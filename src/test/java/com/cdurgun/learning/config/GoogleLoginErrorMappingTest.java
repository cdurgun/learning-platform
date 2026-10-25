package com.cdurgun.learning.config;

import com.cdurgun.learning.service.GoogleOidcUserService;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Google dönüşündeki hata kodunun login sayfasındaki {@code ?error=} değerine çevrilmesi.
 * Gerçek Google dönüşü MockMvc'de taklit edilemediği için eşleme burada doğrudan sabitleniyor.
 */
class GoogleLoginErrorMappingTest {

    @Test
    void adminRejectionUsesTheGenericLinkUnavailableError() {
        assertThat(SecurityConfig.googleLoginError(GoogleOidcUserService.ADMIN_NOT_ALLOWED))
                .isEqualTo("google_link_unavailable");
        assertThat(GoogleOidcUserService.ADMIN_NOT_ALLOWED).isEqualTo("google_admin_not_allowed");
    }

    @Test
    void deniedConsentAtGoogleIsACancellation() {
        assertThat(SecurityConfig.googleLoginError("access_denied")).isEqualTo("google_cancelled");
    }

    @Test
    void unverifiedEmailAndUnknownCodesKeepTheirErrors() {
        assertThat(SecurityConfig.googleLoginError(GoogleOidcUserService.EMAIL_NOT_VERIFIED))
                .isEqualTo("google_email_not_verified");
        assertThat(SecurityConfig.googleLoginError("invalid_token_response")).isEqualTo("google_failed");
    }
}
