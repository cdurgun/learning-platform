package com.cdurgun.learning.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.CacheControl;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.resource.ResourceUrlEncodingFilter;
import org.springframework.web.servlet.resource.VersionResourceResolver;

import java.time.Duration;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    private final QuizIngestApiKeyInterceptor quizIngestApiKeyInterceptor;
    private final boolean cacheStaticResourceChain;

    public WebConfig(QuizIngestApiKeyInterceptor quizIngestApiKeyInterceptor,
                     @Value("${app.cache-static-resource-chain:true}") boolean cacheStaticResourceChain) {
        this.quizIngestApiKeyInterceptor = quizIngestApiKeyInterceptor;
        this.cacheStaticResourceChain = cacheStaticResourceChain;
    }

    /**
     * /css, /js ve /img uzun süreli önbelleğe alınır; önbelleğin bayatlamaması için
     * Thymeleaf'in {@code @{...}} ile ürettiği linkler içerik hash'i taşır
     * ({@code /css/custom-<hash>.css}) -- dosya değişince URL de değişir. Kök dizindeki
     * dosyalar (robots.txt, favicon.ico) BİLİNÇLİ OLARAK bu kapsamın dışında: adresleri
     * sabit olduğu için uzun süre önbelleğe alınmamalılar.
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        for (String dir : new String[]{"css", "js", "img"}) {
            registry.addResourceHandler("/" + dir + "/**")
                    .addResourceLocations("classpath:/static/" + dir + "/")
                    .setCacheControl(CacheControl.maxAge(Duration.ofDays(365)).cachePublic())
                    .resourceChain(cacheStaticResourceChain)
                    .addResolver(new VersionResourceResolver().addContentVersionStrategy("/**"));
        }
    }

    /** {@code @{/css/custom.css}} gibi linkleri hash'li adrese çeviren filtre. */
    @Bean
    public ResourceUrlEncodingFilter resourceUrlEncodingFilter() {
        return new ResourceUrlEncodingFilter();
    }

    @Bean
    public LocaleResolver localeResolver() {
        return new LangParamLocaleResolver();
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // Faz D: yalnızca AI ingestion rotası korunuyor -- diğer tüm rotalar
        // (topic/quiz/practice) genel kullanıcıya açık, bu interceptor'a tabi değil.
        registry.addInterceptor(quizIngestApiKeyInterceptor).addPathPatterns("/api/internal/**");
    }
}
