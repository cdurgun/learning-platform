# API Gateway

So far, every call into this course's microservices has come from ANOTHER microservice -- order-service calling inventory-service, first with a hardcoded URL (see the "Inter-Service Communication" lesson), then by name through Eureka (see the "Service Discovery & Eureka" lesson's "Calling a Service by Name with a Load-Balanced RestClient" section). But real systems also have EXTERNAL clients -- a browser, a mobile app -- and those clients don't run inside the Eureka network, don't know service names, and shouldn't need to know that "orders" and "inventory" are even separate applications. This lesson introduces the piece that sits between external clients and the whole microservices system: the API Gateway.

## What Is an API Gateway?

An API Gateway is a SINGLE entry point that sits in front of a set of microservices. An external client sends every request to ONE address (the gateway); the gateway looks at the request and ROUTES it to whichever internal service actually handles it -- order-service, inventory-service, or any service added later. The client never talks to order-service or inventory-service directly, and never needs their real addresses.

## Why Does It Exist?

Without a gateway, an external client would need to know the address of EVERY microservice individually -- and that address list would change every time a service moved, scaled, or was renamed. Worse, without a single entry point, concerns that apply to the WHOLE system (authentication, rate limiting, request logging) would need to be reimplemented inside EVERY service separately. An API Gateway solves both problems at once: ONE address for clients to remember, and ONE place to apply system-wide concerns -- instead of order-service and inventory-service each reinventing the same logic.

## History

