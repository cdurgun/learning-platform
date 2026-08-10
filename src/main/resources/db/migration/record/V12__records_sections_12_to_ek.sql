-- Record konusu, 12-17. bölümler (Serialization & Reflection, Best Practices, Yaygın
-- Hatalar, Gerçek Dünya Örnekleri, Mülakat Soruları, Özet) ile Record vs Lombok ve
-- Record Patterns eklerinin örnek metadata'sı. Dosyaların kendisi examples/records/
-- altında; bağlantı, enum konusunda olduğu gibi slug + example_name convention'ıyla.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Serializable Record ve Deserialization Doğrulaması', 'SerializableRecordExample', 15
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Reflection ile Bileşenleri İnceleme', 'ReflectionExample', 16
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Spring Boot: İstek DTO''su (CreateUserRequest)', 'CreateUserRequest', 17
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Spring Boot: Yanıt DTO''su (UserResponse)', 'UserResponse', 18
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Spring Boot: Controller Kullanımı', 'UserController', 19
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Record Patterns: Sealed Interface + switch', 'SealedShapeExample', 20
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Record Patterns: İç İçe Deconstruction', 'NestedPatternExample', 21
FROM topic WHERE slug = 'records';
