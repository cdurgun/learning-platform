-- built-in-functional-interfaces konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta
-- javac+java ile gerçekten derlenip çalıştırılarak doğrulandı (bkz. V182'deki not).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Predicate<T>', 'PredicateExample', 1
FROM topic WHERE slug = 'built-in-functional-interfaces';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Function<T,R>', 'FunctionExample', 2
FROM topic WHERE slug = 'built-in-functional-interfaces';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Consumer<T> ve Supplier<T>', 'ConsumerSupplierExample', 3
FROM topic WHERE slug = 'built-in-functional-interfaces';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'UnaryOperator<T> ve BinaryOperator<T>', 'UnaryBinaryOperatorExample', 4
FROM topic WHERE slug = 'built-in-functional-interfaces';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Method Reference Biçimleri', 'MethodReferenceExample', 5
FROM topic WHERE slug = 'built-in-functional-interfaces';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Constructor Reference', 'ConstructorReferenceExample', 6
FROM topic WHERE slug = 'built-in-functional-interfaces';
