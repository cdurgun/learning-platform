# Spring IoC Container ve Bean Yaşam Döngüsü

Dependency Injection ve IoC dersinde "Spring Olmadan Elle Bağımlılık Enjeksiyonu
(Composition Root)" bölümünde kendi elimizle yaptığımız işi -- somut sınıfları bilip
`new` ile nesneleri doğru sırayla kurmak -- bu derste gerçek bir Spring container'ının
nasıl otomatikleştirdiğini işliyoruz. İlk kez burada gerçek bir `ApplicationContext`
ayağa kaldırıp kapatacağız; bean'lerin ne zaman yaratıldığını, hangi sırayla
başlatıldığını, ne zaman kapatıldığını ve kaç kopyasının var olduğunu (scope) elle
gözlemleyeceğiz.

## Spring IoC Container Nedir?

Spring IoC container, Dependency Injection ve IoC dersindeki composition root'un
otomatikleştirilmiş hâlidir -- sınıfları/tanımları okur, aralarındaki bağımlılık
grafiğini çıkarır, nesneleri doğru sırayla kurar ve onların tüm yaşam döngüsünü
(yaratma, başlatma, kullanılabilir olma, kapatma) yönetir:

```java
// "Spring Olmadan Elle Bağımlılık Enjeksiyonu (Composition Root)" bölümünde
// elle yaptığımız iş:
static OrderService buildOrderService() {
    NotificationSender sender = new EmailNotificationSender();
    return new OrderService(sender);
}

// Container'ın aynı işi otomatik yapması:
ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
OrderService orderService = context.getBean(OrderService.class);
```

İkinci versiyonda `new OrderService(...)` satırını sen değil, container yazıyor --
`AppConfig` içindeki `@Bean` metotlarına bakarak hangi nesnenin hangi bağımlılığa
ihtiyaç duyduğunu kendisi çıkarıyor.

## Neden Var?

"Spring Olmadan Elle Bağımlılık Enjeksiyonu (Composition Root)" bölümündeki
`buildOrderService()` gibi elle yazılmış bir kurulum
metodu, birkaç nesne için gayet yönetilebilir. Ama bir uygulama büyüdükçe -- yüzlerce
sınıf, aralarında karmaşık bağımlılıklar, bazılarının uygulama boyunca tek bir kopyası
olması gerekirken bazılarının her seferinde yeniden yaratılması gerektiği, bazılarının
başlarken bir kaynağı (veritabanı bağlantısı gibi) açıp kapanırken serbest bırakması
gerektiği bir sistem -- bu elle yazılan kurulum kodu hızla kendi başına bakım gerektiren,
hataya açık bir katmana dönüşür.

Container bunu üç şeyi merkezi olarak yöneterek çözer: **bağımlılık grafiğini çözme**
(hangi nesne hangisine ihtiyaç duyuyor, hangi sırayla kurulmalı), **yaşam döngüsü**
(bir nesne ne zaman "hazır" sayılır, kapanışta ne çalışmalı) ve **scope** (bir nesnenin
uygulama boyunca tek mi yoksa her istekte yeni bir kopya mı olacağı). Bu derste üçünü de
sırasıyla işleyeceğiz.

## Tarihçe

Spring'in container'ı, Spring Framework 1.0 (2004) ile birlikte `BeanFactory`
arayüzüyle başladı -- minimal, yalnızca bean tanımlarını tutup istendiğinde nesne
üreten temel bir mekanizma. Kısa süre sonra `ApplicationContext` geldi: `BeanFactory`'yi
kapsayan (aslında onu extend eden), üzerine olay yayınlama (event publishing),
uluslararasılaştırma (mesaj kaynakları) ve AOP-dostu proxy oluşturma gibi "kurumsal"
özellikler ekleyen daha zengin bir arayüz.

