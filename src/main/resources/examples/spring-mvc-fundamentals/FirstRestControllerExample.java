import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

// @RestController writes its return value DIRECTLY to the HTTP response body -- there
// is no view name, no ViewResolver, no template. A plain String becomes the entire
// response body, with Content-Type: text/plain.
@RestController
class HelloRestController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello, World!";
    }
}
