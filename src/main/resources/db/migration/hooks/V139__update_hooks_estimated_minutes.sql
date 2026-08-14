-- İçerik tamamlandı -- V137'deki iskelet tahmini olan 5 dakikayı gerçek içerik
-- uzunluğuna göre güncelliyoruz. use-effect, kategorinin en kapsamlısı olduğu
-- için en uzunu.
UPDATE topic SET estimated_minutes = 10 WHERE slug = 'what-are-hooks';
UPDATE topic SET estimated_minutes = 14 WHERE slug = 'use-effect';
UPDATE topic SET estimated_minutes = 11 WHERE slug = 'use-ref';
UPDATE topic SET estimated_minutes = 12 WHERE slug = 'use-memo-use-callback';
UPDATE topic SET estimated_minutes = 10 WHERE slug = 'custom-hooks';