Netflix built one of the first widely-used API gateways, Zuul, around 2013, for the same internal infrastructure that produced Eureka (see the Service Discovery & Eureka lesson's "History" section). Zuul 1 was blocking, thread-per-request, built on the older Servlet model. Spring Cloud Gateway, introduced in 2018, is the modern Spring Cloud answer -- built on Spring WebFlux (reactive, non-blocking) from the start, since a gateway sits on the path of EVERY request in the system and benefits the most from handling many concurrent connections without tying up a thread per request. This lesson uses Spring Cloud Gateway.

## Setting Up the Gateway Application

api-gateway is its OWN Spring Boot application -- a fourth one in this course, next to order-service, inventory-service, and eureka-server. It contains no business logic and no database of its own; its only job is receiving requests and forwarding them.

{{ApiGatewayApplication.java}}
{{ApiGatewayConfig.yml}}

> 💡 Tip
> api-gateway is ALSO a Eureka client, for the same reason order-service and inventory-service are -- it needs to resolve service names to real addresses to route requests to them (see "Discovery-Based Routing with lb://" below).

## Route Configuration: Predicates and Filters

A ROUTE is the gateway's core building block -- three things together: a PREDICATE (a condition that decides whether this route applies to an incoming request, most commonly matching on the request path), a URI (where a matching request gets forwarded), and optionally one or more FILTERS (transformations applied to the request or response along the way).

{{GatewayRoutesConfig.yml}}

## Discovery-Based Routing with lb://

Notice the `lb://order-service` URI in the route configuration above -- this is the SAME idea as `@LoadBalanced RestClient` calling `http://inventory-service` in the Service Discovery & Eureka lesson (see its "Calling a Service by Name with a Load-Balanced RestClient" section): `lb://` is not a real protocol, it tells Spring Cloud Gateway to resolve `order-service` through Eureka and load-balance across however many instances are currently registered under that name. The gateway never needs order-service's real host and port hardcoded anywhere.

## Writing a Custom Filter

Built-in filters like `StripPrefix` (used above) cover common cases, but a gateway can also run custom code on every request through a `GlobalFilter`. This is the first REACTIVE code in this course -- Spring Cloud Gateway runs on Spring WebFlux, not the blocking Spring MVC used by order-service and inventory-service's controllers.

{{RequestLoggingGlobalFilter.java}}

> ⚠️ Warning
> A `GlobalFilter`'s `filter(...)` method must return a `Mono<Void>` and must never BLOCK the calling thread (no JDBC calls, no `Thread.sleep`, no blocking I/O) -- Spring WebFlux runs a small, fixed number of threads shared across every concurrent request; blocking even one of them stalls unrelated requests too.

## Where Cross-Cutting Concerns Belong

A gateway is the natural place for concerns that apply to EVERY request, regardless of which service ultimately handles it -- assigning a correlation id, for instance, so one external request can be traced across multiple internal services later.

{{CorrelationIdGatewayFilter.java}}

> 💡 Tip
> This lesson only ASSIGNS the correlation id -- actually propagating it into outgoing calls between order-service and inventory-service, and using it to tie log lines together, is covered by the upcoming Observability lesson.

## What a Gateway Should NOT Do

It's tempting to put business logic in the gateway too, since it already sees every request -- but that pulls business rules OUT of the services that own them and INTO a piece of infrastructure that has no domain knowledge. A gateway should route, and apply concerns that are genuinely about the REQUEST itself (authentication, rate limiting, logging, correlation ids) -- not decide, for example, whether an order is valid. That decision belongs to order-service, exactly as before.

## Best Practices

- **Route by service NAME (`lb://service-name`), never by a hardcoded host:port** -- the same reasoning as `@LoadBalanced RestClient` (see the Service Discovery & Eureka lesson).
- **Keep filters focused on request/response concerns** (logging, correlation ids, headers) -- push anything resembling a business decision back into the owning service.
- **Register api-gateway with Eureka under its own `spring.application.name`** -- even though nothing routes TO the gateway itself through discovery, it keeps it visible in the registry alongside every other service.
- **Order global filters deliberately with `Ordered`** -- a filter that assigns a correlation id needs to run before a filter that logs requests using it.

## Common Mistakes

- **Adding business logic (validation, calculations) directly inside a gateway filter.** That logic belongs in the owning microservice, not in shared infrastructure every request passes through.
- **Writing a `GlobalFilter` that blocks the thread** (a JDBC call, `Thread.sleep`) -- Spring WebFlux's threading model makes this far more damaging than the same mistake in a blocking Spring MVC controller.
- **Hardcoding a downstream service's host:port in a route's `uri`** instead of using `lb://service-name` -- reintroduces exactly the problem Service Discovery was meant to solve.
- **Expecting the gateway to aggregate responses from multiple services into one.** Plain Spring Cloud Gateway routes ONE request to ONE service; combining multiple calls into a single response is a different pattern (often called Backend for Frontend), out of scope for this lesson.

## Summary, Cheat Sheet, and Glossary

An API Gateway is a single entry point external clients talk to instead of individual microservices. Spring Cloud Gateway routes are made of predicates (when a route applies), a URI (where it forwards to, usually `lb://service-name` resolved through Eureka), and filters (transformations along the way) -- both built-in filters like `StripPrefix` and custom `GlobalFilter`s, which run on Spring WebFlux and must never block. The gateway is the right place for request-level, system-wide concerns (correlation ids, logging) -- never for business logic, which stays in the service that owns it.

Quick reference:

```java
@SpringBootApplication
public class ApiGatewayApplication { ... }   // its own Spring Boot app, no
                                              // business logic of its own

// application.yml
// spring.cloud.gateway.routes:
//   - id: orders-route
//     uri: lb://order-service               // service NAME, resolved via Eureka
//     predicates:
//       - Path=/orders/**
//     filters:
//       - StripPrefix=0

@Component
class SomeGlobalFilter implements GlobalFilter, Ordered {
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        return chain.filter(exchange);       // forwards the request onward
    }
}
```

**Glossary**

**API Gateway** — A single entry point that routes external requests to the correct internal microservice.

**Route** — A gateway's core building block: a predicate, a destination URI, and optional filters.

**Predicate** — A condition (most commonly a path pattern) that decides whether a route applies to an incoming request.

**GlobalFilter** — Custom code that runs on every request passing through the gateway, written reactively on Spring WebFlux.

**`lb://`** — A pseudo-protocol telling Spring Cloud Gateway to resolve a service name through Eureka and load-balance across its instances, instead of using a fixed address.
