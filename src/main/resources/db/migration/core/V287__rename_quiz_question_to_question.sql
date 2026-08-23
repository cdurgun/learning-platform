-- Quiz soru havuzu (question pool) yeniden tasarımının 1. adımı (Faz A).
-- quiz_question tablosu, artık herhangi bir quiz'e bağlı olmak zorunda olmayan
-- genel bir "Question" (havuz sorusu) kavramına dönüştürülüyor. Bu, saf bir
-- yeniden adlandırma -- veri taşınmıyor, id'ler ve mevcut FK'ler (quiz_option'dan)
-- olduğu gibi kalıyor (Postgres FK'leri tablo OID'ine bağlıdır, isme değil).
ALTER TABLE quiz_question RENAME TO question;

ALTER INDEX idx_quiz_question_topic_lang RENAME TO idx_question_topic_lang;

ALTER SEQUENCE quiz_question_id_seq RENAME TO question_id_seq;
