import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.MDC;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.UUID;

// Runs inside order-service (and inventory-service, the same class copied into
// both -- see "Propagating the Correlation Id: Finishing What the Gateway
// Started"). api-gateway's CorrelationIdGatewayFilter (see the API Gateway
// lesson) already assigns an X-Correlation-Id header before a request ever
// reaches order-service -- this filter is what makes THAT id actually usable
// inside order-service's own code: it reads the header and puts it into SLF4J's
// MDC (Mapped Diagnostic Context), a thread-local map every log statement can
// automatically include (see "Structured Logging: Making Logs Machine-
// Readable").
@Component
@WebFilter("/*")
class CorrelationIdMdcFilter implements jakarta.servlet.Filter {

    private static final String CORRELATION_ID_HEADER = "X-Correlation-Id";
    private static final String MDC_KEY = "correlationId";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        // A request that DIDN'T come through api-gateway (a direct call during
        // local development, for instance) won't have this header at all --
        // generating one here means order-service's own logs are still
        // traceable even without the gateway in front of it.
        String correlationId = httpRequest.getHeader(CORRELATION_ID_HEADER);
        if (correlationId == null || correlationId.isBlank()) {
            correlationId = UUID.randomUUID().toString();
        }

        MDC.put(MDC_KEY, correlationId);
        try {
            chain.doFilter(request, response);
        } finally {
            // MDC is thread-local, and this thread will be REUSED for a
            // different request later (a servlet container's thread pool) --
            // forgetting this cleanup would leak one request's correlation id
            // into another request's logs (see "Common Mistakes").
            MDC.remove(MDC_KEY);
        }
    }
}
