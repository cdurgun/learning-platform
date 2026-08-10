-- Faz 13: Java içeriğinden sonraki ilk kurs -- "Spring Boot". Course > Category > Topic
-- hiyerarşisi zaten çok-kurslu tasarlanmıştı (bkz. NavigationService.buildNavigation,
-- tüm course'ları dolaşıyor), bu yüzden yeni bir kurs açmak hiçbir Java kodu değişikliği
-- gerektirmiyor -- yalnızca bu iskelet migration'ı.
--
-- İlk kategori "Spring Core" (Concurrency'nin açıldığı desenle aynı: Category adı
-- İngilizce, çünkü CategoryTranslation yok). İlk konu "Dependency Injection & IoC" --
-- Spring Core kategorisi planı 4 konuya bölündü (bu, Spring IoC Container & Bean
-- Lifecycle, Component Scanning & Configuration, Spring Boot Auto-Configuration &
-- Properties izleyecek), her biri Interface/Threads ölçeğinde kendi topic'i olacak, tek
-- bir dev sayfa değil.
--
-- Bu konu, DI/IoC'yi Spring'e hiç değinmeden (Reflection dersindeki "Basit Dependency
-- Injection Container" mini projesine benzer şekilde, ama bu kez saf constructor/setter/
-- field injection üzerinden) elle öğretiyor; container'ın kendisi bir sonraki konuya
-- bırakıldı. Interface'le aynı INTERMEDIATE zorlukta işaretlendi -- Reflection/Threads
-- kadar JVM-içi derinliği yok, ama Record'dan daha kapsamlı bir tasarım konusu.
--
-- Şimdilik yalnızca iskelet (course + category + topic + çeviriler) var --
-- estimated_minutes buna göre düşük tutuldu, içerik önceki konularda yaptığımız gibi
-- kademeli olarak eklenecek. Kullanıcı kararıyla bu fazda yalnızca TR tamamlanıyor; EN
-- çevirisi ayrı bir sonraki fazda ele alınacak (bu yüzden EN çevirisi published=false).

INSERT INTO course (name, slug)
VALUES ('Spring Boot', 'spring-boot');

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Spring Core', 'spring-core', 1
FROM course
WHERE slug = 'spring-boot';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'dependency-injection', 'INTERMEDIATE', 5, 1
FROM category
WHERE slug = 'spring-core';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Dependency Injection ve IoC',
       'Spring''e değinmeden, saf Java ile Inversion of Control, Dependency Injection ve constructor/setter/field injection.',
       'Dependency Injection ve IoC Nedir? | Örneklerle Anlatım',
       'Java''da Inversion of Control (IoC) ve Dependency Injection (DI); sıkı bağlılık problemi, constructor/setter/field injection, test edilebilirlik ve composition root deseni gerçek dünya örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'dependency-injection';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Dependency Injection & IoC',
       'Inversion of Control, Dependency Injection, and constructor/setter/field injection in plain Java -- no Spring required.',
       'What Are Dependency Injection & IoC? | With Examples',
       'Learn Inversion of Control (IoC) and Dependency Injection (DI) in Java: the tight coupling problem, constructor/setter/field injection, testability, and the composition root pattern with real-world examples.',
       false
FROM topic
WHERE slug = 'dependency-injection';
