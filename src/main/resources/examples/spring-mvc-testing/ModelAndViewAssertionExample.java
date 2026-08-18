import org.springframework.stereotype.Controller;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

// model()/view(): looks not just at the HTTP status and body, but at which attributes
// the controller put into the Model and which view name it returned -- for a classic
// @Controller (rendered with Thymeleaf, not returning JSON), this is usually more
// meaningful than content(), because it verifies the controller's CONTRACT (which
// view, with what data) rather than the rendered HTML.
public class ModelAndViewAssertionExample {

    @Controller
    static class ProfileController {
        @GetMapping("/profile")
        String profile(Model model) {
            model.addAttribute("username", "cdurgun");
            model.addAttribute("topicCount", 25);
            return "profile";
        }
    }

    public static void main(String[] args) throws Exception {
        MockMvc mockMvc = MockMvcBuilders.standaloneSetup(new ProfileController()).build();

        mockMvc.perform(get("/profile"))
                .andExpect(status().isOk())
                // view().name(): verifies the returned logical view name (NOT whether
                // the physical profile.html file was actually rendered --
                // standaloneSetup has no ViewResolver/template engine).
                .andExpect(view().name("profile"))
                // model().attribute(...): verifies the VALUE of an attribute.
                .andExpect(model().attribute("username", "cdurgun"))
                .andExpect(model().attribute("topicCount", 25))
                // model().attributeExists(...): verifies only its PRESENCE, not its value --
                // useful when you don't care about testing the value itself.
                .andExpect(model().attributeExists("username", "topicCount"));

        System.out.println("Model and view assertions passed.");
    }
}
