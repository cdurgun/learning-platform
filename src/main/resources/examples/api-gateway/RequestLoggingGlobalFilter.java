import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

// Spring Cloud Gateway is built on Spring WebFlux (reactive), NOT the same
// blocking Spring MVC used by order-service/inventory-service's controllers --
// this is the FIRST reactive code in this course. A GlobalFilter runs for
// EVERY route, unlike a filter attached to one specific route (see
// GatewayRoutesConfig.yml's per-route "filters:" list) -- implementing
// Ordered lets several global filters run in a defined sequence.
//
// The chain.filter(exchange) call is what actually forwards the request
// toward its destination (order-service or inventory-service, picked by the
// matching route) -- code BEFORE that call runs before forwarding, code
// inside .then(...) runs AFTER the downstream response comes back. Nothing
// here blocks a thread waiting for that response, unlike a plain
// @RestController method.
@Component
class RequestLoggingGlobalFilter implements GlobalFilter, Ordered {

    private static final Logger log = LoggerFactory.getLogger(RequestLoggingGlobalFilter.class);

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        long startedAt = System.currentTimeMillis();
        String method = exchange.getRequest().getMethod().name();
        String path = exchange.getRequest().getPath().value();

        return chain.filter(exchange)
                .then(Mono.fromRunnable(() -> {
                    long tookMillis = System.currentTimeMillis() - startedAt;
                    int status = exchange.getResponse().getStatusCode() != null
                            ? exchange.getResponse().getStatusCode().value()
                            : 0;
                    log.info("{} {} -> {} ({} ms)", method, path, status, tookMillis);
                }));
    }

    @Override
    public int getOrder() {
        return Ordered.LOWEST_PRECEDENCE;   // run last among global filters --
                                             // logs the FINAL outcome, after any
                                             // other filter has already run
    }
}
