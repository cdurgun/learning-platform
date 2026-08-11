import org.springframework.util.AntPathMatcher;

// registry.addInterceptor(...).addPathPatterns(...).excludePathPatterns(...) limits
// which URLs an interceptor actually runs for. Internally, Spring MVC compares each
// incoming path against these Ant-style patterns using AntPathMatcher -- the same
// class this example uses directly, standing in for what
// InterceptorRegistration/MappedInterceptor do for you.
class PathPatternScopingExample {

    // In a real @Configuration class:
    //
    // registry.addInterceptor(new AuthInterceptor())
    //         .addPathPatterns("/topics/**")
    //         .excludePathPatterns("/topics/public/**");

    static boolean shouldRunFor(String path) {
        AntPathMatcher matcher = new AntPathMatcher();
        boolean included = matcher.match("/topics/**", path);
        boolean excluded = matcher.match("/topics/public/**", path);
        return included && !excluded;
    }

    public static void main(String[] args) {
        System.out.println(shouldRunFor("/topics/spring-mvc-fundamentals"));
        // true -- matches the include pattern, not the exclude pattern

        System.out.println(shouldRunFor("/topics/public/announcement"));
        // false -- matches the include pattern too, but the exclude pattern wins

        System.out.println(shouldRunFor("/"));
        // false -- doesn't match the include pattern at all
    }
}
