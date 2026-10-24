package com.cdurgun.learning.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.oauth2.client.CommonOAuth2Provider;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
import org.springframework.util.Assert;

/**
 * "Google ile devam et" istemcisi. Boot'un {@code spring.security.oauth2.client.*}
 * özellikleri BİLİNÇLİ OLARAK kullanılmıyor: o yol boş bir client-id ile uygulamanın
 * açılmasını engellerdi. Burada {@code GOOGLE_CLIENT_ID} verilmemişse (dev, CI) istemci
 * hiç kaydedilmez -- {@link SecurityConfig} Google girişini kurmaz, login sayfası butonu
 * göstermez; şifreyle giriş aynen çalışır.
 *
 * <p>Kapsam yalnızca {@code openid email profile} (Gmail vb. hiçbir API erişimi yok).
 * Redirect URI sabit olarak {@code app.base-url}'den kurulur (bkz. CLAUDE.md "mutlak URL
 * her zaman app.base-url") -- Google Cloud Console'a kaydedilen adresle birebir aynı
 * olmalı. Gizli istemci olmasına rağmen PKCE de açık (derinlemesine savunma).</p>
 */
@Configuration
public class GoogleSignInConfig {

    public static final String REGISTRATION_ID = "google";
    public static final String AUTHORIZATION_PATH = "/oauth2/authorization/" + REGISTRATION_ID;
    public static final String CALLBACK_PATH = "/login/oauth2/code/" + REGISTRATION_ID;

    @Bean
    @ConditionalOnExpression("!'${app.auth.google.client-id:}'.isBlank()")
    public ClientRegistrationRepository googleClientRegistrationRepository(
            @Value("${app.auth.google.client-id}") String clientId,
            @Value("${app.auth.google.client-secret:}") String clientSecret,
            @Value("${app.base-url}") String baseUrl) {
        Assert.hasText(clientSecret,
                "GOOGLE_CLIENT_ID verilmiş ama GOOGLE_CLIENT_SECRET boş -- ikisi birlikte ayarlanmalı");

        ClientRegistration google = CommonOAuth2Provider.GOOGLE.getBuilder(REGISTRATION_ID)
                .clientId(clientId)
                .clientSecret(clientSecret)
                .scope("openid", "email", "profile")
                .redirectUri(baseUrl + CALLBACK_PATH)
                .clientSettings(ClientRegistration.ClientSettings.builder().requireProofKey(true).build())
                .build();
        return new InMemoryClientRegistrationRepository(google);
    }
}
