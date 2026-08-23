# Resilience4j

"Servisler Arası İletişim" dersi, order-service'e inventory-service'i çağırırken bir 404'ü bağlantı hatasından ayırt etmeyi ve ikincisini bir `InventoryServiceUnavailableException`'a çevirmeyi zaten öğretmişti ("Ağ Güvenilmez: inventory-service Ayakta Değilse Ne Olur?" bölümüne bakınız). Bu dürüst bir hata yönetimi -- ama bir boşluğu var: inventory-service birkaç SANİYELİĞİNE bile düşse, stok verisine ihtiyaç duyan HER order-service isteği hemen ve aynı şekilde başarısız olur, ve order-service zaten zorlandığı belli olan bir servisi durmadan yoklamaya devam eder. Bu ders, her iki sorunu da çözen kütüphaneyi tanıtıyor: Resilience4j.

## Resilience4j Nedir?

Resilience4j, riskli bir çağrıyı -- en sık başka bir servise yapılan bir çağrıyı -- bir veya daha fazla KORUYUCU davranışla saran hafif bir Java kütüphanesi: bir circuit breaker (açıkça başarısız olan bir servisi çağırmayı DURDURMAK), bir retry (vazgeçmeden önce TEKRAR denemek), bir rate limiter (bir çağrının ne sıklıkla yapılabileceğini SINIRLAMAK), ve bir bulkhead (aynı anda kaç çağrının UÇUŞTA olabileceğini SINIRLAMAK). Her davranış bir metodun üzerine bir annotation ile uygulanır -- metodun kendi kodu, hataya nasıl dayanacağıyla değil, gerçekte ne yaptığıyla ilgilenmeye devam eder.

## Neden Var?

`ResourceAccessException`'ı yakalayıp `InventoryServiceUnavailableException` fırlatmak (StockClientWithDiscovery'nin zaten yaptığı gibi) gerekli ama YETERLİ değil. İki gerçek sorun kalıyor: birincisi, inventory-service düşükse, order-service HER isteği denemeye devam eder, zaten başarısız olacak bağlantıları beklemek için zaman harcar, ve zaten toparlanmaya çalışan bir servise ek yük bindirir. İkincisi, tek bir kısa ağ aksaklığı, bir kez daha denemek muhtemelen başarılı olacaksa isteği doğrudan başarısız kılmamalı. İkisini de elle iyi yönetmek -- hata sayılarını izlemek, ne zaman çağırmayı bırakacağına karar vermek, doğru aralarla tekrar denemek -- tam olarak ustaca yanlış yapılması kolay olan türden altyapı kodu. Resilience4j bunu kod yerine yapılandırma olarak sağlıyor.

## Tarihçe

Resilience4j, 2016'da, Netflix Hystrix'in (Netflix'in kendi circuit breaker kütüphanesi, Zuul ve Eureka ile aynı dönemden -- bkz. "Servis Keşfi ve Eureka" ve "API Gateway" derslerinin "Tarihçe" bölümleri) AÇIK bir yerine geçme amacıyla oluşturuldu. Hystrix, 2018'de Netflix tarafından bakım moduna alındı -- Netflix'in kendi açık kaynak altyapı araçlarının birçoğundan geri çekildiği aynı genel dönem. Resilience4j baştan itibaren daha hafif olacak (Hystrix'in sahip olduğu RxJava bağımlılığı olmadan, Java 8+ fonksiyonel tarzı için tasarlandı) ve modüler olacak şekilde tasarlandı -- bir proje, büyük tek bir kütüphane yerine yalnızca circuit breaker modülüne, yalnızca retry'a, ya da herhangi bir kombinasyona bağımlı olabilir.

## order-service'e Resilience4j Eklemek

Resilience4j, Spring Boot'a `resilience4j-spring-boot3` starter'ı ve `application.yml`'de annotation-tabanlı yapılandırmayla entegre olur -- Eureka Server ya da api-gateway'in aksine ayrı bir sunucu ya da altyapı parçasına gerek yok; her koruyucu davranış order-service'in KENDİ İÇİNDE çalışır.

{{Resilience4jConfig.yml}}

> 💡 Tip
> Örnek adı (yukarıdaki `inventoryService`) Resilience4j'nin yapılandırmayı gruplamak için İÇ olarak kullandığı bir isim -- Eureka servis adıyla (`inventory-service`) birebir eşleşmesine hiç gerek yok, ama ilgili bir isim seçmek takip etmeyi kolaylaştırır.

