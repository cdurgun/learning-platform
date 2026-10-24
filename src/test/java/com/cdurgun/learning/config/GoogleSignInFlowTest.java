package com.cdurgun.learning.config;

import com.cdurgun.learning.domain.IdentityProvider;
import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.UserIdentityRepository;
import com.cdurgun.learning.repository.UserRepository;
import com.cdurgun.learning.service.PendingGoogleSignIn;
import com.cdurgun.learning.service.UserRegistrationService;
import com.cdurgun.learning.web.auth.GoogleSignInSession;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import java.time.Duration;
import java.time.Instant;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.not;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * "Google ile devam et" akışı, gerçek {@code SecurityFilterChain} + gerçek test DB'si
 * üzerinden. Testler Google'a bağlanmaz: Google'a giden istek (yönlendirme URL'i),
 * Google'dan dönen hata yanıtları ve uygulamanın kendi adımları (koşul onayı, şifreyle
 * bağlama) burada; Google'ın ID token'ının doğrulanmasından sonraki eşleme
 * {@code GoogleOidcUserServiceTest}'te. application-test.yml SAHTE bir istemci tanımlar.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class GoogleSignInFlowTest {

    private static final String TEST_CLIENT_ID = "test-client-id.apps.googleusercontent.com";

    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserIdentityRepository userIdentityRepository;
    @Autowired
    private UserRegistrationService userRegistrationService;

    private static String randomEmail() {
        return "google-flow-" + UUID.randomUUID() + "@example.com";
    }

    /** Google'dan dönüşte failure handler'ın yaptığı gibi, session'a bekleyen bir kimlik koyar. */
    private static MockHttpSession sessionWithPending(PendingGoogleSignIn pending) {
        MockHttpSession session = new MockHttpSession();
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setSession(session);
        GoogleSignInSession.storePending(request, pending);
        return session;
    }

    private static PendingGoogleSignIn pending(String email) {
        return PendingGoogleSignIn.of("sub-" + UUID.randomUUID(), email, "Google User", Instant.now());
    }

    private static Authentication authenticationIn(HttpSession session) {
        assertThat(session).isNotNull();
        SecurityContext context = (SecurityContext) session
                .getAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY);
        return context == null ? null : context.getAuthentication();
    }

    private boolean isLinked(String subject) {
        return userIdentityRepository.existsByProviderAndProviderSubject(IdentityProvider.GOOGLE, subject);
    }

    // --- Login sayfası ve Google'a gidiş ---

    @Test
    void loginAndRegisterPagesShowTheGoogleButtonInTheirLanguage() throws Exception {
        mockMvc.perform(get("/en/login"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("href=\"/en/login/google\"")))
                .andExpect(content().string(containsString("Continue with Google")));
        mockMvc.perform(get("/tr/register"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("href=\"/tr/login/google\"")))
                .andExpect(content().string(containsString("Google ile devam et")));
    }

    @Test
    void startRemembersLanguageAndHandsOverToSpringSecurity() throws Exception {
        MvcResult result = mockMvc.perform(get("/tr/login/google"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/oauth2/authorization/google"))
                .andReturn();

        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setSession(result.getRequest().getSession(false));
        assertThat(GoogleSignInSession.lang(request)).isEqualTo("tr");
    }

    @Test
    void authorizationRequestAsksOnlyForIdentityScopesWithStateNonceAndPkce() throws Exception {
        MvcResult result = mockMvc.perform(get("/oauth2/authorization/google"))
                .andExpect(status().is3xxRedirection())
                .andReturn();

        String location = result.getResponse().getRedirectedUrl();
        assertThat(location).startsWith("https://accounts.google.com/o/oauth2/v2/auth?");
        UriComponents uri = UriComponentsBuilder.fromUriString(location).build();
        assertThat(uri.getQueryParams().getFirst("response_type")).isEqualTo("code");
        assertThat(uri.getQueryParams().getFirst("client_id")).isEqualTo(TEST_CLIENT_ID);
        assertThat(decode(uri.getQueryParams().getFirst("scope"))).isEqualTo("openid email profile");
        assertThat(decode(uri.getQueryParams().getFirst("redirect_uri")))
                .isEqualTo("http://localhost:8080/login/oauth2/code/google");
        assertThat(uri.getQueryParams().getFirst("state")).isNotBlank();
        assertThat(uri.getQueryParams().getFirst("nonce")).isNotBlank();
        assertThat(uri.getQueryParams().getFirst("code_challenge")).isNotBlank();
        assertThat(uri.getQueryParams().getFirst("code_challenge_method")).isEqualTo("S256");
        assertThat(location).doesNotContainIgnoringCase("gmail");
    }

    private static String decode(String value) {
        return java.net.URLDecoder.decode(value, java.nio.charset.StandardCharsets.UTF_8);
    }

    // --- Google'dan dönüş: hata yolları ---

    @Test
    void deniedConsentAtGoogleReturnsToLoginInTheStartingLanguage() throws Exception {
        MockHttpSession session = new MockHttpSession();
        mockMvc.perform(get("/tr/login/google").session(session));
        String state = stateFrom(mockMvc.perform(get("/oauth2/authorization/google").session(session)).andReturn());

        mockMvc.perform(get("/login/oauth2/code/google")
                        .param("error", "access_denied")
                        .param("state", state)
                        .session(session))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/tr/login?error=google_cancelled"));

        assertThat(authenticationIn(session)).isNull();
    }

    @Test
    void callbackWithoutAMatchingAuthorizationRequestFails() throws Exception {
        mockMvc.perform(get("/login/oauth2/code/google")
                        .param("code", "forged-code")
                        .param("state", "forged-state"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/en/login?error=google_failed"));
    }

    private static String stateFrom(MvcResult authorizationRedirect) {
        // Yönlendirme URL'inde yüzde-kodlu ("=" -> %3D); Google onu çözülmüş haliyle geri yollar.
        return decode(UriComponentsBuilder.fromUriString(authorizationRedirect.getResponse().getRedirectedUrl())
                .build().getQueryParams().getFirst("state"));
    }

    @Test
    void loginPageShowsLocalizedGoogleErrors() throws Exception {
        mockMvc.perform(get("/en/login").param("error", "google_cancelled"))
                .andExpect(content().string(containsString("Google sign-in was cancelled")));
        mockMvc.perform(get("/tr/login").param("error", "google_email_not_verified"))
                .andExpect(content().string(containsString("doğrulanmamış")));
        // Form login'in kendi hatası ve listede olmayan değerler genel mesaja düşer.
        mockMvc.perform(get("/en/login").param("error", ""))
                .andExpect(content().string(containsString("Invalid email or password.")));
        mockMvc.perform(get("/en/login").param("error", "auth.login.title"))
                .andExpect(content().string(containsString("Invalid email or password.")));
    }

    // --- Yeni hesap: Kullanım Koşulları onayı ---

    @Test
    void newGoogleUserSeesTermsPageAndNoAccountExistsYet() throws Exception {
        PendingGoogleSignIn pending = pending(randomEmail());

        mockMvc.perform(get("/en/login/google/complete").session(sessionWithPending(pending)))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("name=\"termsAccepted\"")))
                .andExpect(content().string(containsString(pending.email())));

        assertThat(userRepository.existsByEmail(pending.email())).isFalse();
    }

    @Test
    void rejectingTermsCreatesNoAccount() throws Exception {
        PendingGoogleSignIn pending = pending(randomEmail());
        MockHttpSession session = sessionWithPending(pending);

        mockMvc.perform(post("/en/login/google/terms").with(csrf()).session(session))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Accept the Terms of Use to create an account.")));

        assertThat(userRepository.existsByEmail(pending.email())).isFalse();
        assertThat(authenticationIn(session)).isNull();
    }

    @Test
    void termsFormRequiresCsrfToken() throws Exception {
        PendingGoogleSignIn pending = pending(randomEmail());

        mockMvc.perform(post("/en/login/google/terms")
                        .param("termsAccepted", "true")
                        .session(sessionWithPending(pending)))
                .andExpect(status().isForbidden());

        assertThat(userRepository.existsByEmail(pending.email())).isFalse();
    }

    @Test
    void acceptingTermsCreatesAccountSignsInWithFreshSessionAndCannotBeReplayed() throws Exception {
        PendingGoogleSignIn pending = pending(randomEmail());
        MockHttpSession session = sessionWithPending(pending);

        MvcResult result = mockMvc.perform(post("/tr/login/google/terms")
                        .param("termsAccepted", "true")
                        .with(csrf())
                        .session(session))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/tr"))
                .andReturn();

        User user = userRepository.findByEmail(pending.email()).orElseThrow();
        assertThat(user.getPasswordHash()).isNull();
        assertThat(user.getRole()).isEqualTo(Role.USER);
        assertThat(isLinked(pending.subject())).isTrue();

        // Eski session kapatıldı (session fixation), giriş yeni session'da.
        assertThat(session.isInvalid()).isTrue();
        HttpSession newSession = result.getRequest().getSession(false);
        Authentication authentication = authenticationIn(newSession);
        assertThat(authentication.getName()).isEqualTo(pending.email());
        assertThat(authentication.getAuthorities()).extracting(GrantedAuthority::getAuthority)
                .containsExactly("ROLE_USER");

        // Aynı formun tekrar gönderilmesi: bekleyen kimlik yok, ikinci hesap açılmaz.
        mockMvc.perform(post("/tr/login/google/terms")
                        .param("termsAccepted", "true")
                        .with(csrf())
                        .session(session))
                .andExpect(redirectedUrl("/tr/login?error=google_expired"));
        assertThat(userRepository.findAll().stream().filter(u -> u.getEmail().equals(pending.email()))).hasSize(1);

        // Navbar yerel görünen adı gösteriyor; ADMIN alanına girilemiyor.
        mockMvc.perform(get("/tr").session((MockHttpSession) newSession))
                .andExpect(content().string(containsString("Google User")));
        mockMvc.perform(get("/en/admin/questions").session((MockHttpSession) newSession))
                .andExpect(status().isForbidden());
    }

    @Test
    void cancellingCreatesNothingAndClearsPendingSignIn() throws Exception {
        PendingGoogleSignIn pending = pending(randomEmail());
        MockHttpSession session = sessionWithPending(pending);

        mockMvc.perform(post("/en/login/google/cancel").with(csrf()).session(session))
                .andExpect(redirectedUrl("/en/login?error=google_cancelled"));
        mockMvc.perform(get("/en/login/google/complete").session(session))
                .andExpect(redirectedUrl("/en/login?error=google_expired"));

        assertThat(userRepository.existsByEmail(pending.email())).isFalse();
    }

    @Test
    void expiredPendingSignInIsRejected() throws Exception {
        String email = randomEmail();
        PendingGoogleSignIn stale = PendingGoogleSignIn.of("sub-" + UUID.randomUUID(), email, "x",
                Instant.now().minus(PendingGoogleSignIn.TIME_TO_LIVE).minus(Duration.ofSeconds(5)));

        mockMvc.perform(post("/en/login/google/terms")
                        .param("termsAccepted", "true")
                        .with(csrf())
                        .session(sessionWithPending(stale)))
                .andExpect(redirectedUrl("/en/login?error=google_expired"));

        assertThat(userRepository.existsByEmail(email)).isFalse();
    }

    @Test
    void stepsWithoutAPendingSignInDoNothing() throws Exception {
        mockMvc.perform(get("/en/login/google/complete"))
                .andExpect(redirectedUrl("/en/login?error=google_expired"));
        mockMvc.perform(post("/en/login/google/link").param("password", "x").with(csrf()))
                .andExpect(redirectedUrl("/en/login?error=google_expired"));
    }

    // --- E-postası eşleşen mevcut hesap: şifreyle bağlama ---

    @Test
    void matchingEmailRequiresPasswordInsteadOfCreatingOrLinkingAutomatically() throws Exception {
        String email = randomEmail();
        userRegistrationService.register(email, "correct-password", "Existing");
        PendingGoogleSignIn pending = pending(email);
        MockHttpSession session = sessionWithPending(pending);

        mockMvc.perform(get("/en/login/google/complete").session(session))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("name=\"password\"")))
                .andExpect(content().string(not(containsString("name=\"termsAccepted\""))));

        // Koşul formu doğrudan gönderilse bile ikinci hesap açılmaz, bağlamaya döner.
        mockMvc.perform(post("/en/login/google/terms").param("termsAccepted", "true").with(csrf()).session(session))
                .andExpect(redirectedUrl("/en/login/google/complete"));

        assertThat(isLinked(pending.subject())).isFalse();
        assertThat(authenticationIn(session)).isNull();
    }

    @Test
    void wrongPasswordDoesNotLinkAndTooManyAttemptsEndTheFlow() throws Exception {
        String email = randomEmail();
        userRegistrationService.register(email, "correct-password", "Existing");
        PendingGoogleSignIn pending = pending(email);
        MockHttpSession session = sessionWithPending(pending);

        for (int attempt = 1; attempt < PendingGoogleSignIn.MAX_PASSWORD_ATTEMPTS; attempt++) {
            mockMvc.perform(post("/en/login/google/link").param("password", "wrong").with(csrf()).session(session))
                    .andExpect(status().isOk())
                    .andExpect(content().string(containsString("Incorrect password.")));
        }
        mockMvc.perform(post("/en/login/google/link").param("password", "wrong").with(csrf()).session(session))
                .andExpect(redirectedUrl("/en/login?error=google_link_locked"));

        // Kilitlendikten sonra doğru şifre de işe yaramaz -- akış baştan başlamalı.
        mockMvc.perform(post("/en/login/google/link").param("password", "correct-password").with(csrf()).session(session))
                .andExpect(redirectedUrl("/en/login?error=google_expired"));

        assertThat(isLinked(pending.subject())).isFalse();
        assertThat(authenticationIn(session)).isNull();
    }

    @Test
    void linkFormRequiresCsrfToken() throws Exception {
        String email = randomEmail();
        userRegistrationService.register(email, "correct-password", "Existing");
        PendingGoogleSignIn pending = pending(email);

        mockMvc.perform(post("/en/login/google/link")
                        .param("password", "correct-password")
                        .session(sessionWithPending(pending)))
                .andExpect(status().isForbidden());

        assertThat(isLinked(pending.subject())).isFalse();
    }

    @Test
    void correctPasswordLinksAndSignsInWithTheLocalUserRole() throws Exception {
        String email = randomEmail();
        userRegistrationService.register(email, "correct-password", "Existing User");
        PendingGoogleSignIn pending = pending(email);
        MockHttpSession session = sessionWithPending(pending);

        MvcResult result = mockMvc.perform(post("/tr/login/google/link")
                        .param("password", "correct-password")
                        .with(csrf())
                        .session(session))
                .andExpect(redirectedUrl("/tr"))
                .andReturn();

        assertThat(isLinked(pending.subject())).isTrue();
        assertThat(session.isInvalid()).isTrue();
        MockHttpSession newSession = (MockHttpSession) result.getRequest().getSession(false);
        Authentication authentication = authenticationIn(newSession);
        assertThat(authentication.getName()).isEqualTo(email);
        assertThat(authentication.getAuthorities()).extracting(GrantedAuthority::getAuthority)
                .containsExactly("ROLE_USER");
        mockMvc.perform(get("/en/admin/questions").session(newSession))
                .andExpect(status().isForbidden());

        // Şifreyle giriş de hâlâ çalışıyor.
        mockMvc.perform(post("/en/login").param("username", email).param("password", "correct-password").with(csrf()))
                .andExpect(redirectedUrl("/en"));
    }

    @Test
    void adminAccountCannotBeLinkedAndKeepsItsPasswordLogin() throws Exception {
        String email = randomEmail();
        User existing = userRegistrationService.register(email, "correct-password", "Existing Admin");
        existing.setRole(Role.ADMIN);
        userRepository.save(existing);
        PendingGoogleSignIn pending = pending(email);
        MockHttpSession session = sessionWithPending(pending);

        mockMvc.perform(post("/tr/login/google/link")
                        .param("password", "correct-password")
                        .with(csrf())
                        .session(session))
                .andExpect(redirectedUrl("/tr/login?error=google_link_unavailable"));

        assertThat(isLinked(pending.subject())).isFalse();
        assertThat(authenticationIn(session)).isNull();
        // Bekleyen kimlik silindi: aynı session'la tekrar denenemez.
        mockMvc.perform(post("/tr/login/google/link").param("password", "correct-password").with(csrf()).session(session))
                .andExpect(redirectedUrl("/tr/login?error=google_expired"));

        // Yöneticinin şifreyle girişi ve yetkisi değişmedi.
        MvcResult login = mockMvc.perform(post("/en/login")
                        .param("username", email).param("password", "correct-password").with(csrf()))
                .andExpect(redirectedUrl("/en"))
                .andReturn();
        mockMvc.perform(get("/en/admin/questions").session((MockHttpSession) login.getRequest().getSession(false)))
                .andExpect(status().isOk());
    }

    @Test
    void googleAccountLinkedToAnAdminDoesNotSignInThroughTheTermsStep() throws Exception {
        String email = randomEmail();
        userRegistrationService.register(email, "correct-password", "Promoted");
        PendingGoogleSignIn linked = pending(email);
        mockMvc.perform(post("/en/login/google/link").param("password", "correct-password").with(csrf())
                        .session(sessionWithPending(linked)))
                .andExpect(redirectedUrl("/en"));
        User promoted = userRepository.findByEmail(email).orElseThrow();
        promoted.setRole(Role.ADMIN);
        userRepository.save(promoted);

        // Aynı Google hesabı farklı (yeni) bir e-postayla bekliyor: "zaten bağlı" kısa yolu ADMIN'i açmamalı.
        PendingGoogleSignIn sameGoogleAccount =
                PendingGoogleSignIn.of(linked.subject(), randomEmail(), "x", Instant.now());
        MockHttpSession session = sessionWithPending(sameGoogleAccount);

        mockMvc.perform(post("/en/login/google/terms").param("termsAccepted", "true").with(csrf()).session(session))
                .andExpect(redirectedUrl("/en/login?error=google_link_unavailable"));

        assertThat(authenticationIn(session)).isNull();
        assertThat(userRepository.existsByEmail(sameGoogleAccount.email())).isFalse();
    }

    // --- Şifresiz (yalnızca Google) hesap ---

    @Test
    void googleOnlyAccountCannotSignInWithPasswordForm() throws Exception {
        PendingGoogleSignIn pending = pending(randomEmail());
        MockHttpSession session = sessionWithPending(pending);
        mockMvc.perform(post("/en/login/google/terms").param("termsAccepted", "true").with(csrf()).session(session))
                .andExpect(redirectedUrl("/en"));

        for (String password : new String[]{"", "null", "anything"}) {
            mockMvc.perform(post("/en/login").param("username", pending.email()).param("password", password).with(csrf()))
                    .andExpect(redirectedUrl("/en/login?error"));
        }
    }
}
