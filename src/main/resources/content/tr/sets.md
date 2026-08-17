# Sets

"Lists" dersinde gördüğün `List` arayüzü tekrar eden elemanlara izin veriyordu ve eklenme sırasını koruyordu. Bazen tam tersini istersin: bir elemanın koleksiyonda **yalnızca bir kez** bulunmasını garanti etmek, ve genellikle sıra da hiç önemli değildir -- örneğin bir sistemdeki benzersiz kullanıcı ID'leri, bir metindeki farklı kelimeler, ya da bir kümenin matematiksel anlamda temsili. Bunun için Java `Set` arayüzünü sunar.

## Set Nedir?

`Set<E>`, `java.util.Collection`'ı genişleten bir arayüzdür ve tek bir garanti verir: **hiçbir eleman birden fazla bulunamaz**. `List`'in aksine index tabanlı erişim (`get(index)`) sunmaz -- bir elemana yalnızca `contains()` ile ya da dolaşarak (iteration) erişilebilir. Üç ana implementasyonu vardır: `HashSet` (hash tablosu, sıra garantisi yok, en hızlı), `LinkedHashSet` (`HashSet` + eklenme sırasını hatırlayan bağlı liste), ve `TreeSet` (kırmızı-siyah ağaç, elemanları her zaman sıralı tutar).

## Neden Var?

Bir `List`'te yinelenenleri elle önlemek, her `add()`'den önce `contains()` ile kontrol etmeyi gerektirir -- bu hem unutulmaya açıktır hem de `List.contains()`'in doğrusal (O(n)) taraması yüzünden büyük listelerde yavaştır. `Set`, "bu eleman zaten var mı" kontrolünü `add()`'in kendi içine gömer ve bunu (implementasyona göre) çok daha hızlı yapar -- ayrıca kodu okuyan kişiye "burada tekrarların önemi yok, önemli olan tekilliktir" mesajını doğrudan verir.

## Tarihçe

`Set` arayüzü de `List` gibi Java 1.2 (1998) ile gelen Collections Framework'ün parçasıdır. `HashSet`, arka planda bir `HashMap` kullanarak (yalnızca anahtarları saklayarak) implemente edilir. `LinkedHashSet` ve `TreeSet` de aynı ilk sürümle geldi; `TreeSet`, sıralı bir yapı olan `TreeMap`'in üzerine kurulmuştur -- tıpkı `HashSet`'in `HashMap`'in üzerine kurulması gibi.

## Temel Set İşlemleri

`Set`'in temel metotları `List`'inkine çok benzer -- `add()`, `remove()`, `contains()`, `size()` -- ama iki önemli fark var: index tabanlı erişim yoktur, ve `add()` zaten var olan bir elemanı eklemeye çalışırsan sessizce `false` döner (istisna fırlatmaz).

{{SetBasicsExample.java}}

> ⚠️ Warning
> `HashSet`'in dolaşma (iteration) sırası, elemanların **eklenme sırasıyla ilgisizdir** -- iç hash tablosundaki konumlarına göre belirlenir ve bu sıra JDK sürümüne, hatta çalışma zamanına göre değişebilir. Sırayı önemseyen bir kodda `HashSet`'in dolaşma sırasına ASLA güvenme.

## LinkedHashSet: Eklenme Sırasını Korumak

`HashSet`'in dolaşma sırası öngörülemezken, bazen "tekrarları ele ama eklenme sırasını da koru" istersin. `LinkedHashSet` tam olarak bunu yapar: `HashSet`'in tüm davranışını korur, üzerine ince bir çift yönlü bağlı liste ekleyerek eklenme sırasını hatırlar -- bunun küçük bir bellek ve performans maliyeti vardır ama çoğu uygulamada gözle görülmez.

{{LinkedHashSetExample.java}}

## TreeSet: Sıralı Bir Set

