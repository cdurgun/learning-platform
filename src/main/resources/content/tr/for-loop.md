# for Loop

Control Flow kategorisinin üçüncü konusu for döngüsü -- bir kod bloğunu, önceden bilinen ya da sayılabilen bir sayıda TEKRARLAMAYI sağlayan kontrol yapısı. `if`/`else` (bkz. "if / else" dersi) ve `switch` (bkz. "switch" dersi) bir kod yolunu YALNIZCA BİR KEZ çalıştırıp çalıştırmayacağına karar verirken, `for` aynı bloğu BİRDEN FAZLA KEZ, bir sayaç değişkeninin ilerlemesine bağlı olarak çalıştırır. Bu ders, klasik `for` sözdizimini, `break`/`continue` ile döngü akışını kontrol etmeyi, ve bir dizi (array) üzerinde indeks tabanlı gezinmeyi ele alıyor.

## for Döngüsü Nedir?

`for` döngüsü, tek bir satırda üç parçayı birleştirir: BAŞLANGIÇ (initialization -- yalnızca bir kez, döngü başlamadan önce çalışır), KOŞUL (condition -- her tekrardan önce kontrol edilir, `false` olduğunda döngü biter) ve GÜNCELLEME (update -- her tekrarın SONUNDA çalışır). `for (int i = 0; i < 5; i++)` biçimindeki bu üç parça noktalı virgülle ayrılır. Başlangıçta tanımlanan sayaç değişkeni (`i`), yalnızca döngünün kendi kapsamında (scope) vardır -- döngü bittikten sonra erişilemez.

## Neden Var?

Aynı işlemi belirli bir sayıda (ya da bir koşul sağlanana kadar) tekrarlamak, programlamanın en temel ihtiyaçlarından biridir -- bir listenin her elemanını işlemek, bir işlemi N kez denemek, bir aralıktaki her sayıyı kontrol etmek. Bunu döngü OLMADAN yazmak, aynı kodu elle N kez kopyalamayı gerektirirdi -- hem N'in kendisi değişkense imkansız, hem de N sabit olsa bile bakımı zor ve hataya açık olurdu. `for`, sayaç tabanlı tekrarların BAŞLANGIÇ/KOŞUL/GÜNCELLEME mantığını tek bir yerde, kompakt bir şekilde toplar.

## Tarihçe

`for` döngüsü de `if`/`switch` gibi C'den (1972) Java'ya (1995) neredeyse birebir geçti -- üç bölümlü (`init; condition; update`) sözdizimi C'nin doğrudan mirasıdır ve o günden beri değişmedi. Java 5 (2004), bu klasik `for`'un yanına dizi/koleksiyon elemanlarını indekssiz gezmek için "enhanced for" (`for-each`) sözdizimini EKLEDİ (bkz. "Enhanced for Loop" dersi) -- klasik `for`'u DEĞİŞTİRMEDİ, ikisi hâlâ yan yana, farklı amaçlar için var.

## Temel for Döngüsü Sözdizimi

En yaygın kullanım, `0`'dan başlayıp bir sınıra kadar (`<` ya da `<=` ile) sayan, her adımda `1` artan (`i++`) bir sayaçtır -- ama üç bölüm de tamamen esnektir: `i--` ile geriye sayılabilir, farklı bir adım büyüklüğü (`i += 2`) kullanılabilir.

{{ForLoopBasicsExample.java}}

## break ile Döngüden Çıkmak

`break`, bir döngüyü KOŞULUN hâlâ `true` olup olmadığına BAKMAKSIZIN anında sonlandırır -- kontrol akışı döngüden hemen sonraki satıra atlar. En yaygın kullanımı, bir ARAMA'da aranan şey bulunduğunda kalan elemanları kontrol etmeye devam etmenin gereksiz olduğu durumlardır.

{{BreakExample.java}}

## continue ile Bir Adımı Atlamak

`continue`, mevcut tekrarın GERİ KALANINI atlar ve doğrudan GÜNCELLEME adımına (ardından tekrar KOŞUL kontrolüne) geçer -- döngünün kendisi `break`'in aksine SONA ERMEZ, yalnızca o TEK adım kısa kesilir. Yaygın bir kullanım, bir koleksiyondaki geçersiz/istenmeyen elemanları atlayıp geri kalanı işlemeye devam etmektir.

{{ContinueExample.java}}

> 💡 Tip
> `break` "döngüyü tamamen bırak", `continue` ise "yalnızca bu adımı atla, döngüye devam et" anlamına gelir -- ikisini karıştırmak yaygın bir kavramsal hatadır (bkz. "Yaygın Hatalar").

## Sonsuz Döngüler

Üç bölümün de (`init`, `condition`, `update`) TAMAMEN atlanabildiği `for (;;)` biçimi, kendiliğinden asla bitmeyen KASITLI bir sonsuz döngü oluşturur -- yalnızca gövde içindeki bir `break` (ya da bir `return`) onu durdurabilir. Bu, "ne zaman duracağını önceden bilmediğin" durumlarda (örn. kullanıcıdan geçerli bir girdi gelene kadar sor) kullanışlıdır.

{{InfiniteLoopExample.java}}

