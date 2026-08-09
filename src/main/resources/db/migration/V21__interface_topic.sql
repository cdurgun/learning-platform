-- Faz 7: Enum, Record ve Reflection'dan sonraki dördüncü Java Basics konusu: Interface.
-- Soyut metotlardan Java 8 default/static, Java 9 private metotlara ve Java 17 sealed
-- interface'lere kadar uzandığı, ama Reflection kadar ileri seviye bir konu olmadığı
-- için Record'la aynı INTERMEDIATE zorluğunda işaretlendi. Şimdilik yalnızca iskelet
-- (topic + çeviriler) var — estimated_minutes buna göre düşük tutuldu, içerik
-- Reflection'da yaptığımız gibi kademeli olarak eklenecek.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'interface', 'INTERMEDIATE', 5, 4
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Interface',
       'Java''da davranış sözleşmeleri tanımlama; default/static/private metotlar ve sealed interface''ler.',
       'Java Interface Nedir? | Örneklerle Anlatım',
       'Java''da interface kullanımı; soyut metotlar, default/static/private metotlar, diamond problem, sealed interface ve gerçek dünya örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'interface';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Interface',
       'Defining behavior contracts in Java; default/static/private methods and sealed interfaces.',
       'What is a Java Interface? | With Examples',
       'Learn Java interfaces: abstract methods, default/static/private methods, the diamond problem, sealed interfaces, and real-world examples.',
       false
FROM topic
WHERE slug = 'interface';
