-- `relationships-fetching-and-n-plus-1` konusu, 6 örneğin tamamı. Kod
-- yorumları ve açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@ManyToOne''un Diğer Tarafı: @OneToMany', 'OneToManyRelationshipExample', 1
FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@ManyToMany ve Join Table', 'ManyToManyRelationshipExample', 2
FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Cascade Türleri ve orphanRemoval', 'CascadeAndOrphanRemovalExample', 3
FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'N+1 Problemi', 'NPlusOneProblemExample', 4
FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@EntityGraph ile Düzeltmek', 'EntityGraphExample', 5
FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Batch Fetching ile Düzeltmek', 'BatchFetchSizeExample', 6
FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1';
