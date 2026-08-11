# Advanced Spring MVC

Spring MVC Fundamentals'ın "Bir HTTP İsteğinin Yolculuğu: Request Lifecycle"
bölümünde bir isteğin DispatcherServlet'e kadar nasıl geldiğini, oradan
`HandlerMapping`/`HandlerAdapter` ile bir controller metoduna nasıl yönlendirildiğini
gördük. O yolculuğun üzerine, her isteğe **kesişen** (cross-cutting) davranış
eklemenin iki yolu var: `Filter` (Servlet API seviyesinde, DispatcherServlet'in
dışında) ve `HandlerInterceptor` (Spring MVC seviyesinde, DispatcherServlet'in
içinde). Bu ders bu ikisini, ikisinin de yapılandırıldığı `WebMvcConfigurer`'ı,
tarayıcıların farklı origin'ler arası istekleri nasıl kısıtladığını (CORS) ve
dosya yüklemenin (`multipart/form-data`) bu boru hattına nasıl oturduğunu ele
alıyor.

## HandlerInterceptor Nedir?

`HandlerInterceptor`, bir controller metodu çağrılmadan **önce**, çağrıldıktan
**sonra** ve yanıt tamamen bittiğinde çalışacak kod yazmanı sağlayan bir Spring
MVC arayüzü -- loglama, kimlik doğrulama, performans ölçümü gibi, birçok endpoint'te
tekrar eden ama endpoint'in kendi iş mantığına ait olmayan davranışlar için:

```java
interface MinimalInterceptor {
    boolean preHandle(Object request, Object response, Object handler);
    void afterCompletion(Object request, Object response, Object handler, Exception ex);
}
```

Gerçek arayüz `jakarta.servlet.http.HttpServletRequest`/`HttpServletResponse`
kullanır ve üçüncü bir metot (`postHandle`) daha taşır -- "HandlerInterceptor
Arayüzü: preHandle, postHandle, afterCompletion" bölümünün konusu.

## Neden Var?

Her controller metoduna aynı loglama/auth kodunu elle eklemek, Validation &
Exception Handling dersindeki "Neden Var?" bölümünde gördüğümüz tekrar sorununun
bir başka örneği -- kural her yerde tekrar eder, bir yerde unutulması kolaydır.
`HandlerInterceptor`, bu kesişen davranışı **tek bir yere** taşır ve
`WebMvcConfigurer` üzerinden hangi URL'lere uygulanacağını merkezi olarak
belirler; controller'ların kendisi bundan habersiz kalır.

## Tarihçe

`HandlerInterceptor` arayüzü Spring'in ilk sürümlerinden beri var -- Spring MVC'nin
kendisi kadar eski. Spring 5.0 (2017), üç metodu da **default** yaptı (öncesinde
soyut sınıf `HandlerInterceptorAdapter`'dan türetmek gerekiyordu, yalnızca
ihtiyaç duyulan metodu override etmek için); bu projenin kullandığı sürümde
`HandlerInterceptorAdapter` artık gereksiz. CORS desteği Spring 4.2'de (2015)
`@CrossOrigin` ile, Spring 4.3'te de global `WebMvcConfigurer.addCorsMappings`
ile geldi -- ondan önce CORS için elle bir `Filter` yazmak gerekiyordu. Multipart
desteği ise Servlet 3.0 (2009) ile Servlet API'sine, oradan da Spring MVC'ye
`MultipartResolver` üzerinden girdi.

## Filter vs Interceptor: İkisi de "Araya Girer" ama Nerede?

İkisi de bir isteğin etrafına kod sarar, ama farklı katmanlarda:

{{FilterVsInterceptorExample.java}}

