# Dependency Injection ve IoC

Bu ders, sitedeki ilk Spring Boot konusu olsa da, henüz Spring'e hiç dokunmuyor --
Dependency Injection (DI) ve Inversion of Control (IoC), Spring'den çok önce var olan,
çerçeveden tamamen bağımsız iki tasarım fikri. Amaç, Spring'in `@Autowired` ile "sihirli"
biçimde yaptığı şeyi önce tamamen elle, saf Java ile yapabilmek; bir sonraki konuda
(Spring IoC Container & Bean Lifecycle) bu elle yaptığımız işi otomatikleştiren container'ın
kendisini işleyeceğiz. Sıkı bağlılık probleminden başlayıp constructor/setter/field
injection'ın üçünü de karşılaştıracak, sonunda Spring'in bu üçünü nasıl otomatikleştirdiğine
kısa bir bakış atacağız.

## Dependency Injection ve IoC Nedir?

En basit haliyle Dependency Injection (DI), bir nesnenin ihtiyaç duyduğu başka nesneleri
(bağımlılıklarını) kendisi `new` ile yaratmak yerine, dışarıdan hazır olarak almasıdır.
Inversion of Control (IoC) ise bunun arkasındaki daha genel fikir: "kontrolün tersine
çevrilmesi" -- normalde bir sınıf kendi bağımlılıklarını ve akışını kendisi yönetirken, IoC bu
kontrolü sınıfın dışına, ayrı bir mekanizmaya (elle yazılmış bir "composition root"a ya da
Spring gibi bir container'a) devreder. DI, IoC'nin en yaygın ve en somut gerçekleştirme
biçimidir:

```java
// DI olmadan: OrderService kendi bağımlılığını kendisi yaratır ve sahiplenir.
class OrderService {
    private final EmailSender sender = new EmailSender();
}

// DI ile: OrderService yalnızca neye ihtiyaç duyduğunu bildirir; hangi
// EmailSender'ın (ya da hangi alternatifin) verileceğine başkası karar verir.
class OrderService {
    private final EmailSender sender;
    OrderService(EmailSender sender) { this.sender = sender; }
}
```

İkinci versiyonda `OrderService`, kendisine verilen `EmailSender`'ın nereden geldiğini hiç
bilmiyor -- bu, ilerleyen bölümlerde tek tek işleyeceğimiz constructor/setter/field
injection'ın üçünün de ortak paydası.

## Neden Var?

Dependency Injection'ın çözdüğü temel problem **sıkı bağlılık (tight coupling)** -- bir
sınıfın, ihtiyaç duyduğu başka bir sınıfın somut implementasyonunu (`new SomeClass()`
satırıyla) doğrudan içinde barındırması. Bunun üç somut maliyeti var: **test edilemezlik**
(gerçek bir e-posta servisiyle test yazmak zorunda kalırsın, ağ çağrısı olmadan test
edemezsin), **değişim zorluğu** (yarın SMS'e geçmek istediğinde `OrderService`'in içine girip
kodu değiştirmen gerekir) ve **karışık sorumluluk** (bir sınıf hem "ne yapacağını" hem
"bağımlılıklarını nasıl kuracağını" aynı anda üstlenir).

DI bu üçünü de, bağımlılığı sınıfın dışına taşıyarak çözer: `OrderService`, hangi
`NotificationSender`'ı kullanacağını değil, yalnızca *bir* `NotificationSender`'a ihtiyacı
olduğunu bilir. Bu ayrım, sonraki bölümlerde göreceğimiz gibi hem testleri hızlandırır hem de
yeni bir kanal eklemeyi, mevcut kodu hiç değiştirmeden mümkün kılar.

## Tarihçe

Dependency Injection kavramı Spring'den önce de vardı -- fikrin kökleri 1990'ların "Inversion
of Control" tartışmalarına uzanır. Ama ismini ve popülerliğini büyük ölçüde Spring
Framework'e borçlu: Rod Johnson, 2002'de yazdığı *Expert One-on-One J2EE Design and
Development* kitabında, dönemin ağır ve karmaşık EJB (Enterprise JavaBeans) modeline karşı
çok daha hafif bir alternatif önerdi -- bu fikirler 2004'te Spring Framework 1.0 olarak
somutlaştı.

Aynı yıl Martin Fowler, "Inversion of Control Containers and the Dependency Injection
pattern" başlıklı makalesinde, o zamana kadar belirsiz kullanılan "Inversion of Control"
terimini netleştirip "Dependency Injection" ismini önerdi -- bugün kullandığımız terminoloji
büyük ölçüde bu makaleden geliyor. 2009'da JSR-330 (`javax.inject`, bugünkü adıyla
`jakarta.inject`), `@Inject` gibi ortak annotation'ları standartlaştırarak DI'ı yalnızca
Spring'e özgü olmaktan çıkardı -- Spring hâlâ kendi `@Autowired`'ını tercih eder, ama
`@Inject`'i de destekler.

