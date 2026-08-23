-- Soru havuzu yeniden tasarımının 2. adımı (Faz A). quiz_option -> question_option.
-- Saf yeniden adlandırma, veri taşınmıyor.
ALTER TABLE quiz_option RENAME TO question_option;

ALTER TABLE question_option RENAME CONSTRAINT quiz_option_question_id_fkey TO question_option_question_id_fkey;

ALTER INDEX idx_quiz_option_question RENAME TO idx_question_option_question;

ALTER INDEX uq_quiz_option_one_correct_per_question RENAME TO uq_question_option_one_correct_per_question;

ALTER SEQUENCE quiz_option_id_seq RENAME TO question_option_id_seq;
