# Component Scanning ve Configuration

Spring IoC Container dersinde bean tanımlamanın tek bir yolunu gördük: `@Configuration`
sınıfları içindeki `@Bean` metotları (Java Config). Bu derste ikinci, çok daha yaygın
kullanılan yolu -- `@Component` ve onun anlamlı türevlerini (`@Service`, `@Repository`,
`@Controller`) sınıfların üzerine koyup container'ın onları kendiliğinden bulmasını
sağlamayı -- işliyoruz. Bunun yanında, Dependency Injection dersinde saf Java ile elle
simüle ettiğimiz field injection'ı gerçek bir container içinde göreceğiz, ve birden
fazla bean arasındaki belirsizliği `@Qualifier`/`@Primary` ile çözeceğiz.

## Component Scanning Nedir?

Component scanning, container'ın classpath'i tarayıp `@Component` (ya da ondan türeyen
bir annotation) ile işaretlenmiş sınıfları kendiliğinden bulup bean olarak
kaydetmesidir -- Java Config'in aksine, hiçbir `@Bean` metodu yazmana gerek kalmaz:

```java
// Java Config (Spring IoC Container dersinde gördüğümüz): bean'i sen tanımlarsın.
@Configuration
class AppConfig {
    @Bean
    OrderService orderService() { return new OrderService(); }
}

// Component scanning: sınıfın kendisini işaretlersin, container onu bulur.
@Service
class OrderService { }
```

İkinci versiyonda hiçbir `@Bean` metodu yok -- `@Service` annotation'ı, `OrderService`'in
kendisine "beni bul ve bir bean olarak kaydet" diyor. Container, `@ComponentScan` ile
işaretlenmiş paketleri tarayıp bu tür sınıfları kendisi keşfediyor.

## Neden Var?

Java Config'in bir sınırı var: her bean için, container'a "bunu nasıl kuracağını"
açıkça söyleyen bir `@Bean` metodu yazman gerekir. Onlarca sınıfın olduğu bir
uygulamada, her biri için ayrı bir `@Bean` metodu yazmak hem tekrarlayıcı hem de yeni
bir sınıf eklendiğinde unutulması kolay bir adım hâline gelir -- sınıfı yazarsın, ama
`AppConfig`'e eklemeyi unutursun, ve bean hiç kaydedilmez.

Component scanning bu sorumluluğu tersine çevirir: bean tanımını, ayrı bir yapılandırma
dosyasında değil, **sınıfın kendisinde** tutar. Yeni bir `@Service` yazdığında, tek
yapman gereken sınıfın kendisini işaretlemek -- taranan bir paketin içindeyse, container
onu otomatik bulur. Bu, özellikle kendi yazdığın (kaynak koduna sahip olduğun) sınıflar
için Java Config'den çok daha az tekrar gerektirir; "Component Scanning vs Java Config:
Ne Zaman Hangisi?" bölümünde bunun her zaman doğru seçim olmadığı durumları
göreceğiz.

## Tarihçe

Component scanning, Spring 2.5 (2007) ile geldi -- o zamana kadar Spring
uygulamaları neredeyse tamamen XML tabanlı bean tanımlarına dayanıyordu (Spring IoC
Container dersindeki "Tarihçe" bölümünde bahsettiğimiz `ClassPathXmlApplicationContext`
döneminden). Aynı sürümde `@Autowired` de tanıtıldı -- bean'leri XML'de elle birbirine
bağlamak yerine, container'ın bağımlılıkları tipe göre otomatik bulup enjekte etmesini
sağladı.

