import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

// A realistic registration endpoint, guarded by every annotation family from this
// lesson. See UserRegistrationDemo for how Spring's validation gate actually runs
// before this method is ever called.
@Controller
class UserRegistrationController {

    record RegisterRequest(
            @NotBlank @Size(min = 2, max = 50) String name,
            @Email String email,
            @NotBlank @Size(min = 8) String password) {
    }

    @PostMapping("/register")
    @ResponseBody
    public String register(@Valid @RequestBody RegisterRequest request) {
        return "Registered: " + request.name();
    }
}
