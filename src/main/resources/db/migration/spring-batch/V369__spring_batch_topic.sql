-- `advanced-spring` kategorisine, serinin 4. topic'i ekleniyor: "spring-batch"
-- -- task-execution-and-scheduling'in (sort_order=3) hemen ardına, sort_order=4.
-- Kategori şu an üç topic içeriyor, sort_order kaydırması gerekmiyor.
--
-- Kullanıcı, orijinal "Scheduling and Batch Jobs" fikrinin ikinci yarısını
-- (Faz 112'de "Task Execution & Scheduling"den ayrılmıştı) burada
-- tamamlıyor. Önceki üç Advanced Spring topic'inin aksine (mevcut Spring
-- bilgisinin üzerine "gap" materyali ekleyen), Spring Batch müfredata İLK
-- KEZ giren tamamen yeni bir teknoloji -- bu yüzden BİLİNÇLİ OLARAK daha
-- kapsamlı ve temellerden başlıyor, "Task Execution & Scheduling"in
-- (Faz 113'te pedagojik olarak revize edilmiş) aynı öğretim felsefesiyle:
-- önce gerçek sorun, sonra neden basit çözüm yetmiyor, sonra zihinsel
-- model, sonra TEK tutarlı bir çalışan örnek (CSV'den sipariş içe aktarma)
-- boyunca tekrar tekrar kullanılıyor, sonra soyutlamalar, sonra tam kod,
-- sonra hata/restart senaryosu, sonra @Scheduled'la pratik birleşim, sonra
-- best practices/cheat sheet -- kullanıcının verdiği kesin 19 maddelik
-- pedagojik spesifikasyon birebir işlendi.
--
-- Kapsam: gerçek sorun (500.000 kayıtlık gecelik batch, saf @Scheduled
-- neden yetmiyor, @Scheduled vs Spring Batch ayrımı), Job/Step/chunk-
-- odaklı işleme zihinsel modeli, TEK çalışan örnek (orders.csv → Order →
-- veritabanı), chunk işleme (commit sınırları, bellek, restart'ın neden
-- önemli olduğu -- kesin restart semantiği ABARTILMADAN), minimal tam
-- Job/Step yapılandırması (JobBuilder/StepBuilder), ItemReader/
-- ItemProcessor/ItemWriter (processor'dan null dönmenin filtreleme
-- anlamına geldiği), JobParameters/JobInstance/JobExecution/StepExecution
-- ayrımı, JobRepository (neden var, düz bir while döngüsünden farkı),
-- step başarısızlığı, skip/retry fault tolerance (yalnızca temel model
-- oturduktan SONRA), @Scheduled ile Spring Batch'i birleştirmek (JobLauncher),
-- @Async vs @Scheduled vs Spring Batch üç yönlü karşılaştırma, uçtan uca
-- örnek, "Spring Batch ne DEĞİLDİR" bölümü, best practices, yaygın hatalar.
-- Partitioning/remote chunking/paralel step'ler/async processor'lar
-- BİLİNÇLİ OLARAK yalnızca "ileri seviye, bu derste öğretilmiyor" diye
-- İSİMLENDİRİLDİ, derinlemesine işlenmedi (kullanıcının açık talimatı).
--
-- "Threads"e (java kursu) ve "Task Execution & Scheduling"e (bu kategori)
-- gerçek migration başlıklarıyla doğrulanmış referanslar veriliyor --
-- thread pool/ExecutorService temelleri VE @Scheduled/@Async mekaniği
-- TEKRAR ÖĞRETİLMEDİ.
--
-- Örnek dosyaları (4, "Task Execution & Scheduling"in 7'sinden az --
-- kullanıcının AÇIK talimatı: "her API için ilgisiz oyuncak örnekler
-- yaratma, TEK tutarlı bir örnek kullan") gerçek Spring Batch 5 API'sini
-- (JobBuilder/StepBuilder, FlatFileItemReaderBuilder,
-- JdbcBatchItemWriterBuilder) kullanıyor, ama `microservices` kategorisinin
-- Kafka/Eureka örnekleriyle AYNI kısıtla: `spring-boot-starter-batch`
-- projenin pom.xml'inde bir bağımlılık DEĞİL (kod dikkatle, doğrulanmış
-- API şekillerine dayanarak elle yazıldı, gerçek `mvn compile` bu dosyalar
-- için uygulanamaz -- örnek dosyaları zaten `src/main/resources/examples/`
-- altında, Maven derlemesinin bir parçası değil, bu proje genelinde HER
-- Spring örneği için geçerli bir durum).
--
-- ADVANCED zorlukta, kategorinin diğer topic'leriyle aynı seviye. Format:
-- "## Ek: Mini Proje" YOK (kullanıcının açık talimatı: bu kategoriye
-- şimdilik Pratik Proje eklenmeyecek), estimated_minutes konunun
-- olağanüstü genişliği nedeniyle kategorinin diğer topic'lerinden (35dk)
-- yüksek tutuldu.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'spring-batch', 'ADVANCED', 50, 4
FROM category
WHERE slug = 'advanced-spring';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Spring Batch',
       'Neden büyük ölçekli batch işlemlerinin `@Scheduled`''ın tek başına sağlayamadığı bir yapıya ihtiyacı olduğu -- Job/Step/chunk-odaklı işleme zihinsel modeli, tek bir CSV-''den-veritabanına sipariş içe aktarma örneği boyunca ItemReader/ItemProcessor/ItemWriter, JobParameters/JobInstance/JobExecution ayrımı, JobRepository ile yeniden başlatılabilirlik, skip/retry fault tolerance, ve `@Scheduled` ile pratik birleşim. Advanced Spring serisinin 4.''sü.',
       'Spring Batch''e Giriş: Job, Step ve Chunk İşleme',
       'Spring Batch''in temelleri -- Job/Step/chunk-odaklı işleme, ItemReader/ItemProcessor/ItemWriter, JobParameters/JobInstance/JobExecution, ve yeniden başlatılabilirlik gerçek bir CSV içe aktarma örneğiyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'spring-batch';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Spring Batch',
       'Why large-scale batch processing needs a structure `@Scheduled` alone can''t provide -- the Job/Step/chunk-oriented processing mental model, ItemReader/ItemProcessor/ItemWriter through a single CSV-to-database order import example, the JobParameters/JobInstance/JobExecution distinction, restartability via the JobRepository, skip/retry fault tolerance, and practical integration with `@Scheduled`. The 4th lesson in the Advanced Spring series.',
       'Introduction to Spring Batch: Job, Step, and Chunk Processing',
       'The fundamentals of Spring Batch -- Job/Step/chunk-oriented processing, ItemReader/ItemProcessor/ItemWriter, JobParameters/JobInstance/JobExecution, and restartability, explained with a real CSV import example.',
       false
FROM topic
WHERE slug = 'spring-batch';
