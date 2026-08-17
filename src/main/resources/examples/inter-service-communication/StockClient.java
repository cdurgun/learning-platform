import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClient;

// order-service's ONLY window into inventory-service -- everything OrderService needs to
// know about stock goes through this one method. The base URL is read from application.yml
// via @Value (see the Autoconfiguration & Properties lesson's "Injecting a Single Property
// with @Value" section) instead of being hardcoded, for the same "Config" reason
// order-service's own database URL isn't hardcoded (see Spring Boot Microservice Basics'
// "History" section).
@Component
class StockClient {

    private final RestClient restClient;

    StockClient(@Value("${services.inventory-service.url}") String inventoryServiceUrl) {
        this.restClient = RestClient.builder().baseUrl(inventoryServiceUrl).build();
    }

    StockCheckResponse checkStock(String productName) {
        try {
            return restClient.get()
                    .uri("/inventory/{productName}", productName)
                    .retrieve()
                    .body(StockCheckResponse.class);
        } catch (HttpClientErrorException.NotFound e) {
            // inventory-service is UP and answered -- it just doesn't know this product.
            // A well-formed "no" is not a failure, so this does NOT become an exception.
            return new StockCheckResponse(productName, 0);
        } catch (ResourceAccessException e) {
            // inventory-service never answered at all (timeout, connection refused, DNS
            // failure) -- a completely different kind of problem than the 404 above, and
            // one order-service's own code needs to be able to tell apart from it.
            throw new InventoryServiceUnavailableException("inventory-service is not reachable", e);
        }
    }
}

// A deliberate, meaningful exception -- not the raw ResourceAccessException RestClient
// throws. Catching that at the boundary (see StockClient.checkStock above) and translating
// it into something order-service's own code can reason about keeps inventory-service's
// failure mode from leaking, unexplained, into order-service.
class InventoryServiceUnavailableException extends RuntimeException {
    InventoryServiceUnavailableException(String message, Throwable cause) {
        super(message, cause);
    }
}
