-- `entities-and-repositories` konusu, 5 örneğin tamamı. Kod yorumları ve
-- açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Tam Bir Entity Mapping''i', 'EntityMappingExample', 1
FROM topic WHERE slug = 'entities-and-repositories';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Enumerated ile Enum Alanları', 'EnumeratedFieldExample', 2
FROM topic WHERE slug = 'entities-and-repositories';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İyi Biçimlendirilmiş Bir Entity''nin Kuralları', 'WellFormedEntityRulesExample', 3
FROM topic WHERE slug = 'entities-and-repositories';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Entity vs. DTO', 'EntityVsDtoExample', 4
FROM topic WHERE slug = 'entities-and-repositories';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Repository Hiyerarşisi', 'RepositoryHierarchyExample', 5
FROM topic WHERE slug = 'entities-and-repositories';
