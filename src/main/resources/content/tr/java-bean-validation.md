Spring MVC'deki "Validation & Exception Handling", Bean Validation'ın günlük çekirdeğini zaten işledi: `@NotNull`/`@NotEmpty`/`@NotBlank`, `@Size`/`@Min`/`@Max`, `@Email`/`@Pattern`, `@Valid`, `Validator`/`ConstraintViolation` mekanizması, ve iç içe nesnelerde cascading validation. Bu ders bunların hiçbirini tekrarlamıyor. Tam olarak o dersin bıraktığı yerden devam ediyor — orada işlenmeyen hazır kısıtlar, bir violation'ın ürettiği mesajları özelleştirmek, ve hazır kısıtların gerçekten ifade edemediği kurallar için kendi validation kuralını yazmak.

## Temellerin Ötesi: Bu Ders Neyin Üzerine İnşa Ediyor

Buradaki her şey, `@Valid`'in bir `@RequestBody` üzerinde validasyonu nasıl tetiklediğini ve bir `ConstraintViolation`'ı nasıl okuyacağını zaten bildiğini varsayıyor. Yeni olan: işaretli sayılar ve tarihler için kısıtlar, tam ondalık hassasiyet için kısıtlar, mesaj özelleştirmesi, ve — en büyük sıçrama — hazır kısıtların ifade edemediği kurallar için, birden fazla alanı aynı anda kapsayan kurallar dahil, kendi kısıt annotation'ını yazmak.

## İşaret Kısıtları: @Positive, @PositiveOrZero, @Negative, @NegativeOrZero

Dört kısıt, sayısal bir değerin işaretini kontrol eder, her biri ya sıkı ya da sıfırı içeren.

{{SignConstraintsExample.java}}

`@Positive` ve `@Negative` SIKI'dir — sıfırın kendisi ikisini de başarısız kılar. `@PositiveOrZero` ve `@NegativeOrZero` sıfıra izin verir. `@Min`/`@Max`'in kapsayıcı sınırlar olduğunu hatırla — `@Min(16)`, "en az 16" demektir, "16'dan büyük" değil. `@Positive` ve `@Negative` farklı çalışır: tanımı gereği sıfırı dışlarlar, ve "OrZero" varyantlarının `@Min(0)` ile ifade edebileceğin bir şey yerine ayrı, açık bir seçim olarak var olmasının nedeni tam olarak budur.

## Tarih ve Saat Kısıtları: @Past, @Future, @PastOrPresent, @FutureOrPresent

Dört kısıt daha, bir tarih ya da tarih-saat değerini, sabit bir tarihe değil, validasyonun çalıştığı andaki saate karşı kontrol eder.

{{DateTimeConstraintsExample.java}}

`@Past` ve `@Future` sıkıdır — "şimdi"nin kendisi ikisini de başarısız kılar. `@PastOrPresent` ve `@FutureOrPresent`, şu anki ana izin verir. Bunlar Bean Validation'ın tanıdığı herhangi bir tarih/saat türünde çalışır — `LocalDate`, `LocalDateTime`, `java.util.Date` ve diğerleri — hangisini kullandığından bağımsız olarak karşılaştırma mantığı aynıdır.

## Tam Ondalık Sınırlar: @DecimalMin, @DecimalMax ve @Digits

`@Min`/`@Max`, yalnızca tam sayı sınırlarını kabul eder ve yalnızca tam sayı türlerine uygulanır. `@DecimalMin`/`@DecimalMax`, tam olarak bunların ele alamadığı şey için var: bir `BigDecimal` (ya da `double`/`float`) alanında kesirli sınırlar.

{{DecimalBoundsAndDigitsExample.java}}

Sınır bir `String` olarak yazılır — `@DecimalMin(0.01)` değil, `@DecimalMin("0.01")` — böylece herhangi bir floating-point yuvarlama sızıntısı olmadan tam bir ondalık değeri ifade edebilir. `@Digits(integer = 4, fraction = 2)`, ilişkili ama farklı bir kontroldür: bir aralık yerine, ondalık noktadan önce ve sonra kaç basamağa izin verildiğini sınırlar, ki bu tam olarak para tutarlarının genelde nasıl kısıtlandığıdır.

## Gerçekçi Bir DTO'da Kısıtları Birleştirmek

Bu kısıtların hiçbiri izole var olmaz — gerçek bir request DTO'su, "Validation & Exception Handling"in `@Valid` kapsamından beklediğin gibi, birkaçını aynı anda birleştirir.

