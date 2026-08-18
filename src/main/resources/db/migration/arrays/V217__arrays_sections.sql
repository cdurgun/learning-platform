-- `arrays` konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta javac+java ile
-- gerçekten derlenip çalıştırılarak doğrulandı (bkz. V216'daki not). Kod
-- yorumları ve println() çıktı metinleri İNGİLİZCE yazıldı (bkz. Faz 53 --
-- örnek dosyalar dile göre ayrılmadığı için tek kaynak her iki dilde de doğru
-- görünmeli).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Temel Kullanım: Oluşturma, Erişim, Varsayılan Değerler', 'ArrayBasicsExample', 1
FROM topic WHERE slug = 'arrays';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Çok Boyutlu Diziler', 'MultiDimensionalArrayExample', 2
FROM topic WHERE slug = 'arrays';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Arrays Yardımcı Sınıfı', 'ArraysUtilityExample', 3
FROM topic WHERE slug = 'arrays';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Array Covariance', 'ArrayCovarianceExample', 4
FROM topic WHERE slug = 'arrays';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Arrays vs Collections', 'ArraysVsCollectionsExample', 5
FROM topic WHERE slug = 'arrays';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Varargs', 'VarargsExample', 6
FROM topic WHERE slug = 'arrays';
