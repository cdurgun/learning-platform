import org.springframework.http.HttpRequest;
import org.springframework.http.client.ClientHttpRequestExecution;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;

import java.io.IOException;

// The security counterpart of the Observability lesson's
// RestClientCorrelationIdInterceptor -- same shape, different header. Without
// this, order-service's call to inventory-service (see ResilientStockClient in
// the Resilience4j lesson) would carry NO identity at all, and inventory-
// service's own SecurityFilterChain (built the same way as
// OrderServiceSecurityConfig) would have nothing to authenticate -- either the
// call fails outright, or inventory-service has to trust it unconditionally,
// which is exactly the gap "Why the Gateway Alone Isn't Enough" warns against
// one level further down the chain.
//
// Registered on the SAME @LoadBalanced RestClient.Builder bean the Service
// Discovery & Eureka lesson introduced -- adding this interceptor (alongside
// RestClientCorrelationIdInterceptor) doesn't change anything else about how
// the call is made, only which headers travel with it.
class RestClientBearerTokenInterceptor implements ClientHttpRequestInterceptor {

    @Override
    public ClientHttpResponse intercept(HttpRequest request, byte[] body, ClientHttpRequestExecution execution)
            throws IOException {
        // The Jwt Spring Security already validated for THIS incoming request
        // (see OrderServiceSecurityConfig) is available from the security
        // context -- forwarding its original, already-verified token value is
        // simpler and more honest than order-service minting a new one on
        // inventory-service's behalf.
        if (SecurityContextHolder.getContext().getAuthentication() instanceof
                org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken jwtAuth) {
            Jwt jwt = jwtAuth.getToken();
            request.getHeaders().setBearerAuth(jwt.getTokenValue());
        }
        return execution.execute(request, body);
    }
}
