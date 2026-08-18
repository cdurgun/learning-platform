# Arrays

Java Basics kategorisinin ikinci konusu `Array` (dizi) -- `String` gibi çok temel ama altında dilin en eski, en düşük seviyeli veri yapısını barındırır. Diziler, `ArrayList`/`HashMap` gibi tüm koleksiyonların İÇİNDE kullanılan yapı taşıdır; onları anlamak, Collections kategorisindeki `O(1)` erişim gibi performans iddialarının GERÇEKTE nereden geldiğini de netleştirir.

## Array Nedir?

Bir array (dizi), AYNI TİPTEN sabit sayıda elemanı, bellekte ARDIŞIK (contiguous) bir blokta tutan bir veri yapısıdır. Boyutu oluşturulduğu anda belirlenir ve bir daha ASLA değişmez -- bu, `ArrayList` gibi "dinamik boyutlu" koleksiyonlardan en temel farkıdır. Java'da diziler, `int[]`/`String[]` gibi ilkel (primitive) görünseler de aslında birer NESNEdir (`Object`'ten türer) -- bu yüzden `.length` bir alan (field) olarak erişilir, `String.length()`'in aksine parantez GEREKTİRMEZ.

## Neden Var?

Bir index'e göre eleman okumak/yazmak, bitişik bellek yerleşimi sayesinde donanım düzeyinde doğrudan bir adres hesabıyla yapılabilir -- bu, dizileri O(1) index erişimi için mümkün olan EN HIZLI yapı yapar. `ArrayList` gibi üst düzey koleksiyonların O(1) `get(index)` performansı iddiası da tam olarak buradan gelir: `ArrayList` içeride bir array SARAR (wrap eder) ve büyüme gerektiğinde daha büyük yeni bir array'e kopyalar. Dizileri doğrudan anlamak, bu üst düzey koleksiyonların neden hızlı ya da yavaş olduğunu da açıklar.

## Tarihçe

Diziler Java'nın 1.0 sürümünden (1996) beri dilin çekirdek bir parçasıdır -- `String` gibi en eski yapılardan biri. `Arrays` yardımcı sınıfı (statik `sort()`/`binarySearch()`/`equals()` metotlarıyla) Java 1.2 (1998) ile Collections Framework'le birlikte geldi. Varargs (`Type... args`, bir dizi parametresinin çağrı tarafında rahat kullanılmasını sağlayan sözdizimi) Java 5 (2004) ile eklendi. Java 8 (2014), `Arrays.stream()` ile dizileri doğrudan Stream API'ye bağladı (bkz. "Stream Fundamentals" dersi).

## Temel Kullanım: Oluşturma, Erişim, Varsayılan Değerler

Bir dizi `new Type[boyut]` ile ya da bir LİTERAL (`{1, 2, 3}`) ile oluşturulabilir. İlkel tipli bir dizinin (`int[]` gibi) başlatılmamış elemanları varsayılan olarak `0`/`false` gibi bir değer alır; referans tipli bir dizinin (`String[]` gibi) elemanları ise `null` olur. Sınırların dışına çıkmak (`array[10]`, dizi boyutu 5 iken) SESSİZCE yanlış bir şey döndürmez -- gerçek bir `ArrayIndexOutOfBoundsException` fırlatır.

{{ArrayBasicsExample.java}}

> ⚠️ Warning
> Bir diziyi doğrudan `System.out.println(array)` ile yazdırmak, içeriğini GÖSTERMEZ -- `[I@7ea987ac` gibi bir "tip@hashcode" metni verir, çünkü `Object.toString()`'in varsayılan davranışı budur. İçeriği görmek için her zaman `Arrays.toString()` (tek boyutlu) ya da `Arrays.deepToString()` (çok boyutlu) kullanılmalı.

## Çok Boyutlu Diziler

Java'da bir "2 boyutlu dizi" aslında bir DİZİLER DİZİSİDİR (array of arrays) -- her "satır" kendi bağımsız bir dizi nesnesidir. Bu yüzden satırların uzunluğu FARKLI olabilir (buna "jagged array" -- düzensiz/pürüzlü dizi denir); dikdörtgen bir grid de yalnızca özel bir durumdur (tüm satırlar aynı uzunlukta).

{{MultiDimensionalArrayExample.java}}

