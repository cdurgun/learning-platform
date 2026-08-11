import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

// @RequestParam reads a value from the query string -- ?page=2 becomes the `page`
// parameter, matched by name just like @PathVariable.
@Controller
class UserListController {

    @GetMapping("/users")
    @ResponseBody
    public String list(@RequestParam int page) {
        return "Showing page " + page;
    }
}
