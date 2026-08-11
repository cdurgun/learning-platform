# Transaction Management

Şimdiye kadarki Spring Core derslerinde container'ın bean'leri nasıl bulduğunu,
tanımladığını ve yapılandırdığını gördük. Bu son ders farklı bir soruna eğiliyor:
birden fazla veritabanı işleminin ya hep birlikte ya da hiç gerçekleşmemesini nasıl
garanti ederiz? `@Transactional`, Auto-Configuration & Properties dersinde
otomatik kurulan `TransactionManager` bean'ini (bkz. "Bu Projenin Kendi
application.yml ve Config Sınıfları") gerçekten kullanan yer -- bu ders, o bean'in
perde arkasında ne yaptığını, ne zaman işe yaradığını ve nerelerde yanlış anlaşıldığını
işliyor.

## Transaction Nedir?

Spring'den tamamen bağımsız, saf veritabanı kavramı olarak bir transaction, birden
fazla işlemi tek, bölünemez bir birim hâline getirir:

```
BEGIN
   ↓
UPDATE account_a
   ↓
UPDATE account_b
   ↓
COMMIT
```

İşlemlerden biri başarısız olursa, o ana kadar yapılan her şey geri alınır:

```
BEGIN
   ↓
UPDATE account_a
   ↓
(hata oluştu)
   ↓
ROLLBACK
```

Bu davranışı garanti eden dört özellik, ACID kısaltmasıyla anılır: **Atomicity**
(bölünemezlik -- ya tüm işlemler ya hiçbiri), **Consistency** (tutarlılık --
transaction, veritabanını bir geçerli durumdan başka bir geçerli duruma taşır),
**Isolation** (izolasyon -- aynı anda çalışan transaction'lar birbirinin ara
durumunu görmez, bkz. "Isolation Levels (Kısa Bakış)") ve **Durability** (kalıcılık -- commit
olan bir transaction, sunucu çökse bile kalıcıdır).

## Neden Var?

Klasik örnek: A hesabından B hesabına 100 birim transfer. İki ayrı adım var --
A'dan düş, B'ye ekle. Transaction olmadan, ikinci adım herhangi bir sebeple
(ağ hatası, uygulama çökmesi, bir exception) başarısız olursa:

```
A: -100
B: değişmedi  ❌ -- para ortadan kayboldu
```

Transaction ile, yalnızca iki sonuçtan biri mümkündür:

```
A: -100, B: +100   (ikisi de başarılı)
```

veya

```
A: değişmedi, B: değişmedi   (ikisi de geri alındı)
```

"A'dan düşüldü ama B'ye hiç eklenmedi" durumu **hiçbir zaman** gözlemlenemez --
transaction'ın tüm amacı bu ara, tutarsız durumu dış dünyadan tamamen gizlemek.

## Tarihçe

