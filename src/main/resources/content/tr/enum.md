# Enum

Java'da **enum** (enumeration), sabit bir değer kümesini tip güvenli şekilde tanımlamanı
sağlayan özel bir referans türüdür. Java 5 ile dile eklendi ve o günden beri "bu değişken
şu birkaç değerden birini alabilir" durumlarının standart çözümü hâline geldi.

## Enum Nedir?

Bir değişkenin alabileceği değerler önceden bilinen, sınırlı bir kümeyse (örneğin haftanın
günleri, bir siparişin durumları, bir kartın rengi), bunu string veya int sabitlerle değil
enum ile modellemelisin. Java'da her enum, arka planda gizlice `java.lang.Enum` sınıfını
extend eden bir sınıftır — yani enum sabitleri aslında birer **nesnedir**, sadece sayısı
sabittir:

```java
enum Day {
    MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}
```

Bu tek satırda Java, arka planda yedi tane `Day` nesnesi (`MONDAY`, `TUESDAY`, ...) oluşturur
ve bunları `static final` alanlar olarak saklar. Bu yüzden enum sabitlerini `==` ile
karşılaştırmak tamamen güvenlidir — `equals()`'a ihtiyaç yoktur.

## Enum vs String

Enum kullanmak, string sabitlere göre derleme zamanında tip güvenliği sağlar. Şu iki
yaklaşımı karşılaştır:

```java
// String ile — derleyici seni korumaz
void setStatus(String status) { ... }
setStatus("APPROVEDD"); // yazım hatası, ama kod derlenir ve sorun çalışma zamanında çıkar

// Enum ile — derleyici seni korur
void setStatus(OrderStatus status) { ... }
setStatus(OrderStatus.APPROVEDD); // derleme hatası — böyle bir sabit yok
```

String ile yazım hatası ancak çalışma zamanında (belki de üretimde) fark edilir; enum ile
aynı hata derleme anında yakalanır. Ayrıca IDE'ler enum kullanırken otomatik tamamlama ve
"olası tüm değerler" listesi sunabilir — string ile bu mümkün değildir.

## Temel Enum Kullanımı

En basit haliyle bir enum şöyle tanımlanır:

{{BasicEnum.java}}

> 💡 Tip
> Enum sabitleri, gelenek olarak büyük harfle yazılır (`MALE`, `FEMALE`) — tıpkı `static
> final` sabitler gibi, çünkü aslında onlar da öyledir.

## Constructor

Enum sabitleri birer nesne olduğu için constructor'ları da olabilir — her sabit
oluşturulurken kendi parametrelerini geçebilir:

{{PlanetEnum.java}}

Burada her gezegen sabiti (`MERCURY`, `VENUS`, `EARTH`), enum'un tanımlandığı satırda kendi
kütle ve yarıçap değerleriyle "inşa ediliyor". Bu constructor çağrısı, sınıf ilk
yüklendiğinde (class loading anında) bir kereye mahsus çalışır — her sabit için tek bir
nesne örneği vardır, tıpkı bir Singleton gibi.

> ⚠️ Warning
> Enum constructor'ları asla `public` ya da `protected` olamaz — Java bunu derleme zamanında
> zorunlu kılar (yalnızca `private` ya da paket-private/varsayılan erişim geçerlidir). Çünkü
> enum sabitleri yalnızca enum'un kendisi tarafından, tanım satırında oluşturulabilir;
> dışarıdan `new Planet(...)` çağırmak mümkün değildir.

## Alanlar (Fields)

Constructor'a geçirilen değerler genellikle `private final` alanlarda saklanır — bu, her
enum sabitinin kendine özgü, değişmez (immutable) verisi olduğu anlamına gelir. Yukarıdaki
`Planet` örneğinde `massKg` ve `radiusM` tam olarak bu şekilde tanımlandı; dışarıya ise
yalnızca getter metotlarıyla açıldı:

{{PlanetUsageExample.java}}

> 💡 Tip
> Enum alanlarını `final` yapmak bir zorunluluk değil ama güçlü bir alışkanlıktır: bir
> sabitin (örneğin `EARTH`) çalışma zamanında farklı bir kütleye "değişmesi" mantıksal
> olarak anlamsızdır — `final`, bunu derleyiciye garanti ettirir.

## Metotlar

Enum'lar sıradan sınıflar gibi instance metotları barındırabilir. `Planet` örneğindeki
`surfaceGravity()` buna zaten bir örnekti. Constructor'a hiç ihtiyaç duymadan, sabit
değerlere göre karar veren bir metot da ekleyebiliriz:

{{DayWithMethod.java}}

```java
for (DayWithMethod day : DayWithMethod.values()) {
    System.out.println(day + " hafta sonu mu? " + day.isWeekend());
}
```

## values()

`values()`, derleyicinin her enum için otomatik ürettiği statik bir metottur; tüm
sabitleri, tanımlandıkları sırayla bir dizi (array) olarak döner — yukarıdaki döngüde
zaten kullandık:

