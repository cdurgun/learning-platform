-- `merge-conflicts` konusu, 1 örnek (conflict oluşturma + çözme + merge'i
-- tamamlama tam akışı) + sabit quiz shell'i (TR+EN, SORU İÇERMİYOR).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Resolving a Merge Conflict', 'ResolveMergeConflictDemo', 1
FROM topic WHERE slug = 'merge-conflicts';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'merge-conflicts';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'merge-conflicts';
