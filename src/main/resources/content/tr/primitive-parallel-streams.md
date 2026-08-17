# Primitive & Parallel Streams

Bu, **Functional Interfaces & Streams** kategorisinin son konusu. İki ayrı ama ilişkili konuyu bir araya getiriyor: `int`/`long`/`double` gibi primitive tipler için özelleşmiş stream'ler, ve bir stream pipeline'ını birden çok thread'e dağıtan paralel stream'ler.

## Primitive Stream Nedir?

Bir `Stream<Integer>`, her elemanı bir `Integer` **nesnesi** olarak tutar -- her `int` değeri, otomatik olarak (autoboxing) bir nesneye sarılır. `IntStream` (ve karşılıkları `LongStream`, `DoubleStream`), bu sarmalamayı atlayan, doğrudan primitive değerler üzerinde çalışan özelleşmiş stream tipleridir.

## Neden Var?

Autoboxing bedava değildir -- her `int`'i bir `Integer` nesnesine çevirmek, ekstra bellek ayırma ve bir referans katmanı demektir. Milyonlarca elemanlı bir stream'de bu maliyet gözle görülür hale gelir. `IntStream`/`LongStream`/`DoubleStream`, bu maliyeti tamamen ortadan kaldırır; ayrıca `sum()`, `average()` gibi, yalnızca sayılar için anlamlı olan ve genel `Stream<T>`'de bulunmayan metotları doğrudan sunar.

## Tarihçe

Primitive stream tipleri, Stream API ile birlikte Java 8'de (2014) geldi -- tasarımcıların, autoboxing maliyetini bilinçli olarak API'nin temel bir parçası haline getirme kararının bir sonucu. Üç tip vardır: `IntStream`, `LongStream`, `DoubleStream` -- `short`, `byte`, `float` için ayrı bir stream tipi yoktur, bunlar gerektiğinde `int`/`double`'a genişletilir (widening).

## IntStream Oluşturmak: range(), rangeClosed(), of()

`IntStream.range(başlangıç, bitiş)`, bitiş **hariç** bir aralık üretir (`[başlangıç, bitiş)`); `IntStream.rangeClosed(başlangıç, bitiş)`, bitiş **dahil** üretir. `IntStream.of(...)`, literal değerlerden bir stream oluşturur -- `Stream.of(...)`'un primitive karşılığı.

{{IntStreamCreationExample.java}}

## Primitive Stream'e Özel Metotlar: sum(), average(), max(), min()

`sum()`, doğrudan bir `int`/`long`/`double` döndürür (boş stream için `0`). `average()`, `min()`, `max()` ise `Optional<T>` yerine `OptionalInt`/`OptionalLong`/`OptionalDouble` döndürür -- primitive tipler için ayrı, kutulanmamış (unboxed) `Optional` varyantları. Bu metotlar, genel `Stream<Integer>`'da doğrudan bulunmaz; `IntStream`'in var olma sebeplerinden biri tam olarak budur.

## Boxing ve Unboxing: mapToObj() ve boxed()

`mapToObj()`, bir primitive stream'i (örneğin `IntStream`) herhangi bir nesne tipinde bir `Stream<T>`'e çevirir. `boxed()`, aynı yönde ama özel bir hali: `IntStream`'i doğrudan `Stream<Integer>`'a çevirir -- primitive değerleri ilgili kutulanmış (boxed) tipe sarar. `collect()`/`Collectors` (bir önceki ders) gibi yalnızca nesne stream'leriyle çalışan API'lere geçerken sıkça ihtiyaç duyulur.

## Object Stream'den Primitive Stream'e: mapToInt(), mapToLong(), mapToDouble()

`boxed()`'in tersi yöndeki köprü: `mapToInt()`, `mapToLong()`, `mapToDouble()`, bir `Stream<T>`'i ilgili primitive stream'e çevirir -- genellikle bir nesne stream'inde `sum()`/`average()` gibi sayısal bir toplama yapmak istediğinizde kullanılır.

{{BoxingMapToIntExample.java}}

## Parallel Stream Nedir? parallelStream() ve stream().parallel()

Bir `Collection`'ın `parallelStream()` metodu (ya da herhangi bir stream üzerinde `.parallel()` çağırmak), pipeline'ın işini tek bir thread yerine, ortak `ForkJoinPool`'daki birden çok thread'e böler. Sonuç, birleştirme (associative) bir işlem için **aynıdır** -- yalnızca çalışma stratejisi değişir. Aşağıdaki örnek, hem sonucun aynı kaldığını hem de gerçekten birden fazla thread'in kullanıldığını (thread isimlerini toplayarak) doğrudan gözlemliyor.

