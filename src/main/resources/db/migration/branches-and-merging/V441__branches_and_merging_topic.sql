-- Git Fundamentals kategorisinin 4. topic'i: "branches-and-merging". Odak: branch
-- yaşam döngüsü (oluştur/switch/rename/sil), fast-forward vs merge commit,
-- conflict'lere giriş (tam derinlik Advanced Git'teki "merge-conflicts" topic'ine
-- bırakılıyor), git switch'in git checkout'a tercih edilme sebebi. INTERMEDIATE
-- (13 bölüm, en büyük Fundamentals topic'i)/35dk, sort_order=4.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'branches-and-merging', 'INTERMEDIATE', 35, 4
FROM category
WHERE slug = 'git-fundamentals';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Branches & Merging',
       'Branch oluşturmak/silmek/yeniden adlandırmak, git switch ile branch değiştirmek, git merge ile fast-forward ve merge commit''in farkı, merge conflict''lere giriş, ve gerçekçi bir Spring Boot feature branch workflow''u. git switch''in git checkout''a neden tercih edildiği.',
       'Git''te Branch''ler ve Merge Etmek',
       'Branch nasıl oluşturulur, git switch ile nasıl geçilir, fast-forward merge ile merge commit arasındaki fark nedir, ve gerçekçi bir feature branch workflow''u nasıl işler -- gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'branches-and-merging';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Branches & Merging',
       'Creating, deleting, and renaming branches, switching with git switch, the difference between a fast-forward merge and a merge commit, an introduction to merge conflicts, and a realistic Spring Boot feature branch workflow. Why git switch is preferred over git checkout.',
       'Git Branches and Merging',
       'How to create branches, switch with git switch, the difference between a fast-forward merge and a merge commit, and how a realistic feature branch workflow works -- explained with real examples.',
       false
FROM topic
WHERE slug = 'branches-and-merging';
