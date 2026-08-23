# Event-Driven Architecture ve Kafka

Bu kurstaki her servisler arası çağrı şimdiye kadar senkrondu: order-service inventory-service'i çağırıyor ve bir cevap için BEKLİYOR -- ister sabit kodlanmış bir URL'le, ister load-balanced bir RestClient'la, ister bir circuit breaker'la sarılmış olsun ("Servisler Arası İletişim", "Servis Keşfi ve Eureka" ve "Resilience4j" derslerine bakınız). Bu modelin içine gömülü bir şekli var -- çağıran, callee cevap verene kadar bloke olur, ve çağıranın tam olarak hangi servisi çağıracağını bilmesi gerekir. Bu ders temelde farklı bir şekli tanıtıyor: kimin dinlediğini bilmeden ya da umursamadan, zaten olmuş olan gerçekleri duyuran servisler.

## Event-Driven Architecture Nedir?

Event-driven (olay güdümlü) bir mimaride, bir servis bir OLAY YAYINLAR -- zaten olmuş bir şeyin kaydı ("bir sipariş verildi") -- herhangi belirli bir başka servise adreslemeden, bir mesaj broker'ına. Herhangi sayıda BAŞKA servis bu olaya abone olabilir ve kendi zamanlamasında, bağımsız olarak tepki verebilir. Yayıncı hiçbir zaman bir tepki bekleyerek bloke olmaz, ve genellikle hangi servislerin (varsa) dinlediğini bile bilmez.

## Neden Var?

Senkron çağrılar ZAMANDA SIKI bir bağlantı yaratır: inventory-service yavaşsa ya da düşükse, order-service'in isteği de yavaşlar ya da başarısız olur -- envanteri güncellemek sipariş veren çağıran için aslında acil olmasa bile. Senkron çağrılar ayrıca servisleri BİRBİRLERİNİ doğrudan bilmeye bağlar -- order-service'in inventory-service'in var olduğunu ve ona nasıl ulaşacağını bilmesi gerekir. Olaylar (event'ler) her iki bağlantıyı da kaldırır: order-service "bir sipariş verildi"yi yayınlar ve hemen devam eder; buna TEK bir servis tepki versin, ÜÇ tanesi versin, ya da altı ay sonra yeni bir tanesi eklensin, order-service'in kendi kodu hiç değişmez.

## Tarihçe

Kafka, LinkedIn'in ürettiği devasa hacimdeki aktivite verisini (tıklamalar, görüntülemeler, mesajlar) işlemek için 2011 civarında LinkedIn'de inşa edildi, ve kısa süre sonra Apache Software Foundation üzerinden açık kaynak yapıldı. Geleneksel bir mesaj kuyruğunun (tipik olarak bir mesaj tüketildiğinde silinir) aksine, Kafka kalıcı, yalnızca-ekleme (append-only) bir LOG etrafında inşa edilmiş -- mesajlar, kaç tüketici tarafından okunduğundan bağımsız olarak yapılandırılmış bir saklama süresi boyunca kalır -- bu, birden fazla, bağımsız servisin AYNI olay akışını, aynı mesajlar için rekabet etmeden tüketebilmesini sağlayan şey. Spring for Apache Kafka (`spring-kafka`), Kafka'nın kendi client kütüphanesini tanıdık Spring Boot konvansiyonlarıyla saran Spring projesi -- `@KafkaListener`, `@GetMapping`'e benzer bir rol oynuyor ("Bir Olayı Tüketmek: inventory-service Tepki Veriyor" bölümüne bakınız).

## Kafka'yı (Broker) ve Topic'leri Kurmak

eureka-server, api-gateway ya da config-server'ın aksine, Kafka bu kursta inşa edilen bir Spring Boot uygulaması DEĞİL -- ayrı bir altyapı, zaten çalıştığı varsayılıyor (yerel geliştirme için tek bir Kafka broker'ı). Bir TOPIC, üreticilerin yayınladığı ve tüketicilerin abone olduğu adlandırılmış bir olay kategorisidir (bu derste `order-events`); bir topic ayrıca PARTITION'lara bölünür, ve Kafka sırayı yalnızca TEK bir partition İÇİNDE garanti eder, topic'in tamamında değil.

{{KafkaProducerConfig.yml}}

> 💡 Tip
> `spring.kafka.bootstrap-servers`, order-service'in Kafka'yı bulmak için ihtiyaç duyduğu TEK bilgi -- burada bunun sabit bir adres olduğuna, Eureka üzerinden çözülmediğine dikkat edin ("Servis Keşfi ve Eureka" dersine bakınız) -- Kafka client'larının kendi broker-keşfi protokolü zaten var, bu yüzden broker'ın kendisi için servis keşfine, order-service'in inventory-service'i doğrudan çağırmasındaki gibi ihtiyaç yok.

