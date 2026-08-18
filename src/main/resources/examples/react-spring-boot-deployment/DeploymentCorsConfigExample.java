import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

// This is what GlobalCorsConfigExample (addCorsMappings) from the Advanced
// Spring MVC lesson looks like when used in a real deployment. allowedOrigin
// is read from a CORS_ALLOWED_ORIGIN environment variable via
// application.properties -- without changing the code at all, it's enough
// to fill in this variable in the Render Dashboard with the real address
// Vercel provides.
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
