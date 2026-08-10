-- EN çevirisi (content/en/autoconfiguration-properties.md) tamamlandı -- kullanıcı
-- kararıyla bu kez TR ve EN aynı oturumda art arda yapıldığı için, önceki konularda
-- olduğu gibi ayrı bir bekleme dönemi olmadan doğrudan yayına alıyoruz.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'autoconfiguration-properties');
