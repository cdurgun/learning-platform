# Interface

Java'da **interface** (arayüz), bir tipin *ne yapabildiğini* tanımlayan ama *nasıl
yaptığını* söylemeyen bir sözleşmedir (contract). Bir sınıf bir interface'i implement
ettiğinde, o sözleşmeyi yerine getirmeyi taahhüt eder — çağıran kod, karşısındaki nesnenin
gerçek sınıfını hiç bilmeden, yalnızca bu sözleşmeye güvenerek çalışabilir. Bu derste,
temel soyut metotlardan başlayıp Java 8'in default/static metotlarına, Java 9'un private
metotlarına ve Java 17'nin sealed interface'lerine kadar, interface'in zaman içinde nasıl
evrildiğini uçtan uca işleyeceğiz.

## Interface Nedir?

En basit haliyle bir interface, gövdesiz metot imzalarından oluşan bir tip tanımıdır —
"bu tipten bir nesnede şu metotlar bulunmalı" der, ama metotların içini boş bırakır:

```java
interface Payable {
    double calculatePayment();
}

class Invoice implements Payable {
    @Override
    public double calculatePayment() {
        return 199.90;
    }
}
```

`Invoice`, `implements Payable` yazarak "ben bu sözleşmeyi yerine getiriyorum" demiş
oluyor; `calculatePayment()`'ı gerçekten tanımlamazsa kod derlenmez. Karşılığında,
`Payable` tipindeki bir değişken üzerinden çalışan herhangi bir kod, elindeki nesnenin
`Invoice` mi, yoksa henüz yazılmamış başka bir `Payable` implementasyonu mu olduğunu hiç
bilmek zorunda kalmaz.

## Neden Var?

Interface'in çözdüğü temel problem **decoupling** — kodu, somut bir sınıfa değil, bir
sözleşmeye bağımlı kılmak. "Bir `ArrayList` bekliyorum" yerine "bir `List` bekliyorum"
demek, çağıran kodun yarın `LinkedList`'e geçmesini, hatta testte sahte (mock) bir
implementasyon kullanmasını, hiçbir şeyi değiştirmeden mümkün kılar — bu ilkeye genelde
*"implementasyona değil, arayüze göre programla"* denir.

İkinci önemli sebep, Java'nın tek kalıtım (single inheritance) kısıtlamasını aşmak.
Bir sınıf yalnızca **bir** sınıftan `extends` ile miras alabilir — ama gerçek dünyada bir
nesnenin birden fazla "rolü" olabilir: bir `Duck` hem uçabilir hem yüzebilir, ama ne
"Uçan Şeyler" sınıfından ne de "Yüzen Şeyler" sınıfından aynı anda miras alabilir.
İnterface'ler, sınıfların **tek durumdan (state)** ama **birden fazla sözleşmeden**
miras almasına izin vererek bu sorunu çözer ("Çoklu Interface Implement Etmek"
bölümünde bunu somut bir örnekle göreceğiz).

## Tarihçe

Interface, Java'nın ilk gününden (JDK 1.0, 1996) beri var — ama başlangıçta çok katı bir
kuralı vardı: yalnızca soyut metotlar ve sabitler içerebiliyordu, hiçbir metot gövdesi
barındıramıyordu. Bu, yıllar içinde ciddi bir pratik soruna yol açtı: `java.util.List`
gibi, binlerce üçüncü parti sınıfın implement ettiği bir interface'e tek bir yeni metot
eklemek bile, o metodu implement etmeyen **her** sınıfın derlenmesini kırıyordu — bu yüzden
JDK'nın kendisi bile koleksiyon arayüzlerine uzun yıllar yeni metot ekleyemedi.

