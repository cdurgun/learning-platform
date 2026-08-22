-- `if-else` konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta javac+java ile gerçekten
-- derlenip çalıştırılarak doğrulandı (kısa devre değerlendirme demosu dahil -- yalnızca
-- beklenen metotların gerçekten çağrıldığı, kısa devre olanların ÇAĞRILMADIĞI gerçek
-- çıktıyla teyit edildi). Kod yorumları İNGİLİZCE yazıldı (bkz. Faz 53 -- örnek dosyalar
-- dile göre ayrılmadığı için tek kaynak her iki dilde de doğru görünmeli).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Temel if / else Kullanımı', 'IfElseBasicsExample', 1
FROM topic WHERE slug = 'if-else';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'else if Zinciri', 'ElseIfChainExample', 2
FROM topic WHERE slug = 'if-else';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İç İçe Koşullar (Nested Conditions)', 'NestedConditionsExample', 3
FROM topic WHERE slug = 'if-else';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Karşılaştırma Operatörleri', 'ComparisonOperatorsExample', 4
FROM topic WHERE slug = 'if-else';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mantıksal Operatörler ve Kısa Devre Değerlendirme', 'LogicalOperatorsExample', 5
FROM topic WHERE slug = 'if-else';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Üçlü (Ternary) Operatör', 'TernaryOperatorExample', 6
FROM topic WHERE slug = 'if-else';
