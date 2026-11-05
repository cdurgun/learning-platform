-- terminal-operations dersinin forEach() örneği (ForEachExample.java), forEach()'in sıralı bir
-- stream'de karşılaşma sırasını "tıpkı düz bir for döngüsü gibi" koruduğunu söylüyordu; Stream.forEach
-- Javadoc'a göre sıralı stream'de bile sıra garantisi vermez ("explicitly nondeterministic"),
-- yalnızca forEachOrdered() verir. Örneğin yorumu düzeltildi ve ikinci yazdırma forEachOrdered()'a
-- geçirildi (çıktı değişmedi; örneğin "Beklenen Çıktı" paneli yok). TR ve EN ders metninde
-- forEach() bölümüne sıralı/paralel ayrımını ve forEachOrdered() farkını anlatan bir paragraf
-- eklendi, cheat sheet'e forEachOrdered() satırı kondu. Örnek dosyası iki dilin ortak kaynağı
-- olduğu ve iki dilin metni de değiştiği için (bkz. CLAUDE.md, updated_at kuralı) dersin hem TR
-- hem EN çevirisi ilerler: toplam iki satır.
--
-- Tarih açık bir değerdir, migration'ın uygulandığı gün değil. Slug + dil ile anahtarlanır,
-- ortama özgü id kullanılmaz. updated_at < hedef koşulu tarihi asla geri almaz ve tekrar
-- çalıştırıldığında hiçbir satırı değiştirmez.
UPDATE topic_translation tt
SET updated_at = DATE '2026-11-05'
FROM topic t
WHERE tt.topic_id = t.id
  AND t.slug = 'terminal-operations'
  AND tt.language IN ('tr', 'en')
  AND tt.updated_at < DATE '2026-11-05';
