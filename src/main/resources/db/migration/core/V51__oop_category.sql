-- Interface, Abstract Class, Inheritance ve Polymorphism, şimdiye kadar "Java Basics"
-- kategorisindeydi (Enum/Record/Reflection'la birlikte). Bu dört konu birlikte OOP'nin
-- kalıtım/polimorfizm eksenini oluşturduğu için, Concurrency'nin açıldığı desenle aynı
-- şekilde kendi kategorilerine taşınıyor: "Object-Oriented Programming" (slug: oop).
--
-- Category çeviri desteklemediği için (TopicTranslation var, CategoryTranslation yok)
-- isim İngilizce seçildi -- "Java Basics" ve "Concurrency" ile aynı konvansiyon.
--
-- Kategori sırası: java-basics(1) -> oop(2) -> concurrency(3, eskiden 2'ydi).
-- Taşınan topic'lerin sort_order'ı, yeni kategori içinde 1'den başlayacak şekilde
-- yeniden numaralandırıldı (topic.sort_order kategoriye özeldir, bkz. CLAUDE.md).

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Object-Oriented Programming', 'oop', 2
FROM course
WHERE slug = 'java';

UPDATE category
SET sort_order = 3
WHERE slug = 'concurrency';

UPDATE topic
SET category_id = (SELECT id FROM category WHERE slug = 'oop'),
    sort_order = 1
WHERE slug = 'interface';

UPDATE topic
SET category_id = (SELECT id FROM category WHERE slug = 'oop'),
    sort_order = 2
WHERE slug = 'abstract-class';

UPDATE topic
SET category_id = (SELECT id FROM category WHERE slug = 'oop'),
    sort_order = 3
WHERE slug = 'inheritance';

UPDATE topic
SET category_id = (SELECT id FROM category WHERE slug = 'oop'),
    sort_order = 4
WHERE slug = 'polymorphism';
