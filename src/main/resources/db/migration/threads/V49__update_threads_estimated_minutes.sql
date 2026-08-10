-- Tüm bölümler (18 ana + 2 ek) ve 16 kod örneğiyle içerik artık tamamlandı --
-- Reflection'daki V19'a paralel şekilde son süre tahminini güncelliyoruz. Threads,
-- Reflection'la aynı ADVANCED zorluk seviyesinde ama biraz daha geniş kapsamlı olduğu
-- için süresi Reflection'ın (50 dk) biraz üzerinde tutuldu.
UPDATE topic
SET estimated_minutes = 55
WHERE slug = 'threads';
