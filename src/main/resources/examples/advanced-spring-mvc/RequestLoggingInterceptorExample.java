import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.HandlerInterceptor;

// Mini project, part 1/2: a small but realistic request-timing interceptor -- starts
// a timer in preHandle, logs the elapsed time in afterCompletion. Using
// afterCompletion (not postHandle) matters here: it still runs even if the handler
// threw an exception, so a slow-then-failing request is still logged.
class RequestLoggingInterceptorExample implements HandlerInterceptor {

    private static final String START_TIME_ATTRIBUTE = "requestStartTime";

    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        request.setAttribute(START_TIME_ATTRIBUTE, System.currentTimeMillis());
        return true;
    }

    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler,
            Exception ex) {
        long startTime = (long) request.getAttribute(START_TIME_ATTRIBUTE);
        long elapsedMs = System.currentTimeMillis() - startTime;

        String outcome = ex == null ? "OK" : "FAILED (" + ex.getClass().getSimpleName() + ")";
        System.out.println(request.getRequestURI() + " -> " + outcome + " in " + elapsedMs + "ms");
    }
}
