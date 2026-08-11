# Spring MVC'de Test Yazmak

Bu, Spring MVC kategorisinin son dersi -- ve bir bakıma hepsini bir araya
getiriyor. Şu ana kadar `@Controller`/`@RestController`, `@RequestBody`/
`ResponseEntity`, `@Valid`/`ProblemDetail`, Thymeleaf view'ları,
`HandlerInterceptor`/CORS/multipart, ve DTO/pagination/idempotency
desenlerini yazdık -- ama hiçbirini gerçekten **çalıştırıp doğrulamadık**.
Bu ders, `MockMvc` ve `@WebMvcTest` ile bu kodun gerçekten söylediğini
yaptığını, gerçek bir sunucu ayağa kaldırmadan, hızlı ve tekrarlanabilir bir
şekilde nasıl kanıtlayacağımızı ele alıyor.

## Spring MVC'de Test Katmanları Nedir?

Bir Spring MVC uygulamasını test etmenin tek bir yolu yok -- amaca göre
değişen birkaç katman var:

```java
// Üç farklı test, üç farklı hız/gerçekçilik dengesi:
// 1) Saf birim testi: yeni TopicController(...).show(...) -- Spring hiç yok.
// 2) Slice testi: @WebMvcTest + MockMvc -- yalnızca web katmanı yüklü.
// 3) Entegrasyon testi: @SpringBootTest -- gerçek uygulama, gerçek DB (ya da test container'ı).
```

Bu ders esas olarak ortadaki katmana odaklanıyor: `MockMvc` ile `@WebMvcTest`.
Saf birim testi çok hızlı ama HTTP'nin kendisini (path matching, header'lar,
serialization) hiç doğrulamaz; `@SpringBootTest` gerçekçi ama yavaş ve bir
veritabanı gerektirir. `@WebMvcTest`, ikisi arasında -- gerçek HTTP isteği
işleme mekaniğini, gerçek bir sunucu ya da veritabanı olmadan test eder.

## Neden Var?

Bir controller'ı elle (`curl` ile ya da tarayıcıdan) test etmek, her
değişiklikte tekrar tekrar yapılması gereken, unutulması kolay, otomasyona
uygun olmayan bir iştir. `spring-mvc-fundamentals` dersinden bu yana yazdığımız
her controller -- path matching, model attribute'ları, JSON serileştirme,
validation, hata gövdeleri -- otomatik olarak, her kod değişikliğinde yeniden
doğrulanabilir olmalı. `MockMvc`, bunu gerçek bir HTTP sunucusu açmadan (soket
yok, port yok) yapmayı mümkün kılıyor -- bu da testleri hem hızlı hem de CI
ortamında güvenilir kılıyor.

## Tarihçe

Spring Test MVC, başlangıçta Spring Framework'ün ana gövdesinin dışında,
ayrı bir `spring-test-mvc` projesi olarak (2012 civarı) başladı; `MockMvc` ve
`andExpect` zincirleme API'si buradan geldi. Spring 3.2 ile bu proje
Spring Framework'ün kendisine (`spring-test` modülüne) taşındı. Spring Boot
1.4 (2016), `@WebMvcTest` ve kardeşi `@DataJpaTest` gibi "slice test"
annotation'larını tanıttı -- amaç, tüm `ApplicationContext`'i değil, testin
gerçekten ihtiyaç duyduğu dilimi yüklemekti. `@MockBean`, uzun süre bu
dilimlerdeki eksik bağımlılıkları doldurmanın standart yoluydu; Spring Boot
3.4 (2024) ile deprecated edildi ve yerini, Spring Framework'ün kendi test
altyapısına taşınan `@MockitoBean`'e bıraktı -- bu proje Spring Boot 4.1.0
kullandığı için burada yalnızca `@MockitoBean` kullanıyoruz.

## Unit Test vs Slice Test vs Integration Test: @WebMvcTest Nerede Durur?

`@WebMvcTest`, `spring-mvc-fundamentals` dersinin "Bu Projenin Kendi
Controller'ları: Gerçek Bir Spring MVC Örneği" bölümünde gördüğümüz gerçek
`HandlerMapping`/`HandlerAdapter`/`ViewResolver` mekanizmasını, DispatcherServlet'in
front controller deseniyle birlikte gerçekten çalıştırır -- ama `@Service`/
`@Repository` katmanını ve gerçek bir veritabanı bağlantısını YÜKLEMEZ. Bu,
onu üç seçenek arasında bilinçli bir orta nokta yapar: saf birim testinden
daha gerçekçi (gerçek HTTP request/response mekaniği çalışır), tam
`@SpringBootTest`'ten daha hızlı (veritabanı yok, tüm bean'ler yok). Bu
dersin geri kalanı, tam olarak bu orta noktaya -- `@WebMvcTest` ve `MockMvc`'ye
-- odaklanıyor.

