# Collectors

"Terminal Operations" dersinde `toList()`'i, `collect(Collectors.toList())`'in bir kısayolu olarak görmüştünüz -- ama `collect()`'in asıl gücüne hiç değinilmemişti. Bu ders tam olarak orada kalıyor: `Collectors` sınıfının sunduğu, gruplama, birleştirme ve dönüştürme için hazır tarifler.

## Collectors Nedir?

`Collectors`, `java.util.stream` paketindeki bir yardımcı (utility) sınıftır; `collect()` terminal operation'ına verilecek hazır `Collector` nesneleri üretir. `collect()`'in kendisi genel amaçlıdır -- "bu elemanları bir sonuca topla" der, ama **nasıl** toplanacağını `Collector`'a bırakır. `Collectors.toList()`, `Collectors.groupingBy()` gibi statik metotlar, en sık ihtiyaç duyulan "nasıl"ları hazır sağlar.

## Neden Var?

Bir stream'i basit bir listeye çevirmek `toList()` ile kolaydır (Terminal Operations dersi), ama "elemanları bir özelliğe göre grupla", "elemanları tek bir string'de birleştir", "elemanları iki gruba ayır" gibi ihtiyaçlar çok daha yaygındır ve elle yazılan bir `for` döngüsüyle epey kod gerektirir. `Collectors`, bu yaygın desenleri tek satırlık, isimlendirilmiş çağrılara indirger -- `groupingBy(...)` okuyan kişiye doğrudan "bu bir gruplama işlemi" der, döngü mantığını değil.

## Tarihçe

`Collectors` sınıfı, Stream API ile birlikte Java 8'de (2014) geldi. `collect()`'in kendisi de aynı zamanda tanıtıldı; ikisi birlikte tasarlandı çünkü `collect()`'in imzası doğrudan bir `Collector<T,A,R>` parametresi alır -- `Collectors` sınıfı olmadan her geliştirici kendi `Collector`'ını sıfırdan yazmak zorunda kalırdı.

## collect()'in Üç Bileşeni: Supplier, Accumulator, Combiner

