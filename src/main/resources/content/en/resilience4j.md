# Resilience4j

The Inter-Service Communication lesson already taught order-service to tell a 404 apart from a connection failure when calling inventory-service, and to translate the latter into an `InventoryServiceUnavailableException` (see its "The Network Is Unreliable: What If inventory-service Is Down?" section). That's honest error handling -- but it has a gap: if inventory-service is down for even a FEW seconds, EVERY single order-service request that needs stock data fails immediately and identically, and order-service keeps hammering a service that's clearly struggling. This lesson introduces the library that fixes both problems: Resilience4j.

## What Is Resilience4j?

Resilience4j is a lightweight Java library that wraps a risky call -- a call to another service, most often -- with one or more PROTECTIVE behaviors: a circuit breaker (stop calling a service that's clearly failing), a retry (try again before giving up), a rate limiter (cap how often a call is allowed to happen), and a bulkhead (cap how many calls can be IN FLIGHT at once). Each behavior is applied with an annotation on a method -- the method's own code stays focused on what it actually does, not on how to survive failure.

## Why Does It Exist?

Catching `ResourceAccessException` and throwing `InventoryServiceUnavailableException` (as StockClientWithDiscovery already does) is necessary but not SUFFICIENT. Two real problems remain: first, if inventory-service is down, order-service keeps trying every single request, wasting time waiting for connections that will fail anyway, and adding load to a service that's already struggling to recover. Second, a single flaky network blip shouldn't fail a request outright if trying ONE more time would likely succeed. Handling both well by hand -- tracking failure counts, deciding when to stop calling, retrying with the right pauses -- is exactly the kind of infrastructure code that's easy to get subtly wrong. Resilience4j provides it as configuration instead.

## History

Resilience4j was created in 2016, explicitly as a REPLACEMENT for Netflix Hystrix (Netflix's own circuit breaker library, part of the same era as Zuul and Eureka -- see the Service Discovery & Eureka and API Gateway lessons' "History" sections). Hystrix was put into maintenance mode by Netflix in 2018, the same general period Netflix stepped back from several of its open-source infrastructure tools. Resilience4j was designed from the start to be lighter weight (built for Java 8+ functional style, no dependency on RxJava like Hystrix had) and modular -- a project can depend on just the circuit breaker module, just retry, or any combination, instead of one large library.

## Adding Resilience4j to order-service

Resilience4j integrates with Spring Boot through the `resilience4j-spring-boot3` starter and annotation-driven configuration in `application.yml` -- no separate server or infrastructure piece is needed, unlike Eureka Server or api-gateway; every protective behavior runs INSIDE order-service itself.

{{Resilience4jConfig.yml}}

> 💡 Tip
> The instance name (`inventoryService` above) is a name Resilience4j uses INTERNALLY to group configuration -- it doesn't have to match the Eureka service name (`inventory-service`) at all, though picking a related name keeps things easy to follow.

## Circuit Breaker: States and Configuration

A circuit breaker has three states. CLOSED is the normal state -- calls go through, and failures are counted. If the failure rate crosses a configured threshold, the circuit trips to OPEN -- every call fails IMMEDIATELY, without even attempting the real call, for a configured wait duration. After that wait, the circuit moves to HALF_OPEN, where a small number of TEST calls are allowed through -- if they succeed, the circuit closes again; if they fail, it reopens.

## Wrapping StockClient with a Circuit Breaker

The `@CircuitBreaker` annotation applies this state machine to a single method -- no change to the method's own logic is needed, only its signature and a fallback method.

{{ResilientStockClient.java}}
{{StockCheckResponse.java}}

> ⚠️ Warning
> `@CircuitBreaker` only works through Spring's PROXY mechanism, exactly like `@Transactional` (see the Transaction Management lesson) -- calling `checkStock` from ANOTHER method on the SAME class (`this.checkStock(...)`) bypasses the proxy entirely, and neither the circuit breaker nor the retry would ever run.

## Fallback Methods: What Happens When the Circuit Opens?

A fallback method is what runs INSTEAD of the real method, whenever the circuit is open or every retry attempt has failed -- its signature must match the original method's parameters, plus one extra `Throwable` at the end. `checkStockFallback` above returns a degraded-but-valid `StockCheckResponse` rather than letting the exception propagate -- a deliberate choice to let order processing continue with "assume no stock reserved" instead of failing the whole request outright.

## Retry: Trying Again Before Giving Up

`@Retry`, also visible on `checkStock` above, retries a failed call a configured number of times, with a pause between attempts, BEFORE the circuit breaker records a failure at all. This matters for genuinely transient problems -- a single dropped packet, a brief network blip -- where trying again immediately would likely succeed, and giving up on the very first failure would be premature.

> 💡 Tip
> Retry and circuit breaker are not competing choices -- they answer different questions. Retry asks "is this ONE failure worth trying again?"; the circuit breaker asks "has this service been failing SO consistently that it's not even worth trying?" Applying both to the same call (as `ResilientStockClient` does) is a common, sensible combination.

## Rate Limiter and Bulkhead: Two More Guards

A circuit breaker and retry both react to FAILURES. A rate limiter and a bulkhead guard against a different risk entirely: order-service overwhelming inventory-service (or itself) even when everything is HEALTHY. A rate limiter caps how many calls are allowed in a time window; a bulkhead caps how many calls can be IN FLIGHT at the same time -- both borrow their names from real-world safety mechanisms (an electrical rate limiter, a ship's bulkhead compartments preventing one flooded section from sinking the whole vessel).

{{RateLimiterAndBulkheadConfig.yml}}

{{CircuitBreakerEventListener.java}}

## Best Practices

- **Apply `@Retry` and `@CircuitBreaker` TOGETHER on calls that can genuinely fail transiently** -- retry handles the brief blip, the circuit breaker handles sustained failure, and each answers a question the other doesn't.
- **Always provide a fallback that makes sense for the CALLER**, not just a generic error -- `checkStockFallback`'s "assume no stock reserved" lets order-service's larger flow continue, rather than failing outright.
- **Give circuit breaker/retry instances names that map cleanly to what they protect** -- `inventoryService` here, not a generic name shared across unrelated calls.
- **Log state transitions (or expose them as metrics)** during development, exactly like `CircuitBreakerEventListener` -- an OPEN circuit that fails silently is hard to diagnose.

## Common Mistakes

- **Calling an `@CircuitBreaker`/`@Retry`-annotated method from another method in the SAME class.** This bypasses Spring's proxy entirely -- neither annotation has any effect (see the warning above).
- **Writing a fallback method with a mismatched signature.** It must accept the same parameters as the original method plus a trailing `Throwable`, or Resilience4j can't wire it up.
- **Setting `wait-duration-in-open-state` far too short.** The circuit reopens the test call to a service that likely hasn't recovered yet, defeating the point of giving it breathing room.
- **Using a bulkhead or rate limiter as a substitute for a circuit breaker.** They protect against DIFFERENT risks (overload vs. sustained failure) -- a service that's genuinely down still needs a circuit breaker, no amount of concurrency limiting fixes that.

## Summary, Cheat Sheet, and Glossary

Resilience4j wraps a risky call with protective behaviors applied through annotations: `@CircuitBreaker` stops calling a service that's failing consistently (CLOSED -> OPEN -> HALF_OPEN -> CLOSED), `@Retry` tries a transiently-failed call again before giving up, and rate limiters/bulkheads guard against overload even when a service is healthy. A fallback method runs instead of the real one whenever the circuit is open or retries are exhausted -- its signature must match plus a trailing `Throwable`. All of this only works through Spring's proxy mechanism, so self-invocation within the same class bypasses it entirely.

Quick reference:

```java
@CircuitBreaker(name = "inventoryService", fallbackMethod = "checkStockFallback")
@Retry(name = "inventoryService")
StockCheckResponse checkStock(String productName) { ... }

StockCheckResponse checkStockFallback(String productName, Throwable t) {
    return new StockCheckResponse(productName, 0);   // degraded but valid response
}

// application.yml
// resilience4j.circuitbreaker.instances.inventoryService.failure-rate-threshold: 50
// resilience4j.retry.instances.inventoryService.max-attempts: 3
```

**Glossary**

**Circuit Breaker** — A guard that stops calling a consistently-failing service, cycling through CLOSED, OPEN, and HALF_OPEN states.

**Retry** — A guard that automatically tries a failed call again a configured number of times before giving up.

**Rate Limiter** — A guard that caps how many calls are allowed within a time window, regardless of success or failure.

**Bulkhead** — A guard that caps how many calls to a dependency can be in flight at the same time.

**Fallback Method** — The method Resilience4j calls instead of the real one, whenever a circuit is open or retries are exhausted.
