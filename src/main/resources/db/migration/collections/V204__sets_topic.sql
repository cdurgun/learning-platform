-- Collections kategorisinin ikinci topic'i: `sets` (sort_order=2, lists'ten sonra).
-- Kullanıcı onayıyla ("KOntrol ettim, devam edebilirsin") planlanan 4 topic'in
-- ikincisine geçiliyor.
--
-- Kapsam: `Set` arayüzü (tekrar eden elemanlara izin vermez), `HashSet`/
-- `LinkedHashSet`/`TreeSet` implementasyon farkları, `NavigableSet` metotları
-- (`first`/`last`/`higher`/`lower`/`ceiling`/`floor`/`headSet`/`tailSet`),
-- `equals()`/`hashCode()` sözleşmesinin `HashSet` için neden kritik olduğu (gerçek bir
-- hata örneğiyle -- override edilmezse "eşit" görünen nesneler yinelenen sayılır),
-- küme işlemleri (`addAll`/`retainAll`/`removeAll` ile birleşim/kesişim/fark), ve
-- List/HashSet/TreeSet arasındaki `contains()` performans farkı.
--
-- "Lists" dersine geriye dönük çapraz referans veriliyor (kategori sırasında ondan
-- hemen sonra geliyor).
--
-- GERÇEK ÖLÇÜM (bu kategori de saf JDK, sandbox-compile sürecine devam ediliyor):
-- SetPerformanceExample.java iki aşamalı bir ölçüm yapıyor. (1) 20.000 elemanlı bir
-- koleksiyonda 2.000 kez contains(): List ~70-90 ms, HashSet/TreeSet ölçülemeyecek
-- kadar hızlı (0 ms) -- List'in O(n) taramasının ne kadar pahalı olduğunu gösteriyor.
-- (2) Bu ölçekte HashSet (O(1)) ile TreeSet (O(log n)) arasındaki fark görünmediği
-- için, 200.000 elemanlı bir koleksiyonda 200.000 kez contains() ile tekrarlandı:
-- HashSet ~9-10 ms, TreeSet ~15-21 ms -- aradaki teorik fark büyük ölçekte gerçekten
-- ölçülebilir hâle geldi. Ayrıca HashSetEqualsHashCodeExample.java, equals()/
-- hashCode() override edilmeden HashSet'e eklenen iki "değerce eşit" nesnenin
-- GERÇEKTEN farklı sayıldığını (boyut=2) canlı olarak gösteriyor.
--
-- BEGINNER zorlukta -- `lists` ile aynı seviye.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'sets', 'BEGINNER', 20, 2
FROM category
WHERE slug = 'collections';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Sets',
       'Collections kategorisinin ikinci topic''i: `Set` arayüzü ve tekrar eden elemanlara izin vermemesi, `HashSet`/`LinkedHashSet`/`TreeSet` farkları, `NavigableSet` metotları, `equals()`/`hashCode()` sözleşmesinin `HashSet` için neden kritik olduğu (gerçek bir hata örneğiyle), küme işlemleri (birleşim/kesişim/fark), ve List/HashSet/TreeSet arasındaki gerçek bir performans ölçümü.',
       'Java Set, HashSet ve TreeSet Nedir? Örneklerle Anlatım',
       'Java''nın `Set` arayüzü ve üç implementasyonu -- `HashSet`, `LinkedHashSet`, `TreeSet` -- aralarındaki fark; `NavigableSet`''in `first`/`last`/`higher`/`lower`/`ceiling`/`floor` metotları; `HashSet`''in doğru çalışması için `equals()`/`hashCode()` sözleşmesinin neden şart olduğu; `addAll()`/`retainAll()`/`removeAll()` ile birleşim/kesişim/fark; ve List/HashSet/TreeSet''in `contains()` performansının gerçek bir ölçümle karşılaştırılması -- gerçek Java örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'sets';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Sets',
       'The second topic in the Collections category: the `Set` interface and its no-duplicates guarantee, the differences between `HashSet`/`LinkedHashSet`/`TreeSet`, `NavigableSet` methods, why the `equals()`/`hashCode()` contract is critical for `HashSet` (with a real bug example), set operations (union/intersection/difference), and a real performance measurement comparing List/HashSet/TreeSet.',
       'What Are Java Set, HashSet, and TreeSet? Explained with Examples',
       'Java''s `Set` interface and its three implementations -- `HashSet`, `LinkedHashSet`, `TreeSet` -- and the differences between them; `NavigableSet`''s `first`/`last`/`higher`/`lower`/`ceiling`/`floor` methods; why the `equals()`/`hashCode()` contract is essential for `HashSet` to work correctly; union/intersection/difference via `addAll()`/`retainAll()`/`removeAll()`; and a real measurement comparing `contains()` performance across List/HashSet/TreeSet -- explained with real Java examples.',
       false
FROM topic
WHERE slug = 'sets';
