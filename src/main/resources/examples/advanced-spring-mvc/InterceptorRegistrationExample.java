import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

// Implementing a HandlerInterceptor isn't enough by itself -- unlike a @Component
// (which Component Scanning picks up automatically), an interceptor has to be
// registered explicitly. WebMvcConfigurer is the extension point Spring MVC looks
// for at startup; a @Configuration class implementing it can override
// addInterceptors to register any number of interceptors.
@Configuration
class InterceptorRegistrationExample implements WebMvcConfigurer {

    static class SimpleLoggingInterceptor implements HandlerInterceptor {
        public boolean preHandle(jakarta.servlet.http.HttpServletRequest request,
                jakarta.servlet.http.HttpServletResponse response, Object handler) {
            System.out.println("SimpleLoggingInterceptor.preHandle: " + request);
            return true;
        }
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new SimpleLoggingInterceptor());
    }

    public static void main(String[] args) {
        // Without a real ApplicationContext, we can only show that the registration
        // call compiles and reads the way it would in a real @Configuration class --
        // registry.addInterceptor(...) is what DispatcherServlet's HandlerMapping
        // consults at startup to build its interceptor list.
        System.out.println("addInterceptors would register: " + SimpleLoggingInterceptor.class.getSimpleName());
    }
}
