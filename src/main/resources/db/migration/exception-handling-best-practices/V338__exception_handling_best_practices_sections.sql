-- `exception-handling-best-practices` konusu, 4 örneğin tamamı. Kod
-- yorumları ve açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Anti-Pattern: Kontrol Akışı Olarak Exception', 'ExceptionsForControlFlowAntiPatternExample', 1
FROM topic WHERE slug = 'exception-handling-best-practices';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Anti-Pattern: Exception''ları Yutmak', 'SwallowingExceptionsAntiPatternExample', 2
FROM topic WHERE slug = 'exception-handling-best-practices';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Spesifik Yakalama ve Sıralama', 'CatchOrderAndSpecificityExample', 3
FROM topic WHERE slug = 'exception-handling-best-practices';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Yalnızca Ele Alabildiğini Yakalamak', 'OnlyCatchWhatYouCanHandleExample', 4
FROM topic WHERE slug = 'exception-handling-best-practices';
