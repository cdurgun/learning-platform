Spring MVC'deki "Validation & Exception Handling", `@ExceptionHandler`, `@RestControllerAdvice`, ve RFC 7807 `ProblemDetail`'e ilk bakışı zaten işledi. Bu kategorinin daha önceki dersi "Java Bean Validation", artık daha çeşitli şekillerde başarısız olabilen -- custom, çapraz alanlı bir tanesi dahil -- çok daha zengin bir kısıt kümesi ekledi. Bu ders ikisini birbirine bağlıyor: validasyon başarısız olduğunda gerçekte ne olur, gerçek bir REST API'nin hataları için genel olarak durum kodlarını ve response gövdelerini nasıl tasarlarsın, ve bir client'ın görmemesi gereken hiçbir şeyi sızdırmadan hepsini nasıl merkezileştirirsin.

## Neden Her Hata Genel Bir 500 Olmamalı

Her hata için `500 Internal Server Error` döndürmek yazması kolay ama client için neredeyse işe yaramazdır -- "geçersiz veri gönderdin"i "veritabanımız çöktü"den, o da "bu kaynak yok"tan ayırt edemez, üç tamamen farklı client tepkisi gerektiren üç durum. İyi tasarlanmış bir API, CLIENT hatalarını (geçersiz girdi, bir iş kuralı ihlali, eksik bir kaynak) -- client'ın potansiyel olarak düzeltip yeniden deneyebileceği -- gerçek SUNUCU hatalarından -- client'ın düzeltemeyeceği -- ayırt eder. Bu dersteki her şey, bu ayrımı somutlaştırmakla ilgili.

## MethodArgumentNotValidException: @Valid Gerçekte Ne Fırlatır

"Validation & Exception Handling", `@Valid`'in validasyonu tetiklediğini gösterdi, ama bir `@RequestBody` üzerinde başarısız olduğunda gerçekte ne olduğunu adlandırmadı: Spring, controller metodunun gövdesi hiç çalışmadan önce bir `MethodArgumentNotValidException` fırlatır.

{{MethodArgumentNotValidExceptionExample.java}}

Exception, Spring MVC'nin geleneksel form binding için kullandığı TAM OLARAK AYNI tür olan bir `BindingResult` taşır -- başarısız her kısıt için bir `FieldError`, her biri kendi alanını ve kısıtın mesajını adlandırır. `exception.getBindingResult().getFieldErrors()`, bir handler'ın yalnızca ilkini değil, her tek hatayı aynı anda okumasının yoludur.

## Validasyon Hatalarını Bir ProblemDetail'e Dönüştürmek

`MethodArgumentNotValidException`'ı yakalayan bir `@RestControllerAdvice` metodu, o `BindingResult`'ı bir yanıta dönüştürür -- ve yalnızca alan-bazlı hatalardan fazlasını okuması gerekir.

{{ValidationProblemDetailExample.java}}

`getFieldErrors()`, sıradan tek-alan hatalarını (`@NotBlank`, `@Positive` ve geri kalanı) kapsar. `getGlobalErrors()`, "Validation & Exception Handling"in hiç ihtiyaç duymadığı bir şeyi kapsar: "Java Bean Validation"daki `@ValidDateRange` gibi tek bir alana bağlı olmayan, bu yüzden bir `FieldError` yerine bir `ObjectError` olarak ortaya çıkan sınıf-seviyesi bir custom kısıt. Yalnızca `getFieldErrors()`'ı okuyan bir handler, başarısız bir çapraz-alan kuralını yanıtından sessizce tamamen düşürürdü.

## Custom ProblemDetail Özellikleri

Spring MVC'nin dersi, bir `ProblemDetail`'e tek bir `"errors"` özelliği ekledi. Pratikte, gerçek bir API'nin hata gövdesi genelde bundan fazlasını gerektirir.

{{CustomProblemDetailPropertiesExample.java}}

`setType(...)`, `setTitle(...)`, ve tekrarlanan `setProperty(...)` çağrıları, makine tarafından okunabilir bir `errorCode`, ilgili spesifik kaynak, ve bir `timestamp` ile donatılmış bir `ProblemDetail` inşa eder -- hepsi hâlâ geçerli RFC 7807'dir, çünkü `ProblemDetail` tam olarak bu tür bir genişletme için tasarlanmıştır. Bir client, `errorCode` üzerinden, okunabilir bir mesaj string'i üzerinde asla güvenle yapamayacağı şekilde güvenilir biçimde dallanabilir.

## Bir Domain Exception İçin Doğru Durum Kodunu Seçmek

Farklı iş hataları farklı durum kodlarını hak eder -- doğru olanı seçmek, her client'ı hangi kategoride bir sorun olduğunu anlamak için response gövdesini incelemeye zorlamak yerine, spesifik bir şey iletir.

