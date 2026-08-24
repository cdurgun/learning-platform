-- `advanced-spring` kategorisine, serinin 2. ve SON topic'i ekleniyor:
-- "exception-handling" -- java-bean-validation'ın (sort_order=1) hemen
-- ardına, sort_order=2. Kategori şu an tek topic içeriyor, sort_order
-- kaydırması gerekmiyor. (Not: bu slug, `java` kursunun `exceptions`
-- kategorisindeki `exception-handling-best-practices` -- Faz 104 -- ile
-- ÇAKIŞMIYOR, farklı ve global olarak unique bir slug; grep ile önceden
-- doğrulandı.)
--
-- Kullanıcı kararıyla (Faz 110'daki AskUserQuestion'ın devamı), bu topic
-- de spring-mvc'nin `validation-exception-handling` topic'inin ZATEN
-- işlediği temelleri (temel @ExceptionHandler, @RestControllerAdvice,
-- temel ProblemDetail) TEKRARLAMIYOR -- kullanıcının verdiği kesin gap
-- listesine odaklanıyor: MethodArgumentNotValidException'ın gerçekte ne
-- taşıdığı, validasyon hatalarını ProblemDetail'e dönüştürürken hem
-- getFieldErrors() hem getGlobalErrors()'ı okumak (ikincisi "Java Bean
-- Validation"daki (Faz 110) çapraz-alan custom kısıtın hatalarını
-- yakalamak için gerekli), custom ProblemDetail özellikleri (errorCode,
-- timestamp, ...), domain exception'ları doğru durum koduna eşlemek
-- (400/404/409/422/500 farkı), ResponseEntityExceptionHandler ile framework
-- exception'larını merkezileştirmek, ve internal detay sızdırmayan güvenli
-- hata yanıtları. Her bölüm `validation-exception-handling`e ("Validation &
-- Exception Handling") ve `java-bean-validation`a ("Java Bean Validation")
-- gerçek migration başlıklarıyla doğrulanmış referanslarla açılıyor.
--
-- ADVANCED zorlukta, java-bean-validation ile aynı seviye. Format: yeni
-- kategorinin konvansiyonu -- "## Ek: Mini Proje" YOK (kullanıcının açık
-- talimatı: bu kategoriye şimdilik Pratik Proje eklenmeyecek),
-- estimated_minutes 7 örnek nedeniyle java-bean-validation ile aynı
-- yükseklikte tutuldu.
--
-- **BU TOPIC İLE, kullanıcının istediği 2 topic'lik Advanced Spring
-- serisinin TAMAMI tamamlanıyor** -- CLAUDE.md'ye kilometre taşı olarak
-- yansıtılacak (bkz. bu faz'ın phase-log notu).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'exception-handling', 'ADVANCED', 35, 2
FROM category
WHERE slug = 'advanced-spring';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Exception Handling',
       'Spring MVC''nin "Validation & Exception Handling" ve bu kategorinin "Java Bean Validation" derslerinin üzerine inşa edilir -- MethodArgumentNotValidException''ın gerçekte ne taşıdığı, validasyon hatalarını ProblemDetail''e dönüştürmek (çapraz-alan hatalar dahil), custom ProblemDetail özellikleri, domain exception''ları doğru HTTP durum koduna (400/404/409/422/500) eşlemek, ResponseEntityExceptionHandler ile merkezileştirme, ve internal detay sızdırmayan güvenli hata yanıtları. Advanced Spring serisinin 2. ve son dersi.',
       'Spring Boot''ta İleri Seviye Exception Handling',
       'Spring Boot REST API''lerinde ileri seviye exception handling -- ProblemDetail özelleştirme, domain exception''ları HTTP durum kodlarına eşleme, ve güvenli hata yanıtları gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'exception-handling';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Exception Handling',
       'Builds on Spring MVC''s "Validation & Exception Handling" and this category''s "Java Bean Validation" -- what MethodArgumentNotValidException actually carries, turning validation failures into a ProblemDetail (including cross-field failures), custom ProblemDetail properties, mapping domain exceptions to the right HTTP status code (400/404/409/422/500), centralizing with ResponseEntityExceptionHandler, and safe error responses that don''t leak internal details. The 2nd and final lesson in the Advanced Spring series.',
       'Advanced Exception Handling in Spring Boot',
       'Advanced exception handling for Spring Boot REST APIs -- customizing ProblemDetail, mapping domain exceptions to HTTP status codes, and safe error responses, explained with real examples.',
       false
FROM topic
WHERE slug = 'exception-handling';