Spring, transaction yönetimini en başından beri (2003, Spring 1.0'dan önceki
ilk sürümlerden itibaren) framework'ün merkezi bir parçası olarak tasarladı --
o dönemde J2EE'nin kendi transaction API'si (JTA) hem ağır hem de yalnızca
uygulama sunucusu içinde çalışıyordu; Spring'in `PlatformTransactionManager`
soyutlaması, aynı `@Transactional` kodunun JDBC, Hibernate, JTA gibi tamamen
farklı alt katmanlarla, kod değişmeden çalışabilmesini sağladı. Annotation tabanlı
`@Transactional` (XML'deki `<tx:advice>` yapılandırmasının yerini alarak) Spring
2.0'da (2006) geldi -- tam olarak Component Scanning dersinde bahsettiğimiz,
XML'den annotation'lara geçiş döneminin bir parçası. `@EnableTransactionManagement`
(Java Config ile XML-siz kurulum) Spring 3.1'de (2011) eklendi.
`@TransactionalEventListener` ise daha yeni, Spring 4.2'de (2015) geldi.

## @Transactional: En Basit Kullanım

Bu derste `@Transactional`/`TransactionTemplate` örneklerinin **gerçekten** çalışıp
commit/rollback davranışını göstermesi için, gerçek bir veritabanı yerine, elle
yazılmış, in-memory bir "defter" (`Ledger`) ve onu yöneten minik bir
`PlatformTransactionManager` kullanıyoruz. Bu ortamda gerçek bir Postgres
bağlantısı yok; Dependency Injection dersinde container'ı elle simüle ettiğimiz
teknik burada da geçerli. **Gerçek projelerde bu sınıf hiç yazılmaz** -- Spring
Boot'un kendi auto-configuration'ı (`DataSourceAutoConfiguration`,
`JpaTransactionManager`) bunu senin yerine kurar (bkz. Auto-Configuration &
Properties dersi):

{{LedgerTransactionInfra.java}}

Bu altyapıyla artık gerçek `@Transactional` kodu çalıştırabiliriz:

{{TransactionalBasicExample.java}}

`transferSuccessfully` her iki `ledger.add(...)` çağrısını da başarıyla tamamlıyor
ve commit ediyor; `transferAndFail` aynı iki çağrıyı yapıyor ama sonra bir exception
fırlatıyor -- ikisi de geri alınıyor, defterde hiçbir iz kalmıyor.

## Commit ve Rollback Akışı

Başarılı bir metot çağrısında akış şöyle işler:

```
metot başlar
     ↓
transaction başlar
     ↓
veritabanı işlemleri
     ↓
metot başarıyla biter
     ↓
COMMIT
```

Bir exception fırlatıldığında ise (hangi exception'ların rollback tetiklediği bir
sonraki bölümün konusu):

```
metot başlar
     ↓
transaction başlar
     ↓
veritabanı işlemleri
     ↓
exception fırlatılır
     ↓
ROLLBACK
```

Bu karar -- commit mi, rollback mi -- `@Transactional`'ı işleten proxy tarafından,
metot geri döndükten (ya da exception fırlattıktan) hemen sonra, otomatik olarak
verilir; sen hiçbir zaman elle `commit()`/`rollback()` çağırmazsın (programatik
yöntem hariç, bkz. "Programmatic Transactions: TransactionTemplate").

## Rollback Kuralları: RuntimeException vs Checked Exception

Burada çoğu kişinin şaşırdığı bir davranış var: **Spring her exception'da otomatik
rollback yapmaz.** Varsayılan kural, unchecked exception'ları (`RuntimeException`
ve alt sınıfları, artı `Error`) rollback tetikleyici sayar; checked exception'lar
(`Exception`'ın `RuntimeException` olmayan alt sınıfları, örn. `IOException`)
**rollback tetiklemez** -- transaction, exception'a rağmen commit olur:

{{RollbackRulesExample.java}}

`writeThenThrowUnchecked`, `IllegalStateException` (unchecked) fırlattığı için
geri alınıyor. `writeThenThrowChecked`, `IOException` (checked) fırlattığı hâlde
**commit oluyor** -- yazılan satır kalıcı oluyor, exception yalnızca çağırana
bildiriliyor. `@Transactional(rollbackFor = IOException.class)` bu varsayılanı
açıkça geçersiz kılıp checked bir exception'ı da rollback tetikleyici yapıyor.

> ⚠️ Warning
> Bu varsayılan kural, tarihsel bir nedenden geliyor (checked exception'lar
> geleneksel olarak "beklenen, iş akışının bir parçası olan" durumlar, unchecked
> olanlar "beklenmeyen hatalar" sayılırdı) ama günümüzde birçok ekip bunu kafa
> karıştırıcı buluyor. Bir checked exception fırlatan `@Transactional` bir metot
> yazıyorsan, verinin tutarlı kalmasını istiyorsan `rollbackFor` eklemeyi asla
> unutma -- aksi hâlde exception'ı yakalayan kod, verinin aslında geri alınmadığını
> fark etmeyebilir.

## @EnableTransactionManagement ve Proxy Tabanlı Mekanizma

`@Transactional`, Component Scanning ve Spring IoC Container derslerinde gördüğümüz
mekanizmaların hiçbirine benzemiyor -- bir bean tanımlamıyor, bir koşul da
belirtmiyor. Bunun yerine, `@EnableTransactionManagement` etkinken, Spring her
`@Transactional` içeren bean'in etrafına bir **proxy** sarar:

```
Client
  ↓
Spring Proxy (TransactionInterceptor)
  ↓
transaction başlar
  ↓
Gerçek Metot (Target Method)
  ↓
commit / rollback
```

Bu, Spring AOP'nin (Aspect-Oriented Programming) bir uygulaması --
`TransactionInterceptor`, metot çağrısını gerçek nesneye ulaşmadan önce yakalayan
bir "advice." `@Component`/`@Service` gibi component scanning ile bulunan sınıflar
için proxy CGLIB (alt sınıf oluşturarak) ya da JDK dynamic proxy (arayüz varsa)
ile kurulur -- Spring IoC Container dersinde gördüğümüz `BeanPostProcessor`
mekanizmasının (bkz. "Bean Lifecycle: Container'ın Bir Bean'i İnşa Etme Adımları")
gerçek bir uygulaması, tam olarak bu şekilde devreye giriyor. Proxy'nin en önemli
sonucu bir sonraki bölümün konusu.

## Self-Invocation Tuzağı

Proxy, yalnızca **bean üzerinden gelen** çağrıları yakalayabilir -- `this` üzerinden
(aynı sınıfın içinden) yapılan bir çağrı hiçbir zaman proxy'den geçmez, bu yüzden
`@Transactional` sessizce hiç uygulanmaz:

{{SelfInvocationExample.java}}

`createInvoiceViaSelfInvocation`, `writeLine(...)`'ı `this.writeLine(...)` olarak
çağırıyor -- Spring'in container'dan aldığın proxy nesnesi değil, doğrudan gerçek
nesnenin kendisi. `@Transactional` üzerinde dursa da, bu çağrı yolunda hiçbir
transaction hiç başlamıyor, dolayısıyla geri alınacak bir şey de yok.

## Propagation: REQUIRED (Varsayılan)

`PROPAGATION_REQUIRED`, zaten aktif bir transaction varsa **ona katılır** -- ikinci
bir tane başlatmaz. Dış transaction geri alınırsa, çağırdığı her `REQUIRED` metodun
yazdığı her şey de onunla birlikte geri alınır, çünkü aslında hepsi baştan beri aynı
transaction'dı:

{{PropagationRequiredExample.java}}

`placeOrderThatFailsAfterPayment` ve `charge(...)` aynı transaction'ı paylaşıyor --
`charge`'ın kendi `@Transactional`'ı yeni bir transaction başlatmıyor, var olana
katılıyor. Ödeme başarıyla "yazılmış" olsa da, sipariş sonradan başarısız olduğunda
ikisi birlikte geri alınıyor.

## Propagation: REQUIRES_NEW

`PROPAGATION_REQUIRES_NEW`, aktif bir transaction varsa bile onu **askıya alıp**
(suspend) tamamen bağımsız, yeni bir transaction başlatır. Bu yeni transaction kendi
başına commit ya da rollback olur -- dış transaction daha sonra geri alınsa bile,
içteki zaten commit olmuş işi etkilenmez:

{{PropagationRequiresNewExample.java}}

`checkoutThatFails` başarısız olup geri alınıyor, ama `recordAuditEntry(...)` --
`REQUIRES_NEW` sayesinde -- kendi ayrı transaction'ında zaten commit olmuştu.
Gerçek dünyada bu, tam olarak bir denetim (audit) kaydının neden sıradan bir iş
işleminden bağımsız tutulması gerektiğini gösteriyor: "bunu denedik" bilgisi,
asıl işlem başarısız olsa bile kalıcı olmalı.

## Diğer Propagation Türleri (Kısa Bakış)

Geriye kalan beş propagation türü, bu ortamda çalışan bir örnekle göstermeye değecek
kadar sık kullanılmıyor, ama ne yaptıklarını bilmek önemli: **`NESTED`**, dış
transaction içinde bir savepoint oluşturur -- iç kısım geri alınabilir, dış kısım
etkilenmeden devam edebilir (gerçek bir JDBC savepoint'i gerektirir, bizim
`Ledger`'ımız desteklemiyor). **`SUPPORTS`**, aktif bir transaction varsa katılır,
yoksa transaction'sız çalışır. **`MANDATORY`**, aktif bir transaction **zorunlu**
kılar -- yoksa exception fırlatır. **`NOT_SUPPORTED`**, aktif bir transaction'ı
askıya alıp metodu tamamen transaction'sız çalıştırır. **`NEVER`**, aktif bir
transaction varsa exception fırlatır -- "bu metot asla bir transaction içinde
çağrılmamalı" garantisi.

## Isolation Levels (Kısa Bakış)

Isolation, aynı anda çalışan birden fazla transaction'ın birbirinin **henüz commit
olmamış** değişikliklerini ne ölçüde görebileceğini belirler -- bu, gerçek eşzamanlı
transaction'lar ve gerçek bir veritabanı gerektirdiği için bu derste çalışan bir kod
örneği yok, ama çözdüğü üç klasik problemi bilmek önemli: **Dirty Read** (henüz
commit olmamış bir değişikliği okumak -- o değişiklik rollback olursa, okuduğun
değer hiç var olmamış olur), **Non-Repeatable Read** (aynı satırı aynı transaction
içinde iki kez okuyup farklı değerler almak, çünkü aradaki sürede başka bir
transaction commit etti), **Phantom Read** (aynı sorguyu iki kez çalıştırıp farklı
**satır sayısı** almak, çünkü aradaki sürede başka bir transaction yeni satır
ekledi/sildi). Isolation seviyeleri (`READ_UNCOMMITTED`, `READ_COMMITTED`,
`REPEATABLE_READ`, `SERIALIZABLE`) bu üç problemi sırasıyla giderek daha sıkı
kilitleme/versiyon kontrolü pahasına önler -- `@Transactional(isolation = ...)`
ile ayarlanır.

## PostgreSQL'de Isolation

Bu projenin veritabanı PostgreSQL, ve PostgreSQL'in isolation davranışının iki
gerçekçi özelliği var. Birincisi: PostgreSQL'in **varsayılan** isolation seviyesi
`READ_COMMITTED`'dır (Spring/JPA'nın kendi varsayılanı `Isolation.DEFAULT` de zaten
bunu miras alır -- yani bu proje, hiçbir şey özelleştirmeden, zaten `READ_COMMITTED`
ile çalışıyor). İkincisi, ve daha az bilinen: PostgreSQL, `READ_UNCOMMITTED`'ı
**gerçekten desteklemez** -- `READ_UNCOMMITTED` istesen bile, motor sessizce
`READ_COMMITTED`'a yükseltir; yani PostgreSQL'de "dirty read" hiçbir zaman
gerçekleşmez, isteğe bağlı bile olsa. `REPEATABLE_READ` ve `SERIALIZABLE`,
PostgreSQL'de kilitleme yerine "snapshot isolation" (MVCC) ile uygulanır --
`SERIALIZABLE`'da bir çakışma tespit edilirse, transaction commit anında
serialization hatasıyla başarısız olabilir; uygulama kodunun bu durumda yeniden
denemesi (retry) gerekir.

## readOnly = true: Ne İşe Yarar, Ne İşe Yaramaz

`@Transactional(readOnly = true)`, Spring'e ve alttaki JPA/Hibernate'e bir **ipucu**
verir -- gerçek bir kısıtlama değildir:

{{ReadOnlyExample.java}}

`generateReportAndSneakilyWrite`, `readOnly = true` olmasına rağmen sorunsuz yazıyor
-- ne Spring'in `@Transactional` sözleşmesi ne de bizim basit
`LedgerTransactionManager`'ımız bunu engelliyor. Gerçek `JpaTransactionManager`'da
`readOnly = true`'nun asıl faydası performans: Hibernate'in
"dirty checking" (bkz. "Spring Data JPA ve Dirty Checking") mekanizmasını devre
dışı bırakarak flush'ı atlar, ve bazı JDBC sürücüleri bunu okumaları bir replica'ya
yönlendirmek için kullanır. Ama "bu metot kesinlikle veritabanına yazamaz" **anlamına
gelmez** -- bu güvenceyi istiyorsan, veritabanı kullanıcısının kendisine salt okunur
yetki vermen gerekir.

## Transaction Boundary: Neden Service Katmanında?

Bir transaction nerede başlamalı? Tipik bir katmanlı mimaride:

```
Controller
    ↓
Service   ← transaction boundary burada
    ↓
Repository
```

`@Transactional`'ı **service** katmanına koymak genel kabul görmüş kuraldır, iki
sebeple: birincisi, tek bir service metodu genellikle birden fazla repository
çağrısı yapar (bkz. "Propagation: REQUIRED (Varsayılan)" örneğindeki `OrderService` ->
`PaymentService`) -- transaction boundary'yi burada çizmek, bu çağrıların hepsinin
tek bir birim olmasını sağlar. İkincisi, controller katmanına `@Transactional`
koymak (bkz. "Yaygın Hatalar") transaction'ı gereğinden geniş tutar -- view render
etme, JSON serialize etme gibi veritabanıyla ilgisi olmayan işler de transaction
içinde kalır.

## Programmatic Transactions: TransactionTemplate

`TransactionTemplate`, `@Transactional`'ın programatik karşılığı -- transaction
sınırının "metodun tamamı" olmadığı, ya da koşullu olması gereken durumlar için:

{{TransactionTemplateExample.java}}

`executeWithoutResult`, lambda'nın tamamını bir transaction içinde çalıştırıyor --
normal dönerse commit, exception fırlatırsa rollback, `@Transactional` ile aynı
kural. `status.setRollbackOnly()` ise farklı bir yol sunuyor: hiçbir exception
fırlatmadan, sadece bir iş kuralı gereği transaction'ı geri almak istediğinde
kullanılır.

## Spring Data JPA ve Dirty Checking

Spring Data JPA'nın kendi repository metotları (`save()`, `findById()`, `delete()`
gibi -- Component Scanning dersindeki "Bu Projenin Kendi Sınıfları: Gerçek Bir
Component Scanning Örneği" bölümünde
gördüğümüz, hiç `@Repository` yazmadan proxy olarak üretilen `TopicRepository`
gibi arayüzler) zaten kendi içlerinde `@Transactional`'dır (`SimpleJpaRepository`
üzerinde tanımlı). Bunun ötesinde, Hibernate'in **dirty checking** özelliği, bir
transaction içinde yönetilen (managed) bir entity'nin alanları değiştirildiğinde,
`save()`'i hiç çağırmadan bile bu değişikliğin commit'te veritabanına yazılmasını
sağlar. Bu proje tamamen salt-okunur olduğu için (bkz. "Bu Projenin Kendi
Repository'leri: Neden Hâlâ @Transactional Yok?") gerçek bir örneği yok, ama varsayımsal olarak: eğer bir
`TopicService.updateDifficulty(slug, yeniZorluk)` metodu olsaydı ve içinde
`topicRepository.findBySlug(slug)` ile alınan yönetilen bir `Topic` üzerinde
`topic.setDifficulty(yeniZorluk)` çağırsaydık, `topicRepository.save(topic)`'i
**hiç çağırmasak bile**, transaction commit olduğunda Hibernate bu değişikliği fark
edip bir `UPDATE` sorgusu gönderirdi.

> 💡 Tip
> Dirty checking, `readOnly = true` transaction'larda devre dışı bırakılır (bkz.
> "readOnly = true: Ne İşe Yarar, Ne İşe Yaramaz") -- Hibernate, hiçbir zaman
> yazılmayacağını bildiği entity'ler için flush öncesi karşılaştırmayı atlayarak
> performans kazanır.

