import com.cdurgun.learning.controller.HomeController;
import com.cdurgun.learning.service.NavigationService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

// Bu projenin GERÇEK HomeController'ının gerçek bir @WebMvcTest testi -- kurgu bir
// controller değil. HomeController'ın tek bağımlılığı NavigationService, bu yüzden
// tek bir @MockitoBean yeterli. JUnit test sınıfı, `mvn test` ile çalışır. Faz 64'ten
// beri HomeController iki endpoint'e sahip: `/{lang:en|tr}` gerçek anasayfayı render
// eder, çıplak `/` ise bir dil "negotiator"ı -- `Accept-Language` başlığına göre
// `/en` ya da `/tr`'ye 302 yönlendirir. Aşağıdaki iki test ikisini de kapsıyor.
@WebMvcTest(HomeController.class)
class HomeControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private NavigationService navigationService;

    @Test
    void indexReturnsIndexViewWithNavigationModel() throws Exception {
        // buildNavigation gerçek DB'ye gitmiyor -- boş liste dönmesi bile yeterli,
        // çünkü burada test edilen şey NavigationService'in DAVRANIŞI değil,
        // HomeController'ın onu nasıl ÇAĞIRDIĞI ve model'e nasıl koyduğu.
        when(navigationService.buildNavigation(org.mockito.ArgumentMatchers.any())).thenReturn(List.of());

        // Dil artık isteğin kendi varsayılan locale'ine (test ortamında genelde
        // Locale.getDefault()) değil, doğrudan URL path'ine ({en|tr}) bağlı --
        // `/en` isteği her zaman ve her ortamda aynı sonucu verir.
        mockMvc.perform(get("/en"))
                .andExpect(status().isOk())
                .andExpect(view().name("index"))
                .andExpect(model().attributeExists("language"))
                .andExpect(model().attributeExists("nav"));

        verify(navigationService).buildNavigation(org.mockito.ArgumentMatchers.any());
    }

    @Test
    void bareRootRedirectsToDefaultLanguage() throws Exception {
        // Accept-Language header'ı olmayan bir istek (bu testteki gibi) EN'e düşer --
        // bkz. HomeController.resolveRootLanguage'ın varsayılan davranışı. Bu metot
        // hiçbir bağımlılığa dokunmadığı için navigationService'i hiç stub'lamaya
        // gerek yok.
        mockMvc.perform(get("/"))
                .andExpect(status().isFound())
                .andExpect(redirectedUrl("/en"));
    }
}
