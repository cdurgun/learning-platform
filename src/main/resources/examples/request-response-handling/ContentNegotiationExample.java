import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

// Content negotiation is the client (via the Accept header) and the server (via
// `produces`) agreeing on which REPRESENTATION of the same resource to exchange.
// Both mappings below serve the same underlying data, in different formats.
@Controller
class ProductRepresentationController {

    @GetMapping(path = "/products/1", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String asJson() {
        return "{\"name\":\"Keyboard\",\"price\":49.9}";
    }

    @GetMapping(path = "/products/1", produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String asXml() {
        return "<product><name>Keyboard</name><price>49.9</price></product>";
    }
    // A request with "Accept: application/json" matches asJson(); "Accept:
    // application/xml" matches asXml(). A request with "Accept: text/csv" -- a
    // representation neither method produces -- matches neither, and DispatcherServlet
    // responds with 406 Not Acceptable before either method is ever called.
}
