# File Writing

Java Basics kategorisinin yedinci konusu File I/O'nun YAZMA yarısı -- "File Reading" dersinin doğrudan devamı. O derste dosyaları okumanın iki yolunu (`java.nio.file.Files` ve klasik `java.io.BufferedReader`) gördük; burada aynı iki API ailesiyle dosyalara YAZMAYI, dosyaları KOPYALAMAYI, ve dizinleri YÖNETMEYİ ele alıyoruz.

## File Writing Nedir?

Dosyaya yazmak, "File Reading" dersindeki okuma API'lerinin ayna görüntüsüdür: `Files.writeString()`/`Files.write()` (modern, `java.nio.file`) ve `BufferedWriter`+`FileWriter` (klasik, `java.io`, try-with-resources ile). Ek olarak bu ders, tek bir dosyaya yazmanın ötesine geçerek dosya KOPYALAMA (`Files.copy()`) ve dizin OLUŞTURMA/SİLME (`Files.createDirectories()`, `Files.walk()`) konularını da kapsıyor.

## Neden Var?

Bir programın sonuçlarını KALICI hale getirmesi -- bir rapor üretmek, bir log dosyası tutmak, bir yapılandırmayı kaydetmek, bir kullanıcı yüklemesini diske yazmak -- File Writing gerektirir. Modern `Files.writeString()`/`Files.write()` metotları, eski `java.io`'nun gerektirdiği "akış aç → yaz → akışı kapat" ritüelini TEK BİR statik metot çağrısına indirger; ama `BufferedWriter` gibi klasik sınıflar, özellikle çok sayıda küçük yazma işlemini VERİMLİ bir şekilde biriktirmek gerektiğinde hâlâ tercih edilir.

## Tarihçe

"File Reading" dersindeki tarihçenin AYNISI burada da geçerlidir: `java.io` (`FileWriter`/`BufferedWriter`) Java 1.0'dan (1996) beri var, `java.nio.file` (`Path`/`Files`) Java 7 (2011) ile geldi. `Files.writeString()` Java 11 (2018) ile eklendi -- ondan önce, tek bir `String`'i bir dosyaya yazmak için `Files.write(path, content.getBytes())` gibi bir dönüştürme adımı gerekiyordu.

## Files.writeString(): Oluşturma ve Üzerine Yazma

`Files.writeString(path, içerik)`, en basit yazma yoludur -- dosya yoksa OLUŞTURUR, varsa TAMAMEN ÜZERİNE YAZAR (üzerine yazma, biriktirme değil). Aynı dosyaya art arda iki kez çağırmak, yalnızca İKİNCİ çağrının içeriğini bırakır.

{{WriteStringExample.java}}

## Dosyaya Ekleme (Append)

Varsayılan davranış (üzerine yazma) yerine mevcut içeriğin SONUNA eklemek için `StandardOpenOption.APPEND` geçilir. Kritik bir nokta: `APPEND` TEK BAŞINA, dosyanın ZATEN VAR olduğunu varsayar -- henüz var olmayan bir dosyaya yalnızca `APPEND` ile yazmaya çalışmak `NoSuchFileException` fırlatır; dosyayı hem oluşturmak hem de eklemek istiyorsanız `StandardOpenOption.CREATE` İLE BİRLİKTE geçilmelidir.

{{AppendToFileExample.java}}

> ⚠️ Warning
> `Files.writeString(path, içerik, StandardOpenOption.APPEND)`'i henüz var olmayan bir dosya için çağırmak `NoSuchFileException` fırlatır -- `APPEND`, `CREATE`'i OTOMATİK OLARAK içermez. İkisini birlikte geçmek (`StandardOpenOption.CREATE, StandardOpenOption.APPEND`), dosya var olsun ya da olmasın güvenle çalışır.

## Bir Listeyi Satır Satır Yazmak

`Files.write(path, list)`, bir `List<String>` alır ve her elemanı KENDİ SATIRINA yazar -- satır sonu karakterlerini elle eklemekle (`String.join("\n", list)`) uğraşmaya gerek kalmaz.

{{WriteLinesExample.java}}

## BufferedWriter ile Yazma

`BufferedWriter`, `BufferedReader`'ın (bkz. "File Reading" dersi) yazma karşılığıdır -- bir `FileWriter`'ı sarar, yazmaları içeride tamponlar. `write()` KENDİ BAŞINA bir satır sonu EKLEMEZ -- bunun için açıkça `newLine()` çağrılmalıdır (platforma doğru satır sonunu kullanır: Linux/macOS'ta `\n`, Windows'ta `\r\n`).

{{BufferedWriterExample.java}}

> 💡 Tip
> Son satırdan sonra `newLine()` çağırıp çağırmamak SİZİN kararınızdır -- yukarıdaki örnekte üçüncü satırdan sonra `newLine()` ÇAĞRILMADI, bu yüzden dosya `"Line 3"`'ten hemen sonra, satır sonu OLMADAN biter.

## Dosya Kopyalama ve Dizin Yönetimi

`Files.createDirectories()`, bir dizini VE yoldaki tüm eksik üst dizinleri oluşturur (`mkdir -p` gibi) -- dizin zaten varsa hata VERMEZ. `Files.copy()` bir dosyanın içeriğini tek çağrıda kopyalar -- ama VARSAYILAN olarak hedef zaten varsa `FileAlreadyExistsException` fırlatır; `StandardCopyOption.REPLACE_EXISTING` bunun yerine üzerine yazmayı sağlar. Bir dizin ağacını TAMAMEN silmek için önce onu GEZMEK (`Files.walk()`) ve EN DERİNDEKİ (dosyalar, sonra alt dizinler) girişlerden başlayarak silmek gerekir -- boş olmayan bir dizin doğrudan silinemez.

