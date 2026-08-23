-- `introduction-to-exceptions` konusu, 4 örneğin tamamı. Kod yorumları ve
-- açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53 -- örnek dosyalar dile göre
-- ayrılmadığı için tek kaynak her iki dilde de doğru görünmeli).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bir Exception''ın Anatomisi', 'ExceptionAnatomyExample', 1
FROM topic WHERE slug = 'introduction-to-exceptions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Yakalanmamış Bir Exception', 'UncaughtExceptionExample', 2
FROM topic WHERE slug = 'introduction-to-exceptions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Çağrı Zincirinde Yayılma (Propagation)', 'PropagationThroughCallChainExample', 3
FROM topic WHERE slug = 'introduction-to-exceptions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Yaygın Exception Tetikleyicileri', 'CommonExceptionTriggersExample', 4
FROM topic WHERE slug = 'introduction-to-exceptions';
