import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

// Without @RefreshScope, a @Value-injected property is read EXACTLY ONCE, when
// this bean is first created -- editing config-repo/order-service.yml's
// greeting.message afterward would have NO effect on an already-running
// order-service; a full restart would be the only way to pick it up.
// @RefreshScope makes Spring throw this bean away and recreate it (re-reading
// every @Value) whenever a refresh is triggered (see "Refreshing Configuration
// Without Restarting: @RefreshScope") -- the endpoint below always reflects
// whatever config-server is currently serving, without order-service ever
// stopping.
@RestController
@RefreshScope
class RefreshableGreetingController {

    @Value("${greeting.message}")
    private String greetingMessage;

    // GET /greeting -- returns whatever greeting.message currently is. Change
    // OrderServiceExternalConfig.yml, POST to order-service's own
    // /actuator/refresh, and call this again: the response changes, with
    // order-service never having restarted.
    @GetMapping("/greeting")
    String greeting() {
        return greetingMessage;
    }
}
