-- PostgreSQL kursu, PostgreSQL Foundations kategorisi, Topic 7:
-- "SELECT and Filtering"
-- (inserting-updating-and-deleting-data'nın hemen ardına, sort_order=7,
-- BEGINNER -- onaylanan roadmap'te belirtildiği gibi). Kod embed'i YOK --
-- SQL örnekleri bu projenin kendi GERÇEK topic/category tablosu üzerinde
-- yazılmış inline ```sql fence'ler, ayrı bir "sections" migration'ı
-- gerektirmiyor. TR published=true, EN published=false.
INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'select-and-filtering', 'BEGINNER', 20, 7
FROM category
WHERE slug = 'postgresql-foundations';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'SELECT and Filtering',
       'SELECT''in temel şekli, SELECT * yerine kolonları açıkça adlandırma, karşılaştırma/mantıksal operatörler, LIKE desen eşleştirme, IN/BETWEEN, ve NULL''ın neden = ile değil yalnızca IS NULL ile filtrelenebildiği -- bu projenin kendi gerçek topic/category tablosu üzerinde. PostgreSQL Foundations kategorisinin 7.''si.',
       'PostgreSQL''de SELECT ve Filtreleme',
       'SELECT, WHERE, karşılaştırma ve mantıksal operatörler, LIKE, IN/BETWEEN, ve NULL filtrelemesi bu projenin kendi gerçek verisiyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'select-and-filtering';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'SELECT and Filtering',
       'The basic shape of SELECT, naming columns explicitly instead of SELECT *, comparison/logical operators, LIKE pattern matching, IN/BETWEEN, and why NULL can only be filtered with IS NULL, not = -- on this project''s own real topic/category table. The 7th lesson in the PostgreSQL Foundations category.',
       'SELECT and Filtering in PostgreSQL',
       'SELECT, WHERE, comparison and logical operators, LIKE, IN/BETWEEN, and NULL filtering, explained with this project''s own real data.',
       false
FROM topic
WHERE slug = 'select-and-filtering';
