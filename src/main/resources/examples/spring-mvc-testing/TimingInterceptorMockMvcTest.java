import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// standaloneSetup(...).addInterceptors(...): attaches an interceptor directly to
// MockMvc, without ever writing the WebMvcConfigurer that registers it (as in
// InterceptorRegistrationExample) -- ideal for testing the interceptor in ISOLATION,
// since it doesn't pull in the whole application's configuration (path patterns,
// other interceptors).
public class TimingInterceptorMockMvcTest {

    @RestController
    static class PingController {
        @GetMapping("/ping")
        String ping() {
            return "pong";
        }
    }

    public static void main(String[] args) throws Exception {
        MockMvc mockMvc = MockMvcBuilders.standaloneSetup(new PingController())
                .addInterceptors(new TimingInterceptorForTest())
                .build();

        mockMvc.perform(get("/ping"))
                .andExpect(status().isOk())
                // header().exists(...): verifies that this header is present in the response --
                // since its value will change on every run (the real elapsed time), exists()
                // is a more accurate choice here than looking for an exact match with
                // string(...).
                .andExpect(header().exists("X-Response-Time-Ms"));

        System.out.println("Interceptor tested in isolation with standaloneSetup.");

        // addInterceptors(...) applies to ALL paths here -- if you want to restrict it to
        // a specific path pattern, as in the real application, MockMvcBuilders' standalone
        // API doesn't support that directly; in that case you'd need to test the
        // interceptor's own internal path check (if it has one).
    }
}
