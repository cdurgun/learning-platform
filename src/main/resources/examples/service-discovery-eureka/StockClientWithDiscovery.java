import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClient;
import org.springframework.stereotype.Component;

// The Eureka-aware rewrite of the Inter-Service Communication lesson's StockClient (see
// its "From order-service to inventory-service: A Synchronous Call with RestClient"
// section). Two things changed, and only two: the constructor now takes the
// @LoadBalanced RestClient.Builder (see LoadBalancedRestClientConfig) instead of reading
// a URL from @Value, and the base URL is now the service NAME ("http://inventory-service"),
// not a real host:port. Every other line -- the 404-vs-connection-failure distinction, the
// InventoryServiceUnavailableException translation -- stays EXACTLY the same, because that
// logic was never about WHERE inventory-service lives, only about HOW to react to what it
// says.
@Component
class StockClientWithDiscovery {

    private final RestClient restClient;

    StockClientWithDiscovery(RestClient.Builder loadBalancedRestClientBuilder) {
        // "inventory-service" here is NOT a hostname the JVM can resolve on its own --
        // Spring Cloud LoadBalancer intercepts it and substitutes a real host:port that
        // DiscoveryClient currently has registered for that name. If inventory-service
        // scales to three instances, this ONE line of code does not change at all.
        this.restClient = loadBalancedRestClientBuilder.baseUrl("http://inventory-service").build();
    }

    StockCheckResponse checkStock(String productName) {
        try {
            return restClient.get()
                    .uri("/inventory/{productName}", productName)
                    .retrieve()
                    .body(StockCheckResponse.class);
        } catch (HttpClientErrorException.NotFound e) {
            // Same meaning as before: inventory-service answered, it just doesn't know
            // this product.
            return new StockCheckResponse(productName, 0);
        } catch (ResourceAccessException e) {
            // Same meaning as before too -- but now this ALSO covers the case where
            // Eureka has NO instances registered for "inventory-service" at all (the
            // load balancer has nothing to route to), not just a single unreachable
            // host.
            throw new InventoryServiceUnavailableException("inventory-service is not reachable", e);
        }
    }
}

// Unchanged from the Inter-Service Communication lesson -- what CAN fail about a service
// call didn't change just because we now look the service up by name.
class InventoryServiceUnavailableException extends RuntimeException {
    InventoryServiceUnavailableException(String message, Throwable cause) {
        super(message, cause);
    }
}
