-- Git Fundamentals kategorisinin 2. topic'i: "working-with-commits". Kategori
-- V432'de zaten oluşturuldu, burada yalnızca yeni bir topic + çevirileri.
-- Odak: commit mesajı kalitesi, git log/show, -am, --amend (VE amend'in var
-- olan commit'i yerinde değiştirmediği, yeni bir commit oluşturduğu -- kullanıcının
-- açık talimatı), HEAD ve HEAD~N referansları. BEGINNER/25dk, sort_order=2.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'working-with-commits', 'BEGINNER', 25, 2
FROM category
WHERE slug = 'git-fundamentals';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Working With Commits',
       'İyi commit mesajları yazmak, git log/git show ile geçmişte gezinmek, git commit -am, ve git commit --amend''in var olan bir commit''i yerinde değiştirmek yerine YENİ bir commit oluşturduğunu anlamak. HEAD ve HEAD~1/HEAD~2 referansları.',
       'Git Commit''leriyle Çalışmak: Mesajlar, Log, Amend, HEAD',
       'İyi commit mesajları nasıl yazılır, git log ve git show nasıl kullanılır, git commit --amend nasıl çalışır ve HEAD ne anlama gelir -- gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'working-with-commits';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Working With Commits',
       'Writing good commit messages, browsing history with git log/git show, git commit -am, and understanding that git commit --amend creates a NEW commit rather than editing the existing one in place. HEAD and HEAD~1/HEAD~2 references.',
       'Working With Git Commits: Messages, Log, Amend, HEAD',
       'How to write good commit messages, how to use git log and git show, how git commit --amend actually works, and what HEAD means -- explained with real examples.',
       false
FROM topic
WHERE slug = 'working-with-commits';
