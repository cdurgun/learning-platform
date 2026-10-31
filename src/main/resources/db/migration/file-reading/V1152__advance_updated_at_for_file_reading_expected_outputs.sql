-- file-reading dersinin sayfasında artık "Beklenen Çıktı" panelleri var: gömdüğü altı örneğin
-- dördüne, gerçek ve izole bir çalıştırmadan alınıp insan incelemesinden geçen .out dosyaları
-- eklendi (examples/file-reading/{Ad}.out, bkz. scripts/example-outputs/manifest.tsv):
--   BufferedReaderExample, FileReadingStreamAndCountExample, SearchWordInFileExample,
--   ReadFileAsStringExample
-- PathAndFilesBasicsExample toAbsolutePath() yazdırdığı, FileReadingExceptionHandlingExample
-- ise Javadoc'ta "optional specific exception" olan NoSuchFileException'a dayandığı için engelli;
-- ikisi de panelsiz.
-- Sayfada görünen örnek içeriği değiştiği ve örnek dosyaları iki dilin ortak kaynağı olduğu
-- için (bkz. CLAUDE.md, updated_at kuralı) dersin hem TR hem EN çevirisi ilerler: toplam iki
-- satır. Ders metinleri (.md) ve .java dosyaları değişmedi; başka hiçbir ders etkilenmez.
--
-- Tarih açık bir değerdir, migration'ın uygulandığı gün değil. Slug + dil ile anahtarlanır,
-- ortama özgü id kullanılmaz. updated_at < hedef koşulu tarihi asla geri almaz ve tekrar
-- çalıştırıldığında hiçbir satırı değiştirmez.
UPDATE topic_translation tt
SET updated_at = DATE '2026-10-31'
FROM topic t
WHERE tt.topic_id = t.id
  AND t.slug = 'file-reading'
  AND tt.language IN ('tr', 'en')
  AND tt.updated_at < DATE '2026-10-31';
