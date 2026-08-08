-- Faz 2: "Constructor" ve "Alanlar" bölümleri için yeni örnek metadata'sı.
-- Dosyaların kendisi examples/enum/PlanetEnum.java ve examples/enum/PlanetUsageExample.java
-- altında; bağlantı, diğer tüm örneklerde olduğu gibi slug + example_name convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Constructor ve Alanlar (Planet)', 'PlanetEnum', 2
FROM topic
WHERE slug = 'enum';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Planet Kullanımı', 'PlanetUsageExample', 3
FROM topic
WHERE slug = 'enum';
