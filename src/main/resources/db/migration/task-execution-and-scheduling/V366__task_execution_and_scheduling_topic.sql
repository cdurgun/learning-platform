-- `advanced-spring` kategorisine, serinin 3.'sü ekleniyor: "task-execution-
-- and-scheduling" -- exception-handling'in (sort_order=2) hemen ardına,
-- sort_order=3. Kategori şu an iki topic içeriyor, sort_order kaydırması
-- gerekmiyor.
--
-- Kullanıcı, orijinal "Scheduling and Batch Jobs" fikrini İKİ ayrı topic'e
-- böldü: bu topic (Task Execution & Scheduling) ve ayrı bir "Spring Batch"
-- topic'i (henüz eklenmedi, kullanıcının açık talimatı gereği bu fazda
-- YOK). Kapsam (kullanıcının verdiği kesin alt başlıklar): Spring'de task
-- execution/scheduling'e giriş, arka plan işinin neden yararlı olduğu,
-- Spring'in TaskExecutor soyutlaması, thread pool'lar ve önemi, bir thread
-- pool'u yapılandırmak, @Async, @EnableAsync, @Async'in önemli kısıtları
-- (özellikle self-invocation/proxy davranışı), @Scheduled, fixed rate,
-- fixed delay, initial delay, cron ifadeleri, zamanlanmış görev çalışmasını
-- yapılandırmak, scheduling ile thread pool'lar arasındaki etkileşim,
-- pratik örnekler, best practices/yaygın hatalar.
--
-- İKİ gerçek çakışma önceden grep ile tespit edilip ÇAKIŞMAYACAK şekilde
-- işlendi: (1) `java` kursunun `concurrency` kategorisindeki "Threads"
-- (V45) zaten Thread/ExecutorService/thread pool'ları dil seviyesinde
-- kapsamlıca işliyor -- bu topic onu TEKRARLAMIYOR, yalnızca Spring'in
-- TaskExecutor'ının aynı ExecutorService mekanizmasını bean olarak
-- sardığını not edip "Threads"e gerçek migration başlığıyla referans
-- veriyor. (2) `spring-core`'daki "Transaction Management" (V82) zaten
-- @Transactional'ın proxy mekanizmasını VE self-invocation tuzağını
-- ayrıntılıca işliyor -- bu topic, @Async'in AYNI proxy mekanizmasını
-- kullandığını ve AYNI tuzağa sahip olduğunu "Transaction Management"a
-- gerçek migration başlığıyla referans vererek açıklıyor, proxy kavramını
-- baştan öğretmiyor.
--
-- ADVANCED zorlukta, java-bean-validation/exception-handling ile aynı
-- seviye. Format: kategorinin konvansiyonu -- "## Ek: Mini Proje" YOK
-- (kullanıcının açık talimatı: bu kategoriye şimdilik Pratik Proje
-- eklenmeyecek), estimated_minutes 7 örnek nedeniyle diğer iki topic'le
-- aynı yükseklikte tutuldu.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'task-execution-and-scheduling', 'ADVANCED', 35, 3
FROM category
WHERE slug = 'advanced-spring';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Task Execution & Scheduling',
       '"Threads"in dil seviyesinde işlediği thread pool temelinin üzerine inşa edilir -- Spring''in TaskExecutor soyutlaması, @Async ve @EnableAsync ile arka plan işi, self-invocation''ın @Async''i neden bozduğu ("Transaction Management"taki AYNI proxy tuzağı), @Scheduled ile fixed rate/fixed delay/initial delay/cron ifadeleri, ve scheduling''in kendi ayrı thread pool''unun (TaskScheduler) yapılandırılması. Advanced Spring serisinin 3.''sü.',
       'Spring Boot''ta Task Execution ve Scheduling',
       'Spring Boot''ta arka plan işi (@Async) ve zamanlanmış görevler (@Scheduled) -- thread pool yapılandırması, self-invocation tuzağı ve cron ifadeleri gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'task-execution-and-scheduling';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Task Execution & Scheduling',
       'Builds on the thread-pool foundation "Threads" covers at the language level -- Spring''s TaskExecutor abstraction, background work with @Async and @EnableAsync, why self-invocation breaks @Async (the SAME proxy pitfall as "Transaction Management"), scheduling with @Scheduled''s fixed rate/fixed delay/initial delay/cron expressions, and configuring scheduling''s own separate thread pool (TaskScheduler). The 3rd lesson in the Advanced Spring series.',
       'Task Execution and Scheduling in Spring Boot',
       'Background task execution (@Async) and scheduled tasks (@Scheduled) in Spring Boot -- thread pool configuration, the self-invocation pitfall, and cron expressions, explained with real examples.',
       false
FROM topic
WHERE slug = 'task-execution-and-scheduling';