> 💡 Tip
> `Arrays.toString()`, iç içe (nested) dizilerde YANLIŞ araçtır -- her satırı yine `[I@...` gibi bir hashcode metniyle gösterir, İÇERİĞE inmez. Çok boyutlu bir diziyi düzgün yazdırmak için `Arrays.deepToString()` kullanılmalı.

## Arrays Yardımcı Sınıfı

`Arrays`, `Collections`'a benzer şekilde (bkz. "Queues & Collections Utility" dersi), diziler üzerinde çalışan hazır statik metotlar sunan bir yardımcı sınıftır: `sort()` (yerinde sıralar), `binarySearch()` (SIRALI bir dizide O(log n) arama), `equals()` (İÇERİK karşılaştırması -- `==`'nin aksine), `fill()` (tüm elemanları aynı değere ayarlar), ve `copyOf()`/`copyOfRange()` (yeni bir dizi olarak kopyalar).

{{ArraysUtilityExample.java}}

> ⚠️ Warning
> İki diziyi `==` ile karşılaştırmak REFERANS'ı karşılaştırır (aynı bellek adresi mi), İÇERİĞİ değil -- tıpkı `String`'deki `==` vs `equals()` tuzağı gibi (bkz. "String" dersi). İki dizinin AYNI elemanlara sahip olup olmadığını kontrol etmek için `Arrays.equals()` kullanılmalı.

## Array Covariance: Derleyicinin Gözden Kaçırdığı Bir Tuzak

Java dizileri KOVARYANTTIR (covariant): `Integer`, `Number`'ı genişlettiği için bir `Integer[]`, bir `Number[]` değişkenine atanabilir. Ama bu, bir tuzak kapısı açar: derleyici, `Number[]` üzerinden bir `Double` YAZMAYA izin verir (çünkü `Double` de bir `Number`'dır) -- ama dizinin GERÇEK çalışma zamanı tipi hâlâ `Integer[]`'dir, bu yüzden bu yazma işlemi derleme zamanında DEĞİL, ÇALIŞMA ZAMANINDA (`ArrayStoreException` ile) patlar.

{{ArrayCovarianceExample.java}}

> 💡 Tip
> Generic'ler (`List<T>`) BİLEREK bu tuzağı önler: bir `List<Integer>`, bir `List<Number>` değişkenine ATANAMAZ (invariant'tır) -- yani array covariance'ın sakladığı bu tarz bir hata, generic koleksiyonlarda ÇALIŞMA ZAMANI yerine DERLEME ZAMANINDA yakalanır. Bu, "neden `List<Number> list = new ArrayList<Integer>();` derlenmiyor?" sorusunun cevabıdır.

## Arrays vs Collections: Arrays.asList() ve Dönüşümler

