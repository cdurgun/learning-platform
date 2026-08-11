import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.server.ResponseStatusException;

import java.util.Map;

// ResponseStatusException -- the same class this project's own TopicController uses
// (see "This Project's Own Mappings" in an earlier lesson) -- is the simplest way to
// signal a 4xx from anywhere in a controller: throw it, and DispatcherServlet turns
// it into the right HTTP response, no manual ResponseEntity needed.
@Controller
class AccountController {
    private final Map<Long, String> accounts = Map.of(1L, "checking");
    private final Map<Long, String> owners = Map.of(1L, "ayse");

    record TransferRequest(Long fromAccountId, Double amount) {
    }

    @PostMapping("/transfers")
    @ResponseBody
    public String transfer(@RequestBody TransferRequest request) {
        if (request.amount() == null || request.amount() <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "amount must be positive"); // 400
        }
        return "Transfer accepted";
    }

    @GetMapping("/accounts/{id}")
    @ResponseBody
    public String getAccount(@PathVariable Long id, String currentUser) {
        if (currentUser == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "login required"); // 401
        }
        if (!owners.getOrDefault(id, "").equals(currentUser)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "not your account"); // 403
        }
        String account = accounts.get(id);
        if (account == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "account not found"); // 404
        }
        return account;
    }

    @DeleteMapping("/accounts/{id}")
    @ResponseBody
    public String closeAccount(@PathVariable Long id) {
        String account = accounts.get(id);
        if ("checking".equals(account)) {
            // Business rule violated: checking accounts with a balance can't be
            // closed. The request is well-formed, but conflicts with server state.
            throw new ResponseStatusException(HttpStatus.CONFLICT, "account has a balance"); // 409
        }
        return "Account closed";
    }
}