Başlangıçta bean tanımları XML dosyalarında yapılıyordu (`ClassPathXmlApplicationContext`
ile okunurdu); Spring 3.0 (2009) `@Configuration`/`@Bean` ile Java tabanlı
konfigürasyonu (`AnnotationConfigApplicationContext`) getirdi -- bugün bu projede de
kullandığımız yöntem bu. Spring Boot (2014), bir sonraki konuda (Spring Boot
Auto-Configuration & Properties) derinlemesine işleyeceğimiz gibi, bu container'ı
`SpringApplication.run(...)` arkasında otomatik olarak kurup yapılandırarak, elle
`ApplicationContext` yaratma ihtiyacını neredeyse tamamen ortadan kaldırdı.

## BeanFactory: Kök Arayüz

Container hiyerarşisinin en altında `BeanFactory` var -- bean tanımlarını tutan,
istenildiğinde nesne üreten, ama başka hiçbir "kurumsal" özelliği olmayan minimal
arayüz. Önemli bir özelliği: **tembeldir (lazy)** -- bir bean tanımı kaydetmek, o
nesneyi yaratmaz:

{{BeanFactoryExample.java}}

`registerBeanDefinition(...)` çağrısından sonra `EmailNotificationSender`'ın
constructor'ı hâlâ çalışmamış -- `main`'deki çıktı sırası bunu net gösteriyor. Nesne,
yalnızca `getBean(...)` ile gerçekten istendiği an yaratılıyor. Bir sonraki bölümde
göreceğimiz gibi, `ApplicationContext` bu varsayılanı değiştiriyor.

## ApplicationContext: BeanFactory'nin Üzerine İnşa Edilen Katman

`ApplicationContext`, `BeanFactory`'yi genişletir ama davranışça önemli bir farkı
vardır: **singleton bean'leri tembel değil, context oluşturulur oluşturulmaz hemen
(eager) yaratır**:

{{ApplicationContextExample.java}}

