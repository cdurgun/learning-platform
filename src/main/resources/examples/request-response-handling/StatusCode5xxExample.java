import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

// Unlike a 4xx, a 500 usually isn't something you return on purpose -- it's Spring's
// DEFAULT response when a controller method throws an exception nobody handled.
@Controller
class ReportController {

    @GetMapping("/reports/summary")
    @ResponseBody
    public String summary() {
        int result = 1 / computeDivisor(); // bug: divisor can be 0, throws ArithmeticException
        return "Result: " + result;
        // With no ResponseStatusException and no @ExceptionHandler (the next lesson,
        // Validation & Exception Handling, covers those) to catch it,
        // DispatcherServlet's default error handling turns the uncaught
        // ArithmeticException into a generic 500 Internal Server Error -- the
        // exception's details are logged server-side but never exposed to the client.
    }

    private int computeDivisor() {
        return 0;
    }
}
