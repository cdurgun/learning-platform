package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.config.AiTutorProperties;
import tools.jackson.core.JacksonException;
import tools.jackson.databind.PropertyNamingStrategies;
import tools.jackson.databind.json.JsonMapper;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpTimeoutException;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

/**
 * DeepSeek'in OpenAI-uyumlu {@code POST /chat/completions} uç noktası (api-docs.deepseek.com,
 * 2026-10-27'de doğrulandı). Akış (stream) yok, araç yok, thinking HER İSTEKTE açıkça kapalı --
 * DeepSeek'te varsayılan açık ve {@code max_tokens} varsayılanı o modda 64K.
 *
 * <p><b>Süre sınırı toplam istektir:</b> DeepSeek yük altında yanıt başlıklarını gönderip
 * gövdeyi boş satırlarla 10 dakikaya kadar açık tutabiliyor; yalnızca bir okuma zaman aşımı
 * bunu yakalayamaz. Bu yüzden istek {@code sendAsync} ile gönderilip sonuç en fazla
 * {@code timeouts.total} beklenir, süre dolunca istek iptal edilir.</p>
 *
 * <p>Hiçbir şey loglanmaz; hata mesajları yalnızca kategori ve durum kodu taşır. Hata
 * yanıtlarının gövdesi okunmaz (DeepSeek bir hata gövdesi biçimi belgelemiyor). Yönlendirmeler
 * izlenmez -- {@code Authorization} başlığı başka bir adrese taşınmasın.</p>
 */
public class DeepSeekChatClient implements TutorModelClient {

    private static final String THINKING_DISABLED = "disabled";

