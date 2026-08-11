import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

// @Valid on a @RequestBody parameter tells Spring to run the same kind of Validator
// used directly in ManualValidatorExample BEFORE this method's body ever executes --
// if any constraint fails, create(...) is never called at all.
@Controller
class UserController {

    record CreateUserRequest(@NotBlank String name, @Email String email) {
    }

    @PostMapping("/users")
    @ResponseBody
    public String create(@Valid @RequestBody CreateUserRequest request) {
        return "Created: " + request.name();
    }
}