## Lazy Loading ve LazyInitializationException

Bu projenin `Topic`, `Category`, `TopicTranslation`, `CodeExample` entity'lerinin
hepsinde gerçek `@ManyToOne(fetch = FetchType.LAZY)` ilişkileri var
(`TopicTranslation.topic`, `CodeExample.topic`, `Category.course`,
`Topic.category`). Lazy bir ilişki, yalnızca **açıkça erişildiğinde** (örn.
`topic.getCategory()`) veritabanından çekilir -- ve bu erişim, entity'nin bağlı
olduğu persistence context (Hibernate session) hâlâ açıkken olmalıdır. Kapandıktan
sonra erişmeye çalışmak `LazyInitializationException` fırlatır.

`TopicRepository`'nin gerçek kaynak kodunda tam olarak bu problemden kaçınan bir
metot var:

```java
@Query("select t from Topic t join fetch t.category c join fetch c.course where t.slug = :slug")
Optional<Topic> findBySlugWithCategoryAndCourse(String slug);
```

`TopicController.show(...)`, sıradan `findBySlug(slug)` yerine bilerek bunu
kullanıyor -- `join fetch`, `category` ve `course` ilişkilerini **aynı sorguda**,
tembel yükleme beklemeden hemen getiriyor. Kaynak koddaki yorum bunu açıkça
söylüyor: breadcrumb ve önceki/sonraki konu navigasyonu bu ilişkilere ihtiyaç
duyuyor, ve proje bunu "lazy-loading'e (open-in-view'a) bırakmak yerine tek sorguda
açıkça çözüyor." `spring.jpa.open-in-view` bu projede hiç ayarlanmadığı için Spring
Boot'un varsayılanı (`true`) geçerli -- yani `findBySlug(slug)` kullansaydı ve
Thymeleaf şablonu `topic.category.course.name`'e erişseydi muhtemelen yine de
çalışırdı (open-in-view, persistence context'i view render'ı bitene kadar açık
tutar), ama bu, veritabanı bağlantısını gereğinden uzun süre elde tutan, genel
kabul görmüş bir anti-pattern'dir -- projenin `join fetch` tercihi tam olarak bunu
önlüyor.

