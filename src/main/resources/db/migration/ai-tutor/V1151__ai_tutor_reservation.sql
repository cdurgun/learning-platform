-- AI Tutor bütçe rezervasyonları (bkz. AiTutorGuard, AiReservationStore,
-- docs/deepseek-ai-tutor-plan.md §10). Sağlayıcıya gönderilmek üzere KABUL EDİLEN her istek,
-- gönderilmeden ÖNCE burada en kötü durum tutarıyla bir satır alır. Reddedilen istekler hiç
-- satır almaz.
--
-- Durumlar:
--   ACTIVE   istek sürüyor; tutarı bütçede sayılır, kullanıcının yeni isteğini engeller
--   SETTLED  çağrı bitti, gerçek tahmin ai_usage_log'a yazıldı (usage_log_id); bütçede artık
--            BU satır değil, log satırı sayılır
--   EXPIRED  expires_at geçti ama sonuç yazılmadı (instance çöktü, yazma başarısız oldu...);
--            sağlayıcı yine de ücretlendirmiş olabilir, bu yüzden tutarı bütçede SAYILMAYA DEVAM
--            EDER. Yalnızca kullanıcının kilidini bırakır. Geç gelen bir sonuç yine SETTLED yapabilir.
--   RELEASED sağlayıcıya kesinlikle hiç gönderilmedi; bütçede de saatlik sayaçta da sayılmaz
--
-- reserved_usd bir REZERVASYONDUR (AiCostCalculator.worstCase), harcanan tutar değil; harcama
-- tahmini yalnızca ai_usage_log.estimated_cost_usd'dadır.
--
-- user_id ON DELETE SET NULL: hesap silinse de açık/sonuçsuz rezervasyon bütçede kalır.
-- Zamanlar UTC (ai_usage_log ile aynı).
CREATE TABLE ai_tutor_reservation
(
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT         REFERENCES app_user (id) ON DELETE SET NULL,
    created_at      TIMESTAMP      NOT NULL,
    expires_at      TIMESTAMP      NOT NULL,
    input_chars     INTEGER        NOT NULL,
    reserved_usd    NUMERIC(12, 6) NOT NULL,
    pricing_version VARCHAR(64)    NOT NULL,
    status          VARCHAR(16)    NOT NULL,
    closed_at       TIMESTAMP,
    usage_log_id    BIGINT         REFERENCES ai_usage_log (id),

    CONSTRAINT chk_ai_tutor_reservation_values CHECK (
        input_chars >= 0 AND reserved_usd >= 0 AND expires_at > created_at),
    CONSTRAINT chk_ai_tutor_reservation_status CHECK (
        status IN ('ACTIVE', 'SETTLED', 'EXPIRED', 'RELEASED')),
    CONSTRAINT chk_ai_tutor_reservation_closed CHECK (
        (status = 'ACTIVE') = (closed_at IS NULL)),
    CONSTRAINT chk_ai_tutor_reservation_settled CHECK (
        (status = 'SETTLED') = (usage_log_id IS NOT NULL))
);

-- Kullanıcı başına aynı anda en fazla bir açık istek: uygulamadaki kilitli kontrolün veritabanı
-- seviyesindeki yedeği (birden fazla instance olsa da).
CREATE UNIQUE INDEX uq_ai_tutor_reservation_active_user ON ai_tutor_reservation (user_id)
    WHERE status = 'ACTIVE';

CREATE INDEX idx_ai_tutor_reservation_created ON ai_tutor_reservation (created_at);
CREATE INDEX idx_ai_tutor_reservation_user_created ON ai_tutor_reservation (user_id, created_at);
