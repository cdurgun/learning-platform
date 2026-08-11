import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

// Fundamentals' RequestRouterSimulation registered multiple handlers but could only
// key by path. This version keys by (path, HTTP method) across MULTIPLE handler
// classes -- the closest our hand-rolled simulations get to real Spring routing.
class ArticleApiHandlers {
    @GetMapping("/articles")
    public String list() {
        return "Listing articles";
    }

    @PostMapping("/articles")
    public String create() {
        return "Creating an article";
    }
}

class CommentApiHandlers {
    @GetMapping("/comments")
    public String list() {
        return "Listing comments";
    }

    @DeleteMapping("/comments")
    public String deleteAll() {
        return "Deleting all comments";
    }
}

class RouterWithMethodSimulation {
    private final Map<RouteKey, HandlerEntry> registry = new HashMap<>();

    private record RouteKey(String path, RequestMethod method) {
    }

    private record HandlerEntry(Object instance, Method method) {
    }

    void register(Object handler) {
        for (Method method : handler.getClass().getDeclaredMethods()) {
            GetMapping get = method.getAnnotation(GetMapping.class);
            if (get != null) {
                registry.put(new RouteKey(get.value()[0], RequestMethod.GET), new HandlerEntry(handler, method));
            }
            PostMapping post = method.getAnnotation(PostMapping.class);
            if (post != null) {
                registry.put(new RouteKey(post.value()[0], RequestMethod.POST), new HandlerEntry(handler, method));
            }
            DeleteMapping delete = method.getAnnotation(DeleteMapping.class);
            if (delete != null) {
                registry.put(new RouteKey(delete.value()[0], RequestMethod.DELETE), new HandlerEntry(handler, method));
            }
        }
    }

    String dispatch(String path, RequestMethod httpMethod) {
        HandlerEntry entry = registry.get(new RouteKey(path, httpMethod));
        if (entry == null) {
            return "405 Method Not Allowed: " + httpMethod + " " + path;
        }
        try {
            return (String) entry.method().invoke(entry.instance());
        } catch (ReflectiveOperationException e) {
            throw new RuntimeException(e);
        }
    }
}
