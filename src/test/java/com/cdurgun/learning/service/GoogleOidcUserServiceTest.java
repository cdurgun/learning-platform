package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.oidc.OidcIdToken;
import org.springframework.security.oauth2.core.oidc.user.DefaultOidcUser;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;

import java.time.Instant;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

/**
 * Doğrulanmış bir Google kimliğinin yerel hesaba eşlenmesi. ID token doğrulamasının
 * kendisi Spring Security'nin işi (delegate) -- burada yalnızca sonrası test ediliyor.
 */
@ExtendWith(MockitoExtension.class)
class GoogleOidcUserServiceTest {

    @Mock
    private OAuth2UserService<OidcUserRequest, OidcUser> delegate;
    @Mock
    private GoogleAccountService googleAccountService;
    @Mock
    private OidcUserRequest request;

    private GoogleOidcUserService newService() {
        return new GoogleOidcUserService(delegate, googleAccountService);
    }

    private static OidcUser googleUser(String sub, String email, Boolean emailVerified, Map<String, Object> extra) {
        Map<String, Object> claims = new HashMap<>(extra);
        claims.put("sub", sub);
        claims.put("iss", "https://accounts.google.com");
        if (email != null) {
            claims.put("email", email);
        }
        if (emailVerified != null) {
            claims.put("email_verified", emailVerified);
        }
        claims.put("name", "Ada Lovelace");
        OidcIdToken idToken = new OidcIdToken("id-token-value", Instant.now(), Instant.now().plusSeconds(60), claims);
        // Spring'in varsayılan yetkileri (OIDC_USER, SCOPE_*) -- bunlar ASLA geçmemeli.
        List<GrantedAuthority> googleAuthorities = List.of(
                new SimpleGrantedAuthority("OIDC_USER"), new SimpleGrantedAuthority("SCOPE_openid"));
        return new DefaultOidcUser(googleAuthorities, idToken);
    }

    private static User localUser(String email, Role role) {
        return User.builder().id(7L).email(email).displayName("Local").role(role).build();
    }

    @Test
    void linkedGoogleAccountSignsInAsLocalUserWithLocalRoleOnly() {
        OidcUser google = googleUser("sub-1", "changed-at-google@gmail.com", true, Map.of());
        when(delegate.loadUser(request)).thenReturn(google);
        when(googleAccountService.findLinkedUser("sub-1"))
                .thenReturn(Optional.of(localUser("local@example.com", Role.USER)));

        OidcUser principal = newService().loadUser(request);

        assertThat(principal).isInstanceOf(LocalOidcUser.class);
        // getName() yerel hesabın e-postası -- Google'daki e-posta ya da sub değil.
        assertThat(principal.getName()).isEqualTo("local@example.com");
        assertThat(principal.getAuthorities()).extracting(GrantedAuthority::getAuthority)
                .containsExactly("ROLE_USER");
    }

    @Test
    void googleAccountLinkedToAnAdminCannotSignIn() {
        when(delegate.loadUser(request)).thenReturn(googleUser("sub-6", "admin@gmail.com", true, Map.of()));
        when(googleAccountService.findLinkedUser("sub-6"))
                .thenReturn(Optional.of(localUser("admin@example.com", Role.ADMIN)));

        assertThatThrownBy(() -> newService().loadUser(request))
                .isInstanceOf(OAuth2AuthenticationException.class)
                .isNotInstanceOf(PendingGoogleSignInException.class)
                .satisfies(e -> assertThat(((OAuth2AuthenticationException) e).getError().getErrorCode())
                        .isEqualTo(GoogleOidcUserService.ADMIN_NOT_ALLOWED));
    }

    @Test
    void googleClaimsNeverGrantPrivileges() {
        OidcUser google = googleUser("sub-2", "user@gmail.com", true,
                Map.of("role", "ADMIN", "roles", List.of("ROLE_ADMIN")));
        when(delegate.loadUser(request)).thenReturn(google);
        when(googleAccountService.findLinkedUser("sub-2"))
                .thenReturn(Optional.of(localUser("user@gmail.com", Role.USER)));

        OidcUser principal = newService().loadUser(request);

        assertThat(principal.getAuthorities()).extracting(GrantedAuthority::getAuthority)
                .containsExactly("ROLE_USER");
    }

    @Test
    void unlinkedVerifiedAccountBecomesPendingWithoutSigningIn() {
        OidcUser google = googleUser("sub-3", "  New.User@Gmail.com ", true, Map.of());
        when(delegate.loadUser(request)).thenReturn(google);
        when(googleAccountService.findLinkedUser("sub-3")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> newService().loadUser(request))
                .isInstanceOfSatisfying(PendingGoogleSignInException.class, e -> {
                    PendingGoogleSignIn pending = e.getPending();
                    assertThat(pending.subject()).isEqualTo("sub-3");
                    assertThat(pending.email()).isEqualTo("new.user@gmail.com");
                    assertThat(pending.displayName()).isEqualTo("Ada Lovelace");
                    assertThat(pending.failedPasswordAttempts()).isZero();
                });
    }

    @Test
    void unverifiedEmailIsRejected() {
        when(delegate.loadUser(request)).thenReturn(googleUser("sub-4", "x@example.com", false, Map.of()));
        when(googleAccountService.findLinkedUser("sub-4")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> newService().loadUser(request))
                .isInstanceOf(OAuth2AuthenticationException.class)
                .isNotInstanceOf(PendingGoogleSignInException.class)
                .satisfies(e -> assertThat(((OAuth2AuthenticationException) e).getError().getErrorCode())
                        .isEqualTo(GoogleOidcUserService.EMAIL_NOT_VERIFIED));
    }

    @Test
    void missingEmailVerifiedClaimIsTreatedAsUnverified() {
        when(delegate.loadUser(request)).thenReturn(googleUser("sub-5", "x@example.com", null, Map.of()));
        when(googleAccountService.findLinkedUser("sub-5")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> newService().loadUser(request))
                .isInstanceOf(OAuth2AuthenticationException.class)
                .isNotInstanceOf(PendingGoogleSignInException.class);
    }

    @Test
    void pendingSignInExpiresAfterTimeToLive() {
        Instant start = Instant.parse("2026-10-22T10:00:00Z");
        PendingGoogleSignIn pending = PendingGoogleSignIn.of("s", "e@example.com", "n", start);

        assertThat(pending.isExpired(start.plus(PendingGoogleSignIn.TIME_TO_LIVE))).isFalse();
        assertThat(pending.isExpired(start.plus(PendingGoogleSignIn.TIME_TO_LIVE).plusSeconds(1))).isTrue();
    }
}
