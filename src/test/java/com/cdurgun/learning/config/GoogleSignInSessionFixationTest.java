package com.cdurgun.learning.config;

import com.cdurgun.learning.domain.IdentityProvider;
import com.cdurgun.learning.repository.UserIdentityRepository;
import com.cdurgun.learning.repository.UserRepository;
import com.cdurgun.learning.service.GoogleOidcUserService;
import com.cdurgun.learning.service.LocalOidcUser;
import com.cdurgun.learning.service.PendingGoogleSignIn;
import com.cdurgun.learning.service.PendingGoogleSignInException;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.endpoint.OAuth2AccessTokenResponseClient;
import org.springframework.security.oauth2.client.endpoint.OAuth2AuthorizationCodeGrantRequest;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserRequest;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.core.OAuth2AccessToken;
import org.springframework.security.oauth2.core.endpoint.OAuth2AccessTokenResponse;
import org.springframework.security.oauth2.core.oidc.IdTokenClaimNames;
import org.springframework.security.oauth2.core.oidc.endpoint.OidcParameterNames;
import org.springframework.security.oauth2.core.oidc.user.DefaultOidcUser;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoderFactory;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.URI;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

/**
 * Google dönüşünde session ID'nin yenilenmesi (session fixation), gerçek Tomcat session'ları
 * ve çerezleriyle. Saldırgan kurbanın tarayıcısına bildiği bir session ID yerleştirdiyse,
 * Google'dan sonra o ID ile ne bekleyen kimliğe ne de oturuma ulaşılabilmeli.
 *
 * <p>Google'ın kendisi yerine test bean'leri: token uç noktası (ID token olarak isteğin
 * nonce'unu döner) ve ID token çözücü (imza yok, yalnızca claim'ler). Doğrulanmış kimliğin
 * yerel hesaba eşlenmesi mock -- o kısım {@code GoogleOidcUserServiceTest}'te. Spring
 * Security'nin state/nonce/redirect_uri kontrolleri, CSRF filtresi ve bizim handler'larımız
 * gerçek. CSRF token'ı da aynı nedenle yenilenmeli: sabitlenmiş session'da bir sayfa açan
 * saldırgan o session'ın token'ını bilir.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
@ActiveProfiles("test")
class GoogleSignInSessionFixationTest {

    private static final int PORT = freePort();
    private static final String BASE = "http://localhost:" + PORT;
    private static final Pattern CSRF_INPUT = Pattern.compile("name=\"_csrf\" value=\"([^\"]+)\"");

    private final HttpClient http = HttpClient.newBuilder().followRedirects(HttpClient.Redirect.NEVER).build();

    @MockitoBean
    private GoogleOidcUserService googleOidcUserService;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserIdentityRepository userIdentityRepository;

    /** redirect_uri {@code app.base-url}'den kurulur; callback'in geldiği adresle aynı olmalı. */
    @DynamicPropertySource
    static void serverAddress(DynamicPropertyRegistry registry) {
        registry.add("server.port", () -> PORT);
        registry.add("app.base-url", () -> BASE);
    }

    @TestConfiguration
    static class FakeGoogleEndpoints {

        @Bean
        OAuth2AccessTokenResponseClient<OAuth2AuthorizationCodeGrantRequest> fakeTokenEndpoint() {
            return grantRequest -> {
                String nonceHash = (String) grantRequest.getAuthorizationExchange().getAuthorizationRequest()
                        .getAdditionalParameters().get(OidcParameterNames.NONCE);
                return OAuth2AccessTokenResponse.withToken("test-access-token")
                        .tokenType(OAuth2AccessToken.TokenType.BEARER)
                        .expiresIn(300)
                        .scopes(Set.of("openid", "email", "profile"))
                        .additionalParameters(Map.of(OidcParameterNames.ID_TOKEN, nonceHash))
                        .build();
            };
        }

        @Bean
        JwtDecoderFactory<ClientRegistration> fakeIdTokenDecoder() {
            return registration -> nonceHash -> Jwt.withTokenValue(nonceHash)
                    .header("alg", "RS256")
                    .issuer("https://accounts.google.com")
                    .subject("google-subject")
                    .audience(List.of(registration.getClientId()))
                    .issuedAt(Instant.now())
                    .expiresAt(Instant.now().plusSeconds(300))
                    .claim(IdTokenClaimNames.NONCE, nonceHash)
                    .build();
        }
    }

    @Test
    void pendingGoogleSignInIsOnlyReachableFromARenewedSession() throws Exception {
        PendingGoogleSignIn pending = PendingGoogleSignIn.of("sub-" + UUID.randomUUID(),
                "google-fixation-" + UUID.randomUUID() + "@example.com", "Google User", Instant.now());
        when(googleOidcUserService.loadUser(any())).thenThrow(new PendingGoogleSignInException(pending));

        String fixedSession = startSignIn();
        HttpResponse<String> callback = returnFromGoogle(fixedSession);

        assertThat(callback.headers().firstValue("Location").orElseThrow()).endsWith("/tr/login/google/complete");
        String renewedSession = sessionCookie(callback);
        assertThat(renewedSession).isNotNull().isNotEqualTo(fixedSession);

        // Eski ID ile bekleyen kimlik görülemez ve koşul onayı verilemez.
        HttpResponse<String> withFixed = get("/tr/login/google/complete", fixedSession);
        assertThat(withFixed.statusCode()).isEqualTo(302);
        assertThat(withFixed.headers().firstValue("Location").orElseThrow()).endsWith("error=google_expired");

        // Yeni ID'de akış (ve başladığı dil) devam ediyor.
        HttpResponse<String> withRenewed = get("/tr/login/google/complete", renewedSession);
        assertThat(withRenewed.statusCode()).isEqualTo(200);
        assertThat(withRenewed.body()).contains("name=\"termsAccepted\"").contains(pending.email());
    }

    @Test
    void linkedGoogleSignInIsOnlyAuthenticatedInARenewedSession() throws Exception {
        when(googleOidcUserService.loadUser(any())).thenAnswer(invocation -> {
            OidcUserRequest request = invocation.getArgument(0);
            return new LocalOidcUser(new DefaultOidcUser(List.of(), request.getIdToken()),
                    "linked@example.com", List.of(new SimpleGrantedAuthority("ROLE_USER")));
        });

        String fixedSession = startSignIn();
        HttpResponse<String> callback = returnFromGoogle(fixedSession);

        assertThat(callback.headers().firstValue("Location").orElseThrow()).endsWith("/tr");
        String renewedSession = sessionCookie(callback);
        assertThat(renewedSession).isNotNull().isNotEqualTo(fixedSession);

        // Girişli bir USER admin alanında 403 alır; eski ID ise hâlâ anonim (login'e 302).
        assertThat(get("/en/admin/questions", renewedSession).statusCode()).isEqualTo(403);
        assertThat(get("/en/admin/questions", fixedSession).statusCode()).isEqualTo(302);
    }

    @Test
    void csrfTokenKnownBeforeGoogleIsRejectedAndOnlyTheNewOneCreatesTheAccount() throws Exception {
        PendingGoogleSignIn pending = PendingGoogleSignIn.of("sub-" + UUID.randomUUID(),
                "google-csrf-" + UUID.randomUUID() + "@example.com", "Google User", Instant.now());
        when(googleOidcUserService.loadUser(any())).thenThrow(new PendingGoogleSignInException(pending));

        // Saldırgan sabitlediği session'da bir sayfa açıp o session'ın CSRF token'ını öğrenir.
        String fixedSession = startSignIn();
        String knownToken = csrfTokenIn(get("/tr/login", fixedSession).body());
        String renewedSession = sessionCookie(returnFromGoogle(fixedSession));
        assertThat(renewedSession).isNotNull().isNotEqualTo(fixedSession);

        // Kurbanın tarayıcısı (yeni session çereziyle) eski token'lı bir form gönderse bile reddedilir.
        HttpResponse<String> forged = postTerms(renewedSession, knownToken);
        assertThat(forged.statusCode()).isEqualTo(403);
        assertThat(userRepository.existsByEmail(pending.email())).isFalse();
        // Eski session ile de olmaz.
        assertThat(postTerms(fixedSession, knownToken).statusCode()).isEqualTo(403);
        assertThat(userRepository.existsByEmail(pending.email())).isFalse();

        // Bekleyen giriş bundan etkilenmez: sayfa yeni bir token sunar ve onunla hesap açılır.
        HttpResponse<String> page = get("/tr/login/google/complete", renewedSession);
        assertThat(page.statusCode()).isEqualTo(200);
        String newToken = csrfTokenIn(page.body());
        HttpResponse<String> accepted = postTerms(renewedSession, newToken);
        assertThat(accepted.statusCode()).isEqualTo(302);
        assertThat(accepted.headers().firstValue("Location").orElseThrow()).endsWith("/tr");
        assertThat(userRepository.existsByEmail(pending.email())).isTrue();
        assertThat(userIdentityRepository.existsByProviderAndProviderSubject(IdentityProvider.GOOGLE, pending.subject()))
                .isTrue();
        String signedIn = sessionCookie(accepted);
        assertThat(get("/en/admin/questions", signedIn).statusCode()).isEqualTo(403);
    }

    private HttpResponse<String> postTerms(String session, String csrfToken) throws Exception {
        String form = "termsAccepted=true&_csrf=" + URLEncoder.encode(csrfToken, StandardCharsets.UTF_8);
        return http.send(HttpRequest.newBuilder(URI.create(BASE + "/tr/login/google/terms"))
                        .header("Cookie", "JSESSIONID=" + session)
                        .header("Content-Type", "application/x-www-form-urlencoded")
                        .POST(HttpRequest.BodyPublishers.ofString(form))
                        .build(),
                HttpResponse.BodyHandlers.ofString());
    }

    private static String csrfTokenIn(String html) {
        Matcher matcher = CSRF_INPUT.matcher(html);
        assertThat(matcher.find()).as("sayfada CSRF alanı").isTrue();
        return matcher.group(1);
    }

    /** Akışı başlatır; dönen session ID'yi saldırganın da bildiği varsayılır. */
    private String startSignIn() throws Exception {
        String session = sessionCookie(get("/tr/login/google", null));
        assertThat(session).isNotNull();
        return session;
    }

    /** Google'a gidiş ve kullanıcının izin verip dönmesi, aynı tarayıcı session'ıyla. */
    private HttpResponse<String> returnFromGoogle(String session) throws Exception {
        HttpResponse<String> toGoogle = get("/oauth2/authorization/google", session);
        String location = toGoogle.headers().firstValue("Location").orElseThrow();
        assertThat(location).startsWith("https://accounts.google.com/");
        assertThat(sessionCookie(toGoogle)).isNull();
        String state = URLDecoder.decode(UriComponentsBuilder.fromUriString(location).build()
                .getQueryParams().getFirst("state"), StandardCharsets.UTF_8);

        HttpResponse<String> callback = get("/login/oauth2/code/google?code=test-code&state="
                + URLEncoder.encode(state, StandardCharsets.UTF_8), session);
        assertThat(callback.statusCode()).isEqualTo(302);
        return callback;
    }

    private HttpResponse<String> get(String path, String session) throws Exception {
        HttpRequest.Builder request = HttpRequest.newBuilder(URI.create(BASE + path)).GET();
        if (session != null) {
            request.header("Cookie", "JSESSIONID=" + session);
        }
        return http.send(request.build(), HttpResponse.BodyHandlers.ofString());
    }

    private static String sessionCookie(HttpResponse<?> response) {
        return response.headers().allValues("Set-Cookie").stream()
                .filter(cookie -> cookie.startsWith("JSESSIONID="))
                .map(cookie -> cookie.substring("JSESSIONID=".length(), cookie.indexOf(';')))
                .findFirst().orElse(null);
    }

    private static int freePort() {
        try (ServerSocket socket = new ServerSocket(0)) {
            return socket.getLocalPort();
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }
}
