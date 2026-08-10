interface NotificationSender {
    void send(String message);
}

class EmailSender implements NotificationSender {
    @Override
    public void send(String message) {
        System.out.println("Email sent: " + message);
    }
}

class SmsSender implements NotificationSender {
    @Override
    public void send(String message) {
        System.out.println("SMS sent: " + message);
    }
}

class PushSender implements NotificationSender {
    @Override
    public void send(String message) {
        System.out.println("Push notification sent: " + message);
    }
}

class NotificationService {
    private NotificationSender sender; // composition -- holds a channel, doesn't become one

    NotificationService(NotificationSender sender) {
        this.sender = sender;
    }

    void setSender(NotificationSender sender) {
        this.sender = sender; // channel can be swapped at runtime
    }

    void notifyUser(String message) {
        sender.send(message); // delegates -- doesn't know which channel it's using
    }
}
