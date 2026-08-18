-- `file-reading` konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta javac+java ile
-- gerçekten derlenip çalıştırılarak doğrulandı (bkz. V225'teki not). Kod
-- yorumları ve println() çıktı metinleri İNGİLİZCE yazıldı (bkz. Faz 53 --
-- örnek dosyalar dile göre ayrılmadığı için tek kaynak her iki dilde de doğru
-- görünmeli).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Path ve Files Temelleri', 'PathAndFilesBasicsExample', 1
FROM topic WHERE slug = 'file-reading';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'BufferedReader ile Satır Satır Okuma', 'BufferedReaderExample', 2
FROM topic WHERE slug = 'file-reading';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Satır Sayma: readAllLines() vs Files.lines()', 'FileReadingStreamAndCountExample', 3
FROM topic WHERE slug = 'file-reading';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Dosyada Kelime Arama', 'SearchWordInFileExample', 4
FROM topic WHERE slug = 'file-reading';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Dosyanın Tamamını String Olarak Okumak', 'ReadFileAsStringExample', 5
FROM topic WHERE slug = 'file-reading';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İstisna Yönetimi: NoSuchFileException vs FileNotFoundException', 'FileReadingExceptionHandlingExample', 6
FROM topic WHERE slug = 'file-reading';
