Bu kursta şimdiye kadar yazdığın her program, işlerin yolunda gideceğini varsaydı -- bir dizi indeksinin geçerli olduğunu, bir string'in gerçekten bir sayı tuttuğunu, bir değerin kullanıldığı anda asla `null` olmadığını. Gerçek programlar bu varsayımı yapamaz. Bu, Java'nın bir şeyler ters gittiğinde ne yaptığını anlatan yedi dersin ilki -- en temel soruyla başlıyoruz: bir exception aslında NEDİR?

## Exception Nedir?

Bir exception, bir program çalışırken beklenmedik bir şeyin olduğunu temsil eden bir nesnedir -- gerçek bir Java nesnesi, bir sınıfın örneği. Kod, üzerinden basitçe devam edemeyeceği bir sorunla karşılaştığında (sıfıra bölme, bir dizinin sonunun ötesini okuma, `null` olan bir referans üzerinde bir metot çağırma), Java Virtual Machine tam olarak neyin yanlış gittiğini tarif eden bir exception nesnesi oluşturur, ve onu FIRLATIR (throw) -- normal çalışmayı hemen durduran ve sorunla ilgilenmeye istekli bir şey arayan özel bir tür sıçrama.

## Neden Var?

Exception'lar bir dil özelliği olarak var olmadan önce (C gibi eski dillerde eşdeğeri yoktu), başarısız olabilecek bir fonksiyon bu başarısızlığı DÖNÜŞ DEĞERİ üzerinden sinyallemek zorundaydı -- `-1` gibi özel bir sayı, ya da çağıranların HER SEFERİNDE kontrol etmeyi hatırlaması gereken bir out-parameter. Kontrol etmeyi unutmak kolaydı, sessizdi, ve gerçek hataların yaygın bir kaynağıydı. Exception'lar BAŞARISIZLIK YOLUNU BAŞARI YOLUNDAN tamamen ayırır: bir metodun dönüş değeri yalnızca başarıyı temsil etmek zorundadır, ve bir başarısızlık, kontrol edilmemiş bir dönüş değerinin olabileceği gibi asla sessizce görmezden gelinemez -- yakalanmamış bir exception SESSİZ değil, GÜRÜLTÜLÜDÜR ("Bir Exception Yakalanmazsa Ne Olur?" bölümüne bakınız).

## Tarihçe

Yapılandırılmış bir dil özelliği olarak exception handling, Java'dan onlarca yıl önceye dayanır -- PL/I (1964) ve daha sonra CLU ve Ada bununla denemeler yaptı, C++ ise 1980'lerin sonunda `try`/`catch`/`throw`'u ekledi. 1990'ların ortasında tasarlanan Java, bunu C++'ın gittiğinden daha ileri götüren, tartışmalı bir tasarım kararıyla genişletti: derleyicinin kabul etmeni ZORUNLU kıldığı bir kategori olan CHECKED exception'lar (tam kapsamı "Checked ve Unchecked Exception'lar" dersinde) -- Java'dan önce hiçbir ana akım dilin yapmadığı bir tercih, ve C# ile Kotlin gibi sonraki dillerin bilinçli olarak geri aldığı bir tercih. Bu tarihi, checked exception'lar derinlemesine işlenmeden ÖNCE, şimdiden bilmekte fayda var, çünkü Java'nın exception sisteminin neden böyle göründüğünü açıklıyor.

## Bir Exception'ın Anatomisi: Throwable, Mesaj ve Stack Trace

Her exception nesnesi -- spesifik sınıfından bağımsız olarak -- aynı üç bilgiyi taşır. Bir MESAJ: ne yanlış gittiğini anlatan, genellikle exception oluşturulurken ayarlanan, insan tarafından okunabilir bir string. Bir CAUSE (neden): bunu TETİKLEYEN başka bir exception'a opsiyonel bir referans (ne zaman ve neden kullanılacağı için "Exception Handling Best Practices" dersine bakınız). Ve bir STACK TRACE: exception nesnesinin oluşturulduğu anda tam olarak hangi metotların, hangi sırayla aktif olduğunun otomatik bir anlık görüntüsü.

{{ExceptionAnatomyExample.java}}

