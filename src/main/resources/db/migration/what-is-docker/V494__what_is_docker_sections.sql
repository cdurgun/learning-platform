-- `what-is-docker` konusu için `code_example` YOK -- postgresql-and-the-
-- relational-model (V400 ailesi) ile aynı sebep: bu ders bilinçli olarak
-- 0 embed'li, saf bir kavramsal oryantasyon dersi (bkz. V493 yorumu).
-- Yalnızca bu konunun sabit quiz shell'i (TR+EN) -- SORU İÇERMİYOR, bkz.
-- CLAUDE.md "Mimari" Faz 87 maddesi: soru içeriği yalnızca ingestion
-- API'den gelir, hiçbir zaman bir migration'a yazılmaz. `git-fundamentals`
-- (V433) ile BİREBİR aynı desen: slug='default', pass_threshold=0.80,
-- active=true.

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'what-is-docker';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'what-is-docker';
