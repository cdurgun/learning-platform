-- Yeni `spring-data-jpa` kategorisine (bkz. V372) ilk topic ekleniyor:
-- "jpa-hibernate-and-spring-data-jpa", sort_order=1. Onaylanan 9 topic'lik
-- roadmap'in 1.'si.
--
-- Kapsam (kullanıcının verdiği kesin pedagojik spesifikasyon): önce
-- annotation'lara/repository interface'lerine değil, ZİHİNSEL MODELE
-- odaklanan bir giriş dersi -- "bir Java nesnesini (Topic gibi) ilişkisel
-- bir veritabanına nasıl kalıcı hale getiririz" sorusuyla açılıp, ORM →
-- JPA → Hibernate → Spring Data JPA → Spring Boot sırasıyla "neden →
-- kavram → örnek → açıklama" ilerlemesiyle inşa ediliyor. JPA'nın bir
-- KÜTÜPHANE DEĞİL bir SPESİFİKASYON olduğu, Hibernate'in onun somut
-- implementasyonu olduğu, Spring Data JPA'nın JPA/Hibernate'in YERİNİ
-- ALMADIĞI (üzerine inşa edilen bir repository soyutlaması olduğu), ve
-- Spring Boot'un yeni bir katman EKLEMEDİĞİ (var olanları auto-configure
-- ettiği) açıkça vurgulandı. Bu projenin gerçek `Topic`/`Category`/
-- `Course`/`TopicRepository` sınıfları (basitleştirilmiş, öğretim amaçlı
-- versiyonlarıyla) kullanıldı, uydurma paralel bir domain model
-- YARATILMADI.
--
-- Faz 82'deki "transaction-management"in ZATEN kapsamlıca işlediği
-- @Transactional/dirty checking/lazy loading/LazyInitializationException,
-- ve Faz 76'daki "autoconfiguration-properties"in auto-configuration
-- mekanizması (kullanıcının açık talimatı gereği) burada TEKRAR
-- ÖĞRETİLMEDİ -- yalnızca "Spring Boot Auto-Configuration ve Properties"e
-- gerçek migration başlığıyla doğrulanmış bir referans verildi. "Record"a
-- da (java kursu) argümansız constructor gereksinimi bağlamında gerçek
-- migration başlığıyla doğrulanmış bir referans verildi.
--
-- Örnek dosyaları (3, kullanıcının "birkaç küçük örnek, tek büyük örnek
-- değil" talimatı gereği) `@Entity`/`@Id`/`@GeneratedValue`/repository
-- mekaniğinin DETAYINA GİRMİYOR -- her örnek sonrası, ayrıntıların
-- serinin 2. topic'i "Entities and the Repository Abstraction"a
-- bırakıldığı açıkça belirtiliyor (öğrenme köprüsü).
--
-- INTERMEDIATE zorlukta (onaylanan roadmap'teki karar). Format: "## Ek:
-- Mini Proje" YOK (kullanıcının açık talimatı: bu kategoriye şimdilik
-- Pratik Proje eklenmeyecek), estimated_minutes zihinsel-model ağırlıklı,
-- kod-ağır olmayan bir ders olduğu için orta düzeyde tutuldu.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'jpa-hibernate-and-spring-data-jpa', 'INTERMEDIATE', 25, 1
FROM category
WHERE slug = 'spring-data-jpa';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'JPA, Hibernate ve Spring Data JPA',
       'Bir Java nesnesini bir veritabanına kalıcı hale getirme sorunundan başlayarak, ORM → JPA (spesifikasyon) → Hibernate (implementasyon) → Spring Data JPA (repository soyutlaması) → Spring Boot (auto-configuration) zihinsel modeli, bu projenin gerçek Topic/TopicRepository sınıflarıyla inşa ediliyor. Spring Data JPA kategorisinin 1.''si.',
       'JPA, Hibernate ve Spring Data JPA Arasındaki Fark',
       'JPA''nın bir spesifikasyon, Hibernate''in onun implementasyonu, ve Spring Data JPA''nın bir repository soyutlaması olduğu -- dört katmanlı zihinsel model gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'jpa-hibernate-and-spring-data-jpa';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'JPA, Hibernate, and Spring Data JPA',
       'Starting from the problem of persisting a Java object into a database, this lesson builds the ORM → JPA (specification) → Hibernate (implementation) → Spring Data JPA (repository abstraction) → Spring Boot (auto-configuration) mental model using this project''s own Topic/TopicRepository classes. The 1st lesson in the Spring Data JPA category.',
       'JPA vs. Hibernate vs. Spring Data JPA Explained',
       'The difference between JPA (a specification), Hibernate (its implementation), and Spring Data JPA (a repository abstraction) -- the four-layer mental model explained with real examples.',
       false
FROM topic
WHERE slug = 'jpa-hibernate-and-spring-data-jpa';
