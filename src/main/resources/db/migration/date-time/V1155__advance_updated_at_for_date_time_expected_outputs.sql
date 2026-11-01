-- date-time dersinin sayfasında artık "Beklenen Çıktı" panelleri var: gömdüğü on dokuz örneğin
-- onuna, gerçek ve izole bir çalıştırmadan alınıp insan incelemesinden geçen .out dosyaları
-- eklendi (examples/date-time/{Ad}.out, bkz. scripts/example-outputs/manifest.tsv):
--   LocalDateTimeExample, ZonedDateTimeExample, OffsetDateTimeExample, DurationAndPeriodExample,
--   ChronoUnitExample, DateCalculationsExample, TemporalAdjustersExample, LegacyInteropExample,
--   TimeZoneAndDstExample, EventExample
-- ZonedDateTimeExample, LegacyInteropExample ve TimeZoneAndDstExample bölge kurallarına (tzdata)
-- bağlıdır; tarihleri geçmişte olduğu için kabul edildi. FormattingAndParsingExample getMessage()
-- metni bastığı, ComparingDatesExample ise yalnızca işareti sözleşmede olan compareTo değerini
-- (-3) bastığı için reddedildi. LocalDateExample, LocalTimeExample ve InstantExample now()
-- kullandığı için engelli; kalan dört dosyanın main'i yok ya da başka dosyalara bağlı.
-- Sayfada görünen örnek içeriği değiştiği ve örnek dosyaları iki dilin ortak kaynağı olduğu
-- için (bkz. CLAUDE.md, updated_at kuralı) dersin hem TR hem EN çevirisi ilerler: toplam iki
-- satır. Ders metinleri (.md) ve .java dosyaları değişmedi; başka hiçbir ders etkilenmez.
--
-- Tarih açık bir değerdir, migration'ın uygulandığı gün değil. Slug + dil ile anahtarlanır,
-- ortama özgü id kullanılmaz. updated_at < hedef koşulu tarihi asla geri almaz ve tekrar
-- çalıştırıldığında hiçbir satırı değiştirmez.
UPDATE topic_translation tt
SET updated_at = DATE '2026-11-01'
FROM topic t
WHERE tt.topic_id = t.id
  AND t.slug = 'date-time'
  AND tt.language IN ('tr', 'en')
  AND tt.updated_at < DATE '2026-11-01';