## Transactional Events: @TransactionalEventListener ve AFTER_COMMIT

Auto-Configuration & Properties dersinde `ApplicationEvent`/`@EventListener`'ı
gördük -- `@TransactionalEventListener`, aynı fikri transaction'a duyarlı hâle
getiriyor: bir olayı, yayınlandığı anda değil, transaction belirli bir aşamaya
ulaştığında işler. En sık kullanılan aşama `AFTER_COMMIT`:

{{TransactionalEventListenerExample.java}}

`createOrder`, `simulateFailureAfterPublish = false` olduğunda başarıyla commit
oluyor ve dinleyici çalışıyor. `true` olduğunda ise, event yayınlanmış olsa bile,
transaction hiç commit olmadığı için `AFTER_COMMIT` dinleyicisi **hiç çalışmıyor**
-- olay yayınlamak ile o olayın etkisinin gerçekleşmesi arasındaki fark burada net
görülüyor.

## Testing Transactions (Kısa Bakış)

Spring Test (`spring-boot-starter-test`, bu projenin bir bağımlılığı), bir test
metoduna `@Transactional` koyduğunda özel bir davranış ekler: test metodu kendi
transaction'ında çalışır ve **test bittiğinde otomatik olarak rollback olur** --
varsayılan olarak, testin veritabanına yazdığı hiçbir şey kalıcı olmaz, bir sonraki
test temiz bir veritabanıyla başlar:

