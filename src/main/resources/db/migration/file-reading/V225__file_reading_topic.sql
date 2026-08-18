-- java-basics kategorisine yeni bir topic: `file-reading`. Kullanıcı isteğiyle
-- ("Evet file konusuna devam edelim... Eğer çok uzun olacaksa 2 topic'e
-- bölebilirsin") File I/O konusu OKUMA ve YAZMA olarak İKİYE bölündü -- bu,
-- `file-reading` topic'i, `wrapper-classes`'ten (Faz 59) sonraki beşinci konu
-- olarak ekleniyor. sort_order=5, mevcut enum/records/reflection/date-time
-- topic'leri yine bir kaydırılıyor (5,6,7,8 -> 6,7,8,9). Faz 51/56/57/58/59'da
-- kullanılan aynı "sort_order kaydırma" deseni burada da uygulanıyor.
--
-- Kullanıcı, kendi eğitim setinden iki Java alıştırma dosyası
-- (FileReading.java, FileWriting.java, com.amigoscode._2_developers._11_files
-- paketinden) paylaşıp bu dosyalarda geçen TÜM File I/O komutlarına mutlaka
-- yer verilmesini istedi. Bu topic (`file-reading`), FileReading.java'daki
-- TÜM metotları kapsıyor: Files.readAllLines(), BufferedReader+FileReader
-- (try-with-resources), satır sayma (Files.readAllLines().size() VE
-- Files.lines().count()), Files.readAllLines().stream().filter() ile kelime
-- arama, Files.readString(), ve FileNotFoundException/NoSuchFileException/
-- IOException istisna yönetimi.
--
-- Kapsam ayrıca genişletildi: java.io vs java.nio.file (NIO.2) tarihçesi,
-- Path.of()/Files.exists() temelleri, ve Files.lines()'ın LAZY + Closeable
-- olduğu (try-with-resources gerektirdiği) detayı.
--
-- GERÇEK KEŞİF (bu topic de saf JDK, sandbox-compile sürecine devam ediliyor):
-- FileReadingExceptionHandlingExample.java, Files.readString()'in eksik bir
-- dosya için GERÇEKTEN NoSuchFileException fırlattığını (FileNotFoundException
-- DEĞİL) canlı çalıştırmayla kanıtladı -- ve `catch (FileNotFoundException |
-- NoSuchFileException e)` yazıldığında FileNotFoundException dalının hiçbir
-- zaman tetiklenmediğini doğruladı (kullanıcının orijinal alıştırma kodundaki
-- tam bu multi-catch deseni test edilerek). Ayrıca FileNotFoundException'ın
-- gerçekten `FileReader`'dan (klasik java.io) geldiği ayrıca doğrulandı.
--
-- BEGINNER zorlukta -- `string`/`arrays`/`scanner`/`wrapper-classes` ile aynı
-- seviye.

-- Mevcut java-basics topic'lerinden wrapper-classes'ten sonrakileri bir
-- kaydır (file-reading'e yer aç -- yalnızca sort_order >= 5 olanlar,
-- string=1/arrays=2/scanner=3/wrapper-classes=4 sabit kalır).
UPDATE topic
SET sort_order = sort_order + 1
WHERE category_id = (SELECT id FROM category WHERE slug = 'java-basics')
  AND sort_order >= 5;

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'file-reading', 'BEGINNER', 20, 5
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'File Reading',
       'Java Basics kategorisinin beşinci topic''i (File I/O''nun okuma yarısı): `Path`/`Files` temelleri, `Files.readAllLines()`/`Files.readString()`, `BufferedReader` ile satır satır okuma, `Files.lines()`''in lazy ve Closeable olması, dosyada kelime arama, ve `NoSuchFileException` ile `FileNotFoundException` arasındaki gerçek fark.',
       'Java Dosya Okuma (File Reading) Nedir? Files ve BufferedReader Örnekleri',
       'Java''da dosya okumanın iki yolu -- `java.nio.file.Files` (`readAllLines()`, `readString()`, `lines()`) ve klasik `java.io.BufferedReader` -- ve `NoSuchFileException`''in `FileNotFoundException`''dan neden farklı bir sınıf olduğu gerçek bir örnekle anlatılıyor.',
       true
FROM topic
WHERE slug = 'file-reading';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'File Reading',
       'The fifth topic in the Java Basics category (the reading half of File I/O): `Path`/`Files` basics, `Files.readAllLines()`/`Files.readString()`, line-by-line reading with `BufferedReader`, `Files.lines()` being lazy and Closeable, searching a file for a word, and the real difference between `NoSuchFileException` and `FileNotFoundException`.',
       'What Is Java File Reading? Files and BufferedReader Examples',
       'Two ways to read files in Java -- `java.nio.file.Files` (`readAllLines()`, `readString()`, `lines()`) and the classic `java.io.BufferedReader` -- and why `NoSuchFileException` is a different class from `FileNotFoundException`, explained with a real example.',
       false
FROM topic
WHERE slug = 'file-reading';
