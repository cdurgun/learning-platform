import org.springframework.stereotype.Controller;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.bind.annotation.GetMapping;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// MockMvcBuilders.standaloneSetup(...) inşa eder MockMvc'yi bir Spring ApplicationContext
// OLMADAN -- sadece verilen controller(lar)ı DispatcherServlet benzeri bir pipeline'a
// elle bağlar. Bu yüzden bu dosya, projenin main()-ile-çalıştırılabilir kuralına uyarak
// plain main() ile çalışabilir; gerçek @WebMvcTest/@SpringBootTest testleri (aşağıdaki
// diğer örneklerde) bir JUnit runner + Spring TestContext gerektirir.
public class FirstMockMvcTestExample {

    @Controller
    static class GreetingController {
        @GetMapping("/greeting")
        @org.springframework.web.bind.annotation.ResponseBody
        String greeting() {
            return "Merhaba, MockMvc!";
        }
    }

    public static void main(String[] args) throws Exception {
        MockMvc mockMvc = MockMvcBuilders.standaloneSetup(new GreetingController()).build();

        // perform(): sahte bir HTTP isteği gönderir (gerçek soket açılmaz, gerçek port
        // dinlenmez -- her şey aynı JVM içinde, servlet API'sinin sahte implementasyonlarıyla
        // çalışır). andExpect(): zincirlenebilir doğrulamalar; biri başarısız olursa
        // AssertionError fırlatır ve zincirin geri kalanı çalışmaz.
        mockMvc.perform(get("/greeting"))
                .andExpect(status().isOk())
                .andExpect(content().string("Merhaba, MockMvc!"));

        System.out.println("Tum andExpect() dogrulamalari basarili -- gercek bir HTTP");
        System.out.println("sunucusu hic acilmadi.");

        // status(): HTTP durum kodunu doğrular -- isOk() (200), isNotFound() (404),
        // isBadRequest() (400) gibi okunabilir yardımcı metotlarla.
        // content(): yanıt gövdesini doğrular -- string(), contentType(), json() vb.
    }
}
