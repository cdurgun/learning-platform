import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

// order-service's OWN security configuration -- see "Why the Gateway Alone
// Isn't Enough: Zero Trust Between Services" for why order-service validates
// the SAME JWT api-gateway already validated, instead of trusting that a
// request reaching it must have already passed the gateway's check. This is
// the SERVLET-based config style (@EnableWebSecurity, HttpSecurity), matching
// order-service's blocking Spring MVC controllers -- unlike
// ApiGatewaySecurityConfig's reactive style, which matches api-gateway's
// WebFlux runtime.
@EnableWebSecurity
class OrderServiceSecurityConfig {

    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
                .authorizeHttpRequests(requests -> requests
                        .requestMatchers("/actuator/health").permitAll()
                        // Creating an order requires the "customer" role --
                        // see "Authorization: Restricting an Endpoint by Role".
                        // Every OTHER authenticated request just needs a valid
                        // JWT, no specific role.
                        .requestMatchers(org.springframework.http.HttpMethod.POST, "/orders")
                        .hasRole("customer")
                        .anyRequest().authenticated())
                .oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt -> {}))
                .build();
    }
}
