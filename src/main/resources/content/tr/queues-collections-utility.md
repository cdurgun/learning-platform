# Queues & Collections Utility

Collections kategorisinin son durağında iki farklı ama birbirini tamamlayan konuyu bir araya getiriyoruz: `Queue`/`Deque` (elemanları belirli bir sırada -- FIFO, LIFO, ya da önceliğe göre -- işlemek için tasarlanmış koleksiyonlar) ve `Collections` yardımcı sınıfı (herhangi bir koleksiyon üzerinde çalışan hazır statik metotlar). İkisi de kısa, bağımsız konular olduğu için tek bir topic'te birleştirildi -- tıpkı "Primitive & Parallel Streams" dersinde uygulanan aynı gerekçeyle.

## Queue ve Deque Nedir?

`Queue<E>`, elemanları belirli bir sırayla işlemek için tasarlanmış bir arayüzdür -- en yaygın kullanımı FIFO'dur (first-in-first-out, ilk giren ilk çıkar), tıpkı bir bekleme sırası gibi. `Deque<E>` ("double-ended queue", "dek" diye okunur), `Queue`'yu genişletir ve HER İKİ uçtan da ekleme/çıkarma yapılabilmesini sağlar -- bu sayede hem kuyruk (FIFO) hem de yığın (LIFO -- last-in-first-out) olarak kullanılabilir. En yaygın implementasyonları `ArrayDeque` (dairesel bir dizi, en hızlı) ve `LinkedList`'tir (`List`, `Deque` ve `Queue`'nun hepsini birden implement eder).

## Neden Var?

Bir görev kuyruğu, bir mesaj sırası, "geri al" (undo) geçmişi, bir grafikte genişlik-öncelikli arama (BFS) -- bunların hepsi "elemanları belirli bir sırayla işle" fikrine dayanır. `List` ile de teorik olarak benzer bir şey yapılabilir (`add(0, x)` ya da `remove(0)`), ama bu işlemler `ArrayList`'te O(n)'dir (bkz. "Lists" dersi) -- `Queue`/`Deque` implementasyonları bu işlemleri O(1)'de yapacak şekilde tasarlanmıştır.

## Tarihçe

`Queue` arayüzü Java 5 (2004) ile geldi -- Collections Framework'ün ilk sürümünde (1998) yoktu. `Deque` ve `ArrayDeque` Java 6 (2006) ile eklendi; `ArrayDeque`'ın resmi javadoc'u, hem `Stack` sınıfına hem de `Deque` olmadığında `LinkedList`'e göre daha hızlı olduğunu ve tercih edilmesi gerektiğini açıkça belirtir. `PriorityQueue` de Java 5 ile geldi, bir öncelik kuyruğu (heap) implementasyonu olarak.

## Queue Temelleri: İki Paralel Metot Ailesi

`Queue`'nun her işlemi için İKİ paralel metot vardır: biri başarısızlıkta İSTİSNA fırlatır (`add()`, `remove()`, `element()`), diğeri özel bir değer döner (`offer()`, `poll()`, `peek()` -- sırasıyla `false`/`null`/`null`). Genel kural: `offer()`/`poll()`/`peek()` ailesi tercih edilir, çünkü "kuyruk boş" gibi normal bir durumu istisna fırlatarak değil, kontrol edilebilir bir dönüş değeriyle ele alır.

{{QueueBasicsExample.java}}

> ⚠️ Warning
> Boş bir kuyrukta `remove()`/`element()` çağırmak `NoSuchElementException` fırlatır -- bu, "kuyruk boş mu" gibi normal, beklenen bir durum için istisna kullanmanın tipik bir örneğidir. `poll()`/`peek()`'in `null` dönmesi genellikle daha okunabilir ve daha az maliyetlidir (istisna fırlatmak/yakalamak pahalıdır).

## Deque: Her İki Uçtan da Erişim

`Deque`, `addFirst()`/`addLast()`, `removeFirst()`/`removeLast()`, `peekFirst()`/`peekLast()` (ve bunların `offer`/`poll` ile başlayan, istisna fırlatmayan karşılıkları) ile her iki uca da erişim sağlar.

{{DequeExample.java}}

## ArrayDeque'ı Stack Olarak Kullanmak