```java
@SpringBootTest
class OrderServiceTest {

    @Test
    @Transactional
    void shouldCreateOrder() {
        // ... veritabanına yazan kod ...
        // test bittiğinde otomatik rollback, elle temizlik gerekmez
    }
}
```

Bu, `TransactionalTestExecutionListener` tarafından sağlanır ve gerçek bir Spring
Boot test ortamı (`@SpringBootTest`) gerektirir -- bu dersteki diğer örneklerin
kullandığı sade `AnnotationConfigApplicationContext` + `main()` biçiminden farklı
bir çalıştırma modeli olduğu için burada ayrı bir kod örneği yok. Dikkat edilmesi
gereken bir nokta: eğer test edilen kodun kendisi `REQUIRES_NEW` kullanıyorsa
(bkz. "Propagation: REQUIRES_NEW"), o iç transaction test'in kendi transaction'ından
bağımsız olarak **gerçekten commit olur** -- test'in dış rollback'i bunu geri
alamaz.

## Bu Projenin Kendi Repository'leri: Neden Hâlâ @Transactional Yok?

Bu proje boyunca hiçbir yerde `@Transactional` yok -- `grep -rn "@Transactional"
src/main/java` boş dönüyor. Sebebi basit: `NavigationService`, `ContentResolver`,
`TopicController` gibi bu projenin gerçek sınıflarının hepsi **salt okuma**
yapıyor -- `courseRepository.findAll()`, `topicRepository.findBySlugWithCategoryAndCourse(...)`
gibi tekil, tek-sorguluk repository çağrıları. Spring Data JPA'nın kendi
`SimpleJpaRepository`'si (bkz. "Spring Data JPA ve Dirty Checking") her repository
metodunu zaten kendi başına bir transaction'a sarıyor -- tek bir sorgu için ayrıca
servis katmanına `@Transactional` eklemenin hiçbir faydası olmazdı.

