-- lambda-expressions konusu, 4 örneğin tamamı -- hepsi bu sandbox'ta javac+java ile
-- gerçekten derlenip çalıştırılarak doğrulandı (bkz. V179'daki not).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Parametre ve Gövde Biçimleri', 'LambdaSyntaxAndReturnExample', 1
FROM topic WHERE slug = 'lambda-expressions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Target Typing', 'TargetTypingExample', 2
FROM topic WHERE slug = 'lambda-expressions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Effectively Final Değişken Yakalama', 'EffectivelyFinalExample', 3
FROM topic WHERE slug = 'lambda-expressions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Anonymous Inner Class''a Karşı Lambda', 'AnonymousClassVsLambdaExample', 4
FROM topic WHERE slug = 'lambda-expressions';