{{CombinedConstraintsProductDtoExample.java}}

`CreateProductRequest`, Spring MVC'nin dersinden zaten tanıdık kısıtları (`@NotBlank`, `@Size`) burada şimdiye kadar işlenenlerle (`@Positive`, `@DecimalMin`, `@Digits`, `@Future`) karıştırıyor — ve controller parametresindeki `@Valid`, `create(...)`'in gövdesi hiç çalışmadan önce hepsini çalıştırır, tam olarak orada zaten işlenen mekanizma.

## Validation Mesajlarını Özelleştirmek

Her kısıt bir `message` özniteliğini kabul eder. Ayarlanmazsa, kütüphanenin varsayılan İngilizce ifadesini alırsın; açıkça ayarlarsan, bir violation'ın tam olarak neyi raporladığını kontrol edersin.

{{CustomValidationMessageExample.java}}

Literal bir string (`message = "Display name is required"`), en basit geçersiz kılmadır. Bir `{...}` yer tutucusu (`message = "{user.age.tooYoung}"`), bunun yerine classpath'teki bir `messages.properties` dosyasından çözülür — sıradan UI metni için kullanılan aynı Spring i18n mekanizması — ve bu, aynı kısıtın tek bir sabit kodlanmış string yerine aktif locale'de bir mesaj üretmesini sağlayan şeydir.

## Custom, Çapraz Alan Kısıtı Oluşturmak

Bazı kurallar, tek bir alana bağlı hazır bir kısıtla basitçe ifade edilemez — "checkout, check-in'den sonra olmalı", aynı anda İKİ alana bağlıdır, ve ne alandaki tek bir annotation bu ilişkiyi kontrol edemez. Custom bir kısıtın iki parçası vardır: annotation'ın kendisi (hangi `ConstraintValidator`'ın onu uyguladığını bildirir) ve validator sınıfı (gerçek kontrolü içerir).

{{CrossFieldCustomConstraintExample.java}}

`@ValidDateRange`, tek bir alanda değil, tam olarak kuralının `checkInDate` ve `checkOutDate`'i aynı anda görmesi gerektiği için SINIF seviyesine konur. `DateRangeValidator implements ConstraintValidator<ValidDateRange, BookingRequest>`, tek bir alanın değerini değil, bütün `BookingRequest`'i alır, ve `isValid(...)`'ten `true`/`false` döndürür — zaten kullandığın her hazır kısıtın arkasındaki AYNI interface, yalnızca elle uygulanmış.

> 💡 Tip
> Custom bir `ConstraintValidator`'ın `null` bir değer için `true` döndürmesi (burada `DateRangeValidator`'ın yaptığı gibi) standart kuraldır — bu, eksik bir değeri raporlama sorumluluğunu ayrı bir `@NotNull` kısıtına bırakır, her kısıtı tam olarak tek bir konuya odaklı tutar.

## Validation Grupları

Validation grupları, AYNI DTO'nun hangi işlemin çalıştığına bağlı olarak farklı kısıtları uygulamasına izin verir — bunlar olmadan, "`id`, create'te olmamalı" ve "`id`, update'te zorunlu" ikisi de aynı sınıfa aynı anda uygulanamazdı.

{{ValidationGroupsExample.java}}

Her kısıt ait olduğu grup(lar)la etiketlenir (`@NotNull(groups = OnUpdate.class)`), ve `validator.validate(request, OnCreate.class)`, YALNIZCA o grup için etiketlenmiş kısıtları çalıştırır. Bu, belirli bir sorun şekli için dar bir araçtır — aynı request türünün işlem başına gerçekten farklı kurallar uygulaması gerektiğinde başvur, genel amaçlı bir validation mekanizması olarak değil.

## Best Practices

- Varsayılan olarak sıkı işaret/tarih kısıtlarını (`@Positive`, `@Future`, ...) kullan, ve sınır değeri gerçekten geçerli bir durum olduğunda "OrZero"/"OrPresent" varyantına başvur.
- Bir `BigDecimal`'i uygulama kodunda elle karşılaştırmak yerine `@DecimalMin`/`@DecimalMax` string sınırlarını tercih et — kısıt, kuralı doğrudan alanda belgeler.
- Uygulaman birden fazla locale desteklemesi gerektiği anda, her kullanıcıya yönelik validation mesajını sabit kodlamak yerine bir `messages.properties` yer tutucusuna taşı.
- Custom bir `ConstraintValidator`'a yalnızca bir kural gerçekten hazır kısıtların birleşimiyle ifade edilemediğinde başvur — ve her custom kısıtı tek bir kurala odaklı tut.