`Arrays.asList()`, verilen diziyi KOPYALAMAZ -- orijinal diziyi SABİT BOYUTLU bir `List` GÖRÜNÜMÜYLE (view) sarar. Bu görünüm üzerinden yazmak orijinal diziyi de değiştirir (ve tersi de geçerlidir); sabit boyutlu olduğu için `add()`/`remove()` desteklenmez (`UnsupportedOperationException` fırlatır), yalnızca `set()` (mevcut bir index'i değiştirmek) çalışır. Gerçekten bağımsız, yeniden boyutlanabilir bir liste için bu görünümü `new ArrayList<>(...)` içine SARMAK gerekir.

{{ArraysVsCollectionsExample.java}}

## Varargs: Diziyi Rahat Bir Çağrı Sözdizimiyle Kullanmak

Varargs (`Type... isim`), bir metodun ÇAĞIRAN tarafın sıfır, bir ya da birçok argüman geçmesine izin vermesini sağlayan bir sözdizimidir -- metodun İÇİNDE, bu parametre basitçe normal bir dizidir. Varargs parametresi bir metot imzasında yalnızca SON parametre olabilir.

{{VarargsExample.java}}

> 💡 Tip
> `System.out.printf()` ve `String.format()`'in kendisi de varargs kullanır (`Object... args`) -- bu sayede `%s`/`%d` gibi istediğiniz sayıda yer tutucuyu tek bir metotla karşılayabilirler (bkz. "String" dersi).

## Best Practices

- **Bir dizinin içeriğini yazdırmak için her zaman `Arrays.toString()` (tek boyutlu) ya da `Arrays.deepToString()` (çok boyutlu) kullanın**, doğrudan `System.out.println(array)` değil -- bu yalnızca anlamsız bir "tip@hashcode" metni verir.
- **İki dizinin içeriğini karşılaştırmak için `Arrays.equals()` kullanın**, `==` değil -- `==` yalnızca referans karşılaştırır, tıpkı `String`'deki gibi.
- **Boyutu programın çalışması sırasında değişecek bir koleksiyona ihtiyacınız varsa `ArrayList` gibi bir koleksiyon kullanın**, dizi değil -- diziler oluşturulduktan sonra yeniden boyutlandırılamaz.
- **`Arrays.asList()`'in bir GÖRÜNÜM olduğunu, kopya olmadığını unutmayın** -- bağımsız, yeniden boyutlanabilir bir liste istiyorsanız `new ArrayList<>(Arrays.asList(...))` ile sarın.

## Yaygın Hatalar

- **Bir diziyi doğrudan yazdırıp `[I@7ea987ac` gibi anlamsız bir çıktı almak.** `Arrays.toString()`/`Arrays.deepToString()` kullanılması gerekiyordu.
- **İki diziyi `==` ile karşılaştırıp içerik aynı olsa bile `false` almak.** İçerik karşılaştırması için `Arrays.equals()` gerekir.
- **`Arrays.asList()`'in döndürdüğü listeye `add()`/`remove()` çağırıp `UnsupportedOperationException` almak.** Bu görünüm sabit boyutludur -- gerçek bir `ArrayList`'e ihtiyaç varsa açıkça sarmalanmalı.
- **Array covariance'ın (bir `Integer[]`'in bir `Number[]` değişkenine atanabilmesinin) güvenli olduğunu varsaymak.** Bu, derleme zamanında yakalanmayan bir `ArrayStoreException` riski taşır -- generic koleksiyonlar bu riski taşımaz.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Bir array (dizi), aynı tipten sabit sayıda elemanı bitişik bellekte tutan, O(1) index erişimi sağlayan temel bir veri yapısıdır -- `ArrayList` gibi üst düzey koleksiyonların içinde kullanılan yapı taşıdır. `Arrays` yardımcı sınıfı `sort()`/`binarySearch()`/`equals()`/`fill()`/`copyOf()` gibi statik metotlar sunar. Diziler kovaryanttır ve bu yüzden bazı hatalar (generic koleksiyonların aksine) yalnızca çalışma zamanında yakalanır; `Arrays.asList()` orijinal diziyi saran sabit boyutlu bir görünümdür, kopya değildir.

Hızlı referans:

```java
int[] numbers = new int[5];                 // sabit boyutlu, varsayılan 0'larla
String[] fruits = {"apple", "banana"};         // literal ile oluşturma
Arrays.toString(numbers);                        // içeriği düzgün yazdırmak için
Arrays.sort(numbers);                              // yerinde sıralama
Arrays.equals(a, b);                                 // İÇERİK karşılaştırması (== değil)
Arrays.copyOf(numbers, 10);                            // yeni, daha büyük bir kopya
List<String> view = Arrays.asList(fruits);                // SABİT BOYUTLU görünüm, kopya değil
List<String> real = new ArrayList<>(Arrays.asList(fruits)); // bağımsız, resizable liste
```

**Terimler Sözlüğü**

**Array (Dizi)** — Aynı tipten sabit sayıda elemanı, bellekte ardışık bir blokta tutan temel bir veri yapısı.

**Jagged Array** — Satırları (alt dizileri) farklı uzunluklarda olabilen çok boyutlu bir dizi.

**Array Covariance** — Bir alt tip dizisinin (`Integer[]`) bir üst tip dizi değişkenine (`Number[]`) atanabilmesi; potansiyel olarak çalışma zamanı hatasına (`ArrayStoreException`) yol açabilir.

**Varargs** — Bir metodun çağrı tarafında sıfır ya da birçok argüman geçirilmesine izin veren, içeride basit bir diziye dönüşen sözdizimi (`Type... isim`).

**Arrays** — Diziler üzerinde çalışan hazır statik metotlar (`sort`, `equals`, `fill`, `copyOf` vb.) sunan yardımcı sınıf.
