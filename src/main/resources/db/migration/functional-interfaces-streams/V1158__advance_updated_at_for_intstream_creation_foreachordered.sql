-- primitive-parallel-streams dersinin "IntStream Oluşturmak" örneği (IntStreamCreationExample.java)
-- aralıkları forEach() ile yazdırıyordu; Stream.forEach Javadoc'a göre sıralı bir stream'de bile
-- karşılaşma sırasını garanti etmez ("explicitly nondeterministic"), oysa örneğin "Beklenen
-- Çıktı" paneli (2026-10-18) tam olarak o sıraya dayanıyordu. Örnek forEachOrdered()'a geçirildi
-- ve bunu açıklayan bir yorum eklendi; panelin .out'u yeniden üretilip incelendi ve eskisiyle
-- byte byte aynı (manifest satırı yeni java_sha256 ile güncellendi). TR ve EN ders metninde aynı
-- bölüme bir cümle, "Yaygın Hatalar"daki sıralama maddesine ve cheat sheet'teki forEach satırına
-- da sıralı stream'in sırayı garanti etmediğini yansıtan küçük düzeltmeler eklendi.
-- Örnek dosyası iki dilin ortak kaynağı olduğu ve iki dilin metni de değiştiği için (bkz.
-- CLAUDE.md, updated_at kuralı) dersin hem TR hem EN çevirisi ilerler: toplam iki satır.
--
-- Tarih açık bir değerdir, migration'ın uygulandığı gün değil. Slug + dil ile anahtarlanır,
-- ortama özgü id kullanılmaz. updated_at < hedef koşulu tarihi asla geri almaz ve tekrar
-- çalıştırıldığında hiçbir satırı değiştirmez.
UPDATE topic_translation tt
SET updated_at = DATE '2026-11-05'
FROM topic t
WHERE tt.topic_id = t.id
  AND t.slug = 'primitive-parallel-streams'
  AND tt.language IN ('tr', 'en')
  AND tt.updated_at < DATE '2026-11-05';
