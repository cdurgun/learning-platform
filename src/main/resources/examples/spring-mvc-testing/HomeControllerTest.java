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
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

// Bu projenin GERÇEK HomeController'ının gerçek bir @WebMvcTest testi -- kurgu bir
// controller değil. HomeController'ın tek bağımlılığı NavigationService, bu yüzden
// tek bir @MockitoBean yeterli. JUnit test sınıfı, `mvn test` ile çalışır.
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

        mockMvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(view().name("index"))
                .andExpect(model().attributeExists("language"))
                .andExpect(model().attributeExists("nav"));

        // Gerçek controller kodunu okuyunca görürsünüz: `language`,
        // LocaleContextHolder.getLocale() üzerinden çözülüyor -- bu test bunu HTTP
        // isteğinin kendi varsayılan locale'iyle (test ortamında genelde Locale.getDefault())
        // doğal olarak sağlıyor; belirli bir dili zorlamak isterseniz `.locale(Locale.forLanguageTag("tr"))`
        // ekleyebilirsiniz.
        verify(navigationService).buildNavigation(org.mockito.ArgumentMatchers.any());
    }
}