```java
DayWithMethod[] days = DayWithMethod.values();
System.out.println(days.length); // 7
```

> ⚠️ Warning
> `values()` her çağrıldığında yeni bir dizi kopyalar — bir döngü içinde tekrar tekrar
> çağırmak (örneğin `for (int i = 0; i < DayWithMethod.values().length; i++)`) gereksiz
> performans kaybına yol açar. Diziyi bir kere alıp bir değişkende tutmak daha doğrudur.

## valueOf()

`valueOf(String)`, verilen ismi tam olarak eşleşen sabiti döner — eşleşme bulunamazsa
`IllegalArgumentException` fırlatır:

```java
DayWithMethod day = DayWithMethod.valueOf("MONDAY"); // MONDAY
DayWithMethod hata = DayWithMethod.valueOf("monday"); // IllegalArgumentException! Büyük/küçük harfe duyarlı
```

Kullanıcıdan gelen serbest metni doğrudan `valueOf()`'a vermeden önce mutlaka doğrula ya
da çağrıyı `try/catch` ile sarmala.

## name()

`name()`, sabitin kaynak kodda yazıldığı ismi **birebir** döner — `toString()` override
edilmiş olsa bile `name()` her zaman orijinal ismi verir:

```java
System.out.println(DayWithMethod.MONDAY.name()); // "MONDAY"
```

