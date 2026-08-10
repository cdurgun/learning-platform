-- İçerik artık placeholder değil, tam ~19 bölümlük bir ders — süre tahminini güncelliyoruz.
UPDATE topic
SET estimated_minutes = 35
WHERE slug = 'enum';
