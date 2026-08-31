-- `docker-networking` konusu, 1 örnek (bir user-defined network oluşturup
-- bu projenin kendi app + db container'larını isimle birbirine bağlayan
-- tam akış) + sabit quiz shell'i (TR+EN, SORU İÇERMİYOR -- bkz. V433/V494).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Connecting This Project''s App and Database by Name', 'CreateNetworkAndConnectDemo', 1
FROM topic WHERE slug = 'docker-networking';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'docker-networking';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'docker-networking';
