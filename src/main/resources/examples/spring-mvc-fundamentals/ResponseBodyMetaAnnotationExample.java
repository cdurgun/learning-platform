import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

// @RestController is not a separate mechanism from @Controller -- it is a
// meta-annotation combining @Controller with @ResponseBody. The two controllers below
// behave identically for this one endpoint.
@Controller
class ManualResponseBodyController {

    @GetMapping("/status")
    @ResponseBody
    public String status() {
        return "OK"; // @ResponseBody on the method: written directly to the body
    }
}

@RestController
class EquivalentRestController {

    @GetMapping("/status")
    public String status() {
        return "OK"; // @RestController applies @ResponseBody to every method by default
    }
}
