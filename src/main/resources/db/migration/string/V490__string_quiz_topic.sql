-- `string` topic's fixed quiz shell (TR+EN) -- SORU İÇERMİYOR, aynı desen
-- enum/V291 ve git-fundamentals/V433'teki: slug='default', pass_threshold=0.80,
-- active=true. Soru içeriği V491/V492'de, promotion-migration deseniyle
-- (question-promotion/V431, git-fundamentals/V467/V468) ayrı ayrı ekleniyor.

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'string';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'string';