`@Qualifier`, birden fazla aday olduğunda `@Autowired`'ın hangisini seçeceğini
belirtmek için aynı dönemde eklendi. 2009'da JSR-330 standardı (`javax.inject`, bugünkü
adıyla `jakarta.inject`), Spring'in kendi annotation'larına paralel, çerçeveden bağımsız
eşdeğerlerini (`@Inject`, `@Named`) getirdi -- Spring ikisini de destekler, ama bu
projede (ve çoğu Spring kod tabanında) Spring'in kendi annotation'ları tercih edilir.
`@ComponentScan` (Java Config ile birlikte, XML'siz kurulum) ise Spring 3.0 (2009) ile
geldi.

## @Component: Temel Stereotype

Herhangi bir sınıfı bean yapmanın en temel yolu, üzerine `@Component` koymak ve o
sınıfın bir `@ComponentScan` kapsamındaki bir pakette olmasını sağlamaktır:

{{ComponentAnnotationExample.java}}

`GreetingProvider`'ın hiçbir `@Bean` metodu yok, ama yine de `context.getBean(...)` ile
bulunabiliyor -- `AppConfig` üzerindeki `@ComponentScan`, `AppConfig`'in bulunduğu
paketi (burada default package) tarayıp `@Component` işaretli her sınıfı otomatik
kaydediyor.

## Bean Adlandırmasını Özelleştirmek

Spring IoC Container dersindeki "Bean Adlandırma ve Birden Fazla Bean" bölümünde
`@Bean` metotlarının isminin, varsayılan olarak metot adı olduğunu görmüştük --
`@Component` için de benzer bir varsayılan var, istersen değiştirebilirsin:

{{CustomBeanNameExample.java}}

Hiçbir isim vermediğinde (`DefaultNamedSender`), bean adı sınıf adının ilk harfi küçük
hâle getirilmiş versiyonudur (`defaultNamedSender`). `@Component("primaryEmailSender")`
gibi açıkça bir isim verdiğinde, bu varsayılan tamamen yok sayılır -- bean yalnızca
verdiğin isimle bulunabilir.

## @Service, @Repository, @Controller: Anlamlı Stereotype'lar

`@Component`'in kendisi hiçbir katman hakkında bir şey söylemez -- `@Service`,
`@Repository` ve `@Controller`, üzerlerine zaten `@Component` konmuş, yalnızca daha
anlamlı isimler taşıyan özelleşmiş annotation'lardır:

{{StereotypeAnnotationsExample.java}}

Container açısından `@Service` ile `@Component` arasında tarama/kayıt bakımından
hiçbir fark yok -- `AnnotationUtils.findAnnotation(...)` çağrısının `true` dönmesi tam
olarak bunu kanıtlıyor. `@Repository`'nin tek pratik ek özelliği, veritabanı
kütüphanesine özgü checked exception'ları (`SQLException` gibi) Spring'in kendi
`DataAccessException` hiyerarşisine çevirmesidir -- bu proje JPA kullandığı ve JPA
repository'leri farklı bir mekanizmayla (bkz. "Bu Projenin Kendi Sınıfları: Gerçek Bir
Component Scanning Örneği") kaydedildiği
için bu özelliği doğrudan görmüyoruz, ama elle yazdığın bir DAO sınıfında devreye girer.

## @ComponentScan: Hangi Paketler Taranır?

`@ComponentScan`, container'a **nereye** bakacağını söyler -- parametre vermezsen,
`@Configuration` sınıfının kendi paketi (ve alt paketleri) taranır:

{{ComponentScanConfigExample.java}}

Bu projenin kendisinde, `LearningPlatformApplication`'daki `@SpringBootApplication`
(içinde örtük bir `@ComponentScan` barındırır) `com.cdurgun.learning` paketini ve
altındaki her şeyi (`controller`, `service`, `repository`, `config`, `domain`) tarar --
bu yüzden `HomeController`/`TopicController`/`NavigationService` gibi sınıflar hiçbir
yerde elle kaydedilmez. Yukarıdaki örnekte `excludeFilters`, belirli bir sınıfı
taramadan hariç tutmak için kullanılıyor -- gerçek projelerde genelde `basePackages`
ile hangi paketlerin dahil edileceği (ya da `@SpringBootApplication`'da olduğu gibi,
hiçbir şey belirtmeyip yalnızca ana sınıfın paketine güvenmek) tercih edilir.

## Field Injection ile @Autowired (Gerçek Container İçinde)

Dependency Injection dersinin "Field Injection" bölümünde, bir framework'ün
`@Autowired` bir alana ne yaptığını, elle reflection kullanarak simüle etmiştik. Şimdi
aynı şeyi gerçek bir container'a yaptıralım:

{{AutowiredFieldExample.java}}

Kendi kodumuzda hiçbir yerde `Field.setAccessible(true)` ya da `Field.set(...)` yok --
`@Autowired` işaretli `notificationSender` alanı, container tarafından, tam olarak o
mekanizmayla dolduruluyor. Dependency Injection dersindeki "Best Practices" bölümünde
söylediğimiz "field injection'dan kaçın" tavsiyesi burada da geçerli -- bu örnek yalnızca
mekanizmayı göstermek için var, tercih edilen yol değil.

## Setter ve Constructor ile @Autowired

`@Autowired`, field'ların yanı sıra constructor ve setter metotlarına da konabilir --
Dependency Injection dersindeki üç injection stilinin gerçek bir container içindeki
karşılığı budur:

{{AutowiredConstructorSetterExample.java}}

Tek constructor'lı bir sınıfta `@Autowired` yazmak aslında **zorunlu değil** -- Spring
bunu otomatik anlıyor (Spring IoC Container dersinin "Bean Tanımlama: @Bean ile Java
Config" bölümünde bu noktaya kısaca değinmiştik). Yine de burada açıkça yazıldı, çünkü
niyeti okuyan biri için netleştiriyor. Setter'daki `@Autowired` ise zorunlu -- Spring,
hangi setter'ın enjeksiyon için kullanılacağını bilemeyeceğinden, işaretlenmemiş bir
setter asla otomatik çağrılmaz.

## Birden Fazla Bean: @Qualifier ile Belirsizliği Çözmek

Spring IoC Container dersinin "Bean Adlandırma ve Birden Fazla Bean" bölümünde, iki
aynı-tipli bean varken `getBean(Type.class)`'in `NoUniqueBeanDefinitionException`
fırlattığını görmüştük. `@Qualifier`, aynı belirsizliği **enjekte edilen bir
parametre** seviyesinde çözer:

{{QualifierExample.java}}

`@Qualifier("emailSender")`, Spring'e "bu parametre için, `NotificationSender` tipindeki
adaylar arasından ismi tam olarak `emailSender` olanı seç" diyor -- tıpkı elle
`context.getBean("emailSender", NotificationSender.class)` çağırmak gibi, ama bunu
constructor imzasının kendisinde, deklaratif olarak ifade ediyor.

## @Primary: Varsayılan Aday Belirlemek

`@Qualifier` her enjeksiyon noktasına ayrı ayrı yazmak yerine, adaylardan birini
**varsayılan** olarak işaretlemenin bir yolu daha var:

{{PrimaryExample.java}}

`@Primary` işaretli `EmailNotificationSender`, hiçbir `@Qualifier` belirtilmeyen her
enjeksiyon noktasında otomatik seçiliyor. Bu, "çoğu yerde X'i istiyorum, yalnızca
birkaç özel yerde Y'yi" durumları için idealdir -- her yere `@Qualifier` yazmak yerine,
istisnai yerlere yazman yeterli (bir sonraki bölümde tam olarak bunu göreceğiz).

## @Qualifier ve @Primary Bir Arada Kullanıldığında

İkisi aynı anda kullanıldığında hangisi kazanır? Enjeksiyon noktasındaki **açık**
`@Qualifier`, her zaman `@Primary`'nin önüne geçer:

{{QualifierPrimaryTogetherExample.java}}

`EmailOnlyService`, hiçbir `@Qualifier` belirtmediği için `@Primary` işaretli
`EmailNotificationSender`'ı alıyor. `SmsOnlyService` ise açıkça
`@Qualifier("smsSender")` istediği için, `@Primary`'nin varlığı hiç önemli değil --
"en spesifik talep kazanır" kuralı burada da geçerli.

## Component Scanning vs Java Config: Ne Zaman Hangisi?

İkisi de bean tanımlamanın geçerli yolları, ama en doğal oldukları durumlar farklı:

- **Component scanning** (`@Component` ve türevleri), **kendi yazdığın** sınıflar için
  idealdir -- sınıfın kaynak koduna erişimin var, bean tanımını sınıfın kendisiyle
  birlikte tutmak tekrarı azaltır (bkz. "Neden Var?").
- **Java Config** (`@Bean`), kaynak koduna **erişimin olmayan** sınıflar (üçüncü parti
  kütüphaneler) ya da constructor'ı bean olmayan parametreler (bir API anahtarı, bir
  sayı) alan sınıflar için gereklidir -- bunlara annotation koyamazsın.

{{MixedConfigExample.java}}

`NotificationOrchestrator` kendi sınıfımız olduğu için `@Service`; `ThirdPartyMailClient`
ise hem üçüncü parti bir sınıfı temsil ettiği hem de bir API anahtarı parametresi
aldığı için yalnızca `@Bean` ile tanımlanabiliyor. Gerçek uygulamalarda bu iki
yaklaşım neredeyse her zaman bir arada kullanılır -- biri diğerinin yerine geçmez.

## Bu Projenin Kendi Sınıfları: Gerçek Bir Component Scanning Örneği

Bu dersteki her mekanizmayı, bu projenin kendi kaynak kodunda görebilirsin:
`HomeController` ve `TopicController` `@Controller`; `NavigationService`,
`ContentResolver`, `MarkdownService`, `CodeExampleResolver` ise `@Service` ile
işaretli -- hepsi `LearningPlatformApplication`'daki `@SpringBootApplication`'ın örtük
`@ComponentScan`'i sayesinde otomatik bulunuyor.

İlginç bir istisna: `CourseRepository`, `CategoryRepository` gibi repository
arayüzlerinde **hiç `@Repository` annotation'ı yok**. Bunun sebebi, Spring Data JPA'nın
farklı bir mekanizma kullanması -- `JpaRepository`'yi extend eden bir arayüz gördüğünde,
Spring Data (Spring Boot'un auto-configuration'ı sayesinde) bu arayüz için **çalışma
zamanında bir proxy implementasyonu üretir** ve onu bean olarak kaydeder; bu, "Field
Injection ile @Autowired" ya da "@Component: Temel Stereotype" bölümlerinde gördüğümüz
klasik component scanning'den tamamen ayrı bir yol. Spring Boot Auto-Configuration &
Properties dersinde, Spring Boot'un hangi mekanizmaları senin yerine "otomatik"
tetiklediğine daha yakından bakacağız.

## Best Practices

- **Kendi sınıfların için component scanning'i, üçüncü parti/parametre gerektiren
  sınıflar için Java Config'i tercih et** (bkz. "Component Scanning vs Java Config: Ne
  Zaman Hangisi?") -- ikisini birbirinin yerine kullanmaya çalışmak gereksiz zorlanmaya
  yol açar.
- **`@Service`/`@Repository`/`@Controller`'ı, sadece `@Component` yerine, katmanı
  netleştirdiği için tercih et** -- kodu okuyan biri, bir sınıfın hangi katmanda
  olduğunu annotation'a bakarak hemen anlar (bkz. "@Service, @Repository, @Controller:
  Anlamlı Stereotype'lar").
- **Field injection yerine constructor injection kullan** -- bu, Dependency Injection
  dersinde işlediğimiz gerekçelerin (test edilebilirlik, `final` alanlar) hepsi gerçek
  bir container içinde de geçerli (bkz. "Field Injection ile @Autowired (Gerçek
  Container İçinde)").
- **`@Primary`'yi "çoğunlukla bu" durumları için, `@Qualifier`'ı istisnalar için
  kullan** -- her enjeksiyon noktasına `@Qualifier` yazmak yerine bir varsayılan
  belirlemek, kod tekrarını azaltır (bkz. "@Primary: Varsayılan Aday Belirlemek").
- **`@ComponentScan`'de neyin dahil/hariç tutulduğunu açık tut** -- geniş, belirsiz bir
  tarama kapsamı, hangi sınıfların gerçekten bean olduğunu takip etmeyi zorlaştırır
  (bkz. "@ComponentScan: Hangi Paketler Taranır?").

## Yaygın Hatalar

**1. Bir sınıfı yazıp `@Component`/`@Service` eklemeyi unutmak, sonra "neden bean
bulunamadı" diye şaşırmak.** Component scanning yalnızca işaretlenmiş sınıfları bulur
-- işaretlenmemiş bir sınıf, taranan pakette olsa bile asla bean olmaz (bkz.
"@Component: Temel Stereotype").

**2. `@Service`/`@Repository`/`@Controller`'ın `@Component`'ten farklı bir tarama
mekanizması kullandığını sanmak.** Üçü de altında `@Component` taşır, container
açısından tamamen eşdeğerdirler (bkz. "@Service, @Repository, @Controller: Anlamlı
Stereotype'lar").

**3. `@ComponentScan`'in varsayılan olarak **tüm** classpath'i tarayacağını sanmak.**
Parametre verilmezse yalnızca `@Configuration` sınıfının kendi paketi (ve altları)
taranır -- farklı bir pakette kalan bir sınıf hiç bulunmaz (bkz. "@ComponentScan:
Hangi Paketler Taranır?").

**4. Birden fazla aynı-tipli bean varken hiçbir `@Qualifier`/`@Primary` eklememek.**
Bu, uygulama başlangıcında `NoUniqueBeanDefinitionException` ile sonuçlanır -- Spring
IoC Container dersindeki "Bean Adlandırma ve Birden Fazla Bean" bölümünde gördüğümüz
hatanın aynısı (bkz. "Birden Fazla Bean: @Qualifier ile Belirsizliği Çözmek").

**5. Üçüncü parti bir sınıfa (kaynak kodun olmayan) `@Component` eklemeye çalışmak.**
Bu mümkün değildir -- böyle sınıflar yalnızca bir `@Bean` metoduyla tanımlanabilir
(bkz. "Component Scanning vs Java Config: Ne Zaman Hangisi?").

**6. Bu projedeki repository arayüzlerinin `@Repository` annotation'ı olmadığını görüp
"bean olarak kaydedilmemiş" sanmak.** Spring Data JPA, bunları component scanning'den
tamamen ayrı bir mekanizmayla (proxy üretimi) kaydeder (bkz. "Bu Projenin Kendi
Sınıfları: Gerçek Bir Component Scanning Örneği").

## Özet, Cheat Sheet ve Terimler Sözlüğü

Component scanning, container'ın `@Component` (ve türevleri) ile işaretlenmiş
sınıfları classpath'te bulup kendiliğinden bean olarak kaydetmesidir -- Spring IoC
Container dersindeki Java Config'e (`@Bean`) alternatif, çok daha az tekrar gerektiren
bir bean tanımlama yolu. Öne çıkan noktalar:

- `@Component`: temel stereotype, sınıfın kendisini bean işaretler; bean adı
  varsayılan olarak sınıf adının küçük harfli hâli, `@Component("isim")` ile
  özelleştirilebilir
- `@Service`/`@Repository`/`@Controller`: `@Component`'in anlamlı türevleri, container
  için birbirinden farksız
- `@ComponentScan`: hangi paket(ler)in taranacağını belirler; parametresiz kullanımda
  `@Configuration` sınıfının kendi paketi taranır
- `@Autowired`: field, setter ya da constructor'a konabilir; tek constructor'da
  isteğe bağlı, birden fazla setter'da her birine ayrı ayrı yazılmalı
- `@Qualifier("isim")`: enjeksiyon noktasında, aynı tipteki adaylardan hangisinin
  isteneceğini açıkça belirtir
- `@Primary`: birden fazla aday varken, `@Qualifier` belirtilmeyen her yerde
  kullanılacak varsayılan adayı işaretler; açık bir `@Qualifier` her zaman kazanır
- Component scanning kendi sınıfların için, Java Config üçüncü parti/parametreli
  sınıflar için tercih edilir -- ikisi bir arada kullanılır

Hızlı referans:

```java
@Component                          // temel stereotype
@Component("customName")            // özel bean adı
@Service / @Repository / @Controller // anlamlı stereotype'lar (hepsi @Component)

@Configuration
@ComponentScan                      // parametresiz: kendi paketini tarar
// @ComponentScan(basePackages = "com.example")  // belirli paket(ler)
class AppConfig { }

class OrderService {
    @Autowired                      // field injection (tercih edilmez)
    private NotificationSender fieldSender;

    @Autowired                      // constructor injection (tercih edilen)
    OrderService(@Qualifier("emailSender") NotificationSender sender) { }

    @Autowired                      // setter injection
    void setSender(NotificationSender sender) { }
}

@Component
@Primary                            // @Qualifier yoksa varsayılan aday
class EmailSender implements NotificationSender { }
```

**Terimler Sözlüğü**

**Component scanning** — Container'ın classpath'i tarayıp `@Component` (ya da
türevi) ile işaretlenmiş sınıfları kendiliğinden bulup bean olarak kaydetmesi.

**`@Component`** — Bir sınıfı, component scanning tarafından bulunacak temel bir
bean olarak işaretleyen annotation.

**Stereotype annotation** — `@Component`'in, belirli bir katmanı ifade eden
(`@Service`, `@Repository`, `@Controller`) anlamlı türevi; container açısından
`@Component`'ten farksızdır.

**`@ComponentScan`** — Bir `@Configuration` sınıfına, hangi paket(ler)in
taranacağını söyleyen annotation; parametresiz kullanımda kendi paketini tarar.

**`@Autowired`** — Bir alanın, setter'ın ya da constructor'ın, container tarafından
otomatik doldurulmasını/çağrılmasını isteyen annotation.

**`@Qualifier`** — Aynı tipte birden fazla bean adayı olduğunda, bir enjeksiyon
noktasında hangisinin isteneceğini isimle açıkça belirten annotation.

**`@Primary`** — Birden fazla aday arasından, açık bir `@Qualifier` verilmediğinde
kullanılacak varsayılan bean'i işaretleyen annotation.

**Java Config** — `@Configuration` sınıfları içindeki `@Bean` metotlarıyla bean
tanımlama yaklaşımı; component scanning'in alternatifi.

## Ek: Mini Proje — Çok Kanallı Bildirim Ağ Geçidi

Dependency Injection dersindeki "Çok Kanallı Bildirim Dağıtıcısı" mini projesinde
`List<NotificationSender>` enjekte ederek tüm kanallara aynı anda yayın yapmıştık. Bu
kez Spring'in bir başka özel durumunu kullanıyoruz: `Map<String, T>` enjekte edildiğinde,
Spring bu haritayı **bean adı → bean nesnesi** eşlemesiyle otomatik dolduruyor:

{{NotificationGateway.java}}

{{NotificationGatewayDemo.java}}

`NotificationGateway`, hangi kanalların var olduğunu hiç bilmiyor -- `sendersByName`
haritası, `@Component("email")` ve `@Component("sms")` ile verdiğimiz isimlerle
otomatik dolduruluyor. Yeni bir kanal eklemek (`@Component("push")` gibi) istersen,
`NotificationGateway`'in tek satırını bile değiştirmen gerekmez -- tıpkı "Bean
Adlandırmasını Özelleştirmek" bölümünde gördüğümüz isim mekanizmasının, bu kez toplu
hâlde çalışması gibi.

> 💡 Tip
> Bu, "Bean Adlandırma ve Birden Fazla Bean" (Spring IoC Container dersi)
> bölümündeki `NoUniqueBeanDefinitionException` probleminin bambaşka bir çözümü: orada
> belirsizliği tek bir bean seçerek (`@Qualifier`/`@Primary`) çözüyorduk, burada ise
> belirsizliği hiç çözmüyoruz -- tüm adayları, isimleriyle birlikte, aynı anda
> kullanılabilir hâle getiriyoruz.

## Ek: Mini Proje — Kitap Kataloğu (Repository/Service/Controller Katmanları)

Son mini proje, "Bu Projenin Kendi Sınıfları: Gerçek Bir Component Scanning Örneği"
bölümünde bahsettiğimiz üç katmanlı
yapıyı (repository/service/controller) küçük ölçekte, bu projenin gerçek mimarisine
paralel şekilde kuruyor:

{{BookCatalogApp.java}}

{{BookCatalogAppDemo.java}}

`BookController`, `BookService`'e; `BookService` de `BookRepository`'ye bağımlı --
her katman yalnızca bir altındakini tanıyor, `@Autowired` constructor'larla
birbirine bağlanıyor. `BookRepository`'nin (bu projenin gerçek repository'lerinin
aksine) burada gerçek bir `@Repository` annotation'ı taşıdığına dikkat et -- bu,
Spring Data JPA'nın proxy tabanlı mekanizmasını değil, "@Service, @Repository,
@Controller: Anlamlı Stereotype'lar" bölümünde gördüğümüz klasik component scanning'i
kullanıyor.

> ⚠️ Warning
> `BookRepository`'nin `books` listesi, `context.close()` çağrılana kadar bellekte
> yaşayan bir singleton durumdur -- `BookCatalogAppDemo`'daki `addBook(...)` çağrısının
> ikinci `printCatalog()` çıktısında görünmesi tam olarak bu yüzden (bkz. Spring IoC
> Container dersindeki "Bean Scope: Singleton (Varsayılan)"). Gerçek bir uygulamada bu
> veri elbette bir veritabanında (bu projede olduğu gibi PostgreSQL'de) kalıcı olurdu,
> bellekte değil.
