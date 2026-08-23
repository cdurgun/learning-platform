-- Yeni "generics" kategorisine (bkz. V340) ilk topic ekleniyor:
-- "introduction-to-generics", sort_order=1. Kullanıcının verdiği 6-topic'lik
-- Generics serisinin 1.'si.
--
-- Kapsam (kullanıcının verdiği kesin alt başlıklar): neden generics var
-- (pre-generics raw type/cast/ClassCastException sorunu), tür güvenliği
-- (compile-time reddetme), generic sınıflar, generic interface'ler, tür
-- parametreleri (adlandırma kuralı), pratik örnekler. Bu, serinin geri kalan
-- 5 topic'inin (generic-methods, bounded-type-parameters, wildcards,
-- generics-with-collections, type-erasure-and-generic-limitations) üzerine
-- inşa edeceği temel -- generic metotlar, bounded type parameter'lar,
-- wildcard'lar (PECS dahil) ve type erasure BİLİNÇLİ OLARAK burada
-- ÖĞRETİLMEDİ, kavram tekrarı yapılmaması için sonraki topic'lere
-- bırakıldı.
--
-- INTERMEDIATE zorlukta -- `functional-interfaces-streams` kategorisinin
-- lambda-expressions'ıyla (V179) aynı seviye, OOP'nin (interface/inheritance)
-- üzerine kurulduğu için java-basics'in BEGINNER topic'lerinden daha ileri.
-- Format: Exception Handling serisiyle (V318 vd.) AYNI güncel konvansiyon --
-- "## Ek: Mini Proje" YOK (kullanıcının açık talimatı: bu kategoriye
-- şimdilik Pratik Proje eklenmeyecek), estimated_minutes doğrudan son
-- değerine yazıldı.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'introduction-to-generics', 'INTERMEDIATE', 25, 1
FROM category
WHERE slug = 'generics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Generics''e Giriş',
       'Generics''in neden var olduğu (pre-generics raw type/cast/ClassCastException sorunu), tür güvenliğinin derleme zamanında nasıl sağlandığı, generic sınıflar ve interface''ler, ve tür parametresi adlandırma kuralı. Generics serisinin 1.''si.',
       'Java''da Generics''e Giriş',
       'Java generics''in temelleri -- neden var olduğu, tür güvenliği, generic sınıflar ve interface''ler gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'introduction-to-generics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Introduction to Generics',
       'Why generics exist (the pre-generics raw type/cast/ClassCastException problem), how type safety is enforced at compile time, generic classes and interfaces, and the type parameter naming convention. The 1st lesson in the Generics series.',
       'Introduction to Generics in Java',
       'The fundamentals of Java generics -- why they exist, type safety, generic classes and interfaces, explained with real examples.',
       false
FROM topic
WHERE slug = 'introduction-to-generics';
