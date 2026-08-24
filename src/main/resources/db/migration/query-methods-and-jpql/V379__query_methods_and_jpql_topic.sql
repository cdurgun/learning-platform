-- `spring-data-jpa` kategorisine, onaylanan 9 topic'lik roadmap'in 3.'sü
-- ekleniyor: "query-methods-and-jpql" -- entities-and-repositories'in
-- (sort_order=2) hemen ardına, sort_order=3. Kategori şu an iki topic
-- içeriyor, sort_order kaydırması gerekmiyor.
--
-- Kapsam (roadmap'in onaylanan tablosu): derived query metot adlandırma
-- konvansiyonları (`findBy`, `existsBy`, `countBy`, `And`/`Or`/`OrderBy`),
-- `@Query` ile JPQL, isimli parametreler, toplu update/delete için
-- `@Modifying`. Faz 116'da "Entities and the Repository Abstraction"ın
-- yalnızca geçerken adını andığı `TopicRepository.findBySlug(...)`'ın
-- gerçekte NASIL çalıştığı burada tam olarak açıklanıyor.
--
-- Bu projenin GERÇEK repository'lerinden zengin bir örnek kümesi
-- kullanıldı, uydurma paralel bir domain model YARATILMADI:
-- `CodeExampleRepository` (temel derived query'ler), `QuizRepository`
-- (hem yoğun bir derived metot -- `findFirst`/`And`/`ActiveTrue`/
-- `OrderBy` -- hem de bir `@Query` join fetch), `TopicTranslationRepository`
-- ve `QuizQuestionRepository` (join fetch zincirleme), `QuestionRepository`
-- (gerçek bir native query, `RANDOM()` gerekçesiyle). `@Modifying` için
-- gerçek kod tabanında bir örnek olmadığından (bu proje çoğunlukla
-- read-heavy), Question/QuestionStatus domain'ine (CLAUDE.md'de belgeli
-- soru havuzu mimarisi) tutarlı, MAKUL bir illustratif örnek (stale
-- PENDING_REVIEW sorularını toplu reddetmek) yazıldı -- kullanıcı
-- talimatı gereği gerçekçi, izole olmayan bir senaryo.
--
-- `join fetch`'in kendisi VE `LazyInitializationException` "Transaction
-- Management"te (Faz 82) ZATEN tam işlendiği için burada TEKRAR
-- ÖĞRETİLMEDİ -- yalnızca JPQL sözdizimine odaklanıldı, gerçek migration
-- başlığıyla doğrulanmış referans verildi. N+1 problemi ve join zincirleme
-- BİLİNÇLİ OLARAK burada derinlemesine İŞLENMEDİ -- roadmap'in 6. topic'i
-- "Relationships, Fetching, and the N+1 Problem"e (henüz YAZILMADI, ileri
-- referans, o topic yazıldığında doğrulanacak) açıkça ertelendi.
-- Pagination/Sorting/Projections de roadmap'in 4. topic'ine (henüz
-- YAZILMADI) aynı şekilde ertelendi, "REST API Tasarımı"na (gerçek
-- migration başlığıyla doğrulandı) da kısaca referans verildi.
--
-- INTERMEDIATE zorlukta (onaylanan roadmap'teki karar). Format: "## Ek:
-- Mini Proje" YOK (kullanıcının açık talimatı: bu kategoriye şimdilik
-- Pratik Proje eklenmeyecek), estimated_minutes 6 örnek nedeniyle önceki
-- iki topic'le aynı yükseklikte tutuldu.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'query-methods-and-jpql', 'INTERMEDIATE', 30, 3
FROM category
WHERE slug = 'spring-data-jpa';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Query Methods and JPQL with @Query',
       'Spring Data JPA''nın bir repository metodunun adından bir sorguyu nasıl çıkardığı (findBy/existsBy/countBy, And/Or/OrderBy), @Query ile JPQL yazmak ve isimli parametreler, toplu güncelleme/silme için @Modifying, join fetch, ve ne zaman bir native query''ye başvurulacağı -- bu projenin gerçek repository''leriyle. Spring Data JPA kategorisinin 3.''sü.',
       'Spring Data JPA''da Query Metotları ve @Query',
       'Spring Data JPA''da derived query metotları, @Query ile JPQL, join fetch, @Modifying ve native query''ler gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'query-methods-and-jpql';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Query Methods and JPQL with @Query',
       'How Spring Data JPA derives a query from a repository method''s name (findBy/existsBy/countBy, And/Or/OrderBy), writing JPQL with @Query and named parameters, @Modifying for bulk updates/deletes, join fetch, and when to reach for a native query -- using this project''s own real repositories. The 3rd lesson in the Spring Data JPA category.',
       'Query Methods and @Query in Spring Data JPA',
       'Derived query methods, JPQL with @Query, join fetch, @Modifying, and native queries in Spring Data JPA, explained with real examples.',
       false
FROM topic
WHERE slug = 'query-methods-and-jpql';
