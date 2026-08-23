package com.cdurgun.learning.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

/**
 * {@code /api/internal/**} altındaki ingestion rotasını korur -- proje henüz
 * Spring Security kullanmıyor (bkz. plan bölüm 6: tek bir internal endpoint için
 * bu bağımlılığı eklemek orantısız), bu yüzden minimal bir paylaşılan-sır
 * (shared-secret) kontrolü yeterli: n8n workflow'u {@code X-Api-Key} başlığıyla
 * çağırır, değer {@code quiz.ingest.api-key} (env: {@code QUIZ_INGEST_API_KEY})
 * ile birebir eşleşmeli. Karşılaştırma {@link MessageDigest#isEqual} ile sabit
 * zamanlı yapılır (timing attack'a karşı standart pratik).
 *
 * <p>Anahtar YAPILANDIRILMAMIŞSA (boş/prod'da unutulmuş) istekler REDDEDİLİR
 * (fail-closed) -- boş bir anahtarla "her isteği kabul et" gibi güvensiz bir
 * varsayılana asla düşülmez.</p>
 */
@Component
public class QuizIngestApiKeyInterceptor implements HandlerInterceptor {

    private static final String API_KEY_HEADER = "X-Api-Key";

    private final String configuredApiKey;

    public QuizIngestApiKeyInterceptor(@Value("${quiz.ingest.api-key:}") String configuredApiKey) {
        this.configuredApiKey = configuredApiKey;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws IOException {
        if (configuredApiKey == null || configuredApiKey.isBlank()) {
            response.sendError(HttpStatus.SERVICE_UNAVAILABLE.value(), "ingestion endpoint is not configured");
            return false;
        }

        String providedApiKey = request.getHeader(API_KEY_HEADER);
        if (providedApiKey == null || !constantTimeEquals(providedApiKey, configuredApiKey)) {
            response.sendError(HttpStatus.UNAUTHORIZED.value(), "missing or invalid " + API_KEY_HEADER);
            return false;
        }

        return true;
    }

    private static boolean constantTimeEquals(String a, String b) {
        return MessageDigest.isEqual(a.getBytes(StandardCharsets.UTF_8), b.getBytes(StandardCharsets.UTF_8));
    }
}
