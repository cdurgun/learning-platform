-- Tüm bölümler (20 ana + 2 ek) ve 17 kod örneğiyle içerik artık tamamlandı --
-- Reflection'daki V19'a paralel şekilde son süre tahminini güncelliyoruz. Interface,
-- Record'la aynı INTERMEDIATE zorluk seviyesinde ama biraz daha kapsamlı olduğu için
-- (20 ana bölüm + 2 mini proje) süresi Record'dan (45 dk) biraz yüksek tutuldu.
UPDATE topic
SET estimated_minutes = 50
WHERE slug = 'interface';
