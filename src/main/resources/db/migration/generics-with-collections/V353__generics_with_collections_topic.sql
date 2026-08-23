-- `generics` kategorisine, serinin 5.'si ekleniyor: "generics-with-
-- collections" -- wildcards'ın (sort_order=4) hemen ardına, sort_order=5.
-- Kategori şu an dört topic içeriyor, sort_order kaydırması gerekmiyor.
--
-- Kapsam (kullanıcının verdiği kesin alt başlıklar): List<T>/Set<T>/
-- Map<K,V> gibi generic koleksiyonlar, generic API'ler, koleksiyonlarla tür
-- güvenliği, List<Object>'in neden List<String> OLMADIĞI (Faz 108'de
-- "Wildcards"ta yalnızca MOTİVASYON olarak kısaca değinilen değişmezlik
-- kuralının burada TAM işlenmesi -- bu, o topic'te verilen ileri
-- referansın kapatıldığı yer), tür çıkarımı (diamond operatörü ve var), ve
-- pratik örnekler. "Introduction to Generics"teki (Faz 105) temel generics
-- mekaniği ve "Wildcards"taki (Faz 108) wildcard/PECS mekaniği burada
-- TEKRARLANMADI, yalnızca topic başlıkları üzerinden referans verildi.
--
-- INTERMEDIATE zorlukta, serinin önceki topic'leriyle aynı seviye. Format:
-- serinin önceki topic'leriyle AYNI konvansiyon -- "## Ek: Mini Proje" YOK,
-- estimated_minutes doğrudan son değerine yazıldı.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'generics-with-collections', 'INTERMEDIATE', 25, 5
FROM category
WHERE slug = 'generics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Koleksiyonlarla Generics',
       'List<T>, Set<T> ve Map<K,V> gibi generic koleksiyonlar, koleksiyonlarla tür güvenliği, List<Object>''in neden List<String> OLMADIĞI (generics değişmezliği, tam işleniş), ve diamond operatörü/var ile tür çıkarımı. Generics serisinin 5.''si.',
       'Java''da Generic Koleksiyonlar',
       'Java''da List, Set ve Map generic koleksiyonları -- tür güvenliği, generics değişmezliği ve tür çıkarımı gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'generics-with-collections';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Generics with Collections',
       'Generic collections like List<T>, Set<T>, and Map<K,V>, type safety with collections, why List<Object> is NOT List<String> (the full treatment of generics invariance), and type inference with the diamond operator and var. The 5th lesson in the Generics series.',
       'Generic Collections in Java',
       'Generic collections in Java -- List, Set, and Map, type safety, generics invariance, and type inference, explained with real examples.',
       false
FROM topic
WHERE slug = 'generics-with-collections';
