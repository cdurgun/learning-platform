-- Tüm bölümler (21 ana + 2 ek) ve 19 kod örneğiyle içerik artık tamamlandı --
-- Threads'teki V49'a paralel şekilde son süre tahminini güncelliyoruz. Date & Time,
-- diğer INTERMEDIATE konulardan (Record/Interface/Abstract Class/Inheritance/
-- Polymorphism) daha geniş kapsamlı olduğu için süresi Threads'le (55 dk) aynı tutuldu.
UPDATE topic
SET estimated_minutes = 55
WHERE slug = 'date-time';
