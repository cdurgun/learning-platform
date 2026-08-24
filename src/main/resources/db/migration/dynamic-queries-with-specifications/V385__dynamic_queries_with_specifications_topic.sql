-- `spring-data-jpa` kategorisine, onaylanan 9 topic'lik roadmap'in 5.'si
-- ekleniyor: "dynamic-queries-with-specifications" -- pagination-sorting-
-- and-projections'ın (sort_order=4) hemen ardına, sort_order=5. Kategori
-- şu an dört topic içeriyor, sort_order kaydırması gerekmiyor. Bu topic
-- roadmap'te ADVANCED zorluk olarak onaylanmıştı -- serinin önceki dört
-- topic'i INTERMEDIATE'den ilk ADVANCED geçiş.
--
-- Kapsam (roadmap'in onaylanan tablosu): JPA Criteria API temelleri,
-- `Specification` interface'i, `Specification.where/and/or`,
-- `JpaSpecificationExecutor`. Grep ile önceden doğrulandı: `spring-mvc`'deki
-- "REST API Tasarımı"nın `DynamicFilterExample.java`'sı, isteğe bağlı
-- filtrelemeyi (`Predicate<Topic>`, yokken "t -> true"ya varsayılan) bellek
-- içi bir `Stream` üzerinde gösteriyor, ve kendi yorumunda açıkça "a real
-- repository would push this down into a WHERE clause... or a JPA
-- Specification for cases this dynamic" diyor -- bu topic tam olarak o
-- ertelenmiş vaadi, aynı "isteğe bağlı filtre" şeklini gerçek SQL'e
-- iterek, yerine getiriyor.
--
-- "Query Methods and JPQL with @Query"nin (Faz 117) derived metotları ve
-- `@Query`'si BİLİNÇLİ OLARAK TEKRAR ÖĞRETİLMEDİ -- yalnızca ikisinin de
-- neden bu spesifik sorunu (çalışma zamanında bilinmeyen koşul kümesi)
-- çözemediği açıklandı. "Pagination, Sorting, and Projections"a (Faz 118)
-- `findAll(Specification, Pageable)` bağlamında gerçek migration
-- başlığıyla doğrulanmış bir referans verildi, `Page`/count-sorgu
-- mekaniği TEKRAR AÇIKLANMADI. "JPA, Hibernate, and Spring Data JPA"ya
-- (Faz 115) da Criteria API'nin JPA'nın kendi API'si olduğu bağlamında
-- referans verildi.
--
-- Gerçek kod tabanında hiçbir Specification kullanımı olmadığından
-- (grep ile önceden doğrulandı -- yalnızca isim olarak anılıyor), bu
-- projenin gerçek `Topic` entity'sine tutarlı, makul bir uzatma
-- (`TopicRepository extends JpaRepository<Topic, Long>,
-- JpaSpecificationExecutor<Topic>` ve `category`/`difficulty` alanlarına
-- Specification'lar) yazıldı, uydurma paralel bir domain model
-- YARATILMADI.
--
-- N+1 problemi ve ilişki fetching'i BİLİNÇLİ OLARAK burada ÖĞRETİLMEDİ --
-- roadmap'in 6. topic'i "Relationships, Fetching, and the N+1 Problem"e
-- (TR karşılığı "İlişkiler, Fetching ve N+1 Problemi" olarak şimdiden
-- kararlaştırıldı, henüz YAZILMADI, ileri referans, o topic yazıldığında
-- doğrulanacak) ertelendi.
--
-- Format: "## Ek: Mini Proje" YOK (kullanıcının açık talimatı: bu
-- kategoriye şimdilik Pratik Proje eklenmeyecek), estimated_minutes
-- ADVANCED zorluk ve Criteria API'nin ek kavramsal yüküyle tutarlı olarak
-- önceki topic'lerden biraz yüksek tutuldu.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'dynamic-queries-with-specifications', 'ADVANCED', 35, 5
FROM category
WHERE slug = 'spring-data-jpa';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Dynamic Queries with Specifications',
       '"REST API Tasarımı"nın bellek içinde bıraktığı isteğe bağlı filtrelemeyi, JPA''nın Criteria API''si (Root/CriteriaQuery/CriteriaBuilder/Predicate) üzerine ince bir sarmalayıcı olan Specification interface''i, JpaSpecificationExecutor, Specification.where/and/or ile birleştirme, ve findAll(Specification, Pageable) ile gerçek sayfalamayla birleştirme -- bu projenin gerçek Topic entity''siyle. Spring Data JPA kategorisinin 5.''si.',
       'Spring Data JPA''da Specification ile Dinamik Sorgular',
       'Spring Data JPA''da JPA Criteria API''si, Specification interface''i, JpaSpecificationExecutor, ve dinamik filtreleme gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'dynamic-queries-with-specifications';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Dynamic Queries with Specifications',
       'Delivers on the optional filtering "REST API Design" left in memory, pushing it into the database -- the Specification interface as a thin wrapper around JPA''s own Criteria API (Root/CriteriaQuery/CriteriaBuilder/Predicate), JpaSpecificationExecutor, combining conditions with Specification.where/and/or, and combining with real pagination via findAll(Specification, Pageable) -- using this project''s own Topic entity. The 5th lesson in the Spring Data JPA category.',
       'Dynamic Queries with Specifications in Spring Data JPA',
       'The JPA Criteria API, the Specification interface, JpaSpecificationExecutor, and dynamic filtering in Spring Data JPA, explained with real examples.',
       false
FROM topic
WHERE slug = 'dynamic-queries-with-specifications';