## Bir Olay Yayınlamak: order-service OrderPlaced'i Yayınlıyor

`OrderPlacedEvent`, bilinçli, ayrı bir sözleşme tipi -- `StockCheckResponse`'un içsel bir modeli doğrudan yeniden kullanmak yerine ayrı olmasının arkasındaki AYNI gerekçe ("Servisler Arası İletişim" dersinin "Kendi Sözleşmen: StockCheckResponse Neden InventoryItem Değil?" bölümüne bakınız) burada da geçerli, yalnızca TERS yönde: order-service'in dış dünyaya söylediği bir gerçek, order-service'in aldığı bir cevap değil.

{{OrderPlacedEvent.java}}
{{OrderEventPublisher.java}}

`OrderService.create(...)` ("Mikroservis Yapılandırma" dersinin "Domain Modeli: Bu Serviste "Sipariş" Ne Demek?" bölümüne bakınız), yeni bir siparişi kaydettikten hemen sonra `publishOrderPlaced(...)`'ı çağırır -- order-service'in zaten senkron olarak yaptığı her şeyin YANINDA, YERİNE değil.

## Bir Olayı Tüketmek: inventory-service Tepki Veriyor

`@KafkaListener`, spring-kafka'nın `@GetMapping`'e karşılığı -- bu consumer group için topic'te yeni bir mesaj geldiğinde Spring, işaretlenmiş metodu otomatik olarak çağırır.

{{KafkaConsumerConfig.yml}}
{{InventoryEventListener.java}}

## Senkron vs Asenkron: Hangisi Ne Zaman Kullanılır?

Bu ders, "Servisler Arası İletişim" dersindeki senkron çağrıyı DEĞİŞTİRMİYOR -- ikisi de bir arada var oluyor, ve aralarında seçim yapmak sorulan SORUYA bağlı. "Bu ürün şu anda stokta mı, müşteriye hemen bir cevap gösterebileyim mi?" senkron bir çağrı gerektirir -- çağıran, KENDİ çağıranına cevap verebilmeden önce gerçekten bir cevaba ihtiyaç duyar. "Bir sipariş verildi, er ya da geç envanter kayıtlarını güncelle ve önemseyeni bilgilendir" hiç anlık bir cevaba ihtiyaç duymaz -- bir olay doğal olarak uyar, ve çağıran, yavaş olabilecek ya da geçici olarak düşük olabilecek bir servisi beklerken bloke olmaz.

## En Az Bir Kez Teslimat ve Idempotency

Kafka (bu dersin varsaydığı yaygın yapılandırmada) EN AZ BİR KEZ (at-least-once) teslimatı garanti eder -- bir tüketici AYNI olayı birden fazla kez görebilir, en sık bir mesajı işlemeyi bitirdiğini onaylamadan ("commit" etmeden) önce bir yeniden başlatmadan sonra. Bu, bir tüketicinin bir olayı işlemesinin IDEMPOTENT olması gerektiği anlamına gelir -- aynı olayı iki kez işlemek, bir kez işlemekle AYNI etkiye sahip olmalı.

> ⚠️ Warning
> `InventoryEventListener`'ın `processedOrderIds` koruması tam olarak bu idempotency kontrolü -- o olmadan, yeniden teslim edilen bir `OrderPlacedEvent`, zaten işlenmiş bir sipariş için envanteri İKİNCİ kez azaltır, stok sayılarını sessizce bozar. Bu, event-driven sistemlerde gerçek, yaygın bir hata modu, varsayımsal bir kenar durum değil.

## Serialization: Neden Tel Üzerinde JSON

`OrderPlacedEvent`, giderken (`JsonSerializer`) JSON'a, gelirken (`JsonDeserializer`) tekrar bir Java nesnesine serialize edilir -- bu kursun REST API'lerinin zaten kullandığı AYNI format, burada da aynı gerekçeyle seçildi: insan tarafından okunabilir, gelecekteki bir tüketicinin hangi dilde yazılmış olursa olsun çalışır, ve çalışan bir sistemde incelemek için ekstra bir araca ihtiyaç duymaz. (Production Kafka dağıtımları genellikle bunun yerine bir schema registry ile birlikte Avro gibi ikili bir format kullanır, bu okunabilirliğin bir kısmını daha küçük mesajlar ve üreticiler/tüketiciler arasında daha katı, zorunlu kılınan sözleşmelerle takas eder -- bu dersin kapsamı dışında.)

## Best Practices

