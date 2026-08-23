-- `generics` kategorisine, serinin 6. ve SON topic'i ekleniyor: "type-
-- erasure-and-generic-limitations" -- generics-with-collections'ın
-- (sort_order=5) hemen ardına, sort_order=6. Kategori şu an beş topic
-- içeriyor, sort_order kaydırması gerekmiyor.
--
-- Kapsam (kullanıcının verdiği kesin alt başlıklar): type erasure'ın ne
-- olduğu, generic türlere çalışma zamanında ne olduğu, `new T()`'nin neden
-- izin verilmediği, generic array'ler, statik üyeler ve generics, generics'in
-- çalışma zamanı kısıtları, pratik örnekler. Kullanıcının açık talimatı
-- gereği erasure KAVRAMSAL bir tanımla sınırlı kalmadı -- her alt başlık
-- gerçek, derlenebilir bir örnekle ("neden derlenmiyor" yorumu dahil)
-- somutlaştırıldı. "Introduction to Generics"teki (Faz 105) pre-generics
-- raw type motivasyonu ve "Generic Methods"teki (Faz 106) metot tür
-- parametresi mekaniği burada TEKRARLANMADI, yalnızca topic başlıkları
-- üzerinden referans verildi -- son bölüm ("Runtime Limitations in
-- Practice"), "Introduction to Generics"in açtığı raw type/ClassCastException
-- sorununun bugün hâlâ nasıl erişilebilir olduğunu göstererek seriyi kapatıyor.
--
-- **BU TOPIC İLE, kullanıcının istediği 6 topic'lik Generics serisinin
-- TAMAMI tamamlanıyor** -- CLAUDE.md'ye kilometre taşı olarak yansıtılacak
-- (bkz. bu faz'ın phase-log notu).
--
-- INTERMEDIATE zorlukta tutuldu (ADVANCED değil) -- kullanıcının "kavramsal
-- değil pratik de anlat" talimatı içeriğin derinliğine yansıdı, ama seri
-- boyunca zorluk etiketi tutarlı kaldı. Format: serinin önceki
-- topic'leriyle AYNI konvansiyon -- "## Ek: Mini Proje" YOK (kullanıcının
-- açık talimatı: bu kategoriye Pratik Proje eklenmeyecek), estimated_minutes
-- doğrudan son değerine yazıldı.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'type-erasure-and-generic-limitations', 'INTERMEDIATE', 25, 6
FROM category
WHERE slug = 'generics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Type Erasure ve Generics''in Kısıtları',
       'Type erasure''ın (tür silme) ne olduğu, generic türlere çalışma zamanında ne olduğu, `new T()` ve generic array''lerin neden izin verilmediği, statik üyeler ve generics, ve generics''in çalışma zamanı kısıtlarının pratikte (raw type/unchecked uyarı/heap pollution) nasıl karşımıza çıktığı. Generics serisinin 6. ve son dersi.',
       'Java''da Type Erasure ve Generics Kısıtları',
       'Java''da type erasure kavramsal ve pratik olarak anlatılıyor -- çalışma zamanı kısıtları, new T()''nin neden izin verilmediği, generic array''ler ve statik üyeler gerçek örneklerle işleniyor.',
       true
FROM topic
WHERE slug = 'type-erasure-and-generic-limitations';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Type Erasure and Generic Limitations',
       'What type erasure is, what happens to generic types at runtime, why `new T()` and generic arrays aren''t allowed, static members and generics, and how generics'' runtime limitations actually surface in practice (raw types, unchecked warnings, heap pollution). The 6th and final lesson in the Generics series.',
       'Type Erasure and Generic Limitations in Java',
       'Type erasure in Java explained conceptually and practically -- runtime limitations, why new T() isn''t allowed, generic arrays, and static members, with real examples.',
       false
FROM topic
WHERE slug = 'type-erasure-and-generic-limitations';
