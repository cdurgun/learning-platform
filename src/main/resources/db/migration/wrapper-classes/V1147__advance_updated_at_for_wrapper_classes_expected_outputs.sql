-- java-basics kategorisinin dördüncü dersi wrapper-classes'ın sayfasında artık "Beklenen Çıktı" panelleri var:
-- gömdüğü altı örneğin üçüne, gerçek ve izole bir çalıştırmadan alınıp insan incelemesinden
-- geçen .out dosyaları eklendi (examples/wrapper-classes/{Ad}.out, bkz. scripts/example-outputs/manifest.tsv):
--   WrapperBasicsExample, WrapperUtilityMethodsExample, WrapperInCollectionsExample
-- IntegerCachingExample reddedildi: -128..127 dışındaki değerlerde == sonucunu JLS garanti etmez
-- (AutoBoxCacheMax ile değişebilir). AutoboxingNullPointerExample HashMap kullandığı,
-- AutoboxingPerformanceExample süre ölçtüğü için engelli; üçü de panelsiz.
-- Sayfada görünen örnek içeriği değiştiği ve örnek dosyaları iki dilin ortak kaynağı olduğu
-- için (bkz. CLAUDE.md, updated_at kuralı) dersin hem TR hem EN çevirisi ilerler: toplam iki
-- satır. Ders metinleri (.md) ve .java dosyaları değişmedi; başka hiçbir ders etkilenmez.
--
-- Tarih açık bir değerdir, migration'ın uygulandığı gün değil. Slug + dil ile anahtarlanır,
-- ortama özgü id kullanılmaz. updated_at < hedef koşulu tarihi asla geri almaz ve tekrar
-- çalıştırıldığında hiçbir satırı değiştirmez.
UPDATE topic_translation tt
SET updated_at = DATE '2026-10-22'
FROM topic t
WHERE tt.topic_id = t.id
  AND t.slug = 'wrapper-classes'
  AND tt.language IN ('tr', 'en')
  AND tt.updated_at < DATE '2026-10-22';
