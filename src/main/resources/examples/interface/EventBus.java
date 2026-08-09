import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;

// A functional interface used as an event listener contract. Extending
// Consumer<OrderPlacedEvent> instead of writing a brand-new interface from
// scratch reuses a shape the whole JDK already understands.
@FunctionalInterface
interface OrderPlacedListener extends Consumer<OrderPlacedEvent> {
}

record OrderPlacedEvent(String orderId, double amount) {
}

// A minimal publish/subscribe event bus: subscribers register a listener
// (often just a lambda), and every published event fans out to all of them —
// the core idea behind Spring's ApplicationEventPublisher, scaled down to
// its essence.
class EventBus {
    private final List<OrderPlacedListener> listeners = new ArrayList<>();

    void subscribe(OrderPlacedListener listener) {
        listeners.add(listener);
    }

    void publish(OrderPlacedEvent event) {
        for (OrderPlacedListener listener : listeners) {
            listener.accept(event);
        }
    }
}
