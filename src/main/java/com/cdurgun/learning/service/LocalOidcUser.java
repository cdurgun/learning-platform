package com.cdurgun.learning.service;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.core.oidc.OidcIdToken;
import org.springframework.security.oauth2.core.oidc.OidcUserInfo;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;

import java.io.Serial;
import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * Google ile giriş yapmış ve bir yerel hesaba bağlı kullanıcının principal'ı. Uygulamanın
 * geri kalanı {@code authentication.getName()}'i YEREL hesabın e-postası sayar
 * ({@code GlobalModelAttributes}, Question Review'in {@code reviewedBy}'ı) -- Spring'in
 * varsayılanı ise Google'ın {@code sub}'ı olurdu. Yetkiler de YALNIZCA yerel
 * {@code app_user.role}'den gelir; Google'ın gönderdiği hiçbir claim yetki vermez.
 */
public final class LocalOidcUser implements OidcUser, Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private final OidcUser googleUser;
    private final String localEmail;
    private final List<GrantedAuthority> authorities;

    public LocalOidcUser(OidcUser googleUser, String localEmail, List<GrantedAuthority> authorities) {
        this.googleUser = googleUser;
        this.localEmail = localEmail;
        this.authorities = List.copyOf(authorities);
    }

    @Override
    public String getName() {
        return localEmail;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public Map<String, Object> getClaims() {
        return googleUser.getClaims();
    }

    @Override
    public OidcUserInfo getUserInfo() {
        return googleUser.getUserInfo();
    }

    @Override
    public OidcIdToken getIdToken() {
        return googleUser.getIdToken();
    }

    @Override
    public Map<String, Object> getAttributes() {
        return googleUser.getAttributes();
    }
}
