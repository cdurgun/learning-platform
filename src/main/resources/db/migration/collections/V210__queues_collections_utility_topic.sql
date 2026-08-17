-- Collections kategorisinin dördüncü ve SON topic'i: `queues-collections-utility`
-- (sort_order=4, maps'ten sonra). Bu, planlanan 4 topic'in sonuncusu -- bu
-- migration'la birlikte `collections` kategorisi TAMAMLANIYOR (4/4).
--
-- Kapsam: `Queue`/`Deque` arayüzleri (iki paralel metot ailesi -- istisna fırlatan
-- add()/remove()/element() vs. özel değer dönen offer()/poll()/peek()),
-- `ArrayDeque` (hem Deque hem stack olarak, `java.util.Stack`'e tercih edilen
-- resmi öneri), `PriorityQueue` (heap tabanlı, toString()'in SIRALI OLMADIĞI
-- gerçek bir keşif), ve `Collections` yardımcı sınıfı (sort/reverse/shuffle/max/
-- min/frequency/binarySearch + factory metotları).
--
-- Queue/Deque ve Collections utility, "Primitive & Parallel Streams" dersinde
-- uygulanan aynı gerekçeyle (kısa, bağımsız alt konuları tek bir topic'te
-- birleştirmek) tek bir topic'te toplandı.
--
-- GERÇEK ÖLÇÜM (bu kategori de saf JDK, sandbox-compile sürecine devam ediliyor):
-- ArrayDequeVsLinkedListPerformanceExample.java, 5 milyon offer()+poll() çiftinde
-- ArrayDeque'ı LinkedList'e karşı ölçüyor. Sonuç: ArrayDeque çoğu çalıştırmada
-- belirgin şekilde daha hızlı (örn. ~40ms'ye karşı ~55-60ms), ama fark her
-- çalıştırmada aynı oranda değil -- bu, LinkedList'in her eleman için ayrı bir
-- node nesnesi tahsis etmesinin garbage collector üzerinde değişken bir baskı
-- yaratmasıyla tutarlı. ArrayDeque hiçbir çalıştırmada daha yavaş ölçülmedi.
-- Ayrıca PriorityQueueExample.java'da gerçek bir keşif: doğrudan
-- System.out.println(pq) çıktısı [10, 20, 40, 50, 30] -- SIRALI DEĞİL, yalnızca
-- heap invariant'ı (kök = en küçük) geçerli; sıralı çıktı için tekrar tekrar
-- poll() çağırmak gerekiyor.
--
-- BEGINNER zorlukta -- `lists`/`sets`/`maps` ile aynı seviye.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'queues-collections-utility', 'BEGINNER', 20, 4
FROM category
WHERE slug = 'collections';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Queues & Collections Utility',
       'Collections kategorisinin son topic''i: `Queue`/`Deque` arayüzleri (offer()/poll()/peek() vs add()/remove()/element()), `ArrayDeque`''ın hem kuyruk hem stack olarak `LinkedList`/`java.util.Stack`''a tercih edilmesi, `PriorityQueue`''nun heap tabanlı ve toString()''inin sıralı OLMADIĞI gerçek bir keşif, ve `Collections` yardımcı sınıfının sort/shuffle/max/binarySearch gibi statik metotları.',
       'Java Queue, Deque ve Collections Sınıfı Nedir? Örneklerle Anlatım',
       'Java''nın `Queue` ve `Deque` arayüzleri, offer()/poll()/peek() ile add()/remove()/element() arasındaki fark; `ArrayDeque`''ın hem kuyruk hem stack olarak neden `LinkedList` ve `java.util.Stack`''a tercih edildiği; `PriorityQueue`''nun heap tabanlı yapısı ve toString()''inin neden sıralı olmadığı; ve `Collections` yardımcı sınıfının sort()/shuffle()/binarySearch() gibi statik metotları gerçek ölçümlerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'queues-collections-utility';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Queues & Collections Utility',
       'The final topic in the Collections category: the `Queue`/`Deque` interfaces (offer()/poll()/peek() vs add()/remove()/element()), why `ArrayDeque` is preferred over `LinkedList`/`java.util.Stack` as both a queue and a stack, a real discovery that `PriorityQueue` is heap-based and its toString() is NOT sorted, and the `Collections` utility class''s static methods like sort/shuffle/max/binarySearch.',
       'What Are Java Queue, Deque, and the Collections Class? Explained with Examples',
       'Java''s `Queue` and `Deque` interfaces, the difference between offer()/poll()/peek() and add()/remove()/element(); why `ArrayDeque` is preferred over `LinkedList` and `java.util.Stack` as both a queue and a stack; `PriorityQueue`''s heap-based structure and why its toString() isn''t sorted; and the `Collections` utility class''s static methods like sort()/shuffle()/binarySearch(), explained with real measurements.',
       false
FROM topic
WHERE slug = 'queues-collections-utility';
