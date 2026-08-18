import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

// This is the ONE change that turns a plain RestClient into a discovery-aware one: a
// RestClient.Builder bean annotated @LoadBalanced. Once this bean exists, ANY RestClient
// built from it can call a service by NAME (e.g. "http://inventory-service") instead of
// a real host and port -- Spring Cloud LoadBalancer intercepts the call, asks the
// DiscoveryClient which instances are registered under that name, and picks one.
//
// Compare this to the plain RestClient.builder() used directly in the Inter-Service
// Communication lesson's StockClient (see its "From order-service to inventory-service:
// A Synchronous Call with RestClient" section) -- the calling code barely changes (see
// StockClientWithDiscovery), but the base URL stops being a real network address and
// becomes a logical service name instead.
@Configuration
class LoadBalancedRestClientConfig {

    @Bean
    @LoadBalanced
    RestClient.Builder loadBalancedRestClientBuilder() {
        return RestClient.builder();
    }
}