`BeanFactoryExample`'daki sıranın tam tersine dikkat et: burada `EmailNotificationSender
constructed` satırı, `getBean(...)` çağrılmadan, `AnnotationConfigApplicationContext`'in
constructor'ı çalışırken (context "refresh" edilirken) yazdırılıyor. Bu yüzden gerçek
Spring uygulamalarında (Spring Boot dahil) neredeyse her zaman `ApplicationContext`
kullanılır -- `BeanFactory`, container'ın kavramsal temelini anlamak için değerli, ama
günlük kullanımda doğrudan karşına nadiren çıkar.

## Spring Bean Nedir?

"Bean", container tarafından yaratılan, yapılandırılan ve yaşam döngüsü boyunca
yönetilen herhangi bir nesnedir -- Java'daki sıradan bir sınıftan hiçbir farkı yok,
farkı yaratılış ve yönetilme şeklinde:

{{SpringBeanBasicsExample.java}}

`getBeanDefinitionNames()` çıktısında yalnızca senin `@Bean` metotlarınla tanımladığın
`receiptPrinter` değil, Spring'in kendi altyapısı için kaydettiği bean'ler de görünür --
container, kendi iç işleyişini de aynı mekanizmayla yönetir. `byType == byName`
karşılaştırması `true` çıkıyor çünkü ("ApplicationContext: BeanFactory'nin Üzerine İnşa
Edilen Katman" bölümünde gördüğümüz gibi) varsayılan olarak her bean tek bir örnek --
bunu "Bean Scope: Singleton (Varsayılan)" bölümünde derinleştireceğiz.

## Bean Tanımlama: @Bean ile Java Config

`@Configuration` sınıfları içindeki `@Bean` metotları, hangi nesnenin nasıl
yaratılacağını tanımlar -- bir `@Bean` metodu başka bir `@Bean`'e parametre olarak
ihtiyaç duyduğunda, Spring bunu tıpkı bir constructor parametresi gibi çözer:

{{JavaConfigBeanExample.java}}

`orderService(NotificationSender notificationSender)` metodunun parametresi, Spring
Boot'a değinmeden önce Dependency Injection dersinde elle yazdığımız `OrderService`
constructor'ının birebir aynısı -- fark, `new OrderService(notificationSender)`
satırını artık senin değil, container'ın çağırmasında. Component Scanning &
Configuration dersinde, bu Java-config yaklaşımını `@Component` taramasıyla (bean
tanımlamanın ikinci yolu) karşılaştıracağız.

## Bean Adlandırma ve Birden Fazla Bean

Aynı arayüzün birden fazla implementasyonu bean olarak tanımlandığında, `getBean(Type)`
artık hangisini kastettiğini bilemez -- bunun için bean'lerin isimleri (varsayılan
olarak `@Bean` metodunun adı) devreye girer:

{{MultipleBeansExample.java}}

İki `NotificationSender` bean'i varken `context.getBean(NotificationSender.class)`
çağırmak `NoUniqueBeanDefinitionException` fırlatıyor -- container hangisini
istediğini tahmin etmeye çalışmıyor, açıkça bir isim ister. Bu belirsizliği
`@Qualifier` ve `@Primary` ile *enjekte edilen bir constructor parametresi* seviyesinde
nasıl çözeceğimizi Component Scanning & Configuration dersinde işleyeceğiz -- burada
gördüğün isimle `getBean(...)` çağrısı, o annotation'ların altında yatan aynı
mekanizmadır.

## Bean Lifecycle: Container'ın Bir Bean'i İnşa Etme Adımları

Bir bean'in "hazır" hâle gelmesi tek bir adım değil -- container, her bean için
sabit bir sıra izler. Bunu, her bean'in başlatılmasını saran özel bir bileşenle
(`BeanPostProcessor`) gözlemleyelim:

{{BeanLifecyclePhasesExample.java}}

Çıktı sırası tam olarak şu adımları izliyor: (1) constructor çalışır, (2) bağımlılıklar
zaten constructor'da set edilmiş olur, (3) `BeanPostProcessor.postProcessBeforeInitialization`
her bean için çalışır, (4) `@PostConstruct` metodu çalışır, (5)
`postProcessAfterInitialization` çalışır -- ve bean artık kullanıma hazırdır.
Kapanışta (`context.close()`) bu sıranın tersine yakın bir şekilde `@PreDestroy`
çalışır. Sıradaki iki bölüm, adım (4) ve kapanıştaki adıma iki farklı açıdan
(annotation ve interface) daha yakından bakıyor.

## @PostConstruct ve @PreDestroy

Bir bean'in, constructor'ı bittikten (tüm bağımlılıkları set edildikten) sonra
çalışması gereken bir kurulum adımı varsa (`@PostConstruct`), ya da container
kapanırken serbest bırakması gereken bir kaynağı varsa (`@PreDestroy`), bu iki
annotation tam olarak bunun için var:

{{PostConstructPreDestroyExample.java}}

`ConnectionPool`'un kendisi hiçbir Spring arayüzü implement etmiyor -- yalnızca iki
metodunu annotation'la işaretliyor. `context.close()` çağrıldığında her yönetilen
bean'in `@PreDestroy` metodu otomatik çalışır; bu, "Spring Olmadan Elle Bağımlılık
Enjeksiyonu (Composition Root)" bölümünde elle `new` ile yaratılmış nesnelerde asla
bedava gelmeyen bir garanti -- kimin ne zaman `close()`/`cleanup()` çağıracağını sen
takip etmek zorunda kalırdın.

## InitializingBean ve DisposableBean Arayüzleri

`@PostConstruct`/`@PreDestroy`'dan önce, aynı işi yapmanın tek yolu iki Spring
arayüzünü implement etmekti -- hâlâ çalışır, ama bu yaklaşımın bir bedeli var:

{{InitializingDisposableBeanExample.java}}

`LegacyStyleConnectionPool implements InitializingBean, DisposableBean` yazdığın an,
bu sınıf artık Spring'e bağımlı hâle geliyor -- container olmadan derlenemez bile.
`@PostConstruct`/`@PreDestroy` ise yalnızca standart Java annotation'ları (`jakarta.annotation`
paketinden), sınıfın kendisi Spring'i hiç import etmeden de anlamlı kalır. Bu yüzden
günümüzde neredeyse her zaman annotation tabanlı yaklaşım tercih edilir; arayüz tabanlı
yaklaşımı büyük ölçüde eski kod tabanlarında görürsün.

## Bean Scope: Singleton (Varsayılan)

Bir bean'in **scope**'u, container'ın kaç kopyasını tutacağını belirler.
Varsayılan (hiçbir şey belirtmesen bile geçerli olan) scope singleton'dır -- container
başına tek bir örnek:

{{SingletonScopeExample.java}}

`first` ve `second`, aynı nesneyi işaret ediyor (`==` karşılaştırması `true`) --
`first.increment()` ile yapılan değişiklik, `second` üzerinden de görünüyor, çünkü
ikisi de aynı `Counter`. Bu, "Spring Bean Nedir?" bölümünde `byType == byName`
karşılaştırmasında gördüğümüz davranışın nedeni.

> ⚠️ Warning
> Singleton bir bean'in **mutable (değişebilir) durum** tutması, çok kolayca
> beklenmedik paylaşılan durum hatalarına yol açar -- `Counter` burada kasıtlı olarak
> basit tutuldu, ama gerçek bir uygulamada birden fazla thread aynı singleton bean'e
> aynı anda erişebileceği için (Threads dersindeki race condition'ları hatırla),
> singleton bean'lerin ya thread-safe olması ya da mutable durumdan tamamen
> kaçınması gerekir.

## Bean Scope: Prototype

`@Scope("prototype")` ile işaretlenen bir bean'de bu varsayılan tersine döner --
her `getBean(...)` çağrısı, container'ın **yeni bir örnek** yarattığı anlamına gelir:

{{PrototypeScopeExample.java}}

"Bean Scope: Singleton (Varsayılan)" bölümündeki örnekle birebir aynı `Counter`
sınıfı, yalnızca `@Scope` annotation'ı eklenince tamamen farklı davranıyor -- `first`
ve `second` artık birbirinden bağımsız, `first`'ü artırmak `second`'ı hiç etkilemiyor.
Bu, uygulama boyunca paylaşılmaması gereken (örneğin her kullanıcı işlemi için ayrı
tutulması gereken) durum için tercih edilir.

## Web Scope'ları: Request, Session, Application (Kısa Bakış)

Singleton ve prototype dışında, yalnızca bir web uygulaması bağlamında (bu proje gibi
bir Spring MVC uygulamasında) anlamlı olan üç scope daha vardır -- bunlar standalone
bir `AnnotationConfigApplicationContext` ile test edilemez, çünkü varlıkları bir HTTP
isteğine bağlıdır:

```java
@Bean
@RequestScope   // tek bir HTTP isteği boyunca tek örnek
ShoppingCart requestScopedCart() { return new ShoppingCart(); }

