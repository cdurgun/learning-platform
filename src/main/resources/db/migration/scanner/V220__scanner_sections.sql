-- `scanner` konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta javac+java ile
-- gerçekten derlenip çalıştırılarak doğrulandı (bkz. V219'daki not). Kod
-- yorumları ve println() çıktı metinleri İNGİLİZCE yazıldı (bkz. Faz 53 --
-- örnek dosyalar dile göre ayrılmadığı için tek kaynak her iki dilde de doğru
-- görünmeli).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Temel Kullanım: Token Okumak', 'ScannerBasicsExample', 1
FROM topic WHERE slug = 'scanner';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'nextInt() + nextLine() Klasik Tuzağı', 'ScannerNextIntNextLinePitfallExample', 2
FROM topic WHERE slug = 'scanner';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Özel Ayırıcılar', 'ScannerDelimiterExample', 3
FROM topic WHERE slug = 'scanner';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Dosyadan Okuma', 'ScannerFileExample', 4
FROM topic WHERE slug = 'scanner';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Scanner vs BufferedReader Performans', 'ScannerVsBufferedReaderPerformanceExample', 5
FROM topic WHERE slug = 'scanner';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İstisna Yönetimi', 'ScannerExceptionHandlingExample', 6
FROM topic WHERE slug = 'scanner';
