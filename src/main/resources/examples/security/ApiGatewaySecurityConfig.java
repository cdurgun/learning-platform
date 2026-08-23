import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.web.server.SecurityWebFilterChain;

// api-gateway's FIRST security configuration -- this course has used no Spring
// Security anywhere until now (the AI ingestion endpoint in the quiz feature
// used a hand-written X-Api-Key check specifically BECAUSE Spring Security
// wasn't already a dependency, see that feature's own design notes). Spring
// Cloud Gateway runs on WebFlux (see the API Gateway lesson), so this uses the
// REACTIVE security config style (@EnableWebFluxSecurity, ServerHttpSecurity),
// not the servlet-based style order-service uses in OrderServiceSecurityConfig.
@EnableWebFluxSecurity
class ApiGatewaySecurityConfig {

    @Bean
    SecurityWebFilterChain securityFilterChain(ServerHttpSecurity http) {
        return http
                .authorizeExchange(exchanges -> exchanges
                        .pathMatchers("/actuator/health").permitAll()   // health
                                                                          // checks stay
                                                                          // public --
                                                                          // load
                                                                          // balancers
                                                                          // need to
                                                                          // reach them
                                                                          // unauthenticated
                        .anyExchange().authenticated())
                // oauth2ResourceServer + jwt() tells Spring Security that a valid
                // request carries a JWT in its Authorization header, and how to
                // VERIFY it (see ApiGatewayJwtConfig.yml for where the verification
                // key comes from) -- see "JWT: A Self-Contained, Verifiable Identity".
                .oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt -> {}))
                .build();
    }
}
