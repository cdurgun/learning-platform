-- java-basics kategorisine yeni bir topic: `wrapper-classes` (Wrapper Classes &
-- Autoboxing). Kullanıcı isteğiyle ("Olur devam edebilirsin") Scanner'dan
-- (Faz 58) sonraki dördüncü konu olarak ekleniyor -- sort_order=4, mevcut
-- enum/records/reflection/date-time topic'leri yine bir kaydırılıyor
-- (4,5,6,7 -> 5,6,7,8). Faz 51/56/57/58'de kullanılan aynı "sort_order
-- kaydırma" deseni burada da uygulanıyor.
--
-- Kapsam: ilkel tiplerin (int/double/boolean vb.) nesne karşılıkları (Integer/
-- Double/Boolean vb.), autoboxing/autounboxing (Java 5, generic'lerin ilkel
-- tiplerle çalışamaması sorununu çözüyor), Integer önbellekleme (-128..127) ve
-- bunun "String" dersindeki == vs equals() tuzağına birebir paralel olan
-- kendi == tuzağı, null bir wrapper'ı unboxing yapmanın gerçek bir
-- NullPointerException fırlattığı (özellikle Map.get() ile), autoboxing'in
-- sıkı döngülerdeki gizli performans maliyeti, wrapper yardımcı metotları
-- (parseXxx/compare/toBinaryString), ve wrapper sınıflarının generic
-- koleksiyonları (List<Integer>) mümkün kılması.
--
-- GERÇEK DOĞRULAMA (bu topic de saf JDK, sandbox-compile sürecine devam
-- ediliyor): IntegerCachingExample.java, 100 için == ile true, 200 için ==
-- ile false döndüğünü canlı çalıştırmayla kanıtladı; AutoboxingNullPointer
-- Example.java, hem null bir Integer'ı aritmetikte kullanmanın hem de
-- Map.get()'in eksik bir anahtar için döndürdüğü null'ın unboxing edilmesinin
-- gerçek birer NullPointerException fırlattığını doğruladı.
--
-- GERÇEK ÖLÇÜM: AutoboxingPerformanceExample.java, ısıtılmış bir ölçümle (2
-- milyon tur ısıtma sonrası) 20 milyon sayıyı toplarken ilkel long
-- biriktiriciyi wrapper Long biriktiriciye karşı ölçtü -- ilkel tutarlı
-- şekilde ~7 ms, wrapper ise ~35-39 ms sürdü (birden fazla çalıştırmada
-- tutarlı çıktı).
--
-- BEGINNER zorlukta -- `string`/`arrays`/`scanner` ile aynı seviye.

-- Mevcut java-basics topic'lerinden scanner'dan sonrakileri bir kaydır
-- (Wrapper Classes'e yer aç -- yalnızca sort_order >= 4 olanlar, string=1,
-- arrays=2, scanner=3 sabit kalır).
UPDATE topic
SET sort_order = sort_order + 1
WHERE category_id = (SELECT id FROM category WHERE slug = 'java-basics')
  AND sort_order >= 4;

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'wrapper-classes', 'BEGINNER', 20, 4
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Wrapper Classes & Autoboxing',
       'Java Basics kategorisinin dördüncü topic''i: ilkel tiplerin nesne karşılıkları (Integer/Double/Boolean vb.), autoboxing/autounboxing, Integer önbellekleme (-128..127) ve `==` tuzağı, null bir wrapper''ı unboxing yapmanın gerçek bir NullPointerException fırlatması, autoboxing''in sıkı döngülerdeki performans maliyeti, ve wrapper sınıflarının generic koleksiyonları mümkün kılması.',
       'Java Wrapper Classes ve Autoboxing Nedir? Integer Önbellekleme Tuzağı',
       'Java''nın Integer/Double/Boolean gibi wrapper sınıfları, autoboxing/autounboxing''in nasıl çalıştığı, Integer önbelleklemesinin (-128..127) neden bir `==` tuzağı taşıdığı, null bir wrapper''ı unboxing yapmanın neden NullPointerException fırlattığı, ve autoboxing''in sıkı döngülerdeki gerçek performans maliyeti örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'wrapper-classes';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Wrapper Classes & Autoboxing',
       'The fourth topic in the Java Basics category: the object counterparts of primitive types (Integer/Double/Boolean, etc.), autoboxing/autounboxing, Integer caching (-128..127) and the `==` trap, why unboxing a null wrapper throws a real NullPointerException, autoboxing''s performance cost in tight loops, and how wrapper classes make generic collections possible.',
       'What Are Java Wrapper Classes and Autoboxing? The Integer Caching Trap',
       'Java''s wrapper classes like Integer/Double/Boolean, how autoboxing/autounboxing works, why Integer caching (-128..127) carries a `==` trap, why unboxing a null wrapper throws NullPointerException, and autoboxing''s real performance cost in tight loops, explained with examples.',
       false
FROM topic
WHERE slug = 'wrapper-classes';
