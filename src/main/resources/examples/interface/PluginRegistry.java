import java.util.HashMap;
import java.util.Map;

// The contract every plugin has to satisfy — the registry below never
// needs to know about a concrete plugin's class, only this interface.
interface NotificationChannel {
    void send(String message);
}

class EmailChannel implements NotificationChannel {
    @Override
    public void send(String message) {
        System.out.println("[email] " + message);
    }
}

class SmsChannel implements NotificationChannel {
    @Override
    public void send(String message) {
        System.out.println("[sms] " + message);
    }
}

// A tiny strategy/plugin registry: new channels can be registered from
// anywhere (even a different package/module) as long as they implement
// NotificationChannel — the registry's code never has to change.
class PluginRegistry {
    private final Map<String, NotificationChannel> channels = new HashMap<>();

    void register(String key, NotificationChannel channel) {
        channels.put(key, channel);
    }

    void broadcast(String message) {
        for (NotificationChannel channel : channels.values()) {
            channel.send(message);
        }
    }

    void sendVia(String key, String message) {
        NotificationChannel channel = channels.get(key);
        if (channel == null) {
            throw new IllegalArgumentException("No channel registered for: " + key);
        }
        channel.send(message);
    }
}
