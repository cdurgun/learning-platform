-- `spring-data-jpa` kategorisine, onaylanan 9 topic'lik roadmap'in 4.'sü
-- ekleniyor: "pagination-sorting-and-projections" -- query-methods-and-
-- jpql'in (sort_order=3) hemen ardına, sort_order=4. Kategori şu an üç
-- topic içeriyor, sort_order kaydırması gerekmiyor.
--
-- Kapsam (roadmap'in onaylanan tablosu): repository seviyesinde
-- `Pageable`/`Page<T>`/`Sort` -- `spring-mvc`'deki "REST API Tasarımı"nın
-- ZATEN öğrettiği controller-seviyesi çözümlemeyi (query parametrelerinden
-- `Pageable`/`Sort` çözme) DEĞİL, o dersin kendi örneğinin bilinçli olarak
-- "gerçek bir repository bunu veritabanında yapar" diyerek atladığı
-- repository-seviyesi implementasyonu; interface-tabanlı ve DTO/record
-- projection'ları. Grep ile önceden doğrulandı: "REST API Tasarımı"nın
-- `PaginationExample.java`'sı `PageImpl` ile bellek-içi bir listeyi
-- sarmalıyor, yorumda açıkça "a real repository does this in the database"
-- diyor -- bu topic tam olarak o boşluğu dolduruyor.
--
-- Bu projenin GERÇEK `Topic`/`TopicTranslation` entity'leri ve
-- repository'leri kullanıldı (uydurma paralel bir domain model
-- YARATILMADI), ama gerçek kod tabanında sayfalanmış bir repository
-- metodu olmadığından (uygulama küçük ölçekli, sidebar her şeyi tek
-- seferde gösteriyor), makul, tutarlı bir uzatma yazıldı: `TopicRepository`
-- benzeri bir arayüze `Page<Topic> findByCategoryId(...)` ve ilgili
-- metotlar eklendi. `Sort.by(...).and(...)` inşası "REST API Tasarımı"nda
-- ZATEN işlendiği için burada TEKRAR ÖĞRETİLMEDİ, yalnızca bunun bir
-- repository metoduna nasıl teslim edildiği gösterildi.
--
-- Specification/dinamik filtreleme BİLİNÇLİ OLARAK burada ÖĞRETİLMEDİ --
-- "REST API Tasarımı"nın filtreleme bölümünün yalnızca isim olarak andığı
-- (hiç implement etmediği) boşluk, roadmap'in 5. topic'i "Dynamic Queries
-- with Specifications"a (henüz YAZILMADI, ileri referans, TR karşılığı
-- "Specifications ile Dinamik Sorgular" olarak şimdiden kararlaştırıldı,
-- o topic yazıldığında gerçek migration başlığıyla doğrulanacak)
-- ertelendi.
--
-- INTERMEDIATE zorlukta (onaylanan roadmap'teki karar). Format: "## Ek:
-- Mini Proje" YOK (kullanıcının açık talimatı: bu kategoriye şimdilik
-- Pratik Proje eklenmeyecek), estimated_minutes önceki topic'lerle aynı
-- yükseklikte tutuldu.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'pagination-sorting-and-projections', 'INTERMEDIATE', 30, 4
FROM category
WHERE slug = 'spring-data-jpa';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Pagination, Sorting, and Projections',
       '"REST API Tasarımı"nın controller-seviyesinde çözdüğü Pageable/Sort''un, repository seviyesinde gerçekte nasıl LIMIT/OFFSET + count sorgusuna dönüştüğü, findAll(Sort)/derived metotlarla sıralama, ve bütün bir entity yerine yalnızca ihtiyaç duyulan alanları döndüren interface-tabanlı ve record/constructor-expression projection''lar -- bu projenin gerçek Topic/TopicTranslation sınıflarıyla. Spring Data JPA kategorisinin 4.''sü.',
       'Spring Data JPA''da Sayfalama, Sıralama ve Projection''lar',
       'Spring Data JPA''da repository-seviyesi Pageable/Page/Sort, ve interface/record projection''ları gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'pagination-sorting-and-projections';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Pagination, Sorting, and Projections',
       'How the Pageable/Sort "REST API Design" resolves at the controller level actually becomes a real LIMIT/OFFSET plus count query at the repository level, sorting with findAll(Sort)/derived methods, and interface-based and record/constructor-expression projections that return only the fields a query needs instead of a whole entity -- using this project''s own Topic/TopicTranslation classes. The 4th lesson in the Spring Data JPA category.',
       'Pagination, Sorting, and Projections in Spring Data JPA',
       'Repository-level Pageable/Page/Sort and interface/record projections in Spring Data JPA, explained with real examples.',
       false
FROM topic
WHERE slug = 'pagination-sorting-and-projections';
