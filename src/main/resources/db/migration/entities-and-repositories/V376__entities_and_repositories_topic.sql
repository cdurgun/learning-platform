-- `spring-data-jpa` kategorisine, onaylanan 9 topic'lik roadmap'in 2.'si
-- ekleniyor: "entities-and-repositories" -- jpa-hibernate-and-spring-data-
-- jpa'nın (sort_order=1) hemen ardına, sort_order=2. Kategori şu an tek
-- topic içeriyor, sort_order kaydırması gerekmiyor.
--
-- Kapsam (roadmap'in onaylanan tablosu + kullanıcının roadmap onayı
-- sırasında eklediği düzeltme): `@Entity`/`@Id`/`@GeneratedValue`/`@Column`
-- mapping, `Repository`→`CrudRepository`→`PagingAndSortingRepository`→
-- `JpaRepository` hiyerarşisi ve her katmanın ne kattığı, bu projenin
-- gerçek `Topic`/`Category`/`TopicRepository` sınıfları kullanılarak.
-- Kullanıcının düzeltmesiyle eklenen, ayrı bölümler AÇILMADAN kısaca
-- işlenen konular: `@Table`, `@Enumerated`, nullable/unique kısıtları,
-- argümansız constructor gereksinimi, entity vs DTO, ve entity'ler için
-- temel `equals()`/`hashCode()` değerlendirmeleri -- hepsi mapping
-- anlatımına gömülü, kendi H2 başlıklarını almadı (kullanıcının açık
-- talimatı).
--
-- İlişki mapping'i (`@ManyToOne`/fetch semantiği) ve N+1 problemi
-- BİLİNÇLİ OLARAK burada ÖĞRETİLMEDİ -- gerçek `Topic` entity'sinin
-- `category` alanı örnekte GÖRÜNÜYOR (gerçek kod budur) ama açıkça
-- "Relationships, Fetching, and the N+1 Problem"e (roadmap'in 6.
-- topic'i, henüz YAZILMADI -- bu bir ileri referans, o topic
-- yazıldığında gerçek migration başlığıyla doğrulanacak) ertelendi.
-- Query metotları/JPQL, ve Pagination/Sorting/Projections de aynı şekilde
-- roadmap'in 3. ve 4. topic'lerine ileri referanslarla ertelendi (henüz
-- YAZILMADI, ileride doğrulanacak). "Transaction Management" (Faz 82,
-- `LazyInitializationException` bağlamında) ve "Record" (argümansız
-- constructor bağlamında) gerçek migration başlıklarıyla doğrulanmış
-- referanslarla anıldı, TEKRAR ÖĞRETİLMEDİ.
--
-- INTERMEDIATE zorlukta (onaylanan roadmap'teki karar). Format: "## Ek:
-- Mini Proje" YOK (kullanıcının açık talimatı: bu kategoriye şimdilik
-- Pratik Proje eklenmeyecek), estimated_minutes 5 örnek ve genişçe kapsam
-- nedeniyle topic 1'den biraz yüksek tutuldu.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'entities-and-repositories', 'INTERMEDIATE', 30, 2
FROM category
WHERE slug = 'spring-data-jpa';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Entities and the Repository Abstraction',
       '@Entity/@Id/@GeneratedValue/@Column mapping''i, @Table/@Enumerated/nullable-unique kısıtları/argümansız constructor/entity vs DTO/equals()-hashCode() (kısaca), ve Repository → CrudRepository → PagingAndSortingRepository → JpaRepository hiyerarşisinin her katmanının ne kattığı -- bu projenin gerçek Topic/Category/TopicRepository sınıflarıyla. Spring Data JPA kategorisinin 2.''si.',
       'JPA Entity Mapping ve Repository Hiyerarşisi',
       'Java''da bir sınıfı düzgün eşlenmiş bir JPA entity''si yapan şey, ve Spring Data JPA''nın Repository/CrudRepository/JpaRepository hiyerarşisinin her katmanının ne kattığı gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'entities-and-repositories';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Entities and the Repository Abstraction',
       '@Entity/@Id/@GeneratedValue/@Column mapping, plus @Table/@Enumerated/nullable-unique constraints/the no-args-constructor requirement/entity vs. DTO/equals()-hashCode() (concisely), and what each tier of the Repository → CrudRepository → PagingAndSortingRepository → JpaRepository hierarchy actually contributes -- using this project''s own Topic/Category/TopicRepository classes. The 2nd lesson in the Spring Data JPA category.',
       'JPA Entity Mapping and the Repository Hierarchy',
       'What makes a class a properly mapped JPA entity in Java, and what each tier of Spring Data JPA''s Repository/CrudRepository/JpaRepository hierarchy actually contributes, explained with real examples.',
       false
FROM topic
WHERE slug = 'entities-and-repositories';
