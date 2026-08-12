-- İçerik tamamlandı -- V128'deki iskelet tahmini olan 5 dakikayı gerçek içerik
-- uzunluğuna göre güncelliyoruz. component-composition, mini proje eki içerdiği için
-- biraz daha uzun.
UPDATE topic SET estimated_minutes = 8 WHERE slug = 'components';
UPDATE topic SET estimated_minutes = 10 WHERE slug = 'props';
UPDATE topic SET estimated_minutes = 12 WHERE slug = 'component-composition';
