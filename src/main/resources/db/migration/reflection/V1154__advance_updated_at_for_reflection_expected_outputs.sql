-- reflection dersinin sayfası iki şekilde değişti. Birincisi, "Beklenen Çıktı" panelleri eklendi:
-- gömdüğü on beş örneğin yedisine, gerçek ve izole bir çalıştırmadan alınıp insan incelemesinden
-- geçen .out dosyaları geldi (examples/reflection/{Ad}.out, bkz. scripts/example-outputs/manifest.tsv):
--   ThreeWaysToGetClass, ClassInfoExample, DynamicObjectCreation, DynamicMethodInvocation,
--   PrivateAccessExample, AnnotationExample, MethodHandleExample
-- İkincisi, MethodHandleExample.java düzeltildi: package-private greet() metodunu Class.getMethod
-- bulamadığı için örnek NoSuchMethodException ile çöküyordu; metot public yapıldı.
-- FieldsExample, MethodsExample, ConstructorsExample ve MiniTestRunner reflection-order nedeniyle
-- engelli; SimpleContainer ve ObjectInspector'da main yok; iki Demo dosyası başka dosyalara bağlı.
-- Sayfada görünen örnek içeriği değiştiği ve örnek dosyaları iki dilin ortak kaynağı olduğu
-- için (bkz. CLAUDE.md, updated_at kuralı) dersin hem TR hem EN çevirisi ilerler: toplam iki
-- satır. Ders metinleri (.md) değişmedi; başka hiçbir ders etkilenmez.
--
-- Tarih açık bir değerdir, migration'ın uygulandığı gün değil. Slug + dil ile anahtarlanır,
-- ortama özgü id kullanılmaz. updated_at < hedef koşulu tarihi asla geri almaz ve tekrar
-- çalıştırıldığında hiçbir satırı değiştirmez.
UPDATE topic_translation tt
SET updated_at = DATE '2026-11-01'
FROM topic t
WHERE tt.topic_id = t.id
  AND t.slug = 'reflection'
  AND tt.language IN ('tr', 'en')
  AND tt.updated_at < DATE '2026-11-01';
