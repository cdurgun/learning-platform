package com.cdurgun.learning.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    private final QuizIngestApiKeyInterceptor quizIngestApiKeyInterceptor;

    public WebConfig(QuizIngestApiKeyInterceptor quizIngestApiKeyInterceptor) {
        this.quizIngestApiKeyInterceptor = quizIngestApiKeyInterceptor;
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
