import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

// DiscoveryClient is the LOW-LEVEL way to ask the registry a question directly: "which
// instances are currently registered under this service name?" Spring Boot autoconfigures
// a DiscoveryClient bean automatically once eureka.client dependencies are on the
// classpath -- nothing else needs to be wired up.
//
// This is NOT how order-service will normally talk to inventory-service (see "Calling a
// Service by Name with a Load-Balanced RestClient" for the idiomatic way) -- but it's
// useful for diagnostics, and for understanding exactly what Eureka is tracking under the
// hood: host, port, and a small metadata map per instance.
@RestController
class DiscoveryClientExample {

    private final DiscoveryClient discoveryClient;

    DiscoveryClientExample(DiscoveryClient discoveryClient) {
        this.discoveryClient = discoveryClient;
    }

    // GET /discovered-services/{serviceName} -- lists every currently-registered
    // instance of a given service name, straight from the Eureka registry.
    @GetMapping("/discovered-services/{serviceName}")
    List<Map<String, Object>> listInstances(@PathVariable String serviceName) {
        List<ServiceInstance> instances = discoveryClient.getInstances(serviceName);
        return instances.stream()
                .map(instance -> Map.<String, Object>of(
                        "host", instance.getHost(),
                        "port", instance.getPort(),
                        "uri", instance.getUri().toString(),
                        "metadata", instance.getMetadata()
                ))
                .toList();
    }

    // GET /discovered-services -- lists every service NAME currently registered with
    // Eureka, regardless of instance count (useful to see the whole registry at a
    // glance).
    @GetMapping("/discovered-services")
    List<String> listServiceNames() {
        return discoveryClient.getServices();
    }
}
