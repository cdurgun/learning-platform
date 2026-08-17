# Terminal Operations

"Stream API Temelleri" dersinde bir stream pipeline'ının üç aşamasını görmüştünüz: source, intermediate operation'lar, ve tam olarak bir terminal operation. O ders intermediate operation'lara odaklanmıştı; bu ders, pipeline'ı gerçekten çalıştırıp bir sonuç üreten **terminal operation**'ları ele alıyor.

## Terminal Operation Nedir?

Bir terminal operation, bir stream pipeline'ını **tüketen** ve bir sonuç (bir değer, bir koleksiyon, ya da hiçbir şey -- `void`) üreten son adımdır. "Stream Pipeline: Source, Intermediate, Terminal" bölümünde de belirtildiği gibi, bir pipeline'da tam olarak bir terminal operation bulunur; çağrıldığı anda tüm intermediate operation'lar zincirleme olarak, eleman eleman çalıştırılır.

Bu derste sırasıyla `forEach()`, `reduce()`, `count()`, `min()`/`max()`, `findFirst()`/`findAny()`, `anyMatch()`/`allMatch()`/`noneMatch()`, ve `toList()`/`toArray()`'i göreceksiniz. `collect()`'in tam gücü (özellikle `Collectors` sınıfı) bir sonraki derste.

## Neden Var?

Intermediate operation'lar tembeldir (Lazy Evaluation, "Stream API Temelleri" dersi) -- kendi başlarına hiçbir şey üretmezler, yalnızca pipeline'ın tanımına adım eklerler. Bir sonuca gerçekten ihtiyaç duyduğunuzda (bir sayı, bir liste, bir `boolean`) bu tanımı **tetikleyecek** bir şeye ihtiyacınız var: işte bu, terminal operation'ın işi. Terminal operation olmadan bir stream pipeline'ı yalnızca bir tanımdır, hiçbir zaman çalışmaz.

## Tarihçe

Terminal operation'ların çoğu, Stream API ile birlikte Java 8'de (2014) geldi. `toList()` bir istisna -- Java 16'ya (2021) kadar bir stream'i listeye çevirmenin tek yolu `collect(Collectors.toList())` idi; `toList()`, bu çok sık kullanılan deseni kısaltmak için sonradan eklenen bir kolaylık metodudur.

## forEach(): Yan Etki Uygulamak

`forEach(Consumer<T>)`, her elemanda bir yan etki çalıştırır ve `void` döndürür -- bir `for-each` döngüsünün terminal operation karşılığıdır. Hiçbir şey döndürmediği için, bir pipeline'ı yalnızca **bitirebilir**, asla devam ettiremez.

{{ForEachExample.java}}

## count(): Eleman Sayısı

`count()`, terminal operation'a ulaşan eleman sayısını `long` olarak döndürür. Peek()/lazy evaluation bölümünde detaylandırılacağı gibi, `count()`'un davranışı göründüğünden daha ilginçtir.

## reduce(): Elemanları Tek Bir Değere İndirgemek

`reduce()`, tüm elemanları, iki değeri birleştirip bir tane üreten bir `BinaryOperator` ile, tekrar tekrar uygulanarak **tek bir değere** indirger. Üç aşırı yüklemesi (overload) vardır, temel fark başlangıç değeri (identity) verilip verilmemesi:

- `reduce(identity, accumulator)`: `identity`'den başlar, boş stream için bile her zaman bir değer döndürür (doğrudan `identity`'yi).
- `reduce(accumulator)`: başlangıç değeri yok -- boş bir stream'in döndürecek bir değeri olmayacağından, bu aşırı yükleme `T` yerine `Optional<T>` döndürür.
- Üç parametreli `reduce(identity, accumulator, combiner)` (bu örnekte kullanılmadı) paralel stream'ler için kısmi sonuçları birleştirmeye yarar.

{{ReduceExample.java}}

