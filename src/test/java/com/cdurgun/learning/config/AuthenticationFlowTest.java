package com.cdurgun.learning.config;

import com.cdurgun.learning.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.Matchers.containsString;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Kimlik doğrulama akışının uçtan uca (gerçek {@code SecurityFilterChain} +
 * gerçek Postgres test DB'si üzerinden) doğrulanması: anonim erişim, kayıt,
 * başarılı/başarısız giriş, çıkış. Her test kendi rastgele email'ini üretir
 * (UUID) — testler arası izolasyon için ayrı bir temizleme adımına gerek yok.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class AuthenticationFlowTest {

    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private UserRepository userRepository;

    @Test
    void anonymousUserCanReachHomePage() throws Exception {
        mockMvc.perform(get("/en"))
                .andExpect(status().isOk());
    }

    @Test
    void anonymousUserCanReachLoginAndRegisterPages() throws Exception {
        mockMvc.perform(get("/en/login")).andExpect(status().isOk());
        mockMvc.perform(get("/en/register")).andExpect(status().isOk());
    }

    @Test
    void registrationThenLoginThenLogoutSucceeds() throws Exception {
        String email = "user-" + UUID.randomUUID() + "@example.com";

        mockMvc.perform(post("/en/register")
                        .param("email", email)
                        .param("password", "correct-password")
                        .param("displayName", "Test User")
                        .param("termsAccepted", "true")
                        .with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/en/login?registered"));

        MvcResult loginResult = mockMvc.perform(post("/en/login")
                        .param("username", email)
                        .param("password", "correct-password")
                        .with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/en"))
                .andReturn();

        HttpSession session = loginResult.getRequest().getSession(false);
        assertThat(session).isNotNull();
        SecurityContext securityContext = (SecurityContext) session
                .getAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY);
        assertThat(securityContext.getAuthentication().isAuthenticated()).isTrue();
        assertThat(securityContext.getAuthentication().getName()).isEqualTo(email);

        mockMvc.perform(post("/en/logout")
                        .session((MockHttpSession) session)
                        .with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/en"));
    }

    @Test
    void registrationWithoutAcceptingTermsIsRejected() throws Exception {
        String email = "noterms-" + UUID.randomUUID() + "@example.com";

        mockMvc.perform(post("/en/register")
                        .param("email", email)
                        .param("password", "correct-password")
                        .param("displayName", "No Terms")
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Accept the Terms of Use to create an account.")));

        assertThat(userRepository.existsByEmail(email)).isFalse();

        mockMvc.perform(post("/tr/register")
                        .param("email", email)
                        .param("password", "correct-password")
                        .param("displayName", "No Terms")
                        .with(csrf()))
                .andExpect(content().string(containsString("Kullanım Koşulları&#39;nı kabul etmelisin.")));
    }

    @Test
    void registerPageLinksTermsAndPrivacyInsideTheForm() throws Exception {
        mockMvc.perform(get("/tr/register"))
                .andExpect(content().string(containsString(
                        "<a href=\"/tr/terms\" target=\"_blank\" rel=\"noopener\">Kullanım Koşulları</a>'nı kabul ediyorum")))
                .andExpect(content().string(containsString("href=\"/tr/privacy\" target=\"_blank\"")));
    }

    @Test
    void duplicateEmailRegistrationIsRejected() throws Exception {
        String email = "dup-" + UUID.randomUUID() + "@example.com";

        mockMvc.perform(post("/en/register")
                        .param("email", email)
                        .param("password", "correct-password")
                        .param("displayName", "First")
                        .param("termsAccepted", "true")
                        .with(csrf()))
                .andExpect(status().is3xxRedirection());

        mockMvc.perform(post("/en/register")
                        .param("email", email)
                        .param("password", "another-password")
                        .param("displayName", "Second")
                        .param("termsAccepted", "true")
                        .with(csrf()))
                .andExpect(status().isOk());
    }

    @Test
    void loginWithWrongPasswordRedirectsWithError() throws Exception {
        String email = "wrongpass-" + UUID.randomUUID() + "@example.com";

        mockMvc.perform(post("/en/register")
                        .param("email", email)
                        .param("password", "correct-password")
                        .param("displayName", "Test User")
                        .param("termsAccepted", "true")
                        .with(csrf()))
                .andExpect(status().is3xxRedirection());

        mockMvc.perform(post("/en/login")
                        .param("username", email)
                        .param("password", "totally-wrong")
                        .with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/en/login?error"));
    }
}
