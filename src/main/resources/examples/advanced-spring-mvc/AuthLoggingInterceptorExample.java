import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.HandlerInterceptor;

// preHandle returning false stops the chain immediately -- neither the handler
// method nor any later interceptor's preHandle runs. This is the standard place for
// cross-cutting checks (auth, rate limiting) that should reject a request before any
// business logic executes.
class AuthLoggingInterceptorExample implements HandlerInterceptor {

    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String apiKey = request.getHeader("X-Api-Key");
        System.out.println("Checking X-Api-Key: " + apiKey);

        if (apiKey == null) {
            response.setStatus(401);
            System.out.println("-> rejected, handler will NOT run");
            return false;
        }

        System.out.println("-> accepted, handler will run");
        return true;
    }

    // A tiny fake HttpServletRequest/HttpServletResponse, only implementing the two
    // methods this example actually calls -- everything else throws, since a real
    // implementation would need a full servlet container.
    static HttpServletRequest fakeRequest(String apiKeyHeaderValue) {
        return (HttpServletRequest) java.lang.reflect.Proxy.newProxyInstance(
                HttpServletRequest.class.getClassLoader(),
                new Class<?>[]{HttpServletRequest.class},
                (proxy, method, methodArgs) -> {
                    if (method.getName().equals("getHeader")) {
                        return apiKeyHeaderValue;
                    }
                    throw new UnsupportedOperationException(method.getName());
                });
    }

    static HttpServletResponse fakeResponse(int[] statusHolder) {
        return (HttpServletResponse) java.lang.reflect.Proxy.newProxyInstance(
                HttpServletResponse.class.getClassLoader(),
                new Class<?>[]{HttpServletResponse.class},
                (proxy, method, methodArgs) -> {
                    if (method.getName().equals("setStatus")) {
                        statusHolder[0] = (int) methodArgs[0];
                        return null;
                    }
                    throw new UnsupportedOperationException(method.getName());
                });
    }

    public static void main(String[] args) {
        AuthLoggingInterceptorExample interceptor = new AuthLoggingInterceptorExample();

        int[] status = {200};
        boolean allowed = interceptor.preHandle(fakeRequest(null), fakeResponse(status), null);
        System.out.println("allowed=" + allowed + ", status=" + status[0]);
        // Checking X-Api-Key: null
        // -> rejected, handler will NOT run
        // allowed=false, status=401

        boolean allowedWithKey = interceptor.preHandle(fakeRequest("secret-123"), fakeResponse(status), null);
        System.out.println("allowed=" + allowedWithKey);
        // Checking X-Api-Key: secret-123
        // -> accepted, handler will run
        // allowed=true
    }
}
