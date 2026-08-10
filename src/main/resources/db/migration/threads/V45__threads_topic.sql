-- Faz 11: İlk "Concurrency" kategorisi konusu -- Threads. Buraya kadarki yedi konu
-- (Enum..Polymorphism) tek bir "Java Basics" kategorisindeydi; Concurrency, kendi
-- sort_order'ıyla (2, java-basics'ten sonra) ayrı bir kategori olarak açılıyor, çünkü
-- konu alanı köklü şekilde farklı (multithreading) ve zamanla birden fazla konuya
-- (Threads, Executor Framework/CompletableFuture, Modern Concurrency) bölünecek.
--
-- Threads, Thread/Runnable, lifecycle, thread metotları, daemon thread'ler, race
-- condition, synchronized, volatile, wait/notify, Atomic sınıflar, ReentrantLock ve
-- deadlock'u kapsıyor -- ExecutorService/CompletableFuture bilinçli olarak kapsam dışı,
-- ayrı bir sonraki Concurrency konusuna bırakıldı. Reflection gibi ADVANCED zorlukta.
-- Şimdilik yalnızca iskelet (kategori + topic + çeviriler) var -- estimated_minutes
-- buna göre düşük tutuldu, içerik önceki konularda yaptığımız gibi kademeli olarak
-- eklenecek.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Concurrency', 'concurrency', 2
FROM course
WHERE slug = 'java';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'threads', 'ADVANCED', 5, 1
FROM category
WHERE slug = 'concurrency';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Threads',
       'Java''da thread''ler; oluşturma (Thread/Runnable), lifecycle, thread metotları, race condition, synchronized, volatile, wait/notify, Atomic sınıflar, ReentrantLock ve deadlock.',
       'Java Threads (İş Parçacıkları) Nedir? | Örneklerle Anlatım',
       'Java''da multithreading; Thread ve Runnable ile thread oluşturma, thread lifecycle, start/join/sleep/interrupt, daemon thread''ler, race condition, synchronized, volatile, wait/notify/notifyAll, Atomic sınıflar, ReentrantLock ve deadlock gerçek dünya örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'threads';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Threads',
       'Threads in Java; creating threads (Thread/Runnable), the thread lifecycle, thread methods, race conditions, synchronized, volatile, wait/notify, Atomic classes, ReentrantLock, and deadlock.',
       'What Are Java Threads? | With Examples',
       'Learn Java multithreading: creating threads with Thread and Runnable, the thread lifecycle, start/join/sleep/interrupt, daemon threads, race conditions, synchronized, volatile, wait/notify/notifyAll, Atomic classes, ReentrantLock, and deadlock with real-world examples.',
       false
FROM topic
WHERE slug = 'threads';
