import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.lang.reflect.Proxy;
import java.util.HashMap;
import java.util.Map;

// Mini project, part 2/2: drives RequestLoggingInterceptorExample through a
// successful request and a failing one, using a tiny reflection-based fake
// HttpServletRequest (same technique as AuthLoggingInterceptorExample) that actually
// backs setAttribute/getAttribute with a real Map, since the interceptor depends on
// that round-trip.
class RequestLoggingInterceptorDemo {

    static HttpServletRequest fakeRequest(String uri) {
        Map<String, Object> attributes = new HashMap<>();
        return (HttpServletRequest) Proxy.newProxyInstance(
                HttpServletRequest.class.getClassLoader(),
                new Class<?>[]{HttpServletRequest.class},
                (proxy, method, methodArgs) -> switch (method.getName()) {
                    case "setAttribute" -> {
                        attributes.put((String) methodArgs[0], methodArgs[1]);
                        yield null;
                    }
                    case "getAttribute" -> attributes.get((String) methodArgs[0]);
                    case "getRequestURI" -> uri;
                    default -> throw new UnsupportedOperationException(method.getName());
                });
    }

    public static void main(String[] args) throws InterruptedException {
        RequestLoggingInterceptorExample interceptor = new RequestLoggingInterceptorExample();
        HttpServletResponse fakeResponse = (HttpServletResponse) Proxy.newProxyInstance(
                HttpServletResponse.class.getClassLoader(),
                new Class<?>[]{HttpServletResponse.class},
                (proxy, method, methodArgs) -> {
                    throw new UnsupportedOperationException(method.getName());
                });

        HttpServletRequest okRequest = fakeRequest("/topics/advanced-spring-mvc");
        interceptor.preHandle(okRequest, fakeResponse, null);
        Thread.sleep(5);
        interceptor.afterCompletion(okRequest, fakeResponse, null, null);
        // /topics/advanced-spring-mvc -> OK in Xms

        HttpServletRequest failingRequest = fakeRequest("/topics/does-not-exist");
        interceptor.preHandle(failingRequest, fakeResponse, null);
        interceptor.afterCompletion(failingRequest, fakeResponse, null,
                new IllegalStateException("Topic not found"));
        // /topics/does-not-exist -> FAILED (IllegalStateException) in Xms
    }
}