## Circuit Breaker: Durumlar ve Yapılandırma

Bir circuit breaker'ın üç durumu vardır. CLOSED normal durumdur -- çağrılar geçer, ve başarısızlıklar sayılır. Başarısızlık oranı yapılandırılmış bir eşiği geçerse, devre OPEN'a düşer -- yapılandırılmış bir bekleme süresi boyunca HER çağrı, gerçek çağrıyı denemeden bile, HEMEN başarısız olur. O bekleme süresinden sonra, devre HALF_OPEN'a geçer, burada az sayıda TEST çağrısına izin verilir -- başarılı olurlarsa devre yeniden kapanır; başarısız olurlarsa yeniden açılır.

## StockClient'ı Bir Circuit Breaker ile Sarmak

`@CircuitBreaker` annotation'ı bu durum makinesini TEK bir metoda uygular -- metodun kendi mantığında hiçbir değişiklik gerekmez, yalnızca imzasında ve bir fallback metodunda.

{{ResilientStockClient.java}}
{{StockCheckResponse.java}}

> ⚠️ Warning
> `@CircuitBreaker`, tıpkı `@Transactional` gibi (bkz. Transaction Management dersi), yalnızca Spring'in PROXY mekanizması üzerinden çalışır -- `checkStock`'u AYNI sınıftaki BAŞKA bir metottan çağırmak (`this.checkStock(...)`) proxy'yi tamamen atlar, ne circuit breaker ne de retry hiçbir zaman çalışmaz.

## Fallback Metotları: Devre Açıldığında Ne Olur?

Bir fallback metodu, devre açık olduğunda ya da her retry denemesi başarısız olduğunda, gerçek metodun YERİNE çalışan metottur -- imzası orijinal metodun parametreleriyle AYNI olmalı, artı sonda bir `Throwable` daha. Yukarıdaki `checkStockFallback`, istisnanın yukarı yayılmasına izin vermek yerine bozuk-ama-geçerli bir `StockCheckResponse` döndürüyor -- bu bilinçli bir tercih, siparişin tamamen başarısız olması yerine "stok rezerve edilmediği varsayılsın" diyerek sipariş işlemenin devam etmesine izin veriyor.

## Retry: Vazgeçmeden Önce Tekrar Denemek

Yukarıda `checkStock`'ta da görülen `@Retry`, başarısız bir çağrıyı, aralarında bir bekleme ile, circuit breaker HİÇ bir başarısızlığı kaydetmeden ÖNCE, yapılandırılmış bir sayıda tekrar dener. Bu, gerçekten geçici sorunlar için önemli -- tek bir düşen paket, kısa bir ağ aksaklığı -- burada hemen tekrar denemek muhtemelen başarılı olurdu, ve ilk başarısızlıkta vazgeçmek erken olurdu.

