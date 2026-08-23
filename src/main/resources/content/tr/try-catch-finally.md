"Exception'lara Giriş", hiçbir şey bir exception'ı handle etmediğinde ne olduğunu gösterdi -- program gürültülü bir şekilde, bir stack trace'le sonlanıyor. Bu ders, bu olmadan ÖNCE araya girmenin gerçek mekanizmasını kapsıyor: `try`, `catch`, ve `finally`.

## Try ve Catch Nedir?

Bir `try` bloğu, bir kod bölümünü "bu bir exception fırlatabilir -- izle" olarak işaretler. Hemen ardından gelen bir `catch` bloğu, o `try` bloğunun İÇİNDE BELİRLİ bir tipte exception GERÇEKTEN oluşursa ne yapılacağını belirtir. Hiçbir exception fırlatılmazsa, her `catch` bloğu basitçe atlanır, ve çalışma hiç orada değillermiş gibi hemen onların ardından devam eder.

## Neden Var?

"Exception'lara Giriş", exception'ların kendisinin bir dil özelliği olarak neden var olduğunu zaten kapsadı. `try`/`catch`, daha dar, daha pratik bir soruyu cevaplar: belirli bir kod parçasının başarısız OLABİLECEĞİNİ bildiğinde, bu başarısızlığı tüm programı sonlandırmasına izin vermek yerine, tam olarak ele almaya hazır olduğun yere nasıl sınırlarsın? Riskli kodu `try`'a, kurtarma mantığını `catch`'e sarmak, "bu başarısız olursa ne olur" handling'ini gerçekten başarısız olabilecek kodun fiziksel olarak yanında tutar.

## Tarihçe

`try`/`catch`/`finally` keyword'leri olarak Java'dan öncesine dayanır -- Java'nın tasarımcıları bu tam üç parçalı şekli yeni bir tane icat etmek yerine doğrudan C++'ın exception handling sözdiziminden (1980'lerin sonunda C++'a eklendi) ödünç aldı. `finally`'nin kendisi, sonucundan bağımsız olarak cleanup kodunun çalışmasını garanti etmesi, Java'nın bu ödünç alınan şekle kendi eklemesi -- C++'ın doğrudan bir eşdeğeri yok, bunun yerine cleanup'ı garanti etmek için farklı bir desene (RAII) dayanıyor.

## Temel try-catch Bloğu

{{BasicTryCatchExample.java}}

> 💡 Tip
> Bir `catch` bloğundaki parametre (yukarıdaki `e`) gerçek, sıradan bir yerel değişkendir, yalnızca o `catch` bloğuna scope'lanmıştır -- üzerinde `Throwable`'ın tanımladığı herhangi bir metodu çağırabilirsin ("Exception'lara Giriş" dersinin "Bir Exception'ın Anatomisi: Throwable, Mesaj ve Stack Trace" bölümüne bakınız), en yaygın olarak `getMessage()`.

## Birden Fazla catch Bloğu: Sırayla Eşleşme

Tek bir `try`'ı, her biri FARKLI bir exception tipini ele alan birkaç `catch` bloğu izleyebilir -- Java bunları yukarıdan aşağıya kontrol eder ve yalnızca eşleşen İLKİNİ çalıştırır.

{{MultipleCatchBlocksExample.java}}

> ⚠️ Warning
> Sıra önemli. Bir SÜPER SINIF için `catch` bloğu (`RuntimeException` gibi), alt sınıflarından biri için `catch` bloğundan (`NumberFormatException` gibi) ÖNCE gelseydi, alt sınıfın `catch` bloğu erişilemez olurdu -- süper sınıfınki her zaman önce eşleşirdi. Derleyici bu spesifik hatayı yakalar ve build'i reddeder ("süper sınıf"ın burada tam olarak ne anlama geldiği için "Exception Hiyerarşisi" dersine bakınız).

## Multi-Catch: | ile Birden Fazla Exception Tipini Aynı Blokta Yakalamak

İki ya da daha fazla FARKLI exception tipi gerçekten AYNI handling koduna ihtiyaç duyduğunda, ayrı, yinelenen `catch` blokları yazmak (`MultipleCatchBlocksExample`'da olduğu gibi) hiçbir sebep olmadan kendini tekrar eder. Java 7'de eklenen multi-catch, tek bir `catch` bloğunun `|` ile ayrılmış birkaç tipi listelemesine izin verir.

{{MultiCatchExample.java}}

## finally: Her Zaman Çalışan Blok

Son `catch`'ten sonra (ya da hiç `catch` olmadan, doğrudan `try`'dan sonra) yerleştirilen bir `finally` bloğu, her durumda çalışır -- `try` bloğu başarılı olsun, bir exception yakalansın, ya da bir exception her `catch` bloğunu yakalanmadan geçip gitsin.

{{FinallyAlwaysRunsExample.java}}

> 💡 Tip
> `finally`, bir dosyayı ya da bir veritabanı bağlantısını kapatmak gibi bir resource-cleanup deseninin üzerine inşa edildiği şey -- `try`-with-resources (gerçekten kullanıldığı yerde, "File Reading" dersinde kapsanıyor) aslında derleyicinin senin için otomatik olarak yazdığı `finally`-tabanlı bir cleanup'tır, temelde farklı bir mekanizma değil.

