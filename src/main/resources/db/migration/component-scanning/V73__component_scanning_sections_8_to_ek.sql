-- Component Scanning & Configuration konusu, kalan örnekler: @Primary, @Qualifier ve
-- @Primary bir arada, Component Scanning vs Java Config, ve iki mini proje eki (Çok
-- Kanallı Bildirim Ağ Geçidi, Kitap Kataloğu). Dosyaların kendisi
-- examples/component-scanning/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Primary: Varsayılan Aday Belirlemek', 'PrimaryExample', 8
FROM topic WHERE slug = 'component-scanning';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Qualifier ve @Primary Bir Arada', 'QualifierPrimaryTogetherExample', 9
FROM topic WHERE slug = 'component-scanning';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Component Scanning ve Java Config''i Karıştırmak', 'MixedConfigExample', 10
FROM topic WHERE slug = 'component-scanning';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Çok Kanallı Bildirim Ağ Geçidi (Base)', 'NotificationGateway', 11
FROM topic WHERE slug = 'component-scanning';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Çok Kanallı Bildirim Ağ Geçidi (Demo)', 'NotificationGatewayDemo', 12
FROM topic WHERE slug = 'component-scanning';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Kitap Kataloğu (Base)', 'BookCatalogApp', 13
FROM topic WHERE slug = 'component-scanning';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Kitap Kataloğu (Demo)', 'BookCatalogAppDemo', 14
FROM topic WHERE slug = 'component-scanning';
