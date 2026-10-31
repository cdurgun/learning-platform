package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.config.AiTutorProperties;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.boot.test.system.CapturedOutput;
import org.springframework.boot.test.system.OutputCaptureExtension;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;

import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.assertj.core.api.Assertions.catchThrowableOfType;

/**
 * {@link DeepSeekChatClient}, yerel bir JDK {@link HttpServer} sahtesine karşı. Gerçek DeepSeek'e
 * hiçbir istek gitmez; yanıt örnekleri api-docs.deepseek.com'daki chat-completion şemasının
 * biçimindedir (2026-10-27).
 */
@ExtendWith(OutputCaptureExtension.class)
class DeepSeekChatClientTest {

    private static final String KEY = "sk-test-not-a-real-key";
    private static final JsonMapper JSON = JsonMapper.builder().build();

    private static final String DOCUMENTED_RESPONSE = """
            {
              "id": "930c60df-bf64-41c9-a88e-3ec75f81e00e",
              "object": "chat.completion",
              "created": 1730000000,
              "model": "deepseek-flash",
              "system_fingerprint": "fp_7a09fdf9c2",
              "choices": [{
                "index": 0,
                "message": {"role": "assistant", "content": "A **record** is a data carrier."},
                "logprobs": null,
                "finish_reason": "stop"
              }],
              "usage": {
                "prompt_tokens": 16,
                "completion_tokens": 10,
                "total_tokens": 26,
                "prompt_tokens_details": {"cached_tokens": 4},
                "prompt_cache_hit_tokens": 4,
                "prompt_cache_miss_tokens": 12,
                "completion_tokens_details": {"reasoning_tokens": 0}
              }
            }
            """;

    private HttpServer server;
    private ExecutorService executor;
    private final AtomicInteger requestCount = new AtomicInteger();
    private final AtomicReference<RecordedRequest> lastRequest = new AtomicReference<>();

    record RecordedRequest(String method, String path, Map<String, List<String>> headers, String body) {
    }

    @BeforeEach
    void startServer() throws IOException {
        server = HttpServer.create(new InetSocketAddress("127.0.0.1", 0), 0);
        executor = Executors.newCachedThreadPool();
        server.setExecutor(executor);
        server.start();
    }

    @AfterEach
    void stopServer() {
        server.stop(0);
        executor.shutdownNow();
    }

    private String baseUrl() {
        return "http://127.0.0.1:" + server.getAddress().getPort();
    }

    private void respond(int status, String body) {
        handle(exchange -> {
            byte[] bytes = body.getBytes(StandardCharsets.UTF_8);
            exchange.getResponseHeaders().add("Content-Type", "application/json");
            exchange.sendResponseHeaders(status, bytes.length == 0 ? -1 : bytes.length);
            if (bytes.length > 0) {
                try (OutputStream out = exchange.getResponseBody()) {
                    out.write(bytes);
                }
            }
            exchange.close();
        });
    }

    private void handle(HttpHandler handler) {
        server.createContext("/chat/completions", exchange -> {
            requestCount.incrementAndGet();
            String body = new String(exchange.getRequestBody().readAllBytes(), StandardCharsets.UTF_8);
            lastRequest.set(new RecordedRequest(exchange.getRequestMethod(), exchange.getRequestURI().getPath(),
                    Map.copyOf(exchange.getRequestHeaders()), body));
            handler.handle(exchange);
        });
    }

    static AiTutorProperties properties(String baseUrl, boolean enabled, String apiKey, Duration total) {
        AiTutorProperties.Rates rates = new AiTutorProperties.Rates(
                new BigDecimal("0.003"), new BigDecimal("0.15"), new BigDecimal("0.60"));
        return new AiTutorProperties(enabled, apiKey, baseUrl, "deepseek-flash",
                new AiTutorProperties.Timeouts(Duration.ofSeconds(2), total),
                new AiTutorProperties.Limits(1500, 4000, 60000, 8000, 6, 5, 30, 24000),
                new AiTutorProperties.Budget(new BigDecimal("1.00"), new BigDecimal("10.00"),
                        new BigDecimal("0.80"), new BigDecimal("0.5")),
                new AiTutorProperties.Pricing("test", rates, rates, List.of(), List.of()));
    }

    private DeepSeekChatClient client() {
        return client(Duration.ofSeconds(5));
    }

    private DeepSeekChatClient client(Duration total) {
        return new DeepSeekChatClient(properties(baseUrl(), true, KEY, total));
    }

