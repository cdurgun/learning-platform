# Maps

"Sets" dersinde her elemanın bir koleksiyonda yalnızca bir kez bulunmasını garanti eden `Set`'i gördün. `Map` bu fikri bir adım öteye taşır: her **anahtarın** (key) yalnızca bir kez bulunmasını garanti eder, ama her anahtarı bir **değere** (value) eşler. Bir sözlükteki kelime-tanım ilişkisini, bir kullanıcı ID'si ile kullanıcı profili ilişkisini, ya da bir kelimenin bir metinde kaç kez geçtiğini tutmak -- bunların hepsi `Map`'in doğal kullanım alanıdır.

## Map Nedir?

`Map<K, V>`, anahtar-değer çiftlerini (key-value pair) tutan bir arayüzdür -- dikkat: `Collection`'ı GENİŞLETMEZ, Collections Framework'ün ayrı bir kolu olarak durur. Her anahtar (`K`) benzersizdir, ama değerler (`V`) tekrar edebilir. `Set`'e çok benzer üç ana implementasyonu vardır: `HashMap` (hash tablosu, sıra garantisi yok, en hızlı), `LinkedHashMap` (`HashMap` + eklenme sırasını hatırlar), ve `TreeMap` (anahtarları her zaman sıralı tutar).

## Neden Var?

Bir `List`'te "bu ID'ye sahip kullanıcıyı bul" gibi bir arama yapmak, listeyi baştan sona taramayı (O(n)) gerektirir. `Map`, anahtarla doğrudan erişim sunar -- `map.get(id)`, `HashMap` için ortalama O(1)'dir, listenin boyutundan bağımsız olarak neredeyse anında sonuç verir. Herhangi bir "X'e göre Y'yi bul" ihtiyacı olduğunda -- ki bu programlamada son derece yaygındır -- `Map` doğru araçtır.

## Tarihçe

`Map` arayüzü de Java 1.2 (1998) ile gelen Collections Framework'ün parçasıdır -- ama `Collection`'ın DIŞINDA, kendi ayrı hiyerarşisinde tanımlanır (çünkü iki parametreli, `Iterable<E>` değil `Map<K,V>` şeklinde bir yapıya ihtiyaç duyar). `HashMap`, eski `Hashtable` sınıfının senkronizasyon yükü olmayan modern karşılığı olarak aynı sürümle geldi. Java 8 (2014), `Map`'e `getOrDefault()`, `putIfAbsent()`, `computeIfAbsent()`, `merge()` gibi -- bu dersin ilerleyen bölümlerinde göreceğimiz -- güçlü varsayılan (default) metotlar ekledi.

## Temel Map İşlemleri

`Map`'in temel metotları: `put(key, value)` (ekler ya da üzerine yazar), `get(key)` (okur, anahtar yoksa `null` döner -- istisna fırlatmaz), `remove(key)`, `containsKey()`, `containsValue()`, `size()`. Bir `Map`'i dolaşmanın en doğal yolu `entrySet()`'tir -- her adımda hem anahtarı hem değeri tek seferde verir.

{{MapBasicsExample.java}}

> ⚠️ Warning
> `Map`'in anahtar olarak kullanılan sınıfların `equals()`/`hashCode()`'u tutarlı olmalıdır -- tıpkı "Sets" dersindeki "equals() ve hashCode() Sözleşmesi" bölümünde `HashSet` için anlatılan kuralın aynısı. Bir sınıf bu metotları doğru override etmezse, `HashMap` "değerce aynı" görünen iki anahtarı FARKLI sanabilir ve beklenmedik şekilde iki ayrı giriş oluşturabilir.

## LinkedHashMap: Eklenme Sırasını Korumak

`HashMap`'in dolaşma sırası öngörülemezken, `LinkedHashMap` `HashMap`'in tüm davranışını korur ve üzerine eklenme sırasını hatırlayan ince bir bağlı liste ekler.

{{LinkedHashMapExample.java}}

> 💡 Tip
> `LinkedHashMap`'in daha az bilinen bir kullanımı, basit bir LRU (least-recently-used) önbellek yazmaktır -- constructor'a `accessOrder=true` verilip `removeEldestEntry()` override edildiğinde, `LinkedHashMap` en son erişilen sırayı tutmaya başlar ve en eski girdiyi otomatik atabilir.

## TreeMap: Sıralı Bir Map

`TreeMap`, `TreeSet`'in `Map` karşılığıdır -- anahtarları eklenme sırasından bağımsız olarak her zaman sıralı tutar ve `NavigableMap` arayüzünü implement eder: `firstKey()`/`lastKey()`, `higherKey()`/`lowerKey()`, `ceilingKey()`/`floorKey()`, `headMap()`/`tailMap()`.

{{TreeMapExample.java}}

## Immutable Map'ler: Map.of(), Map.entry(), Collections.unmodifiableMap()

Tıpkı `List`/`Set` gibi, `Map`'in de değiştirilemez sürümleri vardır: `Map.of(...)` en fazla 10 çift için kısa bir syntax sunar; daha fazla çift ya da dinamik oluşturma gerektiğinde `Map.ofEntries(Map.entry(...), ...)` kullanılır; `Collections.unmodifiableMap()` mevcut bir map'in salt okunur bir GÖRÜNÜMÜNÜ döner; `Map.copyOf()` ise bağımsız bir KOPYA oluşturur.

{{ImmutableMapExample.java}}

## Modern Map API: getOrDefault(), computeIfAbsent(), merge()

