# Lists

Java Basics kategorisinde tekil değerleri, sabit sayıda alanları ve özel davranışları nasıl modelleyeceğini gördün. Ama gerçek programların çoğu, sayısı önceden bilinmeyen, çalışma zamanında büyüyüp küçülen veri toplulukları tutar -- bir alışveriş sepetindeki ürünler, bir formdan gelen hata mesajları, bir API'den dönen kayıtlar. Bu, Collections kategorisinin konusu; ilk durağımız da Java'nın en çok kullanılan koleksiyon tipi: `List`.

## List Nedir?

`List<E>`, `java.util.Collection` arayüzünü genişleten bir arayüzdür ve iki temel garanti sunar: elemanlar **sıralıdır** (eklenme sırası korunur) ve **indekslidir** (her elemana `get(index)` ile doğrudan erişilebilir). `Set`'in aksine, aynı değer bir `List`'te birden fazla kez bulunabilir.

`List` bir arayüz olduğu için doğrudan örneklenemez; en sık kullanılan iki implementasyonu `ArrayList` ve `LinkedList`'tir. İkisi de aynı sözleşmeyi (contract) uygular ama içeride tamamen farklı veri yapıları kullanır -- bu farkın pratikte ne anlama geldiğini birazdan gerçek bir ölçümle göreceğiz.

## Neden Var?

Java dizileri (array) sabit boyutludur -- bir `int[10]` oluşturduğunda, o dizi hep 10 elemanlıktır, ne bir eksik ne bir fazla. Ama gerçek dünyada eleman sayısı neredeyse hiç önceden bilinmez: kullanıcı sepete kaç ürün ekleyecek, bir sorgu kaç satır dönecek? `List`, bu problemi çözer -- `add()`/`remove()` ile dinamik olarak büyür/küçülür, dizinin sabit boyut kısıtını ortadan kaldırır.

## Tarihçe

`List` arayüzü, Java 1.2 (1998) ile gelen **Collections Framework**'ün parçası olarak tanıtıldı -- o zamana kadar Java'da yalnızca eski, senkronize (ve bu yüzden yavaş) `Vector` sınıfı vardı. `ArrayList`, `Vector`'ın senkronizasyon yükü olmayan modern karşılığı olarak aynı fazda geldi. Java 5 (2004) jenerikleri (`List<E>`) ekleyerek tip güvenliğini kazandırdı; Java 9 (2017) ise `List.of()` ile değiştirilemez (immutable) liste oluşturmayı kısayol hâline getirdi.

## Temel List İşlemleri