{{CopyAndDirectoryExample.java}}

> ⚠️ Warning
> `Files.walk(dizin).sorted(Comparator.reverseOrder()).forEach(Files::delete)` deseni, bir dizin ağacını silmenin STANDART yoludur -- `reverseOrder()` KRİTİKTİR, çünkü bir dizin, İÇİNDEKİ dosyalar/alt dizinler silinmeden silinemez. `Comparator.reverseOrder()` olmadan (doğal, sığdan derine sıralamayla) silme denemesi, boş olmayan dizinler için istisna fırlatır.

## CSV Dosyası Yazmak

Yapılandırılmış bir metin dosyası (CSV gibi) yazmak, string birleştirme temellerini (bkz. "String" dersi) File I/O ile birleştirir: `String.join(",", dizi)` her satırı oluşturur, tüm satırlar bir `StringBuilder`'da toplanır, ve TEK bir `Files.writeString()` çağrısıyla diske yazılır -- her satır için ayrı bir yazma çağrısı yapmaktan daha VERİMLİDİR.

{{WriteCsvExample.java}}

## Best Practices

- **Tek seferlik, basit yazmalar için `Files.writeString()`/`Files.write()` kullanın** -- kısa ve okunabilir; çok sayıda küçük yazma biriktiriyorsanız `BufferedWriter` tercih edin.
- **`APPEND` kullanırken dosyanın var olup olmadığından emin değilseniz `StandardOpenOption.CREATE`'i de birlikte geçin** -- yalnızca `APPEND`, dosya yoksa `NoSuchFileException` fırlatır.
- **`Files.copy()` çağırırken hedefin üzerine yazılmasını istiyorsanız her zaman `StandardCopyOption.REPLACE_EXISTING` ekleyin** -- aksi halde hedef zaten varsa istisna alırsınız.
- **Bir dizin ağacını silerken `Files.walk().sorted(Comparator.reverseOrder())` desenini kullanın** -- doğal sırayla silmeye çalışmak boş olmayan dizinlerde başarısız olur.

## Yaygın Hatalar

- **`StandardOpenOption.APPEND`'i henüz var olmayan bir dosyada kullanıp `NoSuchFileException` almak.** `CREATE`'i de birlikte geçmek gerekir.
- **`Files.copy()`'yi `REPLACE_EXISTING` olmadan çağırıp hedef zaten varken `FileAlreadyExistsException` almak.** Üzerine yazma isteniyorsa bu seçenek eklenmeli.
- **Bir dizin ağacını doğal sırayla (sığdan derine) silmeye çalışıp boş olmayan dizin hatası almak.** `Comparator.reverseOrder()` ile derinden sığa doğru silinmeli.
- **`BufferedWriter.write()`'ın otomatik satır sonu ekleyeceğini varsaymak.** `write()` yalnızca metni yazar -- satır sonu için ayrıca `newLine()` çağrılmalı.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Dosyaya yazmak için de iki API vardır: modern `Files.writeString()`/`Files.write()` (tek satırlık, `StandardOpenOption` ile davranışı özelleştirilebilir) ve klasik `BufferedWriter`+`FileWriter` (satır satır yazma, `newLine()` ile açık satır sonu kontrolü). `Files.copy()` dosya kopyalar (`REPLACE_EXISTING` gerekebilir), `Files.createDirectories()` dizin oluşturur, ve bir dizin ağacını silmek `Files.walk()` + ters sıralama gerektirir.

Hızlı referans:

```java
Files.writeString(path, "content");                                // oluştur/üzerine yaz
Files.writeString(path, "\nmore", StandardOpenOption.APPEND);         // sona ekle (dosya VAR olmalı)
Files.writeString(path, "content",
        StandardOpenOption.CREATE, StandardOpenOption.APPEND);          // yoksa oluştur + ekle
Files.write(path, listOfStrings);                                         // List<String> -> satır satır

try (BufferedWriter w = new BufferedWriter(new FileWriter(path.toFile()))) {  // klasik yazma
    w.write("line");
    w.newLine();                                                                // AÇIKÇA satır sonu
}

Files.createDirectories(dirPath);                                            // dizin (+ üst dizinler)
Files.copy(source, dest, StandardCopyOption.REPLACE_EXISTING);                 // kopyala, üzerine yaz

Files.walk(dirPath)
    .sorted(Comparator.reverseOrder())                                          // derinden sığa
    .forEach(p -> { try { Files.delete(p); } catch (IOException e) {} });         // ağacı sil
```

**Terimler Sözlüğü**

**BufferedWriter** — Bir yazma hedefini (örn. `FileWriter`) saran, yazmaları tamponlayan klasik `java.io` sınıfı.

**StandardOpenOption** — `Files.writeString()`/`Files.write()`'ın davranışını (üzerine yazma, ekleme, oluşturma) özelleştiren enum (`APPEND`, `CREATE` vb.).

**StandardCopyOption** — `Files.copy()`'nin davranışını özelleştiren enum (örn. `REPLACE_EXISTING`).

**Files.walk()** — Bir dizin ağacındaki TÜM dosya/alt dizinleri gezen, bir `Stream<Path>` döndüren metot.

**FileAlreadyExistsException** — `Files.copy()` gibi bir metot, üzerine yazma izni verilmeden ZATEN VAR olan bir hedefe yazmaya çalıştığında fırlatılan istisna.
