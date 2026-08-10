-- Tüm bölümler (17 ana + 2 ek) ve 14 kod örneğiyle içerik artık tamamlandı --
-- Interface'teki V25'e paralel şekilde son süre tahminini güncelliyoruz. Dependency
-- Injection & IoC, Interface/Abstract Class'la aynı INTERMEDIATE zorluk seviyesinde ama
-- biraz daha az kod örneğine (14 vs 15-17) sahip olduğu için süresi onlardan (50 dk)
-- biraz düşük tutuldu.
UPDATE topic
SET estimated_minutes = 45
WHERE slug = 'dependency-injection';