`TreeSet`, elemanları eklenme sırasından bağımsız olarak **her zaman sıralı** tutar -- varsayılan olarak doğal sıralamaya (`Comparable`) göre, ya da constructor'a verilen bir `Comparator`'a göre. Ayrıca `NavigableSet` arayüzünü implement eder: `first()`/`last()`, `higher()`/`lower()` (kesin küçük/büyük), `ceiling()`/`floor()` (eşit ya da küçük/büyük), ve `headSet()`/`tailSet()` (bir noktadan önceki/sonraki alt küme) gibi sıralamaya özgü metotlar sunar.

{{TreeSetExample.java}}

> 💡 Tip
> `TreeSet`'in `add()`/`contains()`/`remove()` işlemleri `HashSet`'ten daha yavaştır (O(log n) vs O(1)) -- sıralamaya gerçekten ihtiyacın yoksa `HashSet` (sıra önemsizse) ya da `LinkedHashSet` (eklenme sırası önemliyse) daha iyi bir varsayılandır.

## equals() ve hashCode() Sözleşmesi

`HashSet`'in "bu eleman zaten var mı" kontrolü, elemanların `hashCode()` ve `equals()` metotlarına dayanır. Kendi yazdığın bir sınıf bu metotları override etmezse, `Object`'in varsayılanı kullanılır -- ki bu da "eşitlik" yerine yalnızca **aynı referans** (`==`) anlamına gelir. Sonuç: değerleri aynı görünen iki farklı nesne, `HashSet` tarafından FARKLI sayılır.

{{HashSetEqualsHashCodeExample.java}}

> ⚠️ Warning
> Bir sınıfı `HashSet` (ya da `HashMap`'in anahtarı) içinde kullanacaksan, `equals()`'ı override ettiğinde `hashCode()`'u da MUTLAKA override etmelisin -- ikisi birbiriyle tutarlı olmalıdır (`equals()` `true` dönen iki nesnenin `hashCode()`'u da aynı olmalıdır). Yalnızca birini override etmek, tam da yukarıdaki örnekte görülen türden sessiz, tespit etmesi zor hatalara yol açar.

## Set İşlemleri: Birleşim, Kesişim, Fark

`Set`, matematikteki küme işlemlerini üç metotla destekler: `addAll()` **birleşim** (union) yapar, `retainAll()` **kesişim** (intersection) alır (yalnızca her iki kümede de olanları tutar), `removeAll()` **fark** (difference) alır (diğer kümede olanları çıkarır).

{{SetOperationsExample.java}}

> ⚠️ Warning
> Bu üç metot da çağrıldıkları set'i **yerinde** (in-place) değiştirir -- orijinali korumak istiyorsan, önce (yukarıdaki örnekteki gibi) bir kopya oluşturup işlemi kopya üzerinde yapmalısın.

## Performans: List, HashSet ve TreeSet Karşılaştırması

`Set`'in var oluş sebebini ("Neden Var?" bölümü) gerçek bir ölçümle doğrulayalım: aynı 20.000 elemanlı koleksiyonda `contains()`'i binlerce kez çağırmak, `List`'te milisaniyeler alırken `HashSet`/`TreeSet`'te ölçülemeyecek kadar hızlıdır. Bu ölçekte `HashSet` (O(1)) ile `TreeSet` (O(log n)) arasındaki fark da göze çarpmaz -- ikisini gerçekten ayırt edebilmek için çok daha büyük bir koleksiyon ve çok daha fazla tekrar gerekir; bunu ikinci bir ölçümle gösteriyoruz.

{{SetPerformanceExample.java}}

Gerçek sonuçlar: 20.000 elemanlı bir koleksiyonda 2.000 kez `contains()`, `List`'te yaklaşık 70-90 ms sürerken `HashSet`/`TreeSet`'te 0 ms (ölçülemeyecek kadar hızlı). Ölçeği 200.000 elemana ve 200.000 tekrara çıkarınca aradaki fark ortaya çıkıyor: `HashSet` yaklaşık 9-10 ms, `TreeSet` yaklaşık 15-21 ms -- ikisi de `List`'ten kıyaslanamayacak kadar hızlı olsa da, O(1) ile O(log n) arasındaki teorik fark büyük ölçekte gerçekten ölçülebilir hâle geliyor.

