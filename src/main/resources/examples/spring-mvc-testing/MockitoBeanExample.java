import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// NOTE: @MockBean has been deprecated since Spring Boot 3.4 and was planned for removal
// in 4.0; since this project uses Spring Boot 4.1.0, ONLY @MockitoBean
// (org.springframework.test.context.bean.override.mockito.MockitoBean) is used here and
// in all subsequent examples. This is a JUnit test class -- it does not run via main(),
// it requires `mvn test`.
@WebMvcTest(MockitoBeanExample.GreeterController.class)
class MockitoBeanExample {

    // In a real application this would be a @Service; here it's defined inside the
    // file just to keep the example self-contained.
    interface GreetingService {
        String greetingFor(String name);
    }

    @Service
    static class RealGreetingService implements GreetingService {
        @Override
        public String greetingFor(String name) {
            throw new UnsupportedOperationException("The real implementation does not matter here");
        }
    }

    @Controller
    static class GreeterController {
        private final GreetingService greetingService;

        GreeterController(GreetingService greetingService) {
            this.greetingService = greetingService;
        }

        @GetMapping("/greet")
        @org.springframework.web.bind.annotation.ResponseBody
        String greet() {
            return greetingService.greetingFor("Cem");
        }
    }

    @Autowired
    private MockMvc mockMvc;

    // @MockitoBean: adds a Mockito fake of type GreetingService to the context (or
    // replaces the real bean if one exists). Since @WebMvcTest doesn't load @Service
    // beans anyway, without this GreeterController's dependency would blow up at
    // context startup with a "no qualifying bean" error.
    @MockitoBean
    private GreetingService greetingService;

    @Test
    void greetUsesMockedService() throws Exception {
        when(greetingService.greetingFor("Cem")).thenReturn("Hello, Cem!");

        mockMvc.perform(get("/greet"))
                .andExpect(status().isOk())
                .andExpect(content().string("Hello, Cem!"));

        // RealGreetingService never ran -- only the value returned by the fake object
        // was used. This fully isolates the test from RealGreetingService's implementation
        // details (e.g. a database call).
    }
}
