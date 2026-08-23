-- exceptions kategorisine, Exception Handling serisinin 6.'sı ekleniyor:
-- "custom-exceptions" -- throw-and-throws'un (sort_order=5) hemen ardına,
-- sort_order=6. Kategori şu an beş topic içeriyor, sort_order kaydırması
-- gerekmiyor.
--
-- Kapsam (serinin 6.'sı, kullanıcının verdiği kesin sözdizimi listesi): kendi
-- exception türünü Exception (checked) ya da RuntimeException (unchecked)
-- genişleterek tanımlamak, mesaj/cause ileten minimal bir constructor,
-- exception'a ekstra alan (context) eklemek, Throwable'ın dört standart
-- constructor'ını (argümansız/mesaj/mesaj+cause/cause) yansıtmak, ve ortak
-- bir custom base sınıfıyla kendi küçük exception hiyerarşini kurmak.
-- Checked/unchecked seçim kılavuzu ve wrapping (serinin 4./5.'sinde işlendi)
-- burada TEKRARLANMADI, yalnızca topic başlıkları üzerinden referans
-- verildi.
--
-- Format: serinin önceki beş topic'iyle (V318/V321/V325/V328/V331) AYNI
-- güncel java-basics/exceptions konvansiyonu -- "## Ek: Mini Proje" YOK,
-- estimated_minutes doğrudan son değerine yazıldı, BEGINNER zorluk
-- (komşularıyla aynı).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'custom-exceptions', 'BEGINNER', 20, 6
FROM category
WHERE slug = 'exceptions';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Özel (Custom) Exception Oluşturmak ve Fırlatmak',
       'Kendi exception türünü Exception (checked) ya da RuntimeException (unchecked) genişleterek tanımlamak -- ekstra bağlam (context) taşıyan alanlar eklemek, Throwable''ın dört standart constructor''ını yansıtmak, ve ortak bir custom base sınıfıyla kendi küçük exception hiyerarşini kurmak. Exception Handling serisinin 6.''sı.',
       'Java''da Custom Exception Oluşturma',
       'Java''da kendi exception sınıflarını tasarlamak -- ekstra veri taşıyan alanlar, standart constructor''lar, ve kendi exception hiyerarşini kurmak gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'custom-exceptions';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Creating and Throwing Custom Exceptions',
       'Defining your own exception type by extending Exception (checked) or RuntimeException (unchecked) -- adding fields that carry extra context, mirroring Throwable''s four standard constructors, and building your own small exception hierarchy with a shared custom base class. The 6th lesson in the Exception Handling series.',
       'Creating Custom Exceptions in Java',
       'Designing your own exception classes in Java -- fields that carry extra data, standard constructors, and building your own exception hierarchy, explained with real examples.',
       false
FROM topic
WHERE slug = 'custom-exceptions';
