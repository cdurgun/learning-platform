import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.UUID;

// A cross-cutting concern that genuinely BELONGS at the gateway (see "Where
// Cross-Cutting Concerns Belong"): every request entering the system gets a
// correlation id -- one shared value that order-service, inventory-service,
// and any future service can log alongside their own messages, making it
// possible to trace ONE external request across MULTIPLE internal services.
// This filter does NOT invent request tracing itself -- it only ensures the
// header exists as early as possible; an upcoming Observability lesson covers
// actually propagating and using it downstream.
@Component
class CorrelationIdGatewayFilter implements GlobalFilter, Ordered {

    private static final String CORRELATION_ID_HEADER = "X-Correlation-Id";

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        if (request.getHeaders().containsKey(CORRELATION_ID_HEADER)) {
            // A caller (or a previous hop) already set one -- keep it AS IS, don't
            // overwrite an id a client may already be tracking.
            return chain.filter(exchange);
        }

        String correlationId = UUID.randomUUID().toString();
        ServerHttpRequest mutatedRequest = request.mutate()
                .header(CORRELATION_ID_HEADER, correlationId)
                .build();

        return chain.filter(exchange.mutate().request(mutatedRequest).build());
    }

    @Override
    public int getOrder() {
        return Ordered.HIGHEST_PRECEDENCE;   // run FIRST -- every later filter
                                              // (including RequestLoggingGlobalFilter)
                                              // and every downstream service should
                                              // see the header already set
    }
}
