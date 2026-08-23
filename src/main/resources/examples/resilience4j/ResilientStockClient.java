import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import io.github.resilience4j.retry.annotation.Retry;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClient;

// Builds directly on the Service Discovery & Eureka lesson's StockClientWithDiscovery
// (see its own file, and the "Calling a Service by Name with a Load-Balanced RestClient"
// section) -- the constructor and the discovery-aware base URL are UNCHANGED. What's NEW
// is the two annotations on checkStock: @CircuitBreaker and @Retry, both referring to
// the "inventoryService" instance configured in Resilience4jConfig.yml. Neither
// annotation touches the METHOD BODY at all -- Resilience4j wraps the call from the
// OUTSIDE, at the proxy level, exactly like @Transactional does (see the Transaction
// Management lesson).
@Component
class ResilientStockClient {

    private final RestClient restClient;

    ResilientStockClient(RestClient.Builder loadBalancedRestClientBuilder) {
        this.restClient = loadBalancedRestClientBuilder.baseUrl("http://inventory-service").build();
    }

    // Retry runs FIRST (innermost) -- Resilience4j retries the call up to
    // resilience4j.retry.instances.inventoryService.max-attempts times BEFORE the
    // circuit breaker ever records a single failure from this call. Only once retries
    // are exhausted does the circuit breaker see "this call failed" and count it toward
    // opening the circuit. If the circuit is ALREADY open, neither the method body nor
    // any retry attempt runs at all -- checkStockFallback is called immediately.
    @CircuitBreaker(name = "inventoryService", fallbackMethod = "checkStockFallback")
    @Retry(name = "inventoryService")
    StockCheckResponse checkStock(String productName) {
        try {
            return restClient.get()
                    .uri("/inventory/{productName}", productName)
                    .retrieve()
                    .body(StockCheckResponse.class);
        } catch (HttpClientErrorException.NotFound e) {
            // Same meaning as in every earlier lesson: inventory-service answered, it
            // just doesn't know this product -- this is NOT a failure Resilience4j
            // should retry or count against the circuit breaker.
            return new StockCheckResponse(productName, 0);
        } catch (ResourceAccessException e) {
            throw new InventoryServiceUnavailableException("inventory-service is not reachable", e);
        }
    }

    // The fallback method's signature MUST match checkStock's (same parameters), plus
    // one extra Throwable parameter at the end -- Resilience4j calls THIS method
    // instead, with the exception that finally triggered it, whenever the circuit is
    // OPEN or every retry attempt has failed. Returning a degraded-but-VALID
    // StockCheckResponse here (instead of letting the exception propagate) is a
    // deliberate choice: order-service can still let the order proceed, treating stock
    // as "unknown, assume none reserved" rather than failing the whole request just
    // because inventory-service is having trouble.
    StockCheckResponse checkStockFallback(String productName, Throwable t) {
        return new StockCheckResponse(productName, 0);
    }
}

// Unchanged from earlier lessons -- what CAN fail about the call didn't change, only
// what order-service now DOES in response (see checkStockFallback above, instead of
// letting this propagate all the way up).
class InventoryServiceUnavailableException extends RuntimeException {
    InventoryServiceUnavailableException(String message, Throwable cause) {
        super(message, cause);
    }
}
