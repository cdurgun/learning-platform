-- `exception-handling` (advanced-spring) konusu, 7 örneğin tamamı. Kod
-- yorumları ve açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'MethodArgumentNotValidException''ın İçeriği', 'MethodArgumentNotValidExceptionExample', 1
FROM topic WHERE slug = 'exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Validasyon Hatalarını ProblemDetail''e Dönüştürmek', 'ValidationProblemDetailExample', 2
FROM topic WHERE slug = 'exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Custom ProblemDetail Özellikleri', 'CustomProblemDetailPropertiesExample', 3
FROM topic WHERE slug = 'exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Domain Exception''ları Durum Koduna Eşlemek', 'DomainExceptionStatusMappingExample', 4
FROM topic WHERE slug = 'exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'ResponseEntityExceptionHandler ile Merkezileştirme', 'ResponseEntityExceptionHandlerExample', 5
FROM topic WHERE slug = 'exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Güvenli Hata Yanıtları', 'SafeErrorResponseExample', 6
FROM topic WHERE slug = 'exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Pratik, Uçtan Uca Bir Örnek', 'PracticalCentralizedErrorHandlingExample', 7
FROM topic WHERE slug = 'exception-handling';
