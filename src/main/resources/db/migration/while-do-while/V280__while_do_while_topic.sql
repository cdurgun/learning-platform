-- `control-flow` kategorisine beşinci topic: `while & do-while Loops` (slug:
-- while-do-while, sort_order=5). Kapsam: temel `while` sözdizimi, `do-while`'ın
-- gövdeyi en az bir kez çalıştırma davranışı, while vs do-while karşılaştırması,
-- break/continue'nun for Loop'takiyle birebir aynı davranışı, Scanner ile girdi
-- doğrulama döngüsü, ve kapanışta kullanıcının kendi kararıyla bu topic'e
-- yerleştirilen uygulamalı örnek: Sayı Tahmin Oyunu (Number Guessing Game) --
-- bkz. Faz 83 devamı, kullanıcının "Number guessing game i, while & do-while
-- Loops içine koyabilirsin" onayı.
--
-- 6 örneğin tamamı bu sandbox'ta javac+java ile GERÇEKTEN derlenip çalıştırıldı.
-- Girdi Gerektiren iki örnek (InputValidationLoopExample, NumberGuessingGameExample)
-- pipe edilmiş stdin ile test edildi (örn. `printf "10\n80\n42\n" | java
-- NumberGuessingGameExample`) ve beklenen "Too low!"/"Too high!"/"Correct!" çıktısı
-- gerçek çalıştırmayla doğrulandı. Kod yorumları İNGİLİZCE (bkz. Faz 53).
--
-- BEGINNER zorlukta -- diğer Control Flow topic'leriyle aynı seviye.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'while-do-while', 'BEGINNER', 20, 5
FROM category
WHERE slug = 'control-flow';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'while & do-while Loops',
       'Control Flow kategorisinin beşinci topic''i: temel `while` sözdizimi, gövdeyi en az bir kez çalıştıran `do-while`, while vs do-while karşılaştırması, break/continue, Scanner ile girdi doğrulama döngüsü, ve uygulamalı örnek olarak Sayı Tahmin Oyunu (Number Guessing Game).',
       'Java while ve do-while Döngüleri: Sayı Tahmin Oyunu Örneğiyle',
       'Java''nın `while` ve `do-while` döngüleri -- sözdizimi, aralarındaki fark, girdi doğrulama ve Sayı Tahmin Oyunu uygulamalı örneğiyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'while-do-while';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'while & do-while Loops',
       'The fifth topic in the Control Flow category: basic `while` syntax, `do-while`''s run-at-least-once body, while vs do-while comparison, break/continue, a Scanner-based input validation loop, and a worked example: the Number Guessing Game.',
       'Java while and do-while Loops: With a Number Guessing Game Example',
       'Java''s `while` and `do-while` loops -- syntax, the difference between them, input validation, and a worked Number Guessing Game example.',
       false
FROM topic
WHERE slug = 'while-do-while';
