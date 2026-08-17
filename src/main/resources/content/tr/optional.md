# Optional

"Terminal Operations" dersinde `reduce(accumulator)`, `min()`, `max()`, `findFirst()`, `findAny()`'in `Optional<T>` döndürdüğünü görmüş, ama detayına girmemiştik. Bu ders tam olarak `Optional`'ın kendisine odaklanıyor: bir değerin bulunmama ihtimalini tip sisteminde nasıl ifade ettiği, ve bunu nasıl güvenle kullanacağınız.

## Optional Nedir?

`Optional<T>`, bir değeri **olabilir ya da olmayabilir** şeklinde saran bir kapsayıcı (wrapper) sınıftır. Amacı, bir metodun "bu değeri bulamayabilirim" ihtimalini, dönüş tipinde açıkça göstermektir -- çağıran kodun bunu görmezden gelip doğrudan `null` ile karşılaşmasını (ve bir `NullPointerException`'a çarpmasını) engellemek.

## Neden Var?

Java'da geleneksel olarak "değer yok" durumu `null` ile ifade edilir -- ama bir metodun imzasına bakarak `null` dönebileceğini anlayamazsınız; bunu ancak dokümantasyondan öğrenirsiniz (ya da acı yoldan, bir `NullPointerException` ile). `Optional<T>`, bu ihtimali dönüş tipinin **kendisine** taşır: bir metot `Optional<User>` döndürüyorsa, çağıran kodun bunu ele almak zorunda olduğu açıktır -- derleyici sizi zorlamaz, ama tip imzası niyeti nettir.

## Tarihçe

`Optional<T>`, Java 8'de (2014) Stream API ile birlikte geldi -- Stream API'nin bazı terminal operation'larının (`reduce(accumulator)`, `min()`, `max()`, `findFirst()`, `findAny()`) boş bir stream için bir değer döndürememesi problemi, `Optional`'ın asıl motivasyonlarından biriydi. `ifPresentOrElse()` gibi bazı metotlar sonradan, Java 9'da (2017) eklendi.

## Optional Oluşturmak: of(), ofNullable(), empty()

Üç fabrika (factory) metodu bir `Optional` oluşturur. `Optional.of(value)`, değerin asla `null` olmayacağını iddia eder -- `null` verilirse anında `NullPointerException` fırlatır. `Optional.ofNullable(value)`, `null` olabilecek bir değeri güvenle sarar -- `null` ise boş bir `Optional` üretir. `Optional.empty()`, kasıtlı olarak boş bir `Optional` oluşturur.

{{OptionalCreationExample.java}}

## Bir Optional'ın İçini Okumak: isPresent(), isEmpty(), get()

`isPresent()` ve `isEmpty()`, bir değerin olup olmadığını `boolean` olarak sorar. `get()`, değeri doğrudan çıkarır -- ama Optional boşsa `NoSuchElementException` fırlatır. Bu üçlüyü birlikte kullanmak (`if (opt.isPresent()) { opt.get() }`) teknik olarak çalışır, ama bu dersin geri kalanında görülecek `orElse()`/`map()`/`ifPresent()` gibi metotlar aynı işi daha güvenli ve daha kısa yapar.

## orElse() ve orElseGet(): Varsayılan Değer Sağlamak

`orElse(değer)` ve `orElseGet(supplier)`, Optional boşsa kullanılacak bir varsayılan sağlar -- ama varsayılanın **ne zaman** hesaplandığı konusunda ayrılırlar. `orElse()`'in argümanı **her zaman**, Optional dolu olsa bile, hemen hesaplanır. `orElseGet()`'in `Supplier`'ı yalnızca Optional gerçekten boşsa çağrılır -- tembel (lazy) değerlendirme (Built-in Functional Interfaces dersindeki `Supplier<T>`'ın tam olarak var olma sebebi).

{{OrElseExample.java}}

## orElseThrow(): Özel Bir İstisna Fırlatmak

`orElseThrow()`'un iki biçimi vardır. Argümansız hali, `get()` ile tamamen aynı `NoSuchElementException`'ı fırlatır -- yalnızca niyeti daha net ifade eder. Bir `Supplier<X extends Throwable>` alan hali, kendi alan-özel (domain-specific) istisnanızı fırlatmanızı sağlar. Optional doluysa, `Supplier` hiç çağrılmaz -- `orElseGet()` ile aynı tembel değerlendirme mantığı.

{{OrElseThrowExample.java}}

## map() ve flatMap(): Optional İçindeki Değeri Dönüştürmek

`map(Function)`, Optional'ın **içindeki** değeri dönüştürür, önce `isPresent()` kontrolü yapmanıza gerek kalmadan -- Optional boşsa, fonksiyon hiç çağrılmadan boş bir Optional döner.

`flatMap()`, "Stream API Temelleri" dersinde `Stream.flatMap()`'in çözdüğü aynı iç içelik problemini çözer: dönüştürme fonksiyonunun kendisi bir `Optional` döndürüyorsa, `map()` bir `Optional<Optional<T>>` üretir -- kullanışsız, iç içe bir yapı. `flatMap()`, iç Optional'ı doğrudan dış Optional'a birleştirir.

{{OptionalMapFlatMapExample.java}}

## ifPresent() ve ifPresentOrElse(): Yan Etki Uygulamak