{{DomainExceptionStatusMappingExample.java}}

`404 Not Found`, hakkında soru sorulan kaynağın var olmadığı anlamına gelir. `409 Conflict`, isteğin kaynağın mevcut durumuyla çakıştığı anlamına gelir (bu örnekte bir yineleme). `422 Unprocessable Entity`, isteğin iyi biçimlendirilmiş ve anlaşılmış olduğu ama bir iş kuralını ihlal ettiği anlamına gelir -- yukarıdaki bölümlerde işlenen, isteğin kendisinin bozuk olduğu ya da validasyondan geçemediği anlamına gelen `400 Bad Request`'ten temel ayrım.

> 💡 Tip
> Hızlı bir kural: isteğin kendisi bozuksa (eksik alanlar, yanlış türler), bu `400`'dür. İstek iyi biçimlendirilmiş ama sorduğu ŞEY yoksa, bu `404`'tür. İyi biçimlendirilmiş ama mevcut durumla çakışıyorsa, bu `409`'dur. İyi biçimlendirilmiş ve kaynak var, ama bir iş kuralı yine de reddediyorsa, bu `422`'dir.

## ResponseEntityExceptionHandler ile Framework Exception'larını Merkezileştirmek

Spring MVC'nin dersindeki, ayrı `@ExceptionHandler` metotlarıyla `@RestControllerAdvice`, bir uygulamanın KENDİ exception'larının ele alınmasını merkezileştirir. `ResponseEntityExceptionHandler`, Spring MVC'nin KENDİSİNİN fırlattığı exception'lar için eşdeğerini yapar.

{{ResponseEntityExceptionHandlerExample.java}}

Onu genişletmek ve tek bir metodu -- burada `handleMethodArgumentNotValid(...)` -- override etmek, tam olarak o tek durumu özelleştirir, zaten ele almayı bildiği diğer her framework exception'ı (bozuk bir JSON gövdesi, desteklenmeyen bir medya türü, eksik bir parametre, ve daha fazlası) ise, hiçbiri için kod yazmadan, otomatik olarak makul varsayılan davranışını korur.

## Hata Yanıtlarını Güvenli Tutmak

Bir exception'ın mesajı ya da stack trace'i, genelde sunucudan asla çıkmaması gereken bilgiler içerir -- bir veritabanı hostname'i, bir iç dosya yolu, bir kütüphane sürümü.

{{SafeErrorResponseExample.java}}

