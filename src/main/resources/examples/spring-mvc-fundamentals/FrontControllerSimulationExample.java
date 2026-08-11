import org.springframework.web.bind.annotation.GetMapping;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

// A hand-rolled, drastically simplified stand-in for what DispatcherServlet does at
// startup and on every request. Real Spring builds a much richer HandlerMapping (path
// variables, HTTP method matching, content negotiation...), but the core idea is the
// same: scan for @GetMapping-annotated methods, remember which path maps to which
// method, then invoke the right one when a request comes in.
class ProductPageHandlers {

    @GetMapping("/products")
    public String listProducts() {
        return "Showing all products";
    }

    @GetMapping("/products/featured")
    public String featuredProducts() {
        return "Showing featured products";
    }
}

class FrontControllerSimulationExample {

    // Stands in for DispatcherServlet's HandlerMapping: builds a path -> method registry
    // by reading @GetMapping off every method of the handler object.
    static Map<String, Method> buildHandlerMapping(Object handler) {
        Map<String, Method> mapping = new HashMap<>();
        for (Method method : handler.getClass().getDeclaredMethods()) {
            GetMapping annotation = method.getAnnotation(GetMapping.class);
            if (annotation != null) {
                mapping.put(annotation.value()[0], method);
            }
        }
        return mapping;
    }

    // Stands in for DispatcherServlet's dispatch loop: given an incoming path, find the
    // matching method (HandlerMapping's job) and invoke it (HandlerAdapter's job).
    static String dispatch(String path, Object handler, Map<String, Method> mapping) throws Exception {
        Method method = mapping.get(path);
        if (method == null) {
            return "404 Not Found: " + path;
        }
        return (String) method.invoke(handler);
    }

    public static void main(String[] args) throws Exception {
        ProductPageHandlers handler = new ProductPageHandlers();
        Map<String, Method> handlerMapping = buildHandlerMapping(handler);

        System.out.println(dispatch("/products", handler, handlerMapping));
        // Showing all products
        System.out.println(dispatch("/products/featured", handler, handlerMapping));
        // Showing featured products
        System.out.println(dispatch("/products/unknown", handler, handlerMapping));
        // 404 Not Found: /products/unknown
    }
}
