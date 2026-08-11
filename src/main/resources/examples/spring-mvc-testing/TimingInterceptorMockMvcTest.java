import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// standaloneSetup(...).addInterceptors(...): bir interceptor'ı, onu kayıt eden
// WebMvcConfigurer'ı (InterceptorRegistrationExample'daki gibi) hiç yazmadan, doğrudan
// MockMvc'ye takar -- interceptor'ı İZOLE olarak test etmek için idealdir, çünkü tüm
// uygulamanın konfigürasyonunu (path pattern'ler, diğer interceptor'lar) devreye
// sokmaz.
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
                // header().exists(...): yanıtta bu header'ın var olduğunu doğrular --
                // değeri her koşuda değişeceği (gerçek geçen süre) için exists() burada
                // string(...) ile tam eşleşme aramaktan daha doğru bir seçimdir.
                .andExpect(header().exists("X-Response-Time-Ms"));

        System.out.println("Interceptor, standaloneSetup ile izole test edildi.");

        // addInterceptors(...) burada TÜM path'lere uygulanır -- gerçek uygulamada
        // olduğu gibi belirli bir path pattern'ine sınırlamak isterseniz
        // MockMvcBuilders'ın standalone API'si bunu doğrudan desteklemez; bu durumda
        // interceptor'ın kendi içindeki path kontrolünü (varsa) test etmeniz gerekir.
    }
}
