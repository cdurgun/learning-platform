-- `control-flow` kategorisine ikinci topic: `switch` (sort_order=2, if-else'in hemen
-- ardına -- kategori yeni olduğu için mevcut topic'lerde sort_order kaydırmaya gerek
-- yok, V216/V219'daki gibi). Kapsam: klasik `case`/`break` sözdizimi, fall-through
-- tuzağı, Java 14'ten beri kalıcı olan modern ok (`->`) sözdizimi, switch İFADESİ ve
-- `yield`, birden fazla etiket + enum kapsayıcılık (exhaustiveness) kontrolü, ve
-- `String`/enum üzerinde switch. Pattern matching for switch (Java 21) BİLİNÇLİ OLARAK
-- kapsam DIŞI -- bu zaten "Record" dersinin "Ek: Record Patterns" bölümünde var, dersin
-- sonunda oraya çapraz referans veriliyor.
--
-- 6 örneğin tamamı bu sandbox'ta javac+java ile GERÇEKTEN derlenip çalıştırıldı --
-- fall-through'un (break'siz sürüm) gerçekten üç satır yazdığı, break'li sürümün tek
-- satır yazdığı; enum switch ifadesinin default OLMADAN derlendiği; hepsi gerçek
-- çıktıyla doğrulandı. Kod yorumları İNGİLİZCE (bkz. Faz 53).
--
-- BEGINNER zorlukta -- if-else ile aynı seviye (Control Flow'un ilk iki konusu).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'switch', 'BEGINNER', 20, 2
FROM category
WHERE slug = 'control-flow';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'switch',
       'Control Flow kategorisinin ikinci topic''i: klasik `case`/`break` sözdizimi ve fall-through tuzağı, modern ok (`->`) sözdizimi, switch İFADESİ ve `yield`, birden fazla etiket ve enum kapsayıcılık (exhaustiveness) kontrolü, ve `String`/enum üzerinde `switch` kullanımı.',
       'Java switch Nedir? Klasik ve Modern Sözdizimiyle Örneklerle',
       'Java''nın `switch` yapısı -- klasik `case`/`break` sözdizimi, fall-through tuzağı, modern ok sözdizimi, switch ifadesi ve `yield`, ve enum kapsayıcılık kontrolü -- gerçek Java örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'switch';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'switch',
       'The second topic in the Control Flow category: classic `case`/`break` syntax and the fall-through trap, the modern arrow (`->`) syntax, switch EXPRESSIONS and `yield`, multiple labels with enum exhaustiveness checking, and using `switch` with `String`/enum.',
       'What Is Java switch? Classic and Modern Syntax Explained',
       'Java''s `switch` construct -- classic `case`/`break` syntax, the fall-through trap, the modern arrow syntax, switch expressions and `yield`, and enum exhaustiveness checking -- explained with real Java examples.',
       false
FROM topic
WHERE slug = 'switch';
