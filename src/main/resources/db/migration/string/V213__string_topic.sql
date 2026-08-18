-- java-basics kategorisine yeni bir topic: `string`. Kullanıcı isteğiyle ("String
-- topic sanırım ilk konu? Enum'dan önce gelmesi lazım") String, java-basics'in
-- İLK konusu olarak ekleniyor (sort_order=1) -- mevcut enum/records/reflection/
-- date-time topic'leri bir kaydırılıyor (1,2,3,4 -> 2,3,4,5). Bu, Faz 51'de
-- `collections` kategorisi eklenirken kullanılan aynı "sort_order kaydırma"
-- deseniyle uygulanıyor (yalnızca `topic.sort_order` UPDATE edilir, başka hiçbir
-- alana dokunulmaz).
--
-- Kapsam: `String` sınıfının IMMUTABLE tasarımı, string pool (intern table) ve
-- `==` vs `equals()` tuzağı, `+` ile birleştirmenin O(n^2) maliyeti vs
-- `StringBuilder`'ın amortized O(1)'i (gerçek, ısıtılmış bir ölçümle), `String.
-- format()`/`formatted()` ve text block'lar (Java 15+), ve split/join/replace/
-- trim/strip gibi yardımcı metotlar.
--
-- GERÇEK ÖLÇÜM (bu topic de saf JDK, sandbox-compile sürecine devam ediliyor):
-- StringConcatenationPerformanceExample.java, 30.000 parçadan bir string
-- oluştururken `+` operatörünü `StringBuilder`'a karşı ölçüyor -- `+` tutarlı
-- şekilde onlarca milisaniye sürdü (~63-80 ms, çalıştırmalar arasında değişti),
-- `StringBuilder` bu ölçekte ölçülemeyecek kadar hızlıydı (0 ms).
--
-- BEGINNER zorlukta -- `enum` ile aynı seviye (java-basics'in ilk iki konusu).

-- Önce mevcut java-basics topic'lerinin sort_order'ını bir kaydır (String'e yer aç).
UPDATE topic
SET sort_order = sort_order + 1
WHERE category_id = (SELECT id FROM category WHERE slug = 'java-basics');

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'string', 'BEGINNER', 20, 1
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'String',
       'Java Basics kategorisinin ilk topic''i: `String`''in IMMUTABLE tasarımı, string pool ve `==` vs `equals()` tuzağı, `+` ile birleştirmenin O(n^2) maliyeti vs `StringBuilder`''ın amortized O(1)''i (gerçek, ısıtılmış bir ölçümle), `String.format()`/text block''lar (Java 15+), ve split/join/replace/trim/strip gibi yardımcı metotlar.',
       'Java String Nedir? Immutability, String Pool ve StringBuilder',
       'Java''nın `String` sınıfı neden immutable (değişmez), string pool ne işe yarar, `==` ile `equals()` arasındaki kritik fark, `+` operatörüyle birleştirmenin neden `StringBuilder`''dan çok daha yavaş olduğu gerçek bir ölçümle, ve `String.format()`/text block''lar gibi modern Java özellikleri örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'string';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'String',
       'The first topic in the Java Basics category: `String`''s IMMUTABLE design, the string pool and the `==` vs `equals()` trap, the O(n^2) cost of `+` concatenation vs. `StringBuilder`''s amortized O(1) (with a real, warmed-up measurement), `String.format()`/text blocks (Java 15+), and helper methods like split/join/replace/trim/strip.',
       'What Is Java String? Immutability, String Pool, and StringBuilder',
       'Why Java''s `String` class is immutable, what the string pool is for, the critical difference between `==` and `equals()`, why `+` concatenation is so much slower than `StringBuilder` shown with a real measurement, and modern Java features like `String.format()`/text blocks explained with examples.',
       false
FROM topic
WHERE slug = 'string';
