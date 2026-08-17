-- `java` kursuna dördüncü kategori: `functional-interfaces-streams` (java-basics=1,
-- oop=2, concurrency=3'ten sonra). Microservices wave 1 tamamlandıktan sonra
-- kullanıcının isteğiyle açıldı -- Microservices kategorisine ara verildi, kalan 9 aday
-- konu için devam kararı sonra birlikte verilecek.
--
-- Kullanıcı ChatGPT'nin hazırladığı 11 maddelik "Java Functional Interfaces & Streams"
-- planını paylaştı (Functional Interface, Built-in Functional Interfaces, Method
-- References, Lambda Expressions, Stream API, Intermediate/Terminal Operations,
-- Collectors, Optional, Primitive Streams, Parallel Streams) ve iki ayrı kategoriye mi
-- (Functional Interfaces / Streams) bölünsün diye sordu. Önerim (kullanıcı onayladı):
-- TEK kategori -- gerekçe: (1) kullanıcının vurguladığı "Functional Interface -> Lambda
-- -> Stream -> Intermediate -> Terminal" zincirini sürekli gösterme hedefi, bir
-- kategori sınırıyla bölünmeden en iyi tek kategoride korunuyor; (2) precedent'te tek
-- kategoride 9 topic'e kadar çıkılmış (Spring MVC), bu konunun toplam boyutu (7 topic
-- planlandı) bunun altında; (3) ikiye bölünseydi "Functional Interfaces" kategorisi
-- yalnızca 2 topic'ten oluşurdu, mevcut kategorilerin hepsi 3+ topic içeriyor.
--
-- ÖNEMLİ BULGU: bu konu sıfırdan başlamıyor -- `oop` kategorisindeki `interface`
-- dersinde zaten "Functional Interface ve Lambda" bölümü var (functional interface
-- tanımı, `@FunctionalInterface`, lambda'nın bağlantısı, `java.util.function`'a kısa
-- referans, `FunctionalInterfaceExample.java`). Yeni kategori bunu TEKRARLAMIYOR,
-- doğrudan `interface` dersine çapraz referans verip oradan derinleşiyor (bu projenin
-- standart "içerik tekrarlama, bkz. ver" pratiği).
--
-- SANDBOX AVANTAJI: bu kategori Spring Boot'un aksine hiçbir dış bağımlılık
-- gerektirmiyor (`java.util.function`/`java.util.stream` saf JDK) -- kullanıcı bu
-- fazda örneklerin gerçekten derlenip çalıştırılmasını onayladı (Faz 12'den beri
-- varsayılan olan "yazıldıktan sonra derleme yok" kuralına bilinçli bir istisna,
-- kullanıcının doğrudan onayıyla): tüm örnekler bu sandbox'ta `javac`+`java` ile
-- gerçekten çalıştırılıp çıktıları doğrulandıktan sonra içeriğe/dersin metnine işlendi.
--
-- Planlanan 7 topic (sort_order): 1) lambda-expressions, 2) built-in-functional-
-- interfaces (+ method references), 3) stream-fundamentals (+ intermediate operations),
-- 4) terminal-operations, 5) collectors, 6) optional, 7) primitive-parallel-streams.
-- Bu migration yalnızca kategoriyi ve ilk topic'i (lambda-expressions) açıyor.
--
-- INTERMEDIATE zorlukta -- `interface` dersiyle (oop kategorisi) aynı seviye.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Functional Interfaces & Streams', 'functional-interfaces-streams', 4
FROM course
WHERE slug = 'java';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'lambda-expressions', 'INTERMEDIATE', 20, 1
FROM category
WHERE slug = 'functional-interfaces-streams';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Lambda Expressions',
       'Lambda expression syntax''ının tamamı: parametre yazım kuralları, expression body vs block body, derleyicinin lambda''ya bağlamdan tip vermesi (target typing), effectively final değişken yakalama, ve lambda''nın anonymous inner class''tan farkı. Örnekler gerçekten derlenip çalıştırılarak doğrulandı.',
       'Java Lambda Expression Nedir? Syntax ve Örneklerle Anlatım',
       'Java''da lambda expression syntax''ı -- sıfır/tek/çoklu parametre yazımı, expression body ile block body arasındaki fark, derleyicinin lambda''yı bağlamdan (target type) çıkarması, effectively final kısıtı ve sebebi, ve lambda''nın anonymous inner class''a göre `this` davranışı farkı -- gerçek, derlenip çalıştırılmış Java örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'lambda-expressions';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Lambda Expressions',
       'The full syntax of lambda expressions: parameter-writing rules, expression body vs. block body, the compiler inferring a lambda''s type from context (target typing), capturing effectively final variables, and how a lambda differs from an anonymous inner class. Examples were actually compiled and run to verify them.',
       'What Is a Java Lambda Expression? Syntax Explained with Examples',
       'Java lambda expression syntax -- writing zero/one/multiple parameters, the difference between an expression body and a block body, the compiler inferring a lambda''s type from context (target type), the effectively-final capture restriction and why it exists, and how a lambda''s `this` differs from an anonymous inner class''s -- explained with real, compiled-and-run Java examples.',
       false
FROM topic
WHERE slug = 'lambda-expressions';
