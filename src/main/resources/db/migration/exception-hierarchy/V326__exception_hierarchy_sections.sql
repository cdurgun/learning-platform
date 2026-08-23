-- `exception-hierarchy` konusu, 4 örneğin tamamı. Kod yorumları ve açıklama
-- metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Throwable Zincirinde Yürümek', 'ThrowableHierarchyWalkExample', 1
FROM topic WHERE slug = 'exception-hierarchy';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'StackOverflowError: Bir Error Örneği', 'StackOverflowErrorExample', 2
FROM topic WHERE slug = 'exception-hierarchy';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Süper Sınıfla Yakalama (Polimorfik catch)', 'CatchingBySupertypeExample', 3
FROM topic WHERE slug = 'exception-hierarchy';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'instanceof ile Hiyerarşi Kontrolü', 'InstanceofHierarchyCheckExample', 4
FROM topic WHERE slug = 'exception-hierarchy';
