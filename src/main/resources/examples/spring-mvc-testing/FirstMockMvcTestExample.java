import org.springframework.stereotype.Controller;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.bind.annotation.GetMapping;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// MockMvcBuilders.standaloneSetup(...) builds MockMvc WITHOUT a Spring ApplicationContext --
// it just wires the given controller(s) into a DispatcherServlet-like pipeline by hand.
// That's why this file, following the project's runnable-via-main() convention, can run
// as a plain main(); the real @WebMvcTest/@SpringBootTest tests (in the other examples
// below) require a JUnit runner + Spring TestContext.
public class FirstMockMvcTestExample {

    @Controller
    static class GreetingController {
        @GetMapping("/greeting")
        @org.springframework.web.bind.annotation.ResponseBody
        String greeting() {
            return "Hello, MockMvc!";
        }
    }

    public static void main(String[] args) throws Exception {
        MockMvc mockMvc = MockMvcBuilders.standaloneSetup(new GreetingController()).build();

        // perform(): sends a fake HTTP request (no real socket is opened, no real port
        // is listened on -- everything runs inside the same JVM, using fake implementations
        // of the servlet API). andExpect(): chainable assertions; if one fails it throws
        // an AssertionError and the rest of the chain does not run.
        mockMvc.perform(get("/greeting"))
                .andExpect(status().isOk())
                .andExpect(content().string("Hello, MockMvc!"));

        System.out.println("All andExpect() assertions passed -- no real HTTP");
        System.out.println("server was ever opened.");

        // status(): verifies the HTTP status code -- via readable helper methods like
        // isOk() (200), isNotFound() (404), isBadRequest() (400).
        // content(): verifies the response body -- via string(), contentType(), json(), etc.
    }
}
