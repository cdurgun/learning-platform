-- `try-catch-finally` konusu, 5 örneğin tamamı. Kod yorumları ve açıklama
-- metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Temel try-catch Bloğu', 'BasicTryCatchExample', 1
FROM topic WHERE slug = 'try-catch-finally';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Birden Fazla catch Bloğu', 'MultipleCatchBlocksExample', 2
FROM topic WHERE slug = 'try-catch-finally';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Multi-Catch: | ile Tek Blokta Yakalama', 'MultiCatchExample', 3
FROM topic WHERE slug = 'try-catch-finally';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'finally Her Zaman Çalışır', 'FinallyAlwaysRunsExample', 4
FROM topic WHERE slug = 'try-catch-finally';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'finally İçinde return''ün Tehlikesi', 'FinallyOverridingReturnExample', 5
FROM topic WHERE slug = 'try-catch-finally';
