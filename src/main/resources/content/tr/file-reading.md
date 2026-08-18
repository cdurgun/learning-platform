# File Reading

Java Basics kategorisinin altıncı konusu File I/O -- iki topic'e bölündü: bu topic OKUMA (`File Reading`), bir sonraki topic ise YAZMA (`File Writing`) tarafını kapsıyor. Bu ayrım, `functional-interfaces-streams` ve `collections` kategorilerinde uygulanan "kısa, bağımsız alt konuları TEK topic'te birleştirme" pratiğinin tam tersi bir karar -- burada tersine, tek bir konu (File I/O) YETERİNCE GENİŞ olduğu için iki topic'e AYRILDI.

## File I/O Nedir?

File I/O (dosya girdi/çıktı), bir programın diskteki dosyalarla -- okuma, yazma, kopyalama, silme -- etkileşime girmesidir. Java'da bu iş için İKİ farklı API bir arada kullanılır: eski `java.io` paketi (`FileReader`, `BufferedReader`, `FileWriter`, `BufferedWriter` gibi AKIŞ (stream) tabanlı sınıflar) ve modern `java.nio.file` paketi (`Path`, `Files` gibi YOL (path) tabanlı, çoğu işlemi tek satırlık statik metotlara indirgeyen sınıflar).

## Neden Var?

Bir program, kalıcı veri okumadan/yazmadan gerçek dünyada pek işe yaramaz -- log dosyaları, yapılandırma dosyaları, CSV raporları, kullanıcı tarafından yüklenen belgeler, hepsi File I/O gerektirir. `java.nio.file` (NIO.2), eski `java.io`'nun bazı can sıkıcı yönlerini (checked exception yönetiminin karmaşıklığı, sembolik bağlantı desteğinin eksikliği, dosya sistemi meta verisine erişimin zorluğu) çözmek için tasarlandı -- ama `java.io`'nun `BufferedReader` gibi bazı sınıfları hâlâ yaygın kullanılıyor, özellikle satır satır işleme gerektiren durumlarda.

## Tarihçe

`java.io` paketi Java'nın 1.0 sürümünden (1996) beri var -- akış tabanlı (stream-based) klasik model. `java.nio` (Non-blocking I/O), Java 1.4 (2002) ile geldi ama asıl dosya sistemi API'si olan `java.nio.file` (`Path`/`Files`, "NIO.2" olarak da bilinir) Java 7 (2011) ile eklendi -- daha okunabilir bir API, gerçek istisna tipleri (`NoSuchFileException` gibi), ve dosya sistemi işlemlerini (kopyalama, taşıma, sembolik bağlantı) doğrudan destekleyen statik metotlar sundu. Java 11 (2018), `Files.readString()`/`Files.writeString()` ile tüm dosyayı tek bir `String` olarak okuma/yazmayı daha da basitleştirdi.

## Path ve Files Temelleri

`Path.of(...)`, bir dosya konumunu TEMSİL EDEN bir nesne oluşturur -- ama DOSYA SİSTEMİNE dokunmaz, yalnızca bir "adres"tir. `Files.exists()` gibi metotlar gerçekten dosya sistemini kontrol eder. `Files.readAllLines(path)`, tüm dosyayı belleğe okuyup her satırı bir eleman olarak içeren bir `List<String>` döner -- küçük/orta boyutlu metin dosyaları için en basit okuma yoludur.

{{PathAndFilesBasicsExample.java}}

## BufferedReader ile Satır Satır Okuma

`BufferedReader`, klasik `java.io` yoludur -- bir `FileReader`'ı SARAR (wrap eder) ve okumaları içeride TAMPONLAR (buffer), bu da tek tek karakter okumaktan çok daha hızlıdır. `readLine()`, dosyanın sonuna gelindiğinde tam olarak BİR KEZ `null` döner -- bu, döngünün doğal bitiş koşuludur. `BufferedReader` gerçek bir dosya tanıtıcısı (file handle) tuttuğu için try-with-resources İÇİNDE kullanılmalıdır.

{{BufferedReaderExample.java}}

> 💡 Tip
> `while ((line = reader.readLine()) != null) { ... }` deseni, atama VE karşılaştırmayı tek bir ifadede birleştirir -- Java'da yaygın, idiomatik bir okuma döngüsü kalıbıdır.

## Satır Sayma: readAllLines() vs Files.lines()

Bir dosyadaki satır sayısını bulmanın iki yolu vardır: `Files.readAllLines(path).size()` (tüm dosyayı belleğe yükler, küçük dosyalar için sorunsuz) ya da `Files.lines(path).count()` (LAZY -- tembel -- bir `Stream<String>` döner, dosyayı TÜMÜYLE belleğe yüklemeden okur, çok büyük dosyalar için ölçeklenebilir).

{{FileReadingStreamAndCountExample.java}}

> ⚠️ Warning
> `Files.lines()`'ın döndürdüğü `Stream<String>`, altta gerçek bir dosya tanıtıcısı tutar -- yani bir `Scanner` ya da `BufferedReader` gibi KAPATILMASI (`close()`) gerekir. Bunu try-with-resources OLMADAN kullanmak (`Files.lines(path).count()` tek satırda) dosya tanıtıcısını sızdırır -- `Stream`'in `Closeable` olduğunu unutmak yaygın bir hatadır.

## Dosyada Kelime Arama

`Files.readAllLines()`'ı Stream API ile birleştirmek (bkz. "Stream Fundamentals" dersi), bir dosyada anahtar kelime aramayı tek satıra indirger: satırları FİLTRELE, yalnızca kelimeyi içerenleri tut.

{{SearchWordInFileExample.java}}

## Dosyanın Tamamını String Olarak Okumak

