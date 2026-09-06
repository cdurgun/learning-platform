-- Quiz Area: initial content for the "Spring Quiz" nav group -- BİREBİR AYNI desen
-- V430__quiz_definition_seed_java.sql'in (Java Quiz nav group) kullandığı desen,
-- kullanıcının açık talebiyle: "reuse the same architecture ... as closely as
-- possible", "Do NOT create a separate or unnecessarily different quiz architecture".
--
-- Scope decisions (bu Faz'da kullanıcıyla teyit edilen yapı):
--   spring-core     = Spring Core kategorisinin TAMAMI
--   spring-mvc      = Spring MVC kategorisinin TAMAMI
--   microservices   = Microservices kategorisinin TAMAMI
--   advanced-spring = Advanced Spring kategorisinin TAMAMI
--   spring-data-jpa = Spring Data JPA kategorisinin TAMAMI
--   all-spring      = spring-boot kursunun TAMAMI -- Java'nın "all-java"sıyla AYNI
--                     desen: quiz_definition_category'de bilerek HİÇ satırı yok
--                     (boş kapsam = tüm kurs konvansiyonu, bkz. QuizDefinition
--                     javadoc'u), bu yüzden spring-boot kursuna ileride eklenecek
--                     herhangi bir kategori otomatik olarak buraya da dahil olur,
--                     ek bir migration gerekmeden.
--
-- Java'dan farklı olarak Spring'in 5 kategorisi Java'daki gibi birden fazla
-- kategoriyi tek bir quiz'de GRUPLAMIYOR -- her kategori kendi başına zaten
-- kullanıcının istediği 1:1 quiz'i oluşturuyor (spring-core, spring-mvc, vb.
-- kendi category slug'larını doğrudan quiz_definition.slug olarak kullanıyor;
-- bu slug'ların course genelinde başka hiçbir kategoriyle çakışmadığı önceden
-- doğrulandı).
--
-- Category subqueries, category.slug'ın yalnızca kurs başına unique olması
-- nedeniyle (uq_category_course_slug, core/V1) hem course.slug hem category.slug
-- ile scope'lanıyor -- V430'daki AYNI gerekçe.
--
-- question_count: kategori-kapsamlı 5 quiz için 10 (Java'nın basic-java/
-- advanced-java'sıyla AYNI, mevcut Practice DEFAULT_COUNT konvansiyonuyla eşleşir),
-- all-spring için 20 (Java'nın all-java'sıyla AYNI, kapsamı tüm kursu kapsadığı
-- için orantılı olarak daha büyük).
--
-- ÖNEMLİ, kullanıcıya AYRICA raporlanan gerçek bir bulgu: bu migration
-- yazıldığı anda `microservices` kategorisinin soru havuzunda (PUBLISHED ya da
-- değil) HİÇ soru YOK -- bu quiz_definition satırı yine de, Java'nın
-- "advanced-java"sının (0 uygun soru bulunan bir senaryoda) zaten test edilmiş
-- ve belgelenmiş davranışıyla AYNI şekilde, QuizDefinitionService.draw()'ın 0
-- soru döndürmesi bir hata değil (bkz. servis javadoc'u ve
-- QuizDefinitionServiceTest#drawReturnsEmptyListWhenNoEligibleQuestionsExist) --
-- bu kategoriye soru eklenene kadar "Microservices" quiz'i boş bir sayfa
-- gösterecektir, template katmanı bunu zaten dostane şekilde ele alıyor.
INSERT INTO quiz_definition (course_id, slug, question_count, active, sort_order)
VALUES
    ((SELECT id FROM course WHERE slug = 'spring-boot'), 'spring-core', 10, true, 1),
    ((SELECT id FROM course WHERE slug = 'spring-boot'), 'spring-mvc', 10, true, 2),
    ((SELECT id FROM course WHERE slug = 'spring-boot'), 'microservices', 10, true, 3),
    ((SELECT id FROM course WHERE slug = 'spring-boot'), 'advanced-spring', 10, true, 4),
    ((SELECT id FROM course WHERE slug = 'spring-boot'), 'spring-data-jpa', 10, true, 5),
    ((SELECT id FROM course WHERE slug = 'spring-boot'), 'all-spring', 20, true, 6);

INSERT INTO quiz_definition_category (quiz_definition_id, category_id)
VALUES
    ((SELECT id FROM quiz_definition WHERE slug = 'spring-core'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'spring-boot' AND c.slug = 'spring-core')),

    ((SELECT id FROM quiz_definition WHERE slug = 'spring-mvc'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'spring-boot' AND c.slug = 'spring-mvc')),

    ((SELECT id FROM quiz_definition WHERE slug = 'microservices'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'spring-boot' AND c.slug = 'microservices')),

    ((SELECT id FROM quiz_definition WHERE slug = 'advanced-spring'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'spring-boot' AND c.slug = 'advanced-spring')),

    ((SELECT id FROM quiz_definition WHERE slug = 'spring-data-jpa'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'spring-boot' AND c.slug = 'spring-data-jpa'));
    -- all-spring intentionally gets NO rows here (whole-course convention, same as all-java).
