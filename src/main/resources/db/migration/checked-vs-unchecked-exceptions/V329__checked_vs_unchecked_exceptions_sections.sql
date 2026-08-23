-- `checked-vs-unchecked-exceptions` konusu, 4 örneğin tamamı. Kod yorumları ve
-- açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Checked Exception: Zorunlu throws/catch', 'CheckedExceptionHandlingExample', 1
FROM topic WHERE slug = 'checked-vs-unchecked-exceptions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Unchecked Exception: Zorunlu Bildirim Yok', 'UncheckedExceptionExample', 2
FROM topic WHERE slug = 'checked-vs-unchecked-exceptions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Checked Exception''ı Unchecked''e Sarmalamak', 'WrappingCheckedAsUncheckedExample', 3
FROM topic WHERE slug = 'checked-vs-unchecked-exceptions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Override Edilen Metotlarda throws Kısıtı', 'OverridingThrowsRestrictionExample', 4
FROM topic WHERE slug = 'checked-vs-unchecked-exceptions';