Projenin gördüğü tek "yazma" işlemleri, çalışan uygulamanın kendisinden değil,
Flyway migration'larından geliyor (bkz. `db/migration/`) -- her `INSERT`/`UPDATE`,
uygulama her başladığında, servis katmanı hiç devreye girmeden, doğrudan SQL
olarak çalışıyor. Eğer bu projeye gelecekte bir "admin panel" ya da içerik
düzenleme özelliği eklenseydi (örneğin bir konunun `sort_order`'ını değiştiren bir
`TopicService.reorder(...)` metodu), işte tam o zaman gerçek bir `@Transactional`
service metoduna ihtiyaç duyulurdu -- muhtemelen birden fazla `Topic` satırını tek
bir birim olarak güncelleyen, "Propagation: REQUIRED (Varsayılan)" bölümündeki
`OrderService` örneğine çok benzer bir yapıda.

## Best Practices

- **`@Transactional`'ı service katmanına koy, controller'a değil** -- transaction
  sınırının yalnızca veritabanıyla ilgili işleri kapsamasını sağlar (bkz.
  "Transaction Boundary: Neden Service Katmanında?").
- **Checked exception fırlatan bir `@Transactional` metotta `rollbackFor`'u
  unutma** -- varsayılan davranış, checked exception'larda commit yapar, bu
  genellikle istenen şey değildir (bkz. "Rollback Kuralları: RuntimeException vs Checked Exception").
- **Salt okuma yapan metotları `readOnly = true` işaretle** -- gerçek bir kısıtlama
  sağlamasa da, gerçek `JpaTransactionManager`'da performans kazandırır (bkz.
  "readOnly = true: Ne İşe Yarar, Ne İşe Yaramaz").
- **Transaction'ları kısa tut, içine harici bir API çağrısı koyma** -- bir ödeme
  sağlayıcısı ya da e-posta servisi gibi harici bir çağrı yavaş/başarısız olursa,
  veritabanı bağlantısını (ve varsa kilitleri) gereğinden uzun süre açık tutar;
  böyle işler için `@TransactionalEventListener(phase = AFTER_COMMIT)` daha
  uygundur (bkz. "Transactional Events: @TransactionalEventListener ve AFTER_COMMIT").
- **Gereksiz yere `REQUIRES_NEW` kullanma** -- her `REQUIRES_NEW` çağrısı ayrı bir
  transaction (ve gerçek bir veritabanında ayrı bir bağlantı) demektir; yalnızca
  denetim kaydı gibi, dış transaction'dan gerçekten bağımsız olması gereken işler
  için kullan (bkz. "Propagation: REQUIRES_NEW").