## Sıkı Bağlılık (Tight Coupling) Problemi

"Neden Var?" bölümünde sözünü ettiğimiz problemi somut kodda görelim -- bir `OrderService`,
kendi `EmailSender`'ını kendisi yaratıyor:

{{TightlyCoupledOrderService.java}}

`OrderService`, `new EmailSender()` satırını içinde barındırdığı sürece, onu SMS'e
geçirmenin ya da testte sahte bir gönderici kullanmanın tek yolu `OrderService`'in kaynak
kodunu açıp değiştirmektir. Sorun, `EmailSender`'ın kendisinde değil -- `OrderService`'in
*hangi* göndericiyi kullanacağına dair kararı, göndericiyi *kullanma* mantığıyla aynı yere
gömmüş olmasında.

## Inversion of Control (IoC) Nedir?

IoC'nin en küçük hali: nesne yaratma kararını, onu kullanan sınıfın dışına taşımak. Aşağıda
`OrderNotifier`, `EmailMessageSender`'ı artık kendisi `new` ile yaratmıyor -- bu işi ayrı bir
factory'ye devrediyor:

{{ManualFactoryExample.java}}

`OrderNotifier` hâlâ factory'yi kendisi çağırıyor -- kontrol tam olarak henüz tersine
çevrilmiş değil, yalnızca bir adım dışarı taşınmış. Bir sonraki bölümde bu son adımı da
kaldırıp, `OrderService`'in hiçbir şeyi kendisi çağırmadan, hazır bir nesneyi doğrudan
constructor'ından alacağı hâline geleceğiz.

> 💡 Tip
> Bu fikir bazen "Hollywood Principle" (Hollywood İlkesi) diye anılır: "Don't call us, we'll
> call you" -- yani bir bileşen, ihtiyaç duyduğu şeyi kendisi çağırıp istemez, ihtiyacı
> olduğunda dışarıdan kendisine getirilmesini bekler.

## Dependency Injection: Sözleşmeye Karşı Programlamak

Şimdi hem factory adımını hem de somut sınıf bağımlılığını tamamen kaldırıyoruz --
`OrderService`, bir `NotificationSender` **interface'ine** bağımlı, hangi implementasyonun
kullanılacağına ise dışarıdan, constructor aracılığıyla karar veriliyor:

{{NotificationSenderExample.java}}

Bu, Interface dersindeki "implementasyona değil, arayüze göre programla" ilkesinin dependency
injection'a uygulanmış hâli. `OrderService`'in kaynak kodunda `EmailNotificationSender` ya da
`SmsNotificationSender` isimleri hiç geçmiyor -- `main`'deki iki çağrının gösterdiği gibi, aynı
`OrderService`, hiçbir satırı değişmeden iki farklı kanala bağlanabiliyor.

## Constructor Injection

Bağımlılığı vermenin en yaygın yolu, onu bir constructor parametresi olarak almak ve `final`
bir alanda saklamaktır:

{{ConstructorInjectionExample.java}}

`notificationSender` ve `storeName`, `OrderService` nesnesi var olduğu sürece **her zaman**
doludur -- bunları unutup boş bırakmanın hiçbir yolu yok, çünkü derleyici o parametreleri
olmadan bir `OrderService` yaratmana izin vermiyor. "Neden Constructor Injection Öneriliyor?"
bölümünde bu garantinin neden önemli olduğuna daha yakından bakacağız.

## Setter Injection

İkinci yaklaşım, bağımlılığı nesne yaratıldıktan **sonra** bir setter metoduyla vermek:

{{SetterInjectionExample.java}}

Burada `notificationSender` artık `final` değil -- setter'ın onu sonradan doldurabilmesi
için değişebilir kalması gerekiyor. Bunun bedelini `main`'deki ikinci `OrderService` gösteriyor:
`setNotificationSender(...)` çağrılmadan `placeOrder(...)` çağrıldığında hata, nesne
yaratılırken değil, tam da o satırda, çalışma zamanında ortaya çıkıyor.

