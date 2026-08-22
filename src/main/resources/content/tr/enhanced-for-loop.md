# Enhanced for Loop

Control Flow kategorisinin dördüncü konusu enhanced for (for-each) döngüsü -- bir dizinin ya da koleksiyonun her elemanını, bir sayaç değişkeni YAZMADAN gezmeyi sağlayan, klasik "for Loop" dersinin üzerine kurulu bir sözdizimi. Klasik `for`, KONUMA (indekse) ihtiyaç duyulan her durumda gereklidir; enhanced for ise yalnızca DEĞERLERİN kendisiyle ilgilenildiğinde -- konumun hiç önemi olmadığında -- aynı işi çok daha az kodla yapar. Bu ders, temel sözdizimini, üç gerçek SINIRINI (indekssizlik, döngü değişkeninin bir kopya olması, paralel gezinememe), ve klasik `for` ile aralarındaki seçimi ele alıyor.

## Enhanced for Loop Nedir?

`for (Tip eleman : koleksiyon)` biçimindeki enhanced for, "koleksiyondaki her eleman için" diye okunur -- klasik `for`'un aksine BAŞLANGIÇ/KOŞUL/GÜNCELLEME bölümlerinin hiçbiri yazılmaz, JVM bunları arka planda kendisi yönetir. Herhangi bir dizi ya da `Iterable` arayüzünü uygulayan herhangi bir tip (örn. `List`, `Set`) üzerinde çalışır.

## Neden Var?

Klasik `for` ile bir diziyi/koleksiyonu baştan sona gezmek -- `for (int i = 0; i < dizi.length; i++) { dizi[i] ... }` -- yaygın bir kalıptır ama iki gereksiz risk taşır: sınır koşulunu yanlış yazmak (`<=` yerine `<`, bkz. "for Loop" dersindeki "Yaygın Hatalar") ve indeksle DEĞER arasında kafa karışıklığı (`dizi[i]` yerine yanlışlıkla `i`'yi kullanmak). Konuma hiç ihtiyaç duyulmayan -- yalnızca her değerin kendisiyle ilgilenilen -- durumların ÇOĞUNLUĞUNDA bu risklerin ikisi de gereksizdir; enhanced for, bu riskleri sözdiziminden tamamen kaldırır.

## Tarihçe

Enhanced for, Java 5'te (2004) generic'ler ve autoboxing'le (bkz. "Wrapper Classes & Autoboxing" dersi) AYNI sürümde, `Iterable`/`Iterator` arayüzleriyle birlikte tanıtıldı -- amaç, o zamana kadar her koleksiyon gezintisinde elle yazılan `Iterator` kullanım kalıbını (`while (it.hasNext()) { Tip eleman = it.next(); ... }`) gizleyip daha kısa bir sözdizimine indirgemekti. Klasik `for`'un YERİNİ almadı, yalnızca konuma ihtiyaç duyulmayan durumlar için bir ALTERNATİF sundu.

## Temel Enhanced for Sözdizimi (Diziler)

Bir dizi üzerinde enhanced for, her elemanı sırayla `eleman` değişkenine atar -- indeks hiç yazılmaz, dizinin sınırları JVM tarafından otomatik kontrol edilir (bu yüzden `ArrayIndexOutOfBoundsException` riski YOKTUR).

{{EnhancedForArrayExample.java}}

## Koleksiyonlar Üzerinde Enhanced for

Enhanced for yalnızca dizilerle sınırlı değildir -- `Iterable` arayüzünü uygulayan HER TİP (yani `List`, `Set` dahil hemen hemen tüm koleksiyon sınıfları) üzerinde aynı sözdizimiyle çalışır.

{{EnhancedForCollectionExample.java}}

## Sınır: İndekse Erişilememesi

Enhanced for, her elemanın DEĞERİNİ verir ama KONUMUNU (indeksini) hiçbir zaman vermez -- "1. sırada X" gibi bir çıktı üretmek gerekiyorsa ya elle bir sayaç değişkeni tutulmalı ya da klasik `for` (bkz. "for Loop" dersindeki "for Döngüsüyle Dizi Üzerinde Gezinme" bölümü) kullanılmalıdır.

{{NoIndexAccessExample.java}}

## Sınır: Döngü Değişkeni ve Yapısal Değişiklik

Enhanced for'un döngü değişkeni her elemanın bir KOPYASIDIR -- ona yeni bir değer atamak, alttaki diziyi/koleksiyonu DEĞİŞTİRMEZ. Ayrıca bir `List` üzerinde enhanced for çalışırken listenin YAPISINI değiştirmek (bir eleman eklemek/çıkarmak) genellikle `ConcurrentModificationException` fırlatır -- döngü, koleksiyonun kendi ayaklarının altından değiştiğini böyle tespit eder. Elemanları güvenle çıkarmanın gerçek yolu (`Iterator.remove()`) "Lists" dersindeki "Iterator ve ListIterator" bölümünde ele alınıyor.

{{ModifyingDuringIterationExample.java}}

> ⚠️ Warning
> Bir listeden eleman çıkarırken `ConcurrentModificationException`'ın HER ZAMAN fırlayacağına güvenmeyin -- listenin SONUNA yakın bir eleman çıkarıldığında, iç sayaçların tesadüfen örtüşmesi yüzünden istisna fırlamayabilir (sessizce yanlış bir sonuç üretebilir). Güvenli olan tek yol, enhanced for içinde YAPISAL değişiklik yapmamaktır.

## for-each vs Klasik for: Ne Zaman Hangisi

Konuma ihtiyaç YOKSA (yalnızca değerler işleniyorsa) enhanced for tercih edilmelidir -- daha kısa, daha az hataya açık. Konuma ihtiyaç VARSA (bkz. bir önceki bölüm), ya da diziyi/koleksiyonu YERİNDE değiştirmek gerekiyorsa (bkz. "for Loop" dersindeki "for Döngüsüyle Dizi Üzerinde Gezinme" bölümü), klasik `for` gereklidir.

{{ForEachVsClassicForExample.java}}

## Sınır: Birden Fazla Koleksiyonu Paralel Gezmek

Enhanced for, TEK bir `Iterable`'ı bir seferde gezer -- iki diziyi/koleksiyonu "AYNI ANDA, aynı konumdan" gezmenin doğrudan bir yolu yoktur (iki enhanced for'u iç içe yazmak, HER elemanı DİĞER koleksiyonun her elemanıyla eşleştirir, bu istenen davranış DEĞİLDİR). Klasik `for`, tek bir paylaşılan indeksle bu problemi doğrudan çözer (bkz. "for Loop" dersindeki "Birden Fazla Değişkenle for" bölümü).

