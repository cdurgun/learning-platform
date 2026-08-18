-- `wrapper-classes` konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta javac+java
-- ile gerçekten derlenip çalıştırılarak doğrulandı (bkz. V222'deki not). Kod
-- yorumları ve println() çıktı metinleri İNGİLİZCE yazıldı (bkz. Faz 53 --
-- örnek dosyalar dile göre ayrılmadığı için tek kaynak her iki dilde de doğru
-- görünmeli).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Temel Kullanım: Autoboxing ve Autounboxing', 'WrapperBasicsExample', 1
FROM topic WHERE slug = 'wrapper-classes';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Integer Önbellekleme: == Tuzağı', 'IntegerCachingExample', 2
FROM topic WHERE slug = 'wrapper-classes';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Autoboxing''in Gizli Tehlikesi: null Unboxing', 'AutoboxingNullPointerExample', 3
FROM topic WHERE slug = 'wrapper-classes';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Autoboxing''in Performans Maliyeti', 'AutoboxingPerformanceExample', 4
FROM topic WHERE slug = 'wrapper-classes';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Wrapper Sınıflarının Yardımcı Metotları', 'WrapperUtilityMethodsExample', 5
FROM topic WHERE slug = 'wrapper-classes';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Wrapper Sınıfları ve Koleksiyonlar', 'WrapperInCollectionsExample', 6
FROM topic WHERE slug = 'wrapper-classes';
