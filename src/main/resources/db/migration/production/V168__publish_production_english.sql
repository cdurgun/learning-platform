-- Kullanıcı kararıyla (Faz 20'nin sonunda) her topic'in EN'i, TR'siyle aynı
-- fazda onay beklemeden yazılıyor -- burada iki topic'in EN çevirisini de
-- yayına alıyoruz. Bu, React course'unun (ve ChatGPT'nin orijinal 11
-- kategorilik planının) SON kategorisi -- yayına alındığında kurs 11
-- kategori / 33 yayında topic'e ulaşıyor.
UPDATE topic_translation SET published = true
WHERE language = 'en'
  AND topic_id IN (
    SELECT id FROM topic
    WHERE slug IN (
      'build-deployment',
      'react-spring-boot-deployment'
    )
  );