> 💡 Tip
> Java'daki her exception sınıfı (tam resim için "Exception Hiyerarşisi" dersine bakınız) nihayetinde `Throwable`'ı extend eder -- `getMessage()`, `getCause()` ve `getStackTrace()`'in gerçekte geldiği yer burasıdır -- spesifik exception bir `ArithmeticException`, bir `NullPointerException`, ya da bu serinin ilerisinde kendi yazacağın özel bir exception olsa bile bu doğrudur.

## Bir Exception Yakalanmazsa Ne Olur?

Bir exception'ı nasıl handle edeceğimizi henüz işlemedik -- bu, hemen bir sonraki ders. Önce onu HİÇ handle etmeden ne olduğunu görmek, handle etmenin değerini çok daha net kılıyor.

{{UncaughtExceptionExample.java}}

> ⚠️ Warning
> Yakalanmamış bir exception yalnızca bir mesaj yazdırıp devam etmez -- üzerinde oluştuğu THREAD'i, onu fırlatan satırda, HEMEN sonlandırır. Bu kursun şimdiye kadar yazdığı tek-thread'li programlar için bu, tüm programın tam orada durması demektir, onu başlatan her neyse (bir shell, bir build aracı, başka bir program) başarısızlığı sinyalleyen sıfırdan farklı bir exit code'la birlikte.

## Stack Trace Okumak: Çağrı Zincirinde Yayılma (Propagation)

Bir exception yalnızca en üst seviyede belirmez -- sorunun gerçekte olduğu yerde, genellikle birkaç metot çağrısı derinlikte oluşturulur, ve bir şey onu handle edene ya da en tepeye ulaşana kadar, kendisini çağıran her metot boyunca, bir çerçeve (frame) seferinde yukarı doğru YAYILIR (propagate).

{{PropagationThroughCallChainExample.java}}

## Exception'lar Pratikte Neden Oluşur?

Gerçek Java kodunda sürekli karşılaşacağın exception'lar egzotik değil -- küçük, tekrar eden bir günlük hata ve kenar durum kümesinden geliyorlar.

{{CommonExceptionTriggersExample.java}}

## Temel Terminoloji

Bu sürecin tamamını kesin olarak anlatan bir avuç kelime var, ve bu seri bunları buradan itibaren tutarlı bir şekilde kullanıyor. Bir exception'ı FIRLATMAK (throw), nesneyi oluşturmak ve JVM'e bir handler aramaya başlamasını sinyallemektir (`ExceptionAnatomyExample`'ın dizi erişimi bunu örtük olarak yapar; `PropagationThroughCallChainExample`'ın `throw new IllegalArgumentException(...)`'ı bunu açıkça yapar -- keyword'ün kendisi için "Throw ve Throws" dersine bakınız). Bir exception'ı YAKALAMAK (catch), onu araya giren ve programın sonlanmasına izin vermek yerine ne yapılacağına karar veren kod yazmaktır (bir sonraki ders olan "Try-Catch ve Finally"ye bakınız). YAYILMA (propagation), yakalanmamış bir exception'ın onu fırlatan metottan, yukarıda gösterildiği gibi, onu çağıran her metot boyunca hareket etmesidir. Bir STACK TRACE, o yayılmanın yazdırılmış kaydıdır. Ve CHECKED vs UNCHECKED, derleyicinin olası bir exception'ı kabul etmeni zorunlu kılıp kılmadığını tarif eder -- kendi başına bir ders olacak kadar önemli bir ayrım ("Checked ve Unchecked Exception'lar").

## Best Practices