{{ParallelBasicsExample.java}}

## Sıralama: forEach() vs forEachOrdered()

Paralel bir stream'de `forEach()`, elemanları **karşılaşma sırasına göre değil**, hangi thread hangi elemanı ne zaman işlerse o sırayla işler -- sıra garantisi yoktur. `forEachOrdered()`, sonucu tekrar karşılaşma sırasına zorlar, ama bunun bir bedeli vardır: paralelliğin sağladığı hız kazancının büyük kısmından vazgeçilir. Aşağıdaki örnek, aynı 10 elemanlı listede `forEach()`'in gerçekten sırayı bozduğunu, `forEachOrdered()`'ın ise korduğunu doğrudan gözlemliyor.

{{ParallelOrderingExample.java}}

## Yaygın Bir Tuzak: Thread-Safe Olmayan Paylaşılan Durum

Paralel bir `forEach()` içinde, sıradan (thread-safe olmayan) bir `ArrayList` gibi paylaşılan bir yapıya yazmak, gerçek bir veri yarışına (race condition) yol açar. Aşağıdaki örnek bunu 100.000 elemanlı bir listeyle gösteriyor: `ArrayList::add`'e paralel olarak yazmak **hiçbir istisna fırlatmadan**, sessizce, beklenenden daha az elemanla sonuçlanabiliyor -- gerçek çalıştırmalarda gözlemlenen boyutlar 96.901 ile 100.000 arasında değişti (bazı çalıştırmalarda şans eseri doğru çıktı, bu da hatayı daha da tehlikeli kılıyor). Doğru çözüm, `collect(Collectors.toList())` kullanmaktır -- thread-safety'yi kendi içinde, sizin kodunuza hiçbir paylaşılan durum sızdırmadan halleder.

{{ParallelPitfallExample.java}}

## Ne Zaman Kullanılmalı?

Paralel stream'ler, şu koşullar bir arada olduğunda fayda sağlar: veri kümesi yeterince büyük (binlerce/milyonlarca eleman), işlem CPU-yoğun (her eleman için gerçek hesaplama gerektiriyor, yalnızca hızlı bir I/O beklemesi değil), ve işlem **birleştirilebilir/durumsuz** (associative/stateless) -- her elemanın işlenme sırası ya da diğer elemanlarla paylaşılan bir durum sonucu etkilememeli.

## Neden Her Zaman Daha Hızlı Değildir?

Paralelleştirmenin gerçek bir maliyeti vardır: işi bölmek, thread'leri `ForkJoinPool` üzerinden koordine etmek, ve kısmi sonuçları birleştirmek zaman alır. Küçük bir veri kümesinde ya da ucuz bir işlemde, bu maliyet kazançtan fazla olabilir.

Bunu, tek seferlik bir `nanoTime()` ölçümüyle **doğru** göstermek mümkün değildir -- JVM, JIT derleyicisi devreye girmeden önce kodu yorumlar (interpret eder), bu yüzden hangi yol **önce** çalışırsa o, sırf ısınma (warmup) maliyeti yüzünden haksız yere yavaş görünür. Aşağıdaki örnek önce her iki yolu da binlerce kez çalıştırıp ısıtıyor, ancak ondan **sonra** gerçek bir ölçüm alıyor -- bu sandbox'ta 100 elemanlık küçük bir liste için tipik bir çalıştırmada sıralı yol yaklaşık 15ms, paralel yol yaklaşık 41ms sürdü (tam sayılar çalıştırmadan çalıştırmaya değişir, ama küçük veri/ucuz işlem için sıralı yolun kazandığı yön tutarlı).

{{ParallelOverheadExample.java}}

## Best Practices

- **Varsayılan olarak sıralı (`stream()`) kullanın, yalnızca ölçtükten sonra paralele geçin.** "Ne Zaman Kullanılmalı?" bölümündeki koşullar sağlanmıyorsa, `parallelStream()` genellikle ek karmaşıklık getirir, performans kazandırmaz.
- **Paylaşılan, thread-safe olmayan bir yapıya asla paralel `forEach()` içinde yazmayın** -- bunun yerine her zaman bir `collect()`/`Collectors` kullanın (bir sonraki bölümde gerçek bir örnekle gösteriliyor).
- **Sıralamanın önemli olduğu yerlerde `forEachOrdered()` kullanın** -- ama bunun paralelliğin çoğu faydasını iptal ettiğini bilerek; sıralama gerekiyorsa çoğu zaman `stream()` (sıralı) zaten daha basit bir seçimdir.
- **Gerçek performans iddialarını her zaman ısıtılmış (warmed-up), tekrarlı bir ölçümle destekleyin** -- tek seferlik bir `nanoTime()` farkı yanıltıcı olabilir.

