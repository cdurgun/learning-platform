import org.slf4j.MDC;
import org.springframework.http.HttpRequest;
import org.springframework.http.client.ClientHttpRequestExecution;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.http.client.ClientHttpResponse;

import java.io.IOException;

// CorrelationIdMdcFilter puts the correlation id into MDC for order-service's
// OWN logs -- but that alone does NOT make inventory-service see the same id
// when order-service calls it through ResilientStockClient (see the
// Resilience4j lesson). Without this interceptor, inventory-service would
// generate a BRAND NEW correlation id for that request (CorrelationIdMdcFilter
// running there too, finding no incoming header) -- breaking the trace right
// at the service boundary.
//
// Registered on the SAME @LoadBalanced RestClient.Builder bean from the
// Service Discovery & Eureka lesson's LoadBalancedRestClientConfig -- adding
// this interceptor doesn't change anything else about how ResilientStockClient
// calls inventory-service, only what headers go along with the call.
class RestClientCorrelationIdInterceptor implements ClientHttpRequestInterceptor {

    private static final String CORRELATION_ID_HEADER = "X-Correlation-Id";

    @Override
    public ClientHttpResponse intercept(HttpRequest request, byte[] body, ClientHttpRequestExecution execution)
            throws IOException {
        String correlationId = MDC.get("correlationId");
        if (correlationId != null) {
            request.getHeaders().add(CORRELATION_ID_HEADER, correlationId);
        }
        return execution.execute(request, body);
    }
}
