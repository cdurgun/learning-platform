-- Git Fundamentals kategorisinin 6. (ve son) topic'i: "pull-requests". Kategorinin
-- SON topic'i -- kullanıcının curriculum'unda "Git Fundamentals" kategorisi tam
-- olarak 6 topic'le bitiyor. Odak: PR nedir, review/approve/request-changes akışı,
-- merge vs squash-and-merge, branch protection rules. 0 embed -- bu konu GitHub'ın
-- web UI'ında gerçekleşen bir süreci anlatıyor (what-is-react/postgresql-and-the-
-- relational-model'in "0 embed'li oryantasyon" deseninin AYNISI değil ama benzer
-- gerekçe: anlatılan eylemler bir terminalde çalıştırılabilir komutlar değil).
-- INTERMEDIATE/30dk, sort_order=6.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'pull-requests', 'INTERMEDIATE', 30, 6
FROM category
WHERE slug = 'git-fundamentals';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Pull Requests',
       'Pull Request nedir, gerçekçi bir feature branch workflow''u üzerinden nasıl oluşturulur/incelenir/onaylanır, merge vs squash-and-merge farkı, merge sonrası branch''leri silmek, ve branch protection rules.',
       'GitHub Pull Request''leri: Oluşturmak, İncelemek, Merge Etmek',
       'Bir Pull Request nedir, nasıl oluşturulur, nasıl incelenir ve onaylanır, ve merge ile squash-and-merge arasındaki fark nedir -- gerçekçi bir Spring Boot örneğiyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'pull-requests';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Pull Requests',
       'What a Pull Request is, how to create/review/approve one through a realistic feature branch workflow, the difference between merge and squash-and-merge, deleting branches after merge, and branch protection rules.',
       'GitHub Pull Requests: Creating, Reviewing, Merging',
       'What a Pull Request is, how to create one, how it gets reviewed and approved, and what the difference is between merge and squash-and-merge -- explained with a realistic Spring Boot example.',
       false
FROM topic
WHERE slug = 'pull-requests';