`Deque`, `push()`/`pop()` metotlarıyla bir YIĞIN (stack, LIFO -- last-in-first-out) gibi de kullanılabilir. Java'nın kendi `java.util.Stack` sınıfının javadoc'u, bu eski sınıf yerine `Deque`'ın (özellikle `ArrayDeque`'ın) kullanılmasını RESMİ OLARAK önerir -- çünkü `Stack`, `Vector`'ı genişletir ve bu yüzden gereksiz senkronizasyon yükü ile yığın kavramına uymayan index tabanlı metotlar (`insertElementAt()` gibi) miras alır.

{{ArrayDequeAsStackExample.java}}

## ArrayDeque ile LinkedList Arasında Performans

`ArrayDeque` ve `LinkedList`, `Deque` olarak aynı işlemler için ikisi de teorik olarak O(1)'dir -- ama sabit faktörler (constant factors) farklıdır: `LinkedList`, her eleman için ayrı bir bağlantı nesnesi (node) tahsis eder, `ArrayDeque` ise dairesel bir dizi kullanarak bu ek yükten kaçınır.

{{ArrayDequeVsLinkedListPerformanceExample.java}}

Gerçek ölçüm: 5 milyon `offer()`+`poll()` çiftinde `ArrayDeque` çoğu çalıştırmada `LinkedList`'ten belirgin şekilde daha hızlı çıktı (örneğin ~40 ms'ye karşı ~55-60 ms), ama fark her çalıştırmada aynı oranda değildi -- bazı çalıştırmalarda ikisi birbirine çok yaklaştı. Bu, `LinkedList`'in her eleman için ayrı bir nesne tahsis etmesinin garbage collector üzerinde değişken bir baskı yaratmasıyla tutarlı. Sonuç olarak `ArrayDeque` hiçbir çalıştırmada `LinkedList`'ten daha yavaş ölçülmedi.

## PriorityQueue: Sırayla Değil, Önceliğe Göre

`PriorityQueue`, elemanları eklenme sırasına göre DEĞİL, doğal sıralamaya (ya da verilen bir `Comparator`'a) göre işler -- her zaman en küçük (ya da `Comparator`'a göre "en öncelikli") eleman `peek()`/`poll()` ile önce çıkar. Ama dikkat: bu YALNIZCA `peek()`/`poll()` için geçerlidir -- `PriorityQueue`'yu doğrudan yazdırmak ya da `Iterator` ile dolaşmak, elemanları SIRALI göstermez.

{{PriorityQueueExample.java}}

> ⚠️ Warning
> `PriorityQueue`'nun `toString()`'i (ya da doğrudan `Iterator` ile dolaşmak), elemanların sıralı görüneceği YANLIŞ izlenimini verebilir -- yukarıdaki örnekte gerçek çıktı bunu kanıtlıyor: `[10, 20, 40, 50, 30]`, sıralı DEĞİL. `PriorityQueue` içeride bir heap (yığın ağacı) kullanır -- yalnızca kökün (dizinin ilk elemanı) her zaman en küçük olduğu garanti edilir, geri kalanı için hiçbir sıra garantisi yoktur. Elemanları gerçekten sıralı almak için tek yol tekrar tekrar `poll()` çağırmaktır.

## Collections Yardımcı Sınıfı

`Collections`, `Collectors`'a benzer şekilde (bkz. "Collectors" dersi), herhangi bir `Collection`/`List` üzerinde çalışan hazır statik metotlar sunan bir yardımcı sınıftır: `sort()`, `reverse()`, `shuffle()`, `max()`/`min()`, `frequency()` (bir değerin kaç kez geçtiğini sayar), `binarySearch()` (SIRALI bir listede O(log n) arama), ve `emptyList()`/`singletonList()`/`nCopies()` gibi küçük, özel amaçlı immutable koleksiyon üreten fabrika metotları.

{{CollectionsUtilityExample.java}}

> 💡 Tip
> `Collections.binarySearch()`'ün doğru çalışması için listenin ÖNCEDEN sıralanmış olması şarttır -- sıralanmamış bir listede çağırmak istisna fırlatmaz ama YANLIŞ bir sonuç döner (sessiz bir hata). Emin değilsen önce `Collections.sort()` çağır.

