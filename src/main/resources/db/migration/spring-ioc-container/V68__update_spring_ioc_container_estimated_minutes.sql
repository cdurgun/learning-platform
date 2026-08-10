-- Tüm bölümler (20 ana + 2 ek) ve 16 kod örneğiyle içerik artık tamamlandı --
-- Threads'teki V49'a paralel şekilde son süre tahminini güncelliyoruz. Spring IoC
-- Container & Bean Lifecycle, Threads/Reflection'la aynı ADVANCED zorluk
-- seviyesinde ve benzer kapsamda (gerçek container/framework mekanizması) olduğu
-- için süresi onlarla (55 dk) aynı tutuldu.
UPDATE topic
SET estimated_minutes = 55
WHERE slug = 'spring-ioc-container';