- **Bir stack trace'i YUKARIDAN AŞAĞIYA oku, aşağıdan yukarıya değil** -- en üstteki satır exception'ın gerçekte oluşturulduğu yerdir, ki bu genellikle gerçek sorunun olduğu yerdir, programın sonlandığı yer değil.
- **Yakalanmamış bir exception'ı sadece bir çökme değil, bilgi olarak ele al** -- sınıf adı, mesaj ve stack trace birlikte, tek bir satır handling kodu yazmadan ÖNCE bile, neyin nerede yanlış gittiğini neredeyse her zaman tam olarak söyler.
- **Yaygın exception sınıflarını görür görmez tanımayı öğren** (`NullPointerException`, `ArrayIndexOutOfBoundsException`, `NumberFormatException`, `ArithmeticException`, `ClassCastException` -- `CommonExceptionTriggersExample`'a bakınız) -- bunlar, gerçekte karşılaşacağın exception'ların ezici çoğunluğunu oluşturur.
- **Bu ders exception'ların handle edilebileceğinden bahsetti diye henüz try/catch'e yönelme** -- bir exception'ın gerçekte NE OLDUĞUNU, ve handle edilmediğinde ne olduğunu anlamak, bir sonraki ders mekanikleri tanıtmadan önce üzerinde durmaya değer.

## Yaygın Hatalar

- **Bir exception'ın her zaman KENDİ kodundaki bir hata anlamına geldiğini varsaymak.** Birçok exception, gerçekten olağandışı ama geçerli bir durumu temsil eder (henüz var olmayan bir dosya, sayı olmayan bir kullanıcı girdisi) -- Java'nın kendi tip sisteminin bu ayrımı nasıl yansıttığı için "Checked ve Unchecked Exception'lar" dersine bakınız.
- **Stack trace'i görmezden gelip yalnızca exception'ın mesajını okumak.** Mesaj tek başına, sorunun NEREDE olduğunu bulmak için genellikle yeterli değildir -- onu tam olarak belirleyen stack trace'tir.
- **Bir exception'ın mevcut metodun geri kalanını sessizce "atladığını" düşünmek.** Sessizce atlamaz -- yayılan her metotta, throw noktasından sonraki her satır gerçekten hiç çalışmaz, bu yüzden `PropagationThroughCallChainExample`'ın "Order processed." satırı hiçbir zaman yazdırılmaz.
- **Bir exception'ın fırlatılmasını, programın basitçe bir hata mesajı yazdırıp devam etmesiyle karıştırmak.** Bir handler olmadan, çalışma throw noktasının ötesinde HİÇ devam etmez -- "Bir Exception Yakalanmazsa Ne Olur?" bölümündeki uyarıya bakınız.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Bir exception, çalışma sırasında beklenmedik bir şeyi temsil eden bir nesnedir -- bir sorun tespit edildiği anda JVM tarafından (ya da bu serinin ilerisinde kendi kodun tarafından) oluşturulur ve fırlatılır. Her exception, hepsi `Throwable`'dan miras alınan bir mesaj, opsiyonel bir cause, ve bir stack trace taşır. Bir handler olmadan, yakalanmamış bir exception thread'ini hemen sonlandırır, yolda kendisini çağıran her metot boyunca yukarı doğru yayılır, ve tam olarak nerede olduğunun okunabilir bir kaydı olarak bir stack trace bırakır. Sonraki altı ders doğrudan bu dört fikrin üzerine inşa ediyor -- exception'ları handle etmek, ait oldukları sınıf hiyerarşisini anlamak, checked/unchecked ayrımı, kendi exception'ını fırlatmak, ve yardımcı olan exception-handling kodunu sorunları yalnızca gizleyen koddan ayıran pratikler.

Hızlı referans:

```java
// JVM bunu otomatik olarak fırlatır -- bizim yazdığımız bir "throw" yok:
int result = 10 / 0;                     // ArithmeticException: / by zero

// Kendimiz de birini fırlatabiliriz (tam kapsam "Throw ve Throws"ta):
throw new IllegalArgumentException("quantity must be positive");

// Bir Throwable'ı incelemek (try/catch işlenmeden önce, gayri resmi olarak):
exception.getMessage();                  // insan tarafından okunabilir açıklama
exception.getClass().getName();          // tam exception tipi
exception.getStackTrace();               // nerede olduğu, çerçeve çerçeve
```

**Terimler Sözlüğü**

**Exception** — Bir programın çalışması sırasında olan beklenmedik bir şeyi temsil eden bir nesne.

**Throw (Fırlatmak)** — Bir exception nesnesi oluşturma ve JVM'e bir handler aramaya başlamasını sinyalleme eylemi.

**Uncaught Exception (Yakalanmamış Exception)** — Hiçbir kodun araya girmediği, JVM'in üzerinde oluştuğu thread'i sonlandırıp stack trace'ini yazdırmasına neden olan bir exception.

**Propagation (Yayılma)** — Yakalanmamış bir exception'ın, onu fırlatan metottan, onu çağıran her metot boyunca yukarı doğru hareket etmesi.

**Stack Trace** — Bir exception oluşturulduğu anda aktif olan her metot çağrısının yazdırılmış, sıralı kaydı.