Güvensiz versiyon -- `e.toString()`'i ya da exception'dan doğrudan bir mesajı döndürmek -- tam olarak bu bilgiyi, saldırgan olsun olmasın, isteği gönderen kişiye teslim eder. Güvenli versiyon, TAM exception'ı yalnızca ekibin görebileceği bir yerde loglar, ve client'a genel, sabit bir mesaj döndürür -- iki hedef kitle de (bir log'u debug eden bir mühendis, bir yanıtı okuyan bir client) tam olarak sahip olması gereken bilgiyi alır, fazlasını değil.

## Pratik, Uçtan Uca Bir Örnek

Yukarıdakilerin hepsini tek, gerçekçi bir endpoint'te birleştirmek, bu parçaların pratikte nasıl bir araya geldiğini gösterir.

{{PracticalCentralizedErrorHandlingExample.java}}

`OrderController.placeOrder(...)`, üç farklı şekilde başarısız olabilir, ve `OrderExceptionAdvice`, her birini gerçekten gerektirdiği teknikle ele alır: bir `MethodArgumentNotValidException`, alan-bazlı detayla bir `400`'e dönüşür, bir `OutOfStockException`, makine tarafından okunabilir bir `errorCode`'la bir `422`'ye dönüşür, ve diğer her şey tam olarak loglanıp güvenli, genel bir `500`'e indirgenir -- tek bir merkezi sınıf, bütün bir controller'ın gerçekçi başarısızlık modlarını kapsıyor.

## Best Practices

- Bir durum kodunu alışkanlıkla ya da kolaylıkla değil, gerçekte neyin ters gittiğine göre (bozuk istek, eksik kaynak, çakışan durum, reddedilen iş kuralı, gerçek sunucu hatası) seç.
- Bir `BindingResult`'tan hem `getFieldErrors()`'ı hem `getGlobalErrors()`'ı oku -- sınıf-seviyesi bir custom kısıtın hatası yalnızca ikincisinde görünür.
- Bir client'ın spesifik hataya göre dallanması gerekebileceği her durumda, yalnızca bir mesaj göstermek yerine makine tarafından okunabilir bir `errorCode`'u custom bir `ProblemDetail` özelliği olarak ekle.
- Beklenmeyen her şey için tam exception'ı içeride logla ve dışarıda genel bir mesaj döndür -- `e.getMessage()`'ın ya da bir stack trace'in asla doğrudan bir client'a ulaşmasına izin verme.

## Yaygın Hatalar

- Bir validasyon hatası ya da bir iş kuralı reddi için `500` döndürmek -- ikisi de client-kaynaklıdır, ve ikisi de client'ın harekete geçebileceği bir `4xx` durumunu hak eder.
- Yalnızca `getFieldErrors()`'ı okuyup, sınıf-seviyesi bir kısıtın hatasını -- yalnızca `getGlobalErrors()`'da göründüğü için -- tamamen kaçırmak.
- `409 Conflict` ve `422 Unprocessable Entity`'yi birbirinin yerine kullanmak -- bir conflict mevcut durumla ilgilidir; unprocessable bir entity, herhangi bir conflict'ten bağımsız, bir iş kuralıyla ilgilidir.
- Bir exception'ın ham mesajını ya da stack trace'ini bir response gövdesinde açığa çıkarmak, bir client'ın (ya da saldırganın) asla görmemesi gereken implementasyon detaylarını sızdırmak.

## Özet, Cheat Sheet ve Terimler Sözlüğü

**Özet**

- Bir `@RequestBody` üzerinde `@Valid`'in başarısız olması, alan-bazlı ve sınıf-seviyesi hataları taşıyan bir `BindingResult` içeren `MethodArgumentNotValidException` fırlatır.
- `getFieldErrors()`, tek-alan hatalarını kapsar; `getGlobalErrors()`, bir çapraz-alan kuralı gibi sınıf-seviyesi custom kısıtları kapsar.
- `ProblemDetail`, tek bir hata listesinin ötesinde -- bir hata kodu, bir kaynak id'si, bir timestamp -- bir API'nin ihtiyaç duyduğu kadar custom özelliği destekler.
- Farklı domain hataları farklı durum kodlarını hak eder: `400` bozuk, `404` eksik, `409` çakışan durum, `422` reddedilen iş kuralı, `500` gerçek sunucu hatası.
- `ResponseEntityExceptionHandler`, `@RestControllerAdvice`'ın bir uygulamanın kendi exception'larının ele alınmasını merkezileştirmesi gibi, Spring MVC'nin kendi exception'larının ele alınmasını merkezileştirir.
- Güvenli bir hata yanıtı, tam exception'ı içeride loglar ve dışarıda yalnızca genel bir mesaj döndürür.

**Cheat Sheet**

```java
// İki tür validasyon hatasını da okumak
ex.getBindingResult().getFieldErrors();   // alan-bazlı
ex.getBindingResult().getGlobalErrors();  // sınıf-seviyesi custom kısıtlar

// Custom ProblemDetail özellikleri
ProblemDetail problem = ProblemDetail.forStatusAndDetail(status, detail);
problem.setProperty("errorCode", "OUT_OF_STOCK");

// Domain exception'lar için durum kodları
@ExceptionHandler(NotFoundException.class)
@ResponseStatus(HttpStatus.NOT_FOUND) // 404
@ExceptionHandler(ConflictException.class)
@ResponseStatus(HttpStatus.CONFLICT) // 409
@ExceptionHandler(BusinessRuleException.class)
@ResponseStatus(HttpStatus.UNPROCESSABLE_ENTITY) // 422

// Framework exception'larını merkezileştirmek
class GlobalMvcExceptionHandler extends ResponseEntityExceptionHandler {
    @Override
    protected ResponseEntity<Object> handleMethodArgumentNotValid(...) { ... }
}

// Güvenli fallback
@ExceptionHandler(Exception.class)
public ProblemDetail handleUnexpected(Exception e) {
    log.error("Unhandled exception", e);
    return ProblemDetail.forStatusAndDetail(HttpStatus.INTERNAL_SERVER_ERROR, "An unexpected error occurred.");
}
```

**Terimler Sözlüğü**

- **MethodArgumentNotValidException**: `@Valid`, bir `@RequestBody` üzerinde başarısız olduğunda Spring MVC'nin fırlattığı, bir `BindingResult` taşıyan exception.
- **Field error vs. object error**: bir `FieldError`, başarısız olan tek bir alanı raporlar; bir `ObjectError` (`getGlobalErrors()`'dan), tek bir alana bağlı olmayan sınıf-seviyesi bir hatayı raporlar.
- **422 Unprocessable Entity**: iyi biçimlendirilmiş, anlaşılmış ama yine de bir iş kuralını ihlal eden bir istek için durum kodu.
- **ResponseEntityExceptionHandler**: Spring MVC'nin kendi hazır exception'larını merkezi olarak ele almak için base sınıfı.
- **Güvenli hata yanıtı (safe error response)**: tam hata detayını içeride loglayan ama dışarıda yalnızca genel bir mesaj açığa çıkaran bir yanıt.
