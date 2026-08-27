-- Git Fundamentals kategorisinin 5. topic'i: "github-and-remotes". Odak: remote
-- kavramı, clone/push/fetch/pull, fetch'in pull'dan farkı (kullanıcının açık
-- talimatı: "fetch = entegre etmeden indir, pull = fetch + entegre"), commit
-- edilmemiş değişikliklerle pull çalıştırmanın ne yaptığı, tracking branch'ler.
-- INTERMEDIATE (13 bölüm)/35dk, sort_order=5.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'github-and-remotes', 'INTERMEDIATE', 35, 5
FROM category
WHERE slug = 'git-fundamentals';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'GitHub & Remotes',
       'Remote nedir, git clone/push/fetch/pull nasıl çalışır, fetch''in pull''dan farkı (fetch: entegre etmeden indir, pull: fetch + entegre), tracking branch''ler ve git push -u, ve yerel/remote branch''leri senkronize etmek.',
       'GitHub ve Git Remote''ları: clone, push, fetch, pull',
       'Bir remote nedir, git clone/push/fetch/pull nasıl kullanılır, fetch ile pull arasındaki fark nedir -- gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'github-and-remotes';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'GitHub & Remotes',
       'What a remote is, how git clone/push/fetch/pull work, the difference between fetch and pull (fetch: download without integrating, pull: fetch + integrate), tracking branches and git push -u, and synchronizing local and remote branches.',
       'GitHub and Git Remotes: clone, push, fetch, pull',
       'What a remote is, how to use git clone/push/fetch/pull, and what the difference is between fetch and pull -- explained with real examples.',
       false
FROM topic
WHERE slug = 'github-and-remotes';