## Field Injection

Üçüncü yaklaşımda bağımlılık ne constructor'dan ne setter'dan geçer -- doğrudan bir alana
"enjekte edilir". Spring'de bunu `@Autowired` bir alanla görürsün; burada aynı mekanizmayı,
bir framework'ün arka planda ne yaptığını görmek için elle simüle ediyoruz:

{{FieldInjectionExample.java}}

`OrderService`'in hiçbir constructor'ı ya da setter'ı yok -- `field.set(...)` çağrısı,
Reflection dersindeki "Private Alan ve Metotlara Erişmek" bölümünde gördüğümüz tam mekanizmayla,
`private` alana dışarıdan doğrudan yazıyor. Gerçek bir Spring uygulamasında bunu sen değil,
container yapar; ama sonuç aynıdır: `OrderService`'in kaynak koduna bakarak bu alanın nasıl
dolduğunu anlayamazsın.

> ⚠️ Warning
> Field injection, `OrderService`'i test etmek için de reflection gerektirir -- normal bir
> `new OrderService(fakeSender)` çağrısı bağımlılığı hiç ayarlayamaz, çünkü ortada bunu kabul
> eden bir constructor yok. "Yaygın Hatalar" bölümünde bu ve benzer nedenlerle field
> injection'ın neden tercih edilmediğine değineceğiz.

## Injection Türlerini Karşılaştırma

Üç yaklaşımı yan yana koyduğumuzda:

- **Constructor Injection:** bağımlılık `final`, zorunlu, nesne yaratılır yaratılmaz
  garantili. Eksik bir bağımlılık **derleme zamanında** (parametre eksikse) ya da en geç
  nesne yaratılırken yakalanır.
- **Setter Injection:** bağımlılık değişebilir, isteğe bağlı olabilir. Eksik bir bağımlılık,
  yalnızca o bağımlılığın gerçekten kullanıldığı satırda, çalışma zamanında ortaya çıkar.
