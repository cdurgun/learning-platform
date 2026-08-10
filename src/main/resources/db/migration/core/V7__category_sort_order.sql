-- Faz 3: Prev/Next Topic navigasyonu, kategori sınırlarını doğru sırayla geçebilmek için
-- kategoriler arasında da bir sıralama gerektiriyor (Topic'te zaten vardı, Category'de yoktu).
ALTER TABLE category
    ADD COLUMN sort_order INTEGER NOT NULL DEFAULT 0;

UPDATE category
SET sort_order = 1
WHERE slug = 'java-basics';
