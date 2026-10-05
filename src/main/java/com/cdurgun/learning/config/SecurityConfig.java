package com.cdurgun.learning.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.DelegatingAuthenticationEntryPoint;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;
import org.springframework.security.web.servlet.util.matcher.PathPatternRequestMatcher;
import org.springframework.security.web.util.matcher.OrRequestMatcher;

import java.io.IOException;

/**
 * Session-based, form-login kimlik doğrulaması (bkz. auth planı bölüm "Authentication
 * architecture" — JWT/OAuth2 BİLİNÇLİ OLARAK kullanılmıyor, bu sunucu tarafında render
 * edilen bir Thymeleaf uygulaması). Anasayfa ve TÜM kursların ders içeriği (konu
 * sayfaları, PDF) anonim erişime açık; Java dışındaki kursların quiz'leri ve
 * Practice'i giriş gerektirir -- kural {@link CourseAccessPolicy}'de.
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

    private static final String LOGIN_PAGE = "/en/login";

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http, CourseAccessPolicy courseAccessPolicy) throws Exception {
        http
                .authorizeHttpRequests(authorize -> authorize
                        // Question Review (Faz A, henüz UI/controller'ı yok -- yalnızca kural
                        // önden hazır) -- CustomUserDetailsService zaten her girişli kullanıcıya
                        // "ROLE_" + role.name() authority'sini veriyor (bkz. Role enum'u,
                        // Faz 138'den beri var, hiç kullanılmıyordu), burada onu ilk kez
                        // kullanan tek kural. .anyRequest().permitAll()'dan ÖNCE gelmeli --
                        // Spring Security zincirinde ilk eşleşen kural kazanır.
                        .requestMatchers("/{lang:en|tr}/admin/**").hasRole("ADMIN")
                        // Course seviyesi quiz erişimi: anonim kullanıcı yalnızca Java kursunun,
                        // girişli kullanıcı tüm kursların quiz'lerine. Kural CourseAccessPolicy'de
                        // -- burada yalnızca course'u URL'den belirlenebilen rotalara bağlanıyor.
                        // Ders içeriğinin kendisi (topic sayfası + PDF) BİLİNÇLİ OLARAK bu kalıpların
                        // dışında, tüm kurslarda anonim okumaya açık (arama motorları dahil). topics
                        // kalıbı yalnızca sabit quiz submit'i kapsar; quiz kalıbı Quiz Area oynatma +
                        // submit'i kapsar, /{lang}/quiz kataloğu eşleşmez (yalnızca isim listeler).
                        // Course'u istek gövdesinden/havuzdan belirlenen Practice ve Quiz Area
                        // submit'in soru-id kontrolü PracticeService'te, AYNI policy ile.
                        .requestMatchers("/{lang:en|tr}/topics/{slug}/quiz/**")
                        .access(courseAccessPolicy.topicQuizAccess())
                        .requestMatchers("/{lang:en|tr}/quiz/{definitionSlug}", "/{lang:en|tr}/quiz/{definitionSlug}/**")
                        .access(courseAccessPolicy.quizDefinitionAccess())
                        // Geri kalan her şey (anasayfa, ders içeriği, Practice API -- course
                        // kontrolü serviste --, AI ingestion -- kendi X-Api-Key interceptor'ıyla
                        // zaten korunuyor) anonim erişime açık.
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
                // Korunan bir kaynağa anonim erişim: sayfalar login sayfasına 302 ile yönlenir
                // (formLogin'in varsayılanıyla aynı -- /admin/** dahil), ama JSON uç noktaları
                // (quiz.js'in fetch() ile çağırdığı submit'ler + Practice API) yönlendirme
                // yerine gövdesiz 401 alır -- aksi halde fetch() yönlendirmeyi sessizce takip
                // edip login HTML'ini 200 olarak alırdı. Varsayılan entry point AÇIKÇA login
                // sayfası olarak veriliyor: yalnızca defaultAuthenticationEntryPointFor(...)
                // eklemek, ilk kaydı (401) TÜM diğer istekler için varsayılan yapıyordu.
                .exceptionHandling(exceptions -> exceptions
                        .authenticationEntryPoint(DelegatingAuthenticationEntryPoint.builder()
                                .addEntryPointFor(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED),
                                        new OrRequestMatcher(
                                                PathPatternRequestMatcher.pathPattern("/{lang:en|tr}/topics/*/quiz/*/submit"),
                                                PathPatternRequestMatcher.pathPattern("/{lang:en|tr}/quiz/*/submit"),
                                                PathPatternRequestMatcher.pathPattern("/{lang:en|tr}/practice/submit"),
                                                PathPatternRequestMatcher.pathPattern("/{lang:en|tr}/practice")))
                                .defaultEntryPoint(new LoginUrlAuthenticationEntryPoint(LOGIN_PAGE))
                                .build()))
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED))
                .formLogin(form -> form
                        .loginPage(LOGIN_PAGE)
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
