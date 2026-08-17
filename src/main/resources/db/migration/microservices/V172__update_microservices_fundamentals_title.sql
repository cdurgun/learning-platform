-- Kullanıcı geri bildirimi: topic sayfasında başlık üç kere art arda aynı metni
-- ("Microservices Nedir?") gösteriyordu -- breadcrumb, sayfa H1'i ve markdown'ın
-- ilk H2'si (giriş bölümü) hepsi birebir aynıydı, gereksiz tekrar okunuyordu.
--
-- Çözüm: `topic.title`'ı (breadcrumb + H1) `spring-mvc-fundamentals`'taki (V88)
-- TR/EN desenine uyacak şekilde değiştirdik -- title artık "X Temelleri"/
-- "X Fundamentals" (slug'la da tutarlı: `microservices-fundamentals`), ilk H2
-- ("Microservices Nedir?" / "What Are Microservices?") olduğu gibi kaldı --
-- artık yalnızca BİR kez, kendi bölümünde geçiyor. `content/tr/` ve `content/en/`
-- dosyalarındaki H1 satırları da aynı şekilde güncellendi (bu migration'ın dışında,
-- migration'la takip edilmeyen statik dosyalar). `summary`/`seo_title`/
-- `seo_description` bilinçli olarak değişmedi -- spring-mvc-fundamentals'ta da
-- title "Temelleri" derken seo_title "Nedir?" diye soruyor (arama niyetine göre
-- kasıtlı bir fark).
--
-- V169 (TR) zaten kullanıcının kendi ortamında UYGULANMIŞ durumda (ekran görüntüsüyle
-- doğrulandı) -- bu yüzden CLAUDE.md'nin "Flyway migration'ları asla geriye dönük
-- değiştirilmez" kuralı gereği V169/V170 doğrudan düzenlenmedi, ayrı bir UPDATE
-- migration'ı eklendi.

UPDATE topic_translation
SET title = 'Microservices Temelleri'
WHERE language = 'tr'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'microservices-fundamentals');

UPDATE topic_translation
SET title = 'Microservices Fundamentals'
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'microservices-fundamentals');
