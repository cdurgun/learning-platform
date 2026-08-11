import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.ResponseBody;

// Each shortcut is a meta-annotation: @GetMapping is exactly
// @RequestMapping(method = RequestMethod.GET), just shorter and more readable at a
// glance. A typical resource controller uses one of each, one per operation.
@Controller
@ResponseBody
class UserShortcutController {

    @GetMapping("/users")
    public String listUsers() {
        return "list of users";
    }

    @PostMapping("/users")
    public String createUser() {
        return "user created";
    }

    @PutMapping("/users/1")
    public String replaceUser() {
        return "user replaced";
    }

    @PatchMapping("/users/1")
    public String updateUser() {
        return "user partially updated";
    }

    @DeleteMapping("/users/1")
    public String deleteUser() {
        return "user deleted";
    }
}
