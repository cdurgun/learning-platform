-- AI Tutor'un sağlayıcıya (DeepSeek) yaptığı HER çağrının kullanım/maliyet kaydı -- başarılı
-- da olsa başarısız da olsa (bkz. AiUsageRecorder, docs/deepseek-ai-tutor-plan.md §9-§10).
-- Kullanıcının sorusu, modelin cevabı, ders içeriği ve API anahtarı BİLİNÇLİ OLARAK burada
-- YOK: yalnızca boyutlar (input_chars, context_chars), token sayıları ve tahmini maliyet.
--
-- user_id ON DELETE SET NULL (CASCADE DEĞİL): bir hesap silinse de harcama kaydı kalmalı,
-- yoksa günlük/aylık bütçe toplamı geriye dönük olarak düşerdi. Kişisel bağ kopar, tutar kalır.
--
-- created_at UTC'dir (uygulama açıkça UTC yazar, bkz. AiUsageRecorder) -- bütçe günü/ayı ve
-- DeepSeek'in yoğun saat pencereleri UTC olduğu için JVM saat diliminden bağımsız olmalı.
--
-- estimated_cost_usd bizim TAHMİNİMİZDİR (AiCostCalculator, USD, 6 ondalık, yukarı
-- yuvarlanmış), sağlayıcının faturası değil. Hiçbir zaman NULL değildir: kullanım bilinmiyorsa
-- (usage_reported = false) en kötü durum tutarı yazılır, sıfır DEĞİL. Token kolonları yalnızca
-- sağlayıcının bildirdiği değerlerdir; bilinmiyorlarsa NULL kalırlar.
CREATE TABLE ai_usage_log
(
    id                       BIGSERIAL PRIMARY KEY,
    user_id                  BIGINT        REFERENCES app_user (id) ON DELETE SET NULL,
    feature                  VARCHAR(32)   NOT NULL,
    model                    VARCHAR(64)   NOT NULL,
    topic_slug               VARCHAR(255),
    language                 VARCHAR(5),
    created_at               TIMESTAMP     NOT NULL,
    duration_ms              INTEGER       NOT NULL,
    outcome                  VARCHAR(16)   NOT NULL,
    error_category           VARCHAR(32),
    truncated                BOOLEAN       NOT NULL,
    input_chars              INTEGER       NOT NULL,
    context_chars            INTEGER,
    usage_reported           BOOLEAN       NOT NULL,
    prompt_cache_hit_tokens  INTEGER,
    prompt_cache_miss_tokens INTEGER,
    completion_tokens        INTEGER,
    reasoning_tokens         INTEGER,
    estimated_cost_usd       NUMERIC(12, 6) NOT NULL,
    pricing_period           VARCHAR(16)   NOT NULL,
    pricing_version          VARCHAR(64)   NOT NULL,

    CONSTRAINT chk_ai_usage_log_non_negative CHECK (
        duration_ms >= 0 AND input_chars >= 0 AND (context_chars IS NULL OR context_chars >= 0)
            AND estimated_cost_usd >= 0
            AND (prompt_cache_hit_tokens IS NULL OR prompt_cache_hit_tokens >= 0)
            AND (prompt_cache_miss_tokens IS NULL OR prompt_cache_miss_tokens >= 0)
            AND (completion_tokens IS NULL OR completion_tokens >= 0)
            AND (reasoning_tokens IS NULL OR reasoning_tokens >= 0)),
    -- Sağlayıcı kullanımı bildirdiyse üç ana token sayısı vardır ve tutar o döneme göredir;
    -- bildirmediyse token sayıları yoktur ve tutar en kötü durumdur.
    CONSTRAINT chk_ai_usage_log_usage_consistency CHECK (
        (usage_reported AND prompt_cache_hit_tokens IS NOT NULL AND prompt_cache_miss_tokens IS NOT NULL
            AND completion_tokens IS NOT NULL AND pricing_period IN ('OFF_PEAK', 'PEAK'))
            OR (NOT usage_reported AND prompt_cache_hit_tokens IS NULL AND prompt_cache_miss_tokens IS NULL
            AND completion_tokens IS NULL AND reasoning_tokens IS NULL AND pricing_period = 'WORST_CASE')),
    CONSTRAINT chk_ai_usage_log_outcome CHECK (
        (outcome = 'SUCCESS' AND error_category IS NULL)
            OR (outcome = 'ERROR' AND error_category IS NOT NULL AND NOT truncated))
);

-- Uygulama geneli günlük/aylık toplam ve kullanıcı başına sorgular için.
CREATE INDEX idx_ai_usage_log_created ON ai_usage_log (created_at);
CREATE INDEX idx_ai_usage_log_user_created ON ai_usage_log (user_id, created_at);
