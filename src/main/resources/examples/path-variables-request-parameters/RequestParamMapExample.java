import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

// Sometimes you don't know the query parameter names in advance -- binding to a Map
// captures every query parameter present on the request, whatever its name.
@Controller
class FlexibleFilterController {

    @GetMapping("/reports")
    @ResponseBody
    public String report(@RequestParam Map<String, String> allParams) {
        return "Received filters: " + allParams;
    }
}
