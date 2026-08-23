-- exceptions kategorisine, Exception Handling serisinin 3.'sü ekleniyor:
-- "exception-hierarchy" -- try-catch-finally'nin (sort_order=2) hemen ardına,
-- sort_order=3. Kategori şu an yalnızca bu iki topic'i içerdiği için (bkz.
-- V324'ün category reorg'u) basit bir ekleme -- sort_order kaydırması
-- gerekmiyor.
--
-- Kapsam (serinin 3.'sü, kullanıcının verdiği kesin sözdizimi listesi):
-- Throwable/Error/Exception/RuntimeException, hiyerarşinin nasıl çalıştığı,
-- catch'in polimorfik eşleştirmesi, instanceof ile hiyerarşi kontrolü.
-- Checked/unchecked ayrımının KENDİSİ bilinçli olarak burada ÖĞRETİLMEDİ --
-- yalnızca hiyerarşideki yerine değiniliyor, tam kapsam "Checked vs Unchecked
-- Exceptions" (serinin 4.'sü) konusunda işlenecek.
--
-- Format: introduction-to-exceptions (V318) ve try-catch-finally (V321) ile
-- AYNI güncel java-basics/exceptions konvansiyonu -- "## Ek: Mini Proje" YOK,
-- estimated_minutes doğrudan son değerine yazıldı, BEGINNER zorluk (komşularıyla
-- aynı).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'exception-hierarchy', 'BEGINNER', 20, 3
FROM category
WHERE slug = 'exceptions';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Exception Hiyerarşisi',
       'Throwable, Error, Exception ve RuntimeException arasındaki miras ilişkisi -- her exception''ın tek bir ortak kökten geldiği, catch bloklarının bir türün herhangi bir atasını da hedefleyebildiği (polimorfik yakalama), ve instanceof ile bu hiyerarşinin çalışma zamanında nasıl sorgulanacağı. Exception Handling serisinin 3.''sü.',
       'Java''da Exception Hiyerarşisi: Throwable, Error, Exception',
       'Java''nın Throwable/Error/Exception/RuntimeException hiyerarşisi gerçek örneklerle anlatılıyor -- catch bloklarının polimorfik eşleştirmesi ve instanceof ile hiyerarşi kontrolü dahil.',
       true
FROM topic
WHERE slug = 'exception-hierarchy';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Exception Hierarchy',
       'The inheritance relationship between Throwable, Error, Exception, and RuntimeException -- how every exception descends from a single shared root, how a catch block can target any ancestor of a type (polymorphic catching), and how to query that hierarchy at runtime with instanceof. The 3rd lesson in the Exception Handling series.',
       'The Java Exception Hierarchy: Throwable, Error, Exception',
       'Java''s Throwable/Error/Exception/RuntimeException hierarchy explained with real examples -- including polymorphic catch matching and checking the hierarchy at runtime with instanceof.',
       false
FROM topic
WHERE slug = 'exception-hierarchy';
