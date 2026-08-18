# Wrapper Classes & Autoboxing

Java Basics kategorisinin dördüncü konusu Wrapper Classes (Sarmalayıcı Sınıflar) ve Autoboxing (otomatik kutulama) -- `int`, `double`, `boolean` gibi ilkel (primitive) tiplerin NESNE karşılıkları ve derleyicinin bu ikisi arasında sizin için otomatik yaptığı dönüşüm. Basit görünse de, `Integer` önbelleklemesi (`==` tuzağı) ve `null` unboxing'in fırlattığı gerçek `NullPointerException`'lar gibi ince davranışlar barındırır.

## Wrapper Class Nedir?

Java'daki her ilkel tipin bir NESNE karşılığı vardır: `int` → `Integer`, `double` → `Double`, `boolean` → `Boolean`, `char` → `Character`, `long` → `Long`, `short` → `Short`, `byte` → `Byte`, `float` → `Float`. Bunlara wrapper (sarmalayıcı) sınıf denir çünkü her biri, bir ilkel değeri bir NESNE içinde "sarar". Autoboxing, derleyicinin bir ilkel değeri otomatik olarak wrapper nesnesine dönüştürmesidir (`Integer i = 5;`); autounboxing ise tersi yöndeki otomatik dönüşümdür (`int x = i;`).

## Neden Var?

İlkel tipler doğrudan generic'lerle KULLANILAMAZ -- `List<int>` derlenmez, çünkü Java generic'leri yalnızca referans tipleriyle çalışır (bkz. "Reflection" dersindeki type erasure notu). Wrapper sınıfları, sayıları/booleanları bir `List<Integer>` gibi bir koleksiyona koymayı mümkün kılan köprüdür. Ayrıca bir ilkel tip ASLA `null` olamaz (`int x = null;` derlenmez) ama bir wrapper nesnesi olabilir -- bu, "değer yok" durumunu temsil etmek gerektiğinde (örneğin bir veritabanı sütunu NULL olabiliyorsa) kritik bir farktır. Wrapper sınıfları ayrıca `MAX_VALUE`/`MIN_VALUE` gibi sabitler ve `parseInt()` gibi yardımcı metotlar da taşır.

## Tarihçe

Wrapper sınıfları Java'nın 1.0 sürümünden (1996) beri var -- ama o zamanlar bir ilkeli bir wrapper'a dönüştürmek (`new Integer(5)`) ya da tersini yapmak (`i.intValue()`) tamamen ELLE yapılıyordu. Autoboxing/autounboxing, generic'ler ve enum'larla birlikte Java 5'te (2004) geldi -- derleyicinin bu dönüşümü SİZİN İÇİN otomatik yapması, generic koleksiyonların (`List<Integer>` gibi) günlük kullanımda pratik hâle gelmesini sağladı. `Integer` önbellekleme (-128 ile 127 arası) de yine bu dönemde, bellek optimizasyonu amacıyla eklendi.

## Temel Kullanım: Autoboxing ve Autounboxing

Bir ilkel değeri bir wrapper değişkenine atamak (`Integer i = 5;`) derleyicinin arka planda `Integer.valueOf(5)` çağırmasıyla eşdeğerdir -- bu AUTOBOXING'dir. Tersi yönde, bir wrapper'ı aritmetik bir ifadede kullanmak (`i + 1`) derleyicinin `i.intValue()` çağırmasıyla eşdeğerdir -- bu da AUTOUNBOXING'dir. `parseInt()` bir İLKEL döner, `valueOf()` ise bir WRAPPER NESNESİ döner (mümkünse önbellekten).

{{WrapperBasicsExample.java}}

> 💡 Tip
> Bir ilkel ASLA `null` olamaz ama bir wrapper nesnesi olabilir -- bu, wrapper sınıflarının var olma nedenlerinden biridir ("değer atanmamış" ya da "bilinmiyor" durumunu temsil edebilmek).

## Integer Önbellekleme: == Tuzağı

