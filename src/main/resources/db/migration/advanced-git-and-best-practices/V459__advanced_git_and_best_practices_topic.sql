-- Advanced Git kategorisinin 4. topic'i: "advanced-git-and-best-practices". Odak:
-- cherry-pick, reflog (özellikle kayıp commit kurtarma vurgusu -- kullanıcının
-- açık talimatı), blame, alias'lar, branch/commit konvansiyonları, ve
-- merge/rebase/squash/revert'i özetleyen bir karşılaştırma tablosu. Kullanıcının
-- açık talimatı gereği Git internal'lerine, webhook'lara ya da karmaşık kurumsal
-- branching stratejilerine GİRİLMİYOR. Kullanıcının açık talimatı gereği
-- INTERMEDIATE/30dk, sort_order=4.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'advanced-git-and-best-practices', 'INTERMEDIATE', 30, 4
FROM category
WHERE slug = 'advanced-git';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Advanced Git & Best Practices',
       'git cherry-pick, git reflog (özellikle kayıp commit''leri kurtarma mekanizması olarak), git blame, alias''lar, iyi branch/commit konvansiyonları, ve merge/rebase/squash/revert''i özetleyen bir karşılaştırma. Bir geliştirme takımı için Git en iyi pratikleri.',
       'İleri Git ve En İyi Pratikler: reflog, cherry-pick, blame',
       'git cherry-pick, git reflog ile kayıp commit''leri kurtarma, git blame, ve bir takım için Git en iyi pratikleri -- gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'advanced-git-and-best-practices';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Advanced Git & Best Practices',
       'git cherry-pick, git reflog (especially as a recovery mechanism for lost commits), git blame, aliases, good branch/commit conventions, and a comparison tying together merge/rebase/squash/revert. Git best practices for a development team.',
       'Advanced Git and Best Practices: reflog, cherry-pick, blame',
       'git cherry-pick, recovering lost commits with git reflog, git blame, and Git best practices for a team -- explained with real examples.',
       false
FROM topic
WHERE slug = 'advanced-git-and-best-practices';