{{ParallelIterationLimitationExample.java}}

## Best Practices

- **Konuma (indekse) ihtiyaç yoksa her zaman enhanced for'u tercih edin** -- daha kısa, sınır hatalarına kapalı.
- **Enhanced for içinde bir koleksiyonun YAPISINI (eleman ekleme/çıkarma) değiştirmeyin** -- gerekiyorsa `Iterator.remove()` ya da bir klasik `for` (geriye doğru gezinerek) kullanın.
- **Döngü değişkenine yeni bir değer atamanın diziyi/koleksiyonu DEĞİŞTİRMEDİĞİNİ unutmayın** -- bu yaygın bir yanlış beklentidir.
- **İki koleksiyonu paralel gezmeniz gerekiyorsa klasik `for`'u tek bir paylaşılan indeksle kullanın.**

## Yaygın Hatalar

- **Enhanced for'un döngü değişkenini değiştirip diziyi/koleksiyonu güncellediğini SANMAK.** Döngü değişkeni yalnızca bir kopyadır, alttaki veri yapısı ETKİLENMEZ.
- **Enhanced for içinde bir `List`'ten doğrudan `list.remove(...)` çağırıp `ConcurrentModificationException` almak.** Güvenli kaldırma, `Iterator.remove()` gerektirir.
- **Konuma (indekse) ihtiyaç varken enhanced for kullanmaya çalışıp elle sayaç tutmaya zorlanmak.** Bu durumda klasik `for` zaten daha az kod gerektirir.
- **İki diziyi eşleştirmek için iki enhanced for'u İÇ İÇE yazmak.** Bu her elemanı diğerinin HER elemanıyla eşleştirir -- paralel gezinme değil, kartezyen çarpım üretir.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Enhanced for (`for (Tip eleman : koleksiyon)`), bir dizi/koleksiyonun her elemanını, indeks yazmadan gezmeyi sağlar -- `Iterable` uygulayan her tip üzerinde çalışır. Üç gerçek sınırı vardır: KONUMA erişilemez, döngü değişkenine atama alttaki veriyi DEĞİŞTİRMEZ (ve yapısal değişiklikler genellikle `ConcurrentModificationException` fırlatır), ve birden fazla koleksiyon PARALEL gezilemez. Bu üç durumda klasik `for` (bkz. "for Loop" dersi) hâlâ doğru araçtır.

Hızlı referans:

```java
for (int eleman : dizi) {
    // yalnızca DEĞER, indeks yok
}

for (String eleman : liste) {
    // Iterable uygulayan her tip üzerinde çalışır
}

// YANLIŞ -- alttaki diziyi değiştirmez:
for (int eleman : dizi) {
    eleman = eleman * 2;
}

// Konuma ihtiyaç varsa klasik for:
for (int i = 0; i < dizi.length; i++) {
    System.out.println(i + ": " + dizi[i]);
}
```

**Terimler Sözlüğü**

**Enhanced for (for-each)** — Bir dizi/koleksiyonun her elemanını, indeks yazmadan gezen döngü sözdizimi.

**Iterable** — Enhanced for ile gezilebilen her tipin uyguladığı arayüz (`List`, `Set` dahil).

**ConcurrentModificationException** — Bir koleksiyon, üzerinde enhanced for çalışırken YAPISAL olarak değiştirildiğinde genellikle fırlatılan çalışma zamanı istisnası.
