package com.cdurgun.learning.config;

import com.cdurgun.learning.service.ai.AiErrorCategory;
import com.cdurgun.learning.service.ai.AiProviderException;
import com.cdurgun.learning.service.ai.DeepSeekChatClient;
import com.cdurgun.learning.service.ai.TutorModelClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

/**
 * AI Tutor yapılandırmasını uygulamanın açılışından YALITIR: {@code ai.tutor.*} geçersizse
 * LearnForgeX normal açılır, tutor kapalı kalır ve tek bir temizlenmiş uyarı loglanır
 * (bkz. {@link AiTutorSettings}). Uyarıda yalnızca özellik adları ve kısıt mesajları var,
 * hiçbir değer -- API anahtarı dahil -- yok.
 */
@Configuration
public class AiTutorConfig {

    private static final Logger log = LoggerFactory.getLogger(AiTutorConfig.class);

    @Bean
    public AiTutorSettings aiTutorSettings(Environment environment) {
        AiTutorSettings settings = AiTutorSettings.load(environment);
        if (!settings.isValid()) {
            log.warn("AI Tutor disabled: invalid configuration -- {}", String.join("; ", settings.problems()));
        } else if (settings.properties().orElseThrow().enabled() && !settings.isUsable()) {
            log.warn("AI Tutor disabled: ai.tutor.enabled is true but no API key is configured (DEEPSEEK_API_KEY)");
        }
        return settings;
    }

    /**
     * Yapılandırma geçerliyse DeepSeek istemcisi; değilse hiçbir yere bağlanmayan ve her çağrıda
     * {@link AiErrorCategory#DISABLED} fırlatan bir istemci (AiTutorGuard zaten önce reddeder).
     * İstemci kurulurken ağa çıkılmaz; anahtar ve bayrak her çağrıda yeniden kontrol edilir.
     */
    @Bean
    public TutorModelClient tutorModelClient(AiTutorSettings settings) {
        return settings.properties()
                .<TutorModelClient>map(DeepSeekChatClient::new)
                .orElseGet(() -> prompt -> {
                    throw new AiProviderException(AiErrorCategory.DISABLED, null);
                });
    }
}
