-- Kullanıcı kararıyla (Faz 20'nin sonunda) her topic'in EN'i, TR'siyle aynı
-- fazda onay beklemeden yazılıyor -- burada beş topic'in EN çevirisini de
-- yayına alıyoruz.
UPDATE topic_translation SET published = true
WHERE language = 'en'
  AND topic_id IN (
    SELECT id FROM topic
    WHERE slug IN (
      'react-performance',
      'error-boundaries',
      'lazy-loading-code-splitting',
      'suspense',
      'portals'
    )
  );
