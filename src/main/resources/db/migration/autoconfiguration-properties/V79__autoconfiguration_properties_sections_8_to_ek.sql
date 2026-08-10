-- Spring Boot Auto-Configuration & Properties konusu, kalan örnekler: @Profile,
-- property kaynak önceliği, ApplicationEvent/@EventListener, ve iki mini proje eki
-- (Feature Toggle Sistemi, Bildirim Ayarları Yöneticisi). Dosyaların kendisi
-- examples/autoconfiguration-properties/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Profiles: @Profile ile Ortama Özel Bean''ler', 'ProfileExample', 8
FROM topic WHERE slug = 'autoconfiguration-properties';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'External Configuration: Property Kaynaklarının Öncelik Sırası', 'PropertySourceOrderExample', 9
FROM topic WHERE slug = 'autoconfiguration-properties';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'ApplicationEvent ve @EventListener', 'ApplicationEventExample', 10
FROM topic WHERE slug = 'autoconfiguration-properties';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Feature Toggle Sistemi (Base)', 'FeatureToggleConfig', 11
FROM topic WHERE slug = 'autoconfiguration-properties';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Feature Toggle Sistemi (Demo)', 'FeatureToggleDemo', 12
FROM topic WHERE slug = 'autoconfiguration-properties';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Bildirim Ayarları Yöneticisi (Base)', 'NotificationSettingsApp', 13
FROM topic WHERE slug = 'autoconfiguration-properties';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Bildirim Ayarları Yöneticisi (Demo)', 'NotificationSettingsDemo', 14
FROM topic WHERE slug = 'autoconfiguration-properties';
