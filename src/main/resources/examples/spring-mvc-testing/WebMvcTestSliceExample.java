import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.stereotype.Controller;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.bind.annotation.GetMapping;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// @WebMvcTest loads a SLICE of the application, not the whole thing: DispatcherServlet,
// HandlerMapping/HandlerAdapter, message converters, the given controller (and other
// @Controller/@ControllerAdvice/@Converter/HandlerInterceptor/WebMvcConfigurer beans) --
// but NOT @Service/@Repository/@Component beans, and NOT a real database connection.
// This is a "run via `mvn test`" example, not a plain main() program -- @WebMvcTest
// needs JUnit's test runner and a Spring TestContext to do its work.
@WebMvcTest(WebMvcTestSliceExample.PingController.class)
class WebMvcTestSliceExample {

    // A tiny controller defined right here, just to keep this example self-contained --
    // in a real test this would be an existing @Controller/@RestController class.
    @Controller
    static class PingController {
        @GetMapping("/ping")
        @org.springframework.web.bind.annotation.ResponseBody
        String ping() {
            return "pong";
        }
    }

    private final MockMvc mockMvc;

    WebMvcTestSliceExample(MockMvc mockMvc) {
        // MockMvc is one of the few beans @WebMvcTest auto-configures and lets you
        // inject directly -- no manual setup needed.
        this.mockMvc = mockMvc;
    }

    @Test
    void pingReturnsPong() throws Exception {
        mockMvc.perform(get("/ping"))
                .andExpect(status().isOk());
        // If PingController depended on a @Service, this test would fail at context
        // startup with "no qualifying bean" -- @WebMvcTest deliberately does NOT wire
        // up @Service/@Repository beans; see "Mocking Dependencies with @MockitoBean"
        // for how to supply the ones a real controller needs.
    }
}
