-- collectors dersi, Collectors.toList()'in değiştirilebilir (mutable) bir liste döndürdüğünü
-- garanti ediyormuş gibi anlatıyordu; Java API dokümantasyonu döndürülen listenin türü ve
-- değiştirilebilirliği hakkında hiçbir garanti vermez. TR ve EN ders metni düzeltildi ve
-- ortak örnek ToListToSetExample.java, listeyi değiştirdiği yerde artık
-- Collectors.toCollection(ArrayList::new) kullanıyor. Örnek dosyası iki dilin ortak kaynağı
-- olduğu için (bkz. CLAUDE.md, updated_at kuralı) her iki çevirinin tarihi ilerler.
--
-- Tarih açık bir değerdir, migration'ın uygulandığı gün değil. Slug + dil ile anahtarlanır;
-- updated_at < hedef koşulu tarihi asla geri almaz ve tekrar çalıştırıldığında hiçbir satırı
-- değiştirmez.
UPDATE topic_translation tt
SET updated_at = DATE '2026-10-19'
FROM topic t
WHERE tt.topic_id = t.id
  AND t.slug = 'collectors'
  AND tt.language IN ('tr', 'en')
  AND tt.updated_at < DATE '2026-10-19';
