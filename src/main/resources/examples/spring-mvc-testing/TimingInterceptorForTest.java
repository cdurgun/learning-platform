import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.HandlerInterceptor;

// Küçük, gerçekçi bir HandlerInterceptor -- "Advanced Spring MVC" dersindeki
// HandlerInterceptorLifecycleExample ile aynı yaşam döngüsünü (preHandle/postHandle/
// afterCompletion) kullanır, ama burada amaç interceptor'ı kendi başına test etmek
// olduğu için mümkün olduğunca sade tutuldu: her istekte X-Response-Time-Ms header'ı
// ekler.
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
        // Not: header'ı postHandle yerine afterCompletion'da eklemek kasıtlı -- afterCompletion
        // handler bir exception fırlatsa BİLE her zaman çalışır, postHandle ise çalışmaz
        // (bkz. "Advanced Spring MVC" dersindeki "HandlerInterceptor Yaşam Döngüsü" bölümü).
    }
}
