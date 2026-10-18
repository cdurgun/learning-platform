-- Bu üç dersin sayfasında artık bir "Beklenen Çıktı" paneli var: gömdükleri dört örneğin
-- yanına, gerçek ve izole bir çalıştırmadan alınıp insan incelemesinden geçen .out dosyaları
-- eklendi (examples/{slug}/{Ad}.out, bkz. scripts/example-outputs/manifest.tsv):
--   primitive-parallel-streams     IntStreamCreationExample, BoxingMapToIntExample
--   built-in-functional-interfaces FunctionExample
--   collectors                     JoiningExample
-- Sayfada görünen örnek içeriği değiştiği ve örnek dosyaları iki dilin ortak kaynağı olduğu
-- için (bkz. CLAUDE.md, updated_at kuralı) her dersin hem TR hem EN çevirisi ilerler: toplam
-- altı satır. Ders metinleri (.md) ve .java dosyaları değişmedi; başka hiçbir ders etkilenmez.
--
-- Tarih açık bir değerdir, migration'ın uygulandığı gün değil. Slug + dil ile anahtarlanır,
-- ortama özgü id kullanılmaz. updated_at < hedef koşulu tarihi asla geri almaz ve tekrar
-- çalıştırıldığında hiçbir satırı değiştirmez.
UPDATE topic_translation tt
SET updated_at = DATE '2026-10-18'
FROM topic t
WHERE tt.topic_id = t.id
  AND t.slug IN ('primitive-parallel-streams', 'built-in-functional-interfaces', 'collectors')
  AND tt.language IN ('tr', 'en')
  AND tt.updated_at < DATE '2026-10-18';
