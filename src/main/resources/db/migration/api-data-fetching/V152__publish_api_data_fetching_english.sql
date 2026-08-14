-- Kullanıcı kararıyla (Faz 20'nin sonunda) her topic'in EN'i, TR'siyle aynı
-- fazda onay beklemeden yazılıyor -- burada iki topic'in EN çevirisini de
-- yayına alıyoruz.
UPDATE topic_translation SET published = true
WHERE language = 'en'
  AND topic_id IN (SELECT id FROM topic WHERE slug IN ('fetching-data', 'react-rest-api'));
