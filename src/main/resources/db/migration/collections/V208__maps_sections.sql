-- `maps` konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta javac+java ile gerçekten
-- derlenip çalıştırılarak doğrulandı (bkz. V207'deki not). Kod yorumları ve
-- println() çıktı metinleri İNGİLİZCE yazıldı (bkz. Faz 53 -- örnek dosyalar dile
-- göre ayrılmadığı için tek kaynak her iki dilde de doğru görünmeli).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Temel Map İşlemleri', 'MapBasicsExample', 1
FROM topic WHERE slug = 'maps';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'LinkedHashMap: Eklenme Sırasını Korumak', 'LinkedHashMapExample', 2
FROM topic WHERE slug = 'maps';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'TreeMap ve NavigableMap', 'TreeMapExample', 3
FROM topic WHERE slug = 'maps';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Immutable Map''ler', 'ImmutableMapExample', 4
FROM topic WHERE slug = 'maps';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Modern Map API', 'ModernMapMethodsExample', 5
FROM topic WHERE slug = 'maps';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'entrySet() vs keySet() + get() Performans', 'MapIterationPerformanceExample', 6
FROM topic WHERE slug = 'maps';
