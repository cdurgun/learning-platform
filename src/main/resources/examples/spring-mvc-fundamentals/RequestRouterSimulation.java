import org.springframework.web.bind.annotation.GetMapping;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// A slightly more complete front-controller simulation than
// FrontControllerSimulationExample: this one registers MULTIPLE handler objects (like a
// real app has many @Controller beans) and builds one shared registry across all of
// them -- exactly what DispatcherServlet's HandlerMapping does across every
// @Controller/@RestController bean the container finds.
class HomeHandlers {
    @GetMapping("/")
    public String home() {
        return "Welcome to the store";
    }
}

class CartHandlers {
    @GetMapping("/cart")
    public String cart() {
        return "Your cart is empty";
    }

    @GetMapping("/cart/checkout")
    public String checkout() {
        return "Redirecting to checkout";
    }
}

class RequestRouterSimulation {
    private final Map<String, HandlerEntry> registry = new HashMap<>();

    private record HandlerEntry(Object instance, Method method) {
    }

    // Runs once, across every registered handler -- like component scanning discovering
    // every @Controller and DispatcherServlet indexing its methods at startup.
    void register(Object handler) {
        for (Method method : handler.getClass().getDeclaredMethods()) {
            GetMapping mapping = method.getAnnotation(GetMapping.class);
            if (mapping != null) {
                registry.put(mapping.value()[0], new HandlerEntry(handler, method));
            }
        }
    }

    // Runs on every request -- like DispatcherServlet's dispatch loop.
    String dispatch(String path) {
        HandlerEntry entry = registry.get(path);
        if (entry == null) {
            return "404 Not Found: " + path;
        }
        try {
            return (String) entry.method().invoke(entry.instance());
        } catch (ReflectiveOperationException e) {
            throw new RuntimeException(e);
        }
    }

    List<String> registeredPaths() {
        return List.copyOf(registry.keySet());
    }
}