    private final AiTutorProperties properties;
    private final HttpClient httpClient;
    private final URI endpoint;
    private final JsonMapper json = JsonMapper.builder()
            .propertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE)
            .build();

    public DeepSeekChatClient(AiTutorProperties properties) {
        this.properties = properties;
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(properties.timeouts().connect())
                .followRedirects(HttpClient.Redirect.NEVER)
                .build();
        this.endpoint = URI.create(properties.baseUrl().replaceAll("/+$", "") + "/chat/completions");
    }

    @Override
    public TutorCompletion complete(TutorPrompt prompt) {
        if (!properties.isUsable()) {
            throw new AiProviderException(AiErrorCategory.DISABLED, null);
        }
        HttpResponse<String> response = send(requestBody(prompt));
        int status = response.statusCode();
        if (status != 200) {
            throw new AiProviderException(categoryForStatus(status), status);
        }
        return parse(response.body());
    }

    private String requestBody(TutorPrompt prompt) {
        List<WireMessage> messages = prompt.messages().stream()
                .map(m -> new WireMessage(m.role().name().toLowerCase(Locale.ROOT), m.content()))
                .toList();
        ChatRequest request = new ChatRequest(properties.model(), messages,
                new Thinking(THINKING_DISABLED), properties.limits().maxOutputTokens(), false);
        return json.writeValueAsString(request);
    }

    private HttpResponse<String> send(String body) {
        Duration total = properties.timeouts().total();
        HttpRequest request = HttpRequest.newBuilder(endpoint)
                .timeout(total)
                .header("Authorization", "Bearer " + properties.apiKey())
                .header("Content-Type", "application/json")
                .header("Accept", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(body, StandardCharsets.UTF_8))
                .build();

        CompletableFuture<HttpResponse<String>> call =
                httpClient.sendAsync(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
        try {
            return call.get(total.toMillis(), TimeUnit.MILLISECONDS);
        } catch (TimeoutException e) {
            call.cancel(true);
            throw new AiProviderException(AiErrorCategory.TIMEOUT, null);
        } catch (InterruptedException e) {
            call.cancel(true);
            Thread.currentThread().interrupt();
            throw new AiProviderException(AiErrorCategory.NETWORK, null);
        } catch (ExecutionException e) {
            Throwable cause = e.getCause();
            if (cause instanceof HttpTimeoutException) {
                throw new AiProviderException(AiErrorCategory.TIMEOUT, null, null, cause);
            }
            if (cause instanceof IOException) {
                throw new AiProviderException(AiErrorCategory.NETWORK, null, null, cause);
            }
            throw new AiProviderException(AiErrorCategory.PROVIDER_ERROR, null, null, cause);
        }
    }

    static AiErrorCategory categoryForStatus(int status) {
        return switch (status) {
            case 400, 422 -> AiErrorCategory.INVALID_REQUEST;
            case 401 -> AiErrorCategory.AUTHENTICATION;
            case 402 -> AiErrorCategory.INSUFFICIENT_BALANCE;
            case 429 -> AiErrorCategory.RATE_LIMITED;
            case 503 -> AiErrorCategory.OVERLOADED;
            default -> AiErrorCategory.PROVIDER_ERROR;
        };
    }

    private TutorCompletion parse(String body) {
        ChatResponse response;
        try {
            // Baştaki boş satırlar (DeepSeek'in keep-alive'ı) JSON için yalnızca boşluktur.
            response = body == null ? null : json.readValue(body, ChatResponse.class);
        } catch (JacksonException e) {
            // Neden bilerek eklenmiyor: Jackson'ın mesajı yanıt gövdesinden parçalar içerebilir.
            throw new AiProviderException(AiErrorCategory.INVALID_RESPONSE, 200);
        }
        if (response == null) {
            throw new AiProviderException(AiErrorCategory.INVALID_RESPONSE, 200);
        }

        TutorUsage usage = toUsage(response.usage());
        if (response.choices() == null || response.choices().isEmpty() || response.choices().getFirst() == null) {
            throw new AiProviderException(AiErrorCategory.INVALID_RESPONSE, 200, usage, null);
        }
        Choice choice = response.choices().getFirst();
        String content = choice.message() == null ? null : choice.message().content();
        String finishReason = choice.finishReason() == null ? "" : choice.finishReason();

        return switch (finishReason) {
            case "stop", "length" -> {
                if (content == null || content.isBlank()) {
                    throw new AiProviderException(AiErrorCategory.INVALID_RESPONSE, 200, usage, null);
                }
                String model = response.model() == null ? properties.model() : response.model();
                yield new TutorCompletion(content, finishReason.equals("length"), model, usage);
            }
            case "content_filter" -> throw new AiProviderException(AiErrorCategory.CONTENT_FILTERED, 200, usage, null);
            // Plan §5: ai_unavailable (502), 503 "meşgul" ile aynı sayılmaz.
            case "insufficient_system_resource" -> throw new AiProviderException(AiErrorCategory.PROVIDER_ERROR, 200, usage, null);
            case "aborted" -> throw new AiProviderException(AiErrorCategory.PROVIDER_ERROR, 200, usage, null);
            // tool_calls (araç göndermiyoruz), boş ya da bilinmeyen bir neden.
            default -> throw new AiProviderException(AiErrorCategory.INVALID_RESPONSE, 200, usage, null);
        };
    }

    /**
     * Sağlayıcının token sayıları. Önbellek ayrımı yoksa tüm girdi önbellek dışı sayılır (maliyet
     * yüksek tarafta kalır). Eksik ya da negatif sayılar güvenilmez kabul edilir: {@code null}.
     */
    static TutorUsage toUsage(Usage usage) {
        if (usage == null || usage.completionTokens() == null) {
            return null;
        }
        Integer hit = usage.promptCacheHitTokens();
        Integer miss = usage.promptCacheMissTokens();
        if (hit == null && miss == null) {
            if (usage.promptTokens() == null) {
                return null;
            }
            hit = 0;
            miss = usage.promptTokens();
        } else {
            hit = hit == null ? 0 : hit;
            miss = miss == null ? 0 : miss;
        }
        Integer reasoning = usage.completionTokensDetails() == null
                ? null : usage.completionTokensDetails().reasoningTokens();
        if (hit < 0 || miss < 0 || usage.completionTokens() < 0 || (reasoning != null && reasoning < 0)) {
            return null;
        }
        return new TutorUsage(hit, miss, usage.completionTokens(), reasoning);
    }

    // DeepSeek'in kablo biçimi (snake_case, mapper'ın adlandırma stratejisiyle). Yalnızca
    // kullandığımız alanlar; bilinmeyen alanlar yok sayılır (Jackson 3 varsayılanı).

    record ChatRequest(String model, List<WireMessage> messages, Thinking thinking, int maxTokens, boolean stream) {
    }

    record WireMessage(String role, String content) {
    }

    record Thinking(String type) {
    }

    record ChatResponse(String model, List<Choice> choices, Usage usage) {
    }

    record Choice(WireMessage message, String finishReason) {
    }

    record Usage(Integer promptTokens,
                 Integer completionTokens,
                 Integer promptCacheHitTokens,
                 Integer promptCacheMissTokens,
                 CompletionTokensDetails completionTokensDetails) {
    }

    record CompletionTokensDetails(Integer reasoningTokens) {
    }
}
