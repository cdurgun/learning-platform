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

// NOT: @MockBean, Spring Boot 3.4'ten beri deprecated ve 4.0'da kaldırılması planlanıyordu;
// bu proje Spring Boot 4.1.0 kullandığı için burada ve sonraki tüm örneklerde
// SADECE @MockitoBean (org.springframework.test.context.bean.override.mockito.MockitoBean)
// kullanılıyor. Bu, bir JUnit test sınıfıdır -- main() ile çalışmaz, `mvn test` gerektirir.
@WebMvcTest(MockitoBeanExample.GreeterController.class)
class MockitoBeanExample {

    // Gerçek uygulamada bir @Service olurdu; burada örneği self-contained tutmak için
    // dosyanın içinde tanımlı.
    interface GreetingService {
        String greetingFor(String name);
    }

    @Service
    static class RealGreetingService implements GreetingService {
        @Override
        public String greetingFor(String name) {
            throw new UnsupportedOperationException("Gerçek implementasyon burada önemli değil");
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

    // @MockitoBean: context'e GreetingService türünde bir Mockito sahtesi ekler (veya
    // varsa gerçek bean'in yerine geçirir). @WebMvcTest zaten @Service'leri yüklemediği
    // için, GreeterController'ın bağımlılığı bu olmadan "no qualifying bean" hatasıyla
    // context başlatma anında patlardı.
    @MockitoBean
    private GreetingService greetingService;

    @Test
    void greetUsesMockedService() throws Exception {
        when(greetingService.greetingFor("Cem")).thenReturn("Merhaba, Cem!");

        mockMvc.perform(get("/greet"))
                .andExpect(status().isOk())
                .andExpect(content().string("Merhaba, Cem!"));

        // RealGreetingService hiç çalışmadı -- sadece sahte nesnenin döndürdüğü değer
        // kullanıldı. Bu, testi RealGreetingService'in implementasyon detaylarından
        // (örn. bir veritabanı çağrısından) tamamen izole eder.
    }
}