## Best Practices

- **Yığın (stack) için `java.util.Stack` yerine `ArrayDeque`'ı `push()`/`pop()` ile kullanın** -- bu, Java'nın kendi resmi önerisidir.
- **Kuyruk/deque olarak `LinkedList` yerine varsayılan olarak `ArrayDeque`'ı tercih edin** -- neredeyse her zaman en az o kadar hızlı, genellikle daha hızlı, ve daha az bellek kullanır (her eleman için ayrı node nesnesi tahsis etmez).
- **"Kuyruk boş" gibi normal durumlar için `offer()`/`poll()`/`peek()` ailesini tercih edin**, `add()`/`remove()`/`element()` değil -- istisna fırlatmak/yakalamak normal akış kontrolü için pahalıdır.
- **`PriorityQueue`'yu doğrudan yazdırmaya ya da `Iterator` ile dolaşmaya güvenmeyin** -- sıralı çıktı istiyorsanız tekrar tekrar `poll()` çağırın.

## Yaygın Hatalar

- **Boş bir kuyrukta `remove()`/`element()` çağırıp `NoSuchElementException` almak.** Normal bir "boş mu" kontrolü için `offer()`/`poll()`/`peek()` ailesi kullanılmalı.
- **`PriorityQueue`'nun `toString()`'inin ya da `Iterator`'ının sıralı olduğunu varsaymak.** Yalnızca `peek()`/`poll()` sıralama garantisi verir.
- **`Collections.binarySearch()`'ü sıralanmamış bir listede çağırmak.** İstisna fırlatmaz ama yanlış bir sonuç döner -- önce mutlaka `Collections.sort()` çağrılmalı.
- **Sık ekleme/çıkarma gereken bir senaryoda gereksiz yere `java.util.Stack` ya da `Vector` kullanmak.** Bunlar eski, senkronize sınıflardır -- modern kod `ArrayDeque`/`ArrayList` kullanmalı.

## Özet, Cheat Sheet ve Terimler Sözlüğü

`Queue`, elemanları belirli bir sırayla (genellikle FIFO) işler; `Deque`, her iki uçtan da erişim sağlayarak hem kuyruk hem yığın olarak kullanılabilir. `ArrayDeque`, hem `LinkedList`'e (Deque olarak) hem `java.util.Stack`'e (yığın olarak) tercih edilen modern implementasyondur. `PriorityQueue`, elemanları önceliğe göre işler ama yalnızca `poll()`/`peek()` sıralama garantisi verir. `Collections` yardımcı sınıfı, herhangi bir liste/koleksiyon üzerinde çalışan hazır statik metotlar sunar.

Hızlı referans:

```java
Queue<String> queue = new ArrayDeque<>();     // FIFO -- offer()/poll()/peek()
Deque<String> stack = new ArrayDeque<>();      // LIFO -- push()/pop()/peek()
Queue<Integer> pq = new PriorityQueue<>();      // önceliğe göre -- poll() sıralıdır, toString() DEĞİL
Collections.sort(list);                            // yerinde sıralama
Collections.max(list); Collections.min(list);         // en büyük/en küçük
Collections.frequency(list, value);                     // kaç kez geçtiğini say
Collections.binarySearch(sortedList, value);              // O(log n) arama (ÖNCE sırala!)
```

**Terimler Sözlüğü**

**Queue** — Elemanları belirli bir sırayla (genellikle FIFO) işleyen bir koleksiyon arayüzü.

**Deque** — Her iki uçtan da ekleme/çıkarma yapılabilen, hem kuyruk hem yığın olarak kullanılabilen `Queue` alt arayüzü.

**ArrayDeque** — `Deque`'ın dairesel diziyle çalışan, `LinkedList`'e ve `java.util.Stack`'e tercih edilen implementasyonu.

**PriorityQueue** — Elemanları eklenme sırasına göre değil, önceliğe (doğal sıralama ya da `Comparator`) göre işleyen, heap tabanlı bir `Queue` implementasyonu.

**Collections** — Herhangi bir koleksiyon üzerinde çalışan hazır statik metotlar (`sort`, `reverse`, `max`, `binarySearch` vb.) sunan yardımcı sınıf.
