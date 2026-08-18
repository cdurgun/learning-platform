-- java-basics kategorisine yeni bir topic: `file-writing`. File I/O'nun ikinci
-- yarısı -- `file-reading`'den (Faz 60) hemen sonra altıncı konu olarak
-- ekleniyor. sort_order=6, mevcut enum/records/reflection/date-time topic'leri
-- yine bir kaydırılıyor (6,7,8,9 -> 7,8,9,10). Faz 51/56/57/58/59/60'ta
-- kullanılan aynı "sort_order kaydırma" deseni burada da uygulanıyor.
--
-- Kullanıcının paylaştığı FileWriting.java (com.amigoscode._2_developers.
-- _11_files paketinden) alıştırma dosyasındaki TÜM metotlar bu topic'te
-- kapsandı: Files.writeString() (oluştur/üzerine yaz), Files.writeString() +
-- StandardOpenOption.APPEND (sona ekleme), Files.write(path, List<String>)
-- (satır satır yazma), BufferedWriter+FileWriter (try-with-resources,
-- write()+newLine()), Files.copy() + StandardCopyOption.REPLACE_EXISTING
-- (dosya kopyalama), ve CSV yazma (String.join(",", array) ile).
--
-- Kapsam ayrıca genişletildi: Files.createDirectories() (dizin oluşturma), ve
-- kullanıcının orijinal main() metodundaki dizin temizleme deseni
-- (Files.walk().sorted(Comparator.reverseOrder()).forEach(delete)) ayrı bir
-- bölüm olarak ele alındı -- bu, bir dizin ağacını silmenin STANDART Java
-- deseni.
--
-- GERÇEK DOĞRULAMA (bu topic de saf JDK, sandbox-compile sürecine devam
-- ediliyor): AppendToFileExample.java yazılırken, StandardOpenOption.APPEND
-- TEK BAŞINA henüz var olmayan bir dosyada kullanıldığında GERÇEKTEN
-- NoSuchFileException fırlattığı ayrı bir test dosyasıyla doğrulandı (CREATE
-- ile birlikte kullanılınca sorunsuz çalıştığı da doğrulandı);
-- CopyAndDirectoryExample.java, Files.copy()'nin REPLACE_EXISTING olmadan
-- ikinci çağrıda gerçek bir FileAlreadyExistsException fırlattığını, ve
-- Files.walk()+reverseOrder() deseninin bir dizin ağacını (dosyalar dahil)
-- eksiksiz sildiğini canlı çalıştırmayla kanıtladı.
--
-- BEGINNER zorlukta -- `file-reading` ile aynı seviye. Bu, java-basics'e Faz
-- 56'dan beri eklenen 6. ve File I/O'nun 2. (son) topic'i.

-- Mevcut java-basics topic'lerinden file-reading'ten sonrakileri bir kaydır
-- (file-writing'e yer aç -- yalnızca sort_order >= 6 olanlar, string=1/
-- arrays=2/scanner=3/wrapper-classes=4/file-reading=5 sabit kalır).
UPDATE topic
SET sort_order = sort_order + 1
WHERE category_id = (SELECT id FROM category WHERE slug = 'java-basics')
  AND sort_order >= 6;

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'file-writing', 'BEGINNER', 20, 6
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'File Writing',
       'Java Basics kategorisinin altıncı topic''i (File I/O''nun yazma yarısı): `Files.writeString()`/`Files.write()`, `StandardOpenOption.APPEND` ile sona ekleme, `BufferedWriter` ile yazma, `Files.copy()` ile dosya kopyalama, `Files.createDirectories()`, bir dizin ağacını silmenin standart deseni, ve CSV dosyası yazma.',
       'Java Dosya Yazma (File Writing) Nedir? Files ve BufferedWriter Örnekleri',
       'Java''da dosyaya yazmanın iki yolu -- `java.nio.file.Files` (`writeString()`, `write()`, `copy()`) ve klasik `java.io.BufferedWriter` -- ve `StandardOpenOption.APPEND`''in neden tek başına `NoSuchFileException` fırlatabildiği gerçek bir örnekle anlatılıyor.',
       true
FROM topic
WHERE slug = 'file-writing';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'File Writing',
       'The sixth topic in the Java Basics category (the writing half of File I/O): `Files.writeString()`/`Files.write()`, appending with `StandardOpenOption.APPEND`, writing with `BufferedWriter`, copying files with `Files.copy()`, `Files.createDirectories()`, the standard pattern for deleting a directory tree, and writing a CSV file.',
       'What Is Java File Writing? Files and BufferedWriter Examples',
       'Two ways to write files in Java -- `java.nio.file.Files` (`writeString()`, `write()`, `copy()`) and the classic `java.io.BufferedWriter` -- and why `StandardOpenOption.APPEND` alone can throw `NoSuchFileException`, explained with a real example.',
       false
FROM topic
WHERE slug = 'file-writing';
