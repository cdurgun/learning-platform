-- GenericCollectionApisExample.java çalışırken çöküyordu: Set.of tekrar eden elemanı
-- düşürmez, IllegalArgumentException ("duplicate element: Alice") fırlatır. Satır
-- Set.copyOf(List.of(...)) ile değiştirildi; tekrar eden eleman artık gerçekten düşüyor ve
-- program sonuna kadar çalışıyor. Sayfada görünen örnek kod değiştiği ve örnek dosyaları iki
-- dilin ortak kaynağı olduğu için (bkz. CLAUDE.md, updated_at kuralı) dersin hem TR hem EN
-- çevirisi ilerler: toplam iki satır. Ders metinleri (.md) değişmedi; başka hiçbir ders
-- etkilenmez.
--
-- Tarih açık bir değerdir, migration'ın uygulandığı gün değil. Slug + dil ile anahtarlanır,
-- ortama özgü id kullanılmaz. updated_at < hedef koşulu tarihi asla geri almaz ve tekrar
-- çalıştırıldığında hiçbir satırı değiştirmez.
UPDATE topic_translation tt
SET updated_at = DATE '2026-10-25'
FROM topic t
WHERE tt.topic_id = t.id
  AND t.slug = 'generics-with-collections'
  AND tt.language IN ('tr', 'en')
  AND tt.updated_at < DATE '2026-10-25';
