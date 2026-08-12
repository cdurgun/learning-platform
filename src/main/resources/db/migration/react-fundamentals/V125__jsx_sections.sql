-- JSX konusu, 5 örneğin tamamı. Dosyaların kendisi examples/jsx/ altında -- bu proje
-- için ilk .jsx (.java olmayan) örnekler, Faz 27'de genelleştirilen {{Ad.ext}} embed
-- sistemiyle gömülüyor. What Is React? ve Creating a React Application konularının
-- örnek dosyası yok (yalnızca inline kod snippet'leri kullanıyorlar).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'JSX Nedir? Basit Bir Örnek', 'JsxHelloWorldExample', 1
FROM topic WHERE slug = 'jsx';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Süslü Parantez { } ile JavaScript Gömme', 'JsxExpressionExample', 2
FROM topic WHERE slug = 'jsx';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Attribute''lar ve className', 'JsxAttributesExample', 3
FROM topic WHERE slug = 'jsx';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'JSX Kuralları: Tek Kök Element ve Fragment', 'JsxRulesExample', 4
FROM topic WHERE slug = 'jsx';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Conditional Rendering''e Kısa Bir Bakış', 'JsxConditionalIntroExample', 5
FROM topic WHERE slug = 'jsx';
