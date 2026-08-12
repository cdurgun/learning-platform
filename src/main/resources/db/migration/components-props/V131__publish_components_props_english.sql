-- İngilizce çeviriler tamamlandı (content/en/components.md, props.md,
-- component-composition.md) -- TR ile birebir aynı başlık ve embed sayısı/sırası.
-- Üçü birden yayına alınıyor.
--
-- "Components & Props" kategorisi tamamlandı -- react course'u artık iki kategori,
-- altı yayında topic'e sahip. Sıradaki kategori: "State & Events".
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id IN (SELECT id FROM topic WHERE slug IN ('components', 'props', 'component-composition'));