`Filter`, Servlet API'nin bir parçası -- container (embedded Tomcat) her isteği
DispatcherServlet'e ulaştırmadan önce filter zincirinden geçirir; bu yüzden
statik bir dosya isteği ya da 404 ile sonuçlanacak bir istek bile filter'lardan
geçer. `HandlerInterceptor` ise yalnızca DispatcherServlet bir isteği gerçekten
bir handler'a eşleştirdiğinde devreye girer -- eşleşme yoksa hiç çalışmaz. Bu
iki katmanın gerçekte nasıl iç içe geçtiğini "Bir İsteğin İzlediği Yol: Filter
Chain + Interceptor Chain Birlikte" bölümünde göreceğiz.

## HandlerInterceptor Arayüzü: preHandle, postHandle, afterCompletion

Üç callback, üç farklı ana karşılık gelir:

{{HandlerInterceptorLifecycleExample.java}}

`preHandle`, handler metodundan **önce** çalışır -- `false` dönmesi zinciri
hemen durdurur, ne handler ne `postHandle` çalışır (bkz. "preHandle'da İsteği
Durdurmak: Basit Bir Auth/Logging Örneği"). `postHandle`, handler başarıyla
tamamlandıktan sonra, view render edilmeden **önce** çalışır -- hâlâ
`ModelAndView`'i değiştirebilir. `afterCompletion` ise view render edildikten
sonra çalışır, handler bir exception fırlatmış olsa bile -- bu yüzden
temizlik/loglama için en güvenilir nokta odur (bkz. "Ek: Mini Proje — İstek
Süresini Loglayan Bir Interceptor").

## Bir İsteğin İzlediği Yol: Filter Chain + Interceptor Chain Birlikte

Filter'lar ile interceptor'lar aynı istekte iç içe çalışır:

{{RequestPipelineSimulationExample.java}}

Filter, DispatcherServlet'in **tüm** çağrısını (view render dahil) sarar --
interceptor'lar ise yalnızca handler çağrısını sarar, `afterCompletion` bile
view render edildikten sonra ama filter'ın "after" kodundan önce çalışır. Bu
sıralamayı bilmek, "hangi kod nerede loglanmalı" sorusuna doğru cevabı verir --
tüm istekleri (statik dosyalar dahil) görmek istiyorsan `Filter`, yalnızca
controller'a ulaşan istekleri görmek istiyorsan `HandlerInterceptor`.

## WebMvcConfigurer: Interceptor'ı Kaydetmek

Bir `HandlerInterceptor` implement etmek yetmez -- Component Scanning
dersindeki `@Component` gibi otomatik bulunmaz, açıkça kaydedilmesi gerekir:

{{InterceptorRegistrationExample.java}}

`WebMvcConfigurer`, Spring MVC'nin başlangıçta aradığı bir genişletme noktası --
`@Configuration` işaretli bir sınıf bunu implement edip `addInterceptors`'ı
override ettiğinde, `registry.addInterceptor(...)` ile eklenen her interceptor,
`HandlerMapping`'in interceptor listesine katılır. Bu proje şu an bir
interceptor kaydetmiyor -- `WebConfig.java`, yalnızca `LocaleResolver` bean'i
tanımlayan bir `@Configuration` sınıfı; bir interceptor eklenecek olsa
`addInterceptors`'ı override ederek aynı sınıfa taşınabilirdi.

## addPathPatterns ve excludePathPatterns: Interceptor'ı Sınırlamak

Her interceptor her URL'de çalışmak zorunda değil:

{{PathPatternScopingExample.java}}

`addPathPatterns("/topics/**")` bir interceptor'ı yalnızca o desenle eşleşen
URL'lere sınırlar; `excludePathPatterns(...)` ise dahil edilmiş bir desen
içinden belirli bir alt kümeyi hariç tutar. Path Variable'lar ve Request
Parametreleri dersinde `@GetMapping`'in URL desenlerini gördük -- buradaki
`/**` de aynı Ant-style eşleştirmeyi kullanıyor, tek fark bunun bir handler
metodunu değil bir interceptor'ı kapsaması.

## Çoklu Interceptor: Sıralama ve Zincirleme

Birden fazla interceptor kayıtlıysa, sıralama önemli:

{{MultipleInterceptorOrderExample.java}}

`preHandle` çağrıları **kayıt sırasıyla** çalışır; `postHandle` ve
`afterCompletion` ise **ters sırayla** -- try-with-resources'ın kaynakları
kapatma sırasına benzer bir "yığın" (stack) deseni. Bu, bir interceptor'ın
diğerinin `preHandle`'ının zaten çalıştığını güvenle varsayabilmesini sağlar --
örneğin bir loglama interceptor'ı, bir auth interceptor'ın request'e koyduğu
kullanıcı bilgisine `postHandle`'da güvenle erişebilir.

## preHandle'da İsteği Durdurmak: Basit Bir Auth/Logging Örneği

`preHandle`'ın `false` dönme yeteneği, onu basit bir erişim kontrolü için de
kullanılabilir kılar:

{{AuthLoggingInterceptorExample.java}}

Burada `response.setStatus(401)` çağrısı önemli -- `false` dönmek zinciri
durdurur ama yanıt kodunu **kendin** ayarlamazsan istemci varsayılan 200 alır.
Bu, gerçek bir güvenlik framework'ünün (Spring Security gibi) yaptığının çok
basitleştirilmiş bir hâli -- bu proje Spring Security kullanmıyor, ama
mekanizmanın temel fikri (isteği handler'a ulaşmadan reddetmek) birebir aynı.

## CORS Nedir? Same-Origin Policy ve Preflight Request

Tarayıcılar, bir sayfanın farklı bir origin'den (şema+host+port) veri okumasını
varsayılan olarak engeller -- **same-origin policy**. CORS, sunucunun "bu
origin'e izin veriyorum" demesinin standart yolu:

{{CorsPreflightExample.java}}

Basit olmayan bir istek (örneğin özel bir header taşıyan ya da `GET`/`POST`
dışında bir metotla yapılan istek) için tarayıcı önce bir **preflight**
gönderir -- gerçek isteği hiç göndermeden, `OPTIONS` metoduyla "bu isteği
yapabilir miyim?" diye sorar. Sunucu doğru `Access-Control-Allow-*`
header'larıyla yanıt vermezse, tarayıcı gerçek isteği hiç göndermez.
`CorsConfiguration`, bu kararı üreten nesne -- `checkOrigin`/`checkHttpMethod`
metotları, tarayıcının sorduğu sorulara verilecek cevabı hesaplar.

## @CrossOrigin: Controller/Metot Seviyesinde CORS

CORS'u tek tek endpoint'lere tanımlamanın yolu `@CrossOrigin`:

{{CrossOriginAnnotationExample.java}}

Reflection dersinde gördüğümüz `getAnnotation` mekanizması burada da aynen
işliyor -- Spring, uygulama başlarken her handler metodunu tarar, `@CrossOrigin`
varsa attribute'larından (`origins`, `methods`, ...) bir `CorsConfiguration`
inşa eder ve o mapping için saklar. `@RequestMapping` ve arkadaşlarının nasıl
okunduğuyla (Mapping Annotation'ları ve HTTP Metotları dersi) birebir aynı
mekanizma.

## WebMvcConfigurer ile Global CORS Yapılandırması

Her controller'a `@CrossOrigin` eklemek yerine, tek bir yerden tüm `/api/**`
için CORS tanımlamak da mümkün:

{{GlobalCorsConfigExample.java}}

`addCorsMappings`, "WebMvcConfigurer: Interceptor'ı Kaydetmek" bölümündeki
`addInterceptors` ile aynı `WebMvcConfigurer` arayüzünün başka bir metodu --
ikisi de aynı `@Configuration` sınıfında bir arada bulunabilir. Bir URL deseni
birden fazla `CorsRegistration`'la eşleşirse (biri global, biri `@CrossOrigin`
ile) Spring bunları birleştirmeye çalışır, ama pratikte karışıklığı önlemek için
genelde **ya global ya da annotation tabanlı** bir yaklaşım seçilir, ikisi
birden değil.

## Multipart File Upload: @RequestParam ile MultipartFile Almak

Dosya yükleme, `@RequestBody`'nin (Request ve Response Handling dersi) tek bir
JSON gövdeyi okumasından farklı bir mekanizma kullanır:

{{MultipartUploadControllerExample.java}}

`multipart/form-data`, isteği adlandırılmış **parçalara** ayırır -- her parça
ayrı bir form alanı ya da dosya olabilir. `MultipartFile`, Path Variable'lar ve
Request Parametreleri dersindeki "@RequestParam: Query String'den Değer Okumak"
bölümündeki gibi `@RequestParam`'la bağlanır, ama okuduğu şey bir query
parametresi değil, isteğin bir parçası -- `getOriginalFilename()`,
`getSize()`, `getBytes()` gibi metotlarla o parçaya erişilir.

## Multipart Yapılandırması ve Boyut Sınırları

`spring.servlet.multipart.max-file-size`/`max-request-size`, Spring'in
handler'a hiç ulaşmadan reddedeceği bir üst sınır tanımlar:

{{MultipartSizeLimitExample.java}}

Sınır aşıldığında fırlatılan `MaxUploadSizeExceededException`, Validation &
Exception Handling dersindeki "Controller-Seviyesinde Hata Yakalama:
@ExceptionHandler" ve "Global Hata Yönetimi: @RestControllerAdvice"
bölümlerinde gördüğümüz mekanizmayla aynı şekilde yakalanır; "ProblemDetail:
RFC 7807 ile Standart Hata Gövdesi" bölümündeki gibi standart bir hata gövdesi
döndürmek, ham bir stack trace'i istemciye sızdırmaktan çok daha iyi bir
davranış.

## Best Practices

- **`Filter`'ı yalnızca gerçekten her isteği (statik dosyalar dahil) görmen
  gerektiğinde kullan, aksi halde `HandlerInterceptor`'ı tercih et** -- ikincisi
  Spring'in kendi mekanizmalarına (Model, exception handling) daha yakın çalışır
  (bkz. Filter vs Interceptor: İkisi de "Araya Girer" ama Nerede?).
- **Temizlik/loglama kodunu `postHandle` değil `afterCompletion`'a koy** --
  yalnızca `afterCompletion` handler bir exception fırlatsa bile çalışır (bkz.
  "HandlerInterceptor Arayüzü: preHandle, postHandle, afterCompletion").
- **CORS'u ya global (`WebMvcConfigurer.addCorsMappings`) ya da annotation
  tabanlı (`@CrossOrigin`) yönet, ikisini karıştırma** -- karışık kullanım,
  hangi kuralın hangi endpoint'e uygulandığını takip etmeyi zorlaştırır (bkz.
  "WebMvcConfigurer ile Global CORS Yapılandırması").
- **Multipart boyut sınırlarını her zaman açıkça yapılandır** -- varsayılan
  sınırlar (Spring Boot'ta 1MB) çoğu gerçek dosya yükleme senaryosu için ya çok
  düşük ya da hiç düşünülmeden bırakılmış olabilir; her iki durumda da bilinçli
  bir karar olmalı (bkz. "Multipart Yapılandırması ve Boyut Sınırları").

## Yaygın Hatalar

**1. `Filter` ile `HandlerInterceptor`'ı birbirinin yerine geçebilir sanmak.**
Bir `Filter`, Spring'in `Model`/`HandlerMethod` gibi kavramlarına erişemez --
yalnızca ham `ServletRequest`/`ServletResponse` görür; bir handler'ın hangi
controller'a eşleştiğini bilmesi gerekiyorsa doğru araç `HandlerInterceptor`'dır
(bkz. Filter vs Interceptor: İkisi de "Araya Girer" ama Nerede?).

**2. `preHandle`'da `false` dönüp yanıt kodunu ayarlamayı unutmak.** Zincir
durur ama istemci hâlâ varsayılan `200 OK` alır -- `false` dönmeden önce
`response.setStatus(...)` çağırmak gerekir (bkz. "preHandle'da İsteği
Durdurmak: Basit Bir Auth/Logging Örneği").

**3. Birden fazla interceptor'da `postHandle`'ın da kayıt sırasıyla çalıştığını
sanmak.** `preHandle` ileri sırada, `postHandle`/`afterCompletion` ise ters
sırada çalışır -- bu farkı unutmak, bir interceptor'ın diğerinin state'ine
yanlış zamanda erişmesine yol açabilir (bkz. "Çoklu Interceptor: Sıralama ve
Zincirleme").

**4. CORS hatasını sunucu tarafında bir hata sanıp sunucu loglarında aramak.**
Tarayıcı, preflight başarısız olduğunda gerçek isteği hiç göndermez -- sunucu
logunda hiçbir şey görünmeyebilir; hata yalnızca tarayıcının geliştirici
konsolunda görünür (bkz. "CORS Nedir? Same-Origin Policy ve Preflight
Request").

**5. `@CrossOrigin`'i yalnızca `@RestController` sınıfına ekleyip metotların
kendi `@CrossOrigin`'ini unutmak.** Sınıf seviyesindeki `@CrossOrigin`, o
sınıftaki tüm metotlara varsayılan olarak uygulanır, ama bir metot kendi
`@CrossOrigin`'ini tanımlarsa sınıf seviyesindekini **tamamen** geçersiz kılar,
birleştirmez -- bu, beklenmedik şekilde bazı endpoint'lerin CORS izinlerini
kaybetmesine yol açabilir (bkz. "@CrossOrigin: Controller/Metot Seviyesinde
CORS").

**6. Multipart boyut sınırını yalnızca `max-file-size` ile ayarlayıp
`max-request-size`'ı unutmak.** Birden fazla dosya içeren bir istekte her dosya
tek başına sınırın altında kalabilir ama toplamı `max-request-size`'ı aşabilir
-- ikisi ayrı sınırlar, ikisi de ayrı ayrı yapılandırılmalı (bkz. "Multipart
Yapılandırması ve Boyut Sınırları").

## Özet, Cheat Sheet ve Terimler Sözlüğü

`Filter` ve `HandlerInterceptor`, bir isteğin etrafına kesişen davranış eklemenin
iki farklı katmandaki yolu; `WebMvcConfigurer` ikisinin de (interceptor kaydı,
CORS) yapılandırıldığı merkezi nokta; CORS ve multipart ise gerçek dünya
uygulamalarının sıkça karşılaştığı iki somut senaryo. Öne çıkan noktalar:

- `Filter`: Servlet API seviyesinde, **tüm** istekleri görür (DispatcherServlet'in
  dışında)
- `HandlerInterceptor`: Spring MVC seviyesinde, yalnızca eşleşen istekleri
  görür (`preHandle`/`postHandle`/`afterCompletion`)
- `preHandle` `false` dönerse zincir durur -- handler ve `postHandle` hiç
  çalışmaz
- `afterCompletion`, exception olsa bile her zaman çalışır -- temizlik/loglama
  için en güvenilir nokta
- Çoklu interceptor: `preHandle` ileri sırada, `postHandle`/`afterCompletion`
  ters sırada
- `WebMvcConfigurer.addInterceptors`/`addCorsMappings`: interceptor kaydı ve
  global CORS için genişletme noktaları
- CORS: same-origin policy'nin sunucu tarafından gevşetilmesi; preflight,
  `OPTIONS` ile önceden sorulan bir izin sorusu
- `@CrossOrigin`: controller/metot seviyesinde CORS, `WebMvcConfigurer`'a
  alternatif
- `MultipartFile`: `multipart/form-data` isteğinin bir parçasını temsil eden,
  `@RequestParam` ile bağlanan arayüz
- `max-file-size`/`max-request-size`: multipart yükleme için iki ayrı boyut
  sınırı

Hızlı referans:

```java
@Configuration
class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new AuthInterceptor())
                .addPathPatterns("/api/**")
                .excludePathPatterns("/api/public/**");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("https://example.com")
                .allowedMethods("GET", "POST");
    }
}

@RestController
class UploadController {
    @PostMapping("/upload")
    ResponseEntity<String> upload(@RequestParam("file") MultipartFile file) {
        return ResponseEntity.ok(file.getOriginalFilename() + ": " + file.getSize() + " bytes");
    }
}
```

**Terimler Sözlüğü**

**`Filter`** — Servlet API'nin bir parçası; container'ın DispatcherServlet'e
ulaşmadan önce her isteği geçirdiği, kesişen davranış için kullanılan arayüz.

**`HandlerInterceptor`** — Spring MVC'ye özel, yalnızca bir handler'a eşleşen
istekleri saran, `preHandle`/`postHandle`/`afterCompletion` callback'lerine
sahip arayüz.

**`WebMvcConfigurer`** — Interceptor kaydı ve CORS gibi Spring MVC
yapılandırmalarının yapıldığı, `@Configuration` sınıflarının implement ettiği
genişletme noktası.

**Same-origin policy** — Tarayıcıların, bir sayfanın farklı bir origin'den veri
okumasını varsayılan olarak engelleyen güvenlik kuralı.

**CORS (Cross-Origin Resource Sharing)** — Sunucunun, belirli origin'lere
same-origin policy'yi gevşeterek izin vermesini sağlayan HTTP header
mekanizması.

**Preflight request** — Tarayıcının, "basit olmayan" bir isteği göndermeden
önce `OPTIONS` metoduyla sunucuya izin sorduğu ön istek.

**`@CrossOrigin`** — CORS izinlerini controller sınıfı ya da metodu
seviyesinde tanımlayan annotation.

**`MultipartFile`** — Bir `multipart/form-data` isteğindeki tek bir dosya
parçasını temsil eden Spring arayüzü.

**`MaxUploadSizeExceededException`** — Yapılandırılmış boyut sınırı aşıldığında
Spring'in fırlattığı, `@ExceptionHandler` ile yakalanabilen exception.

## Ek: Mini Proje — İstek Süresini Loglayan Bir Interceptor

Bu dersin `HandlerInterceptor` mekaniğini gerçekçi bir senaryoda birleştiriyoruz:
`preHandle`'da bir zamanlayıcı başlatıp `afterCompletion`'da (handler başarılı
olsa da olmasa da) geçen süreyi loglayan bir interceptor:

{{RequestLoggingInterceptorExample.java}}

{{RequestLoggingInterceptorDemo.java}}

`afterCompletion`'ın kullanılması bilinçli bir seçim -- "HandlerInterceptor
Arayüzü: preHandle, postHandle, afterCompletion" bölümünde gördüğümüz gibi, bu
callback handler bir exception fırlatsa bile çalışır, yani yavaş **ve** başarısız
olan bir istek de doğru şekilde loglanır. `RequestLoggingInterceptorDemo`, hem
başarılı hem başarısız bir isteği simüle ederek ikisinin de loglandığını
gösteriyor.

## Ek: Mini Proje — CORS Destekli Dosya Yükleme Endpoint'i

Son mini proje, bu dersin üç konusunu (`@CrossOrigin`, `MultipartFile`, boyut
sınırı aşıldığında `@ExceptionHandler`) tek bir endpoint'te birleştiriyor:

{{FileUploadCorsController.java}}

{{FileUploadCorsDemo.java}}

`FileUploadCorsController`, farklı bir origin'den (örneğin ayrı bir frontend
uygulamasından) çağrılabilmesi için `@CrossOrigin` taşıyor, `MultipartFile`
parametresiyle dosyayı alıyor, ve boyut sınırını aşan bir dosya için kendi
`@ExceptionHandler`'ıyla (Validation & Exception Handling dersindeki
`@RestControllerAdvice` yerine, bu kez controller'a **yerel** olarak) bir
`ProblemDetail` döndürüyor. `FileUploadCorsDemo`, küçük bir dosyayla başarılı,
büyük bir dosyayla da 413 sonucu üreten iki çağrıyı gösteriyor.
