-- exceptions kategorisine, Exception Handling serisinin 7. ve SON topic'i
-- ekleniyor: "exception-handling-best-practices" -- custom-exceptions'ın
-- (sort_order=6) hemen ardına, sort_order=7. Kategori şu an altı topic
-- içeriyor, sort_order kaydırması gerekmiyor.
--
-- Kapsam (serinin 7. ve kapanış topic'i, kullanıcının verdiği kesin başlıkla
-- "Exception Handling Best Practices"): önceki altı topic'in mekaniğinin
-- üzerine kurulan pratikler -- exception'ları sıradan kontrol akışı için
-- kullanma anti-pattern'i, exception'ları boş bir catch bloğuyla yutma
-- anti-pattern'i, catch bloklarını spesifik türden genele doğru doğru
-- sırada yakalamak (geniş bir catch'i bilinçli bir son çare olarak
-- kullanmak), ve yalnızca gerçekten anlamlı bir tepki verilebilecek yerde
-- yakalamak. Kapanış bölümü, serinin diğer 6 topic'ini isimleriyle
-- (gerçek başlıklarıyla) tek tek özetleyerek bir araya getiriyor. Önceki
-- topic'lerde zaten TAM işlenen konular (checked/unchecked seçimi,
-- wrapping, custom exception tasarımı, finally/multi-catch mekaniği)
-- burada TEKRARLANMADI, yalnızca topic başlıkları üzerinden referans
-- verildi -- bu ders yeni bir mekanik öğretmiyor, var olanın üzerine
-- disiplin ekliyor.
--
-- Format: serinin önceki altı topic'iyle (V318/V321/V325/V328/V331/V334)
-- AYNI güncel java-basics/exceptions konvansiyonu -- "## Ek: Mini Proje"
-- YOK, estimated_minutes doğrudan son değerine yazıldı, BEGINNER zorluk
-- (komşularıyla aynı).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'exception-handling-best-practices', 'BEGINNER', 20, 7
FROM category
WHERE slug = 'exceptions';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Exception Handling Best Practices',
       'Önceki altı dersin mekaniğinin üzerine kurulan pratikler -- exception''ları kontrol akışı için kullanma ve yutma anti-pattern''leri, catch bloklarını spesifikten genele doğru doğru sırada yakalamak, ve yalnızca gerçekten anlamlı bir tepki verilebilecek yerde yakalamak. Exception Handling serisinin 7. ve son dersi, tüm seriyi özetleyen bir kapanış bölümüyle.',
       'Java''da Exception Handling Best Practices',
       'Java''da exception''ları doğru ele almanın en iyi pratikleri -- kontrol akışı anti-pattern''i, exception yutma, catch sırası ve spesifikliği gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'exception-handling-best-practices';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Exception Handling Best Practices',
       'Practices built on top of the previous six lessons'' mechanics -- the anti-patterns of using exceptions for control flow and swallowing them, catching in the right order from specific to broad, and only catching where a genuinely useful response is possible. The 7th and final lesson in the Exception Handling series, closing with a recap of the whole series.',
       'Exception Handling Best Practices in Java',
       'Best practices for handling exceptions in Java -- the control-flow anti-pattern, swallowing exceptions, catch order and specificity, explained with real examples.',
       false
FROM topic
WHERE slug = 'exception-handling-best-practices';
