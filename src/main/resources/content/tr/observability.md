# Observability

Bu kategorideki birkaç önceki ders bilinçli olarak bitirilmemiş bir iplik bıraktı. API Gateway dersinin `CorrelationIdGatewayFilter`'ı bir correlation id atadı ama açıkça "onu order-service ile inventory-service arasındaki giden çağrılara GERÇEKTEN aktarmak... yakında gelecek Observability dersinin konusu" dedi. Resilience4j dersinin `CircuitBreakerEventListener`'ı durum geçişlerini logladı, ama bunu "Observability dersinin ilerde kapsayacağı metrik/dashboard'ların gerçek bir öncüsü" olarak adlandırdı. Bu ders her iki ipliği de birbirine bağlıyor, ve bağımsız dağıtılmış bir servisler bütününü dışarıdan gerçekten anlaşılır kılan pratiği tanıtıyor.

## Observability Nedir?

Observability, çalışan bir sistemin İÇİNDE ne olduğunu, dışarıdan ürettiklerini -- log'larını, metriklerini ve trace'lerini -- inceleyerek anlama yeteneğidir, bir debugger bağlamaya ya da tahmin etmeye gerek kalmadan. Tek bir uygulamada, "ne yanlış gidiyor" genellikle tek bir konsoldaki bir stack trace'i okumak anlamına gelir. Birçok servisten oluşan bir sistemde, aynı soru, birçok FARKLI servisin log'ları ve dashboard'ları arasına dağılmış bilgiyi ilişkilendirmek anlamına gelir -- observability araçlarının var olma amacı tam olarak bunu pratik hale getirmek.

## Neden Var?

Bu kurs "Distributed Transactions" dersine geldiğinde, tek bir iş operasyonu (bir sipariş vermek) order-service'in veritabanına, bir Kafka topic'ine, ve inventory-service'in veritabanına, tamamen asenkron olarak dokunabiliyordu. Bir şeyler ters giderse -- bir sipariş sessizce hiç onaylanmazsa -- artık bakılacak tek bir stack trace yok. Paylaşılan bir correlation id, structured log'lar ve metrikler olmadan, o başarısızlığı teşhis etmek, kaç servis işin içindeyse, hangi servisin log'larına ne zaman bakılacağını elle tahmin etmek anlamına gelir. Observability bu tahmin oyununu bir sorguya dönüştürür.

## Tarihçe