En sık kullanılan `List` metotları: `add()` (sona ekler), `get(index)` (okur), `set(index, value)` (üzerine yazar), `remove()` (değere ya da index'e göre siler), `size()`, `contains()`, `indexOf()`. Bir `List`'i for-each döngüsüyle dolaşmak da doğal olarak çalışır, çünkü `List` `Iterable`'ı genişletir.

{{ListBasicsExample.java}}

> ⚠️ Warning
> `remove()`'un iki aşırı yüklemesi (overload) vardır ve `List<Integer>` gibi kutulanmış (boxed) sayısal tiplerde karıştırılması kolaydır: `remove(int index)` index'e göre siler, `remove(Object o)` ise değere göre siler. `list.remove(2)` bir `List<Integer>` üzerinde çağrıldığında, `2` otomatik olarak `Integer`'a kutulanmaz -- doğrudan `int` olarak yorumlanır ve index 2'deki elemanı siler, değeri 2 olan elemanı değil. Değere göre silmek istiyorsan `list.remove(Integer.valueOf(2))` yazman gerekir.

## ArrayList ve LinkedList: İki Farklı Implementasyon

`ArrayList`, içeride büyüyebilen bir diziyle (dynamic array) çalışır -- `get(index)` doğrudan bellek adresine atlar, bu yüzden **O(1)**'dir. `LinkedList` ise çift yönlü bağlı bir listedir (doubly-linked list) -- her eleman bir öncekine ve bir sonrakine işaret eder; `get(index)`'in belirli bir index'e ulaşması için baştan (ya da sondan, hangisi yakınsa) o index'e kadar **tek tek ilerlemesi** gerekir, yani **O(n)**'dir.

Tersi de doğru: `ArrayList`'in başına eleman eklemek (`add(0, x)`), sonraki tüm elemanları bir sağa kaydırmayı gerektirir -- **O(n)**. `LinkedList`'in başına eklemek ise sadece birkaç referansı güncellemektir -- **O(1)**.

{{ArrayListVsLinkedListExample.java}}

Bu örnek, ısıtılmış (warmed-up) gerçek bir ölçümle şunu doğruluyor: 20.000 elemanlık bir listede, ortadaki elemana 3.000 kez `get()` ile erişmek `ArrayList`'te ölçülemeyecek kadar hızlı (0 ms) iken `LinkedList`'te milisaniyeler alıyor (yaklaşık 48 ms) -- çünkü her çağrı listenin yarısını baştan taramak zorunda. Buna karşılık, listenin başına 20.000 kez eleman eklemek `LinkedList`'te göz açıp kapayana kadar (yaklaşık 1 ms) biterken `ArrayList`'te belirgin şekilde daha uzun sürüyor (yaklaşık 16-17 ms) -- her ekleme, o ana kadarki tüm elemanları kaydırmak zorunda.

> 💡 Tip
> Pratikte neredeyse her zaman `ArrayList` doğru seçimdir -- rastgele erişim (`get(index)`) çok daha yaygın bir işlemdir ve modern donanımda bitişik bellek (contiguous memory) erişimi CPU önbelleği (cache) sayesinde ek bir hız avantajı da sağlar. `LinkedList`'i yalnızca gerçekten listenin başına/sonuna sık sık ekleme-çıkarma yapıyorsan (örneğin bir kuyruk/queue olarak) düşün.

## Immutable List'ler: List.of(), Collections.unmodifiableList(), List.copyOf()

Bazen bir listenin hiç değişmemesini garanti etmek istersin -- örneğin sabit bir yapılandırma listesi. Java üç farklı immutable liste aracı sunar ve aralarındaki fark önemlidir: `List.of(...)` sıfırdan değiştirilemez bir liste oluşturur; `Collections.unmodifiableList(list)` var olan bir listenin değiştirilemez bir **görünümünü** (view) döner -- orijinal liste hâlâ değişirse görünüm de değişir; `List.copyOf(list)` ise tamamen bağımsız, ayrı bir immutable **kopya** oluşturur.

{{ListOfImmutableExample.java}}

> ⚠️ Warning
> `Collections.unmodifiableList()`'in döndürdüğü listenin "salt okunur" olması, orijinal listenin de değişmeyeceği anlamına gelmez -- sadece görünüm üzerinden değiştirme engellenir. Gerçekten bağımsız, değişmeyen bir kopya istiyorsan `List.copyOf()` kullanmalısın.

## Iterator ve ListIterator

Bir `List`'i dolaşırken SIRASINDA elemanları silmek/eklemek istersen, doğrudan `List.remove()` çağırmak `ConcurrentModificationException` fırlatır -- çünkü for-each döngüsü arka planda bir `Iterator` kullanır ve `Iterator`, listenin "beklenmedik" şekilde değiştiğini fark eder. Doğru yol, `Iterator.remove()` metodunu kullanmaktır -- bu, iterator'ın kendi iç sayacını da günceller. `ListIterator`, `Iterator`'ın genişletilmiş hâlidir: hem ileri hem geri gidebilir (`hasPrevious()`/`previous()`) ve dolaşırken `set()`/`add()` de destekler.

{{IteratorExample.java}}

## Sıralama: List.sort() ve Comparator

`List.sort(Comparator)`, listeyi **yerinde** (in-place) sıralar -- yeni bir liste döndürmez, var olanı değiştirir. Argüman olarak `Comparator.naturalOrder()` (doğal sıralama), `Comparator.reverseOrder()` (ters), ya da `Comparator.comparing(...)` ile bir nesnenin belirli bir alanına göre özel bir sıralama verilebilir. `Collections.sort(list)`, `List.sort()`'tan (Java 8) önceki eski yoldur -- hâlâ çalışır ama artık `List.sort()` tercih edilir.

{{SortingExample.java}}

> 💡 Tip
> `Comparator.comparing(Person::name).thenComparing(Person::age)` gibi zincirleme, "önce isme göre sırala, isimler eşitse yaşa göre sırala" anlamına gelir -- birden fazla alana göre sıralama gerektiğinde elle yazılmış bir `compareTo()`'dan çok daha okunabilirdir.

## subList() ve toArray()

`subList(from, to)`, orijinal listenin `from` (dahil) ile `to` (hariç) arasındaki bir **görünümünü** (view) döner -- bağımsız bir kopya değildir. Bu görünüm üzerinde yapılan değişiklikler (ekleme, silme, `set()`) orijinal listeye de yansır. `toArray()`, bir `List`'i diziye çevirmenin üç yolunu sunar: argümansız hâli tip bilgisini kaybeden bir `Object[]` döner, `toArray(new String[0])` ya da (Java 11+) `toArray(String[]::new)` ise doğru tipte bir dizi üretir.

{{SubListAndToArrayExample.java}}

> ⚠️ Warning
> `subList()`'in bir kopya değil bir görünüm olması sık karşılaşılan bir tuzaktır -- görünüm üzerinde `clear()` çağırmak, orijinal listedeki o aralığı da siler. Bağımsız bir alt-liste istiyorsan `new ArrayList<>(numbers.subList(3, 6))` ile açıkça kopyalamalısın.

## Best Practices

- **Varsayılan olarak `ArrayList` kullanın**, yalnızca listenin başına/sonuna sık sık ekleme-çıkarma yapıyorsanız `LinkedList`'i (ya da daha iyisi, `ArrayDeque`'ı) düşünün.
- **Değişmeyecek bir liste için `List.of()`'u tercih edin** -- hem niyeti nettir hem de yanlışlıkla değiştirilmeyi derleme zamanı değil ama en azından ilk çalıştırmada `UnsupportedOperationException` ile yakalar.
- **Dolaşırken silme/ekleme gerekiyorsa `Iterator.remove()`/`ListIterator` kullanın**, doğrudan `List.remove()` çağırmayın.
- **Birden fazla alana göre sıralama için `Comparator.comparing(...).thenComparing(...)` zincirini kullanın** -- elle yazılmış `compareTo()`'dan daha az hataya açıktır.

