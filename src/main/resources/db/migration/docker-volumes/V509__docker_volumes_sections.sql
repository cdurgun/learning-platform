-- `docker-volumes` konusu, 1 örnek (bir named volume oluşturup PostgreSQL'e
-- mount eden, veri yazan, container'ı tamamen kaldırıp yeniden oluşturan,
-- ve verinin hayatta kaldığını doğrulayan tam akış) + sabit quiz shell'i
-- (TR+EN, SORU İÇERMİYOR -- bkz. V433/V494).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Proving Data Survives Container Removal', 'VolumePersistenceDemo', 1
FROM topic WHERE slug = 'docker-volumes';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'docker-volumes';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'docker-volumes';
