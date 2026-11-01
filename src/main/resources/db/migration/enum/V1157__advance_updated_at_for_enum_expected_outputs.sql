-- enum dersinin sayfasında artık "Beklenen Çıktı" panelleri var: gömdüğü on bir örneğin ikisine,
-- gerçek ve izole bir çalıştırmadan alınıp insan incelemesinden geçen .out dosyaları eklendi
-- (examples/enum/{Ad}.out, bkz. scripts/example-outputs/manifest.tsv):
--   EnumSetExample, EnumMapExample
-- İkisi de DayWithMethod.java ile birlikte derlendi; manifest'in companions sütunu bu dosyanın
-- hash'ini tutar. PlanetUsageExample %.2f çıktısı locale-tr varyantında farklı olduğu için
-- panelsiz; kalan sekiz dosyanın main'i yok.
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
  AND t.slug = 'enum'
  AND tt.language IN ('tr', 'en')
  AND tt.updated_at < DATE '2026-11-01';
