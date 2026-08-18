-- `string` konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta javac+java ile
-- gerçekten derlenip çalıştırılarak doğrulandı (bkz. V213'teki not). Kod
-- yorumları ve println() çıktı metinleri İNGİLİZCE yazıldı (bkz. Faz 53 --
-- örnek dosyalar dile göre ayrılmadığı için tek kaynak her iki dilde de doğru
-- görünmeli).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Temel Kullanım ve Immutability', 'StringBasicsExample', 1
FROM topic WHERE slug = 'string';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'String Pool ve == vs equals()', 'StringPoolAndEqualityExample', 2
FROM topic WHERE slug = 'string';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Birleştirme Performansı: + vs StringBuilder', 'StringConcatenationPerformanceExample', 3
FROM topic WHERE slug = 'string';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'StringBuilder', 'StringBuilderExample', 4
FROM topic WHERE slug = 'string';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Biçimlendirme: format() ve Text Block''lar', 'StringFormattingExample', 5
FROM topic WHERE slug = 'string';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Arama, Bölme ve Yardımcı Metotlar', 'StringSearchSplitExample', 6
FROM topic WHERE slug = 'string';
