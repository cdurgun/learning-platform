-- java-basics kategorisine yeni bir topic: `scanner`. Kullanıcı isteğiyle
-- ("Scanner la devam edebilirsin?") Arrays'ten (Faz 57) sonraki üçüncü konu
-- olarak ekleniyor -- sort_order=3, mevcut enum/records/reflection/date-time
-- topic'leri yine bir kaydırılıyor (3,4,5,6 -> 4,5,6,7). Faz 51/56/57'de
-- kullanılan aynı "sort_order kaydırma" deseni burada da uygulanıyor.
--
-- Kapsam: `Scanner`'ın token tabanlı okuma modeli (next()/nextInt()/
-- nextDouble()), klasik `nextInt()` + `nextLine()` tuzağı (nextInt()'in
-- ardından gelen satır sonunu tüketmemesi), `useDelimiter()` ile özel
-- ayırıcılar, `File` üzerinden okuma (try-with-resources), `Scanner` ile
-- `BufferedReader` arasındaki gerçek bir performans farkı, ve
-- `InputMismatchException`/`NoSuchElementException` istisna yönetimi.
--
-- GERÇEK DOĞRULAMA (bu topic de saf JDK, sandbox-compile sürecine devam
-- ediliyor): ScannerNextIntNextLinePitfallExample.java, simüle edilmiş bir
-- konsol girdisiyle (ByteArrayInputStream), nextInt()'ten hemen sonra gelen
-- nextLine()'ın gerçekten BOŞ bir string döndürdüğünü canlı çalıştırmayla
-- kanıtladı -- ve fazladan bir nextLine() ile düzeltildiğini gösterdi.
--
-- GERÇEK ÖLÇÜM: ScannerVsBufferedReaderPerformanceExample.java, ısıtılmış bir
-- ölçümle (50 tur ısıtma sonrası) 50.000 satırlık bir metni okurken
-- Scanner.nextLine()'ı BufferedReader.readLine()'a karşı ölçtü -- Scanner
-- tutarlı şekilde ~6 ms, BufferedReader ~1 ms sürdü (birden fazla çalıştırmada
-- tutarlı çıktı).
--
-- BEGINNER zorlukta -- `string`/`arrays`/`enum` ile aynı seviye.

-- Mevcut java-basics topic'lerinden arrays'ten sonrakileri bir kaydır
-- (Scanner'a yer aç -- yalnızca sort_order >= 3 olanlar, string=1 ve
-- arrays=2 sabit kalır).
UPDATE topic
SET sort_order = sort_order + 1
WHERE category_id = (SELECT id FROM category WHERE slug = 'java-basics')
  AND sort_order >= 3;

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'scanner', 'BEGINNER', 20, 3
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Scanner',
       'Java Basics kategorisinin üçüncü topic''i: `Scanner`''ın token tabanlı okuma modeli, klasik `nextInt()` + `nextLine()` tuzağı, `useDelimiter()` ile özel ayırıcılar, `File` üzerinden okuma, `Scanner` ile `BufferedReader` arasındaki gerçek bir performans farkı, ve `InputMismatchException`/`NoSuchElementException` istisna yönetimi.',
       'Java Scanner Nedir? nextInt() ve nextLine() Tuzağı Örnekli Anlatım',
       'Java''nın `Scanner` sınıfı ile konsoldan/dosyadan okuma, `nextInt()`''ten sonra `nextLine()`''ın neden boş string döndürdüğü (klasik tuzak ve çözümü), `useDelimiter()` ile özel ayırıcılar, ve `Scanner`''ın `BufferedReader`''dan neden daha yavaş olduğu gerçek bir ölçümle anlatılıyor.',
       true
FROM topic
WHERE slug = 'scanner';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Scanner',
       'The third topic in the Java Basics category: `Scanner`''s token-based reading model, the classic `nextInt()` + `nextLine()` trap, custom delimiters via `useDelimiter()`, reading from a `File`, a real performance difference between `Scanner` and `BufferedReader`, and `InputMismatchException`/`NoSuchElementException` exception handling.',
       'What Is Java Scanner? The nextInt() and nextLine() Trap Explained',
       'Reading from the console/a file with Java''s `Scanner` class, why `nextLine()` returns an empty string right after `nextInt()` (the classic trap and its fix), custom delimiters via `useDelimiter()`, and why `Scanner` is slower than `BufferedReader`, shown with a real measurement.',
       false
FROM topic
WHERE slug = 'scanner';
