-- java/spring-boot/react/ai'dan sonra BEŞİNCİ Course -- "PostgreSQL"
-- (course.slug = 'postgresql'). Kullanıcı, PLAN MODE'da önce tam bir 14
-- topic'lik (2 kategori: "PostgreSQL Foundations" 10 topic, "Advanced
-- PostgreSQL" 4 topic) roadmap istedi ve onayladı (bkz. docs/phase-log.md'nin
-- bu faz notundaki tam liste). Course tablosunda ARTIK gerçek bir
-- sort_order var (bkz. V234) -- 'ai'nin (V235) yaptığı gibi, insert
-- sırasına güvenmeden 'postgresql' sort_order=5 ile doğrudan ekleniyor,
-- kursun sonuna (V235'teki AYNI "kursun sonuna ekle" deseni).
--
-- Bu, Spring Boot'un bir uzantısı DEĞİL, kendi başına duran, bağımsız bir
-- kurs -- ama Spring Data JPA kursuyla (Faz 115-123) bilinçli olarak
-- bağlantılı: bu ilk topic'in kendisi, o kursun "JPA, Hibernate, and
-- Spring Data JPA" topic'inin (Faz 115) tam olarak bıraktığı yerden --
-- Hibernate'in SQL'e çevirdiği katmanın ALTINDA, PostgreSQL'in kendisinde
-- gerçekte ne olduğundan -- devam ediyor.
--
-- Kategori: "PostgreSQL Foundations" (category.sort_order=1) -- kursun
-- ilk kategorisi, roadmap'in onaylanan 10 topic'lik ilk yarısını
-- taşıyacak (yalnızca bu fazda 1. topic ekleniyor). "Advanced PostgreSQL"
-- (sort_order=2, 4 topic) henüz eklenmedi.
--
-- 1. topic: "postgresql-and-the-relational-model" -- react-fundamentals'ın
-- "what-is-react"i ve ai-fundamentals'ın "what-is-ai"siyle AYNI desen:
-- kursun VE kategorinin ilk dersi, bilinçli olarak KOD YOK (0 embed) --
-- amaç SQL sözdizimi değil, doğru bir zihinsel model kurmak. Kullanıcının
-- açık talimatı gereği burada yalnızca ORYANTASYON var: ilişkisel
-- veritabanı nedir, PostgreSQL nedir, Spring Boot → Spring Data JPA →
-- Hibernate → SQL → PostgreSQL yığını, ve ACID'e yalnızca YÜZEYSEL bir
-- ilk bakış (tam işleniş roadmap'in 14. topic'i "Transactions and
-- Concurrency in PostgreSQL"a bırakıldı). BEGINNER/15dk, what-is-ai'yle
-- (Faz 70, V236) BİREBİR aynı "kursun/kategorinin ilk, kod içermeyen
-- dersi" ölçeği.

INSERT INTO course (name, slug, sort_order)
VALUES ('PostgreSQL', 'postgresql', 5);

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'PostgreSQL Foundations', 'postgresql-foundations', 1
FROM course
WHERE slug = 'postgresql';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'postgresql-and-the-relational-model', 'BEGINNER', 15, 1
FROM category
WHERE slug = 'postgresql-foundations';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'PostgreSQL ve İlişkisel Model',
       'İlişkisel bir veritabanının ne olduğu, PostgreSQL''in özellikle ne olduğu, Spring Boot → Spring Data JPA → Hibernate → SQL → PostgreSQL yığını, ve bu projenin gerçek TopicRepository''sinin bir çağrısının bu yığından nasıl geçtiği -- hiç SQL sözdizimi olmadan, yalnızca zihinsel model. PostgreSQL kursunun ve PostgreSQL Foundations kategorisinin 1.''si.',
       'PostgreSQL ve İlişkisel Veritabanı Modeli',
       'PostgreSQL nedir, ilişkisel bir veritabanı ne çözer, ve bir Spring Boot uygulamasında Spring Data JPA''dan PostgreSQL''e kadar olan yığın gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'postgresql-and-the-relational-model';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'PostgreSQL and the Relational Model',
       'What a relational database actually is, what PostgreSQL is specifically, the Spring Boot → Spring Data JPA → Hibernate → SQL → PostgreSQL stack, and how a call to this project''s own real TopicRepository travels through it -- no SQL syntax yet, just the mental model. The 1st lesson in both the PostgreSQL course and its PostgreSQL Foundations category.',
       'PostgreSQL and the Relational Database Model',
       'What PostgreSQL is, what problem a relational database solves, and the stack from Spring Data JPA down to PostgreSQL in a Spring Boot application, explained with real examples.',
       false
FROM topic
WHERE slug = 'postgresql-and-the-relational-model';
