-- Enum ve Record'dan sonraki üçüncü Java Basics konusu: Reflection. Enum (BEGINNER) ve
-- Record'dan (INTERMEDIATE) belirgin şekilde daha ileri bir konu olduğu için ADVANCED
-- olarak işaretlendi. Şimdilik yalnızca 1. bölüm (Giriş: Nedir / Neden Var / Tarihçe)
-- yazıldı — estimated_minutes buna göre düşük tutuldu, içerik büyüdükçe Record'da
-- yaptığımız gibi kademeli olarak güncellenecek.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'reflection', 'ADVANCED', 5, 3
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Reflection',
       'Java''da çalışma zamanında sınıf, alan, metot ve constructor bilgisine erişme ve bunları dinamik olarak kullanma.',
       'Java Reflection Nedir? | Örneklerle Anlatım',
       'Java''da Reflection API kullanımı; Class nesneleri, dinamik metot çağırma, annotation okuma ve gerçek dünya örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'reflection';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Reflection',
       'Accessing and dynamically using class, field, method, and constructor information at runtime in Java.',
       'What is Java Reflection? | With Examples',
       'Learn the Java Reflection API: Class objects, dynamic method invocation, reading annotations, and real-world examples.',
       false
FROM topic
WHERE slug = 'reflection';
