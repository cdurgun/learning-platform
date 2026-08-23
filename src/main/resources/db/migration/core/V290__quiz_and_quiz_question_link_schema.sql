-- Soru havuzu yeniden tasarımının 4. adımı (Faz B). "Sabit quiz" artık kendi
-- tablosuna sahip: bir Quiz, bir topic+language'e bağlı, isimlendirilmiş (slug),
-- KÜRE edilmiş (curated) bir soru KÜMESİ. quiz_question_link, hangi Question'ların
-- hangi Quiz'e, hangi sırada (position) ait olduğunu tutan saf bir ilişki tablosu --
-- bir Question artık hiçbir Quiz'e bağlı olmadan da (Practice havuzunda) var olabilir.
CREATE TABLE quiz
(
    id             BIGSERIAL PRIMARY KEY,
    topic_id       BIGINT       NOT NULL REFERENCES topic (id) ON DELETE CASCADE,
    language       VARCHAR(5)   NOT NULL,
    slug           VARCHAR(100) NOT NULL,
    title          VARCHAR(255) NOT NULL,
    pass_threshold NUMERIC(3, 2) NOT NULL DEFAULT 0.80,
    active         BOOLEAN      NOT NULL DEFAULT TRUE,
    UNIQUE (topic_id, language, slug)
);

-- question_id: ON DELETE RESTRICT KASITLI -- bir soru, canlı bir sabit quiz'in
-- parçasıysa hard-delete edilemez; bir soruyu "kaldırmak" isteyen kişi
-- question.status = REJECTED yapmalı, satırı silmemeli.
CREATE TABLE quiz_question_link
(
    id          BIGSERIAL PRIMARY KEY,
    quiz_id     BIGINT  NOT NULL REFERENCES quiz (id) ON DELETE CASCADE,
    question_id BIGINT  NOT NULL REFERENCES question (id) ON DELETE RESTRICT,
    position    INTEGER NOT NULL,
    UNIQUE (quiz_id, question_id),
    UNIQUE (quiz_id, position)
);

CREATE INDEX idx_quiz_topic_lang ON quiz (topic_id, language);
CREATE INDEX idx_quiz_question_link_question ON quiz_question_link (question_id);
