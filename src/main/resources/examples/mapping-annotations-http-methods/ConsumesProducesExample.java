import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

// consumes/produces narrow a mapping to specific Content-Type/Accept headers -- the
// SAME path and HTTP method can be mapped twice, once per representation. @RequestBody
// is used here just to keep the example realistic; it's covered in full in a later
// lesson (Request & Response Handling).
@Controller
class ContentNegotiatingController {

    @PostMapping(path = "/orders", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String createFromJson(@RequestBody String body) {
        return "{\"status\":\"created from JSON\"}";
    }

    @PostMapping(path = "/orders", consumes = MediaType.APPLICATION_XML_VALUE, produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String createFromXml(@RequestBody String body) {
        return "<status>created from XML</status>";
    }
}