    private static TutorPrompt prompt() {
        return new TutorPrompt(List.of(
                new TutorPrompt.Message(TutorPrompt.Role.SYSTEM, "You are a tutor."),
                new TutorPrompt.Message(TutorPrompt.Role.USER, "What is a record?"),
                new TutorPrompt.Message(TutorPrompt.Role.ASSISTANT, "A data carrier."),
                new TutorPrompt.Message(TutorPrompt.Role.USER, "Kısaca örnek verir misin?")));
    }

    private static String completion(String finishReason, String contentJson, String usageJson) {
        return """
                {"model":"deepseek-flash","choices":[{"index":0,
                 "message":{"role":"assistant","content":%s},"finish_reason":%s}]%s}
                """.formatted(contentJson, finishReason == null ? "null" : "\"" + finishReason + "\"",
                usageJson == null ? "" : ",\"usage\":" + usageJson);
    }

    private AiProviderException failure(Runnable call) {
        AiProviderException e = catchThrowableOfType(AiProviderException.class, call::run);
        assertThat(e).as("expected AiProviderException").isNotNull();
        assertNoSecret(e);
        return e;
    }

    private static void assertNoSecret(Throwable e) {
        for (Throwable t = e; t != null; t = t.getCause()) {
            assertThat(String.valueOf(t.getMessage())).doesNotContain(KEY);
            assertThat(t.toString()).doesNotContain(KEY);
        }
    }

    // --- request contract ---

    @Test
    void sendsTheDocumentedRequest() {
        respond(200, DOCUMENTED_RESPONSE);

        client().complete(prompt());

        RecordedRequest request = lastRequest.get();
        assertThat(request.method()).isEqualTo("POST");
        assertThat(request.path()).isEqualTo("/chat/completions");
        assertThat(request.headers().get("Authorization")).containsExactly("Bearer " + KEY);
        assertThat(request.headers().get("Content-type")).containsExactly("application/json");

        JsonNode body = JSON.readTree(request.body());
        List<String> fields = new ArrayList<>(body.propertyNames());
        assertThat(fields).containsExactlyInAnyOrder("model", "messages", "thinking", "max_tokens", "stream");
        assertThat(body.get("model").asString()).isEqualTo("deepseek-flash");
        assertThat(body.get("thinking").get("type").asString()).isEqualTo("disabled");
        assertThat(body.get("max_tokens").asInt()).isEqualTo(1500);
        assertThat(body.get("stream").asBoolean()).isFalse();

        JsonNode messages = body.get("messages");
        assertThat(messages).hasSize(4);
        assertThat(messages.get(0).get("role").asString()).isEqualTo("system");
        assertThat(messages.get(1).get("role").asString()).isEqualTo("user");
        assertThat(messages.get(2).get("role").asString()).isEqualTo("assistant");
        assertThat(messages.get(3).get("content").asString()).isEqualTo("Kısaca örnek verir misin?");
        assertThat(request.body()).doesNotContain(KEY);
    }

    @Test
    void trailingSlashInBaseUrlStillHitsTheEndpoint() {
        respond(200, DOCUMENTED_RESPONSE);
        new DeepSeekChatClient(properties(baseUrl() + "/", true, KEY, Duration.ofSeconds(5))).complete(prompt());
        assertThat(lastRequest.get().path()).isEqualTo("/chat/completions");
    }

    @Test
    void disabledTutorNeverCallsTheProvider() {
        respond(200, DOCUMENTED_RESPONSE);
        AiProviderException e = failure(() ->
                new DeepSeekChatClient(properties(baseUrl(), false, KEY, Duration.ofSeconds(5))).complete(prompt()));
        assertThat(e.getCategory()).isEqualTo(AiErrorCategory.DISABLED);

        AiProviderException noKey = failure(() ->
                new DeepSeekChatClient(properties(baseUrl(), true, " ", Duration.ofSeconds(5))).complete(prompt()));
        assertThat(noKey.getCategory()).isEqualTo(AiErrorCategory.DISABLED);
        assertThat(requestCount).hasValue(0);
    }

    // --- successful responses ---

    @Test
    void parsesTheDocumentedResponse() {
        respond(200, DOCUMENTED_RESPONSE);

        TutorCompletion completion = client().complete(prompt());

        assertThat(completion.content()).isEqualTo("A **record** is a data carrier.");
        assertThat(completion.truncated()).isFalse();
        assertThat(completion.model()).isEqualTo("deepseek-flash");
        assertThat(completion.usage()).isEqualTo(new TutorUsage(4, 12, 10, 0));
    }

    @Test
    void leadingKeepAliveBlankLinesAreIgnored() {
        respond(200, "\n\n\n" + DOCUMENTED_RESPONSE);
        assertThat(client().complete(prompt()).content()).isEqualTo("A **record** is a data carrier.");
    }

