# Validation & Exception Handling

Request ve Response Handling dersinde Jackson'ın `@RequestBody` gövdesini yalnızca
**biçim** olarak doğruladığını görmüştük -- JSON geçerli mi, tipler uyuşuyor mu.
İş kurallarını (boş olmayan bir isim, pozitif bir miktar, geçerli bir e-posta)
doğrulamak sana kalıyordu. Bu ders, o boşluğu iki mekanizmayla kapatıyor: **Bean
Validation** (`@Valid` ve arkadaşları), bir isteği controller'a ulaşmadan **önce**
reddetmenin standart yolu; **exception handling** (`@ExceptionHandler`,
`@RestControllerAdvice`, `ProblemDetail`), bir hata oluştuğunda istemciye tutarlı,
standart bir yanıt döndürmenin yolu.

## Validation & Exception Handling Nedir?

Bean Validation, bir Java nesnesinin alanlarına **annotation ile kural** yazma ve bu
kuralları tek bir çağrıyla kontrol etme standardıdır (JSR-380, `jakarta.validation`
paketi). Exception handling ise, bir controller metodunda (ya da validation'da)
oluşan bir hatayı, dağınık `try`/`catch` bloklarına gerek kalmadan, merkezi ve
tutarlı bir HTTP yanıtına çevirme mekanizmasıdır:

```java
record CreateUserRequest(@NotBlank String name, @Email String email) { }

@PostMapping("/users")
public String create(@Valid @RequestBody CreateUserRequest request) {
    // buraya yalnızca name boş değilse ve email geçerliyse ulaşılır
    return "Created: " + request.name();
}
```

## Neden Var?

Validation kuralını her controller metodunun başına elle yazmak (`if (name == null
|| name.isBlank()) throw ...`) hem tekrarlıdır hem unutulmaya açıktır -- bir alan
eklenir, kontrolü eklemeyi unutursun. Bean Validation, kuralı **veri tipinin
kendisine** taşır: `CreateUserRequest` nerede kullanılırsa kullanılsın, `@NotBlank`
kuralı onunla birlikte gelir. Benzer şekilde, her `catch` bloğunda elle bir hata
gövdesi inşa etmek tutarsız sonuçlar üretir (bir yerde düz metin, başka bir yerde
JSON, bir başkasında hiçbir şey); `@ExceptionHandler`/`@RestControllerAdvice`, bu
dönüşümü tek bir yerde toplar.

## Tarihçe

Bean Validation, Java EE 6 ile 2009'da JSR-303 olarak standartlaştırıldı;
`jakarta.validation` adına geçişi (Java EE'nin Jakarta EE'ye taşınmasıyla) izleyen
JSR-380 (Bean Validation 2.0), `@NotEmpty`/`@NotBlank` gibi artık tanıdık
annotation'ları ekledi. Hibernate Validator, bu standardın referans
implementasyonudur -- `spring-boot-starter-validation` bağımlılığı, projeye tam da
bunu (ve Spring'in `@Valid` entegrasyonunu) kazandırır. `@ExceptionHandler` Spring
3.0'da geldi; `@ControllerAdvice` (global karşılığı) Spring 3.2'de, `ProblemDetail`
(RFC 7807 desteği) ise Spring 6 / Spring Boot 3'te eklendi.

## @NotNull, @NotEmpty, @NotBlank: Boşluk Farkları

Üç annotation da "değer eksik olmasın" der, ama her biri farklı bir eşiği kontrol
eder:

{{NotNullBlankEmptyExample.java}}

`@NotNull`, yalnızca `null` olmamasını ister -- boş bir string (`""`) geçer.
`@NotEmpty`, `null` da boş string de reddeder -- ama yalnızca boşluklardan oluşan
bir string (`"   "`) geçer. `@NotBlank`, üçünü de reddeder -- pratikte kullanıcıdan
gelen metin alanları için en sık istenen budur.

## @Size, @Min, @Max: Sayısal ve Uzunluk Sınırları

`@Size`, bir string/koleksiyon/dizinin **uzunluğunu**; `@Min`/`@Max`, sayısal bir
değerin **aralığını** kontrol eder -- her iki sınır da dahildir (inclusive):

{{SizeMinMaxExample.java}}

`@Size(min = 3, max = 50)`, tam 3 ya da tam 50 karakteri kabul eder, 2 ya da 51'i
reddeder; `@Min(1) @Max(1000)` de aynı şekilde 1 ve 1000'i kabul eder.

## @Email ve @Pattern: Biçim Doğrulama

`@Email`, sözdizimsel olarak geçerli bir e-posta biçimini kontrol eder; `@Pattern`,
verdiğin herhangi bir düzenli ifadeye (regex) karşı kontrol eder -- kendi kuralını
yazabildiğin için en esnek annotation'dır:

{{EmailPatternExample.java}}

`@Pattern`'e verilen `message` attribute'una dikkat et: çoğu annotation'ın
varsayılan mesajı ("must match ...") kullanıcıya bir şey ifade etmez; `@Pattern`
gibi serbest biçimli kurallarda okunur bir `message` yazmak neredeyse zorunludur.

## @Valid ile İstek Gövdesini Doğrulamak

`@RequestParam`/`@PathVariable`'ın aksine, Bean Validation kuralları kendiliğinden
çalışmaz -- bir parametrenin önüne `@Valid` koymak, Spring'e "bu nesneyi
controller metodu çalışmadan önce doğrula" der:

{{ValidRequestBodyExample.java}}

`@NotBlank`/`@Email` kısıtlarından biri bile başarısız olursa, `create(...)`
metodunun gövdesi **hiç çalışmaz** -- Spring, metodu çağırmadan önce isteği
reddeder. Bu doğrulamanın gerçekte nasıl çalıştığını "@Valid'in Perde Arkası:
Validator ve ConstraintViolation" bölümünde göreceğiz.

## @Valid'in Perde Arkası: Validator ve ConstraintViolation

`@Valid`, kendi doğrulama motorunu icat etmez -- `jakarta.validation.Validator`'ı
(container'dan tamamen bağımsız, doğrudan da kullanılabilen bir arayüz) çağırır ve
sonucu senin için yorumlar:

{{ManualValidatorExample.java}}

`validator.validate(nesne)`, ihlal edilen her kural için bir `ConstraintViolation`
içeren bir `Set` döndürür; küme boşsa nesne geçerlidir. `@Valid @RequestBody`
başarısız olduğunda, Spring bu aynı sonucu doğrudan sana vermez --
`MethodArgumentNotValidException` içine sarıp (bir `BindingResult` taşıyarak)
fırlatır; bu, bir sonraki iki bölümde göreceğimiz `@ExceptionHandler` ile
yakalanabilir.

## İç İçe Nesnelerde Doğrulama: Cascading ile @Valid

Bean Validation, iç içe bir nesnenin alanlarını **varsayılan olarak** kontrol
etmez -- iç nesnenin de doğrulanmasını istiyorsan, o alanın önüne de ayrıca
`@Valid` koymak gerekir (buna cascading, "basamaklama" denir):

{{NestedValidationExample.java}}

`ShippingRequestWithoutCascade`'in `address` alanının önünde `@Valid` yoktur --
`Address`'in kendi `@NotBlank` kuralı hiç çalıştırılmaz, sonuç her zaman 0 ihlaldir.
`ShippingRequestWithCascade`'de `@Valid Address address` ile bu basamaklama açılır
ve iç nesnenin ihlalleri de kümeye eklenir.

## Controller-Seviyesinde Hata Yakalama: @ExceptionHandler

`@ExceptionHandler`, bir controller'ın içindeki bir metoda konduğunda, **aynı**
controller'daki herhangi bir handler metodun fırlattığı belirtilen türden bir
exception'ı yakalar:

{{ExceptionHandlerBasicExample.java}}

`getProduct(...)` bir `ProductNotFoundException` fırlattığında, çağıran kodun
gördüğü bir exception değil -- Spring, aynı controller içindeki eşleşen
`@ExceptionHandler`'ı bulup çalıştırır ve onun dönüş değerini yanıt olarak
gönderir; `@ResponseStatus(HttpStatus.NOT_FOUND)` de yanıtın durum kodunu belirler.

## Global Hata Yönetimi: @RestControllerAdvice

`@ExceptionHandler`'ın controller-seviyesinde kalması bir sorun yaratır: aynı tür
hatayı (örn. "kaynak bulunamadı") her controller'da ayrı ayrı ele almak gerekir.
`@RestControllerAdvice` (`@ControllerAdvice` + `@ResponseBody`), bunu **tüm**
controller'lar için tek bir yerde toplar:

{{RestControllerAdviceExample.java}}

Bu sınıftaki üç `@ExceptionHandler`, uygulamadaki **her** controller'ı kapsar --
"Controller-Seviyesinde Hata Yakalama: @ExceptionHandler" bölümündeki gibi tek bir
controller'a özel değildir. Son handler (`Exception.class`), hiçbir spesifik
handler eşleşmediğinde devreye giren bir son çare (catch-all); Spring her zaman en
**spesifik** eşleşen handler'ı seçer, bu yüzden `Exception.class` yalnızca gerçekten
beklenmeyen durumlarda çalışır.

## ProblemDetail: RFC 7807 ile Standart Hata Gövdesi

`@ExceptionHandler`'ın dönüş değeri düz bir `String` de olabilir, ama gerçek bir
API'de her takımın kendi hata JSON'ını icat etmesi tutarsızlık yaratır.
`ProblemDetail`, Spring'in RFC 7807'yi (standart, kendini açıklayan bir hata
biçimi) uygulayan yerleşik sınıfıdır:

{{ProblemDetailBasicExample.java}}

`ProblemDetail.forStatusAndDetail(status, detay)`, durum kodunu, standart bir
`title`'ı (durum kodundan otomatik türetilir) ve senin verdiğin `detail`'i taşıyan
bir nesne üretir -- gerçek bir Spring uygulamasında bu, `Content-Type:
application/problem+json` ile serileştirilir.

## Doğrulama Hatalarını ProblemDetail'e Dönüştürmek

`ProblemDetail`, sabit alanların (`status`, `detail`, `title`) ötesinde
`setProperty(...)` ile **özel** alanlar da taşıyabilir -- bu, "@Valid'in Perde
Arkası: Validator ve ConstraintViolation" bölümündeki `ConstraintViolation`
kümesini istemciye okunur bir liste olarak döndürmek için tam ihtiyacımız olan şey:

{{ProblemDetailValidationExample.java}}

`toProblemDetail(...)`, her `ConstraintViolation`'ı `"alan: mesaj"` biçiminde bir
metne çevirip `errors` adlı özel bir property olarak ekliyor -- istemci, yalnızca
"400 Bad Request" değil, **hangi alanların** neden geçersiz olduğunu da tek bir
yanıtta görüyor.

## Best Practices

- **Doğrulama kuralını controller'ın içine değil, request nesnesinin (record'un)
  üzerine yaz** -- "@Valid ile İstek Gövdesini Doğrulamak" bölümünde gördüğümüz
  gibi, kural annotation olarak tipe bağlı kaldığı sürece o tip nerede kullanılırsa
  kullanılsın geçerli kalır; controller içindeki elle yazılmış bir `if` bloğu
  yalnızca o metotta çalışır.
- **İç içe nesnelerde `@Valid`'i unutma** -- "İç İçe Nesnelerde Doğrulama: Cascading
  ile @Valid" bölümünde gördüğümüz gibi, bu kolayca gözden kaçan bir hatadır: dış
  nesne doğrulanıyor görünür, ama iç nesnenin kuralları sessizce hiç çalışmaz.
- **Hata yönetimini tek bir `@RestControllerAdvice`'ta topla, her controller'a
  ayrı `@ExceptionHandler` yazma** -- "Global Hata Yönetimi: @RestControllerAdvice"
  bölümünde gördüğümüz gibi, bu hem tekrarı önler hem tüm API'de tutarlı bir hata
  biçimi garanti eder.
- **Kendi hata JSON'unu icat etme, `ProblemDetail` kullan** -- "ProblemDetail: RFC
  7807 ile Standart Hata Gövdesi" bölümünde gördüğümüz gibi, bu hem standarttır hem
  de `setProperty(...)` ile ihtiyacın olan özel alanları (doğrulama hataları gibi)
  eklemene izin verir.

## Yaygın Hatalar

**1. `@NotNull`'ın boş string'i de reddettiğini sanmak.** "@NotNull, @NotEmpty,
@NotBlank: Boşluk Farkları" bölümünde gördüğümüz gibi, `@NotNull` yalnızca `null`'ı
reddeder -- kullanıcıdan gelen bir metin alanı için neredeyse her zaman istenen
`@NotBlank`'tir.

**2. İç içe bir nesnenin alanının otomatik doğrulanacağını varsaymak.** "İç İçe
Nesnelerde Doğrulama: Cascading ile @Valid" bölümünde gördüğümüz gibi, `@Valid`
cascading'i açıkça istemek gerekir -- aksi halde iç nesnenin kuralları sessizce
atlanır, hiçbir hata da vermez.

**3. `@Valid`'i unutup yalnızca `@RequestBody` yazmak.** Bean Validation
annotation'ları tipte dursa bile, `@Valid` olmadan hiçbir zaman **tetiklenmezler**
-- "@Valid ile İstek Gövdesini Doğrulamak" bölümünde gördüğümüz gibi, kuralın
yazılmış olması onun kontrol edildiği anlamına gelmez.

**4. `@ExceptionHandler(Exception.class)`'ı en üste yazıp diğer handler'ların hiç
çalışmadığını düşünmek.** Sıralama önemli değildir -- "Global Hata Yönetimi:
@RestControllerAdvice" bölümünde gördüğümüz gibi, Spring her zaman fırlatılan
exception'a **en spesifik** eşleşen handler'ı seçer, dosyadaki yazım sırası değil.

**5. Hata yanıtında yalnızca durum kodunu dönüp, hangi alanın neden geçersiz
olduğunu istemciye hiç söylememek.** "Doğrulama Hatalarını ProblemDetail'e
Dönüştürmek" bölümünde gördüğümüz gibi, `ProblemDetail`'in `setProperty(...)`'i
tam olarak bu bilgiyi taşımak için var -- bir `400` almak, istemcinin sorunu
düzeltebilmesi için yeterli değildir.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Bean Validation, bir nesnenin alanlarına annotation ile kural yazıp bu kuralları
`@Valid` ile otomatik tetikleme standardıdır; exception handling,
`@ExceptionHandler`/`@RestControllerAdvice` ile bir hatayı tutarlı bir HTTP
yanıtına (idealde bir `ProblemDetail`) çevirme mekanizmasıdır. Öne çıkan noktalar:

- `@NotNull`/`@NotEmpty`/`@NotBlank`: giderek daha sıkı üç "eksik olmasın" kuralı
- `@Size`/`@Min`/`@Max`: uzunluk ve sayısal aralık sınırları (her iki sınır dahil)
- `@Email`/`@Pattern`: biçim doğrulama, `@Pattern` serbest regex ile
- `@Valid`: bir parametreyi/alanı doğrulama tetikleyicisi; iç içe nesnelerde her
  seviyede ayrıca yazılmalı (cascading)
- `Validator`/`ConstraintViolation`: `@Valid`'in arkasındaki gerçek mekanizma,
  container olmadan da doğrudan kullanılabilir
- `@ExceptionHandler`: controller-seviyesinde hata yakalama;
  `@RestControllerAdvice` ile global hale gelir, en spesifik handler kazanır
- `ProblemDetail`: RFC 7807 standart hata gövdesi, `setProperty(...)` ile özel
  alanlar taşıyabilir

Hızlı referans:

```java
record CreateUserRequest(
        @NotBlank @Size(min = 2, max = 50) String name,
        @Email String email) { }

@PostMapping("/users")
public String create(@Valid @RequestBody CreateUserRequest request) {
    return "Created: " + request.name();
}

@RestControllerAdvice
class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ProblemDetail handleNotFound(ResourceNotFoundException e) {
        return ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, e.getMessage());
    }
}
```

**Terimler Sözlüğü**

**Bean Validation** — Bir Java nesnesinin alanlarına annotation ile kural yazma ve
bu kuralları tek bir `Validator` çağrısıyla kontrol etme standardı (JSR-380).

**`@Valid`** — Bir parametreyi/alanı, çağrı gerçekleşmeden önce Bean Validation
kurallarına göre doğrulamayı tetikleyen annotation.

**`ConstraintViolation`** — Bir Bean Validation kuralının ihlal edildiğini,
hangi alanda ve hangi mesajla ihlal edildiğini taşıyan nesne.

**Cascading** — İç içe bir nesnenin kendi kısıtlarının da kontrol edilmesi için,
o alanın önüne ayrıca `@Valid` yazma gerekliliği.

**`@ExceptionHandler`** — Bir metodun, belirtilen türden bir exception'ı
yakalayıp bir HTTP yanıtına çevirmesini sağlayan annotation.

**`@RestControllerAdvice`** — `@ExceptionHandler` metotlarını tüm uygulama
genelinde (tek bir controller'a değil) geçerli kılan, `@ResponseBody`'yi de içeren
annotation.

**`ProblemDetail`** — RFC 7807'yi uygulayan, Spring'in yerleşik standart hata
gövdesi sınıfı.

## Ek: Mini Proje — Kullanıcı Kayıt Formu

Bu dersteki doğrulama annotation'larını gerçekçi bir kayıt endpoint'inde bir araya
getiriyoruz, ve `@Valid`'in normalde **görünmeyen** iç işleyişini elle simüle
ediyoruz:

{{UserRegistrationController.java}}

{{UserRegistrationDemo.java}}

`dispatch(...)`, Spring'in gerçekte otomatik yaptığını görünür kılıyor: isteği
`register(...)` metoduna ulaşmadan **önce** doğruluyor, herhangi bir ihlal varsa
metodu hiç çağırmıyor. Geçersiz istekte yalnızca `email` alanı bozuk olduğu için
sonuç deterministik bir tek ihlal.

## Ek: Mini Proje — Ürün Kataloğu API'si

Son mini proje, bu dersin iki yarısını (doğrulama ve hata yönetimi) tek bir
API diliminde birleştiriyor -- doğrulama girişte, `@RestControllerAdvice` ise
controller'ın kendi fırlattığı bir exception'da devreye giriyor:

{{ProductCatalogApi.java}}

{{ProductCatalogApiDemo.java}}

`ProductCatalogController` ve `ProductCatalogExceptionHandler` **ayrı** sınıflar --
"Global Hata Yönetimi: @RestControllerAdvice" bölümünde vurguladığımız ayrımın
gerçek bir örneği: doğrulama, controller'ın kendi metoduna (`@Valid` ile) bağlı
kalırken, hata dönüşümü tamamen ayrı, paylaşılan bir advice sınıfında yaşıyor.
`ProductCatalogApiDemo`, geçerli bir create+get, geçersiz bir create (yalnızca
ihlal sayısını yazdırarak) ve bulunamayan bir get (advice'ın `ProblemDetail`'i
elle çağırarak) olmak üzere üç yolu da çalıştırıyor.

> 💡 Tip
> `ProductCatalogController`'ın `create(...)` metodu gerçek bir Spring
> ortamında olsaydı, `@Valid` başarısız olduğunda `MethodArgumentNotValidException`
> fırlar ve bu istisna da bir `@RestControllerAdvice`'a eklenecek ayrı bir
> `@ExceptionHandler(MethodArgumentNotValidException.class)` ile yakalanırdı --
> bu mini projede doğrulamayı `ProductCatalogApiDemo` içinde elle çağırıyoruz,
> çünkü bir gerçek `DispatcherServlet` olmadan bu otomatik tetiklenme gerçekleşmez.
