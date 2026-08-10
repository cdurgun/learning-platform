-- Date & Time konusu, 11-15. bölümler (TemporalAdjusters, Tarihleri Karşılaştırma,
-- Legacy API'den java.time'a Geçiş, Time Zone'lar ve Daylight Saving Time, Gerçek Dünya
-- Örnekleri: Spring Boot'ta java.time) ile iki mini proje ekinin (Çoklu Saat Dilimli
-- Toplantı Planlayıcı, Etkinlik Süre Takibi) örnek metadata'sı. Dosyaların kendisi
-- examples/date-time/ altında; bağlantı, önceki konularda olduğu gibi slug +
-- example_name convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'TemporalAdjusters', 'TemporalAdjustersExample', 11
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Tarihleri Karşılaştırma', 'ComparingDatesExample', 12
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Legacy API''den java.time''a Geçiş', 'LegacyInteropExample', 13
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Time Zone''lar ve Daylight Saving Time', 'TimeZoneAndDstExample', 14
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Gerçek Dünya Örneği: Spring Boot''ta java.time', 'EventExample', 15
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Çoklu Saat Dilimli Toplantı Planlayıcı', 'MeetingScheduler', 16
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Toplantı Planlayıcı Kullanımı', 'MeetingSchedulerDemo', 17
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Etkinlik Süre Takibi', 'EventDurationTracker', 18
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Etkinlik Süre Takibi Kullanımı', 'EventDurationTrackerDemo', 19
FROM topic WHERE slug = 'date-time';
