-- Soru havuzu yeniden tasarımının 5. adımı (Faz B). enum konusunun daha önce
-- "topic+language'in TÜM soruları = the quiz" varsayımıyla çalışan quiz'ini,
-- artık gerçek bir Quiz satırı + quiz_question_link ile açıkça KÜRE ediyoruz.
-- İçerik değişmiyor -- yalnızca mevcut 10 question satırı (TR+EN, 5'er soru) bir
-- Quiz'e bağlanıyor, question.sort_order değeri quiz_question_link.position'a
-- BİREBİR taşınıyor (bu taşıma tamamlanmadan question.sort_order DÜŞÜRÜLEMEZ,
-- bkz. V292).
INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'enum';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'enum';

INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, q.id, q.sort_order
FROM question q
         JOIN topic t ON t.id = q.topic_id
         JOIN quiz ON quiz.topic_id = t.id AND quiz.language = q.language AND quiz.slug = 'default'
WHERE t.slug = 'enum';
