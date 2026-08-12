-- İçerik tamamlandı -- kullanıcı kararıyla sade bir dille, kısa tutuldu (mini proje
-- eki yok, Java/Spring konularına göre çok daha az bölüm ve örnek). V124'teki iskelet
-- tahmini olan 5 dakikayı gerçek içerik uzunluğuna göre güncelliyoruz.
UPDATE topic SET estimated_minutes = 8 WHERE slug = 'what-is-react';
UPDATE topic SET estimated_minutes = 10 WHERE slug = 'creating-a-react-application';
UPDATE topic SET estimated_minutes = 12 WHERE slug = 'jsx';