Kontrol teorisinden ödünç alınan "observability" terimi (bir sistemin iç durumu dış çıktılarından çıkarılabiliyorsa o sistem observable'dır), yazılımda özellikle mikroservis benimsemesinin 2010'lar boyunca büyümesiyle popülerleşti -- monolit-dönemi araçları (tek uygulama, tek log dosyası, debugger bağlanacak tek bir süreç) birçok bağımsız dağıtılmış servisten oluşan sistemlere basitçe ölçeklenmiyordu. Bu dersin kullandığı metrik facade'i Micrometer, Spring Boot'a vendor-nötr bir metrik API'si vermek için özel olarak 2018'de yaratıldı (SLF4J'in loglama implementasyonlarıyla olan ilişkisiyle aynı) -- Spring Boot Actuator o zamandan beri metrik temeli olarak onu kullanıyor.

## Üç Sütun: Log'lar, Metrikler ve Trace'ler

Observability yaygın olarak üç tamamlayıcı veri türüne dayandığı şeklinde tanımlanır. LOG'lar, ayrık, zaman damgalı olaylardır, genellikle düz metin ya da yapılandırılmış alanlar -- tek bir zaman noktasında tam olarak ne olduğunu anlamak için iyi. METRİKLER, zaman içinde toplanan sayısal ölçümlerdir (bir sayaç, bir gauge, bir zamanlama histogramı) -- eğilimleri fark etmek ve alarm kurmak için iyi, ama herhangi TEK bir istek hakkında bilgi vermezler. TRACE'ler, TEK bir isteği birden fazla servis boyunca izler -- "BU belirli istek zamanını nerede geçirdi, ve hangi serviste başarısız oldu" sorusuna cevap vermek için iyi. Bu ders üçünü de, tek bir paylaşılan correlation id ile bağlanmış olarak inşa ediyor.

## Correlation Id'yi Yaymak: Gateway'in Başlattığını Bitirmek

`CorrelationIdGatewayFilter` (API Gateway dersine bakınız), order-service'e bir istek ulaşmadan önce bir `X-Correlation-Id` header'ı zaten atıyor -- ama bu header'ın AYARLANMIŞ olması, order-service'in kendi kodunu, log'larını ya da giden çağrılarını otomatik olarak bunun farkında yapmıyor. İki parça bu boşluğu kapatıyor.

{{CorrelationIdMdcFilter.java}}
{{RestClientCorrelationIdInterceptor.java}}

> 💡 Tip
> `CorrelationIdMdcFilter`, api-gateway'in her isteğin önünde olmasını gerektirmek yerine, header hiç yoksa KENDİ id'sini üretir -- bu, order-service yerel geliştirme sırasında doğrudan çağrıldığında bile kendi log'larını izlenebilir tutar.

## Structured Logging: Log'ları Makine Tarafından Okunabilir Yapmak

Düz metin bir log satırı, TEK bir servisin kendi konsolunda bir insan için okunması kolay, ama bir kez birçok servisin log'u tek bir yerde toplanınca güvenilir bir şekilde aramak zor. Structured (JSON) loglama, correlation id de dahil her alanı -- şu anda MDC'de oturan -- düz metin yerine sorgulanabilir bir alana dönüştürür.

{{LogbackJsonConfig.xml}}

## Micrometer ve Actuator ile Metrikler

Micrometer, Spring Boot Actuator'ın üzerine inşa edildiği metrik facade'i -- SLF4J'in bir loglama implementasyonuyla olan ilişkisiyle aynı. `spring-boot-starter-actuator` classpath'te olduğu anda bir `MeterRegistry` bean'i otomatik olarak yapılandırılır.

{{ActuatorMetricsConfig.yml}}
{{OrderMetrics.java}}

## Distributed Tracing: Tek Bir İsteği Servisler Boyunca İzlemek

Bir trace, tek bir kaynak istekten kaynaklanan her span'ı (bir servisin bir isteği ele almadaki katkısı) birbirine bağlar, bir dashboard'un order-service'in inventory-service'i çağırmadan önce ne kadar zaman harcadığını, ve inventory-service'in cevap vermesinin ne kadar sürdüğünü tam olarak göstermesini sağlar. Micrometer Tracing (Zipkin gibi, trace'leri gerçekten saklayan ve görselleştiren bir tracing backend'iyle eşleştirilmiş), bunu bu dersin zaten kurduğu AYNI correlation id kavramı üzerine inşa eder -- bir trace id, `X-Correlation-Id`'nin oynadığı AYNI bağlayıcı rolü oynar, aynı servis sınırları boyunca aynı şekilde yayılır.

> ⚠️ Warning
> Gerçek bir tracing backend'i (Zipkin, ya da barındırılan bir eşdeğeri) kurmak production'da gerçekten faydalı, ama bunu sıfırdan inşa etmek bu dersin kapsamı dışında -- yukarıdaki correlation id altyapısı bu kursun örneklerine zaten çalışan, aranabilir bir iz veriyor, özel bir tracing backend'i eklemeden önce başlamak için çoğu zaman yeterli.

## Resilience4j'nin Zaten İzlediğini Ortaya Çıkarmak

`CircuitBreakerEventListener` (Resilience4j dersine bakınız), durum geçişlerini elle logladı -- ama Resilience4j, ikisi de classpath'teyken Micrometer'la zaten otomatik olarak entegre olur, circuit breaker durumunu, çağrı sayılarını ve başarısızlık oranlarını HİÇBİR ek kod olmadan metrik olarak ortaya çıkarır. Elle yazılan listener, geliştirme sırasında anlık, insan tarafından okunabilir log satırları için hâlâ faydalı; Micrometer entegrasyonu, gerçek bir dashboard ya da alarm'ın production'da gerçekten izleyeceği şey.

## Best Practices

- **Correlation id'yi HER servis sınırında yay**, yalnızca bu dersin inşa ettiği sınırlarda değil -- zincirdeki herhangi bir yerde kırık bir bağlantı, o noktadan sonra tüm trace'i işe yaramaz kılar.
- **Her metriği onu üreten servisle etiketle** (`ActuatorMetricsConfig.yml`'nin `management.metrics.tags.application`'ına bakınız) -- birçok servisten gelen metrikler tek bir dashboard'a inince zorunlu.
- **Var olduğunda bir kütüphanenin yerleşik metrik entegrasyonunu (Resilience4j'ninki gibi) elle yazılmış loglamaya tercih et** -- "Resilience4j'nin Zaten İzlediğini Ortaya Çıkarmak" bölümüne bakınız.
- **Log'ları, metrikleri ve trace'leri birbirini TAMAMLAYAN, birbirinin YERİNE geçmeyen şeyler olarak ele al** -- sorulan spesifik soruya cevap vereni seç ("Üç Sütun"a bakınız).

## Yaygın Hatalar

- **İstek bittikten sonra MDC'yi temizlemeyi unutmak.** Bir servlet container thread'leri istekler arasında yeniden kullanır -- `CorrelationIdMdcFilter`'daki `finally` bloğu olmadan, bir isteğin correlation id'si tamamen ilgisiz, sonraki bir isteğin log'larına sızar.
- **Correlation id'yi gateway'de atayıp ilk servisin ötesine hiç yaymamak.** `RestClientCorrelationIdInterceptor` olmadan, inventory-service sessizce KENDİ id'sini üretir, trace'i tam da en çok ihtiyaç duyulan noktada kırar.
- **Metrikleri log'ların, ya da tam tersini, yerine geçen bir şey gibi ele almak.** Bir metrik bir başarısızlık oranının arttığını söyler; bir log neyin gerçekten başarısız olduğunu ve nedenini söyler -- hiçbiri diğerinin sorusunu cevaplamaz.
- **Observability'yi baştan tutarlı bir desen yerine, servis servis, sonradan akla gelen bir şey olarak eklemek.** Üç serviste yayılan ama dördüncüde eksik olan bir correlation id, o dördüncü servise dokunan her trace'i kırar.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Observability, çalışan bir sistemi, bir debugger bağlamadan, log'larından, metriklerinden ve trace'lerinden anlamak demektir. `CorrelationIdMdcFilter` ve `RestClientCorrelationIdInterceptor`, api-gateway'in atamaya başladığı correlation id'yi yaymayı bitirir, onu structured (JSON) log'larda, ve er ya da geç distributed trace'lerde kullanılabilir yapar. Actuator üzerinden otomatik yapılandırılan Micrometer, hem özel (`OrderMetrics`) hem de kütüphanelerin zaten bedavaya ürettiği (Resilience4j'nin circuit breaker metrikleri) metrikleri sağlar. Üç sütun farklı sorulara cevap verir ve birbirinin yerini almak yerine birbirini tamamlamak için tasarlanmıştır.

Hızlı referans:

```java
// Correlation id'yi yaymak
MDC.put("correlationId", correlationId);           // bu thread'deki her log
                                                     // satırında kullanılabilir yapar
request.getHeaders().add("X-Correlation-Id", MDC.get("correlationId"));  // bir
                                                     // sonraki servise iletir

// Özel bir metrik
Counter.builder("orders.placed")
    .register(meterRegistry)
    .increment();
```

**Terimler Sözlüğü**

**Observability** — Çalışan bir sistemin iç durumunu dış çıktılarından (log'lar, metrikler, trace'ler) anlama yeteneği.

**MDC (Mapped Diagnostic Context)** — SLF4J'in, bağlamsal verinin (bir correlation id gibi) o thread'deki her log satırına otomatik olarak dahil edilmesini sağlayan thread-local map'i.

**Structured Logging** — Düz metin yerine makine tarafından ayrıştırılabilir bir formatta (tipik olarak JSON) loglama, böylece tek tek alanlar sorgulanabilir olur.

**Micrometer** — Spring Boot Actuator'ın üzerine inşa edildiği, vendor-nötr metrik facade'i.

**Trace** — Tek bir kaynak istekten kaynaklanan, birden fazla servis boyunca bağlı span kümesi.
