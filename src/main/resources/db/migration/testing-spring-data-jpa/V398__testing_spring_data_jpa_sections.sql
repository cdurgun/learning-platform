-- `testing-spring-data-jpa` konusu, 5 örneğin tamamı. Kod yorumları ve
-- açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mock''lanmış Repository''nin Sınırı', 'MockedRepositoryLimitationExample', 1
FROM topic WHERE slug = 'testing-spring-data-jpa';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@DataJpaTest ve TestEntityManager', 'DataJpaTestWithTestEntityManagerExample', 2
FROM topic WHERE slug = 'testing-spring-data-jpa';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Derived Query Metodu Testi', 'DerivedQueryMethodTestExample', 3
FROM topic WHERE slug = 'testing-spring-data-jpa';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Custom @Query Testi', 'CustomQueryTestExample', 4
FROM topic WHERE slug = 'testing-spring-data-jpa';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Testcontainers Taslağı', 'TestcontainersSketchExample', 5
FROM topic WHERE slug = 'testing-spring-data-jpa';
