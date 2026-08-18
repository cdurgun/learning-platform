import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

// A traditional Spring MVC controller. The String it returns is NOT the HTTP response
// body -- it is a LOGICAL VIEW NAME. DispatcherServlet hands this name to a
// ViewResolver, which turns it into an actual template (e.g. templates/home.html).
// This class can't run on its own -- it needs a running DispatcherServlet and a
// configured ViewResolver, exactly like this project's own HomeController (see "This
// Project's Own Controllers").
@Controller
class HomePageController {

    @GetMapping("/")
    public String home() {
        return "home"; // resolves to templates/home.html, not the literal text "home"
    }
}