Java 8 (2014), bu "interface evrimi" problemini **default metotlar** ile çözdü — bir
interface artık gövdeli bir metot tanımlayabiliyor, mevcut implementasyonlar hiçbir şey
yapmadan bu metodu otomatik miras alıyordu (`forEach`, `stream()` gibi metotlar tam olarak
bu sayede `Collection`'a sonradan eklenebildi). Aynı sürümde **static metotlar** da geldi.
Java 9 (2017), default metotlar arasında kod paylaşımını kolaylaştırmak için **private
metotlar**ı ekledi. Java 17 (2021), interface'in implement edebileceği tipleri açıkça
sınırlayan **sealed interface**'leri getirdi — bu projede kullandığımız Java 21, tüm bu
katmanları bir arada barındırıyor ve hepsini bu derste sırayla işleyeceğiz.

## İlk Interface'ini Yazmak

Bir interface, `class` yerine `interface` anahtar kelimesiyle tanımlanır; onu implement
eden bir sınıf, `implements` ile bunu belirtir ve interface'in tüm soyut metotlarını
`@Override` ile gerçeklemek zorundadır:

{{FirstInterface.java}}

`Payable`, tek bir metot imzası dışında hiçbir şey söylemiyor — `Invoice`'un o metodu
nasıl hesapladığı tamamen kendi işi. `FirstInterfaceDemo` içinde `Payable invoice = new
Invoice(...)` satırına dikkat et: değişkenin tipi `Invoice` değil, `Payable` — bu, ileride
başka bir `Payable` implementasyonuna geçmenin, çağıran kodda tek bir satır bile
değiştirmeyeceği anlamına gelir.

> 💡 Tip
> Bir sınıf `implements` yazıp interface'in bir metodunu eksik bırakırsa, derleyici
> hemen hata verir — bu, interface'in en değerli özelliklerinden biri: sözleşmeyi bozmak
> çalışma zamanında değil, **derleme zamanında** yakalanır.

## Soyut Metotlar

Bir interface içindeki gövdesiz bir metot, hiçbir şey yazmasan bile örtük olarak
(implicitly) `public abstract`'tır — bu iki kelimeyi elle yazman gerekmez, yazsan da
anlam değişmez:

{{AbstractMethodExample.java}}

`Greeter` ile `GreeterExplicit` tamamen aynı şeyi tanımlıyor. Bunun pratikteki önemli bir
sonucu var: bir sınıf bu metodu implement ederken, erişim belirleyicisini **daraltamaz**
— interface metodu örtük olarak `public` olduğu için, `EnglishGreeter.greet(...)`'i
`protected` ya da paketin içine kapalı (package-private) yazmaya kalkışsan derleme hatası
alırsın; override eden metot en az interface'teki kadar erişilebilir olmak zorundadır.

> ⚠️ Warning
> Bir interface metodunun gövdesiz olması için `abstract` anahtar kelimesini **yazmana
> gerek yok**, ama bu metoda bir gövde eklemek istiyorsan (`default`/`static`/`private`
> kullanmadan) buna hiç izin verilmez — düz bir metot ya tamamen gövdesiz (soyut) ya da
> aşağıdaki bölümlerde göreceğimiz üç özel anahtar kelimeden biriyle işaretlenmiş
> olmalıdır.

## Constant Alanlar

Bir interface'te tanımlanan alanlar da, tıpkı metotlar gibi, örtük olarak `public static
final`'dır — yani hem sabittirler hem de bir örneğe ihtiyaç duymadan doğrudan
`InterfaceAdı.ALAN` şeklinde erişilirler:

{{InterfaceConstantsExample.java}}

`FreeFall`, `PhysicsConstants`'ı implement ederek `GRAVITY`'ye sanki kendi alanıymış gibi
doğrudan erişebiliyor — ama bu bir **kalıtım** değil, çünkü alan zaten `static`; her
implementasyon kendi kopyasını almaz, hepsi aynı tek sabiti paylaşır.

> ⚠️ Warning
> Bir interface alanının `final` olduğunu unutup ona sonradan bir değer atamaya
> çalışmak (`PhysicsConstants.GRAVITY = 10;`) derleme hatasıdır. Bir interface,
> implementasyonlar arasında paylaşılan **değişebilir (mutable) durum** tutmak için asla
> uygun bir yer değildir — bunun için sınıfların `static` alanlarını kullan.

## Interface Implement Etmek

Bir sınıf, `implements` anahtar kelimesiyle bir interface'e bağlanır ve interface'in tüm
soyut metotlarını gerçeklemek zorundadır. Aynı interface'i birden fazla sınıf, birbirinden
tamamen farklı şekillerde implement edebilir — bu, **polimorfizmin** temelidir:

{{ShapeImplementationExample.java}}

`Circle` ve `Rectangle`, `area()`'yı taban tabana zıt formüllerle hesaplıyor, ama
`ShapeImplementationExample`'daki döngü bunu hiç bilmiyor — elindeki her nesneyi yalnızca
bir `Shape` olarak görüyor ve `area()`/`perimeter()` çağırıyor. Çalışma zamanında hangi
metodun **gerçekten** çalışacağına JVM, nesnenin gerçek sınıfına bakarak karar veriyor
(dinamik gönderim / dynamic dispatch) — koddaki `Shape` referansı bunu bilmene bile gerek
bırakmıyor.

## Çoklu Interface Implement Etmek

Bir sınıf, `extends` ile yalnızca **bir** sınıftan miras alabilirken, `implements` ile
**birden fazla** interface'i aynı anda implement edebilir — virgülle ayırman yeterli:

{{MultipleInterfaceExample.java}}

`Duck`, hem `Flyable` hem `Swimmable` sözleşmesini tek başına yerine getiriyor — "Neden
Var?" bölümünde değindiğimiz, Java'nın tek kalıtım kısıtlamasını aşma problemi tam olarak
burada çözülüyor. Aynı `duck` nesnesi, ihtiyaca göre bir `Flyable` referansı üzerinden de,
bir `Swimmable` referansı üzerinden de kullanılabilir; her referans yalnızca kendi
sözleşmesindeki metotları görür.

## Interface'in Interface'i Genişletmesi

Tıpkı sınıflar gibi, bir interface de `extends` ile başka bir interface'i (hatta virgülle
ayırarak birden fazlasını) genişletebilir — bu durumda alt interface, üst interface'in tüm
soyut metotlarını devralır ve kendi metotlarını ekler:

{{InterfaceExtendsExample.java}}

`Describable`, `Nameable`'ı genişletiyor; `Product` sınıfı `Describable`'ı implement
ettiğinde, aslında dolaylı olarak `Nameable`'ı da implement etmiş oluyor — `name()`'i
gerçeklemek zorunda kalıyor, tıpkı `description()` gibi. `fullLabel()` default metodunun
(bir sonraki bölümde bu anahtar kelimeyi detaylandıracağız), henüz implement edilmemiş
`name()` ve `description()`'ı doğrudan çağırabildiğine dikkat et — bir interface, kendi
soyut metotlarını (implementasyonun *ileride* sağlayacağını varsayarak) default
metotlarının içinde güvenle kullanabilir.

## Default Metotlar

Java 8 ile gelen `default` anahtar kelimesi, bir interface metoduna **gövde** yazmana
izin verir — "Tarihçe" bölümünde bahsettiğimiz interface evrimi problemini çözen tam
olarak budur: var olan bir interface'e yeni bir default metot eklediğinde, onu implement
eden hiçbir sınıfın derlemesi bozulmaz, hepsi bu davranışı otomatik miras alır:

{{DefaultMethodExample.java}}

`Vehicle`'a `honk()` eklendiğinde, `Car` hiçbir şey yapmadan bu metodu bedava kazanıyor —
kendi `honk()` implementasyonunu yazmak zorunda değil. `SportsCar` ise dilerse bu
varsayılanı, tıpkı bir sınıf kalıtımındaki gibi, kendi `@Override`'ıyla değiştirebiliyor.
Bir default metot, çalışma zamanında **normal bir instance metodu** gibi davranır —
polimorfik olarak çözümlenir, çağıran kod hiçbir farkı hissetmez.

> 💡 Tip
> Default metotlar sözleşmeye **davranış** eklemeni sağlasa da, bir interface'in temel
> amacının hâlâ "ne yapılabildiğini" tanımlamak olduğunu unutma — default metotları
> business logic'in ana yeri haline getirmek yerine, ortak/yardımcı davranışlar için
> kullanmak "Best Practices" bölümünde değineceğimiz bir tasarım tavsiyesidir.

## Static Metotlar

Java 8, `default` ile birlikte `static` metotları da interface'lere ekledi — bir default
metodun aksine, bir static metot **hiçbir implementasyona ait değildir**, doğrudan
interface adı üzerinden çağrılır ve asla override edilemez:

{{StaticMethodExample.java}}

`DiscountPolicy.percentageOff(30)`, bir `DiscountPolicy` **örneği olmadan** çağrılıyor —
tıpkı bir sınıfın static factory metodu gibi. Bu kalıp, bir interface'in kendi ilgili
yardımcı/factory metotlarını, ayrı bir utility sınıfına (`DiscountPolicies` gibi)
taşımadan, doğrudan yanına koymanı sağlar; `java.util.Comparator.comparing(...)` ve
`java.util.List.of(...)` bu deseni gerçek dünyada kullanan tanıdık örneklerdir.

## Private Metotlar

Java 9, iki (ya da daha fazla) default metot aynı yardımcı mantığı paylaştığında bu
mantığı tekrar etmek zorunda kalmamak için **private metotları** ekledi — bir private
interface metodu (isteğe bağlı olarak `private static` da olabilir), yalnızca aynı
interface'in default/static metotları tarafından çağrılabilir, dışarıya hiç sızmaz:

{{PrivateMethodExample.java}}

`totalWithTax()` ve `taxAmount()`, ikisi de aynı yuvarlama mantığını (`round(...)`)
kullanıyor — bu mantığı her ikisine de kopyalamak yerine, `private` bir metoda çıkarıp
paylaşıyoruz. `round(...)`, `Invoice`'un public API'sinin **hiçbir parçası değil** —
`SimpleInvoice`'u implement eden bir sınıf onu asla göremez, göremediği için de override
edemez ya da yanlışlıkla farklı bir anlamda kullanamaz.

> 💡 Tip
> Private metotlar yalnızca Java 9+ ile gelir — bu projedeki Java 21 hedefinde sorunsuz
> çalışır, ama daha eski bir Java sürümüne (8 gibi) taşınabilir kod yazman gerekiyorsa, bu
> paylaşılan mantığı ayrı bir `static` yardımcı sınıfa çıkarmak zorunda kalırsın.

## Diamond Problem ve Çözümü

Bir sınıf, aynı imzaya sahip **iki farklı default metot** sağlayan iki interface'i aynı
anda implement ederse ne olur? Java, hangisini seçeceğini asla kendiliğinden **tahmin
etmez** — bu durumda sınıfın metodu açıkça override etmesini zorunlu kılar:

{{DiamondProblemExample.java}}

`Duck`, hem `Flyer`'dan hem `Swimmer`'dan çakışan bir `move()` default'u miras alıyor —
`move()`'u override etmezsen kod derlenmez (`Flyer`'ın mı yoksa `Swimmer`'ın mı
kastedildiği belirsiz olduğu için). Çözüm, `InterfaceAdı.super.metotAdı()` söz dizimiyle
üst interface'lerden **hangisinin** (ya da örnekteki gibi ikisinin birden)
kullanılacağını açıkça belirtmek — düz `super.move()` burada işe yaramaz, çünkü sınıf
kalıtımındaki gibi tek bir "üst" yok, birbirine eşit iki interface var.

> 💡 Tip
> Bu durum tarihsel olarak "elmas problemi" (diamond problem) diye anılır — C++'ta
> **çoklu sınıf kalıtımı** yüzünden ortaya çıkan, çok daha ciddi bir belirsizlik
> problemiyle aynı isimdir. Java, sınıflar için çoklu kalıtıma hiç izin vermeyerek o
> versiyonunu baştan engelliyor; interface'lerdeki bu daha hafif versiyon ise yalnızca
> **davranış** (default metot) çakıştığında ortaya çıkar ve derleyici seni sessizce
> yanlış bir seçim yapmak yerine açıkça çözmeye zorlar.

## Interface vs Abstract Class

Java 8'den beri default metotlarla interface'ler abstract class'lara epey yaklaşsa da,
aralarında hâlâ kalıcı farklar var:

- **Durum (state):** Bir abstract class instance alanları tutabilir; bir interface
  yalnızca `public static final` sabitler tanımlayabilir ("Constant Alanlar"
  bölümünde gördük) — instance düzeyinde değişebilir bir alanı asla olamaz.
- **Constructor:** Bir abstract class constructor tanımlayabilir (ortak başlatma
  mantığı için); bir interface'in hiçbir zaman constructor'ı olamaz.
- **Kalıtım sayısı:** Bir sınıf yalnızca **bir** abstract class'tan `extends` ile
  miras alabilir, ama istediği kadar interface `implements` edebilir ("Çoklu
  Interface Implement Etmek" bölümünde gördük).
- **Amaç:** Abstract class, birbiriyle yakından ilişkili tiplerin ortak
  **implementasyonunu** paylaşmak içindir ("is-a" ilişkisi, tek bir hiyerarşi);
  interface, birbiriyle hiç ilişkili olmayan tiplerin bile aynı **sözleşmeye**
  uyabilmesini sağlamak içindir ("can-do" ilişkisi — `Comparable`'ı hem bir `String`
  hem bir `Player` implement edebilir, ikisi arasında hiçbir hiyerarşik ilişki yok).

> 💡 Tip
> Pratik bir kural: paylaşacağın şey **davranış ve ortak alanlar** ise (birbirine
> gerçekten akraba tipler) abstract class'ı düşün; paylaşacağın şey yalnızca bir
> **yetenek sözleşmesi** ise (birbirine hiç akraba olmayan tipler bile uyabilsin
> istiyorsan) interface'i tercih et. Modern Java'da, sadece davranış paylaşmak için
> default metotlu bir interface çoğu zaman abstract class'a göre daha esnektir, çünkü
> çoklu implement etmeye izin verir.

## Functional Interface ve Lambda

Tam olarak **tek** soyut metoda sahip bir interface'e *functional interface* (fonksiyonel
arayüz) denir — default ve static metotlar bu sayıya dahil edilmez, istediğin kadar
olabilir. `@FunctionalInterface` annotation'ı zorunlu değildir ama derleyiciye "bu
interface'in tek soyut metodu olmasını garanti et" demeni sağlar; birisi yanlışlıkla ikinci
bir soyut metot eklerse, derleme hatası hemen orada yakalanır:

{{FunctionalInterfaceExample.java}}

Bir lambda ifadesi (`value -> value != null && !value.isBlank()`), ayrı bir sınıf
yazmadan, doğrudan bir functional interface'in **örneği** olarak kullanılabilir — Java,
lambda'nın imzasını (parametre sayısı/tipleri, dönüş tipi) hedef interface'in tek soyut
metoduyla eşleştirir. `java.util.function` paketi (`Predicate`, `Function`, `Supplier`,
`Consumer` gibi), en sık ihtiyaç duyulan şekilleri hazır sağlar — kendi functional
interface'ini yazmadan önce, ihtiyacının bunlardan biriyle zaten karşılanıp
karşılanmadığını kontrol etmek genelde daha iyi bir ilk adımdır.

> ⚠️ Warning
> Bir interface'in **iki veya daha fazla** soyut metodu varsa, ona asla lambda
> atayamazsın — derleyici hangi metodu implement ettiğini bilemez. `@FunctionalInterface`
> eklemeden yazdığın bir interface'e sonradan ikinci bir soyut metot eklersen, onu lambda
> ile kullanan tüm kod sessizce (derleme zamanında, açık bir hatayla) bozulur;
> annotation'ı eklemek bu hatayı ekleme anında yakalar, aylar sonra değil.

## Sealed Interface

Java 17 ile gelen `sealed` anahtar kelimesi, bir interface'i implement edebilecek
tiplerin **tam listesini** `permits` ile önceden belirlemene izin verir — derleyici, bu
listenin dışında hiçbir tipin (başka bir pakette, başka bir modülde bile) bu interface'i
implement edemeyeceğini garanti eder:

{{SealedInterfaceExample.java}}

`PaymentMethod`'un yalnızca `CreditCard`, `BankTransfer` ve `CashOnDelivery` tarafından
implement edilebileceğini derleyici biliyor — bu yüzden `switch` ifadesinde bu üç dalı
kapsadığımızda, hiçbir `default` dalına ihtiyaç duymuyoruz; derleyici bunun **tüketici
(exhaustive)** olduğunu kanıtlayabiliyor. Yarın dördüncü bir ödeme yöntemi eklemek
istersen, önce `permits` listesine ekleyip sonra bu `switch`'i güncellemek **zorunda**
kalırsın — derleyici seni unutmaya karşı korur, tıpkı bir enum'a yeni bir değer eklendiğinde
olduğu gibi.

> 💡 Tip
> `permits` ile izin verilen her tip, `final`, `sealed` ya da `non-sealed` olmak
> zorundadır — yani hiyerarşinin "kapalı" mı yoksa yeniden "açık" mı olacağı her
> seviyede açıkça belirtilir. Örnekteki `record`'lar buna otomatik uyar, çünkü
> record'lar zaten örtük olarak `final`'dır; ayrıca `final` yazmana gerek yoktur.

## Gerçek Dünya Kullanım Alanları

Buraya kadar öğrendiğimiz her mekanizma, JDK'nın ve popüler framework'lerin temel
tasarım araçlarından biridir:

- **`Comparable<T>`** (java.lang, JDK 1.2'den beri), bir tipe tek bir "doğal sıralama"
  kazandırır — implement eden her tip, `Collections.sort()`, `Arrays.sort()`,
  `TreeSet`, `TreeMap` tarafından otomatik olarak anlaşılır:

{{ComparableImplementationExample.java}}

- **`Runnable`/`Callable`**, bir iş parçasını ("şunu çalıştır") somut bir sınıftan
  bağımsız şekilde temsil eder — thread'ler ve `ExecutorService` bunları bilir, senin
  hangi sınıfı kullandığını hiç umursamaz.
- **Koleksiyon hiyerarşisi** (`Collection`, `List`, `Map`, `Set`), neredeyse tamamen
  interface'lerden oluşur — kodun `ArrayList`'e değil `List`'e bağımlı olması, "Neden
  Var?" bölümünde bahsettiğimiz decoupling'in en yaygın gerçek dünya örneğidir.
- **Spring**, `@Service`/`@Repository` ile işaretlenen sınıfları genelde bir interface
  üzerinden enjekte eder (`UserService` interface'i + `UserServiceImpl` sınıfı) — bu,
  testte gerçek implementasyon yerine bir sahte (mock) `UserService` vermeyi, hiçbir
  çağıran kodu değiştirmeden mümkün kılar.
- **`Serializable`/`Cloneable`** gibi, hiç metot içermeyen "marker interface"ler, bir
  tipe herhangi bir davranış eklemez — yalnızca JVM'e/kütüphaneye "bu tip şu özel
  muameleyi kabul ediyor" diye işaret verir (`instanceof` ile kontrol edilir).

## Best Practices

- **İmplementasyona değil, arayüze göre programla** — değişken/parametre/dönüş
  tiplerinde, mümkün olduğunca somut sınıf yerine interface kullan ("Neden Var?"
  bölümünde değindik).
- **Interface Segregation Principle (ISP):** bir interface'i küçük ve odaklı tut;
  implementasyonların ihtiyaç duymadığı metotları implement etmeye zorlayan "şişkin"
  bir interface yerine, birkaç dar interface'i (istersen "Interface'in Interface'i
  Genişletmesi" bölümündeki gibi) birleştirmek genelde daha esnektir.
- Default metotları **yardımcı/ortak davranış** için kullan, business logic'in ana
  yeri haline getirme (bkz. "Default Metotlar" bölümündeki tip).
- Kendi functional interface'ini yazmadan önce `java.util.function` paketinde hazır bir
  eşleniği olup olmadığını kontrol et (bkz. "Functional Interface ve Lambda").
- Kapalı, sonlu bir tip kümesi tasarlıyorsan (özellikle `switch` ile birlikte
  kullanılacaksa) `sealed` kullanmayı değerlendir — derleyici desteğinden (exhaustiveness
  kontrolü) faydalanırsın (bkz. "Sealed Interface").
- Interface isimlerinde C#'taki gibi `I` öneki (`IShape`) kullanmak Java
  konvansiyonuna aykırıdır; bunun yerine `Shape`/`Comparable`/`-able` sonekli isimler
  ya da doğrudan rol adı tercih edilir.

## Yaygın Hatalar

**1. Bir interface alanının instance başına ayrı bir kopyası olacağını sanmak.**
Tüm interface alanları örtük olarak `static`'tir — hepsi tek bir paylaşılan değeri
işaret eder, her implementasyon kendi kopyasını almaz (bkz. "Constant Alanlar").

**2. Diamond problem'de derleyicinin "mantıklı" bir seçim yapacağını beklemek.**
İki interface aynı imzalı çakışan default metotlar sağladığında, override etmek
**zorunludur**; derleyici asla kendiliğinden birini seçmez (bkz. "Diamond Problem ve
Çözümü").

**3. `@FunctionalInterface` olmayan (birden fazla soyut metotlu) bir interface'e
lambda atamaya çalışmak.** Lambda yalnızca **tam olarak tek** soyut metotlu
interface'lere atanabilir (bkz. "Functional Interface ve Lambda").

**4. Private interface metotlarını Java 8 sürümünde de kullanılabilir sanmak.**
Private metotlar yalnızca Java 9+ ile gelir; static ve default metotlar ise Java 8'den
beri vardır — bu ikisini karıştırmak, eski bir JDK hedefinde beklenmedik derleme
hatalarına yol açar (bkz. "Tarihçe" ve "Private Metotlar").

**5. Sealed bir interface'e yeni bir implementasyon eklerken `permits` listesini
güncellemeyi unutmak.** Yeni tip, `permits` listesine eklenmediği sürece derlenmez —
bu kısıtlama kasıtlıdır, atlanacak bir hata değildir (bkz. "Sealed Interface").

**6. Interface'i, aslında birbirine hiç ilişkisi olmayan metotları bir araya toplayan
"her şeyi yapan" tek bir sözleşme haline getirmek.** Bu, Interface Segregation
Principle'ı ihlal eder ve implementasyonları gereksiz metotlarla implement etmeye
zorlar (bkz. "Best Practices").

## Özet, Cheat Sheet ve Terimler Sözlüğü

Interface, Java'nın JDK 1.0'dan beri sahip olduğu, bir tipin sözleşmesini
implementasyonundan ayıran temel yapı taşıdır. Öne çıkan noktalar:

- Bir interface metodu, gövdesizse örtük olarak `public abstract`'tır; bir interface
  alanı her zaman örtük olarak `public static final`'dır
- Bir sınıf `extends` ile yalnızca bir sınıftan, ama `implements` ile istediği kadar
  interface'ten miras alabilir
- Bir interface, `extends` ile başka bir (hatta birden fazla) interface'i genişletebilir
- Java 8: `default` (gövdeli, override edilebilir, otomatik miras alınır) ve `static`
  (interface'e ait, asla override edilemez) metotlar
- Java 9: `private` (yalnızca aynı interface'in default/static metotları tarafından
  çağrılabilen, dışa kapalı) metotlar
- İki default metot çakıştığında override zorunludur; `InterfaceAdı.super.metot()` ile
  belirli bir üst interface'in davranışı seçilebilir
- Tam olarak tek soyut metotlu bir interface *functional interface*'tir — lambda
  hedefi olarak kullanılabilir
- Java 17: `sealed` + `permits`, implement edebilecek tipleri kapalı bir listeyle
  sınırlar, `switch` ile birlikte derleyici destekli tüketici (exhaustive) kontrol sağlar

Hızlı referans:

```java
// Temel tanım ve implementasyon
interface Shape {
    double area();                       // örtük: public abstract

    double DEFAULT_SIDES = 4;            // örtük: public static final

    default String describe() {          // Java 8: gövdeli, override edilebilir
        return "area=" + area();
    }

    static Shape unit() {                // Java 8: interface'e ait, örneksiz çağrılır
        return () -> 1.0;
    }

    private double round(double v) {     // Java 9: yalnızca içeriden çağrılabilir
        return Math.round(v * 100) / 100.0;
    }
}

class Circle implements Shape {
    public double area() { return 3.14; }
}

// Çoklu implement + interface genişletme
interface A { }
interface B { }
class C implements A, B { }
interface D extends A, B { }

// Diamond problem çözümü
interface X { default String who() { return "X"; } }
interface Y { default String who() { return "Y"; } }
class Z implements X, Y {
    public String who() { return X.super.who() + Y.super.who(); }
}

// Sealed interface
sealed interface Result permits Success, Failure { }
record Success(String value) implements Result { }
record Failure(String reason) implements Result { }
```

**Terimler Sözlüğü**

**Interface (arayüz)** — Bir tipin davranışını, implementasyondan bağımsız olarak
tanımlayan sözleşme; `interface` anahtar kelimesiyle bildirilir.

**Soyut metot (abstract method)** — Gövdesi olmayan, örtük olarak `public abstract`
sayılan interface metodu; onu implement eden her sınıf bir gövde sağlamak zorundadır.

**`default` metot** — Java 8 ile gelen, gövdesi olan ve implementasyonlar tarafından
override edilebilen interface metodu.

**`static` metot** — Java 8 ile gelen, doğrudan interface adı üzerinden çağrılan,
hiçbir implementasyona ait olmayan ve override edilemeyen interface metodu.

**`private` metot** — Java 9 ile gelen, yalnızca aynı interface'in default/static
metotları tarafından çağrılabilen, dışarıya kapalı yardımcı metot.

**Diamond problem** — Bir sınıfın, iki farklı interface'ten aynı imzalı çakışan default
metotlar miras almasıyla ortaya çıkan, açık override gerektiren belirsizlik durumu.

**`InterfaceAdı.super.metot()`** — Diamond problem'i çözmek için, belirli bir üst
interface'in default metot implementasyonunu açıkça seçmeye yarayan söz dizimi.

**Functional interface** — Tam olarak tek soyut metoda sahip interface; lambda
ifadelerinin ve metot referanslarının hedefi olabilir. `@FunctionalInterface`
annotation'ı bunu derleme zamanında garanti eder.

**`sealed` / `permits`** — Java 17 ile gelen, bir interface'i implement edebilecek
tiplerin tam listesini önceden sınırlayan anahtar kelimeler.

**Marker interface** — Hiçbir metot içermeyen, yalnızca bir tipe JVM/kütüphane
tarafından tanınan özel bir özellik "işaretleyen" interface (`Serializable`,
`Cloneable` gibi).

**Interface Segregation Principle (ISP)** — SOLID prensiplerinden biri; bir
implementasyonu, ihtiyaç duymadığı metotları implement etmeye zorlayan geniş
interface'ler yerine, küçük ve odaklı interface'ler tercih edilmesini savunur.

## Ek: Mini Proje — Basit Plugin/Strateji Sistemi

Şimdiye kadar öğrendiklerimizi ("Çoklu Interface Implement Etmek", "Functional
Interface ve Lambda") birleştirip, çalışma zamanında yeni davranışlar "takılabilen"
küçük bir plugin sistemi yazalım. Fikir basit: bir `NotificationChannel` sözleşmesi
tanımlıyoruz, kayıt defteri (registry) yalnızca bu sözleşmeye güveniyor — hangi somut
sınıfların (ya da lambda'ların) kayıtlı olduğunu hiç bilmeden:

{{PluginRegistry.java}}

{{PluginRegistryDemo.java}}

`PluginRegistry`'nin kodu, `EmailChannel` ya da `SmsChannel`'ın var olduğunu hiç bilmiyor
— hatta üçüncü kanalın bir sınıf bile olmadığına, doğrudan bir lambda olduğuna dikkat et.
Gerçek dünyada Spring'in `@Component` taradığı arayüz implementasyonları, ya da bir
ödeme sağlayıcısını (Stripe/iyzico gibi) tek bir `PaymentGateway` interface'i arkasına
gizleyen bir e-ticaret sistemi, tam olarak bu deseni kullanır.

> 💡 Tip
> Bu mini projede reflection'a hiç ihtiyaç duymadık — Reflection dersindeki "Basit
> Dependency Injection Container" mini projesiyle karıştırma: o container, hangi tipin
> hangi tipe ihtiyaç duyduğunu **çalışma zamanında keşfediyordu**; burada ise hangi
> implementasyonun kullanılacağına programcı `register(...)` çağrısıyla **açıkça**
> karar veriyor. İkisi de "somut sınıfı sabitlememe" fikrine hizmet ediyor, ama farklı
> mekanizmalarla.

## Ek: Mini Proje — Event Bus (Yayınla/Abone Ol)

Son mini proje, `java.util.function.Consumer`'ı genişleten kendi functional
interface'imizi (`OrderPlacedListener`) tanımlayıp, bunun üzerine minimal bir
yayınla/abone ol (publish/subscribe) mekanizması kuruyor — "Functional Interface ve
Lambda" ile "Interface'in Interface'i Genişletmesi" bölümlerinde gördüğümüz iki fikri
birleştiriyor:

{{EventBus.java}}

{{EventBusDemo.java}}

`OrderPlacedListener extends Consumer<OrderPlacedEvent>`, yeni bir soyut metot
eklemiyor — yalnızca `Consumer`'ın `accept(T)`'sini daha anlamlı bir isimle sarmalıyor;
bu yüzden hâlâ geçerli bir functional interface ve hâlâ bir lambda ile implement
edilebiliyor. `EventBusDemo`'daki iki `subscribe(...)` çağrısına dikkat et: `EventBus`,
kaç dinleyici olduğunu, onların ne yaptığını hiç bilmiyor — yalnızca her yayınlanan
olayı, kayıtlı her `OrderPlacedListener`'a sırayla iletiyor.

> 💡 Tip
> Bu desen, Spring'in `ApplicationEventPublisher`/`@EventListener` mekanizmasının,
> gerçek dünya karmaşıklığından (asenkron işleme, hata yönetimi, event hiyerarşisi)
> arındırılmış çekirdek halidir — az sayıda gevşek bağlı (loosely coupled) bileşenin
> birbirine doğrudan referans tutmadan haberleşmesi gerektiğinde tercih edilir.
