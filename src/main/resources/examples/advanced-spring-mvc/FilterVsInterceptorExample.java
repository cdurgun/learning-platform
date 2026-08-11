import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import org.springframework.web.servlet.HandlerInterceptor;

import java.io.IOException;

// Both a Filter and a HandlerInterceptor can run code "around" a request, but they
// belong to two different layers: Filter is part of the Servlet API itself (the
// container calls it, before Spring even enters the picture); HandlerInterceptor is
// a Spring MVC concept (DispatcherServlet calls it, only for requests that reach a
// handler mapping).
class FilterVsInterceptorExample {

    // A Filter sees EVERY request the servlet container receives -- static resources,
    // 404s, anything -- because it sits in front of DispatcherServlet, not inside it.
    static class LoggingFilter implements Filter {
        public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
                throws IOException, ServletException {
            System.out.println("[Filter] before -- runs for ANY request the container handles");
            chain.doFilter(request, response);
            System.out.println("[Filter] after");
        }
    }

    // A HandlerInterceptor only sees requests DispatcherServlet has already matched to
    // a handler -- it never runs for a request that 404s before a handler is found.
    static class LoggingInterceptor implements HandlerInterceptor {
        public boolean preHandle(jakarta.servlet.http.HttpServletRequest request,
                jakarta.servlet.http.HttpServletResponse response, Object handler) {
            System.out.println("[Interceptor] preHandle -- only for requests that matched a @Controller method");
            return true;
        }
    }

    public static void main(String[] args) {
        System.out.println("See 'Bir İsteğin İzlediği Yol: Filter Chain + Interceptor Chain Birlikte'");
        System.out.println("for how these two actually nest around each other in a real request.");
    }
}
