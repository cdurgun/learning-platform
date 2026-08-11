import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

// The Fundamentals lesson's FrontControllerSimulationExample only kept a
// path -> method registry -- it couldn't tell a GET handler apart from a POST handler
// on the same path. This version adds the HTTP method into the registry key, exactly
// what real Spring's HandlerMapping does.
class ArticleHandlers {
    @GetMapping("/article")
    public String view() {
        return "Viewing article";
    }

    @PostMapping("/article")
    public String publish() {
        return "Publishing article";
    }
}

class HttpMethodDisambiguationExample {

    private record RouteKey(String path, RequestMethod method) {
    }

    static Map<RouteKey, Method> buildRegistry(Object handler) {
        Map<RouteKey, Method> registry = new HashMap<>();
        for (Method method : handler.getClass().getDeclaredMethods()) {
            GetMapping get = method.getAnnotation(GetMapping.class);
            if (get != null) {
                registry.put(new RouteKey(get.value()[0], RequestMethod.GET), method);
            }
            PostMapping post = method.getAnnotation(PostMapping.class);
            if (post != null) {
                registry.put(new RouteKey(post.value()[0], RequestMethod.POST), method);
            }
        }
        return registry;
    }

    static String dispatch(String path, RequestMethod httpMethod, Object handler, Map<RouteKey, Method> registry) throws Exception {
        Method method = registry.get(new RouteKey(path, httpMethod));
        if (method == null) {
            return "405 Method Not Allowed: " + httpMethod + " " + path;
        }
        return (String) method.invoke(handler);
    }

    public static void main(String[] args) throws Exception {
        ArticleHandlers handler = new ArticleHandlers();
        Map<RouteKey, Method> registry = buildRegistry(handler);

        System.out.println(dispatch("/article", RequestMethod.GET, handler, registry));
        // Viewing article
        System.out.println(dispatch("/article", RequestMethod.POST, handler, registry));
        // Publishing article
        System.out.println(dispatch("/article", RequestMethod.DELETE, handler, registry));
        // 405 Method Not Allowed: DELETE /article
    }
}
