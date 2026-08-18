-- java-basics kategorisine yeni bir topic: `arrays`. Kullanıcı isteğiyle
-- ("Arrays ile devam edebilirsin") String'den (Faz 56) sonraki ikinci konu
-- olarak ekleniyor -- sort_order=2, mevcut enum/records/reflection/date-time
-- topic'leri bir kaydırılıyor (2,3,4,5 -> 3,4,5,6). Aynı "sort_order kaydırma"
-- deseni (Faz 51/56'da kullanılan) burada da uygulanıyor.
--
-- Kapsam: dizilerin sabit boyutlu, aynı tipten, bitişik bellekte tutulan yapısı
-- (Collections kategorisindeki O(1) erişim iddialarının GERÇEK kaynağı), çok
-- boyutlu diziler (jagged array dahil), `Arrays` yardımcı sınıfı (sort/
-- binarySearch/equals/fill/copyOf/copyOfRange), array covariance ve
-- `ArrayStoreException` (generic'lerin bilerek ÖNLEDİĞİ bir tuzak), `Arrays.
-- asList()`'in kopya değil GÖRÜNÜM olması, ve varargs (`Type... args`).
--
-- GERÇEK DOĞRULAMA (bu topic de saf JDK, sandbox-compile sürecine devam
-- ediliyor): ArrayCovarianceExample.java, bir Integer[]'in Number[] değişkenine
-- atanıp içine bir Double yazılmaya çalışıldığında gerçek bir
-- ArrayStoreException fırlattığını canlı çalıştırmayla kanıtladı;
-- ArraysVsCollectionsExample.java, Arrays.asList()'in döndürdüğü listenin
-- gerçekten orijinal diziyi GÖRÜNÜM olarak sardığını (diziyi değiştirince
-- listenin de değiştiğini) ve add()'in gerçekten UnsupportedOperationException
-- fırlattığını doğruladı.
--
-- BEGINNER zorlukta -- `string`/`enum` ile aynı seviye.

-- Mevcut java-basics topic'lerinden string'ten sonrakileri bir kaydır
-- (Arrays'e yer aç -- yalnızca sort_order >= 2 olanlar, string=1 sabit kalır).
UPDATE topic
SET sort_order = sort_order + 1
WHERE category_id = (SELECT id FROM category WHERE slug = 'java-basics')
  AND sort_order >= 2;

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'arrays', 'BEGINNER', 20, 2
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Arrays',
       'Java Basics kategorisinin ikinci topic''i: dizilerin sabit boyutlu, bitişik bellek yapısı, çok boyutlu diziler (jagged array dahil), `Arrays` yardımcı sınıfı (sort/binarySearch/equals/fill/copyOf), array covariance ve `ArrayStoreException` tuzağı, `Arrays.asList()`''in görünüm (view) olması, ve varargs.',
       'Java Array (Dizi) Nedir? Örneklerle Anlatım',
       'Java''nın dizi (array) yapısı, çok boyutlu ve jagged diziler, `Arrays` yardımcı sınıfının sort()/binarySearch()/equals() metotları, array covariance''ın neden gizli bir `ArrayStoreException` tuzağı taşıdığı, `Arrays.asList()`''in kopya değil görünüm olması, ve varargs (`Type... args`) örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'arrays';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Arrays',
       'The second topic in the Java Basics category: arrays'' fixed-size, contiguous-memory structure, multi-dimensional arrays (including jagged arrays), the `Arrays` utility class (sort/binarySearch/equals/fill/copyOf), array covariance and the `ArrayStoreException` trap, `Arrays.asList()` being a view, and varargs.',
       'What Is a Java Array? Explained with Examples',
       'Java''s array structure, multi-dimensional and jagged arrays, the `Arrays` utility class''s sort()/binarySearch()/equals() methods, why array covariance carries a hidden `ArrayStoreException` trap, why `Arrays.asList()` is a view rather than a copy, and varargs (`Type... args`) explained with examples.',
       false
FROM topic
WHERE slug = 'arrays';
