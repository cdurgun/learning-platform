-- `file-writing` konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta javac+java ile
-- gerçekten derlenip çalıştırılarak doğrulandı (bkz. V228'deki not). Kod
-- yorumları ve println() çıktı metinleri İNGİLİZCE yazıldı (bkz. Faz 53 --
-- örnek dosyalar dile göre ayrılmadığı için tek kaynak her iki dilde de doğru
-- görünmeli).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Files.writeString(): Oluşturma ve Üzerine Yazma', 'WriteStringExample', 1
FROM topic WHERE slug = 'file-writing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Dosyaya Ekleme (Append)', 'AppendToFileExample', 2
FROM topic WHERE slug = 'file-writing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bir Listeyi Satır Satır Yazmak', 'WriteLinesExample', 3
FROM topic WHERE slug = 'file-writing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'BufferedWriter ile Yazma', 'BufferedWriterExample', 4
FROM topic WHERE slug = 'file-writing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Dosya Kopyalama ve Dizin Yönetimi', 'CopyAndDirectoryExample', 5
FROM topic WHERE slug = 'file-writing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'CSV Dosyası Yazmak', 'WriteCsvExample', 6
FROM topic WHERE slug = 'file-writing';
