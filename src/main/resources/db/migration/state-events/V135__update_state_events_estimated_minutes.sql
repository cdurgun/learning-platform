-- İçerik tamamlandı -- V133'teki iskelet tahmini olan 5 dakikayı gerçek içerik
-- uzunluğuna göre güncelliyoruz. state, kategorinin çekirdeği olduğu için en uzunu.
UPDATE topic SET estimated_minutes = 9 WHERE slug = 'events';
UPDATE topic SET estimated_minutes = 12 WHERE slug = 'state';
UPDATE topic SET estimated_minutes = 9 WHERE slug = 'conditional-rendering';
UPDATE topic SET estimated_minutes = 10 WHERE slug = 'lists-and-keys';
