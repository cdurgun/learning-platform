import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

// The same WebMvcConfigurer that registers interceptors (see "WebMvcConfigurer:
// Interceptor'ı Kaydetmek") also has an addCorsMappings hook -- the global
// alternative to sprinkling @CrossOrigin over every controller method. One
// CorsRegistration per URL pattern, each building the same kind of CorsConfiguration
// CorsPreflightExample constructed by hand.
@Configuration
class GlobalCorsConfigExample implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("https://learning-platform.example.com")
                .allowedMethods("GET", "POST")
                .allowedHeaders("Content-Type")
                .allowCredentials(true)
                .maxAge(3600);
    }

    public static void main(String[] args) {
        System.out.println("addCorsMappings applies to every /api/** endpoint --");
        System.out.println("no per-controller @CrossOrigin needed, and no risk of forgetting one.");
    }
}
