import java.util.List;

// Filters wrap the ENTIRE DispatcherServlet call -- including view rendering.
// Interceptors only wrap the handler method call, and afterCompletion runs once the
// view has already been rendered, but still before the filter's "after" code, because
// the filter is still the outermost layer. This simulates that nesting order with
// plain method calls, no real Filter/HandlerInterceptor interfaces involved.
class RequestPipelineSimulationExample {

    static void filter(Runnable next) {
        System.out.println("1. Filter -- before (runs for every request the container sees)");
        next.run();
        System.out.println("6. Filter -- after");
    }

    static void interceptorChain(List<String> interceptorNames, Runnable handler) {
        for (String name : interceptorNames) {
            System.out.println("2. " + name + ".preHandle");
        }
        System.out.println("3. Handler method runs");
        handler.run();
        for (int i = interceptorNames.size() - 1; i >= 0; i--) {
            System.out.println("4. " + interceptorNames.get(i) + ".postHandle (reverse order)");
        }
        System.out.println("5. View rendered, then afterCompletion for each interceptor (reverse order)");
    }

    public static void main(String[] args) {
        List<String> interceptors = List.of("AuthInterceptor", "LoggingInterceptor");

        filter(() -> interceptorChain(interceptors, () -> System.out.println("   (view built from Model)")));
        // 1. Filter -- before (runs for every request the container sees)
        // 2. AuthInterceptor.preHandle
        // 2. LoggingInterceptor.preHandle
        // 3. Handler method runs
        //    (view built from Model)
        // 4. LoggingInterceptor.postHandle (reverse order)
        // 4. AuthInterceptor.postHandle (reverse order)
        // 5. View rendered, then afterCompletion for each interceptor (reverse order)
        // 6. Filter -- after
    }
}
