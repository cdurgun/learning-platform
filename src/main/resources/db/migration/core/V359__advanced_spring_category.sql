-- Yeni bir kategori: "Advanced Spring" (spring-boot kursu, sort_order=4 --
-- spring-core(1)/spring-mvc(2)/microservices(3)'ten sonra, kursun sonuna
-- eklendi -- kullanıcı bu kategorinin yerini özellikle belirtmedi, yalnızca
-- "ayrı bir üst-seviye kategori, spring-core/spring-mvc/microservices'in
-- İÇİNE DEĞİL" dedi; V169'daki microservices kategori ekleme deseniyle
-- AYNI, kursun sonuna ekleme yaklaşımı izlendi).
--
-- Kullanıcı önce iki topic (Java Bean Validation, Exception Handling)
-- istedi, ama önce ÖNEMLİ bir çakışma tespit edilip kullanıcıya
-- AskUserQuestion ile soruldu: `spring-mvc` kategorisinde zaten
-- `validation-exception-handling` (Faz 22, V104-V107) adlı bir topic var --
-- @NotNull/@NotEmpty/@NotBlank, @Size/@Min/@Max, @Email/@Pattern, @Valid,
-- Validator/ConstraintViolation, cascading, @ExceptionHandler,
-- @RestControllerAdvice, ProblemDetail/RFC 7807'yi ZATEN kapsamlıca
-- işliyor (18 bölüm, 14 örnek). Kullanıcı kararı: bu temelleri BAŞTAN
-- ÖĞRETME -- Advanced Spring'in iki topic'i, var olan bilginin üzerine
-- inşa etsin, yalnızca GERÇEKTEN yeni ya da önemli ölçüde daha derin
-- materyale odaklansın (bkz. bu kategorinin iki topic'inin kendi
-- migration'larındaki ayrıntılı gerekçe).
--
-- ADVANCED zorlukta (spring-mvc'nin advanced-spring-mvc/rest-api-design/
-- spring-mvc-testing topic'leriyle aynı seviye) -- bu kategori açıkça
-- "temel bilgiyi zaten bilen okuyucu" varsayıyor.
--
-- Kullanıcının açık talimatı gereği şimdilik yalnızca 2 topic (Java Bean
-- Validation, Exception Handling) ekleniyor -- başka topic YOK, Pratik
-- Proje YOK. Bu migration yalnızca kategoriyi açıyor; topic'ler ayrı
-- migration'larda, TEK SEFERDE BİR TOPIC, her topic'ten sonra kullanıcı
-- onayı beklenerek eklenecek.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Advanced Spring', 'advanced-spring', 4
FROM course
WHERE slug = 'spring-boot';
