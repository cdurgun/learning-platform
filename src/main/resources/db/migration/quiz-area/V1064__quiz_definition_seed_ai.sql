-- Quiz Area: initial content for the "AI Quiz" nav group -- BİREBİR AYNI desen
-- V430__quiz_definition_seed_java.sql (Java Quiz) ve
-- V1015__quiz_definition_seed_spring_boot.sql'in (Spring Quiz) kullandığı desen.
--
-- Scope decisions (bu Faz'da teyit edilen yapı):
--   basic-ai    = ai-fundamentals kategorisinin TAMAMI
--   advanced-ai = large-language-models + tools-mcp + ai-agents +
--                 ai-development-tools kategorilerinin TAMAMI
--   all-ai      = ai kursunun TAMAMI -- Java'nın "all-java"sı ve Spring'in
--                 "all-spring"iyle AYNI desen: quiz_definition_category'de
--                 bilerek HİÇ satırı yok (boş kapsam = tüm kurs konvansiyonu,
--                 bkz. QuizDefinition javadoc'u), bu yüzden ai kursuna
--                 ileride eklenecek herhangi bir kategori otomatik olarak
--                 buraya da dahil olur, ek bir migration gerekmeden.
--
-- Kullanıcının isteği "Temel AI" için "AI Fundamentals + Large Language
-- Models'ten uygun giriş seviyesi kavramlar" şeklindeydi -- ama Quiz Area
-- mimarisi (QuestionRepository.findRandomPublishedPoolByCourseAndCategories)
-- yalnızca KATEGORİ seviyesinde scope alıyor, topic seviyesinde değil
-- (bkz. QuizDefinitionService/QuizDefinition javadoc'u) -- Practice modunün
-- aksine Quiz Area hiçbir zaman topic-seviyeli bir filtre desteklemedi.
-- Bir kategoriyi ikiye bölüp yarısını bir quiz'e yarısını başka bir quiz'e
-- vermek YENİ bir mekanizma (topic-seviyeli quiz_definition scope'u)
-- gerektirirdi -- kullanıcının açık "Do NOT redesign the quiz system" /
-- "Do NOT introduce a new quiz architecture" talimatı gereği bu YAPILMADI.
-- Bunun yerine, Java'nın basic-java/advanced-java'sı ve Spring'in 5 ayrı
-- kategori quiz'iyle AYNI, zaten var olan desen izlendi: her kategori
-- BÜTÜN olarak tek bir quiz'e atandı (large-language-models bütünüyle
-- advanced-ai'a gitti, basic-ai'a değil).
--
-- Category subqueries, category.slug'ın yalnızca kurs başına unique olması
-- nedeniyle (uq_category_course_slug, core/V1) hem course.slug hem
-- category.slug ile scope'lanıyor -- V430/V1015'teki AYNI gerekçe.
--
-- question_count: basic-ai/advanced-ai için 10 (Java/Spring'in kategori-
-- kapsamlı quiz'leriyle AYNI, mevcut Practice DEFAULT_COUNT konvansiyonuyla
-- eşleşir), all-ai için 20 (Java'nın all-java'sı ve Spring'in all-spring'iyle
-- AYNI, kapsamı tüm kursu kapsadığı için orantılı olarak daha büyük).
--
-- ÖNEMLİ, kullanıcıya AYRICA raporlanan gerçek bir bulgu: bu migration
-- yazıldığı anda `ai-development-tools` kategorisinin soru havuzunda HİÇ
-- PUBLISHED soru YOK (0) -- advanced-ai ve all-ai quiz_definition'ları yine
-- de bu kategoriyi kapsıyor (kullanıcının açıkça istediği 4 kategoriden
-- biri olduğu için), tıpkı Spring'in "microservices" kategorisinin 0 soru
-- olsa bile quiz_definition'a dahil edilmesi gibi -- QuizDefinitionService
-- .draw()'ın 0 uygun soru için zaten test edilmiş, hatasız davranışına
-- güveniliyor (bkz. QuizDefinitionServiceTest#drawReturnsEmptyListWhenNoEligibleQuestionsExist).
-- Diğer 4 kategori (ai-fundamentals, large-language-models, tools-mcp,
-- ai-agents) her biri 28 EN + 28 TR PUBLISHED soruya sahip -- basic-ai'ın
-- 10'luk havuzu (28) ve advanced-ai'ın 10'luk havuzu (84, ai-development-
-- tools'un 0'ı dahil) rahatça karşılıyor; all-ai'ın 20'lik havuzu da (112)
-- rahatça karşılıyor.
INSERT INTO quiz_definition (course_id, slug, question_count, active, sort_order)
VALUES
    ((SELECT id FROM course WHERE slug = 'ai'), 'basic-ai', 10, true, 1),
    ((SELECT id FROM course WHERE slug = 'ai'), 'advanced-ai', 10, true, 2),
    ((SELECT id FROM course WHERE slug = 'ai'), 'all-ai', 20, true, 3);

INSERT INTO quiz_definition_category (quiz_definition_id, category_id)
VALUES
    ((SELECT id FROM quiz_definition WHERE slug = 'basic-ai'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'ai' AND c.slug = 'ai-fundamentals')),

    ((SELECT id FROM quiz_definition WHERE slug = 'advanced-ai'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'ai' AND c.slug = 'large-language-models')),
    ((SELECT id FROM quiz_definition WHERE slug = 'advanced-ai'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'ai' AND c.slug = 'tools-mcp')),
    ((SELECT id FROM quiz_definition WHERE slug = 'advanced-ai'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'ai' AND c.slug = 'ai-agents')),
    ((SELECT id FROM quiz_definition WHERE slug = 'advanced-ai'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'ai' AND c.slug = 'ai-development-tools'));
    -- all-ai intentionally gets NO rows here (whole-course convention, same as all-java/all-spring).
