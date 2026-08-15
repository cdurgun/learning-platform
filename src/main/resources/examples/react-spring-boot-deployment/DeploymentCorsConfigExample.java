import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

// Advanced Spring MVC dersindeki GlobalCorsConfigExample'ın (addCorsMappings)
// gerçek bir deploy'da kullanılmış hali. allowedOrigin, application.properties
// üzerinden bir CORS_ALLOWED_ORIGIN ortam değişkeninden okunuyor -- kod hiç
// değişmeden, Render Dashboard'ındaki bu değişkeni Vercel'in verdiği gerçek
// adresle doldurmak yeterli.
@Configuration
class DeploymentCorsConfigExample implements WebMvcConfigurer {

    @Value("${app.cors.allowed-origin}")
    private String allowedOrigin;

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins(allowedOrigin, "http://localhost:5173")
                .allowedMethods("GET");
    }
}
