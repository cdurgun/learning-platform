-- Advanced Git kategorisinin 2. topic'i: "merge-conflicts". Kategori V450'de
-- zaten oluşturuldu. Odak: conflict marker'larının tam anlamı, gerçek Java kod
-- örnekleriyle çözme, merge/rebase sırasında aynı mekanik, --abort'un güvenli
-- kaçış kapısı olduğu. Kullanıcının açık talimatı gereği INTERMEDIATE/30dk,
-- sort_order=2.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'merge-conflicts', 'INTERMEDIATE', 30, 2
FROM category
WHERE slug = 'advanced-git';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Merge Conflicts',
       'Bir merge conflict''i tam olarak nedir, conflict marker''ları (<<<<<<<, =======, >>>>>>>) nasıl okunur, gerçek Java kod örnekleriyle nasıl çözülür, merge ve rebase sırasında aynı mekanik, ve git merge --abort/git rebase --abort ile güvenli iptal.',
       'Git''te Merge Conflict''lerini Çözmek',
       'Bir merge conflict''i nedir, conflict marker''ları ne anlama gelir, ve gerçek Java kod örnekleriyle nasıl çözülür -- pratik bir workflow''la anlatılıyor.',
       true
FROM topic
WHERE slug = 'merge-conflicts';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Merge Conflicts',
       'What a merge conflict is, how to read conflict markers (<<<<<<<, =======, >>>>>>>), how to resolve one with real Java code examples, the same mechanics during both merge and rebase, and safely canceling with git merge --abort/git rebase --abort.',
       'Resolving Merge Conflicts in Git',
       'What a merge conflict is, what conflict markers mean, and how to resolve one with real Java code examples -- explained with a practical workflow.',
       false
FROM topic
WHERE slug = 'merge-conflicts';
