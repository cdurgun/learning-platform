-- Soru havuzu yeniden tasarımının 3. adımı (Faz A). question tablosuna havuz
-- semantiği için gereken kolonları ekliyoruz. NOT NULL DEFAULT ile eklenen her
-- kolon, Postgres'in "fast default" optimizasyonu sayesinde mevcut 10 satırı da
-- (enum quiz'inin TR+EN soruları) aynı anda geriye dönük dolduruyor -- ayrı bir
-- UPDATE'e gerek yok. Enum değerleri Java tarafındaki QuestionType/QuestionStatus/
-- QuestionSource/Difficulty enum sabitleriyle BİREBİR aynı yazılmalı
-- (@Enumerated(EnumType.STRING) kullanılıyor).
ALTER TABLE question
    ADD COLUMN type        VARCHAR(20)  NOT NULL DEFAULT 'SINGLE_CHOICE',
    ADD COLUMN difficulty  VARCHAR(20)  NOT NULL DEFAULT 'INTERMEDIATE',
    ADD COLUMN status      VARCHAR(20)  NOT NULL DEFAULT 'PUBLISHED',
    ADD COLUMN source      VARCHAR(20)  NOT NULL DEFAULT 'MANUAL',
    ADD COLUMN code_snippet  TEXT       NULL,
    ADD COLUMN code_language VARCHAR(30) NULL,
    ADD COLUMN reviewed_by   VARCHAR(255) NULL,
    ADD COLUMN reviewed_at   TIMESTAMP    NULL,
    ADD COLUMN created_at    TIMESTAMP    NOT NULL DEFAULT now(),
    ADD COLUMN updated_at    TIMESTAMP    NOT NULL DEFAULT now();

-- type/difficulty/status/source'un varsayılanlarını kaldırıyoruz: geriye dönük
-- 10 satır zaten dolduruldu, ama bundan sonraki her INSERT (ingestion dahil) bu
-- dört alanı EXPLICIT vermek zorunda -- sessiz bir varsayılana düşmesin.
-- created_at/updated_at varsayılanları KASITLI OLARAK kalıyor (append-only kolaylık).
ALTER TABLE question
    ALTER COLUMN type       DROP DEFAULT,
    ALTER COLUMN difficulty DROP DEFAULT,
    ALTER COLUMN status     DROP DEFAULT,
    ALTER COLUMN source     DROP DEFAULT;

CREATE INDEX idx_question_status ON question (status);
