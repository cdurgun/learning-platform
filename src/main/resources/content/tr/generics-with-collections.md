Bu serideki her mekanik şimdiye kadar — generic sınıflar, generic metotlar, sınırlar, wildcard'lar — çoğunlukla `Box<T>` gibi küçük, uydurma türler kullanarak odağı mekanizmanın kendisinde tuttu. Ama pratikte, generics'i gerçekten kullanacağın en yaygın yer Java'nın kendi koleksiyon çerçevesidir. Bu ders özellikle `List<T>`, `Set<T>` ve `Map<K, V>`'ye bakıyor, ve "Wildcard'lar"ın yalnızca geçerken motive ettiği bir soruyu kapatıyor: `List<String>` ve `List<Object>` neden tam olarak ilgisiz türlerdir.

## Generic Koleksiyonlar: List, Set ve Map

`List<T>`, `Set<T>` ve `Map<K, V>`, "Generics'e Giriş"te işlenen tam olarak aynı mekanizmayla inşa edilmiş, kendileri de sıradan generic türlerdir — `List`'in elemanları için bir tür parametresi vardır, `Map`'in ise ikisi vardır, biri key'leri biri value'ları için.

{{GenericCollectionApisExample.java}}

Aynı üç interface, ne tuttuklarından bağımsız olarak birebir aynı şekilde çalışır — `List<String>` ve `List<Integer>`, aynı `List`'tir, `Set<String>` ve `Set<Boolean>`, aynı `Set`'tir. Koleksiyon API'lerinin kendisiyle ilgili hiçbir şey değişmez; yalnızca tür argümanı değişir.

## Koleksiyonlarla Tür Güvenliği

"Generics'e Giriş"te genel olarak işlenen derleme-zamanı kontrolü, her koleksiyon işlemine — `add`, `put`, `get` — uygulanır, yalnızca oluşturmaya değil.

{{CollectionTypeSafetyExample.java}}

Bir `List<String>` üzerinde `names.add(42)` ve bir `Map<String, Integer>` üzerinde `ages.put("Alice", "thirty")`, ikisi de derleme zamanında reddedilir, iki hata da hiç çalışan bir programa ulaşamadan önce. `names.get(0)` ya da `ages.get("Alice")` ile geri okumak da aynı nedenle hiçbir cast gerektirmez — derleyici tam olarak hangi türün saklandığını zaten bilir.

## List<Object> Neden List<String> Değildir

"Wildcard'lar" bu kuralı motivasyon olarak kısaca tanıttı; işte daha eksiksiz resim. Generics DEĞİŞMEZDİR (invariant): `String` bir `Object` OLSA bile, `List<String>` ve `List<Object>`, hiçbir yönde birbirinin yerine geçemeyen, tamamen ilgisiz iki tür olarak ele alınır.

{{ListInvarianceExample.java}}

`List<String>`'in bir `List<Object>` beklenen yerde geçirilmesine İZİN VERİLSEYDİ, `addNumber(...)`, çağıranın yalnızca `String`'lerden oluştuğuna inandığı bir listeye bir `Integer` ekleyebilirdi — tür sisteminin daha sonra yakalamanın hiçbir yolu olmayan, bozulmuş bir söz. Değişmezlik, tam olarak bunu önleyen şeydir: `List<String>`, yalnızca bir `List<String>`'in (ya da "Wildcard'lar"ın işlediği gibi, her `List`'in zaten sağladığı bir `List<? extends Object>`'in) beklendiği yerde geçirilebilir.

> 💡 Tip
> Bir metodun bilinmeyen ya da ilişkili bir eleman türünden bir `List`i gerçekten kabul etmesi gerektiğinde, "Wildcard'lar"daki wildcard formlarına (`List<?>`, `List<? extends T>`, `List<? super T>`) başvur — bu değişmezlik kuralının gerekli kıldığı tam olarak bu araçtır.

## Koleksiyonlarla Tür Çıkarımı

Bir koleksiyon oluşturmak, tür argümanının iki kez tekrarlanmasını gerektirmez — Java bunu bağlamdan iki yaygın şekilde çıkarır.

{{DiamondOperatorInferenceExample.java}}

Diamond operatörü, `<>`, bir constructor'ın tür argümanını atandığı değişkenden çıkarır — bir `List<String>` değişkenine atanan `new ArrayList<>()`, `String`'i tekrar yazmadan bir `ArrayList<String>` olur. `var` ise bunun yerine değişkenin kendi türünü, sağ taraftaki her neyse ondan çıkarır — `var scores = List.of(90, 85, 78)`, `scores`'a, tamamen `List.of(...)`'un argümanlarından çıkarılan `List<Integer>` türünü verir.

## Pratik Bir Örnek

Generic koleksiyonlar, günlük Java kodunun bel kemiğidir — sayma, gruplama ve arama neredeyse her zaman bir `Map` ya da bir `List` üzerinden geçer.

