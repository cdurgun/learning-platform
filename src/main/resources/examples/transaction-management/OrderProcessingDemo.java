import org.springframework.context.annotation.AnnotationConfigApplicationContext;

class OrderProcessingDemo {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(OrderProcessingConfig.class);
        Ledger ledger = context.getBean(Ledger.class);
        OrderService orderService = context.getBean(OrderService.class);

        orderService.placeOrder("ORD-10", 250, false);
        // Shipping notification sent for order ORD-10
        System.out.println(ledger.entries());
        // [audit:attempted:ORD-10, order:ORD-10, payment:ORD-10:250]

        try {
            orderService.placeOrder("ORD-11", 90, true);
        } catch (IllegalStateException e) {
            System.out.println("Failed: " + e.getMessage());
        }
        // No "Shipping notification..." line for ORD-11 -- its transaction
        // rolled back before AFTER_COMMIT could ever fire.
        System.out.println(ledger.entries());
        // [audit:attempted:ORD-10, order:ORD-10, payment:ORD-10:250, audit:attempted:ORD-11]
        // -- the audit entry for ORD-11 survives (REQUIRES_NEW, its own
        // transaction), but "order:ORD-11" and "payment:ORD-11:90" are gone.

        context.close();
    }
}
