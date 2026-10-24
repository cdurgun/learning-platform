package com.cdurgun.learning.service;

import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.OAuth2Error;

/**
 * Google kimliği doğrulandı ama bağlı bir yerel hesap yok. Bilinçli olarak bir
 * kimlik doğrulama HATASI olarak fırlatılır: böylece Spring Security bu kullanıcı için
 * hiçbir {@code SecurityContext} kurmaz ve session'a kaydetmez. Failure handler bekleyen
 * kimliği session'a koyup kullanıcıyı koşul onayı ya da hesap bağlama adımına yönlendirir
 * (bkz. {@code SecurityConfig}, {@code GoogleSignInController}).
 */
public class PendingGoogleSignInException extends OAuth2AuthenticationException {

    public static final String ERROR_CODE = "google_account_pending";

    private final PendingGoogleSignIn pending;

    public PendingGoogleSignInException(PendingGoogleSignIn pending) {
        super(new OAuth2Error(ERROR_CODE));
        this.pending = pending;
    }

    public PendingGoogleSignIn getPending() {
        return pending;
    }
}
