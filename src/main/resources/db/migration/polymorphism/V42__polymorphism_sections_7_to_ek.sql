-- Polymorphism konusu, 7-10. bölümler (Composition ile Polymorphism, instanceof: Ne
-- Zaman Kullanılmalı, Koleksiyonlarda Polymorphism, Gerçek Dünya Örnekleri) ile iki mini
-- proje ekinin (İndirim Hesaplama, Bildirim Gönderme Sistemi) örnek metadata'sı.
-- Dosyaların kendisi examples/polymorphism/ altında; bağlantı, önceki konularda olduğu
-- gibi slug + example_name convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Composition ile Polymorphism (Strategy Pattern)', 'TextFormatterStrategyExample', 7
FROM topic WHERE slug = 'polymorphism';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'instanceof: Tasarım Rehberliği', 'InstanceofDesignExample', 8
FROM topic WHERE slug = 'polymorphism';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Koleksiyonlarda Polymorphism', 'CollectionPolymorphismExample', 9
FROM topic WHERE slug = 'polymorphism';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Gerçek Dünya Örneği: DataSource Hiyerarşisi', 'RealWorldPolymorphismExample', 10
FROM topic WHERE slug = 'polymorphism';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: İndirim Hesaplama (DiscountStrategy)', 'DiscountStrategy', 11
FROM topic WHERE slug = 'polymorphism';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: İndirim Hesaplama Kullanımı', 'DiscountStrategyDemo', 12
FROM topic WHERE slug = 'polymorphism';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Bildirim Gönderme Sistemi (NotificationSender)', 'NotificationSender', 13
FROM topic WHERE slug = 'polymorphism';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Bildirim Gönderme Sistemi Kullanımı', 'NotificationSenderDemo', 14
FROM topic WHERE slug = 'polymorphism';
