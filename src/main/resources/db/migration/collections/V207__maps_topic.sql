-- Collections kategorisinin üçüncü topic'i: `maps` (sort_order=3, sets'ten sonra).
-- Kullanıcı onayıyla ("Olur devam edebilirsin") planlanan 4 topic'in üçüncüsüne
-- geçiliyor.
--
-- Kapsam: `Map<K,V>` arayüzü (Collection'ı GENİŞLETMEZ, ayrı bir hiyerarşi),
-- `HashMap`/`LinkedHashMap`/`TreeMap` implementasyon farkları (Set'teki üçlüyle
-- birebir paralel), `NavigableMap` metotları (`firstKey`/`lastKey`/`higherKey`/
-- `lowerKey`/`ceilingKey`/`floorKey`/`headMap`/`tailMap`), immutable map'ler
-- (`Map.of()`/`Map.ofEntries()`/`Map.entry()`/`Collections.unmodifiableMap()`/
-- `Map.copyOf()`), Java 8'in modern Map API'si (`getOrDefault()`/`putIfAbsent()`/
-- `computeIfAbsent()`/`computeIfPresent()`/`merge()`), ve entrySet() ile
-- keySet()+get() arasındaki gerçek bir performans farkı.
--
-- "Sets" dersine geriye dönük çapraz referans veriliyor -- hem intro paragrafında
-- (Set'in "her eleman bir kez" fikrini Map'in "her anahtar bir kez + değer" fikrine
-- genişletmesi) hem de equals()/hashCode() sözleşmesi uyarısında ("Sets" dersindeki
-- "equals() ve hashCode() Sözleşmesi" bölümüne tam başlık alıntısıyla).
--
-- GERÇEK ÖLÇÜM (bu kategori de saf JDK, sandbox-compile sürecine devam ediliyor):
-- MapIterationPerformanceExample.java, 200.000 girişlik bir HashMap'te tüm
-- değerleri 50 kez toplayan iki farklı dolaşma yolunu ölçüyor: entrySet() ~120-145
-- ms, keySet() + get() (her eleman için GEREKSİZ bir ikinci arama yapıyor) ~140-170
-- ms -- entrySet()'in tutarlı şekilde daha hızlı olduğu gerçek çalıştırmayla
-- doğrulandı (birden fazla kez tekrarlanıp tutarlılık kontrol edildi).
--
-- BEGINNER zorlukta -- `lists`/`sets` ile aynı seviye.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'maps', 'BEGINNER', 20, 3
FROM category
WHERE slug = 'collections';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Maps',
       'Collections kategorisinin üçüncü topic''i: `Map<K,V>` arayüzü (her anahtar bir kez, değerlere eşlenir), `HashMap`/`LinkedHashMap`/`TreeMap` farkları, `NavigableMap` metotları, immutable map''ler (`Map.of()`/`Map.copyOf()`), Java 8''in modern API''si (`getOrDefault()`/`computeIfAbsent()`/`merge()`), ve `entrySet()` ile `keySet()+get()` arasındaki gerçek bir performans ölçümü.',
       'Java Map, HashMap ve TreeMap Nedir? Örneklerle Anlatım',
       'Java''nın `Map<K,V>` arayüzü ve üç implementasyonu -- `HashMap`, `LinkedHashMap`, `TreeMap`; `NavigableMap`''in `firstKey`/`lastKey`/`higherKey`/`lowerKey` metotları; `Map.of()`/`Collections.unmodifiableMap()`/`Map.copyOf()` ile immutable map''ler; Java 8''in `getOrDefault()`/`computeIfAbsent()`/`merge()` metotlarıyla sayma ve gruplama desenleri; ve `entrySet()`''in `keySet()+get()`''ten neden daha hızlı olduğu gerçek bir ölçümle gösteriliyor.',
       true
FROM topic
WHERE slug = 'maps';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Maps',
       'The third topic in the Collections category: the `Map<K,V>` interface (each key once, mapped to a value), the differences between `HashMap`/`LinkedHashMap`/`TreeMap`, `NavigableMap` methods, immutable maps (`Map.of()`/`Map.copyOf()`), Java 8''s modern API (`getOrDefault()`/`computeIfAbsent()`/`merge()`), and a real performance measurement comparing `entrySet()` and `keySet()+get()`.',
       'What Are Java Map, HashMap, and TreeMap? Explained with Examples',
       'Java''s `Map<K,V>` interface and its three implementations -- `HashMap`, `LinkedHashMap`, `TreeMap`; `NavigableMap`''s `firstKey`/`lastKey`/`higherKey`/`lowerKey` methods; immutable maps via `Map.of()`/`Collections.unmodifiableMap()`/`Map.copyOf()`; counting and grouping patterns with Java 8''s `getOrDefault()`/`computeIfAbsent()`/`merge()` methods; and a real measurement showing why `entrySet()` is faster than `keySet()+get()`.',
       false
FROM topic
WHERE slug = 'maps';
