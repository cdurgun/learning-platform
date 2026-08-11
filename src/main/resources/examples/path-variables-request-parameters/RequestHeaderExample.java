import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;

// @RequestHeader reads a value from the HTTP request headers, the same way
// @RequestParam reads from the query string -- required by default, with the same
// `required`/`defaultValue` options.
@Controller
class ClientInfoController {

    @GetMapping("/whoami")
    @ResponseBody
    public String whoAmI(
            @RequestHeader("User-Agent") String userAgent,
            @RequestHeader(value = "X-Request-Id", required = false) String requestId) {
        return "User-Agent: " + userAgent + ", X-Request-Id: " + requestId;
    }
}
