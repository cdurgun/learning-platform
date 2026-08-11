import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

// @RequestMapping is the original, most general mapping annotation -- it can match
// any HTTP method (or several at once) via its `method` attribute. Every shortcut
// annotation we'll see next (@GetMapping, @PostMapping...) is built on top of this one.
@Controller
class RawRequestMappingController {

    @RequestMapping(path = "/ping", method = RequestMethod.GET)
    @ResponseBody
    public String ping() {
        return "pong";
    }

    // Without a `method`, @RequestMapping matches EVERY HTTP method on this path --
    // rarely what you want, but useful to know it's the default.
    @RequestMapping(path = "/any-method")
    @ResponseBody
    public String anyMethod() {
        return "matched regardless of HTTP method";
    }
}