- **Field Injection:** en az kod (constructor/setter yazmaya gerek yok), ama en az kontrol --
  bağımlılığın nereden geldiği kaynak koddan anlaşılmaz, elle (framework'süz) test etmek
  reflection gerektirir.

Bu üçü birbirini dışlamaz -- aynı sınıfta bir zorunlu bağımlılık constructor'dan, isteğe bağlı
bir tanesi setter'dan gelebilir. Ama pratikte tek bir stil neredeyse her zaman diğerlerine
tercih edilir; bir sonraki bölüm nedenini işliyor.

## Neden Constructor Injection Öneriliyor?

Constructor injection'ın önerilmesinin sebebi rastgele değil -- garantilerinden geliyor:

{{ImmutableOrderService.java}}

`Objects.requireNonNull(...)` sayesinde, `null` bir bağımlılıkla `OrderService` yaratmaya
çalışmak, `main`'in gösterdiği gibi **anında** patlıyor -- hatanın kaynağı, hatanın ortaya
çıktığı satırla aynı yerde. Setter injection'da (bkz. "Setter Injection") bu hata, unutulan
setter çağrısından çok sonra, ilgisiz görünen bir satırda ortaya çıkabilirdi.

> 💡 Tip
> Constructor injection'ın gizli bir faydası daha var: bir constructor'ın parametre listesi
> beşe altıya çıkmaya başladığında, bu genelde sınıfın çok fazla sorumluluk yüklendiğinin
> erken bir işaretidir -- setter/field injection bu "kod kokusunu" gizler, çünkü çok sayıda
> bağımlılık dağınık satırlara yayılır ve tek bakışta fark edilmez.

## Dependency Injection ve Test Edilebilirlik

DI'ın en somut günlük faydası testte ortaya çıkar -- gerçek bir `NotificationSender` yerine,
yalnızca ne gönderildiğini hafızada tutan sahte bir tanesini vermek yeterli:

{{TestableOrderServiceExample.java}}

`FakeNotificationSender`, gerçek bir e-posta sağlayıcısına hiç bağlanmadan çalışıyor -- test,
milisaniyeler içinde bitiyor ve `sentMessages` listesine bakarak `OrderService`'in tam olarak
ne yapmaya çalıştığını doğrulayabiliyoruz. Bu, "Sıkı Bağlılık (Tight Coupling) Problemi"
bölümündeki `TightlyCoupledOrderService`'le hiçbir şekilde mümkün değildi -- orada
`EmailSender`'ı değiştirmenin tek yolu kaynak kodu düzenlemekti.

## Spring Olmadan Elle Bağımlılık Enjeksiyonu (Composition Root)

Buraya kadarki her `main` metodu aslında küçük bir "composition root"tu -- uygulamanın somut
sınıfları bildiği tek yer. Bunu daha büyük bir örnekte, birden fazla bağımlılığı aynı anda
bağlayarak netleştirelim:

{{CompositionRootExample.java}}

`buildOrderService()` dışında, ne `OrderService`'in kendisi ne de onu çağıran kod
`EmailNotificationSender` ya da `ConsoleReceiptPrinter`'ın var olduğunu biliyor. Gerçek bir
uygulamada bu desen "Pure DI" ya da "Poor Man's DI" olarak anılır -- hiçbir framework'e
ihtiyaç duymadan, yalnızca sınıf ve constructor kullanarak IoC'nin tüm faydalarını elde
etmeyi sağlar; küçük uygulamalarda veya framework bağımlılığından kaçınmak istediğinde hâlâ
gayet geçerli bir seçimdir.

## Spring'in DI'ı Nasıl Otomatikleştirdiği (Kısa Bakış)

Az önce elle yazdığımız composition root'u, Spring bir container ile otomatikleştirir --
sınıfları tarayıp (`@Component`/`@Service`), constructor'larını okuyup (`@Autowired`), doğru
sırayla nesneleri kendisi kurar:

{{SpringPreviewExample.java}}

Bu dosya, üzerinde çalışan bir `ApplicationContext` olmadığı için tek başına bir şey yapmıyor
-- tarama yapan, `@Autowired` constructor'ı bulup çağıran, "Spring IoC Container & Bean
Lifecycle" konusunda ele alacağımız container'ın kendisi. Şimdilik önemli olan şu: burada
gördüğün `OrderService` ile "Spring Olmadan Elle Bağımlılık Enjeksiyonu (Composition Root)"
bölümündeki
`OrderService` **tasarım olarak birebir aynı** -- Spring, `buildOrderService()`'in elle
yaptığı işi, annotation'lara bakarak kendisi yapıyor.

> 💡 Tip
> Reflection dersindeki "Basit Dependency Injection Container" mini projesiyle karıştırma:
> orada yazdığımız `SimpleContainer`, bir tipin constructor'ının hangi parametrelere ihtiyaç
> duyduğunu **kendi başına, reflection ile keşfediyordu** -- burada ise hangi implementasyonun
> hangi arayüze bağlanacağını `@Component`/`@Service` ile biz açıkça işaretliyoruz. Spring'in
> gerçek container'ı ikisinin bir karışımıdır: hem reflection kullanır hem de annotation'larla
> yönlendirilir.

## Best Practices

- **Varsayılan olarak constructor injection kullan** -- zorunlu bağımlılıkları `final`
  yapar, eksik bir bağımlılığı en erken noktada yakalar (bkz. "Neden Constructor Injection
  Öneriliyor?").
- **Setter injection'ı yalnızca gerçekten isteğe bağlı bağımlılıklar için sakla** -- bir
  bağımlılık olmadan sınıf anlamlı çalışamıyorsa, onu setter'a değil constructor'a koy.
- **Field injection'dan kaçın** -- ne test edilebilirliği ne de bağımlılıkların açıkça
  görünür olmasını sağlar (bkz. "Field Injection" ve "Yaygın Hatalar").
- **Somut sınıflar yerine arayüzlere bağımlı ol** ("Dependency Injection: Sözleşmeye Karşı
  Programlamak") -- bu, hem gerçek implementasyonlar arasında geçişi hem testte sahte
  implementasyon kullanmayı hiçbir çağıran kodu değiştirmeden mümkün kılar.
- **Bir constructor'ın parametre sayısı arttıkça bunu bir uyarı olarak oku** -- genelde
  sınıfın çok fazla sorumluluk yüklendiğinin işaretidir, ekstra bir parametre eklemek yerine
  sınıfı bölmeyi değerlendir.
- **`Objects.requireNonNull(...)` ile fail-fast davran** ("Neden Constructor Injection
  Öneriliyor?") -- bir bağımlılık eksikse bunu hemen, nesne yaratılırken öğrenmek, çok sonra
  ilgisiz bir hatayla karşılaşmaktan her zaman daha iyidir.

## Yaygın Hatalar

**1. Field injection'ı, "daha az kod yazdığı için" varsayılan tercih yapmak.** Daha az kod,
daha az kontrol demektir -- bağımlılık nereden geliyor, kaynak koddan anlaşılmaz ve elle test
etmek reflection gerektirir (bkz. "Field Injection").

**2. Setter injection'daki eksik bir bağımlılığı, hatanın ortaya çıktığı satırda aramak.**
Hata genelde `setX(...)` çağrısının unutulduğu, çok daha önceki bir satırdan kaynaklanır
(bkz. "Setter Injection").

**3. Bir constructor'ın beş altı parametreye çıkmasını normal karşılamak.** Bu, sınıfın
tek bir sorumluluktan fazlasını yüklendiğinin erken bir işaretidir (bkz. "Neden Constructor
Injection Öneriliyor?").

**4. `Objects.requireNonNull(...)` gibi bir kontrol olmadan, `null` bir bağımlılığın sessizce
kabul edilmesine izin vermek.** Böyle bir nesne başarıyla yaratılır ama ilk gerçek kullanımda,
ilgisiz görünen bir yerde patlar (bkz. "Neden Constructor Injection Öneriliyor?").

**5. DI'ı yalnızca Spring'e özgü bir kavram sanmak.** DI, "Spring Olmadan Elle Bağımlılık
Enjeksiyonu (Composition Root)" bölümünde gördüğümüz gibi hiçbir framework olmadan da
uygulanabilir bir tasarım fikridir -- Spring bunu yalnızca otomatikleştirir.

**6. Somut sınıflara bağımlı kalıp arayüz tanımlamayı atlamak.** Bu, "Neden Var?"
bölümündeki sıkı bağlılık problemini geri getirir ve testte sahte bir implementasyon
kullanmayı imkânsızlaştırır.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Dependency Injection, bir nesnenin bağımlılıklarını kendisi yaratmak yerine dışarıdan
alması; Inversion of Control ise bunun arkasındaki daha genel "kontrolü dışarı devret"
fikridir. Öne çıkan noktalar:

- Sıkı bağlılık (`new` ile doğrudan somut sınıf yaratmak), test edilemezlik, değişim
  zorluğu ve karışık sorumluluğa yol açar
- Üç injection stili: **constructor** (zorunlu, `final`, en erken hata yakalama),
  **setter** (isteğe bağlı, sonradan değişebilir), **field** (en az kod, en az kontrol)
- Constructor injection varsayılan tercih olmalı -- garantili doluluk, fail-fast
  doğrulama, kalabalık parametre listesi erken bir tasarım uyarısı olarak işlev görür
- "Composition root": uygulamanın somut sınıfları bildiği, `new` çağrılarının toplandığı
  tek bir yer -- Spring olmadan da IoC'nin faydalarını sağlar
- Spring, aynı fikri `@Component`/`@Service` taraması ve `@Autowired` ile otomatikleştirir
  -- container'ın kendisi bir sonraki konunun (Spring IoC Container & Bean Lifecycle)
  konusu

Hızlı referans:

```java
// Sıkı bağlılık (kaçınılması gereken)
class OrderService {
    private final EmailSender sender = new EmailSender();
}

// Constructor injection (önerilen varsayılan)
class OrderService {
    private final NotificationSender sender;
    OrderService(NotificationSender sender) {
        this.sender = Objects.requireNonNull(sender);
    }
}

// Setter injection (yalnızca gerçekten isteğe bağlı bağımlılıklar için)
class OrderService {
    private NotificationSender sender;
    void setSender(NotificationSender sender) { this.sender = sender; }
}

// Field injection (Spring: @Autowired; elle karşılığı yok, framework/reflection gerekir)
class OrderService {
    private NotificationSender sender; // framework tarafından reflection ile set edilir
}

// Composition root: somut sınıfları bilen tek yer
class AppComposition {
    static OrderService buildOrderService() {
        return new OrderService(new EmailNotificationSender());
    }
}
```

**Terimler Sözlüğü**

**Dependency Injection (DI)** — Bir nesnenin ihtiyaç duyduğu bağımlılıkları kendisi
yaratmak yerine dışarıdan alması.

**Inversion of Control (IoC)** — Bir bileşenin akışını/bağımlılıklarını kendisinin değil,
dışarıdaki bir mekanizmanın (composition root ya da container) yönetmesi; DI, IoC'nin en
yaygın somut gerçekleştirme biçimidir.

**Sıkı bağlılık (tight coupling)** — Bir sınıfın, ihtiyaç duyduğu başka bir sınıfın somut
implementasyonuna doğrudan (`new` ile) bağımlı olması.

**Constructor Injection** — Bağımlılığın zorunlu bir constructor parametresi olarak
alınıp `final` bir alanda saklanması.

**Setter Injection** — Bağımlılığın, nesne yaratıldıktan sonra bir setter metoduyla,
isteğe bağlı olarak verilmesi.

**Field Injection** — Bağımlılığın, ne constructor ne setter kullanılmadan doğrudan bir
alana (genelde reflection ile, bir framework tarafından) atanması.

**Composition root** — Bir uygulamada somut sınıfların bilindiği, `new` çağrılarının
toplandığı tek bir yer; Pure DI/Poor Man's DI olarak da anılır.

**Fail-fast** — Bir hatanın (örn. eksik bir bağımlılık), ortaya çıktığı en erken noktada
(genelde nesne yaratılırken) fırlatılması; hatanın kaynağını bulmayı kolaylaştırır.

**Test double / fake** — Testte gerçek bir implementasyonun yerine geçen, davranışı
basitleştirilmiş ya da gözlemlenebilir yapılmış bir nesne.

## Ek: Mini Proje — Çok Kanallı Bildirim Dağıtıcısı

Şimdiye kadar öğrendiklerimizi ("Constructor Injection", "Dependency Injection: Sözleşmeye
Karşı Programlamak") birleştirip bir adım ileri götürelim: bağımlılık tek bir
`NotificationSender` değil, **birden fazla implementasyonun tamamı** olsun. Fikir basit --
`NotificationDispatcher`, kaç kanal olduğunu ya da bunların ne olduğunu hiç bilmeden, kendisine
verilen listedeki her kanala aynı mesajı iletiyor:

{{NotificationDispatcher.java}}

{{NotificationDispatcherDemo.java}}

`NotificationDispatcher`'ın constructor'ı, tek bir `NotificationSender` yerine bir
`List<NotificationSender>` alıyor -- composition root, listeye kaç eleman koyacağına
(`allChannels` üç kanallı, `emailOnly` tek kanallı) kendisi karar veriyor, `dispatch(...)`
metodunun tek satırı bile değişmiyor.

> ⚠️ Warning
> Gerçek bir Spring container'ında `List<NotificationSender>` enjekte ettiğinde, listenin
> sırası varsayılan olarak **tanımsızdır** (bean tanım sırasına, hatta sınıf tarama sırasına
> bağlı olabilir) -- belirli bir sıraya ihtiyacın varsa `@Order` annotation'ı ya da
> `Ordered` arayüzü kullanılır. Burada elle yazdığımız `List.of(...)` çağrısında sıra bizim
> kontrolümüzde, ama bu güvence Spring'in otomatik taramasında kendiliğinden gelmez.

## Ek: Mini Proje — Ödeme İşlemcisi

Son mini proje, aynı fikirleri farklı bir alanda (ödeme işleme) ve bir isteğe bağlı
bağımlılıkla ("Injection Türlerini Karşılaştırma" bölümünde bahsettiğimiz gibi her
bağımlılığın zorunlu olması gerekmez) tekrar gösteriyor. `PaymentProcessor`, zorunlu bir
`PaymentGateway`'e (`Objects.requireNonNull`, bkz. "Neden Constructor Injection
Öneriliyor?") ve isteğe bağlı, `null` olabilen bir `FraudChecker`'a bağımlı:

{{PaymentProcessor.java}}

{{PaymentProcessorDemo.java}}

`PaymentProcessorDemo`'daki üç senaryoya dikkat et: dolandırıcılık kontrolüyle, kontrol
olmadan (`null` geçirilerek) ve son olarak "Dependency Injection ve Test Edilebilirlik"
bölümündeki gibi bir lambda ile anında yazılmış sahte bir `PaymentGateway` ile. Üçünde de
`PaymentProcessor`'ın kendi kodu tek bir satır bile değişmiyor.

> 💡 Tip
> `FraudChecker fraudChecker`'ın `null` olabilmesine izin vermek yerine, Spring dünyasında
> bu genelde `Optional<FraudChecker>` ya da `@Autowired(required = false)` ile daha açık
> hâle getirilir -- "Spring IoC Container & Bean Lifecycle" konusunda, isteğe bağlı
> bağımlılıkları Spring'in nasıl ifade ettiğine bakacağız.