> 💡 Tip
> Retry ve circuit breaker birbiriyle YARIŞAN seçenekler değil -- farklı sorulara cevap veriyorlar. Retry "bu TEK başarısızlık tekrar denemeye değer mi?" diye sorar; circuit breaker "bu servis o kadar TUTARLI başarısız oldu ki artık denemeye bile değmez mi?" diye sorar. İkisini de aynı çağrıya uygulamak (`ResilientStockClient`'ın yaptığı gibi) yaygın, mantıklı bir kombinasyon.

## Rate Limiter ve Bulkhead: İki Koruma Daha

Bir circuit breaker ve retry, ikisi de BAŞARISIZLIKLARA tepki verir. Bir rate limiter ve bir bulkhead ise tamamen farklı bir riske karşı korur: order-service'in her şey SAĞLIKLIYKEN bile inventory-service'i (ya da kendisini) aşırı yüklemesi. Bir rate limiter, bir zaman penceresinde kaç çağrıya izin verildiğini sınırlar; bir bulkhead ise aynı anda kaç çağrının UÇUŞTA olabileceğini sınırlar -- ikisi de isimlerini gerçek dünyadaki güvenlik mekanizmalarından ödünç alıyor (elektriksel bir akım sınırlayıcı, bir geminin su almış tek bir bölmenin tüm gemiyi batırmasını önleyen bulkhead bölmeleri).

{{RateLimiterAndBulkheadConfig.yml}}

{{CircuitBreakerEventListener.java}}

## Best Practices

- **Gerçekten geçici başarısız olabilecek çağrılarda `@Retry` ve `@CircuitBreaker`'ı BİRLİKTE uygula** -- retry kısa aksaklığı yönetir, circuit breaker sürekli başarısızlığı yönetir, ve her biri diğerinin cevaplamadığı bir soruyu cevaplar.
- **Her zaman ÇAĞIRAN için anlamlı bir fallback sağla**, yalnızca genel bir hata değil -- `checkStockFallback`'in "stok rezerve edilmediği varsayılsın"ı, order-service'in daha büyük akışının tamamen başarısız olmak yerine devam etmesine izin veriyor.
- **Circuit breaker/retry örneklerine ne koruduklarıyla temiz eşleşen isimler ver** -- burada `inventoryService`, ilgisiz çağrılar arasında paylaşılan genel bir isim değil.
- **Geliştirme sırasında durum geçişlerini logla (ya da metrik olarak sun)**, tıpkı `CircuitBreakerEventListener` gibi -- sessizce başarısız olan açık bir devreyi teşhis etmek zordur.

## Yaygın Hatalar

- **`@CircuitBreaker`/`@Retry` ile işaretli bir metodu AYNI sınıftaki başka bir metottan çağırmak.** Bu, Spring'in proxy'sini tamamen atlar -- iki annotation'ın da hiçbir etkisi olmaz (yukarıdaki uyarıya bakınız).
- **İmzası eşleşmeyen bir fallback metodu yazmak.** Orijinal metodun parametrelerini artı sonda bir `Throwable`'ı kabul etmeli, aksi halde Resilience4j onu bağlayamaz.
- **`wait-duration-in-open-state`'i çok kısa ayarlamak.** Devre, muhtemelen henüz toparlanmamış bir servise test çağrısını yeniden açar, servise nefes alma alanı verme amacını boşa çıkarır.
- **Bir bulkhead ya da rate limiter'ı bir circuit breaker'ın YERİNE kullanmak.** Bunlar FARKLI risklere karşı korur (aşırı yük vs. sürekli başarısızlık) -- gerçekten düşmüş bir servis hâlâ bir circuit breaker'a ihtiyaç duyar, hiçbir eşzamanlılık sınırlaması bunu düzeltmez.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Resilience4j, riskli bir çağrıyı annotation'larla uygulanan koruyucu davranışlarla sarar: `@CircuitBreaker` sürekli başarısız olan bir servisi çağırmayı durdurur (CLOSED -> OPEN -> HALF_OPEN -> CLOSED), `@Retry` geçici başarısız olan bir çağrıyı vazgeçmeden önce tekrar dener, ve rate limiter/bulkhead'ler servis sağlıklıyken bile aşırı yüke karşı korur. Bir fallback metodu, devre açık olduğunda ya da retry'lar tükendiğinde gerçek metodun yerine çalışır -- imzası artı sonda bir `Throwable` eşleşmeli. Bunların hepsi yalnızca Spring'in proxy mekanizması üzerinden çalışır, bu yüzden aynı sınıf içindeki self-invocation bunu tamamen atlar.

Hızlı referans:

```java
@CircuitBreaker(name = "inventoryService", fallbackMethod = "checkStockFallback")
@Retry(name = "inventoryService")
StockCheckResponse checkStock(String productName) { ... }

StockCheckResponse checkStockFallback(String productName, Throwable t) {
    return new StockCheckResponse(productName, 0);   // bozuk ama geçerli yanıt
}

// application.yml
// resilience4j.circuitbreaker.instances.inventoryService.failure-rate-threshold: 50
// resilience4j.retry.instances.inventoryService.max-attempts: 3
```

**Terimler Sözlüğü**

**Circuit Breaker** — Sürekli başarısız olan bir servisi çağırmayı durduran, CLOSED, OPEN ve HALF_OPEN durumları arasında dönen bir koruma.

**Retry** — Başarısız bir çağrıyı, vazgeçmeden önce yapılandırılmış bir sayıda otomatik olarak tekrar deneyen bir koruma.

**Rate Limiter** — Başarı/başarısızlıktan bağımsız olarak bir zaman penceresi içinde kaç çağrıya izin verildiğini sınırlayan bir koruma.

**Bulkhead** — Bir bağımlılığa aynı anda kaç çağrının uçuşta olabileceğini sınırlayan bir koruma.

**Fallback Metodu** — Bir devre açık olduğunda ya da retry'lar tükendiğinde Resilience4j'nin gerçek metot yerine çağırdığı metot.
