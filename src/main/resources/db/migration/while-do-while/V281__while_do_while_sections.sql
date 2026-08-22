INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Temel while Sözdizimi', 'WhileBasicsExample', 1
FROM topic WHERE slug = 'while-do-while';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'do-while: En Az Bir Kez Çalışan Döngü', 'DoWhileBasicsExample', 2
FROM topic WHERE slug = 'while-do-while';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'while vs do-while: Ne Zaman Hangisi', 'WhileVsDoWhileExample', 3
FROM topic WHERE slug = 'while-do-while';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'break ve continue ile while', 'BreakContinueInWhileExample', 4
FROM topic WHERE slug = 'while-do-while';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Kullanıcı Girdisiyle Doğrulama Döngüsü (Scanner ile)', 'InputValidationLoopExample', 5
FROM topic WHERE slug = 'while-do-while';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Uygulamalı Örnek: Sayı Tahmin Oyunu (Number Guessing Game)', 'NumberGuessingGameExample', 6
FROM topic WHERE slug = 'while-do-while';