    @Test
    void lengthFinishReasonIsReturnedAsTruncated() {
        respond(200, completion("length", "\"Half an answ\"",
                "{\"prompt_tokens\":5,\"completion_tokens\":1500,\"prompt_cache_hit_tokens\":0,\"prompt_cache_miss_tokens\":5}"));
        TutorCompletion completion = client().complete(prompt());
        assertThat(completion.truncated()).isTrue();
        assertThat(completion.content()).isEqualTo("Half an answ");
    }

    @Test
    void missingCacheSplitCountsAllPromptTokensAsMisses() {
        respond(200, completion("stop", "\"ok\"", "{\"prompt_tokens\":40,\"completion_tokens\":3}"));
        assertThat(client().complete(prompt()).usage()).isEqualTo(new TutorUsage(0, 40, 3, null));
    }

    // Thinking kapalıyken DeepSeek reasoning sayısını hiç göndermeyebilir: yokluk 0 değil null'dır.
    @ParameterizedTest
    @CsvSource(delimiter = '|', nullValues = "NULL", value = {
            "                                                | NULL",
            ",\"completion_tokens_details\":null               | NULL",
            ",\"completion_tokens_details\":{}                 | NULL",
            ",\"completion_tokens_details\":{\"reasoning_tokens\":null} | NULL",
            ",\"completion_tokens_details\":{\"reasoning_tokens\":0}    | 0",
            ",\"completion_tokens_details\":{\"reasoning_tokens\":37}   | 37"})
    void reasoningTokensAreReportedExactlyAsSent(String details, Integer expected) {
        respond(200, completion("stop", "\"ok\"", "{\"prompt_tokens\":5,\"completion_tokens\":3,"
                + "\"prompt_cache_hit_tokens\":0,\"prompt_cache_miss_tokens\":5" + (details == null ? "" : details) + "}"));
        assertThat(client().complete(prompt()).usage()).isEqualTo(new TutorUsage(0, 5, 3, expected));
    }

    @Test
    void missingOrBrokenUsageIsReportedAsUnknown() {
        respond(200, completion("stop", "\"ok\"", null));
        assertThat(client().complete(prompt()).usage()).isNull();
    }

    @Test
    void negativeUsageIsNotTrusted() {
        respond(200, completion("stop", "\"ok\"",
                "{\"prompt_tokens\":5,\"completion_tokens\":-1,\"prompt_cache_hit_tokens\":0,\"prompt_cache_miss_tokens\":5}"));
        assertThat(client().complete(prompt()).usage()).isNull();
    }

    // --- HTTP errors ---

    @ParameterizedTest
    @CsvSource({
            "400, INVALID_REQUEST",
            "401, AUTHENTICATION",
            "402, INSUFFICIENT_BALANCE",
            "404, PROVIDER_ERROR",
            "422, INVALID_REQUEST",
            "429, RATE_LIMITED",
            "500, PROVIDER_ERROR",
            "503, OVERLOADED"
    })
    void httpErrorsMapToCategoriesWithoutProviderDetails(int status, AiErrorCategory expected) {
        respond(status, "{\"error\":{\"message\":\"provider internal detail\",\"type\":\"x\"}}");

        AiProviderException e = failure(() -> client().complete(prompt()));

        assertThat(e.getCategory()).isEqualTo(expected);
        assertThat(e.getHttpStatus()).isEqualTo(status);
        assertThat(e.getMessage()).doesNotContain("provider internal detail");
    }

    @Test
    void redirectsAreNotFollowed() {
        AtomicInteger redirected = new AtomicInteger();
        server.createContext("/elsewhere", exchange -> {
            redirected.incrementAndGet();
            exchange.sendResponseHeaders(200, -1);
            exchange.close();
        });
        handle(exchange -> {
            exchange.getResponseHeaders().add("Location", baseUrl() + "/elsewhere");
            exchange.sendResponseHeaders(302, -1);
            exchange.close();
        });

        AiProviderException e = failure(() -> client().complete(prompt()));

        assertThat(e.getCategory()).isEqualTo(AiErrorCategory.PROVIDER_ERROR);
        assertThat(redirected).hasValue(0);
    }

    // --- finish reasons that are not an answer ---

    @ParameterizedTest
    @CsvSource({
            "content_filter, CONTENT_FILTERED",
            "insufficient_system_resource, PROVIDER_ERROR",
            "aborted, PROVIDER_ERROR",
            "tool_calls, INVALID_RESPONSE",
            "something_new, INVALID_RESPONSE"
    })
    void nonAnswerFinishReasonsFailButKeepUsage(String finishReason, AiErrorCategory expected) {
        respond(200, completion(finishReason, "\"partial\"",
                "{\"prompt_tokens\":7,\"completion_tokens\":2,\"prompt_cache_hit_tokens\":0,\"prompt_cache_miss_tokens\":7}"));

        AiProviderException e = failure(() -> client().complete(prompt()));

        assertThat(e.getCategory()).isEqualTo(expected);
        assertThat(e.getUsage()).isEqualTo(new TutorUsage(0, 7, 2, null));
    }