## min() ve max(): Comparator ile Uç Değerler

`min()` ve `max()`, bir `Comparator` gerektirir -- parametresiz bir aşırı yükleme yoktur, çünkü stream'in eleman tipi her zaman `Comparable` olmak zorunda değildir. `reduce(accumulator)` ile aynı sebeple, ikisi de `Optional<T>` döndürür: boş bir stream'in ne minimumu ne de maksimumu vardır.

{{CountMinMaxExample.java}}

## findFirst() ve findAny(): İlk/Herhangi Bir Eşleşme

`findFirst()`, karşılaşma sırasına (encounter order) göre **ilk** elemanı, `findAny()` ise **herhangi bir** elemanı `Optional<T>` olarak döndürür. Bu kursta yalnızca sıralı (sequential) stream'ler kullanıldığı için ikisi aynı şekilde davranır; fark yalnızca paralel stream'lerde ortaya çıkar (`findAny()` orada daha hızlı olabilir, çünkü ilk bulunan sonucu beklemek zorunda değildir).

## anyMatch(), allMatch(), noneMatch(): Kısa Devre Kontrolleri

Bu üç metot, bir `Predicate` ile stream hakkında evet/hayır sorusu sorar ve düz bir `boolean` döndürür: `anyMatch()` en az bir eleman koşulu sağlıyor mu, `allMatch()` tüm elemanlar sağlıyor mu, `noneMatch()` hiçbir eleman sağlamıyor mu.

{{FindMatchExample.java}}

## toList() ve toArray(): Basit Koleksiyona Dönüştürme

`toList()` (Java 16), `collect(Collectors.toList())`'in kısa yoludur -- ama tek bir önemli farkla: `toList()`'in döndürdüğü liste **değiştirilemezdir** (unmodifiable), `collect(Collectors.toList())`'inki ise değiştirilebilir bir listedir. `toArray()`, stream'i bir `List` yerine bir diziye çevirir; eleman tipini bilen bir dizi üretmek için genellikle `String[]::new` gibi bir constructor reference alır (Built-in Functional Interfaces dersindeki `Class::new` biçimi).

{{ToListToArrayExample.java}}

## Kısa Devre ve count()'un Şaşırtıcı Davranışı

Bazı terminal operation'lar **kısa devre yapar (short-circuit)**: cevap netleştiği anda pipeline'ı durdurur, kalan elemanları hiç işlemez. `anyMatch()` ilk eşleşmede durur; `findFirst()` ilk sonucu bulduğunda durur.

`count()` ise ayrı ve gerçekten şaşırtıcı bir durum: bazı durumlarda JDK, sayıyı doğrudan kaynağın bilinen boyutundan hesaplayabilir ve pipeline'ı **hiç çalıştırmadan** atlayabilir. Bu gerçekleştiğinde, aradaki `peek()` gibi intermediate operation'lar bile hiç çağrılmaz -- bu, JDK dokümantasyonunda açıkça belirtilen, kasıtlı bir optimizasyondur, bir hata değil. Aşağıdaki örnekte bunu gerçek bir `count()` çağrısıyla gözlemleyebilirsiniz: `peek()` içindeki yazdırma satırı **hiç çalışmaz**.

{{ShortCircuitExample.java}}

## Best Practices

- **`peek()`'e (bir önceki dersten) veya yan etkilere dayanan varsayımlar kurmayın.** `count()` örneğinde görüldüğü gibi, JDK bazı intermediate operation'ları atlayabilir; yan etkiler için `forEach()` veya doğrudan bir döngü kullanın.
- **`reduce(accumulator)`/`min()`/`max()`'ın `Optional<T>` döndürdüğünü unutmayın** -- boş bir stream ihtimaline karşı `orElse()`/`orElseThrow()` gibi bir sonlandırma her zaman gerekir (Optional, ayrı bir derste detaylı ele alınacak).
- **`findAny()`'i yalnızca gerçekten "hangi eleman olduğu önemli değil" durumunda kullanın** -- `findFirst()` niyeti daha net ifade eder ve sıralı stream'lerde ek bir performans kazancı sağlamaz.
- **`toList()`'in sonucunun değiştirilemez olduğunu unutmayın** -- değiştirilebilir bir liste gerekiyorsa `collect(Collectors.toCollection(ArrayList::new))` (bir sonraki dersin konusu) veya sonucu yeni bir `ArrayList`'e sarmayı düşünün.

