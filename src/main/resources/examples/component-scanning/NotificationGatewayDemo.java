import org.springframework.context.annotation.AnnotationConfigApplicationContext;

class NotificationGatewayDemo {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        NotificationGateway gateway = context.getBean(NotificationGateway.class);
        gateway.sendVia("email", "ayse@example.com", "Your order has shipped.");
        // [email to ayse@example.com] Your order has shipped.
        gateway.sendVia("sms", "+90 555 000 00 00", "Your order has shipped.");
        // [sms to +90 555 000 00 00] Your order has shipped.

        try {
            gateway.sendVia("push", "ayse@example.com", "Not registered");
        } catch (IllegalArgumentException e) {
            System.out.println("Failed: " + e.getMessage());
            // Failed: Unknown channel: push
        }

        context.close();
    }
}
