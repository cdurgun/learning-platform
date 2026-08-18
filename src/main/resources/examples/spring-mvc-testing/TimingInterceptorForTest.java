import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.HandlerInterceptor;

// A small, realistic HandlerInterceptor -- it uses the same lifecycle (preHandle/
// postHandle/afterCompletion) as HandlerInterceptorLifecycleExample in the "Advanced
// Spring MVC" lesson, but since the goal here is to test the interceptor on its own,
// it's kept as simple as possible: it adds an X-Response-Time-Ms header to every request.
public class TimingInterceptorForTest implements HandlerInterceptor {

    private static final String START_ATTRIBUTE = "requestStartNanos";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        request.setAttribute(START_ATTRIBUTE, System.nanoTime());
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                                 Object handler, Exception ex) {
        Object startValue = request.getAttribute(START_ATTRIBUTE);
        if (startValue instanceof Long startNanos) {
            long elapsedMs = (System.nanoTime() - startNanos) / 1_000_000;
            response.setHeader("X-Response-Time-Ms", String.valueOf(elapsedMs));
        }
        // Note: adding the header in afterCompletion instead of postHandle is intentional --
        // afterCompletion always runs, EVEN IF the handler throws an exception, whereas
        // postHandle does not (see the "HandlerInterceptor Lifecycle" section in the
        // "Advanced Spring MVC" lesson).
    }
}