> 💡 Tip
> Kullanıcıya gösterilecek metin için `name()` yerine, ayrı bir `displayName` alanı
> (constructor ile geçirilen) ya da `toString()` override'ı kullan — `name()` sabittir ve
> yerelleştirilemez (i18n'e uygun değildir).

## ordinal()

`ordinal()`, sabitin tanımlandığı sıradaki pozisyonunu (0'dan başlayarak) döner:

```java
System.out.println(DayWithMethod.MONDAY.ordinal()); // 0
System.out.println(DayWithMethod.SUNDAY.ordinal());  // 6
```

Bu bölümün en başında verdiğimiz uyarıyı burada tekrar hatırlatmakta fayda var:
`ordinal()` değerini asla kalıcı veri (veritabanı, dosya, API sözleşmesi) olarak saklama —
enum tanımına yeni bir sabit eklemek ya da sırayı değiştirmek, mevcut verinin anlamını
sessizce bozar.

## switch ile Kullanım

Enum'lar, `switch` ifadeleriyle doğal olarak çok iyi çalışır. Java 21 ile gelen modern
switch söz dizimiyle:

```java
String mesaj = switch (DayWithMethod.SATURDAY) {
    case MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY -> "Çalışma günü";
    case SATURDAY, SUNDAY -> "Hafta sonu";
};
```

> 💡 Tip
> `case` etiketlerinde enum sabitinin adını tek başına yazıyoruz (`MONDAY`), `DayWithMethod.MONDAY` değil — Java bunu switch edilen tipten çıkarım yaparak otomatik tamamlar. Ayrıca tüm sabitleri kapsayan bir switch ifadesinde (yukarıdaki gibi) `default` dalına gerek yoktur; derleyici olası tüm sabitlerin karşılandığını kontrol eder ve eksik varsa hata verir — yeni bir sabit eklendiğinde unutulmuş switch bloklarını derleme zamanında yakalamanın harika bir yolu.

## Arayüz (Interface) İmplementasyonu

Bir enum, sınıf gibi extend edemez (zaten örtük olarak `Enum`'ı extend eder) ama istediğin
kadar arayüz implement edebilir. Bu, enum sabitlerine ortak bir "sözleşme" kazandırmanın
güzel bir yoludur:

{{InterfaceExample.java}}

Burada her `TrafficLight` sabiti aynı `describe()` implementasyonunu paylaşıyor. Bir
sonraki bölümde, her sabitin **kendi** implementasyonunu nasıl yazabileceğini göreceğiz.

## Soyut Metot (Abstract Method) ve Sabite Özel Gövde

Enum'ın en güçlü özelliklerinden biri, her sabitin bir metodun **kendi**
implementasyonunu yazabilmesidir — buna "constant-specific method body" denir:

{{AbstractMethodExample.java}}

> ⚠️ Warning
> Her sabit için ayrı bir gövde yazmak, arka planda her sabit için gizli bir anonim alt
> sınıf oluşturur — güçlü ama "ağır" bir özelliktir. Sadece birkaç sabit ve gerçekten
> farklılaşan davranış varsa kullan; onlarca sabit ve karmaşık mantık varsa ayrı strateji
> sınıfları daha okunur olabilir (bkz. bir sonraki bölüm).

## EnumSet

`EnumSet`, yalnızca enum sabitleri için tasarlanmış, bit vektörü tabanlı çok verimli bir
`Set` implementasyonudur — `HashSet<MyEnum>` kullanmaktan neredeyse her zaman daha hızlı
ve daha az bellek harcar:

{{EnumSetExample.java}}

## EnumMap

`EnumMap<K,V>`, anahtarları enum olan bir `Map` implementasyonudur; içeride bir
`HashMap` yerine, sabitlerin `ordinal()` değerine göre indekslenmiş bir dizi kullanır — bu
da onu `HashMap<MyEnum, V>`'den belirgin şekilde hızlı yapar:

{{EnumMapExample.java}}

> 💡 Tip
> `EnumMap`, sabitleri her zaman `ordinal()` sırasına göre (yani tanımlandıkları sırayla)
> dolaşır — bu, `HashMap`'in aksine öngörülebilir bir iterasyon sırası ister, örneğin
> haftanın günlerini sırayla listelemek gibi durumlarda işine yarar.

## Singleton Deseni

*Effective Java* kitabında Joshua Bloch'un önerdiği gibi, tek elemanlı bir enum, Java'da
bir Singleton yazmanın en güvenli yoludur:

{{SingletonExample.java}}

Kullanım: `ConfigurationManager.INSTANCE.getEnvironment()`.

> ⚠️ Warning
> Bu deseni bu kadar güvenli yapan şey, JVM'in enum sabitlerinin serialization ve
> reflection yoluyla bile ikinci bir örneğinin oluşturulmasına izin vermemesidir — klasik
> "private constructor + static getInstance()" Singleton'ında bu garantiler elle (ve
> hataya açık şekilde) sağlanmalıdır.

## Strategy Pattern

Az önceki `Operation` örneği aslında bir Strategy Pattern uygulamasıydı: her sabit, aynı
arayüzün (burada `apply` metodu) farklı bir "stratejisini" taşıyor. Bunu daha iş odaklı
bir örnekle pekiştirelim:

{{StrategyPatternExample.java}}

Klasik Strategy Pattern'de her strateji için ayrı bir sınıf ve bunları birbirine bağlayan
bir `Factory` yazman gerekirdi; enum ile hem stratejiler hem de "hangi strateji hangi
anahtara karşılık geliyor" eşlemesi tek bir yapıda, ekstra kod olmadan birleşiyor.

## Gerçek Dünya Örnekleri

Enum'ların üretim kodunda en sık göründüğü yerlerden biri durum makineleridir (state
machine). Bir siparişin geçerli durum geçişlerini enum ile modelleyelim:

{{RealWorldExample.java}}

Bu tür bir yapı, "hangi durumdan hangi duruma geçilebilir" kuralını dağınık `if/else`
bloklarına değil, enum'ın kendisine yerleştirir — kural tek bir yerde yaşar ve derleyici,
olası tüm durumların (`switch` exhaustiveness) ele alındığını garanti eder.

Diğer yaygın gerçek dünya kullanımları: HTTP durum kodu kategorileri, kullanıcı
rolleri/yetkileri, ödeme yöntemleri, log seviyeleri (`DEBUG`, `INFO`, `WARN`, `ERROR`) —
hepsi aynı desenin farklı uygulamalarıdır.

## Mülakat Soruları

**Enum, `int` sabitlere göre ne gibi avantajlar sağlar?**
Tip güvenliği (derleme zamanı kontrolü), okunabilirlik, `switch` ile exhaustiveness
kontrolü ve `values()`/`valueOf()` gibi hazır API.

**Bir enum başka bir sınıfı extend edebilir mi?**
Hayır — her enum örtük olarak `java.lang.Enum`'ı extend eder ve Java tek kalıtımı
desteklediği için başka bir sınıfı extend edemez. Ancak istediği kadar arayüz implement
edebilir.

**`==` ile `equals()` enum sabitleri için aynı sonucu verir mi?**
Evet. Her enum sabiti JVM'de tek bir örnek olarak var olduğundan, `==` ile referans
karşılaştırması `equals()` ile aynı sonucu üretir. Yine de gelenek olarak `equals()`
tercih edilir.

**`ordinal()`'ı neden veri saklamak için kullanmamalıyız?**
Çünkü sabitlerin sırası (dolayısıyla ordinal değerleri) kaynak kodda değişebilir; bu
durumda önceden kaydedilmiş bir ordinal değeri artık yanlış sabiti işaret edebilir.
Bunun yerine `name()` (ya da özel bir kod alanı) sakla.

**Enum'lar `Serializable` mıdır?**
Evet, `java.lang.Enum` zaten `Serializable`'ı implement eder ve JVM enum
serialization'ını özel olarak ele alır (sabit, `name()` üzerinden yeniden çözülür) — bu
yüzden özel bir `readObject`/`writeObject` yazmana gerek kalmaz, hatta yazman
önerilmez.

**Bir enum `clone()`'lanabilir mi?**
Hayır. `Enum.clone()` `CloneNotSupportedException` fırlatır — çünkü her sabitin JVM'de
tek bir örneği olması garanti edilmelidir; klonlama bu garantiyi bozar.
