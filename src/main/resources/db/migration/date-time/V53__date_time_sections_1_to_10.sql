-- Date & Time konusu, 1-10. bölümler (LocalDate, LocalTime, LocalDateTime, Instant,
-- ZonedDateTime ve Time Zone Kavramı, OffsetDateTime, Duration ve Period, ChronoUnit ile
-- Zaman Farkı Hesaplama, DateTimeFormatter: Formatlama ve Parse Etme, Tarih
-- Hesaplamaları) için örnek metadata'sı. Dosyaların kendisi examples/date-time/ altında;
-- bağlantı, önceki konularda olduğu gibi slug + example_name convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'LocalDate', 'LocalDateExample', 1
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'LocalTime', 'LocalTimeExample', 2
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'LocalDateTime', 'LocalDateTimeExample', 3
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Instant', 'InstantExample', 4
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'ZonedDateTime ve Saat Dilimi Dönüşümleri', 'ZonedDateTimeExample', 5
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'OffsetDateTime', 'OffsetDateTimeExample', 6
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Duration ve Period', 'DurationAndPeriodExample', 7
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'ChronoUnit ile Zaman Farkı Hesaplama', 'ChronoUnitExample', 8
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'DateTimeFormatter: Formatlama ve Parse Etme', 'FormattingAndParsingExample', 9
FROM topic WHERE slug = 'date-time';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Tarih Hesaplamaları', 'DateCalculationsExample', 10
FROM topic WHERE slug = 'date-time';
