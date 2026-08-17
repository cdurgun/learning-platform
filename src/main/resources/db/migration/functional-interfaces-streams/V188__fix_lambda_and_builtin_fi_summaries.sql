-- DÜZELTME: Faz 42'de V179 ve V182'nin summary/seo_description alanları YANLIŞLIKLA
-- yerinde (in-place) düzenlenip "Örnekler gerçekten derlenip çalıştırılarak
-- doğrulandı."/"Examples were actually compiled and run to verify them." cümlesi
-- kaldırılmıştı -- ama kullanıcı bu migration'ları kendi ortamında ÇOKTAN uygulamıştı,
-- bu yüzden checksum mismatch hatası aldı (Flyway "Migration checksum mismatch for
-- migration version 179/182"). V179 ve V182 bu migration'da ORİJİNAL haline
-- (cümle geri eklenerek) geri döndürüldü -- checksum'lar tekrar eşleşiyor. Asıl
-- düzeltme (cümlenin kaldırılması) burada, doğru şekilde, YENİ bir migration'la
-- UPDATE olarak uygulanıyor.
--
-- Not: ders metninin kendisi (content/tr,en/*.md) bu değişiklikten etkilenmiyor --
-- proje mimarisinde ders metni DB'de değil dosya sisteminde tutuluyor
-- (ContentResolver), yalnızca summary/seo_description gibi metadata DB'de. O yüzden
-- yalnızca bu iki alan güncelleniyor.

UPDATE topic_translation
SET summary = 'Lambda expression syntax''ının tamamı: parametre yazım kuralları, expression body vs block body, derleyicinin lambda''ya bağlamdan tip vermesi (target typing), effectively final değişken yakalama, ve lambda''nın anonymous inner class''tan farkı.'
WHERE language = 'tr'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions');

UPDATE topic_translation
SET summary = 'The full syntax of lambda expressions: parameter-writing rules, expression body vs. block body, the compiler inferring a lambda''s type from context (target typing), capturing effectively final variables, and how a lambda differs from an anonymous inner class.'
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions');

UPDATE topic_translation
SET summary = 'java.util.function paketindeki hazır interface''ler: Predicate<T>, Function<T,R>, Consumer<T>, Supplier<T>, UnaryOperator<T>, BinaryOperator<T>. Dört method reference biçimi: Class::staticMethod, object::instanceMethod, Class::instanceMethod, Class::new.'
WHERE language = 'tr'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces');

UPDATE topic_translation
SET summary = 'The ready-made interfaces in java.util.function: Predicate<T>, Function<T,R>, Consumer<T>, Supplier<T>, UnaryOperator<T>, BinaryOperator<T>. The four method reference forms: Class::staticMethod, object::instanceMethod, Class::instanceMethod, Class::new.'
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces');
