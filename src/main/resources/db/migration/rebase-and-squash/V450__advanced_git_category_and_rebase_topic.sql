-- Git & GitHub kursunun 2. kategorisi: "Advanced Git" (category.sort_order=2).
-- Git Fundamentals'ın (V432, sort_order=1) BİREBİR aynı deseni -- kategori + ilk
-- topic tek migration'da, postgresql'in Foundations/Advanced ayrımıyla AYNI şekil.
--
-- 1. topic: "rebase-and-squash" -- kullanıcının curriculum'unda Advanced Git'in
-- ilk topic'i. Odak: rebase vs merge, git rebase -i (squash/fixup/reword/reorder),
-- rebase conflict'leri, paylaşılan geçmişi yeniden yazmanın tehlikesi, ve
-- --force-with-lease'in --force'a neden tercih edildiği. Kullanıcının açık
-- talimatı gereği (DIFFICULTY bölümü: "Rebase, Squash, Merge Conflicts, Stash
-- and Advanced Git should be INTERMEDIATE") INTERMEDIATE -- ADVANCED değil.
-- /35dk (12 bölüm, kategorinin en yoğun topic'lerinden), sort_order=1.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Advanced Git', 'advanced-git', 2
FROM course
WHERE slug = 'git-github';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'rebase-and-squash', 'INTERMEDIATE', 35, 1
FROM category
WHERE slug = 'advanced-git';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Rebase & Squash',
       'Rebase nedir, merge''den farkı, git rebase -i ile commit''leri squash/reorder/reword etmek, rebase conflict''lerini çözmek, paylaşılan geçmişi yeniden yazmanın tehlikesi, ve git push --force ile --force-with-lease arasındaki fark.',
       'Git Rebase ve Squash: Temiz Bir Geçmiş İnşa Etmek',
       'git rebase nasıl çalışır, merge''den farkı nedir, git rebase -i ile commit''ler nasıl squash edilir, ve force push neden dikkatli kullanılmalıdır -- gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'rebase-and-squash';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Rebase & Squash',
       'What rebase is, how it differs from merge, squashing/reordering/rewording commits with git rebase -i, resolving rebase conflicts, the danger of rewriting shared history, and the difference between git push --force and --force-with-lease.',
       'Git Rebase and Squash: Building a Clean History',
       'How git rebase works, how it differs from merge, how to squash commits with git rebase -i, and why force push needs to be used carefully -- explained with real examples.',
       false
FROM topic
WHERE slug = 'rebase-and-squash';
