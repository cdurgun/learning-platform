import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

// @RequestBody reads the ENTIRE HTTP request body and deserializes it into a Java
// object -- unlike @RequestParam/@PathVariable, which each read one named value, this
// reads the whole body at once.
@Controller
class UserCreationController {

    record CreateUserRequest(String name, String email) {
    }

    @PostMapping("/users")
    @ResponseBody
    public String create(@RequestBody CreateUserRequest request) {
        return "Created user: " + request.name() + " <" + request.email() + ">";
    }
}
