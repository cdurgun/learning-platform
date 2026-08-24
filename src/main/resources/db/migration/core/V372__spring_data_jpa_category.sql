-- Yeni bir kategori: "Spring Data JPA" (spring-boot kursu, sort_order=5 --
-- spring-core(1)/spring-mvc(2)/microservices(3)/advanced-spring(4)'ten
-- sonra, kursun sonuna eklendi -- kullanıcı bu kategorinin yerini
-- özellikle belirtmedi, V169/V359'daki AYNI "kursun sonuna ekle" deseni
-- izlendi).
--
-- Kullanıcı, PLAN MODE'da önce tam bir 9 topic'lik roadmap istedi ve
-- onayladı (bkz. docs/phase-log.md'nin bu faz notundaki tam liste) --
-- roadmap onaylanmadan önce bir Explore agent'la kapsamlı bir çakışma
-- taraması yapıldı: `spring-core`'daki `transaction-management` (Faz 82)
-- zaten @Transactional'ın TAMAMINI (proxy/self-invocation/rollback/
-- propagation/isolation/readOnly/TransactionTemplate) VE bir "Spring Data
-- JPA and Dirty Checking" + "Lazy Loading and LazyInitializationException"
-- bölümünü (gerçek join fetch JPQL, LazyInitializationException, open-in-
-- view) kapsıyor; `spring-mvc`'deki `rest-api-design` zaten Pageable/Page/
-- Sort'u CONTROLLER seviyesinde kapsıyor (repository seviyesini değil) ve
-- Specification'ı yalnızca İSİM olarak anıyor, hiç implement etmiyor;
-- `spring-mvc-testing` @DataJpaTest'i yalnızca isim olarak anıyor. Bu üç
-- boşluk/örtüşme, roadmap'in her topic'inin "explicitly builds on / does
-- not repeat" sütununda ele alındı.
--
-- Onaylanan 9 topic'lik roadmap (sort_order): 1) jpa-hibernate-and-spring-
-- data-jpa, 2) entities-and-repositories, 3) query-methods-and-jpql,
-- 4) pagination-sorting-and-projections, 5) dynamic-queries-with-
-- specifications, 6) relationships-fetching-and-n-plus-1 (cascade
-- türleri + orphanRemoval dahil, kullanıcının roadmap onayı sırasında
-- eklediği düzeltme), 7) persistence-context-and-locking,
-- 8) jpa-auditing, 9) testing-spring-data-jpa (@DataJpaTest ana konu,
-- embedded DB vs PostgreSQL, Testcontainers isimle anılıyor -- kullanıcının
-- roadmap onayı sırasında eklediği düzeltme). Bu migration yalnızca
-- kategoriyi açıyor -- topic'ler ayrı migration'larda, TEK SEFERDE BİR
-- TOPIC, her topic'ten sonra kullanıcı onayı beklenerek eklenecek.
-- Kullanıcının açık talimatı gereği şimdilik bir Pratik Proje YOK.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Spring Data JPA', 'spring-data-jpa', 5
FROM course
WHERE slug = 'spring-boot';