## Yaygın Hatalar

- **Paralel `forEach()` içinde thread-safe olmayan bir koleksiyona (`ArrayList` gibi) eleman eklemek.** Bu, gerçek bir veri yarışı (race condition) oluşturur -- sonuç boyutu beklenenden **sessizce** küçük çıkabilir, hiçbir istisna fırlatılmadan (aşağıdaki örnekte gerçekten gözlemlendi: bazı çalıştırmalarda 100.000 beklenen elemandan yalnızca ~96.900-99.200'ü sonuca ulaştı). Hatanın her zaman değil, yalnızca bazen ortaya çıkması, bu hatayı daha da tehlikeli kılar -- testlerde fark edilmeyebilir.
- **"Daha çok thread, her zaman daha hızlı" varsayımı.** "Neden Her Zaman Daha Hızlı Değildir?" bölümünde görüldüğü gibi, küçük veri/ucuz işlem için paralel stream genellikle daha yavaştır.
- **Paralel bir stream'de sıralamaya güvenmek.** `forEach()` sırayı korumaz; sıra gerekiyorsa `forEachOrdered()` ya da baştan `stream()` kullanılmalı.
- **`IntStream`/`LongStream`/`DoubleStream`'i gerekmediği yerde kullanmak.** Yalnızca birkaç eleman varsa ya da sayısal bir toplama yapılmıyorsa, autoboxing maliyeti önemsizdir; gereksiz `mapToInt()`/`boxed()` zincirleri kodu karmaşıklaştırır.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Primitive stream'ler (`IntStream`, `LongStream`, `DoubleStream`), autoboxing maliyetini ortadan kaldırır ve `sum()`/`average()`/`max()`/`min()` gibi sayısal metotları doğrudan sunar; `mapToInt()`/`mapToLong()`/`mapToDouble()` bir nesne stream'inden primitive stream'e, `boxed()`/`mapToObj()` ters yöne köprü kurar. Paralel stream'ler (`parallelStream()`/`.parallel()`), bir pipeline'ın işini birden çok thread'e böler -- büyük veri ve CPU-yoğun, birleştirilebilir işlemler için faydalıdır, ama gerçek bir maliyeti vardır ve thread-safe olmayan paylaşılan durumla birlikte kullanıldığında sessiz veri yarışlarına yol açabilir.

Hızlı referans:

```java
IntStream.range(0, 5)          // 0..4, bitiş hariç
IntStream.rangeClosed(0, 5)      // 0..5, bitiş dahil
IntStream.of(1, 2, 3)              // literal değerler

intStream.sum() / .average() / .max() / .min()   // sayısal toplamalar

stream.mapToInt(fn)                    // object -> primitive stream
intStream.boxed() / .mapToObj(fn)        // primitive -> object stream

collection.parallelStream()                // paralel çalışma
stream.forEach(x -> ...)                     // sıra garantisi yok (paralelde)
stream.forEachOrdered(x -> ...)                // sıra garantili
```

**Terimler Sözlüğü**

**Primitive stream** — `int`/`long`/`double` gibi bir primitive tip için özelleşmiş, autoboxing maliyeti olmayan stream tipi (`IntStream`, `LongStream`, `DoubleStream`).

**Autoboxing** — Bir primitive değerin (`int`) otomatik olarak karşılık gelen nesne tipine (`Integer`) sarılması.

**Parallel stream** — Pipeline'ın işini ortak `ForkJoinPool`'daki birden çok thread'e bölen stream.

**Race condition (veri yarışı)** — Birden fazla thread'in, senkronizasyon olmadan aynı paylaşılan duruma aynı anda yazmasından kaynaklanan, öngörülemez ve genellikle sessiz hata.

**Warmup (ısınma)** — Bir JVM'in JIT derleyicisinin, sık çalıştırılan kodu makine koduna derlemesi için gereken tekrarlı çalıştırma süresi; ısıtılmamış bir ölçüm yanıltıcı sonuçlar verebilir.