`ifPresent(Consumer)`, yalnızca bir değer varsa bir yan etki çalıştırır -- açık bir `null` kontrolüne gerek kalmadan `if (value != null) { ... }`'in karşılığı. `ifPresentOrElse(Consumer, Runnable)`, boş durum için de bir dal ekler -- `ifPresent()` tek başına bunu ifade edemez.

{{IfPresentExample.java}}

## filter(): Optional İçindeki Değeri Koşulla Süzmek

`filter(Predicate)`, değeri yalnızca koşulu sağlıyorsa tutar -- aksi halde dolu bir Optional'ı boşa çevirir. Zaten boş bir Optional'a hiç dokunmaz (Predicate yalnızca bir değer varsa test edilir). `filter()`, `map()` ve `orElse()` ile birlikte doğal bir doğrulama (validation) zinciri oluşturur -- hiçbir yerde açık bir `isPresent()`/`get()` çağrısına gerek kalmaz.

{{OptionalFilterExample.java}}

## Best Practices

- **`Optional`'ı yalnızca dönüş tipi olarak kullanın.** Bir alan (field) tipi, metot parametresi, ya da koleksiyon eleman tipi olarak `Optional` kullanmak, topluluk tarafından yaygın olarak önerilmez -- `Optional`'ın tasarım amacı yalnızca "bu metot bir değer döndürmeyebilir" ihtimalini iletmektir.
- **`get()`'i, önce `isPresent()` kontrolü yapmadan çağırmayın** -- ya da daha iyisi, `get()`'i hiç kullanmayın; `orElse()`/`orElseGet()`/`orElseThrow()`/`map()`/`ifPresent()` neredeyse her durumu kapsar.
- **Varsayılan değer ucuzsa `orElse()`, hesaplaması pahalıysa veya yan etkiliyse `orElseGet()` kullanın** -- `orElse()`'in argümanının her zaman hesaplandığını unutmayın.
- **`Optional<T>` yerine `null` döndürmeyi bırakın** yeni yazdığınız metotlarda -- ama zaten `null` dönebilen bir üçüncü parti API ile çalışıyorsanız, `Optional.ofNullable()` ile sarmak, bu ihtimali kodunuzun geri kalanında görünür kılar.

## Yaygın Hatalar

- **`get()`'i kontrolsüz çağırmak.** Boş bir Optional'da `get()`, tıpkı `null.toString()` gibi çalışma zamanı hatası verir -- yalnızca farklı bir istisna tipiyle (`NoSuchElementException`).
- **`orElse()`'in argümanının her zaman hesaplandığını unutmak.** Pahalı bir hesaplamayı veya bir yan etkiyi `orElse()`'e vermek, Optional dolu olsa bile o hesaplamayı/yan etkiyi çalıştırır -- bu durumda `orElseGet()` doğru araçtır.
- **`Optional`'ı bir alan tipi olarak kullanmak.** `Optional`, `Serializable` değildir ve bu amaç için tasarlanmamıştır; bir sınıfın alanı için `null` kontrolü veya ayrı bir tasarım (örneğin bir varsayılan değer) daha uygundur.
- **`map()` ile `flatMap()`'i karıştırmak.** Dönüştürme fonksiyonu bir `Optional` döndürüyorsa ve `map()` kullandıysanız, elinizde işe yaramaz bir `Optional<Optional<T>>` kalır -- tıpkı Stream'deki `flatMap()` hatasının aynısı.

## Özet, Cheat Sheet ve Terimler Sözlüğü

`Optional<T>`, bir değerin bulunmama ihtimalini tip sisteminde ifade eden bir sarmalayıcıdır: `of()`/`ofNullable()`/`empty()` ile oluşturulur, `orElse()`/`orElseGet()`/`orElseThrow()` ile varsayılan/istisna ile sonlandırılır, `map()`/`flatMap()` ile içindeki değer dönüştürülür, `filter()` ile koşulla süzülür, ve `ifPresent()`/`ifPresentOrElse()` ile yan etki uygulanır.

Hızlı referans:

```java
Optional.of(value)              // null verilirse NPE
Optional.ofNullable(value)        // null ise boş Optional
Optional.empty()                    // kasıtlı olarak boş

opt.orElse(defaultValue)              // her zaman hesaplanır
opt.orElseGet(() -> ...)                // yalnızca boşsa çağrılır
opt.orElseThrow(() -> new X())            // yalnızca boşsa çağrılır

opt.map(fn)                                 // içi dönüştürülür, boşsa dokunulmaz
opt.flatMap(fnReturningOptional)              // iç içe Optional'ı düzleştirir
opt.filter(predicate)                           // koşulu sağlamıyorsa boşa çevirir
opt.ifPresent(consumer)                           // yalnızca doluysa çalışır
```

**Terimler Sözlüğü**

**Optional** — Bir değerin bulunmama ihtimalini tip sisteminde açıkça ifade eden sarmalayıcı sınıf.

**Present (dolu)** — Bir `Optional`'ın gerçek bir değer içerdiği durum.

**Empty (boş)** — Bir `Optional`'ın hiçbir değer içermediği durum.

**Eager evaluation (istekli değerlendirme)** — Bir ifadenin, sonucuna gerçekten ihtiyaç olup olmadığına bakılmaksızın hemen hesaplanması; `orElse()`'in argümanı bu şekilde davranır.

**Lazy evaluation (tembel değerlendirme)** — Bir ifadenin yalnızca gerçekten gerektiğinde hesaplanması; `orElseGet()`'in `Supplier`'ı bu şekilde davranır.
