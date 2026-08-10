class NotificationSenderDemo {
    public static void main(String[] args) {
        NotificationService service = new NotificationService(new EmailSender());
        service.notifyUser("Your order has shipped"); // Email sent: ...

        service.setSender(new SmsSender()); // swap channel at runtime
        service.notifyUser("Your order has shipped"); // SMS sent: ...

        service.setSender(new PushSender());
        service.notifyUser("Your order has shipped"); // Push notification sent: ...
    }
}
