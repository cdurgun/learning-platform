-- `jpa-hibernate-and-spring-data-jpa` konusu, 3 örneğin tamamı. Kod
-- yorumları ve açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Düz Bir Java Nesnesi Olarak Topic', 'PlainJavaTopicExample', 1
FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Minimal Bir @Entity', 'MinimalEntityExample', 2
FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bu Projenin TopicRepository''si', 'TopicRepositoryExample', 3
FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa';