@Bean
@SessionScope   // tek bir kullanıcı oturumu boyunca tek örnek
ShoppingCart sessionScopedCart() { return new ShoppingCart(); }

@Bean
@ApplicationScope   // tüm ServletContext boyunca tek örnek (singleton'a çok yakın)
ShoppingCart applicationScopedCart() { return new ShoppingCart(); }
```

`@RequestScope`, her HTTP isteği için farklı bir örnek verir (bir sonraki istekte eski
örnek yok olur); `@SessionScope`, aynı kullanıcının farklı istekleri arasında aynı
örneği korur (örneğin bir alışveriş sepeti); `@ApplicationScope` ise pratikte
singleton'a çok benzer, ama `ServletContext`'e bağlıdır. Bu proje şu an bu üç scope'u
hiç kullanmıyor (`HomeController`/`TopicController` stateless çalışıyor), ama gerçek
bir Spring MVC uygulamasında sıkça karşına çıkarlar.

## Lazy Initialization: @Lazy

"ApplicationContext: BeanFactory'nin Üzerine İnşa Edilen Katman" bölümünde gördüğümüz
gibi, `ApplicationContext` singleton bean'leri varsayılan olarak hemen (eager) yaratır.
`@Lazy` bu varsayılanı tek tek bean bazında geri alır:

{{LazyInitializationExample.java}}

`EagerService`'in constructor'ı context oluşturulurken hemen çalışıyor, ama
`@Lazy` işaretli `LazyService`'inki, yalnızca `getBean(LazyService.class)` gerçekten
çağrıldığında çalışıyor -- tıpkı ham `BeanFactory`'nin varsayılan davranışı gibi.
Bu, yaratılması pahalı ama her çalıştırmada mutlaka kullanılmayan bean'ler için
başlangıç süresini kısaltmak amacıyla kullanılır.

## Circular Dependency: Neden Olur, Nasıl Çözülür

`A`, `B`'ye ihtiyaç duyuyor; `B` de `A`'ya ihtiyaç duyuyor -- ikisi de constructor
injection kullanıyorsa, container'ın hiçbirini önce bitiremeyeceği bir çıkmaz oluşur:

{{CircularDependencyExample.java}}

`@Lazy` burada `ServiceB`'nin constructor'ındaki `ServiceA` parametresine
uygulanıyor -- Spring, gerçek `ServiceA` yerine onun yerine geçen bir proxy enjekte
ediyor; bu proxy, yalnızca ilk gerçek metot çağrısında asıl `ServiceA` bean'ini
çözüyor. Bu noktada `ServiceB`'nin kurulumu tamamlanabiliyor, dolayısıyla `ServiceA`
da kurulumunu bitirebiliyor. `@Lazy` olmasaydı bu kod `BeanCurrentlyInCreationException`
ile (bir `BeanCreationException`'a sarılmış olarak) patlardı -- container sonsuz
döngüye girmek yerine çemberi tespit edip hemen hata verir.

> 💡 Tip
> `@Lazy` tek çözüm değil -- constructor injection yerine bir tarafta setter
> injection'a geçmek de çemberi kırar, çünkü Spring bir bean'i "yarı hazır" (constructor
> tamamlanmış ama setter'lar henüz çağrılmamış) hâlde önce oluşturup, döngüdeki diğer
> bean'i bu yarı hazır referansla besleyebilir. Ama Dependency Injection dersindeki
> "Neden Constructor Injection Öneriliyor?" bölümünde işlediğimiz gerekçelerle, çoğu
> ekip bunun yerine `@Lazy`'yi ya da (daha da iyisi) sınıfları yeniden tasarlayıp
> çemberi tamamen ortadan kaldırmayı tercih eder -- bir circular dependency genelde,
> tıpkı çok parametreli bir constructor gibi, iki sınıfın birbirine fazla bağımlı
> tasarlandığının erken bir işaretidir.

## Spring Boot'ta ApplicationContext (Kısa Bakış)

Bu dersteki her örnekte `ApplicationContext`'i elle yarattık
(`new AnnotationConfigApplicationContext(...)`). Bu projenin kendi
`LearningPlatformApplication` sınıfına bakarsan, bunu hiç görmezsin:

```java
@SpringBootApplication
public class LearningPlatformApplication {
    public static void main(String[] args) {
        SpringApplication.run(LearningPlatformApplication.class, args);
    }
}
```

`SpringApplication.run(...)`, arka planda tam olarak bu derste elle yaptığımız işi
yapıyor -- bir `ApplicationContext` yaratıyor, bean'leri kaydediyor, context'i
"refresh" ediyor -- üstüne bir de embedded web sunucusu (Tomcat) başlatıp uygulamayı
ayakta tutuyor. Bu container'ın bean'leri nereden bulduğunu (component scanning) ve
Spring Boot'un hangi bean'leri "senin yerine" otomatik tanımladığını (auto-configuration)
sırasıyla Component Scanning & Configuration ve Spring Boot Auto-Configuration &
Properties derslerinde işleyeceğiz.

## Best Practices

- **Elinden geldiğince `ApplicationContext` kullan, `BeanFactory`'yi doğrudan
  kullanmaktan kaçın** -- gerçek uygulamalarda (Spring Boot dahil) zaten hep bu şekilde
  çalışırsın (bkz. "ApplicationContext: BeanFactory'nin Üzerine İnşa Edilen Katman").
- **`@PostConstruct`/`@PreDestroy`'ı `InitializingBean`/`DisposableBean`'e tercih et**
  -- sınıfını Spring'e bağımlı kılmadan aynı garantiyi verir (bkz. "InitializingBean ve
  DisposableBean Arayüzleri").
- **Singleton bean'leri stateless tut ya da thread-safe yap** -- tüm uygulama boyunca
  tek bir örnek paylaşıldığı için, mutable durum kolayca eşzamanlılık hatasına dönüşür
  (bkz. "Bean Scope: Singleton (Varsayılan)").
- **Prototype scope'u yalnızca gerçekten "her seferinde yeni" gereken durumlar için
  kullan** -- prototype bean'lerin `@PreDestroy`'u container tarafından
  çağrılmaz, temizlik sorumluluğu sana geçer.
- **Bir circular dependency'yi `@Lazy` ile "gizlemek" yerine, mümkünse tasarımı
  değiştirerek ortadan kaldırmayı düşün** -- genelde iki sınıfın birbirine fazla
  bağımlı olduğunun işaretidir (bkz. "Circular Dependency: Neden Olur, Nasıl
  Çözülür").
- **`@Lazy`'yi yalnızca gerçekten pahalı ya da nadiren kullanılan bean'ler için
  kullan** -- her şeyi lazy yapmak, hataların (örn. eksik bir konfigürasyon) uygulama
  başlangıcında değil, çok daha sonra, ilgisiz bir anda ortaya çıkmasına yol açar.

## Yaygın Hatalar

**1. `BeanFactory` ile `ApplicationContext`'in aynı şeyi yaptığını sanmak.**
`ApplicationContext` singleton'ları eager yaratır, `BeanFactory` lazy'dir -- bu fark,
başlangıçtaki (ya da tam tersi, hiç çağrılmayan) bir hatanın ne zaman ortaya çıkacağını
değiştirir (bkz. "BeanFactory: Kök Arayüz" ve "ApplicationContext: BeanFactory'nin
Üzerine İnşa Edilen Katman").

**2. Aynı arayüzden iki bean tanımlayıp `getBean(Type.class)`'in "birini" seçeceğini
ummak.** Container asla tahmin etmez -- `NoUniqueBeanDefinitionException` fırlatır
(bkz. "Bean Adlandırma ve Birden Fazla Bean").

**3. `@PostConstruct` metodunun constructor'la aynı anda çalıştığını sanmak.**
`@PostConstruct`, tüm bağımlılıklar set edildikten **sonra** çalışır -- constructor
içinde henüz hazır olmayan bir şeye güvenip iş yapmak yerine, o işi `@PostConstruct`'a
taşımak bu yüzden vardır (bkz. "Bean Lifecycle: Container'ın Bir Bean'i İnşa Etme
Adımları").

**4. Prototype scope'lu bir bean'in `@PreDestroy`'unun container kapanırken otomatik
çalışacağını beklemek.** Container, prototype bean'in ne zaman artık kullanılmadığını
bilemez -- temizlik sorumluluğu bean'i alan koda geçer (bkz. "Bean Scope: Prototype").

**5. Circular dependency hatasını, sınıfları yeniden düşünmeden doğrudan `@Lazy` ile
"susturmak".** Çoğu zaman hızlı bir düzeltme olsa da, altında yatan tasarım sorununu
(iki sınıfın birbirine fazla bağımlı olması) çözmez (bkz. "Circular Dependency: Neden
Olur, Nasıl Çözülür").

**6. Web scope'larını (`@RequestScope`/`@SessionScope`) bir web isteği bağlamı
olmadan kullanmaya çalışmak.** Bu üçü yalnızca gerçek bir HTTP isteği/oturumu
içindeyken anlamlıdır -- standalone bir `main` metodunda `getBean(...)` ile
çağırmak hataya yol açar (bkz. "Web Scope'ları: Request, Session, Application (Kısa
Bakış)").

## Özet, Cheat Sheet ve Terimler Sözlüğü

Spring IoC container, Dependency Injection dersinde elle yaptığımız composition
root'u otomatikleştiren mekanizmadır -- bean'leri tanımlar, aralarındaki bağımlılığı
çözer, yaşam döngülerini yönetir ve scope'larına göre kaç kopya tutacağına karar
verir. Öne çıkan noktalar:

- `BeanFactory`: kök arayüz, lazy (bean tanımı ≠ bean nesnesi); `ApplicationContext`:
  `BeanFactory`'nin üzerine kurulu, singleton'ları eager yaratan, gerçek
  uygulamalarda kullanılan katman
- Bean yaşam döngüsü sırası: constructor → bağımlılıklar set edilir →
  `BeanPostProcessor` (before) → `@PostConstruct` → `BeanPostProcessor` (after) →
  kullanıma hazır → (`context.close()`'da) `@PreDestroy`
- `@PostConstruct`/`@PreDestroy` (annotation tabanlı) her zaman
  `InitializingBean`/`DisposableBean`'e (arayüz tabanlı, Spring'e bağımlı kılar)
  tercih edilir
- Scope: **singleton** (varsayılan, container başına tek örnek), **prototype**
  (her `getBean()` yeni örnek), **request/session/application** (yalnızca web
  bağlamında anlamlı)
- `@Lazy`, singleton'ların varsayılan eager yaratılışını tek tek bean bazında geri
  alır; circular dependency'yi çözmek için de kullanılabilir
- Circular dependency, constructor injection'da container'ın çözemediği bir çıkmaz
  yaratır (`BeanCurrentlyInCreationException`) -- `@Lazy` ya da setter injection'a
  geçmek çözer, ama kök neden genelde bir tasarım sorunudur

Hızlı referans:

```java
// ApplicationContext yaratmak
ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