JVM, -128 ile 127 arasındaki değerler için `Integer` nesnelerini ÖNBELLEKLER ("Integer Cache") -- bu aralıktaki bir değer için `Integer.valueOf()` (autoboxing'in arka planda çağırdığı metot) her seferinde AYNI önbelleklenmiş nesneyi döner, yeni bir nesne oluşturmaz. Bu aralığın DIŞINDA ise her autoboxing YENİ bir nesne yaratır -- bu yüzden `==` bazen (tesadüfen) `true`, bazen `false` döner.

{{IntegerCachingExample.java}}

> ⚠️ Warning
> Bu, "String" dersindeki string pool `==` vs `equals()` tuzağıyla BİREBİR AYNI mantıktır -- yalnızca tetikleyici farklıdır (literal vs. `new String(...)` yerine, -128..127 değer aralığı). Kural aynı: wrapper nesnelerini KARŞILAŞTIRIRKEN asla `==` kullanmayın, her zaman `equals()` kullanın (ya da önce ilkel tipe unboxing yapın).

## Autoboxing'in Gizli Tehlikesi: null Unboxing

`null` bir wrapper'ı aritmetik bir ifadede kullanmak, derleyicinin arka planda `.intValue()` (ya da benzeri) çağırmasına, yani AUTOUNBOXING'e yol açar -- ama nesne `null` olduğu için bu, sessizce `0` DEĞİL, gerçek bir `NullPointerException` fırlatır. Bu tuzak özellikle `Map.get()` gibi "bulunamazsa `null` döner" davranışına sahip metotlarla sıkça karşılaşılır.

{{AutoboxingNullPointerExample.java}}

> ⚠️ Warning
> `Map<String, Integer>.get(anahtar)`, anahtar yoksa `null` döner -- bu sonucu doğrudan bir `int` değişkenine atamak (`int x = map.get(anahtar);`) SESSİZCE unboxing yapar ve anahtar bulunamadığında `NullPointerException` fırlatır. Güvenli desen: sonucu bir `Integer` (wrapper) olarak tutup `null` kontrolü yapmak, ya da `getOrDefault()` kullanmak.

## Autoboxing'in Performans Maliyeti

Bir wrapper nesnesi (`Long` gibi) üzerinde `+=` yapmak, her adımda ÜÇ işlem gerektirir: unboxing, toplama, ve YENİ bir wrapper nesnesi olarak yeniden boxing -- bir ilkel (`long`) üzerinde `+=` yapmak ise hiçbir nesne tahsis etmez. Bu fark, özellikle sıkı döngülerde (tight loop) gerçek bir performans maliyetine dönüşür.

{{AutoboxingPerformanceExample.java}}

Gerçek ölçüm (ısıtılmış -- her iki yol da ölçümden önce 2 milyon tur çalıştırıldı): 20 milyon sayıyı bir döngüde toplarken ilkel `long` biriktirici tutarlı şekilde ~7 ms sürdü, wrapper `Long` biriktirici ise ~35-39 ms sürdü (birden fazla çalıştırmada tutarlı çıktı) -- autoboxing'in her döngü adımında yarattığı gizli nesne tahsisinin gerçek maliyetini doğruladı.

## Wrapper Sınıflarının Yardımcı Metotları

Her sayısal wrapper sınıfı bir `parseXxx()` (metin → ilkel), `compare()` (unboxing gerektirmeden karşılaştırma), ve taban dönüşüm metotları (`toBinaryString()`, `toHexString()`) sunar. `Character` sınıfı ise `isDigit()`/`isLetter()`/`isWhitespace()` gibi sınıflandırma yardımcıları taşır.

{{WrapperUtilityMethodsExample.java}}

> 💡 Tip
> `Integer.parseInt()` geçersiz bir metinle çağrıldığında `NumberFormatException` fırlatır -- sessizce `0` DÖNMEZ. Kullanıcı girdisini ayrıştırırken bu istisnayı ele almak (bkz. "Scanner" dersindeki `InputMismatchException` paraleli) gerekir.

## Wrapper Sınıfları ve Koleksiyonlar

Generic koleksiyonlar (`List<T>` gibi) yalnızca REFERANS tipleriyle çalışır -- `List<int>` derlenmez. Wrapper sınıfları, sayıları bir `List<Integer>`'a koymayı mümkün kılan köprüdür: bir ilkeli eklemek otomatik olarak BOXING yapar, geliştirilmiş for döngüsüyle (`for (int x : list)`) okumak ise otomatik olarak UNBOXING yapar.

{{WrapperInCollectionsExample.java}}

## Best Practices

- **Wrapper nesnelerini karşılaştırırken her zaman `equals()` kullanın, asla `==` değil** -- `Integer` önbelleklemesi yüzünden `==` bazı değerlerde tesadüfen doğru sonuç verir, ama güvenilir değildir.
- **`Map.get()` gibi `null` dönebilecek bir sonucu doğrudan bir ilkel değişkene atamayın** -- önce `null` kontrolü yapın ya da `getOrDefault()` kullanın.
- **Sıkı döngülerde (özellikle toplama/sayaç gibi işlemlerde) wrapper tipler yerine ilkel tipler kullanın** -- her `+=` adımında gizli nesne tahsisinden kaçının.
- **Bir sayıyı metinden ayrıştırırken `NumberFormatException`'ı ele almayı unutmayın** -- kullanıcı girdisi her zaman güvenilir değildir.

## Yaygın Hatalar

- **İki `Integer` nesnesini `==` ile karşılaştırıp -128..127 aralığında `true`, dışında `false` almak.** Integer önbelleklemesi yüzünden bu tutarsız bir davranıştır -- her zaman `equals()` kullanılmalı.
- **`null` bir wrapper'ı aritmetik bir ifadede kullanıp beklenmedik bir `NullPointerException` almak.** Özellikle `Map.get()` sonucunu doğrudan bir ilkel değişkene atarken sıkça karşılaşılır.
- **Sıkı bir döngüde wrapper tip (`Long`, `Integer`) kullanıp performans kaybına uğramak.** Her `+=` gizlice unboxing + boxing + yeni nesne tahsisi anlamına gelir -- ilkel tipler kullanılmalı.
- **`Integer.parseInt()`'in geçersiz girdide `0` döneceğini varsaymak.** Aslında `NumberFormatException` fırlatır -- bu ele alınmalı.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Wrapper sınıfları, her ilkel tipin NESNE karşılığıdır (`int` → `Integer` vb.) -- generic koleksiyonlarda kullanılabilmelerini ve `null` temsil edebilmelerini sağlar. Autoboxing/autounboxing, derleyicinin ilkel ↔ wrapper dönüşümünü otomatik yapmasıdır. `Integer` önbelleklemesi (-128..127), `==` ile karşılaştırmayı tutarsız hâle getirir -- her zaman `equals()` kullanılmalı. `null` bir wrapper'ı unboxing yapmak `NullPointerException` fırlatır; sıkı döngülerde wrapper kullanmak gizli bir performans maliyeti taşır.

Hızlı referans:

```java
Integer boxed = 5;                          // autoboxing (Integer.valueOf(5))
int unboxed = boxed + 1;                      // autounboxing (boxed.intValue())

Integer a = 100, b = 100;                       // -128..127 içinde -- önbellekten
a == b;                                           // true (ama GÜVENME, tesadüf)
a.equals(b);                                        // true -- her zaman bunu kullan

Integer nullable = null;
int x = nullable + 1;                                // NullPointerException!

int fromText = Integer.parseInt("42");                 // metin -> ilkel
List<Integer> list = new ArrayList<>();                  // wrapper generic'lerde şart
list.add(5);                                                // autoboxing
```

**Terimler Sözlüğü**

**Wrapper Class** — Bir ilkel tipin (örn. `int`) nesne karşılığı (örn. `Integer`).

**Autoboxing** — Derleyicinin bir ilkel değeri otomatik olarak wrapper nesnesine dönüştürmesi.

**Autounboxing** — Derleyicinin bir wrapper nesnesini otomatik olarak ilkel değere dönüştürmesi.

**Integer Cache** — JVM'in -128 ile 127 arasındaki `Integer` değerleri için önbelleklediği, paylaşılan nesneler havuzu.

**NullPointerException** — `null` bir wrapper'ın unboxing yapılmaya çalışılması gibi durumlarda fırlatılan, çalışma zamanı istisnası.
