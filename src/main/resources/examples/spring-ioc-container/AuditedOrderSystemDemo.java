import org.springframework.context.annotation.AnnotationConfigApplicationContext;

class AuditedOrderSystemDemo {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        System.out.println("Context started -- circular dependency resolved via @Lazy.");
        // Context started -- circular dependency resolved via @Lazy.

        OrderService orderService = context.getBean(OrderService.class);
        orderService.placeOrder("Java 21 Book");
        // [audit #1] Order placed: Java 21 Book
        orderService.placeOrder("Spring Boot Book");
        // [audit #2] Order placed: Spring Boot Book

        context.close();
    }
}