@Configuration
class AppConfig {
    @Bean
    MyService myService() { return new MyService(); }

    @Bean
    @Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
    MyPrototype myPrototype() { return new MyPrototype(); }

    @Bean
    @Lazy
    ExpensiveService expensiveService() { return new ExpensiveService(); }
}

// Bean lifecycle
class ManagedBean {
    @PostConstruct
    void init() { /* bağımlılıklar hazır, kurulum burada */ }

    @PreDestroy
    void cleanup() { /* container kapanırken kaynak serbest bırak */ }
}

// Circular dependency çözümü
class ServiceB {
    ServiceB(@Lazy ServiceA serviceA) { /* proxy enjekte edilir, deadlock önlenir */ }
}

context.close(); // tüm singleton bean'lerin @PreDestroy'unu tetikler
```

**Terimler Sözlüğü**

**BeanFactory** — Spring container'ının kök arayüzü; bean tanımlarını tutar,
istenildiğinde (lazy) nesne üretir.

**ApplicationContext** — `BeanFactory`'yi genişleten, singleton'ları eager yaratan ve
olay yayınlama gibi ek özellikler sunan, gerçek uygulamalarda kullanılan container
arayüzü.

**Bean** — Container tarafından yaratılan, yapılandırılan ve yaşam döngüsü boyunca
yönetilen herhangi bir nesne.

**Bean definition (bean tanımı)** — Bir bean'in nasıl yaratılacağına dair
container'a verilen bilgi (hangi sınıf, hangi bağımlılıklar, hangi scope); bean
tanımının kendisi henüz o nesnenin yaratıldığı anlamına gelmez.

**Bean lifecycle (bean yaşam döngüsü)** — Bir bean'in yaratılmasından
(constructor) kapatılmasına (`@PreDestroy`) kadar geçtiği, container tarafından
yönetilen sabit adım sırası.

**`@PostConstruct` / `@PreDestroy`** — Bir bean'in kurulum (bağımlılıklar set
edildikten hemen sonra) ve temizlik (container kapanırken) adımlarını işaretleyen,
standart Java (`jakarta.annotation`) annotation'ları.

**`BeanPostProcessor`** — Her bean'in başlatılmasını (initialization) saran,
container'ın kendi altyapısı için kullandığı bir uzantı noktası.

**Bean scope** — Bir bean'in container tarafından kaç kopyasının tutulacağını
belirleyen ayar: singleton, prototype, request, session, application.

**`@Lazy`** — Bir singleton bean'in, container refresh edilirken değil, yalnızca
ilk gerçekten istendiğinde yaratılmasını sağlayan annotation; circular dependency
çözümünde de kullanılır.

**Circular dependency** — İki (ya da daha fazla) bean'in birbirine dönüşümlü
olarak ihtiyaç duyması yüzünden container'ın hiçbirini önce bitiremediği durum.

## Ek: Mini Proje — Container Yönetimli Bir Rezervasyon Sistemi

Bu dersteki fikirleri birleştirelim: `@PostConstruct` ile açılışta veri hazırlayan,
`@PreDestroy` ile kapanışta özet yazdıran **singleton** bir `ReservationRegistry`,
her istemde yeni bir kopyası verilen **prototype** `ReservationTicket`'lar üretiyor:

{{ReservationSystem.java}}

{{ReservationSystemDemo.java}}

`ReservationTicket`'ın constructor'ı, kendi bilet numarasını almak için
`ReservationRegistry`'ye (bir singleton'a) bağımlı -- "Bean Scope: Prototype"
bölümünde gördüğümüz gibi her `getBean(ReservationTicket.class)` çağrısı yeni bir
`ReservationTicket` döndürüyor, ama hepsi aynı, paylaşılan `ReservationRegistry`'yi
kullanıyor. `context.close()` çağrıldığında `ReservationRegistry.summarize()`
(`@PreDestroy`) çalışıp o ana kadar onaylanan tüm biletleri özetliyor.

> ⚠️ Warning
> `ReservationRegistry.confirm(...)` ve `nextTicketNumber()` metotlarının
> `synchronized` olmasına dikkat et -- bu bir singleton bean olduğu için (bkz.
> "Bean Scope: Singleton (Varsayılan)" bölümündeki uyarı), gerçek bir web
> uygulamasında birden fazla HTTP isteği aynı `ReservationRegistry`'ye eşzamanlı
> erişebilir; `synchronized` olmasaydı iki isteğin aynı bilet numarasını almasıyla
> sonuçlanabilecek bir race condition (Threads dersini hatırla) oluşurdu.

## Ek: Mini Proje — Denetimli Sipariş Sistemi (Circular Dependency)

Son mini proje, "Circular Dependency: Neden Olur, Nasıl Çözülür" bölümündeki fikri
gerçekçi bir senaryoda gösteriyor: `OrderService`, her siparişi kaydetmek için
`AuditLogger`'a ihtiyaç duyuyor; `AuditLogger` da, log satırına kaçıncı sipariş
olduğunu yazabilmek için `OrderService`'e geri ihtiyaç duyuyor -- yapay değil,
gerçek bir çift yönlü ilişki:

{{AuditedOrderSystem.java}}

{{AuditedOrderSystemDemo.java}}

`@Lazy`, yalnızca `AuditLogger`'ın constructor'ındaki `OrderService` parametresine
uygulanıyor -- iki taraf da `@Lazy` olsaydı bu gereksiz olurdu, çünkü çemberi kırmak
için tek bir tarafın "beklemesi" yeterli. `AuditLogger.log(...)` içinde
`orderService.orderCount()` çağrısının güvenle çalıştığına dikkat et: bu metot,
context tamamen kurulduktan çok sonra, gerçek bir sipariş verildiğinde çalışıyor --
o noktada proxy'nin arkasındaki gerçek `OrderService` çoktan hazır.

> 💡 Tip
> Bu senaryoyu `@Lazy` olmadan denesen (her iki constructor'da da düz `OrderService`/
> `AuditLogger` parametreleri kullansan), context hiç ayağa kalkmadan
> `BeanCurrentlyInCreationException` ile başarısız olurdu -- "Circular Dependency:
> Neden Olur, Nasıl Çözülür" bölümündeki uyarıyı burada somut bir örnekte görmüş
> oldun.
