package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserRequest;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.Optional;

/**
 * Google girişinin callback'inde, ID token'ı Spring Security doğruladıktan SONRA
 * (imza, issuer, audience, süre, nonce) çağrılır ve Google kimliğini yerel hesaba eşler:
 * <ul>
 *   <li>Bu {@code sub} zaten bir hesaba bağlıysa: giriş o yerel hesapla, o hesabın
 *       yerel rolüyle tamamlanır ({@link LocalOidcUser}) -- o hesap ADMIN değilse. ADMIN
 *       hesabına bağlı bir Google kimliğiyle giriş reddedilir.</li>
 *   <li>Bağlı değilse ve Google e-postayı doğrulamamışsa: giriş reddedilir.</li>
 *   <li>Bağlı değilse ve e-postası eşleşen yerel hesap ADMIN ise: parola isteyen bağlama
 *       adımına geçilmeden, bağlı ADMIN ile aynı hatayla reddedilir.</li>
 *   <li>Aksi halde: {@link PendingGoogleSignInException} -- giriş tamamlanmaz, kullanıcı
 *       koşul onayına (yeni hesap) ya da şifreyle bağlamaya (e-postası eşleşen hesap)
 *       yönlendirilir.</li>
 * </ul>
 */
@Service
public class GoogleOidcUserService implements OAuth2UserService<OidcUserRequest, OidcUser> {

    public static final String EMAIL_NOT_VERIFIED = "google_email_not_verified";
    public static final String ADMIN_NOT_ALLOWED = "google_admin_not_allowed";

    private final OAuth2UserService<OidcUserRequest, OidcUser> delegate;
    private final GoogleAccountService googleAccountService;

    @Autowired
    public GoogleOidcUserService(GoogleAccountService googleAccountService) {
        this(new OidcUserService(), googleAccountService);
    }

    GoogleOidcUserService(OAuth2UserService<OidcUserRequest, OidcUser> delegate,
                          GoogleAccountService googleAccountService) {
        this.delegate = delegate;
        this.googleAccountService = googleAccountService;
    }

    @Override
    public OidcUser loadUser(OidcUserRequest userRequest) throws OAuth2AuthenticationException {
        OidcUser googleUser = delegate.loadUser(userRequest);
        String subject = googleUser.getSubject();

        Optional<User> linked = googleAccountService.findLinkedUser(subject);
        if (linked.isPresent()) {
            User user = linked.get();
            if (!GoogleAccountService.allowsGoogleSignIn(user)) {
                throw new OAuth2AuthenticationException(new OAuth2Error(ADMIN_NOT_ALLOWED));
            }
            return new LocalOidcUser(googleUser, user.getEmail(), GoogleAccountService.authoritiesOf(user));
        }

        String email = googleUser.getEmail();
        if (email == null || email.isBlank() || !Boolean.TRUE.equals(googleUser.getEmailVerified())) {
            throw new OAuth2AuthenticationException(new OAuth2Error(EMAIL_NOT_VERIFIED));
        }

        String normalizedEmail = UserRegistrationService.normalizeEmail(email);
        if (googleAccountService.isGoogleSignInBlockedForEmail(normalizedEmail)) {
            throw new OAuth2AuthenticationException(new OAuth2Error(ADMIN_NOT_ALLOWED));
        }

        throw new PendingGoogleSignInException(PendingGoogleSignIn.of(
                subject,
                normalizedEmail,
                googleUser.getFullName(),
                Instant.now()));
    }
}
