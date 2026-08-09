import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;

@RestController
class UserController {

    // In a real application a UserService would be injected here; to keep the
    // example simple, we build the UserResponse directly.
    @PostMapping("/api/users")
    ResponseEntity<UserResponse> create(@Valid @RequestBody CreateUserRequest request) {
        UserResponse response = UserResponse.from(1L, request.fullName(), request.email(), Instant.now());
        return ResponseEntity.ok(response);
    }
}
