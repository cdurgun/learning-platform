import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

// @RequestMapping at the class level sets a COMMON PREFIX for every method inside --
// exactly the pattern this project's own TopicController used to follow
// (@RequestMapping("/topics") on the class, @GetMapping("/{slug}") on the method),
// before it later grew a second mapping shape that no longer shared that prefix
// (see "This Project's Own Mappings: A Real Example" in the parent lesson).
// @PathVariable is used here just to keep the example realistic; we'll cover it in
// full in the next lesson (Path Variables & Request Parameters).
@Controller
@RequestMapping("/users")
class UserController {

    @GetMapping
    @ResponseBody
    public String list() {
        return "GET /users";
    }

    @GetMapping("/{id}")
    @ResponseBody
    public String getOne(@PathVariable Long id) {
        return "GET /users/" + id;
    }

    @GetMapping("/search")
    @ResponseBody
    public String search() {
        return "GET /users/search";
    }
}
