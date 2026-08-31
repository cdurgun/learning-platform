-- `arrays` topic's fixed quiz shell (TR+EN) -- SORU İÇERMİYOR, aynı desen
-- enum/V291, git-fundamentals/V433, ve string/V490'daki: slug='default',
-- pass_threshold=0.80, active=true. Soru içeriği V523/V524'te, promotion-
-- link migration deseniyle (git-fundamentals/V467/V468, string/V491/V492)
-- ayrı ayrı ekleniyor.
--
-- KÖK NEDEN NOTU: 7 EN + 6 TR arrays sorusu question-promotion/V520 ve V521
-- ile daha önce PUBLISHED edildi (havuza girdi -- Practice/Quiz Area'da
-- görünür), ama topic.html'in konu sonunda gösterdiği sabit quiz bölümü
-- TopicController#topic'in quizService.findQuiz(topic.id, language)
-- sonucuna bağlı (bkz. topic.html'deki quiz null olmadığında gösterilen
-- th:if koşulu) -- bir soruyu PUBLISHED yapmak onu hiçbir Quiz'e OTOMATİK EKLEMEZ (bkz.
-- CLAUDE.md Faz 87 maddesi). `arrays` için hiç bir `quiz` satırı yoktu,
-- bu yüzden 7 PUBLISHED soru var olsa da konu sayfasının sonunda hiçbir
-- şey görünmüyordu. Bu migration + V523/V524, `string` topic'inin
-- V490/V491/V492'sinin BİREBİR aynı deseniyle bu eksik bağlantıyı kurar.

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'arrays';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'arrays';