## Yaygın Hatalar

- `@DecimalMin("0.01")` yerine `@DecimalMin(0.01)` yazmak — sınır bir sayısal literal değil, bir `String` olmalıdır.
- `@Positive`'in, `@Min(0)`'ın yapacağı gibi sıfırı kabul ettiğini varsaymak — etmez; bu durum için kısıt `@PositiveOrZero`'dur.
- Çapraz alan bir kuralı, gerçekte her iki alanı aynı anda görebilen tek bir sınıf-seviyesi custom kısıt yerine iki bağımsız tek-alan kısıtıyla doğrulamaya çalışmak.
- Bir validation grubunun yalnızca kendisi için açıkça etiketlenmiş kısıtları çalıştırdığını unutmak — etiketlenmemiş bir kısıt (hiç `groups` özniteliği olmayan) belirli bir gruba karşı doğrulama yapılırken sessizce atlanır.

## Özet, Cheat Sheet ve Terimler Sözlüğü

**Özet**

- `@Positive`/`@Negative` sıfır konusunda sıkıdır; `@PositiveOrZero`/`@NegativeOrZero` sıfıra izin verir.
- `@Past`/`@Future` şu anki an konusunda sıkıdır; `@PastOrPresent`/`@FutureOrPresent` ona izin verir.
- `@DecimalMin`/`@DecimalMax`, tam ondalık hassasiyet için `String` sınırları alır; `@Digits`, ondalık noktadan önce ve sonraki basamak sayısını sınırlar.
- Bir `message` özniteliği (literal bir string ya da `messages.properties`'ten çözülen bir `{...}` yer tutucusu), bir violation'ın neyi raporladığını özelleştirir.
- Custom bir kısıt, bir annotation'ı bir `ConstraintValidator`'la eşleştirir; onu sınıf seviyesine koymak, bir kuralın aynı anda birden fazla alanı kapsamasına izin verir.
- Validation grupları, tek bir DTO'nun hangi gruba karşı doğrulandığına bağlı olarak farklı kısıtları uygulamasına izin verir.

**Cheat Sheet**

```java
// İşaret ve tarih kısıtları
record Adjustment(@Positive int added, @PositiveOrZero int reserved) {}
record Booking(@FutureOrPresent LocalDate checkIn, @Future LocalDate checkOut) {}

// Ondalık hassasiyet
record Price(@DecimalMin("0.01") @Digits(integer = 6, fraction = 2) BigDecimal amount) {}

// Custom mesaj
@NotBlank(message = "Display name is required")
@Min(value = 16, message = "{user.age.tooYoung}")

// Custom, çapraz alan kısıtı
@Target(ElementType.TYPE)
@Constraint(validatedBy = DateRangeValidator.class)
@interface ValidDateRange { ... }

class DateRangeValidator implements ConstraintValidator<ValidDateRange, Booking> {
    public boolean isValid(Booking b, ConstraintValidatorContext ctx) {
        return b.checkOut().isAfter(b.checkIn());
    }
}

// Validation grupları
validator.validate(request, OnCreate.class);
```

**Terimler Sözlüğü**

- **İşaret kısıtı**: sayısal bir değerin işaretini kontrol eden, sıkı (`@Positive`/`@Negative`) ya da sıfırı içeren (`@PositiveOrZero`/`@NegativeOrZero`) bir kısıt.
- **Mesaj yer tutucusu**: bir kısıtın `message` özniteliğindeki, bir `messages.properties` paketinden çözülen `{...}` ile sarmalanmış bir anahtar.
- **Custom kısıt**: hazır kısıtların ifade edemediği kurallar için, elle yazılmış bir `ConstraintValidator`'la eşleştirilmiş bir kısıt annotation'ı.
- **Çapraz alan validasyonu (cross-field validation)**: aynı anda birden fazla alana bağlı, genelde sınıf-seviyesi bir custom kısıt olarak uygulanan bir validation kuralı.
- **Validation grubu**: belirli bir validation çağrısı için hangi kısıtların çalışacağını etiketlemek amacıyla kullanılan, bir türün farklı bağlamlarda farklı kurallar uygulamasına izin veren bir marker interface.