{{PracticalWordFrequencyExample.java}}

`countWords(...)`, bir kelime array'inden `merge(...)` kullanarak her kelimenin sayısını artıran bir `Map<String, Integer>` inşa ediyor — bu derste işlenen tür güvenliğine ve çıkarımına tamamen dayanan, hiçbir yerde cast olmayan sıradan, pratik kod.

## Best Practices

- Değişken ve parametre türü olarak somut implementasyonlar (`ArrayList`, `HashMap`) yerine koleksiyon interface'lerini (`List`, `Set`, `Map`) tercih et — bu, "Interface"in genel kılavuzunu yansıtır ve generic koleksiyon türleri için de aynı derecede geçerlidir.
- Açıkça türlenmiş bir değişkenle bir koleksiyon oluştururken varsayılan olarak diamond operatörünü kullan — tür argümanını her iki tarafta da tekrarlamak için nadiren bir neden vardır.
- Bir koleksiyonun türü zaten başlatıcısından belli olduğunda `var`'a başvur, ama belirgin olmayan bir durumda okunabilirliği artırdığında açık türü koru.
- Bir metodun ilişkili ama aynı olmayan bir eleman türünden bir `List`i kabul etmesi gerektiğinde, değişmezliği başka bir şekilde aşmaya çalışmak yerine ("Wildcard'lar"dan) bir wildcard kullan.

## Yaygın Hatalar

- Bir `List<String>`'i bir `List<Object>` beklenen yerde geçirmeye çalışıp derleyicinin bunu reddetmesine şaşırmak — bu, bir derleyici kısıtı değil, değişmezliğin tam olarak tasarlandığı gibi çalışması.
- Bir `Map<K, V>`'nin tür güvenliğinin key'leri ve value'ları birbirinden bağımsız olarak kapsadığını unutmak — `put(...)` ve `get(...)`, ikisi de kendi tür parametrelerine göre kontrol edilir.
- Bir bildirimin sağ tarafına diamond operatörü yerine tam generic türü yazmak (`List<String> names = new ArrayList<String>();`), saf bir tekrar eklemek.
- `var`'ın bir değişkenin türünü "daha az sıkı" yaptığını ya da tür güvenliğini kaldırdığını varsaymak — yalnızca türü YAZMA ihtiyacını kaldırır; derleyici, sanki açıkça yazılmış gibi onu aynen zorlamaya devam eder.

## Özet, Cheat Sheet ve Terimler Sözlüğü

**Özet**

- `List<T>`, `Set<T>` ve `Map<K, V>`, herhangi bir özel generic sınıfla aynı mekanizmayla inşa edilmiş, sıradan generic türlerdir.
- Koleksiyon işlemleri (`add`, `put`, `get`), hepsi koleksiyonun bildirilen tür argümanlarına göre derleme zamanında kontrol edilir.
- `List<String>` ve `List<Object>`, generics değişmez olduğu için ilgisiz türlerdir -- bu, "Wildcard'lar"daki wildcard formlarını baştan gerekli kılan şeydir.
- Diamond operatörü (`<>`), bir constructor'ın tür argümanını bağlamdan çıkarır; `var`, bir değişkenin tüm türünü başlatıcısından çıkarır.
- Generic koleksiyonlar, generics'in günlük Java kodunda gerçekten en yaygın kullanıldığı yerdir.

**Cheat Sheet**

```java
// Üç temel generic koleksiyon türü
List<String> names = List.of("Alice", "Bob");
Set<String> unique = Set.of("Alice", "Bob");
Map<String, Integer> ages = Map.of("Alice", 30);

// Derleme zamanında kontrol edilen tür güvenliği
List<String> list = new ArrayList<>();
list.add("ok");
// list.add(42); // reddedilir

// Diamond operatörü vs var
List<String> a = new ArrayList<>();       // diamond, ArrayList<String>'i çıkarır
var b = List.of(1, 2, 3);                  // var, List<Integer>'ı çıkarır

// Değişmezlik
// List<Object> o = names; // reddedilir -- List<String>, List<Object> değildir
```

**Terimler Sözlüğü**

- **Generic koleksiyon**: tuttuğu tür(ler)le parametrelenmiş bir koleksiyon türü (`List`, `Set`, `Map`).
- **Değişmezlik (invariance)**: `A` ve `B` aynı tür olmadıkça, ilişkili olsalar bile `List<A>` ve `List<B>`'nin ilgisiz türler olduğu kuralı.
- **Diamond operatörü**: `<>`, bir constructor'ın tür argümanının atandığı değişkenden çıkarılmasını sağlar.
- **var**: bir yerel değişkenin tüm bildirilen türünü, hiçbir derleme-zamanı tür kontrolünü kaldırmadan, başlatıcısından çıkaran bir anahtar kelime.
