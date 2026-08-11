import java.util.ArrayList;
import java.util.List;

// With more than one interceptor registered, preHandle runs in REGISTRATION order,
// but postHandle/afterCompletion run in REVERSE order -- the same "wrapping" pattern
// as try-with-resources closing multiple resources, or a stack of middleware. This
// matters when interceptors depend on each other (e.g. one sets a request attribute
// another one reads).
class MultipleInterceptorOrderExample {

    record NamedInterceptor(String name) {
    }

    static void runChain(List<NamedInterceptor> interceptors) {
        List<NamedInterceptor> executedPreHandle = new ArrayList<>();

        for (NamedInterceptor interceptor : interceptors) {
            System.out.println(interceptor.name() + ".preHandle");
            executedPreHandle.add(interceptor);
        }

        System.out.println("(handler runs)");

        // postHandle/afterCompletion only run for interceptors whose preHandle
        // already completed, and in reverse -- this is what makes it safe for
        // AuthInterceptor to assume LoggingInterceptor's preHandle already ran.
        for (int i = executedPreHandle.size() - 1; i >= 0; i--) {
            System.out.println(executedPreHandle.get(i).name() + ".postHandle");
        }
    }

    public static void main(String[] args) {
        runChain(List.of(new NamedInterceptor("AuthInterceptor"), new NamedInterceptor("LoggingInterceptor")));
        // AuthInterceptor.preHandle
        // LoggingInterceptor.preHandle
        // (handler runs)
        // LoggingInterceptor.postHandle
        // AuthInterceptor.postHandle
    }
}