`Files.readString()` (Java 11+), TÜM dosyayı tek bir `String`'e okur -- satır sonları DAHİL. `Files.readAllLines()`'ın aksine (satır sonlarını atıp bir `List` döner), ham metnin kendisine ihtiyacınız olduğunda (örneğin bir JSON ayrıştırıcıya geçirmek ya da olduğu gibi göstermek için) `readString()` daha uygundur.

{{ReadFileAsStringExample.java}}

## İstisna Yönetimi: NoSuchFileException vs FileNotFoundException

Modern `java.nio.file` API'sinde (`Files.readString()`, `Files.readAllLines()` vb.) eksik bir dosya `NoSuchFileException` fırlatır -- klasik `java.io`'nun `FileNotFoundException`'ı DEĞİL. Bu ikisi, ikisi de `IOException`'ı genişletse de, BİRBİRİYLE İLİŞKİSİZ (sibling) istisna sınıflarıdır. `FileNotFoundException`, `FileReader`/`FileInputStream` gibi klasik `java.io` sınıflarından gelir.

{{FileReadingExceptionHandlingExample.java}}

> ⚠️ Warning
> `Files.readString()`/`Files.readAllLines()` için `catch (FileNotFoundException | NoSuchFileException e)` yazmak DERLENİR ama `FileNotFoundException` dalı BU ÇAĞRI İÇİN asla tetiklenmez -- çünkü `Files.*` metotları bu istisnayı hiç fırlatmaz, yalnızca `NoSuchFileException` fırlatır. Hangi API'yi (java.io mu, java.nio.file mi) kullandığınıza göre DOĞRU istisna tipini yakalamak önemlidir; emin değilseniz genel `IOException`'ı yakalamak her zaman güvenlidir.

## Best Practices

- **Küçük/orta boyutlu dosyalar için `Files.readAllLines()`/`Files.readString()` kullanın** -- tek satırlık, okunabilir bir API sunar; çok büyük dosyalar için `Files.lines()` (try-with-resources İÇİNDE) tercih edin.
- **`BufferedReader`/`Files.lines()` gibi dosya tanıtıcısı tutan her kaynağı try-with-resources İÇİNDE kullanın** -- kapatmayı unutmak kaynak sızıntısına yol açar.
- **`java.nio.file` API'si kullanıyorsanız `NoSuchFileException` yakalayın, `FileNotFoundException` DEĞİL** -- yanlış istisna tipini yakalamak, o dal hiçbir zaman tetiklenmediği için sessiz bir hataya yol açar.
- **Bir dosyada arama/filtreleme yaparken `Files.readAllLines().stream().filter(...)` desenini kullanın** -- okunabilir ve Stream API'nin gücünden yararlanır.

## Yaygın Hatalar

- **`Files.readString()`/`Files.readAllLines()` için `FileNotFoundException` yakalayıp hiçbir zaman tetiklenmediğini fark etmemek.** Bu API'ler `NoSuchFileException` fırlatır -- doğru istisna tipi yakalanmalı.
- **`Files.lines()`'ı try-with-resources olmadan kullanmak.** Döndürdüğü `Stream`, altta gerçek bir dosya tanıtıcısı tutar -- kapatılmazsa kaynak sızar.
- **Çok büyük bir dosyayı `Files.readAllLines()` ile okumaya çalışıp bellek taşması yaşamak.** Büyük dosyalar için `Files.lines()` (lazy) tercih edilmeli.
- **`BufferedReader`'ı kapatmayı unutmak.** try-with-resources kullanılmadığında, altındaki dosya tanıtıcısı açık kalır.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Java'da dosya okumak için iki API vardır: klasik `java.io` (`BufferedReader`+`FileReader`, satır satır okuma için) ve modern `java.nio.file` (`Path`+`Files`, `readAllLines()`/`readString()`/`lines()` ile çoğu işlemi tek satıra indirger). `Files.lines()` LAZY'dir ve `Closeable`'dır -- try-with-resources gerektirir. Eksik dosyalar için modern API `NoSuchFileException`, klasik API `FileNotFoundException` fırlatır -- bunlar İLİŞKİSİZ sınıflardır.

Hızlı referans:

```java
Path path = Path.of("data.txt");                          // yol oluşturma (dosyaya dokunmaz)
List<String> lines = Files.readAllLines(path);               // tüm dosyayı List olarak oku
String content = Files.readString(path);                       // tüm dosyayı tek String olarak oku

try (Stream<String> s = Files.lines(path)) {                      // LAZY, try-with-resources ŞART
    long count = s.count();
}

try (BufferedReader r = new BufferedReader(new FileReader(path.toFile()))) {  // klasik satır satır okuma
    String line;
    while ((line = r.readLine()) != null) { ... }
}

try { Files.readString(path); }
catch (NoSuchFileException e) { ... }                             // java.nio.file -- DOĞRU istisna
```

**Terimler Sözlüğü**

**Path** — Bir dosya konumunu temsil eden, dosya sistemine dokunmayan bir nesne (`java.nio.file.Path`).

**Files** — `java.nio.file` paketinin, dosya işlemleri için statik yardımcı metotlar sunan sınıfı.

**BufferedReader** — Bir okuma kaynağını (örn. `FileReader`) saran, okumaları tamponlayan klasik `java.io` sınıfı.

**NoSuchFileException** — `java.nio.file` API'sinin, eksik bir dosya için fırlattığı istisna (klasik `FileNotFoundException`'dan FARKLI bir sınıf).

**Try-with-Resources** — Bir kaynağın (dosya tanıtıcısı gibi) blok sonunda otomatik kapatılmasını garanti eden Java sözdizimi.
