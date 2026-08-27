-- Git Fundamentals kategorisinin 3. topic'i: "undoing-changes". Odak: restore vs
-- reset (soft/mixed/hard) vs revert, HEAD/staging area/working tree ilişkisi,
-- --hard'ın veri kaybı riski konusunda açık uyarı. INTERMEDIATE (reset --soft,
-- HEAD~N gibi kavramlar Getting Started'dan/Working With Commits'ten daha derin)
-- /30dk, sort_order=3.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'undoing-changes', 'INTERMEDIATE', 30, 3
FROM category
WHERE slug = 'git-fundamentals';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Undoing Changes',
       'git restore ile working tree değişikliklerini geri almak, git reset''in soft/mixed/hard modları arasındaki fark, ve git revert ile paylaşılan commit''leri güvenle geri almak. HEAD, staging area ve working tree arasındaki ilişki, ve git reset --hard''ın veri kaybı riski.',
       'Git''te Değişiklikleri Geri Almak: restore, reset, revert',
       'git restore, git reset (soft/mixed/hard) ve git revert arasındaki fark nedir, ve bir commit''i güvenle nasıl geri alırsın -- gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'undoing-changes';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Undoing Changes',
       'Undoing working tree changes with git restore, the difference between git reset''s soft/mixed/hard modes, and safely undoing shared commits with git revert. The relationship between HEAD, staging area, and working tree, and the data-loss risk of git reset --hard.',
       'Undoing Changes in Git: restore, reset, revert',
       'What''s the difference between git restore, git reset (soft/mixed/hard), and git revert, and how do you safely undo a commit -- explained with real examples.',
       false
FROM topic
WHERE slug = 'undoing-changes';
