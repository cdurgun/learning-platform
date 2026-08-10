import java.util.List;

class NotificationDispatcherDemo {
    public static void main(String[] args) {
        // The composition root: this is the only place that lists the
        // concrete channels by name.
        NotificationDispatcher allChannels = new NotificationDispatcher(
                List.of(new EmailNotificationSender(), new SmsNotificationSender(), new PushNotificationSender()));

        allChannels.dispatch("ayse@example.com", "Your order has shipped.");
        // [email to ayse@example.com] Your order has shipped.
        // [sms to ayse@example.com] Your order has shipped.
        // [push to ayse@example.com] Your order has shipped.

        // A second dispatcher, wired with a different (smaller) list -- same
        // NotificationDispatcher class, no code changes required.
        NotificationDispatcher emailOnly = new NotificationDispatcher(List.of(new EmailNotificationSender()));
        emailOnly.dispatch("mehmet@example.com", "Your order has shipped.");
        // [email to mehmet@example.com] Your order has shipped.
    }
}
