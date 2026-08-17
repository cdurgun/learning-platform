-- Kullanıcı ChatGPT'nin `java-basics`'i genişletme önerisini paylaştı (String, Arrays,
-- Scanner, Wrapper Classes & Autoboxing, Date & Time API, File I/O, Enum, Record,
-- Reflection) ve "sen ne dersin" diye sordu. Değerlendirme:
--   - Enum/Records/Reflection/Date & Time API zaten `java-basics`'te mevcut (4/4).
--   - ChatGPT'nin ayrı önerdiği "Functional Programming" kategorisi de zaten
--     `functional-interfaces-streams` olarak tamamlanmış durumda (farklı isim/gruplama,
--     aynı kapsam + method reference'lar).
--   - Gerçekten yeni olan: String, Arrays, Scanner, Wrapper Classes & Autoboxing,
--     File I/O (java-basics'e 5 yeni topic) + hiç var olmayan bir "Collections"
--     kategorisi (List/Set/Map/Queue).
--   - Reflection'ın DB'de zaten `difficulty = ADVANCED` olmasına rağmen java-basics'te
--     erken sırada (sort_order=3) durması gerçek bir tutarsızlık -- ayrı bir fazda
--     düzeltilecek (sona alınacak).
--   - Collections'ın alt maddelerini (List, ArrayList, LinkedList, Set, HashSet, Map,
--     HashMap, Queue, Collections Utility -- 9 madde) ayrı ayrı topic yapmak yerine, bu
--     projenin yerleşik pratiğiyle (bkz. `built-in-functional-interfaces`'in 4 interface
--     tipini + method reference'ları TEK topic'te toplaması) 4 zengin topic'e
--     indirgendi: Lists, Sets, Maps, Queues & Collections Utility.
--   - Collections kategorisi ayrıca gerçek bir boşluğu dolduruyor: `collectors` topic'i
--     (functional-interfaces-streams) zaten `Map<K,List<V>>` üreten `groupingBy()` gibi
--     API'leri anlatıyor ama List/Set/Map temellerini anlatan hiçbir topic yok.
--
-- Kullanıcı onayladı ("Önce Collections kategorisini yapabilirsin"). Kategori sırası:
-- java-basics(1) -> collections(2, YENİ) -> oop(3, eskiden 2) -> concurrency(4, eskiden 3)
-- -> functional-interfaces-streams(5, eskiden 4). Mevcut kategorilerin sort_order'ı
-- kaydırılıyor, topic'lere DOKUNULMUYOR (topic.sort_order kategoriye özel, bkz. CLAUDE.md).
--
-- Bu kategori de saf JDK (`java.util`) -- functional-interfaces-streams'teki gibi
-- kullanıcı onayıyla gerçek sandbox-compile sürecine devam ediliyor: her örnek javac+java
-- ile gerçekten derlenip çalıştırılıp çıktısı doğrulandı (yalnızca migration
-- yorumlarında belgeleniyor, Faz 42 kuralı gereği ders metninde değil).
--
-- Planlanan 4 topic (sort_order): 1) lists, 2) sets, 3) maps, 4) queues-collections-
-- utility. Bu migration yalnızca kategoriyi ve ilk topic'i (lists) açıyor.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Collections', 'collections', 2
FROM course
WHERE slug = 'java';

UPDATE category SET sort_order = 3 WHERE slug = 'oop';
UPDATE category SET sort_order = 4 WHERE slug = 'concurrency';
UPDATE category SET sort_order = 5 WHERE slug = 'functional-interfaces-streams';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'lists', 'BEGINNER', 20, 1
FROM category
WHERE slug = 'collections';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Lists',
       'Collections kategorisinin ilk topic''i: `List` arayüzü, `ArrayList` ile `LinkedList`''in gerçek bir ısıtılmış ölçümle karşılaştırılan performans farkı, `List.of()`/`Collections.unmodifiableList()`/`List.copyOf()` ile immutable listeler, `Iterator`/`ListIterator` ile güvenli dolaşma, `List.sort(Comparator)` ile sıralama, ve `subList()`/`toArray()`.',
       'Java List, ArrayList ve LinkedList Nedir? Örneklerle Anlatım',
       'Java''nın `List` arayüzü ve iki temel implementasyonu `ArrayList` ile `LinkedList` -- aralarındaki O(1)/O(n) erişim farkı gerçek bir ölçümle gösteriliyor; `List.of()`, `Collections.unmodifiableList()` ve `List.copyOf()` arasındaki fark; `ConcurrentModificationException`''dan kaçınmak için `Iterator`/`ListIterator`; `Comparator` ile sıralama; ve `subList()`''in bir görünüm (view) olduğu gerçeği -- gerçek Java örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'lists';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Lists',
       'The first topic in the Collections category: the `List` interface, the performance difference between `ArrayList` and `LinkedList` shown with a real warmed-up measurement, immutable lists via `List.of()`/`Collections.unmodifiableList()`/`List.copyOf()`, safe iteration with `Iterator`/`ListIterator`, sorting with `List.sort(Comparator)`, and `subList()`/`toArray()`.',
       'What Are Java List, ArrayList, and LinkedList? Explained with Examples',
       'Java''s `List` interface and its two core implementations, `ArrayList` and `LinkedList` -- the O(1)/O(n) access difference between them shown with a real measurement; the difference between `List.of()`, `Collections.unmodifiableList()`, and `List.copyOf()`; using `Iterator`/`ListIterator` to avoid `ConcurrentModificationException`; sorting with `Comparator`; and the fact that `subList()` returns a view -- explained with real Java examples.',
       false
FROM topic
WHERE slug = 'lists';
