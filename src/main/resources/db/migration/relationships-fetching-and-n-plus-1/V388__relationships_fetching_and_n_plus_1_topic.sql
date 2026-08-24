-- `spring-data-jpa` kategorisine, onaylanan 9 topic'lik roadmap'in 6.'sı
-- ekleniyor: "relationships-fetching-and-n-plus-1" -- dynamic-queries-
-- with-specifications'ın (sort_order=5) hemen ardına, sort_order=6.
-- Kategori şu an beş topic içeriyor, sort_order kaydırması gerekmiyor.
--
-- Kapsam (roadmap'in onaylanan tablosu + kullanıcının roadmap onayı
-- sırasında eklediği düzeltme): `@OneToMany`/`@ManyToOne`/`@ManyToMany`
-- mapping, fetch türleri, cascade türleri (PERSIST/MERGE/REMOVE/ALL) ve
-- orphanRemoval (kullanıcının talimatı gereği ayrı bir derin-dalış OLARAK
-- DEĞİL, ilişki mapping'ine pratik olarak gömülü, TEK bir bölümde
-- işlendi), N+1 problemi somut olarak gösterildi (projede daha önce hiç
-- ADLANDIRILMAMIŞTI), `@EntityGraph`, batch fetching, ve N+1'in bir
-- düzeltmesi olarak DTO projection'ları (Faz 118'e geri bağlanıyor).
--
-- Bu, serinin en geniş kapsamlı topic'i -- roadmap'te bu şekilde onaylandı.
-- "Transaction Management"in (Faz 82) ZATEN kapsamlıca işlediği
-- `LazyInitializationException`/`join fetch`/`open-in-view` (bu projenin
-- gerçek `Topic`/`Category`/`Course` `@ManyToOne` ilişkileriyle) BURADA
-- TEKRAR ÖĞRETİLMEDİ -- yalnızca gerçek migration başlığıyla doğrulanmış
-- referans verildi, ve bu dersin `@EntityGraph`'ının aynı `join fetch`
-- tekniğinin bir `@OneToMany` ilişkisine uygulanmış annotation eşdeğeri
-- olduğu açıkça belirtildi.
--
-- Gerçek kod tabanında `@OneToMany`/`@ManyToMany` YOK (yalnızca `@ManyToOne`
-- var, grep ile önceden doğrulandı) -- bu yüzden `Category`'ye makul bir
-- `@OneToMany` uzantısı (Topic'in gerçek `@ManyToOne`'unun ayna görüntüsü)
-- ve tamamen yeni, uydurma ama gerçekçi bir `Topic`↔`Tag` `@ManyToMany`
-- örneği yazıldı. Bu projenin GERÇEK `QuizQuestion`'ı (Quiz↔Question
-- arasında, `position` sütunlu bir join entity) `@ManyToMany` örneğinde
-- "ilişki kendi verisini taşıması gerektiğinde açık bir join entity'sini
-- tercih et" best practice'inin zaten gerçek kodda uygulanmış hâli olarak
-- kullanıldı.
--
-- INTERMEDIATE'ten değil, serinin önceki ADVANCED topic'i "Dynamic Queries
-- with Specifications"la (Faz 119) aynı zorlukta tutuldu. Format: "## Ek:
-- Mini Proje" YOK (kullanıcının açık talimatı: bu kategoriye şimdilik
-- Pratik Proje eklenmeyecek), estimated_minutes 6 örnek ve serinin en
-- geniş kapsamı nedeniyle önceki topic'lerden yüksek tutuldu.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'relationships-fetching-and-n-plus-1', 'ADVANCED', 40, 6
FROM category
WHERE slug = 'spring-data-jpa';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Relationships, Fetching, and the N+1 Problem',
       '@OneToMany/@ManyToMany mapping ("Transaction Management"in zaten kapsamlıca işlediği @ManyToOne''un ötesinde), cascade türleri (PERSIST/MERGE/REMOVE/ALL) ve orphanRemoval, N+1 probleminin somut gösterimi, ve @EntityGraph/batch fetching/projection''larla üç farklı düzeltme -- bu projenin gerçek Topic/Category/QuizQuestion sınıflarıyla. Spring Data JPA kategorisinin 6.''sı.',
       'Spring Data JPA''da İlişkiler, Fetching ve N+1 Problemi',
       'Spring Data JPA''da @OneToMany/@ManyToMany, cascade türleri, orphanRemoval, ve N+1 probleminin @EntityGraph/batch fetching/projection''larla nasıl düzeltileceği gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'relationships-fetching-and-n-plus-1';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Relationships, Fetching, and the N+1 Problem',
       '@OneToMany/@ManyToMany mapping (beyond the @ManyToOne already covered in full in "Transaction Management"), cascade types (PERSIST/MERGE/REMOVE/ALL) and orphanRemoval, a concrete demonstration of the N+1 problem, and three different fixes with @EntityGraph/batch fetching/projections -- using this project''s own Topic/Category/QuizQuestion classes. The 6th lesson in the Spring Data JPA category.',
       'Relationships, Fetching, and the N+1 Problem in Spring Data JPA',
       '@OneToMany/@ManyToMany, cascade types, orphanRemoval, and fixing the N+1 problem with @EntityGraph/batch fetching/projections in Spring Data JPA, explained with real examples.',
       false
FROM topic
WHERE slug = 'relationships-fetching-and-n-plus-1';
