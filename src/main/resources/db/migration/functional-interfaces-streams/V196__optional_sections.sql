-- optional konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta javac+java ile gerçekten
-- derlenip çalıştırılarak doğrulandı (bkz. V195'teki not, özellikle OrElseExample.java'
-- daki eager/lazy gözlemi).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Optional Oluşturmak', 'OptionalCreationExample', 1
FROM topic WHERE slug = 'optional';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'orElse() ve orElseGet()', 'OrElseExample', 2
FROM topic WHERE slug = 'optional';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'orElseThrow()', 'OrElseThrowExample', 3
FROM topic WHERE slug = 'optional';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'map() ve flatMap()', 'OptionalMapFlatMapExample', 4
FROM topic WHERE slug = 'optional';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'ifPresent() ve ifPresentOrElse()', 'IfPresentExample', 5
FROM topic WHERE slug = 'optional';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'filter()', 'OptionalFilterExample', 6
FROM topic WHERE slug = 'optional';
