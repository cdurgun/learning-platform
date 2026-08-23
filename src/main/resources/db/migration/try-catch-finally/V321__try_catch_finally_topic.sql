-- java-basics kategorisine, Exception Handling serisinin 2.'si ekleniyor:
-- "try-catch-finally" -- introduction-to-exceptions (sort_order=5, bkz. V318)
-- ile file-reading (şu an sort_order=6) arasına. Aynı gerçek-tamsayı-kaydırma
-- deseni (bkz. V318'in yorumu) burada da uygulanıyor: file-reading'den itibaren
-- her şey yeniden +1 kaydırılıyor.
--
-- Kapsam (serinin 2.'si -- try/catch/multiple-catch/multi-catch/finally, kullanıcının
-- verdiği kesin sözdizimi listesi): try-catch temel bloğu, birden fazla catch bloğu
-- (sırayla eşleşme, süper sınıf/alt sınıf sıralama kısıtı), multi-catch (`|`, Java 7+),
-- finally'nin koşulsuz çalışması, ve finally içinde return/throw'un try/catch'in
-- ürettiği her şeyi sessizce ezdiği (klasik, gerçek bir Java davranışı) ince ayrıntısı.
-- try-with-resources KASITLI OLARAK burada ÖĞRETİLMEDİ -- file-reading/file-writing
-- konuları zaten onu gerçek kullanımıyla kapsıyor (bkz. Faz 97 notu, kullanıcının
-- "zaten kapsanan kavramları tekrarlama" talimatı); bu ders yalnızca finally'nin
-- try-with-resources'ın temelinde ne olduğuna kısa bir ileri referans veriyor.
--
-- Format: introduction-to-exceptions'la (V318) AYNI güncel java-basics konvansiyonu --
-- "## Ek: Mini Proje" YOK, estimated_minutes doğrudan son değerine yazıldı, BEGINNER
-- zorluk (komşularıyla aynı).

UPDATE topic
SET sort_order = sort_order + 1
WHERE category_id = (SELECT id FROM category WHERE slug = 'java-basics')
  AND sort_order >= 6;

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'try-catch-finally', 'BEGINNER', 20, 6
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Try-Catch ve Finally',
       'Bir exception''ı gerçekten handle etmenin mekanizması: temel try-catch bloğu, birden fazla catch bloğu (sırayla eşleşme, süper sınıf/alt sınıf sıralama kısıtı), | ile multi-catch (Java 7+), finally''nin koşulsuz olarak her zaman çalışması, ve finally içinde return/throw''un try/catch''in ürettiği her şeyi sessizce ezmesi. Exception Handling serisinin 2.''si.',
       'Java''da try-catch-finally Nasıl Kullanılır?',
       'Java''da try, catch, multi-catch ve finally kullanımı -- birden fazla catch bloğu, finally''nin koşulsuz çalışması, ve finally içinde return kullanmanın gerçek tehlikesi gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'try-catch-finally';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Try-Catch and Finally',
       'The actual mechanism for handling an exception: the basic try-catch block, multiple catch blocks (matching in order, the superclass/subclass ordering restriction), multi-catch with | (Java 7+), finally running unconditionally every time, and how a return/throw inside finally silently overrides whatever try/catch was about to produce. The 2nd lesson in the Exception Handling series.',
       'How to Use try-catch-finally in Java',
       'Using try, catch, multi-catch, and finally in Java -- multiple catch blocks, finally running unconditionally, and the real danger of using return inside finally, explained with real examples.',
       false
FROM topic
WHERE slug = 'try-catch-finally';