> ⚠️ Warning
> Kasıtsız (yani bir hatadan kaynaklanan) sonsuz döngüler gerçek bir programın ÇÖKMESİNE ya da DONMASINA yol açar -- en yaygın nedeni, güncelleme adımının koşulu ASLA `false` yapmayacak şekilde yazılmasıdır (örn. `i++` yazmayı unutmak, ya da koşulu yanlışlıkla her zaman `true` kalacak şekilde kurmak). Her `for` yazarken güncelleme adımının gerçekten koşulu bir noktada `false` yapacağından emin olunmalıdır.

## Birden Fazla Değişkenle for

`for`'un başlangıç ve güncelleme bölümleri, virgülle ayrılmış BİRDEN FAZLA ifade içerebilir -- bu, iki değişkenin BİRLİKTE ilerlemesi gerektiğinde (örn. bir dizinin iki ucundan ortaya doğru tarama) kullanışlıdır.

{{MultipleVariablesForExample.java}}

## for Döngüsüyle Dizi Üzerinde Gezinme

Klasik `for`, bir dizinin her adımda İNDEKSİNİ de sağlar -- bu, yalnızca değerlere değil (bkz. "Arrays" dersindeki "Temel Kullanım: Oluşturma, Erişim, Varsayılan Değerler" bölümü) o değerlerin KONUMUNA da ihtiyaç duyulduğunda (örn. bir diziyi YERİNDE değiştirmek) gereklidir. Bunun neden önemli olduğu -- ve indekse ihtiyaç duyulmadığında daha kısa bir alternatifin var olduğu -- gelecek "Enhanced for Loop" dersinde ele alınacak.

{{ArrayIterationForExample.java}}

## Best Practices

- **Döngü sayacının kapsamını (scope) mümkün olduğunca döngüyle sınırlı tutun** -- sayacı `for`'un kendi başlangıç bölümünde tanımlamak, döngü dışında yanlışlıkla kullanılmasını önler.
- **`break`'i yalnızca gerçekten erken çıkmak GEREKTİĞİNDE kullanın** -- gereksiz `break` kullanımı akışı takip etmeyi zorlaştırabilir.
- **`continue` yerine, mümkünse koşulu TERSİNE çevirip erken atlamayı düşünün** -- bazen okunabilirlik açısından daha net olur, ama her iki yaklaşım da geçerlidir.
- **Bir `for (;;)` yazıyorsanız, döngüyü durduracak `break` koşulunun MUTLAKA var olduğundan emin olun.**
- **Güncelleme adımının koşulu bir noktada `false` yapacağını her zaman doğrulayın** -- kasıtsız sonsuz döngülerin en sık nedeni budur.

## Yaygın Hatalar

- **Güncelleme adımını (`i++` gibi) yazmayı unutup kasıtsız bir sonsuz döngü yaratmak.** Koşul asla `false` olmaz, program donar.
- **`break` ile `continue`'yu karıştırmak.** `break` döngüyü tamamen bitirir, `continue` yalnızca mevcut adımı atlar -- ikisi çok farklı davranışlardır.
- **Bir dizinin sınırını `<=` ile `.length` değerine kadar kontrol edip `ArrayIndexOutOfBoundsException` almak.** Geçerli indeksler `0`'dan `length - 1`'e kadardır, bu yüzden koşul `i < dizi.length` olmalıdır, `i <= dizi.length` DEĞİL.
- **Döngü içinde tanımlanan bir sayacı döngü dışında kullanmaya çalışmak.** Sayaç yalnızca `for`'un kendi kapsamında var olur, derleme hatası alınır.

## Özet, Cheat Sheet ve Terimler Sözlüğü

`for` döngüsü, BAŞLANGIÇ/KOŞUL/GÜNCELLEME'yi tek bir satırda birleştiren, sayaç tabanlı bir tekrar yapısıdır. `break` döngüyü tamamen sonlandırır; `continue` yalnızca mevcut adımı atlar. Üç bölümü de atlayan `for (;;)` kasıtlı bir sonsuz döngü oluşturur, yalnızca içindeki bir `break` onu durdurabilir. Başlangıç/güncelleme bölümleri virgülle birden fazla ifade içerebilir. Klasik `for`, bir dizi üzerinde gezinirken hem DEĞERE hem İNDEKSE erişim sağlar.

Hızlı referans:

```java
for (int i = 0; i < 5; i++) {
    // ...
}

for (int i = 0; ; i++) {
    if (kosul) break;
}

for (int i = 0; i < dizi.length; i++) {
    if (dizi[i] < 0) continue;
    // ...
}

for (int i = 0, j = dizi.length - 1; i < j; i++, j--) {
    // ...
}
```

**Terimler Sözlüğü**

**Initialization (Başlangıç)** — `for`'un yalnızca bir kez, döngü başlamadan önce çalışan ilk bölümü.

**Condition (Koşul)** — Her tekrardan önce kontrol edilen, `false` olduğunda döngüyü sonlandıran `boolean` ifade.

**Update (Güncelleme)** — Her tekrarın sonunda çalışan, genellikle sayacı ilerleten bölüm.

**break** — Bir döngüyü koşuldan bağımsız olarak anında sonlandıran anahtar kelime.

**continue** — Mevcut tekrarın geri kalanını atlayıp doğrudan güncelleme adımına geçen anahtar kelime.
