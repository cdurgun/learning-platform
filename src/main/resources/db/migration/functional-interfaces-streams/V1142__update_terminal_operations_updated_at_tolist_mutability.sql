-- terminal-operations dersi, Stream.toList()'i collect(Collectors.toList())'in kısayolu gibi
-- anlatıyor ve Collectors.toList()'in değiştirilebilir (mutable) bir liste döndürdüğünü
-- garanti ediyormuş gibi gösteriyordu; Java API dokümantasyonu döndürülen listenin türü ve
-- değiştirilebilirliği hakkında hiçbir garanti vermez (aynı düzeltme collectors dersi için
-- V1140, quiz soruları için V1141). TR ve EN ders metni düzeltildi; sayfada görünen ortak
-- örnek ToListToArrayExample.java'nın yorumu da aynı yanlışı içerdiği için düzeltildi
-- (kod değişmedi). Örnek dosyası iki dilin ortak kaynağı olduğu için (bkz. CLAUDE.md,
-- updated_at kuralı) her iki çevirinin tarihi ilerler.
--
-- Tarih açık bir değerdir, migration'ın uygulandığı gün değil. Slug + dil ile anahtarlanır;
-- updated_at < hedef koşulu tarihi asla geri almaz ve tekrar çalıştırıldığında hiçbir satırı
-- değiştirmez.
UPDATE topic_translation tt
SET updated_at = DATE '2026-10-19'
FROM topic t
WHERE tt.topic_id = t.id
  AND t.slug = 'terminal-operations'
  AND tt.language IN ('tr', 'en')
  AND tt.updated_at < DATE '2026-10-19';
