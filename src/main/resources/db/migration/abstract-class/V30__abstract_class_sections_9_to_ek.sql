-- Abstract Class konusu, 9-19. bölümler (Interface Implement Etmesi, Abstract Class vs
-- Interface, Template Method Pattern, Gerçek Dünya Kullanım Alanları, Best Practices,
-- Yaygın Hatalar, Özet) ile iki mini proje ekinin (Rapor Pipeline'ı, Ödeme İşleyici)
-- örnek metadata'sı. Dosyaların kendisi examples/abstract-class/ altında; bağlantı, önceki
-- konularda olduğu gibi slug + example_name convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Abstract Class''ın Interface Implement Etmesi', 'AbstractImplementsInterfaceExample', 9
FROM topic WHERE slug = 'abstract-class';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Template Method Pattern', 'TemplateMethodExample', 10
FROM topic WHERE slug = 'abstract-class';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'AbstractList ile Gerçek Dünya Örneği', 'ReadOnlyListExample', 11
FROM topic WHERE slug = 'abstract-class';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Rapor Pipeline''ı', 'ReportPipeline', 12
FROM topic WHERE slug = 'abstract-class';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Rapor Pipeline''ı Kullanımı', 'ReportPipelineDemo', 13
FROM topic WHERE slug = 'abstract-class';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Ödeme İşleyici', 'PaymentProcessor', 14
FROM topic WHERE slug = 'abstract-class';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Ödeme İşleyici Kullanımı', 'PaymentProcessorDemo', 15
FROM topic WHERE slug = 'abstract-class';