Java 8'in eklediği bu metotlar, çok sık karşılaşılan "map deseni"lerini tek satıra indirger. `getOrDefault()`, anahtar yoksa `null` yerine bir varsayılan değer döner. `putIfAbsent()`, yalnızca anahtar yoksa ekler. `merge()`, bir sayaç/toplama deseninin (örneğin kelime sayımı) klasik yolu -- anahtar yoksa başlangıç değerini kullanır, varsa verilen fonksiyonla birleştirir. `computeIfAbsent()`, gruplama deseninin (örneğin `Map<K, List<V>>`) klasik yolu -- anahtar yoksa yeni bir konteyner oluşturur.

{{ModernMapMethodsExample.java}}

> ⚠️ Warning
> `merge()`/`computeIfAbsent()`'ten önce yaygın olan eski yaklaşım -- `if (!map.containsKey(key)) map.put(key, ...)` ardından `map.put(key, map.get(key) + 1)` -- hem daha uzun hem de aynı anahtara İKİ ayrı sözlük araması (`containsKey` + `get`) yapar. Modern metotlar tek bir aramada işi bitirir.

## Dolaşma Performansı: entrySet() vs keySet() + get()

`Map`'i dolaşırken hem anahtara hem değere ihtiyacın varsa, `keySet()` üzerinde dolaşıp her adımda ayrıca `get(key)` çağırmak cazip görünebilir -- ama bu, her eleman için GEREKSİZ bir ikinci sözlük araması yapar. `entrySet()`, anahtarı ve değeri tek bir adımda, tek bir aramayla verir.

{{MapIterationPerformanceExample.java}}

Gerçek ölçüm: 200.000 girişlik bir `HashMap`'te tüm değerleri 50 kez toplamak, `entrySet()` ile yaklaşık 120-145 ms sürerken `keySet() + get()` ile yaklaşık 140-170 ms sürüyor -- `entrySet()` tutarlı şekilde daha hızlı, çünkü her eleman için gereksiz ikinci bir arama yapmıyor.

## Best Practices

- **Anahtara göre hızlı arama gerektiğinde `Map` kullan** -- bir `List`'i elle tarayan bir döngüden neredeyse her zaman daha hızlı ve daha okunabilirdir.
- **Hem anahtara hem değere ihtiyacın varsa `entrySet()` ile dolaş**, `keySet()` + `get()` kombinasyonu değil -- gereksiz ikinci bir arama yapmaktan kaçınır.
- **Sayma/toplama desenleri için `merge()`, gruplama desenleri için `computeIfAbsent()` kullan** -- elle yazılmış `containsKey()`/`get()`/`put()` üçlüsünden hem daha kısa hem daha az hataya açıktır.
- **`Map` anahtarı olarak kullanacağın her özel sınıfta `equals()`/`hashCode()`'u birlikte override et** -- aksi hâlde `HashMap`'in davranışı öngörülemez hâle gelir.

## Yaygın Hatalar

- **`get()`'in `null` dönebileceğini unutup doğrudan sonucu kullanmak.** Anahtar yoksa `get()` `null` döner (istisna fırlatmaz) -- `getOrDefault()` kullanmak ya da `null` kontrolü yapmak gerekir.
- **`keySet()` üzerinde dolaşıp her adımda ayrıca `get()` çağırmak.** Bu, her eleman için gereksiz bir ikinci arama yapar -- `entrySet()` kullanılmalı.
- **`equals()`/`hashCode()`'u override etmeyen bir sınıfı `HashMap` anahtarı yapmak.** Sonuç: "değerce aynı" görünen anahtarlar farklı sayılır, beklenmedik yinelenen girişler oluşur.
- **Sayaç deseninde `containsKey()` + `get()` + `put()` üçlüsünü elle yazmak.** `merge()` aynı işi tek satırda, tek aramayla yapar.

## Özet, Cheat Sheet ve Terimler Sözlüğü

`Map<K, V>`, benzersiz anahtarları değerlere eşleyen bir arayüzdür (`Collection`'ı genişletmez). `HashMap` en hızlı ama sırasızdır, `LinkedHashMap` eklenme sırasını korur, `TreeMap` anahtarları her zaman sıralı tutar. `Map.of()`/`Map.copyOf()` immutable map'ler oluşturur. `getOrDefault()`/`putIfAbsent()`/`computeIfAbsent()`/`merge()`, yaygın map desenlerini tek satıra indirger. Dolaşırken `entrySet()`, `keySet()` + `get()`'ten daha hızlıdır.

Hızlı referans:

```java
Map<String, Integer> hash = new HashMap<>();          // en hızlı, sıra garantisi yok
Map<String, Integer> linked = new LinkedHashMap<>();   // eklenme sırasını korur
Map<String, Integer> tree = new TreeMap<>();            // her zaman anahtara göre sıralı
map.getOrDefault(key, 0);                                 // varsayılan değerle oku
map.putIfAbsent(key, value);                                // yalnızca yoksa ekle
map.merge(key, 1, Integer::sum);                              // sayma/toplama deseni
map.computeIfAbsent(key, k -> new ArrayList<>()).add(value);    // gruplama deseni
for (Map.Entry<String, Integer> e : map.entrySet()) { ... }      // doğru dolaşma yolu
```

**Terimler Sözlüğü**

**Map** — Benzersiz anahtarları değerlere eşleyen, `Collection`'ı genişletmeyen ayrı bir Collections Framework arayüzü.

**HashMap** — `Map`'in hash tablosuyla çalışan, en hızlı (O(1)) ama sıra garantisi olmayan implementasyonu.

**LinkedHashMap** — `HashMap`'in eklenme sırasını da hatırlayan versiyonu.

**TreeMap** — Anahtarları her zaman sıralı tutan, `NavigableMap` arayüzünü implement eden `Map` implementasyonu.

**entrySet()** — Bir `Map`'in tüm anahtar-değer çiftlerini `Map.Entry<K,V>` nesneleri olarak döner; dolaşmanın en verimli yoludur.
