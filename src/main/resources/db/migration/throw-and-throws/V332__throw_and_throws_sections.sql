-- `throw-and-throws` konusu, 4 örneğin tamamı. Kod yorumları ve açıklama
-- metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'throw İfadesinin Temelleri', 'ThrowStatementBasicsExample', 1
FROM topic WHERE slug = 'throw-and-throws';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Fail-Fast Doğrulama', 'FailFastValidationExample', 2
FROM topic WHERE slug = 'throw-and-throws';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Yakalanan Exception''ı Yeniden Fırlatmak', 'RethrowingCaughtExceptionExample', 3
FROM topic WHERE slug = 'throw-and-throws';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'throws Bildirimi ve Yayılma', 'ThrowsDeclarationPropagationExample', 4
FROM topic WHERE slug = 'throw-and-throws';
