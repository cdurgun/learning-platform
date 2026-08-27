-- java/spring-boot/react/ai/postgresql'den sonra ALTINCI Course -- "Git & GitHub"
-- (course.slug = 'git-github'). Kullanıcı önce plan mode'da tam bir 11 topic'lik
-- roadmap istedi (2 kategori: "Git Fundamentals" 6 topic, "Advanced Git" 5 topic),
-- ChatGPT ile birlikte detaylı bir bölüm/başlık listesi hazırladı, ve onayladı.
-- postgresql'in (V400) BİREBİR aynı deseni: course + ilk kategori + ilk topic tek
-- migration'da, sort_order=6 ile kursun sonuna ekleniyor.
--
-- Kategori: "Git Fundamentals" (category.sort_order=1) -- kursun ilk kategorisi,
-- solo/temel Git kullanımını kapsayan 6 topic'i taşıyacak (yalnızca bu fazda 1.
-- topic ekleniyor). "Advanced Git" (sort_order=2, 5 topic, rebase/squash/stash/
-- conflict/best-practices/practical-workflow) henüz eklenmedi.
--
-- 1. topic: "git-fundamentals" -- kategoriyle AYNI isim ama farklı kavram (kategori
-- kursun bir bölümü, topic tek bir ders) -- what-is-react/what-is-ai/postgresql-
-- and-the-relational-model desenindeki gibi kursun/kategorinin ilk dersi olsa da,
-- BİLİNÇLİ OLARAK o desenden SAPIYOR: bu topic 0 embed'li saf bir oryantasyon
-- DEĞİL, gerçek komutlar (git init/status/add/commit/diff/log) içeren, working
-- tree/staging area/repository zihinsel modelini KURAN ilk gerçek ders -- kullanıcının
-- kendi curriculum'unda "Getting Started with Git" bu şekilde tanımlandı.
-- INTERMEDIATE değil BEGINNER (10 bölüm ama tamamı temel sözdizimi), 30 dk.

INSERT INTO course (name, slug, sort_order)
VALUES ('Git & GitHub', 'git-github', 6);

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Git Fundamentals', 'git-fundamentals', 1
FROM course
WHERE slug = 'git-github';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'git-fundamentals', 'BEGINNER', 30, 1
FROM category
WHERE slug = 'git-fundamentals';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Git Fundamentals',
       'Git nedir, GitHub''dan nasıl farklıdır, ve working tree/staging area/repository zihinsel modeli -- git init, status, add, commit, diff ve log ile. Git & GitHub kursunun ve Git Fundamentals kategorisinin 1.''si.',
       'Git Temelleri: Working Tree, Staging Area, Repository',
       'Git nedir, GitHub''dan farkı nedir, ve bir Git repository''sinde çalışmanın temel akışı -- git init, status, add, commit, diff, log -- gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'git-fundamentals';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Git Fundamentals',
       'What Git is, how it differs from GitHub, and the working tree/staging area/repository mental model -- via git init, status, add, commit, diff, and log. The 1st lesson in both the Git & GitHub course and its Git Fundamentals category.',
       'Git Fundamentals: Working Tree, Staging Area, Repository',
       'What Git is, how it differs from GitHub, and the core flow of working in a Git repository -- git init, status, add, commit, diff, log -- explained with real examples.',
       false
FROM topic
WHERE slug = 'git-fundamentals';
