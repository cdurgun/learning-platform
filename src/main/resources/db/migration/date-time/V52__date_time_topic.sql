-- Faz 12: java-basics kategorisine dördüncü konu -- Date & Time API (java.time paketi).
-- OOP serisinden (Interface..Polymorphism) ve Concurrency'den (Threads) bağımsız, taze
-- bir alan olduğu için önceki konularla çakışma yok. LocalDate/LocalTime/LocalDateTime/
-- Instant/ZonedDateTime/OffsetDateTime, Duration/Period/ChronoUnit, DateTimeFormatter,
-- TemporalAdjusters, Legacy Date/Calendar/SimpleDateFormat'tan geçiş, saat dilimleri ve
-- DST, ve Spring Boot'ta (JSON/Jackson, Hibernate/PostgreSQL) gerçek dünya kullanımını
-- kapsıyor. Record/Interface/Abstract Class/Inheritance/Polymorphism'le aynı INTERMEDIATE
-- zorlukta -- Reflection/Threads kadar JVM-internals ağırlıklı değil ama saat dilimi
-- kavramları önemli bir derinlik katıyor. Şimdilik yalnızca iskelet (topic + çeviriler)
-- var -- estimated_minutes buna göre düşük tutuldu, içerik kademeli olarak eklenecek.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'date-time', 'INTERMEDIATE', 5, 4
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Date & Time API',
       'Java''da java.time paketi; LocalDate/LocalTime/LocalDateTime, Instant, ZonedDateTime/OffsetDateTime, Duration/Period/ChronoUnit, formatlama/parse, saat dilimleri ve legacy Date/Calendar''dan geçiş.',
       'Java Date & Time API (java.time) Nedir? | Örneklerle Anlatım',
       'Java''da java.time kullanımı; LocalDate, LocalTime, LocalDateTime, Instant, ZonedDateTime, OffsetDateTime, Duration, Period, ChronoUnit, DateTimeFormatter, TemporalAdjusters, saat dilimleri, yaz saati uygulaması (DST) ve legacy Date/Calendar/SimpleDateFormat''tan geçiş gerçek dünya örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'date-time';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Date & Time API',
       'The java.time package in Java; LocalDate/LocalTime/LocalDateTime, Instant, ZonedDateTime/OffsetDateTime, Duration/Period/ChronoUnit, formatting/parsing, time zones, and migrating from legacy Date/Calendar.',
       'What Is the Java Date & Time API (java.time)? | With Examples',
       'Learn the Java date/time API: LocalDate, LocalTime, LocalDateTime, Instant, ZonedDateTime, OffsetDateTime, Duration, Period, ChronoUnit, DateTimeFormatter, TemporalAdjusters, time zones, Daylight Saving Time (DST), and migrating from legacy Date/Calendar/SimpleDateFormat with real-world examples.',
       false
FROM topic
WHERE slug = 'date-time';