## finally ve return'ün Etkileşimi: İnce Bir Ayrıntı

`finally`'nin koşulsuz çalışmasının gerçekten şaşırtıcı bir sonucu var: `finally`'nin KENDİSİ bir `return` (ya da bir `throw`) içeriyorsa, `try` ya da `catch` bloğunun döndürmek üzere olduğu her şeyi sessizce EZER, tamamen atarak -- zaten yayılmakta olan gerçekten yakalanmamış bir exception dahil.

{{FinallyOverridingReturnExample.java}}

> ⚠️ Warning
> Bu, Java'nın kazara izin verdiği bir bug ya da kenar durum DEĞİL -- yalnızca `finally`'nin koşulsuz çalışmasının `return`/`throw` ile nasıl etkileşime girdiği. Bu tam olarak neden "Best Practices"in `finally` içinde bir `return` ya da `throw`'u pratik bir kısayol DEĞİL, kaçınılması gereken bir şey olarak ele almanı önerdiği.

## Best Practices

- **`try` bloklarını gerçekten başarısız olabilecek spesifik koda odaklı tut** -- gerekenden çok daha fazla kodu sarmak, bir exception'ın gerçekçi olarak hangi satırdan gelebileceğini söylemeyi zorlaştırır.
- **Birden fazla `catch` bloğunu en spesifikten en genele sırala** -- "Birden Fazla catch Bloğu"ndaki uyarıya, ve hangi tipin daha genel olduğunu nasıl akıl yürüteceğin için "Exception Hiyerarşisi" dersine bakınız.
- **Özdeş `catch` gövdelerini yinelemek yerine multi-catch'i tercih et** -- `MultiCatchExample`'a bakınız -- ama yalnızca handling mantığı gerçekten özdeşse, sadece benzer değil.
- **Bir `finally` bloğunun İÇİNE asla bir `return` ya da `throw` koyma** -- "finally ve return'ün Etkileşimi: İnce Bir Ayrıntı" bölümüne bakınız -- `finally`'i yalnızca neyin döndürüldüğünü ya da fırlatıldığını etkilemeyen cleanup için kullan.

## Yaygın Hatalar

- **Bir süper sınıfın `catch` bloğunu bir alt sınıfınkinden ÖNCE sıralamak.** Derleyici bunu erişilemez kod olarak doğrudan reddeder -- "Birden Fazla catch Bloğu: Sırayla Eşleşme" bölümündeki uyarıya bakınız.
- **`finally`'nin bir `try` bloğu return ettiğinde çalışmadığını varsaymak.** Hâlâ çalışır, `return` ifadesi değerlendirildikten ile kontrolün gerçekten metottan çıkması arasında -- `FinallyAlwaysRunsExample`'a bakınız.
- **`finally` içindeki bir `return`'ün devam eden bir exception'ı sessizce attığını fark etmemek.** Hiçbir uyarı, orijinal sorunun hiçbir izi yok -- `FinallyOverridingReturnExample`'a bakınız.
- **Bir metodun tüm gövdesini "her ihtimale karşı" tek bir dev `try` bloğuna sarmak.** Bu, sonradan bir exception'ın gerçekte hangi spesifik satıra karşı koruma sağladığını söylemeyi çok zorlaştırır.

## Özet, Cheat Sheet ve Terimler Sözlüğü

`try`, başarısız olabilecek kodu işaretler; `catch`, bir eşleşme bulunana kadar yukarıdan aşağıya kontrol edilerek, gerçekleşirse belirli bir exception tipi için ne yapılacağını belirtir; multi-catch (`|`), tek bir `catch` bloğunun birbiriyle ilgisiz birkaç tipi özdeş handling ile ele almasına izin verir; `finally` her durumda koşulsuz olarak çalışır, bu da onu cleanup için doğru yer yapar -- ama `return` ya da `throw` için ASLA, çünkü bu, `try`/`catch`'in üretmek üzere olduğu her şeyi sessizce ezer.

Hızlı referans:

```java
try {
    riskyOperation();
} catch (SpecificException e) {
    // spesifik durumu handle et
} catch (AnotherException | YetAnotherException e) {
    // multi-catch: iki ilgisiz tip için özdeş handling
} finally {
    // her zaman çalışır -- yalnızca cleanup, burada asla return/throw yok
}
```

**Terimler Sözlüğü**

**try** — Bir exception fırlatabilecek kodu işaretleyen bir blok.

**catch** — Önceki bir `try` bloğunun içinde fırlatılan belirli bir exception tipinin nasıl handle edileceğini belirten bir blok.

**Multi-Catch** — `|` kullanarak, birbiriyle ilgisiz birkaç exception tipini özdeş şekilde handle eden tek bir `catch` bloğu.

**finally** — Bir exception oluşmuş ya da yakalanmış olsun olmasın, `try`/`catch`'ten sonra koşulsuz olarak çalışan bir blok.
