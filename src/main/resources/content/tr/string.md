# String

Java Basics kategorisinin ilk konusu `String` -- muhtemelen her Java programcısının ilk karşılaştığı sınıf. Basit görünse de, altında yatan IMMUTABLE (değişmez) tasarım, "string pool" adlı özel bir bellek optimizasyonu, ve `==` ile `equals()` arasındaki fark, yeni başlayanların en sık düştüğü tuzaklardan bazılarını barındırır.

## String Nedir?

`String`, `java.lang` paketinde tanımlı, bir karakter dizisini (sequence of characters) temsil eden bir sınıftır. Java'da string'ler bir `char[]` gibi ilkel (primitive) bir tip DEĞİL, tam teşekküllü bir NESNEdir -- ama dil, `String s = "merhaba";` gibi bir sözdizimiyle onu neredeyse ilkel bir tipmiş gibi kullanmayı mümkün kılar. En kritik özelliği: `String` nesneleri IMMUTABLE'dır (değişmezdir) -- bir kez oluşturulduktan sonra içeriği asla değişmez; "değiştiren" gibi görünen her metot (`toUpperCase()`, `substring()`, `replace()` vb.) aslında YENİ bir `String` nesnesi döner.

## Neden Var?

Metin işlemek -- kullanıcı girdisini okumak, bir dosya yolunu oluşturmak, bir hata mesajı yazdırmak -- neredeyse her programın temel bir ihtiyacıdır. `String`'in immutable olması bilinçli bir tasarım kararıdır: immutable nesneler THREAD-SAFE'tir (birden fazla thread aynı `String`'i güvenle paylaşabilir, çünkü kimse onu değiştiremez), `hashCode()` değeri bir kez hesaplanıp önbelleğe alınabilir (`HashMap` anahtarı olarak `String` kullanmak bu yüzden yaygın ve hızlıdır), ve JVM aynı metni tekrar tekrar farklı nesneler olarak saklamak yerine bir "string pool" ile paylaşabilir (bellek tasarrufu).

## Tarihçe

`String` sınıfı Java'nın 1.0 sürümünden (1996) beri var -- dilin en eski, en temel parçalarından biri. `String` pool (intern table) kavramı da baştan beri mevcuttu. Java 7 (2011), `substring()`'in eski implementasyonunu değiştirdi: eskiden bir `substring()` çağrısı ORİJİNAL karakter dizisini paylaşırdı (bellek tasarrufu ama gizli bellek sızıntısı riski taşırdı -- küçük bir substring, dev bir orijinal diziyi bellekte tutabilirdi); Java 7'den itibaren her `substring()` kendi bağımsız kopyasını oluşturur. Java 9 (2017), "Compact Strings" ile içeride yalnızca Latin-1 (tek byte) karakterler içeren string'leri `char[]` yerine `byte[]` olarak saklayarak bellek kullanımını azalttı. Java 11 (2018) `strip()`/`isBlank()`/`repeat()` gibi metotlar, Java 15 (2020) ise text block'lar (`"""`) ve `formatted()` metodunu ekledi.

## Temel Kullanım ve Immutability

`String` oluşturmanın en yaygın yolu bir LİTERAL (`"merhaba"` gibi) yazmaktır. Temel inceleme metotları arasında `length()`, `charAt()`, `substring()`, `indexOf()`, `contains()` bulunur. Kritik nokta: `toUpperCase()` gibi bir metodu çağırmak orijinal `String`'i DEĞİŞTİRMEZ -- yeni bir `String` döner, orijinali aynı kalır.

{{StringBasicsExample.java}}

> 💡 Tip
> Bir `String` metodunun dönüş değerini bir değişkene ATAMAZSANIZ, o çağrının hiçbir etkisi olmaz (`greeting.toUpperCase();` tek başına hiçbir şey yapmaz) -- bu, immutability ile ilgili en yaygın acemi hatalarından biridir.

## String Pool ve == vs equals()

Java, aynı metne sahip string LİTERALLERİNİ bir "string pool" içinde paylaşır -- iki ayrı `"merhaba"` literali aslında BELLEKTE AYNI nesnedir. Ama `new String(...)` ile oluşturulan bir string, pool'daki değerle aynı metne sahip olsa bile HER ZAMAN yeni, ayrı bir nesnedir. `==` operatörü nesne KİMLİĞİNİ (aynı bellek adresi mi) karşılaştırır, `equals()` ise İÇERİĞİ karşılaştırır -- bu ikisini karıştırmak, "bazen çalışan bazen çalışmayan" gizemli hatalara yol açar.

{{StringPoolAndEqualityExample.java}}

> ⚠️ Warning
> `==` ile string içeriği karşılaştırmak KLASİK bir hatadır -- bazı durumlarda (iki literal) tesadüfen doğru sonuç verir, ama `new String(...)` ya da runtime'da birleştirilmiş (concatenate edilmiş) bir string söz konusu olduğunda SESSİZCE yanlış sonuç üretir. İçerik karşılaştırması için HER ZAMAN `equals()` (ya da büyük/küçük harf duyarsız karşılaştırma için `equalsIgnoreCase()`) kullanın.

## String Birleştirme ve Performans

`+` operatörüyle string birleştirmek (concatenation) rahat okunur ama immutable olduğu için her `+=` çağrısı YENİ bir `String` nesnesi yaratır -- bir döngü içinde N kez tekrarlanan `result += "x"`, yaklaşık O(n²) toplam iş anlamına gelir (her adımda önceki tüm içerik yeniden kopyalanır). `StringBuilder`, TEK bir mutable (değişebilir) karakter dizisi tutarak bu maliyeti amortized O(1)'e indirir.

{{StringConcatenationPerformanceExample.java}}

Gerçek ölçüm (ısıtılmış -- her iki yol da ölçümden önce binlerce kez çalıştırıldı): 30.000 parçadan bir string oluştururken `+` operatörü döngü içinde tutarlı şekilde onlarca milisaniye sürdü (~63-80 ms arası, çalıştırmalar arasında değişti), `StringBuilder.append()` ise bu ölçekte ölçülemeyecek kadar hızlıydı (0 ms) -- beklenen O(n²)/O(n) farkını gerçek çalıştırmayla doğruladı.

## StringBuilder ile Mutable String Oluşturma

`StringBuilder`, `String`'in mutable (değişebilir) kardeşidir -- `append()`, `insert()`, `replace()`, `delete()`, `reverse()` gibi metotlar AYNI nesneyi yerinde değiştirir, yeni bir nesne döndürmez. Bir string'i parça parça, özellikle bir döngü içinde oluşturuyorsanız `StringBuilder` doğru araçtır; işiniz bittiğinde `toString()` ile immutable bir `String`'e dönüştürürsünüz.

{{StringBuilderExample.java}}

> 💡 Tip
> `StringBuffer`, `StringBuilder`'la birebir aynı API'ye sahiptir ama her metodu senkronizedir (thread-safe) -- Java 1.0'dan beri var, `StringBuilder` (Java 5) ise senkronizasyon YÜKÜ olmadan aynı işi yapar. Birden fazla thread'in AYNI builder nesnesini gerçekten paylaştığı nadir durumlar dışında `StringBuilder` tercih edilmelidir.

## Biçimlendirme: String.format() ve Text Block'lar

`String.format()` (ya da Java 15'in `formatted()` instance metodu), `%s`/`%d`/`%.2f` gibi yer tutucularla printf tarzı biçimlendirme sağlar. Text block'lar (`"""..."""`, Java 15+) çok satırlı string'leri (JSON, SQL, HTML gibi) her satır sonunda `\n` ve her tırnak işaretinde `\"` yazma zahmeti olmadan tanımlamayı sağlar.

{{StringFormattingExample.java}}

> ⚠️ Warning
> `String.format("%.2f", ...)` ondalık sayıyı YUVARLAR, kesmez -- yukarıdaki örnekte `19.999`, `%.2f` ile `"20.00"` olur (kesme değil, standart yuvarlama). Ayrıca text block'larda kapanış `"""` kendi satırında mı yoksa son metin satırının hemen ardında mı olduğu, sondaki satır sonunun (`\n`) dahil edilip edilmeyeceğini etkiler -- yukarıdaki örnekte iki metnin uzunluğu bu yüzden farklı çıktı (18'e karşı 17).

## Arama, Bölme ve Diğer Yardımcı Metotlar

`split()` bir string'i bir regex ayırıcıya göre parçalara böler, `String.join()` bunun tersini yapar (parçaları bir ayırıcıyla birleştirir). `replace()` bir alt dizinin TÜM geçtiği yerleri değiştirir (literal, regex değil); `replaceAll()`/`replaceFirst()` ise regex kullanır. `trim()` yalnızca ASCII boşlukları temizlerken, `strip()` (Java 11+) Unicode'a duyarlıdır ve artık genellikle tercih edilir.

{{StringSearchSplitExample.java}}

## Best Practices

- **String içeriğini karşılaştırırken her zaman `equals()`/`equalsIgnoreCase()` kullanın, asla `==` değil** -- `==` yalnızca nesne kimliğini karşılaştırır, bazı durumlarda tesadüfen doğru sonuç verse de güvenilir değildir.
- **Bir döngü içinde çok sayıda string birleştiriyorsanız `StringBuilder` kullanın**, `+`/`+=` değil -- `+` tek seferlik, kısa birleştirmeler için (derleyicinin optimize edebildiği) uygundur ama döngüde O(n²) maliyete yol açar.
- **`HashMap` anahtarı olarak `String` kullanmaktan çekinmeyin** -- immutability ve önbelleklenen `hashCode()` sayesinde bu güvenli ve hızlı bir kullanımdır.
- **Uzun, çok satırlı metinler (JSON, SQL, HTML) için text block (`"""`) kullanın** -- kaçış karakterleriyle (`\"`, `\n`) dolu tek satırlık string'lerden çok daha okunabilirdir.

## Yaygın Hatalar

- **`==` ile string içeriğini karşılaştırıp bazen doğru, bazen yanlış sonuç almak.** İki string literal'in `==` ile eşit çıkması bir tesadüftür (string pool sayesinde), genel bir kural değildir -- her zaman `equals()` kullanılmalı.
- **Bir `String` metodunun dönüş değerini bir değişkene atamayı unutmak.** `str.trim();` tek başına hiçbir şey yapmaz -- `str = str.trim();` gerekir, çünkü `String` immutable'dır.
- **Bir döngü içinde `+`/`+=` ile string biriktirmek.** Küçük ölçekte fark edilmez ama büyük döngülerde O(n²) maliyete yol açar -- `StringBuilder` kullanılmalı.
- **`String.format("%.2f", ...)`'in kesme yaptığını sanmak.** Aslında standart yuvarlama yapar (`19.999` → `"20.00"`), bu bazen beklenmedik sonuçlara yol açabilir.

## Özet, Cheat Sheet ve Terimler Sözlüğü

`String`, Java'da bir karakter dizisini temsil eden IMMUTABLE bir sınıftır -- her "değiştiren" metot aslında yeni bir `String` döner. JVM, string literallerini bir "string pool" ile paylaşır; bu yüzden `==` bazen (yanıltıcı biçimde) doğru sonuç verir, ama içerik karşılaştırması için her zaman `equals()` kullanılmalıdır. Sık string birleştirme gerektiren durumlarda `StringBuilder` tercih edilmelidir; biçimlendirme için `String.format()`/`formatted()` ve çok satırlı metinler için text block'lar kullanılabilir.

Hızlı referans:

```java
String a = "merhaba";                       // literal -- string pool'da paylaşılır
String b = new String("merhaba");             // her zaman yeni, ayrı bir nesne
a.equals(b);                                    // İÇERİK karşılaştırması -- true
a == b;                                           // KİMLİK karşılaştırması -- false

StringBuilder sb = new StringBuilder();             // mutable, döngüde birleştirme için
sb.append("x").append("y");

String.format("%s: %.2f", "toplam", 19.999);          // "toplam: 20.00" (yuvarlanır)

String multi = """
        çok satırlı
        metin""";                                        // text block (Java 15+)
```

**Terimler Sözlüğü**

**String** — Java'da bir karakter dizisini temsil eden immutable (değişmez) sınıf.

**Immutable** — Bir kez oluşturulduktan sonra içeriği asla değişmeyen; her "değiştiren" işlemin yeni bir nesne döndüğü tasarım.

**String Pool** — JVM'in aynı metne sahip string literallerini paylaşarak sakladığı özel bir bellek alanı (intern table).

**StringBuilder** — `String`'in mutable (değişebilir) kardeşi; parça parça string oluşturmak için kullanılır.

**Text Block** — Java 15 ile gelen, `"""` ile sınırlanan çok satırlı string literal sözdizimi.