- **Olayları, sıralamanın gerçekten neyi önemsediğini belirleyen bir id ile keyle** (burada `orderId`) -- AYNI varlıkla ilgili olaylar aynı partition'a düşer ve sırayla işlenir; FARKLI varlıklarla ilgili olayların buna ihtiyacı yok.
- **Her tüketiciyi idempotent yap**, yalnızca bu dersin `inventoryService`'ini değil -- en az bir kez teslimat Kafka geneli bir garanti, tek bir topic'e özgü bir şey değil.
- **Bir olayın şeklini, bir REST yanıtıyla aynı şekilde, herkese açık bir sözleşme olarak ele al** -- kontrolünde olmayan başka tüketiciler zaten `OrderPlacedEvent`'in tam alanlarına bağımlı olabilir.
- **Anlık bir cevaba ihtiyaç duymayan gerçekler için olaylara, ihtiyaç duyanlar için senkron çağrılara yönel** -- "Senkron vs Asenkron: Hangisi Ne Zaman Kullanılır?" bölümüne bakınız -- hiçbir yaklaşım diğerinin yerini her yerde almaz.

## Yaygın Hatalar

- **Idempotent OLMAYAN bir tüketici yazmak.** En az bir kez teslimat, yeniden teslimatın er ya da geç GERÇEKLEŞECEĞİ anlamına gelir -- bunu nadir bir kenar durum gibi ele almak, tasarlanması gereken bir kesinlik yerine, gerçek veri bozulmasına yol açar (yukarıdaki uyarıya bakınız).
- **Bir olayı yayınlayıp ondan senkron bir çağrının döndürdüğü gibi ANLIK bir cevap beklemek.** Olaylar, yayıncı tarafından fire-and-forget'tir -- gerçekten bir cevaba ihtiyaç varsa, doğru araç bir olay değil, senkron bir çağrıdır.
- **Tüketiciye o kadar çok mantık koymak ki gizli, belgelenmemiş bir bağımlılık haline gelsin.** `OrderPlacedEvent`'e tepki vermek kritik bir iş mantığıysa, o bağımlılık, kimsenin var olduğunu hatırlamadığı bir listener'a gömülmek yerine görünür ve anlaşılır olmalı.
- **Tek bir Kafka topic'inin ve partition'ının sonsuza kadar ölçekleneceğini varsaymak.** Sıralama garantileri yalnızca bir partition içinde geçerli -- bir topic'in, bir consumer group'un işlemi birden fazla örnek arasında GERÇEKTEN paralelleştirebilmesi için yeterli partition'a ihtiyacı var.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Event-driven mimari, bir servisin, kimin tepki verdiğini bilmeden ya da onu beklemeden, gerçekleri (olayları) bir mesaj broker'ına yayınlamasına izin verir -- bu, senkron çağrıların yarattığı hem zaman-bağlantısını hem doğrudan-bilgi-bağlantısını kaldırır. Kafka, olayları topic'lere ve partition'lara organize eder, sırayı yalnızca bir partition içinde garanti eder; `KafkaTemplate` yayınlar, `@KafkaListener` tüketir. Kafka'nın en az bir kez teslimatı, her tüketicinin idempotent olması gerektiği anlamına gelir. Olaylar ve senkron çağrılar farklı sorunları çözer ve aynı sistemde bir arada var olur -- hiçbiri diğerinin yerini almaz.

Hızlı referans:

```java
record OrderPlacedEvent(String orderId, String productName, int quantity) {}

// Yayınlamak
kafkaTemplate.send("order-events", orderId, event);   // key = orderId, AYNI
                                                        // siparişle ilgili
                                                        // olayları sırayla tutar

// Tüketmek
@KafkaListener(topics = "order-events", groupId = "inventory-service")
void onOrderPlaced(OrderPlacedEvent event) {
    if (!processedOrderIds.add(event.orderId())) return;   // idempotency koruması
    // ...
}
```

**Terimler Sözlüğü**

**Event (Olay)** — Zaten olmuş bir şeyin, belirli bir tüketiciye adreslenmeden yayınlanan kaydı.

**Topic** — Kafka'da üreticilerin yayınladığı, tüketicilerin abone olduğu adlandırılmış bir olay kategorisi.

**Partition** — Bir topic'in alt bölümü; Kafka mesaj sırasını yalnızca tek bir partition içinde garanti eder.

**Consumer Group** — Bir topic'in partition'larını işleme işini paylaşan, her olayın yalnızca bir üyesine teslim edildiği bir tüketici örnekleri kümesi.

**Idempotency** — Aynı olayı birden fazla kez işlemenin, tam olarak bir kez işlemekle aynı etkiye sahip olması özelliği.
