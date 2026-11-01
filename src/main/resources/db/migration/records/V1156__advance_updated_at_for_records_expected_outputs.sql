-- records dersinin sayfasında artık "Beklenen Çıktı" panelleri var: gömdüğü yirmi bir örneğin
-- üçüne, gerçek ve izole bir çalıştırmadan alınıp insan incelemesinden geçen .out dosyaları
-- eklendi (examples/records/{Ad}.out, bkz. scripts/example-outputs/manifest.tsv):
--   EqualsSemanticsExample, ReflectionExample, NestedPatternExample
-- TeamMutableTrap reddedildi: dolaylı Record.toString biçimi Javadoc'a göre "subject to change".
-- TeamDefensiveCopy, NestedRecordExample ve SerializableRecordExample de aynı çıktıyı bastığı için
-- panelsiz (main sınıfları dosya adından farklı olduğundan araç onları çalıştıramadı).
-- SealedShapeExample locale-tr varyantında %.2f farkı verdiği için panelsiz; kalan on üç dosyanın
-- main'i yok ya da başka dosyaya bağlı.
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
  AND t.slug = 'records'
  AND tt.language IN ('tr', 'en')
  AND tt.updated_at < DATE '2026-11-01';
