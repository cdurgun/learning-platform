package com.cdurgun.learning.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;

import java.io.IOException;

/**
 * Session-based, form-login kimlik doğrulaması (bkz. auth planı bölüm "Authentication
 * architecture" — JWT/OAuth2 BİLİNÇLİ OLARAK kullanılmıyor, bu sunucu tarafında render
 * edilen bir Thymeleaf uygulaması). Var olan kamuya açık öğrenim deneyimi (anasayfa,
 * kurs/kategori/konu sayfaları, mevcut quiz submit uç noktası) tamamen anonim erişime
 * açık kalır — kimlik doğrulama yalnızca login/register akışı için eklenen opsiyonel
 * bir katman, mevcut hiçbir rotanın önüne bir kapı KONMADI.
 *
 * <p>Login/register/logout URL'leri, projenin geri kalanıyla aynı desende
 * {@code {lang:en|tr}} path değişkeni taşır (bkz. CLAUDE.md "Mimari" — dil her zaman
 * path'te, query parametresi değil). Spring Security 6+'nın varsayılan
 * {@code PathPatternRequestMatcher}'ı MVC ile aynı {@code {lang:en|tr}} söz dizimini
 * desteklediği için {@code loginProcessingUrl}/{@code logoutUrl} de doğrudan bu
 * kalıpla verilebiliyor — ayrı bir wildcard/regex çözümüne gerek yok. Başarı/hata/
 * logout handler'ları, hangi dilin path'te geldiğini isteğin URI'sinden okuyup
 * yönlendirmeyi o dile göre kurar (bkz. {@link LangPath}).</p>
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(authorize -> authorize
                        // Şu an gated hiçbir öğrenim kaynağı yok -- kimlik doğrulama v1'de
                        // yalnızca opsiyonel bir yetenek. Var olan tüm rotalar (anasayfa,
                        // konu sayfaları, sabit quiz submit, PDF export, AI ingestion --
                        // kendi X-Api-Key interceptor'ıyla zaten korunuyor) anonim erişime açık.
                        .anyRequest().permitAll())
                .csrf(csrf -> csrf
                        // Bu dört uç nokta, anonim JSON POST'lar: ingestion n8n'den (tarayıcı
                        // session'ı yok) geliyor; sabit quiz submit'i ve Quiz Area submit'i
                        // (Faz 139) `quiz.js` düz `fetch()` ile çağırıyor ve hiçbir CSRF
                        // header'ı GÖNDERMİYOR -- CSRF koruması eklemek bunu GERÇEKTEN kırardı
                        // (403). Practice submit'in şu an hiç UI/istemcisi yok (saf bir JSON
                        // API -- bkz. PracticeController javadoc'u) ama aynı anonim/oturumsuz
                        // kullanım deseni beklendiği için aynı muafiyete eklendi. Ingest zaten
                        // kendi X-Api-Key mekanizmasıyla korunuyor; quiz/practice/Quiz Area
                        // submit'in hassas bir yan etkisi yok (bir cevabı puanlamaktan başka
                        // bir şey yapmıyor) -- bu yüzden CSRF'ten bilinçli olarak muaf tutuldu.
                        // Yeni bir anonim/oturumsuz POST API eklenirse aynı muafiyet listesine
                        // eklenmeli (bkz. CLAUDE.md "Mimari" bölümü).
                        .ignoringRequestMatchers(
                                "/api/internal/**",
                                "/{lang:en|tr}/topics/*/quiz/*/submit",
                                "/{lang:en|tr}/practice/submit",
                                "/{lang:en|tr}/quiz/*/submit"))
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED))
                .formLogin(form -> form
                        .loginPage("/en/login")
                        .loginProcessingUrl("/{lang:en|tr}/login")
                        .successHandler(loginSuccessHandler())
                        .failureHandler(loginFailureHandler())
                        .permitAll())
                .logout(logout -> logout
                        .logoutUrl("/{lang:en|tr}/logout")
                        .logoutSuccessHandler(logoutSuccessHandler())
                        .permitAll());

        return http.build();
    }

    private SimpleUrlAuthenticationSuccessHandler loginSuccessHandler() {
        SimpleUrlAuthenticationSuccessHandler handler = new SimpleUrlAuthenticationSuccessHandler() {
            @Override
            protected String determineTargetUrl(HttpServletRequest request, HttpServletResponse response) {
                return "/" + LangPath.extractLangOrDefault(request.getRequestURI());
            }
        };
        handler.setAlwaysUseDefaultTargetUrl(false);
        return handler;
    }

    private SimpleUrlAuthenticationFailureHandler loginFailureHandler() {
        return new SimpleUrlAuthenticationFailureHandler() {
            @Override
            public void onAuthenticationFailure(HttpServletRequest request,
                                                 HttpServletResponse response,
                                                 AuthenticationException exception) throws IOException {
                String lang = LangPath.extractLangOrDefault(request.getRequestURI());
                getRedirectStrategy().sendRedirect(request, response, "/" + lang + "/login?error");
            }
        };
    }

    private SimpleUrlLogoutSuccessHandler logoutSuccessHandler() {
        return new SimpleUrlLogoutSuccessHandler() {
            @Override
            protected String determineTargetUrl(HttpServletRequest request, HttpServletResponse response) {
                return "/" + LangPath.extractLangOrDefault(request.getRequestURI());
            }
        };
    }
}
