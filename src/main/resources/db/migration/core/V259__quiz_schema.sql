-- Quiz sorusu: bir topic + language'e bağlı, çoktan seçmeli soru metni ve açıklaması.
-- code_example ile aynı desen: topic'e FK, sort_order var ama üzerinde UNIQUE/DB kısıtı yok
-- (proje konvansiyonu: hiçbir sort_order kolonunda DB seviyesinde benzersizlik kısıtı yok).
CREATE TABLE quiz_question
(
    id          BIGSERIAL PRIMARY KEY,
    topic_id    BIGINT       NOT NULL REFERENCES topic (id) ON DELETE CASCADE,
    language    VARCHAR(5)   NOT NULL,
    question    TEXT         NOT NULL,
    explanation TEXT         NOT NULL,
    sort_order  INTEGER      NOT NULL DEFAULT 0
);

-- Quiz seçeneği: bir soruya bağlı, doğru/yanlış işaretli metin.
CREATE TABLE quiz_option
(
    id          BIGSERIAL PRIMARY KEY,
    question_id BIGINT       NOT NULL REFERENCES quiz_question (id) ON DELETE CASCADE,
    option_text TEXT         NOT NULL,
    is_correct  BOOLEAN      NOT NULL DEFAULT FALSE,
    sort_order  INTEGER      NOT NULL DEFAULT 0
);

CREATE INDEX idx_quiz_question_topic_lang ON quiz_question (topic_id, language);
CREATE INDEX idx_quiz_option_question ON quiz_option (question_id);

-- Kısmi (partial) unique index: bir soru için en fazla bir doğru seçenek olabilir.
-- is_correct = false olan satırlar bu kısıta tabi değil, dolayısıyla bir soruda
-- istenildiği kadar "yanlış" seçenek olabilir, ama "doğru" olan en fazla bir tane.
CREATE UNIQUE INDEX uq_quiz_option_one_correct_per_question
    ON quiz_option (question_id)
    WHERE is_correct = true;