    // --- malformed or incomplete responses ---

    @ParameterizedTest
    @ValueSource(strings = {
            "not json at all",
            "null",
            "{}",
            "{\"choices\":[]}",
            "{\"choices\":[null]}",
            "{\"choices\":[{\"finish_reason\":\"stop\"}]}",
            "{\"choices\":[{\"message\":{\"role\":\"assistant\",\"content\":null},\"finish_reason\":\"stop\"}]}",
            "{\"choices\":[{\"message\":{\"role\":\"assistant\",\"content\":\"   \"},\"finish_reason\":\"stop\"}]}",
            "{\"choices\":[{\"message\":{\"role\":\"assistant\",\"content\":\"ok\"},\"finish_reason\":null}]}",
            "{\"choices\":[{\"message\":{\"content\":\"ok\"},\"finish_reason\":\"stop\"}"
    })
    void malformedResponsesAreInvalid(String body) {
        respond(200, body);
        assertThat(failure(() -> client().complete(prompt())).getCategory())
                .isEqualTo(AiErrorCategory.INVALID_RESPONSE);
    }

    @Test
    void emptyBodyIsInvalid() {
        respond(200, "");
        assertThat(failure(() -> client().complete(prompt())).getCategory())
                .isEqualTo(AiErrorCategory.INVALID_RESPONSE);
    }

    @Test
    void invalidResponseNeverEchoesTheBody() {
        respond(200, "<html>upstream proxy page with secret-ish text</html>");
        AiProviderException e = failure(() -> client().complete(prompt()));
        assertThat(e.getCause()).isNull();
        assertThat(e.getMessage()).doesNotContain("secret-ish");
    }

    // --- timeouts and network ---

    @Test
    void noResponseHeadersTimesOut() {
        handle(exchange -> {
            try {
                Thread.sleep(10_000);
            } catch (InterruptedException ignored) {
                Thread.currentThread().interrupt();
            }
            exchange.close();
        });

        long start = System.nanoTime();
        AiProviderException e = failure(() -> client(Duration.ofMillis(500)).complete(prompt()));

        assertThat(e.getCategory()).isEqualTo(AiErrorCategory.TIMEOUT);
        assertThat(Duration.ofNanos(System.nanoTime() - start)).isLessThan(Duration.ofSeconds(4));
    }

    @Test
    void keepAliveTrickleAfterHeadersStillHitsTheTotalDeadline() {
        handle(exchange -> {
            exchange.sendResponseHeaders(200, 0);
            OutputStream out = exchange.getResponseBody();
            try {
                while (!Thread.currentThread().isInterrupted()) {
                    out.write('\n');
                    out.flush();
                    Thread.sleep(50);
                }
            } catch (IOException | InterruptedException ignored) {
                // client gave up or server is stopping
            } finally {
                exchange.close();
            }
        });

        long start = System.nanoTime();
        AiProviderException e = failure(() -> client(Duration.ofMillis(800)).complete(prompt()));

        assertThat(e.getCategory()).isEqualTo(AiErrorCategory.TIMEOUT);
        assertThat(Duration.ofNanos(System.nanoTime() - start)).isLessThan(Duration.ofSeconds(4));
    }

    @Test
    void unreachableHostIsANetworkError() throws IOException {
        int closedPort;
        try (ServerSocket socket = new ServerSocket(0)) {
            closedPort = socket.getLocalPort();
        }
        DeepSeekChatClient client = new DeepSeekChatClient(
                properties("http://127.0.0.1:" + closedPort, true, KEY, Duration.ofSeconds(2)));

        assertThat(failure(() -> client.complete(prompt())).getCategory()).isEqualTo(AiErrorCategory.NETWORK);
    }

    // --- secrets ---

    @Test
    void theApiKeyNeverReachesLogsOrExceptions(CapturedOutput output) {
        respond(401, "{\"error\":{\"message\":\"Authentication Fails, Your api key: " + KEY + " is invalid\"}}");
        AiProviderException e = failure(() -> client().complete(prompt()));
        assertThat(e.getCategory()).isEqualTo(AiErrorCategory.AUTHENTICATION);

        assertThatThrownBy(() -> new DeepSeekChatClient(
                properties(baseUrl(), false, KEY, Duration.ofSeconds(1))).complete(prompt()))
                .isInstanceOf(AiProviderException.class);

        assertThat(output).doesNotContain(KEY);
    }
}
