-- İngilizce çeviri tamamlandı (content/en/queues-collections-utility.md) -- TR
-- ile birebir aynı yapı (12/12 başlık, 6/6 embed). Yayına alınıyor.
--
-- Bu migration'la birlikte `collections` kategorisi TAMAMLANIYOR (4/4 topic:
-- Lists, Sets, Maps, Queues & Collections Utility) -- bkz. CLAUDE.md Faz 55.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'queues-collections-utility');
