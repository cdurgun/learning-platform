-- `spring-data-jpa` kategorisine, onaylanan 9 topic'lik roadmap'in 9. ve
-- SON topic'i ekleniyor: "testing-spring-data-jpa" -- jpa-auditing'in
-- (sort_order=8) hemen ardına, sort_order=9. Kategori şu an sekiz topic
-- içeriyor, sort_order kaydırması gerekmiyor.
--
-- Kapsam (roadmap'in onaylanan tablosu + kullanıcının roadmap onayı
-- sırasında eklediği düzeltme): `@DataJpaTest` ve `TestEntityManager` ana
-- konu; embedded test veritabanı vs gerçek PostgreSQL karşılaştırması,
-- Testcontainers gerçekçi entegrasyon-testi seçeneği olarak İSİM verilip
-- kısaca gösterilerek (kullanıcının açık talimatı gereği kendi ayrı bir
-- topic'ine DÖNÜŞTÜRÜLMEDİ, yalnızca bir "sketch").
--
-- `spring-mvc`'deki "Spring MVC'de Test Yazmak"ın (Faz -- V120)
-- `@DataJpaTest`'i yalnızca `@WebMvcTest`'in kardeşi olarak GEÇERKEN
-- andığı, hiç öğretmediği grep ile önceden doğrulandı -- bu topic tam
-- olarak o boşluğu dolduruyor, gerçek migration başlığıyla doğrulanmış
-- referansla.
--
-- Bu dersin en güçlü motivasyonu, önceki birçok topic'te olduğu gibi,
-- UYDURMA değil GERÇEK: bu projenin kendi `application-test.yml`'i
-- okunup, dosyanın kendi (Faz 3 civarı yazılmış) yorumunun -- "İleride
-- (Faz 3+) bunun yerine Testcontainers ile her test çalıştırmasında
-- izole, tek kullanımlık bir Postgres container'ı ayağa kaldırmak çok
-- daha sağlam olur" -- TAM OLARAK kullanıcının istediği "embedded vs
-- gerçek PostgreSQL vs Testcontainers" karşılaştırmasını kendisinin
-- zaten öngördüğü keşfedildi. Bu gerçek yorum, dersin "Testcontainers"
-- bölümünde DOĞRUDAN alıntılandı. Bu projenin gerçek servis testlerinin
-- (QuizServiceTest vb.) HER repository'yi Mockito ile mock'ladığı, ve
-- hiçbir yerde bir derived query/`@Query`/`Specification`'ın gerçekten
-- çalıştığının doğrulanmadığı da motivasyon bölümünde ("Why Mocking a
-- Repository Isn't Enough") kullanıldı.
--
-- "Transaction Management"teki (Faz 82) gerçek `TopicRepository.
-- findBySlugWithCategoryAndCourse`'a, "The Persistence Context and
-- Locking"teki (Faz 121) `EntityManager`/flush'a, ve "Query Methods and
-- JPQL with @Query"teki (Faz 117) gerçek `QuestionRepository.
-- findRandomPublishedPool` native sorgusuna gerçek migration
-- başlıklarıyla doğrulanmış referanslar verildi, TEKRAR AÇIKLANMADI.
--
-- 5 örnek: `MockedRepositoryLimitationExample` (mock'lamanın kör noktası),
-- `DataJpaTestWithTestEntityManagerExample` (`@DataJpaTest` + `TestEntityManager`
-- temelleri), `DerivedQueryMethodTestExample` (filtreleme VE sıralamayı
-- birlikte test etmek), `CustomQueryTestExample` (join fetch'li bir
-- `@Query`), `TestcontainersSketchExample` (kullanıcının talimatı gereği
-- yalnızca bir "sketch" -- `@Container`/`@DynamicPropertySource`/
-- `AutoConfigureTestDatabase.Replace.NONE`, derin dalış YOK). Örnek
-- dosyalarındaki başlangıç taslağında iki yerde private alanlara sınıf
-- dışından erişim hatası fark edilip getter'lar eklenerek düzeltildi.
--
-- ADVANCED zorlukta (onaylanan roadmap'teki karar). Format: "## Ek: Mini
-- Proje" YOK (kullanıcının açık talimatı: bu kategoriye Pratik Proje
-- eklenmedi). **BU TOPIC İLE, kullanıcının onayladığı 9 topic'lik Spring
-- Data JPA roadmap'inin TAMAMI tamamlanıyor** -- CLAUDE.md'ye kilometre
-- taşı olarak yansıtılacak (bkz. bu faz'ın phase-log notu).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'testing-spring-data-jpa', 'ADVANCED', 35, 9
FROM category
WHERE slug = 'spring-data-jpa';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Testing Spring Data JPA Repositories',
       '"Spring MVC''de Test Yazmak"ın yalnızca isim olarak andığı @DataJpaTest ve TestEntityManager -- bu projenin kendi Mockito-mock''lanmış servis testlerinin bırakmadan geçtiği boşluğu (bir sorgunun gerçekten çalıştığının hiç doğrulanmaması) kapatıyor; derived query/custom @Query testi, ve embedded test veritabanı vs gerçek PostgreSQL vs Testcontainers -- bu projenin kendi application-test.yml''inin gerçek yorumuna dayanarak. Spring Data JPA kategorisinin 9. ve son dersi.',
       'Spring Data JPA Repository''lerini Test Etmek: @DataJpaTest',
       'Spring Data JPA repository''lerini @DataJpaTest ve TestEntityManager ile test etmek, derived query/@Query doğrulaması, ve Testcontainers gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'testing-spring-data-jpa';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Testing Spring Data JPA Repositories',
       '@DataJpaTest and TestEntityManager, only named in "Testing in Spring MVC" -- closing the gap this project''s own Mockito-mocked service tests leave open (nothing verifies a query actually works); testing a derived query method and a custom @Query, and embedded test database vs. real PostgreSQL vs. Testcontainers, grounded in this project''s own application-test.yml comment. The 9th and final lesson in the Spring Data JPA category.',
       'Testing Spring Data JPA Repositories with @DataJpaTest',
       'Testing Spring Data JPA repositories with @DataJpaTest and TestEntityManager, verifying derived queries and @Query, and Testcontainers, explained with real examples.',
       false
FROM topic
WHERE slug = 'testing-spring-data-jpa';
