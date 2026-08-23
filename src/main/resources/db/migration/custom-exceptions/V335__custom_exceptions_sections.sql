-- `custom-exceptions` konusu, 4 örneğin tamamı. Kod yorumları ve açıklama
-- metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Minimal Custom Exception', 'BasicCustomExceptionExample', 1
FROM topic WHERE slug = 'custom-exceptions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Ekstra Bağlam Taşıyan Custom Exception', 'CustomExceptionWithContextExample', 2
FROM topic WHERE slug = 'custom-exceptions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Standart Constructor''ları Yansıtmak', 'CustomExceptionConstructorsExample', 3
FROM topic WHERE slug = 'custom-exceptions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Kendi Exception Hiyerarşini Kurmak', 'CustomExceptionHierarchyExample', 4
FROM topic WHERE slug = 'custom-exceptions';
