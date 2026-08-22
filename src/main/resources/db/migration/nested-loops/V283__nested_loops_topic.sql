-- `control-flow` kategorisine altıncı ve son topic: `Nested Loops` (slug:
-- nested-loops, sort_order=6). Kategori bu topic ile TAMAMLANIYOR: if / else,
-- switch, for Loop, Enhanced for Loop, while & do-while Loops, Nested Loops.
-- Kapsam: temel iç içe for döngüsü, 2 boyutlu dizi gezinme, etiketsiz
-- break/continue'nun yalnızca en içteki döngüyü etkilemesi, etiketli
-- (labeled) break/continue ile dış döngüyü doğrudan hedefleme, ve O(n^2)
-- maliyet/performans farkındalığı.
--
-- 6 örneğin tamamı bu sandbox'ta javac+java ile GERÇEKTEN derlenip çalıştırıldı --
-- etiketsiz break/continue'nun GERÇEKTEN yalnızca iç döngüyü durdurduğu/atladığı,
-- etiketli break'in GERÇEKTEN her iki döngüyü de sonlandırdığı, ve n=10/100/1000
-- için işlem sayısının GERÇEKTEN n^2 ile birebir eşleştiği (100/10.000/1.000.000)
-- gerçek çıktıyla doğrulandı. Kod yorumları İNGİLİZCE (bkz. Faz 53).
--
-- BEGINNER zorlukta -- diğer Control Flow topic'leriyle aynı seviye.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'nested-loops', 'BEGINNER', 20, 6
FROM category
WHERE slug = 'control-flow';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Nested Loops',
       'Control Flow kategorisinin altıncı ve son topic''i: temel iç içe `for` döngüsü, 2 boyutlu dizi gezinme, etiketsiz break/continue''nun yalnızca en içteki döngüyü etkilemesi, etiketli (labeled) break/continue, ve O(n²) performans farkındalığı.',
       'Java''da İç İçe Döngüler (Nested Loops) ve Etiketli break/continue',
       'Java''da iç içe döngüler -- 2 boyutlu dizi gezinme, etiketsiz/etiketli break ve continue farkı, ve O(n²) performans maliyeti gerçek Java örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'nested-loops';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Nested Loops',
       'The sixth and final topic in the Control Flow category: basic nested for loops, 2D array traversal, how unlabeled break/continue only affect the innermost loop, labeled break/continue, and O(n²) performance awareness.',
       'Java Nested Loops and Labeled break/continue Explained',
       'Nested loops in Java -- 2D array traversal, the difference between unlabeled and labeled break/continue, and the O(n²) performance cost, explained with real Java examples.',
       false
FROM topic
WHERE slug = 'nested-loops';
