import java.util.List;

// Combines "Constructor Injection" (a required, final dependency) with a
// twist Spring uses constantly: injecting a WHOLE LIST of implementations at
// once, so every registered channel gets used without NotificationDispatcher
// ever naming a single concrete class.
interface NotificationSender {
    void send(String to, String message);
}

class EmailNotificationSender implements NotificationSender {
    @Override
    public void send(String to, String message) {
        System.out.println("[email to " + to + "] " + message);
    }
}

class SmsNotificationSender implements NotificationSender {
    @Override
    public void send(String to, String message) {
        System.out.println("[sms to " + to + "] " + message);
    }
}

class PushNotificationSender implements NotificationSender {
    @Override
    public void send(String to, String message) {
        System.out.println("[push to " + to + "] " + message);
    }
}

class NotificationDispatcher {
    private final List<NotificationSender> senders;

    // Every NotificationSender the caller decides to pass in gets used -- the
    // dispatcher itself has zero knowledge of how many channels exist or what
    // they are called.
    NotificationDispatcher(List<NotificationSender> senders) {
        this.senders = senders;
    }

    void dispatch(String to, String message) {
        for (NotificationSender sender : senders) {
            sender.send(to, message);
        }
    }
}
