import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;

import java.util.ArrayList;
import java.util.List;

// OrderService needs AuditLogger to record every order; AuditLogger needs
// OrderService back, to look up how many orders have been placed so far when
// it writes a log line -- a genuine two-way relationship, not just an
// accidental one (compare with "Circular Dependency").
class OrderService {
    private final AuditLogger auditLogger;
    private final List<String> orders = new ArrayList<>();

    OrderService(AuditLogger auditLogger) {
        this.auditLogger = auditLogger;
    }

    void placeOrder(String item) {
        orders.add(item);
        auditLogger.log("Order placed: " + item);
    }

    int orderCount() {
        return orders.size();
    }
}

class AuditLogger {
    private final OrderService orderService;

    AuditLogger(@Lazy OrderService orderService) {
        this.orderService = orderService;
    }

    void log(String message) {
        // orderService.orderCount() is safe to call here: by the time log(...)
        // actually runs, OrderService has long finished being constructed --
        // @Lazy only delayed resolving the REFERENCE, not this later method call.
        System.out.println("[audit #" + orderService.orderCount() + "] " + message);
    }
}

@Configuration
class AppConfig {
    @Bean
    OrderService orderService(AuditLogger auditLogger) {
        return new OrderService(auditLogger);
    }

    @Bean
    AuditLogger auditLogger(OrderService orderService) {
        return new AuditLogger(orderService);
    }
}
