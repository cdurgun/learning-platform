import org.springframework.stereotype.Controller;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

// model()/view(): sadece HTTP durumuna ve gövdesine değil, controller'ın Model'e
// hangi attribute'ları koyduğuna ve hangi view adını döndürdüğüne bakar -- klasik
// (JSON döndürmeyen, Thymeleaf ile render edilen) bir @Controller için bu genelde
// content()'ten daha anlamlıdır, çünkü render edilmiş HTML'i değil, controller'ın
// SÖZLEŞMESİNİ (hangi view, hangi veriyle) doğrular.
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
                // view().name(): dönen mantıksal view adını doğrular (fiziksel
                // profile.html dosyasının render edilip edilmediğini DEĞİL --
                // standaloneSetup'ta bir ViewResolver/template motoru yok).
                .andExpect(view().name("profile"))
                // model().attribute(...): bir attribute'ın DEĞERİNİ doğrular.
                .andExpect(model().attribute("username", "cdurgun"))
                .andExpect(model().attribute("topicCount", 25))
                // model().attributeExists(...): sadece VARLIĞINI doğrular, değerini değil --
                // değeri test edip etmeyeceğinize önem vermediğiniz durumlarda kullanışlı.
                .andExpect(model().attributeExists("username", "topicCount"));

        System.out.println("Model ve view dogrulamalari basarili.");
    }
}
