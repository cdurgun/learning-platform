-- AI Judge otomatik yayınlama (auto-publish) girişiminin denetim kaydı. Bu satır
-- Question üzerindeki reviewed_by/reviewed_at/source alanlarının bir TEKRARI DEĞİL --
-- onlar sorunun NİHAİ durumunu tutar, bu tablo ise n8n'in her auto-publish DENEMESİNİ
-- (başarılı ya da başarısız) kendi çalıştırma bağlamıyla (run_id/model/reason) birlikte
-- kaydeder, question_id (var olan PK) üzerinden question'a bağlanır.
--
-- question_id ON DELETE CASCADE -- bu yalnızca bir denetim GÜNLÜĞÜ, quiz_question_link'in
-- ON DELETE RESTRICT'inin AKSİNE (bkz. core/V290) burada bir soruyu korumak gibi bir amaç
-- yok; zaten Question hiçbir zaman hard-delete edilmiyor (bkz. domain/Question.java), bu
-- satır fiilen hiç tetiklenmeyecek ama şema açısından doğru davranış budur.
--
-- Yinelenen (duplicate) yayınlamaya karşı FİZİKSEL ikinci bir güvenlik ağı: bir soru için
-- yalnızca TEK bir 'SUCCESS' satırına izin verilir (kısmi/partial unique index). Birincil
-- koruma zaten QuestionReviewService.transition()'ın PENDING_REVIEW-only geçiş kuralı
-- (409 Conflict) -- bu index onu bypass eden bir yarış durumuna (race condition) karşı
-- ikinci bir katman.
CREATE TABLE question_publish_log
(
    id            BIGSERIAL PRIMARY KEY,
    question_id   BIGINT       NOT NULL REFERENCES question (id) ON DELETE CASCADE,
    run_id        VARCHAR(255),
    model_name    VARCHAR(255),
    reason        TEXT,
    status        VARCHAR(20)  NOT NULL,
    error_message TEXT,
    published_at  TIMESTAMP,
    created_at    TIMESTAMP    NOT NULL
);

CREATE INDEX idx_question_publish_log_question ON question_publish_log (question_id);

CREATE UNIQUE INDEX uq_question_publish_log_success_question
    ON question_publish_log (question_id)
    WHERE status = 'SUCCESS';