Bir `Collector`, üç fonksiyondan oluşur: bir **supplier** (sonucu tutacak boş bir kap oluşturur, örneğin boş bir `ArrayList`), bir **accumulator** (her elemanı bu kaba ekler), ve bir **combiner** (paralel stream'lerde kısmi sonuçları birleştirir). `Collectors` sınıfındaki her statik metot, bu üçlüyü sizin için hazır kurar -- kendi `Collector`'ınızı sıfırdan yazmanız neredeyse hiç gerekmez.

## Collectors.toList() ve Collectors.toSet(): Basit Koleksiyonlar

`Collectors.toList()`, `Terminal Operations` dersindeki `Stream.toList()`'e çok benzer, ama önemli bir farkla: `collect(Collectors.toList())`'in döndürdüğü liste **değiştirilebilirdir** (mutable), `Stream.toList()`'inki ise değiştirilemezdir. `Collectors.toSet()`, elemanları bir `Set`'e toplar -- yinelenenler otomatik elenir, ama sıralama garantisi yoktur.

{{ToListToSetExample.java}}

## Collectors.joining(): String Birleştirme

`Collectors.joining()`, bir `String` stream'ini tek bir `String`'de birleştirir -- elle bir `StringBuilder` döngüsü yazmanın yerini alır. Üç aşırı yüklemesi vardır: argümansız (düz birleştirme), bir ayraç (delimiter) alan, ve bir ayraç ile bir önek/sonek (prefix/suffix) birlikte alan.

{{JoiningExample.java}}

## Collectors.groupingBy(): Elemanları Gruplamak

`Collectors.groupingBy(classifier)`, her elemandan bir `Function` ile bir anahtar (key) türetip, elemanları bu anahtara göre gruplar; sonuç bir `Map<K, List<T>>`'dir -- her farklı anahtar, o anahtarı üreten tüm elemanların listesine eşlenir.

{{GroupingByExample.java}}

## Downstream Collector'lar: counting() ve mapping()

`groupingBy()`, ikinci bir parametre olarak bir **downstream collector** kabul eder: varsayılan olarak her grup bir listeye toplanır, ama bir downstream collector verildiğinde, her grubun elemanlarına ne olacağına o karar verir. `Collectors.counting()`, her grubu doğrudan boyutuna indirger (`Map<K, Long>` üretir). `Collectors.mapping()`, her elemanı gruplanmadan **önce** dönüştürmenizi sağlar.

{{GroupingByDownstreamExample.java}}

## Collectors.partitioningBy(): İkiye Ayırma

`Collectors.partitioningBy(predicate)`, `groupingBy()`'ın özel bir halidir: elemanları bir `Predicate`'e göre tam olarak **iki** gruba (`true`/`false`) ayırır. `groupingBy()`'dan farklı olarak, sonuç `Map`'inde her iki anahtar da her zaman bulunur -- bir grup boş olsa bile, o anahtar boş bir liste ile birlikte haritada yer alır.

{{PartitioningByExample.java}}

## Collectors.toMap(): Anahtar-Değer Eşlemesi Oluşturmak

`Collectors.toMap(keyMapper, valueMapper)`, bir stream'den bir `Map` oluşturur. En sivri köşesi: iki farklı eleman **aynı anahtarı** üretirse, varsayılan olarak `IllegalStateException` fırlatır -- bazı dillerin eşdeğerlerindeki gibi otomatik bir "sonuncusu kazanır" davranışı yoktur. Üçüncü bir argüman, bir `BinaryOperator<V>`, bu çakışmayı açıkça nasıl çözeceğinizi belirtmenizi sağlar.

{{ToMapExample.java}}

## Best Practices

- **`collect(Collectors.toList())` ile `Stream.toList()` arasında bilinçli seçim yapın.** Sonuca eleman eklemeniz/çıkarmanız gerekiyorsa `Collectors.toList()` (mutable); yalnızca okuyacaksanız `Stream.toList()` (immutable, niyeti daha net ifade eder).
- **`toMap()`'in üç argümanlı halini, anahtar çakışması olasılığı varsa baştan kullanın** -- iki argümanlı hali production'da beklenmedik bir `IllegalStateException`'a yol açabilir.
- **`groupingBy()` + downstream collector zincirini, iç içe elle yazılmış bir döngüden tercih edin** -- `groupingBy(classifier, counting())` gibi bir satır, aynı işi yapan bir `Map<K, List<T>>` + ayrı bir sayma döngüsünden daha az hataya açıktır.
- **`partitioningBy()`'ı yalnızca gerçekten iki grup varken kullanın** -- ikiden fazla kategori için `groupingBy()` doğru araçtır.

## Yaygın Hatalar

- **`Collectors.toMap()`'i çakışan anahtarlarla, merge fonksiyonu olmadan kullanmak.** Veri her zaman benzersiz anahtarlar üretecekmiş gibi varsaymak, üretimde beklenmedik girdilerle `IllegalStateException`'a yol açar.
- **`collect(Collectors.toList())`'in döndürdüğü listenin immutable olduğunu sanmak.** Tam tersi doğru -- `Stream.toList()` immutable, `collect(Collectors.toList())` mutable'dır; bu iki API'yi karıştırmak beklenmeyen davranışlara yol açabilir.
- **`groupingBy()`'ın sonucundaki her anahtarın var olacağını varsaymak.** Yalnızca `partitioningBy()` bunu garanti eder; `groupingBy()`'da hiç elemanı olmayan bir anahtar haritada hiç yer almaz.
- **`joining()`'i `String` olmayan bir stream'de kullanmaya çalışmak.** `Collectors.joining()` yalnızca `Stream<String>` üzerinde çalışır; başka bir tipte önce `map(Object::toString)` gerekir.

## Özet, Cheat Sheet ve Terimler Sözlüğü

`Collectors`, `collect()` terminal operation'ına verilecek hazır tarifler sunar: `toList()`/`toSet()` basit koleksiyonlara toplar (`toList()` mutable, `Stream.toList()`'in aksine), `joining()` string'leri birleştirir, `groupingBy()` bir anahtara göre gruplar (isteğe bağlı bir downstream collector'la, örneğin `counting()`/`mapping()`), `partitioningBy()` tam olarak iki gruba ayırır, ve `toMap()` bir `Map` oluşturur (çakışan anahtarlar için açık bir merge fonksiyonu gerektirebilir).

Hızlı referans:

```java
stream.collect(Collectors.toList())              // mutable List
stream.collect(Collectors.toSet())                 // Set, yinelenensiz
stream.collect(Collectors.joining(", "))             // tek String
stream.collect(Collectors.groupingBy(fn))              // Map<K, List<T>>
stream.collect(Collectors.groupingBy(fn, counting()))    // Map<K, Long>
stream.collect(Collectors.partitioningBy(pred))            // Map<Boolean, List<T>>
stream.collect(Collectors.toMap(keyFn, valFn))                // Map<K, V>
```

**Terimler Sözlüğü**

**Collector** — `collect()`'e verilen, bir stream'in nasıl bir sonuca toplanacağını tanımlayan nesne; bir supplier, accumulator ve combiner'dan oluşur.

**Collectors** — `Collector` nesneleri üreten hazır statik metotlar sağlayan yardımcı sınıf.

**Downstream collector** — `groupingBy()`/`partitioningBy()`'a verilen, her grubun elemanlarına ne olacağını belirleyen ikinci bir `Collector`.

**groupingBy** — Elemanları bir anahtara göre gruplayıp `Map<K, List<T>>` (veya downstream collector'a göre farklı bir değer tipi) üreten collector.

**partitioningBy** — Elemanları bir `Predicate`'e göre tam olarak iki gruba (`true`/`false`) ayıran, `groupingBy()`'ın özel bir hali olan collector.