## Yaygın Hatalar

**1. `@Transactional`'ı controller'a koymak.** Transaction sınırı, view render
etme gibi veritabanıyla ilgisi olmayan işleri de kapsar hâle gelir -- doğrusu
service katmanıdır (bkz. "Transaction Boundary: Neden Service Katmanında?").

**2. Self-invocation ile `@Transactional`'ın çalışacağını sanmak.** `this` üzerinden
yapılan bir çağrı proxy'den hiç geçmez -- annotation sessizce hiçbir işe yaramaz
(bkz. "Self-Invocation Tuzağı").

**3. Checked bir exception fırlatan bir metodun otomatik rollback yapacağını
varsaymak.** Varsayılan davranış tam tersi: checked exception'lar commit'e izin
verir, `rollbackFor` açıkça yazılmadıkça (bkz. "Rollback Kuralları: RuntimeException vs Checked Exception").

**4. `readOnly = true`'nun "bu metot yazamaz" garantisi verdiğini sanmak.** Bu
yalnızca bir performans ipucudur, bir kısıtlama değildir (bkz. "readOnly = true:
Ne İşe Yarar, Ne İşe Yaramaz").

**5. Isolation seviyesini ne yaptığını tam anlamadan değiştirmek.** Daha sıkı bir
seviye (örn. `SERIALIZABLE`) eşzamanlılık problemlerini önler ama performansı
düşürür ve serialization hatalarına (özellikle PostgreSQL'de) yol açabilir --
varsayılanı değiştirmeden önce hangi problemi (dirty read, non-repeatable read,
phantom read) çözmeye çalıştığını netleştir (bkz. "Isolation Levels (Kısa Bakış)").

**6. Lazy loading problemini her yere `@Transactional`/open-in-view yayarak
"çözmeye" çalışmak.** Bu, veritabanı bağlantısını gereğinden uzun süre açık
tutar -- doğru çözüm, bu projenin `findBySlugWithCategoryAndCourse`'unda olduğu
gibi, ihtiyaç duyulan ilişkileri `join fetch` ile açıkça, tek sorguda getirmektir
(bkz. "Lazy Loading ve LazyInitializationException").

## Özet, Cheat Sheet ve Terimler Sözlüğü

Transaction management, birden fazla veritabanı işlemini tek, bölünemez bir birim
hâline getirir -- `@Transactional`, bunu bir proxy aracılığıyla, metot çağrısını
sarıp exception fırlatılıp fırlatılmadığına göre commit/rollback kararı vererek
sağlar. Önemli noktalar:

- ACID: Atomicity, Consistency, Isolation, Durability
- Varsayılan rollback kuralı: unchecked exception (`RuntimeException`/`Error`)
  rollback tetikler, checked exception tetiklemez -- `rollbackFor` ile değiştirilir
- `@Transactional`, bir proxy (AOP, `TransactionInterceptor`) aracılığıyla çalışır
  -- self-invocation (`this` üzerinden çağrı) bu proxy'yi atlar
- Propagation: `REQUIRED` (varsayılan, var olana katılır), `REQUIRES_NEW` (askıya
  alıp bağımsız yeni bir tane başlatır), `NESTED`/`SUPPORTS`/`MANDATORY`/
  `NOT_SUPPORTED`/`NEVER` (daha az kullanılan diğer türler)
- Isolation levels, dirty read/non-repeatable read/phantom read problemlerini
  giderek daha sıkı biçimde önler; PostgreSQL varsayılanı `READ_COMMITTED`
- `readOnly = true`: performans ipucu, kısıtlama değil
- `TransactionTemplate`: `@Transactional`'ın programatik karşılığı
- `@TransactionalEventListener(phase = AFTER_COMMIT)`: bir event'i, yalnızca
  yayınlandığı transaction gerçekten commit olursa işler

Hızlı referans:

```java
@Transactional                                    // REQUIRED, tüm exception rollback (varsayılan hariç checked)
@Transactional(rollbackFor = Exception.class)      // checked exception'ları da rollback tetikleyici yap
@Transactional(readOnly = true)                    // performans ipucu, kısıtlama değil
@Transactional(propagation = Propagation.REQUIRES_NEW)  // her zaman yeni, bağımsız transaction
@Transactional(isolation = Isolation.SERIALIZABLE) // en sıkı izolasyon

class MyService {
    // Self-invocation UYARISI: this.otherMethod() proxy'yi atlar.
    void outer() {
        this.inner(); // @Transactional'ı olsa bile UYGULANMAZ
    }

    @Transactional
    void inner() { }
}

// Programatik alternatif:
transactionTemplate.executeWithoutResult(status -> {
    // ...
    if (someCondition) {
        status.setRollbackOnly(); // exception fırlatmadan rollback
    }
});

@TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
void onSomeEvent(SomeEvent event) { }
```

**Terimler Sözlüğü**

**Transaction** — Birden fazla işlemin ya hep birlikte (commit) ya da hiç
(rollback) gerçekleşmesini garanti eden, bölünemez bir birim.

**ACID** — Atomicity, Consistency, Isolation, Durability: bir transaction'ın
sağlaması gereken dört özellik.

**`@Transactional`** — Bir metodu (ya da sınıfı) bir transaction sınırıyla
saran annotation.

**`PlatformTransactionManager`** — Spring'in transaction başlatma/commit/rollback
işlemlerini soyutlayan arayüzü; `DataSourceTransactionManager`,
`JpaTransactionManager` gibi gerçek implementasyonları vardır.

**Rollback kuralı** — Hangi exception türlerinin rollback tetikleyeceğini
belirleyen kural; varsayılan olarak yalnızca unchecked exception'lar.

**Self-invocation** — Bir proxy'lenmiş bean'in kendi metodunu `this` üzerinden
çağırması; proxy'yi atladığı için `@Transactional` gibi proxy'ye dayalı
annotation'ları devre dışı bırakır.

**Propagation** — Bir `@Transactional` metodun, zaten aktif bir transaction varken
nasıl davranacağını belirleyen ayar (`REQUIRED`, `REQUIRES_NEW`, vb.).

**Isolation** — Aynı anda çalışan transaction'ların birbirinin commit olmamış
değişikliklerini ne ölçüde görebileceğini belirleyen ayar.

**`readOnly`** — Bir transaction'ın yalnızca okuma yapacağını belirten,
performans amaçlı bir ipucu; bir kısıtlama değildir.

**`TransactionTemplate`** — `@Transactional`'ın programatik (annotation'sız)
karşılığı.

**`@TransactionalEventListener`** — Bir event'i, yayınlandığı transaction belirli
bir aşamaya (en sık `AFTER_COMMIT`) ulaştığında işleyen dinleyici annotation'ı.

## Ek: Mini Proje — Para Transferi

Bu mini proje, dersin baştan beri kullandığı hesap transferi senaryosunu, rollback
kurallarını, `PROPAGATION_REQUIRED`'ı ve self-invocation tuzağını bir araya
getirerek tamamlıyor:

{{MoneyTransferApp.java}}

{{MoneyTransferDemo.java}}

`transfer(...)`, `debit(...)` ve `credit(...)`'in `PROPAGATION_REQUIRED` sayesinde
aynı transaction'ı paylaşmasına dayanıyor -- bakiyesi yetersiz bir hesaptan çekim
denendiğinde, `debit(...)` kendi `InsufficientFundsException`'ını (unchecked)
fırlatıyor ve her şey geri alınıyor. `transferViaSelfInvocation(...)` ise bilerek
bozuk: `transferInternal(...)`'ı `this` üzerinden çağırdığı için, o metodun
`@Transactional`'ı hiç uygulanmıyor -- ama `debit(...)`/`credit(...)`'in kendi
`@Transactional`'ları (ayrı bir bean olan `accountRepository` üzerinden
çağrıldıkları için) normal şekilde işliyor ve her biri kendi başına commit oluyor.

