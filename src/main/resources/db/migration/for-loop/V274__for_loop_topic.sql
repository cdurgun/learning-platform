-- `control-flow` kategorisine üçüncü topic: `for Loop` (slug: for-loop, sort_order=3).
-- Kapsam: klasik üç bölümlü (init;condition;update) sözdizimi, `break` (döngüden erken
-- çıkma), `continue` (bir adımı atlama -- kullanıcının kendi kararıyla break/continue
-- ayrı bir topic olmaktan çıkarılıp for Loop'un içine taşındı, bkz. V268 notu),
-- kasıtlı sonsuz döngü (`for (;;)`) ve kasıtsız sonsuz döngü tuzağı, birden fazla
-- değişkenle for (virgüllü init/update), ve klasik index tabanlı dizi gezinme
-- ("Enhanced for Loop"e -- henüz yazılmadı -- ileriye referansla, indekse ihtiyaç
-- olmadığında daha kısa bir alternatif olduğu belirtiliyor).
--
-- 6 örneğin tamamı bu sandbox'ta javac+java ile GERÇEKTEN derlenip çalıştırıldı --
-- kasıtlı sonsuz döngünün gerçekten 3 denemeden sonra break ile durduğu, break/continue
-- davranışlarının beklenen çıktıyı ürettiği gerçek çıktıyla doğrulandı. Kasıtsız sonsuz
-- döngü örneği YORUM olarak (çalıştırılmadan) gösteriliyor -- gerçekten çalıştırılırsa
-- sandbox'ı sonsuza kadar kilitler. Kod yorumları İNGİLİZCE (bkz. Faz 53).
--
-- BEGINNER zorlukta -- if-else/switch ile aynı seviye.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'for-loop', 'BEGINNER', 20, 3
FROM category
WHERE slug = 'control-flow';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'for Loop',
       'Control Flow kategorisinin üçüncü topic''i: klasik üç bölümlü (init;condition;update) `for` sözdizimi, `break` ile erken çıkış, `continue` ile bir adımı atlama, kasıtlı/kasıtsız sonsuz döngüler, virgüllü init/update ile birden fazla değişken, ve klasik index tabanlı dizi gezinme.',
       'Java for Döngüsü Nedir? break, continue ve Dizi Gezinme',
       'Java''nın `for` döngüsü -- klasik sözdizimi, `break`/`continue` ile akış kontrolü, sonsuz döngüler, ve index tabanlı dizi gezinme -- gerçek Java örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'for-loop';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'for Loop',
       'The third topic in the Control Flow category: the classic three-part (init;condition;update) `for` syntax, exiting early with `break`, skipping a step with `continue`, deliberate/unintentional infinite loops, multiple variables via comma-separated init/update, and classic index-based array iteration.',
       'What Is a Java for Loop? break, continue, and Array Iteration',
       'Java''s `for` loop -- classic syntax, controlling flow with `break`/`continue`, infinite loops, and index-based array iteration -- explained with real Java examples.',
       false
FROM topic
WHERE slug = 'for-loop';
