-- control-flow kategorisinin altı dersinin sayfasında artık "Beklenen Çıktı" panelleri var:
-- gömdükleri örneklerin 33'üne, gerçek ve izole bir çalıştırmadan alınıp insan incelemesinden
-- geçen .out dosyaları eklendi (examples/{slug}/{Ad}.out, bkz. scripts/example-outputs/manifest.tsv):
--   if-else            6 örnek
--   switch             6 örnek
--   for-loop           6 örnek
--   enhanced-for-loop  5 örnek (ModifyingDuringIterationExample incelemede reddedildi)
--   while-do-while     4 örnek (stdin okuyan iki örnek engelli, panelsiz)
--   nested-loops       6 örnek
-- Sayfada görünen örnek içeriği değiştiği ve örnek dosyaları iki dilin ortak kaynağı olduğu
-- için (bkz. CLAUDE.md, updated_at kuralı) her dersin hem TR hem EN çevirisi ilerler: toplam
-- on iki satır. Ders metinleri (.md) ve .java dosyaları değişmedi; başka hiçbir ders etkilenmez.
--
-- Tarih açık bir değerdir, migration'ın uygulandığı gün değil. Slug + dil ile anahtarlanır,
-- ortama özgü id kullanılmaz. updated_at < hedef koşulu tarihi asla geri almaz ve tekrar
-- çalıştırıldığında hiçbir satırı değiştirmez.
UPDATE topic_translation tt
SET updated_at = DATE '2026-10-19'
FROM topic t
WHERE tt.topic_id = t.id
  AND t.slug IN ('if-else', 'switch', 'for-loop', 'enhanced-for-loop', 'while-do-while', 'nested-loops')
  AND tt.language IN ('tr', 'en')
  AND tt.updated_at < DATE '2026-10-19';