## Best Practices

- **Bir koleksiyonda tekrar OLMAMASI gerektiğini biliyorsan, baştan `Set` kullan** -- `List` + elle `contains()` kontrolü hem daha yavaş hem daha hataya açıktır.
- **Sıra önemli değilse `HashSet`'i tercih et** -- en hızlı seçenektir. Eklenme sırası önemliyse `LinkedHashSet`, sıralı gezinmek gerekiyorsa `TreeSet` kullan.
- **`HashSet`/`HashMap` anahtarı olarak kullanacağın her sınıfta `equals()` ve `hashCode()`'u BİRLİKTE override et** -- IDE'lerin otomatik üretim özelliğini kullanmak elle yazmaktan daha güvenlidir.
- **Küme işlemlerinden (`addAll`/`retainAll`/`removeAll`) önce orijinali korumak istiyorsan bir kopya oluştur** -- bu metotlar yerinde değişiklik yapar.

## Yaygın Hatalar

- **`HashSet`'in dolaşma sırasının eklenme sırasıyla aynı olacağını varsaymak.** Bu garanti edilmez ve JDK sürümüne göre değişebilir -- sıra önemliyse `LinkedHashSet` kullan.
- **Özel bir sınıfı `HashSet`'e koyup `equals()`/`hashCode()`'u override etmeyi unutmak.** Sonuç: değerce eşit görünen nesneler yinelenen olarak eklenir, çünkü `Set` onları farklı sanır.
- **Yalnızca `equals()`'ı override edip `hashCode()`'u unutmak (ya da tersi).** İkisi tutarsız olduğunda `HashSet`'in davranışı öngörülemez hâle gelir.
- **Sıralamaya ihtiyaç yokken `TreeSet` kullanmak.** `HashSet`'ten daha yavaştır (O(log n) vs O(1)) -- yalnızca gerçekten sıralı gezinmek gerekiyorsa tercih edilmeli.

## Özet, Cheat Sheet ve Terimler Sözlüğü

`Set<E>`, tekrar eden elemanlara izin vermeyen bir koleksiyon arayüzüdür. `HashSet` en hızlı ama sırasızdır, `LinkedHashSet` eklenme sırasını korur, `TreeSet` elemanları her zaman sıralı tutar (`NavigableSet` metotlarıyla). `HashSet`'in doğru çalışması, elemanların `equals()`/`hashCode()`'unun tutarlı olmasına bağlıdır. `addAll()`/`retainAll()`/`removeAll()` sırasıyla birleşim/kesişim/fark alır.

Hızlı referans:

```java
Set<String> hash = new HashSet<>();          // en hızlı, sıra garantisi yok
Set<String> linked = new LinkedHashSet<>();   // eklenme sırasını korur
Set<String> tree = new TreeSet<>();            // her zaman sıralı (doğal ya da Comparator)
set.add(x);                                     // zaten varsa false döner, istisna fırlatmaz
Set<String> union = new HashSet<>(a); union.addAll(b);       // birleşim
Set<String> intersection = new HashSet<>(a); intersection.retainAll(b); // kesişim
Set<String> difference = new HashSet<>(a); difference.removeAll(b);     // fark
```

**Terimler Sözlüğü**

**Set** — Tekrar eden elemanlara izin vermeyen bir `Collection` alt arayüzü.

**HashSet** — `Set`'in hash tablosuyla çalışan, en hızlı (O(1)) ama sıra garantisi olmayan implementasyonu.

**LinkedHashSet** — `HashSet`'in eklenme sırasını da hatırlayan versiyonu.

**TreeSet** — Elemanları her zaman sıralı tutan, `NavigableSet` arayüzünü implement eden `Set` implementasyonu.

**hashCode()/equals() sözleşmesi** — `equals()` `true` dönen iki nesnenin `hashCode()`'unun da eşit olması gerektiğini belirten kural; `HashSet`/`HashMap`'in doğru çalışması buna bağlıdır.