## @WebMvcTest ve MockMvc: Yalnızca Web Katmanını Yüklemek

`@WebMvcTest`'in ne yüklediğini, ne yüklemediğini somut bir örnekle görelim:

{{WebMvcTestSliceExample.java}}

`@WebMvcTest(PingController.class)`, `DispatcherServlet`, mesaj
converter'ları, ve belirtilen controller'ı (bir de varsa
`@ControllerAdvice`/`HandlerInterceptor`/`WebMvcConfigurer` bean'lerini)
yükler -- ama bir `@Service` bağımlılığı olsaydı, context başlatma anında
"no qualifying bean" hatasıyla patlardı. `MockMvc`, bu daraltılmış context'in
otomatik olarak inject edebildiği birkaç bean'den biri.

## İlk MockMvc Testi: perform, andExpect, status()

`MockMvc`'yi, hatta bir Spring context'i bile beklemeden, en yalın haliyle
görelim:

{{FirstMockMvcTestExample.java}}

`MockMvcBuilders.standaloneSetup(...)`, verilen controller(lar)ı bir Spring
`ApplicationContext` OLMADAN, elle bir mini pipeline'a bağlar -- bu yüzden bu
örnek, projenin `main()` ile çalıştırma kuralına uyarak plain `main()` ile
çalışabiliyor. `perform(...)` sahte bir istek gönderir (gerçek soket açılmaz),
`andExpect(...)` zincirlenebilir doğrulamalar yapar ve biri başarısız olursa
`AssertionError` fırlatır.

## @MockitoBean ile Bağımlılıkları Sahtelemek

`@WebMvcTest`'in `@Service`/`@Repository` bean'lerini yüklemediğini gördük --
peki controller bunlara gerçekten bağımlıysa ne olur?

{{MockitoBeanExample.java}}

`@MockitoBean`, context'e ilgili türden bir Mockito sahtesi ekler (ya da
varsa gerçek bean'in yerine geçirir) -- `GreeterController`'ın bağımlılığı
olan `GreetingService`, bu olmadan context başlatma anında "no qualifying
bean" hatasıyla patlardı. Not: `@MockBean` (Spring Boot 3.4'ten beri
deprecated, bu projenin kullandığı 4.1.0'da kaldırıldı) yerine, burada ve
bu dersin geri kalanında kesinlikle `@MockitoBean` kullanıyoruz.

## Bu Projenin Kendi HomeController'ını Test Etmek: Gerçek Bir Örnek

Kurgu bir controller değil, `spring-mvc-fundamentals` dersinin "Bu Projenin
Kendi Controller'ları: Gerçek Bir Spring MVC Örneği" bölümünde tanıttığımız
gerçek `HomeController`'ı test edelim:

{{HomeControllerTest.java}}

`HomeController`'ın tek bağımlılığı `NavigationService` olduğu için tek bir
`@MockitoBean` yeterli. `buildNavigation(...)`'ın döndürdüğü gerçek listeye
(ya da içeriğine) hiç önem vermiyoruz -- burada test edilen şey
`NavigationService`'in davranışı değil, `HomeController`'ın onu doğru
çağırıp çağırmadığı ve model'e doğru attribute'ları koyup koymadığı.

## Model ve View Adını Doğrulamak: model(), view()

Klasik (JSON döndürmeyen) bir `@Controller` için `content()`'ten daha
anlamlı olan iki matcher:

{{ModelAndViewAssertionExample.java}}

`view().name(...)`, dönen mantıksal view adını doğrular -- fiziksel HTML
dosyasının render edilip edilmediğini değil (`standaloneSetup`'ta bir
`ViewResolver`/template motoru yok). `model().attribute(...)` bir
attribute'ın değerini, `model().attributeExists(...)` ise yalnızca
varlığını doğrular.

## @RestController Test Etmek: JSON Gövdesini jsonPath ile Doğrulamak

`@RestController`'larda view/model yok -- yanıt doğrudan JSON, ve onu
doğrulamanın aracı `jsonPath(...)`:

{{JsonPathAssertionExample.java}}

`jsonPath("$.alan")`, yanıt gövdesinin İÇİNE bakar -- tüm gövdeyi elle
string karşılaştırmaya (`content().json(...)`) tercihen, tek tek alan
doğrulamak, özellikle gövdenin bir kısmını (örn. sunucu tarafından üretilen
bir zaman damgasını) görmezden gelmek istediğinizde kullanışlıdır.
`jsonPath(...).exists()`/`doesNotExist()` ise bir alanın değerine hiç
bakmadan varlığını doğrular.

## Request Body Göndermek: content() ve contentType()

POST/PUT/PATCH gövdesi göndermek için iki parça gerekir: gövdenin kendisi
ve tipi:

{{RequestBodyTestExample.java}}

`content(requestJson)` ham baytları/string'i, `contentType(...)` ise
Content-Type header'ını verir -- Content-Type verilmezse Spring hangi
`HttpMessageConverter`'ın kullanılacağını bilemez ve isteği reddedebilir
(415 Unsupported Media Type). `ObjectMapper` ile elle serileştirme, gerçek
projelerde genelde küçük bir yardımcı metoda çıkarılır çünkü hemen her yazma
testinde tekrar eder.

## Path Variable ve Query Parametrelerini Test Etmek

Path variable'lar URL'in içinde, query parametreleri ise `.param(...)` ile
eklenir:

{{PathVariableQueryParamTestExample.java}}

`get("/api/categories/{categorySlug}/topics", "spring-mvc")` şeklindeki
placeholder doldurma, `@PathVariable` ile eşleşir; `.param("page", "1")`
gibi çağrılar ise `?page=1&size=5` formatındaki gerçek query string'i sizin
için kurar. `@RequestParam(required = false)` olan bir parametre
verilmediğinde, isteğin 400 değil, `null` ile controller'a girdiğini de
ayrıca doğruluyoruz.

## Validation Hatalarını Test Etmek: 400 ve ProblemDetail

`standaloneSetup(...)`, Bean Validation classpath'te olduğu için varsayılan
bir validator kurar -- ama Validation & Exception Handling dersinin "Global
Hata Yönetimi: @RestControllerAdvice" bölümünde gördüğümüz gibi,
`@ControllerAdvice` sınıfları otomatik taranmaz:

{{ValidationErrorTestExample.java}}

Geçerli bir hata gövdesi almak için advice'ı `.setControllerAdvice(...)`
ile elle eklemek gerekiyor. Buradaki `ValidationAdvice`,
`MethodArgumentNotValidException`'ı yakalayıp aynı dersin "ProblemDetail:
RFC 7807 ile Standart Hata Gövdesi" bölümündeki desenle bir `ProblemDetail`
üretiyor -- geçersiz ve geçerli iki farklı istekle, aynı controller + aynı
advice'ın iki farklı sonucunu karşılaştırıyoruz.

## Multipart Dosya Yüklemeyi Test Etmek: MockMultipartFile

Advanced Spring MVC dersinin "Multipart File Upload: @RequestParam ile
MultipartFile Almak" bölümündeki `MultipartUploadControllerExample`,
main-scope olduğu için `MultipartFile`'ı elle implemente etmişti -- burada
test scope'ta olduğumuz için gerçek `MockMultipartFile`'ı doğrudan
kullanabiliyoruz:

{{MultipartUploadTestExample.java}}

`MockMultipartFile`, `spring-boot-starter-test` ile gelen (test scope) gerçek
bir spring-test sınıfı. `multipart(...)`, normal `get()`/`post()` yerine,
`multipart/form-data` gövdesi kuran özel bir request builder'dır --
`.file(file)` ile eklenen dosya, controller'daki `@RequestParam("file")
MultipartFile` parametresiyle eşleşir. Boyut sınırı ihlali gibi senaryolar
(bkz. aynı dersin "Multipart Yapılandırması ve Boyut Sınırları" bölümü),
`ValidationErrorTestExample`'daki desenin aynısıyla, ilgili exception'ı
yakalayan bir advice eklenerek test edilebilir.

## Best Practices

- **`@MockBean` yerine her zaman `@MockitoBean` kullan** -- bu projenin
  kullandığı Spring Boot 4.1.0'da `@MockBean` kaldırıldı; `@MockitoBean`
  aynı işi görür ve Spring Framework'ün kendi test altyapısının bir parçası
  (bkz. "@MockitoBean ile Bağımlılıkları Sahtelemek").
- **`@WebMvcTest`'i, gerçekten test etmek istediğin controller'a daralt**
  (`@WebMvcTest(HomeController.class)` gibi) -- boş bırakmak tüm
  controller'ları yükler ve testi yavaşlatır, ayrıca hangi bağımlılığın
  sahtelenmesi gerektiğini belirsizleştirir (bkz. "Bu Projenin Kendi
  HomeController'ını Test Etmek: Gerçek Bir Örnek").
- **JSON yanıtlarda tüm gövdeyi string karşılaştırmak yerine `jsonPath(...)`
  ile tek tek alan doğrula** -- gövde şekli küçük bir şekilde değiştiğinde
  (yeni bir alan eklendiğinde gibi) testin kırılmaz olmasını sağlar (bkz.
  "@RestController Test Etmek: JSON Gövdesini jsonPath ile Doğrulamak").
- **`standaloneSetup(...)` kullanırken `@ControllerAdvice`'ı elle eklemeyi
  unutma** -- aksi hâlde hata senaryoları, gerçek uygulamada göreceğiniz
  `ProblemDetail` yerine ham bir exception ile sonuçlanır (bkz. "Validation
  Hatalarını Test Etmek: 400 ve ProblemDetail").

## Yaygın Hatalar

**1. `@WebMvcTest` ile bir `@Service` bağımlılığını sahteleme (`@MockitoBean`)
unutmak.** Context, "no qualifying bean" hatasıyla başlatma anında patlar --
`@WebMvcTest`'in `@Service`/`@Repository` katmanını hiç yüklemediğini
unutmak, bu dersteki en sık karşılaşılan hata (bkz. "@WebMvcTest ve MockMvc:
Yalnızca Web Katmanını Yüklemek").

**2. POST/PUT isteklerinde `contentType(...)` eklemeyi unutmak.** Gövde
`content(...)` ile verilse bile, Content-Type header'ı olmadan Spring hangi
`HttpMessageConverter`'ın kullanılacağını bilemez ve istek 415 ile
reddedilebilir (bkz. "Request Body Göndermek: content() ve contentType()").

**3. `jsonPath(...)`'i, dizi mi nesne mi döndüğünü kontrol etmeden
yazmak.** Bir liste için `$.title` değil `$[0].title` gerekir -- yanlış
ifade, alanın hiç bulunamamasıyla sonuçlanan kafa karıştırıcı bir hataya
yol açar (bkz. "@RestController Test Etmek: JSON Gövdesini jsonPath ile
Doğrulamak").

**4. `standaloneSetup(...)` ile `@Valid`'in çalıştığını varsayıp,
`@ControllerAdvice`'ı eklemeyi atlamak.** Validator varsayılan olarak
kurulur ve `MethodArgumentNotValidException` fırlatılır, ama bu exception'ı
düzgün bir `ProblemDetail`'e çeviren advice elle eklenmediği sürece, test
beklenmedik bir 500 ile karşılaşır (bkz. "Validation Hatalarını Test Etmek:
400 ve ProblemDetail").

**5. `@WebMvcTest`'te gerçek bir veritabanına erişmeye çalışmak.** Bu dilim,
kasıtlı olarak `@Repository` bean'lerini yüklemez -- bir repository'ye
ihtiyaç duyan controller, o repository `@MockitoBean` ile sahtelenmediği
sürece çalışmaz (bkz. "Bu Projenin Kendi HomeController'ını Test Etmek:
Gerçek Bir Örnek").

## Özet, Cheat Sheet ve Terimler Sözlüğü

Spring MVC'de test yazmak, üç katman arasında bilinçli bir seçim yapmakla
başlıyor -- saf birim testi, `@WebMvcTest` slice testi, ya da tam
`@SpringBootTest` entegrasyon testi. Öne çıkan noktalar:

- `@WebMvcTest`: yalnızca web katmanını (DispatcherServlet, controller'lar,
  converter'lar) yükleyen, `@Service`/`@Repository`'i hariç tutan bir slice
  test annotation'ı
- `MockMvc`: gerçek bir HTTP sunucusu açmadan sahte istekler gönderen test
  aracı
- `MockMvcBuilders.standaloneSetup(...)`: Spring context olmadan, elle bir
  controller pipeline'ı kuran alternatif kurulum
- `@MockitoBean`: context'e bir Mockito sahtesi ekleyen/gerçek bean'in
  yerine geçiren annotation (`@MockBean`'in yerini aldı)
- `perform()`/`andExpect()`: sırasıyla isteği gönderen ve zincirlenebilir
  doğrulamalar yapan MockMvc metotları
- `status()`/`view()`/`model()`/`jsonPath()`/`content()`/`header()`: farklı
  yanıt yönlerini (durum kodu, view adı, model attribute'ları, JSON alanları,
  gövde, header'lar) doğrulayan matcher aileleri
- `MockMultipartFile`: multipart/form-data testleri için gerçek bir
  spring-test sınıfı (test scope)

Hızlı referans:

```java
@WebMvcTest(TopicController.class)
class TopicControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private TopicRepository topicRepository;

    @Test
    void unknownSlugReturns404() throws Exception {
        when(topicRepository.findBySlugWithCategoryAndCourse("x"))
                .thenReturn(Optional.empty());

        mockMvc.perform(get("/topics/x"))
                .andExpect(status().isNotFound());
    }
}
```

**Terimler Sözlüğü**

**`@WebMvcTest`** — Yalnızca Spring MVC web katmanını yükleyen, `@Service`/
`@Repository` bean'lerini hariç tutan bir Spring Boot test slice
annotation'ı.

**`MockMvc`** — Gerçek bir sunucu/soket açmadan sahte HTTP istekleri
gönderip yanıtları doğrulamayı sağlayan test aracı.

**`standaloneSetup`** — Bir Spring `ApplicationContext` olmadan, verilen
controller'ları elle bir `MockMvc` pipeline'ına bağlayan kurulum yöntemi.

**`@MockitoBean`** — Test context'ine bir Mockito sahtesi ekleyen ya da
gerçek bir bean'in yerine geçiren annotation; `@MockBean`'in yerini aldı.

**`jsonPath`** — Bir JSON yanıt gövdesinin belirli bir alanını, bir JSONPath
ifadesiyle doğrulayan matcher.

**`MockMultipartFile`** — Multipart dosya yükleme testleri için kullanılan,
`spring-test` kütüphanesinin sağladığı sahte dosya sınıfı.

## Ek: Mini Proje — Bu Projenin Kendi TopicController'ı İçin Kapsamlı Bir Test Paketi

Bu dersteki tüm teknikleri, bu projenin gerçek `TopicController`'ı (altı
bağımlılığın tamamı `@MockitoBean` ile sahtelenmiş) üzerinde birleştiriyoruz:

{{TopicTestFixtures.java}}

{{TopicControllerWebMvcTest.java}}

`TopicTestFixtures`, gerçek `Course`/`Category`/`Topic`/`TopicTranslation`
entity'lerini (hepsi Lombok `@Builder` kullanıyor) tutarlı bir ağaç olarak
kuran yardımcı metotlar sağlıyor. `TopicControllerWebMvcTest` üç senaryoyu
kapsıyor: bilinmeyen bir slug için 404, geçersiz bir `lang` parametresi için
400, ve tam yayınlanmış bir konu için gerçek `topic.html` template'i
üzerinden 200 -- son senaryoda mock'lanan her değer, controller'ın
production'da gerçek servislerden aldığı değerlerle aynı tipte (gerçek
`Topic`, gerçek `MarkdownService.MarkdownRenderResult`), bu yüzden template
gerçek bir isteği işliyormuş gibi normal şekilde render ediliyor.

## Ek: Mini Proje — Bir Interceptor'ı MockMvc ile Test Etmek

Son mini proje, Advanced Spring MVC dersinin "HandlerInterceptor Arayüzü:
preHandle, postHandle, afterCompletion" bölümündeki yaşam döngüsünü,
`WebMvcConfigurer: Interceptor'ı Kaydetmek` bölümündeki gibi bir
konfigürasyon sınıfı hiç yazmadan, doğrudan `MockMvc` ile izole test ediyor:

{{TimingInterceptorForTest.java}}

{{TimingInterceptorMockMvcTest.java}}

`TimingInterceptorForTest`, her isteğe `X-Response-Time-Ms` header'ı ekleyen
küçük, gerçekçi bir `HandlerInterceptor`. `TimingInterceptorMockMvcTest`,
`standaloneSetup(...).addInterceptors(...)` ile bu interceptor'ı doğrudan
`MockMvc`'ye takıyor -- tüm uygulamanın konfigürasyonunu (path pattern'ler,
diğer interceptor'lar) hiç devreye sokmadan, interceptor'ı KENDİ BAŞINA
doğruluyor.
