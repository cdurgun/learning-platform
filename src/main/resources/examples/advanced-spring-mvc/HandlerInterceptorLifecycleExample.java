import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

// HandlerInterceptor has three callback points, all default methods (so you only
// override the ones you need). DispatcherServlet calls them at three different
// moments around the actual handler method call.
class HandlerInterceptorLifecycleExample implements HandlerInterceptor {

    public boolean preHandle(jakarta.servlet.http.HttpServletRequest request,
            jakarta.servlet.http.HttpServletResponse response, Object handler) {
        // Runs BEFORE the handler method. Returning false stops the chain right here --
        // the handler method (and postHandle) never run at all.
        System.out.println("1. preHandle");
        return true;
    }

    public void postHandle(jakarta.servlet.http.HttpServletRequest request,
            jakarta.servlet.http.HttpServletResponse response, Object handler, ModelAndView modelAndView) {
        // Runs AFTER the handler method, but only if preHandle returned true AND the
        // handler didn't throw. Still has access to the ModelAndView -- can still
        // change what gets rendered.
        System.out.println("2. handler method runs here (between preHandle and postHandle)");
        System.out.println("3. postHandle");
    }

    public void afterCompletion(jakarta.servlet.http.HttpServletRequest request,
            jakarta.servlet.http.HttpServletResponse response, Object handler, Exception ex) {
        // Runs after the view has been rendered (or an exception occurred) -- the
        // last callback, good for cleanup/logging regardless of success or failure.
        System.out.println("4. afterCompletion" + (ex != null ? " (exception: " + ex + ")" : ""));
    }

    public static void main(String[] args) throws Exception {
        HandlerInterceptorLifecycleExample interceptor = new HandlerInterceptorLifecycleExample();

        // Simulating exactly what DispatcherServlet does around a successful request:
        boolean proceed = interceptor.preHandle(null, null, null);
        if (proceed) {
            interceptor.postHandle(null, null, null, null);
        }
        interceptor.afterCompletion(null, null, null, null);
        // 1. preHandle
        // 2. handler method runs here (between preHandle and postHandle)
        // 3. postHandle
        // 4. afterCompletion
    }
}