## Ek: Mini Proje — Sipariş İşleme

Son mini proje, gerçekçi bir `OrderService` -> `PaymentService` ->
`InventoryAuditService` akışında propagation'ı ve transactional event'leri bir
araya getiriyor:

{{OrderProcessingApp.java}}

{{OrderProcessingDemo.java}}

Sipariş ve ödeme aynı transaction'ı (`REQUIRED`) paylaşırken, denetim kaydı
(`recordAttempt`) bilerek `REQUIRES_NEW` -- sipariş daha sonra stok yetersizliği
yüzünden geri alınsa bile, "bu siparişi denedik" bilgisi kalıcı kalıyor. Kargo
bildirimi ise yalnızca `AFTER_COMMIT`'te tetikleniyor -- stok yetersizliği
durumunda hiçbir bildirim gönderilmiyor, çünkü o transaction hiç commit olmuyor.

> ⚠️ Warning
> `InventoryAuditService.recordAttempt(...)`'in her çağrısı gerçek bir veritabanında
> ayrı bir bağlantı/transaction açar -- "Best Practices" bölümünde belirtildiği
> gibi, `REQUIRES_NEW`'i yalnızca gerçekten bağımsız olması gereken işler için
> kullanmak, performans ve bağlantı havuzu tükenmesi açısından önemlidir.
