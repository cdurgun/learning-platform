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

// A real @WebMvcTest test for this project's ACTUAL HomeController -- not a made-up
// controller. HomeController's only dependency is NavigationService, so a single
// @MockitoBean is enough. This is a JUnit test class, run via `mvn test`. Since Phase 64,
// HomeController has had two endpoints: `/{lang:en|tr}` renders the real home page,
// while the bare `/` acts as a language "negotiator" -- it 302-redirects to `/en` by
// default (Phase 69: deliberately ignores the `Accept-Language` header, so a visitor
// with a Turkish browser/OS still lands on the English site first and switches
// manually via the navbar). The three tests below cover the index page, the
// no-header case, and the header-is-ignored case explicitly.
@WebMvcTest(HomeController.class)
class HomeControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private NavigationService navigationService;

    @Test
    void indexReturnsIndexViewWithNavigationModel() throws Exception {
        // buildNavigation does not hit a real DB -- returning even an empty list is enough,
        // because what's being tested here is not NavigationService's BEHAVIOR, but
        // HOW HomeController CALLS it and puts the result into the model.
        when(navigationService.buildNavigation(org.mockito.ArgumentMatchers.any())).thenReturn(List.of());

        // Language now depends directly on the URL path ({en|tr}), not on the request's
        // own default locale (usually Locale.getDefault() in a test environment) --
        // an `/en` request always produces the same result, in any environment.
        mockMvc.perform(get("/en"))
                .andExpect(status().isOk())
                .andExpect(view().name("index"))
                .andExpect(model().attributeExists("language"))
                .andExpect(model().attributeExists("nav"));

        verify(navigationService).buildNavigation(org.mockito.ArgumentMatchers.any());
    }

    @Test
    void bareRootRedirectsToDefaultLanguage() throws Exception {
        // A request with no Accept-Language header (like this test) redirects to EN --
        // see HomeController.resolveRootLanguage's default behavior. This method doesn't
        // touch any dependency, so there's no need to stub navigationService at all.
        mockMvc.perform(get("/"))
                .andExpect(status().isFound())
                .andExpect(redirectedUrl("/en"));
    }

    @Test
    void bareRootIgnoresAcceptLanguageHeader() throws Exception {
        // Phase 69: even a request that clearly prefers Turkish still lands on `/en` --
        // resolveRootLanguage no longer reads Accept-Language at all. This is a
        // deliberate product decision (default to English for everyone, let the
        // visitor switch languages themselves via the navbar's TR/EN buttons), not an
        // oversight -- this test exists specifically to pin that behavior down so a
        // future change doesn't silently reintroduce header-based negotiation.
        mockMvc.perform(get("/").header("Accept-Language", "tr-TR,tr;q=0.9"))
                .andExpect(status().isFound())
                .andExpect(redirectedUrl("/en"));
    }
}