## Yaygın Hatalar

- **`reduce()`'un boş stream davranışını unutmak.** `reduce(accumulator)` boş bir stream için `Optional.empty()` döndürür; `.get()` ile doğrudan açmaya çalışmak `NoSuchElementException` fırlatır.
- **`min()`/`max()`'ın sonucunu kontrolsüz açmak.** Aynı risk `min()`/`max()` için de geçerli -- ikisi de boş stream'de boş `Optional` döner.
- **`count()`'un her zaman tüm elemanları işlediğini varsaymak.** Yukarıda görüldüğü gibi bu doğru değil; `peek()` ile debug yaparken `count()`'un beklenmedik şekilde hiçbir çıktı vermemesi bu yüzdendir.
- **`toList()`'in döndürdüğü listeye eleman eklemeye çalışmak.** `UnsupportedOperationException` fırlatır -- `List.of()`'un döndürdüğü listelerle aynı immutability kısıtı.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Bir terminal operation, bir stream pipeline'ını tüketip bir sonuç üretir: `forEach()` bir yan etki uygular, `reduce()` elemanları tek bir değere indirger, `count()` eleman sayısını verir (ama bazen pipeline'ı hiç çalıştırmadan), `min()`/`max()` bir `Comparator`'a göre uç değerleri bulur, `findFirst()`/`findAny()` bir eşleşmeyi `Optional<T>` olarak döndürür, `anyMatch()`/`allMatch()`/`noneMatch()` evet/hayır sorularına `boolean` döndürür, ve `toList()`/`toArray()` sonucu basit bir koleksiyona çevirir. `anyMatch()` ve `findFirst()` gibi bazı operation'lar kısa devre yapar; `count()` özel bir kaynak-boyutu optimizasyonuna sahiptir.

Hızlı referans:

```java
stream.forEach(x -> ...)      // yan etki, void döner
stream.count()                 // long, bazen kaynaktan doğrudan hesaplanır
stream.reduce(id, op)           // T, her zaman değer döner
stream.reduce(op)                 // Optional<T>
stream.min(cmp) / .max(cmp)        // Optional<T>
stream.findFirst() / .findAny()     // Optional<T>
stream.anyMatch(p) / .allMatch(p)    // boolean, kısa devre
stream.noneMatch(p)                   // boolean, kısa devre
stream.toList() / .toArray(gen)        // List<T> (değiştirilemez) / T[]
```

**Terimler Sözlüğü**

**Terminal operation** — Bir stream pipeline'ını tüketip bir sonuç üreten, pipeline'ı tetikleyen son adım.

**Short-circuiting (kısa devre)** — Bir terminal operation'ın, cevap netleştiği anda kalan elemanları işlemeden pipeline'ı durdurması.

**reduce** — Tüm elemanları, ikili bir birleştirme fonksiyonuyla tekrar tekrar uygulanarak tek bir değere indirgeyen terminal operation.

**Optional** — Bir değerin bulunmama ihtimalini tip sisteminde ifade eden sarmalayıcı; `reduce(accumulator)`, `min()`, `max()`, `findFirst()`, `findAny()` tarafından döndürülür (ayrı bir derste detaylı ele alınıyor).

**Encounter order (karşılaşma sırası)** — Bir stream'in elemanlarının işlendiği sıra; `findFirst()`, bu sıraya göre ilk elemanı döndürür.