## Yaygın Hatalar

- **`List<Integer>` üzerinde `remove(int)` ile `remove(Object)`'i karıştırmak.** `list.remove(2)`, index 2'yi siler; değeri 2 olan elemanı silmek için `list.remove(Integer.valueOf(2))` gerekir.
- **for-each döngüsü sırasında doğrudan `List.remove()` çağırmak.** Bu, `ConcurrentModificationException` fırlatır -- `Iterator.remove()` kullanılmalı.
- **`subList()`'in bağımsız bir kopya olduğunu sanmak.** Bir görünümdür; üzerindeki değişiklikler orijinal listeye yansır.
- **Rastgele erişimin (`get(index)`) yoğun olduğu bir senaryoda `LinkedList` seçmek.** `ArrayList`'in O(1) erişimine karşı `LinkedList`'in O(n) erişimi, büyük listelerde ölçülebilir bir performans farkına yol açar.

## Özet, Cheat Sheet ve Terimler Sözlüğü

`List<E>`, sıralı ve indeksli, tekrar eden elemanlara izin veren bir koleksiyon arayüzüdür. `ArrayList` rastgele erişimde (O(1)) hızlıdır, `LinkedList` ise listenin uçlarına ekleme/çıkarmada (O(1)) hızlıdır. `List.of()`/`List.copyOf()` değiştirilemez listeler oluşturur, `Collections.unmodifiableList()` ise mevcut bir listenin salt okunur bir görünümünü döner. Dolaşırken güvenli değişiklik için `Iterator`/`ListIterator`, sıralama için `List.sort(Comparator)` kullanılır.

Hızlı referans:

```java
List<String> list = new ArrayList<>();      // dinamik array tabanlı, varsayılan seçim
List<String> linked = new LinkedList<>();    // uçlara ekleme/çıkarma ağırlıklıysa
List<String> immutable = List.of("a", "b");  // değiştirilemez, sıfırdan
List<String> copy = List.copyOf(list);       // değiştirilemez, bağımsız kopya
List<String> view = Collections.unmodifiableList(list); // değiştirilemez GÖRÜNÜM
list.sort(Comparator.comparing(String::length));         // yerinde sıralama
List<String> part = new ArrayList<>(list.subList(1, 3)); // bağımsız alt-liste kopyası
```

**Terimler Sözlüğü**

**List** — Sıralı ve indeksli, tekrar eden elemanlara izin veren bir `Collection` alt arayüzü.

**ArrayList** — `List`'in dinamik diziyle çalışan, rastgele erişimde O(1) olan implementasyonu.

**LinkedList** — `List`'in çift yönlü bağlı listeyle çalışan, uçlara ekleme/çıkarmada O(1) olan implementasyonu.

**View (görünüm)** — `subList()`/`unmodifiableList()` gibi metotların döndürdüğü, orijinal veriyle bağlantısını koruyan (bağımsız kopya olmayan) bir nesne.

**ConcurrentModificationException** — Bir koleksiyon `Iterator` ile dolaşılırken, o iterator'ın dışından değiştirildiğinde fırlatılan istisna.
