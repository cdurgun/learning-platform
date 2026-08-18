# Service Discovery ve Eureka

Microservices kategorisinin "wave 1"i (`microservices-fundamentals`, `spring-boot-microservice-basics`, `inter-service-communication`) `order-service`'in `inventory-service`'i BULMASI için sabit kodlanmış bir URL kullandı (`@Value("${services.inventory-service.url}")`, bkz. "Inter-Service Communication" dersinin "order-service'ten inventory-service'e: RestClient ile Senkron Çağrı" bölümü). Bu, İKİ sabit servis için gayet iyi çalışır -- ama gerçek dünyada servisler ÇOĞALIR (aynı servisin birden fazla kopyası, yük dengeleme için), TAŞINIR (konteynerler yeniden başladığında IP'ler değişir), ve ÖLÇEKLENİR. Bu ders, o probleme Java/Spring ekosisteminin klasik cevabını -- Service Discovery ve Netflix Eureka'yı -- tanıtıyor.

## Service Discovery Nedir?

Service Discovery (servis keşfi), servislerin birbirini SABİT bir adresle değil, bir İSİMLE bulmasını sağlayan bir desendir. Merkezinde bir KAYIT DEFTERİ (registry) vardır: her servis instance'ı başladığında kendini bu deftere KAYDEDER ("ben `inventory-service`'im, şu anda şu host:port'ta çalışıyorum"), ve bir servis başka bir servisi ÇAĞIRMAK istediğinde, sabit bir adres yerine deftere "`inventory-service` şu anda nerede?" diye SORAR.

## Neden Var?

`@Value` ile sabit kodlanmış bir URL, `inventory-service` TEK bir instance olarak TEK bir sabit adreste çalıştığı sürece sorunsuzdur. Ama gerçek üretim ortamlarında: (1) yük artışına karşı AYNI servisin BİRDEN FAZLA kopyası (instance) çalışır -- hangisine gidileceği sabit kodlanamaz; (2) konteynerler/bulut ortamları IP adreslerini SIK SIK değiştirir -- her yeniden başlatmada `application.yml`'i elle güncellemek pratik değildir; (3) yeni bir servis eklendiğinde, ONU çağıracak HER servisin yapılandırmasının güncellenmesi gerekir. Service Discovery, bu üç sorunu da TEK bir merkezi kayıt defteriyle çözer -- servisler birbirini İSİMLE bulur, sabit adresle değil.

## Tarihçe

Eureka, Netflix'in kendi devasa mikroservis altyapısı için 2012 civarında geliştirdiği ve açık kaynağa aktardığı bir servis keşif aracıdır (Netflix OSS'in bir parçası -- aynı dönemde Netflix, Hystrix/Ribbon gibi başka mikroservis araçlarını da açtı). Spring Cloud Netflix (2015), Eureka'yı Spring Boot uygulamalarına birkaç satır yapılandırmayla eklemeyi mümkün kıldı -- bu ders, tam olarak o entegrasyonu kullanıyor. Önemli bir dürüstlük notu: Netflix, kendi iç altyapısında Eureka 2.0'ı 2018 civarında DURDURDU ve artık kendi araçlarını kullanmıyor -- ama Eureka 1.x, Spring Cloud ekosisteminde hâlâ YAYGIN ŞEKİLDE kullanılıyor ve aktif olarak desteklenmeye devam ediyor. Kubernetes gibi platformların KENDİ yerleşik servis keşif mekanizması olduğu için, Kubernetes üzerinde çalışan projelerde Eureka genellikle GEREKMEZ -- Eureka en çok, Kubernetes'in dışında (VM'lerde, klasik sunucularda) çalışan Spring uygulamaları için değerlidir.

## Eureka Server: Merkezi Kayıt Defteri

Eureka Server, `order-service`/`inventory-service`'ten TAMAMEN ayrı, kendi başına çalışan BAĞIMSIZ bir Spring Boot uygulamasıdır -- ne bir iş kuralı içerir, ne bir veritabanına bağlanır. Tek görevi: hangi servislerin kayıtlı olduğunu ve hangi adreste çalıştıklarını bilmektir. `@EnableEurekaServer` ONU Eureka Server yapan TEK anotasyondur.

{{EurekaServerApplication.java}}
{{EurekaServerConfig.yml}}

> 💡 Tip
> `register-with-eureka: false` ve `fetch-registry: false`, Eureka Server'ın KENDİ KENDİNE bir client gibi davranmasını ENGELLER -- tek düğümlü (single-node) bir kurulumda sunucu, kendini kaydedecek ya da kendi kayıt defterini "fetch" edecek başka bir sunucuya ihtiyaç duymaz. (Üretimde birden fazla Eureka Server düğümü birbirini replike edebilir -- bu durumda bu ayarlar `true` olurdu, ama bu ders tek düğümlü kuruluma odaklanıyor.)

## Eureka Client: Servisleri Kaydetmek

`order-service` ve `inventory-service`, `spring-cloud-starter-netflix-eureka-client` bağımlılığını ekleyip `application.yml`'lerine Eureka Server'ın adresini (`eureka.client.service-url.defaultZone`) yazarak Eureka CLIENT'ına dönüşür. Kritik bir nokta: `spring.application.name` (bkz. "Spring Boot Microservice Basics" dersinin "Kendi `application.yml`'i: Port, Uygulama Adı ve Veritabanı" bölümü) ARTIK yalnızca loglarda görünen bir isim DEĞİL -- bu, diğer servislerin ONU bulmak için kullanacağı GERÇEK anahtardır.

{{OrderServiceEurekaConfig.yml}}

## Servisleri Dinamik Olarak Keşfetmek: DiscoveryClient

`DiscoveryClient`, kayıt defterine DOĞRUDAN soru sormanın düşük seviyeli yoludur -- "şu anda `inventory-service` adı altında hangi instance'lar kayıtlı?" `Spring Cloud`'un Eureka client bağımlılığı, hiçbir ekstra yapılandırma olmadan bir `DiscoveryClient` bean'ini OTOMATİK olarak sağlar.

{{DiscoveryClientExample.java}}

> 💡 Tip
> `DiscoveryClient`, günlük servisler arası çağrılar için DOĞRU araç DEĞİLDİR -- asıl kullanım alanı teşhis (diagnostics) ve kayıt defterinin o an ne gördüğünü anlamaktır. Servisler arası GERÇEK çağrılar için "Load-Balanced RestClient ile İsimle Çağrı Yapmak" bölümündeki yaklaşım kullanılmalıdır.

## Load-Balanced RestClient ile İsimle Çağrı Yapmak

`@LoadBalanced` anotasyonu, bir `RestClient.Builder` bean'ini KAYIT DEFTERİNDEN HABERDAR hâle getirir -- bu builder'dan oluşturulan bir `RestClient`, `http://inventory-service` gibi bir "adresi" GERÇEK bir host adı olarak DEĞİL, bir SERVİS İSMİ olarak yorumlar; Spring Cloud LoadBalancer bu çağrıyı YAKALAYIP `DiscoveryClient`'a sorar ve o an kayıtlı instance'lardan BİRİNİ seçer.

{{LoadBalancedRestClientConfig.java}}

Bu, "Inter-Service Communication" dersindeki `StockClient`'ın sabit kodlanmış `@Value` URL'sinin YERİNİ alıyor -- geri kalan TÜM mantık (404 ile bağlantı hatasının ayrıştırılması, `InventoryServiceUnavailableException`'a çevrilmesi) DEĞİŞMİYOR:

{{StockClientWithDiscovery.java}}
{{StockCheckResponse.java}}

> ⚠️ Warning
> `inventory-service`'in birden fazla instance'ı çalışırken, `@LoadBalanced RestClient` HANGİ instance'a gideceğini SİZİN İÇİN seçer -- bu seçim, `StockClientWithDiscovery`'nin KENDİSİNDE tek bir satır bile değiştirmeden gerçekleşir. Load balancing'in kendisi, Eureka'nın DEĞİL, Spring Cloud LoadBalancer'ın işidir -- Eureka yalnızca HANGİ instance'ların var olduğunu SÖYLER, aralarında SEÇİM yapmaz.

## Heartbeat, Eviction ve Self-Preservation Modu

Bir Eureka client, kayıtlı KALMAK için Eureka Server'a düzenli aralıklarla (varsayılan 30 saniye) bir "heartbeat" (kalp atışı) gönderir -- buna "lease renewal" (kira yenileme) denir. Bir client belirli bir süre (varsayılan 90 saniye) boyunca heartbeat GÖNDEREMEZSE, Eureka Server onu kayıt defterinden SİLER ("eviction"). Ama BURADA ilginç bir davranış var: eğer Eureka Server ÇOK SAYIDA client'ın AYNI ANDA heartbeat göndermeyi kestiğini görürse (beklenen heartbeat oranının belirgin şekilde altına düşerse), bunu "birden fazla servis GERÇEKTEN aynı anda çöktü" olarak DEĞİL, "muhtemelen BENİM ağ bağlantım/kendi durumum sorunlu" olarak YORUMLAR -- ve "self-preservation mode"a (kendini koruma modu) girip HİÇBİR instance'ı SİLMEYİ durdurur.

> ⚠️ Warning
> Self-preservation modu, özellikle YEREL geliştirme ortamlarında (tek makinede birkaç servis çalıştırılırken) KAFA KARIŞTIRICI olabilir -- bir servisi kapatsanız bile, Eureka Server onu bir süre (bazen dakikalarca) "kayıtlı" gibi GÖSTERMEYE devam edebilir. Bu bir hata DEĞİLDİR -- Eureka'nın, bir ağ bölünmesi sırasında SAĞLIKLI instance'ları YANLIŞLIKLA silmemek için bilinçli bir tasarım kararıdır.

## Eureka'nın CAP Teoremindeki Yeri: AP Sistemi

"Microservices Fundamentals" dersindeki CAP Teoremine Kısa Bir Bakış bölümünü hatırlayın: dağıtık bir sistem, bir ağ bölünmesi (network partition) sırasında Tutarlılık (Consistency) ile Erişilebilirlik (Availability) arasında SEÇİM yapmak zorundadır. Eureka bilinçli olarak AP tarafını seçer: her Eureka Server düğümü, EN GÜNCEL bilgiye sahip olmayı garanti etmek yerine, HER ZAMAN bir cevap vermeyi (kısmen eski bir kayıt defteriyle bile olsa) tercih eder. Self-preservation modu da bu felsefenin bir SONUCUdur -- Eureka, "belki birkaç kayıt eski" riskini, "sağlıklı servisleri yanlışlıkla sil" riskine TERCİH eder.

## Best Practices

- **Servisler arası çağrılarda sabit kodlanmış host:port yerine servis İSMİYLE (`@LoadBalanced RestClient` ile) çağrı yapın** -- yatay ölçeklendirme ve IP değişiklikleri kod DEĞİŞİKLİĞİ gerektirmez.
- **`DiscoveryClient`'ı yalnızca teşhis/gözlemleme amaçlı kullanın**, günlük servisler arası çağrılar için DEĞİL -- `@LoadBalanced RestClient` bu işi zaten SİZİN İÇİN yapar.
- **Yerel geliştirmede self-preservation modunun KAFA KARIŞTIRICI davranışını (kapatılan servisin bir süre "kayıtlı" görünmesi) BEKLEYİN** -- bu bir hata değil, Eureka'nın AP tasarımının doğal bir sonucudur.
- **Eureka Server'ın kendisini de bir `spring.application.name` ile adlandırın**, kayıt defterinde görünmese bile -- loglar ve gelecekteki gözlemlenebilirlik (observability) araçları için tutarlılık sağlar.

## Yaygın Hatalar

- **Eureka Server'ın `application.yml`'inde `register-with-eureka`/`fetch-registry`'yi `true` bırakmak.** Tek düğümlü bir kurulumda sunucu, kendi kendine bağlanmaya çalışıp gereksiz hatalar/loglar üretir.
- **`DiscoveryClient`'ı doğrudan servisler arası iş mantığında (business logic) kullanmak.** Bu, yük dengeleme mantığını elle yeniden yazmak anlamına gelir -- `@LoadBalanced RestClient` zaten bunu sağlar.
- **Bir servisi kapatıp Eureka'nın kayıt defterinden ANINDA silmesini beklemek.** Eviction, heartbeat zaman aşımına (varsayılan 90 saniye) ve self-preservation moduna bağlıdır -- anlık değildir.
- **Eureka'yı Kubernetes gibi kendi servis keşfi olan bir platformda GEREKSİZ yere kullanmak.** Kubernetes'in kendi Service/DNS mekanizması varken Eureka fazladan bir karmaşıklık katmanı ekler.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Service Discovery, servislerin birbirini sabit bir adresle değil bir İSİMLE bulmasını sağlayan bir desendir. Eureka Server, `@EnableEurekaServer` ile açılan merkezi bir kayıt defteridir; her Eureka Client (`order-service`, `inventory-service`) kendini bu deftere kaydeder ve düzenli heartbeat'lerle kayıtlı kalır. `DiscoveryClient` düşük seviyeli, doğrudan sorgulama sağlar; `@LoadBalanced RestClient` ise günlük servisler arası çağrılar için idiomatik yoldur -- bir servis ismini otomatik olarak gerçek bir host:port'a çevirir. Eureka, CAP teoreminin AP tarafını seçer -- self-preservation modu bunun bir sonucudur.

Hızlı referans:

```java
@SpringBootApplication
@EnableEurekaServer                          // Eureka Server -- ayrı bir uygulama
public class EurekaServerApplication { ... }

// eureka-server/application.yml
// eureka.client.register-with-eureka: false
// eureka.client.fetch-registry: false

// order-service/application.yml
// eureka.client.service-url.defaultZone: http://localhost:8761/eureka/

@Bean
@LoadBalanced                                   // isimle çağrı yapmayı etkinleştirir
RestClient.Builder loadBalancedRestClientBuilder() {
    return RestClient.builder();
}

restClient.get().uri("http://inventory-service/inventory/{name}", name)  // İSİM, host:port değil
```

**Terimler Sözlüğü**

**Service Discovery** — Servislerin birbirini sabit bir adres yerine bir isimle bulmasını sağlayan desen.

**Eureka Server** — Hangi servislerin kayıtlı olduğunu ve nerede çalıştığını bilen, `@EnableEurekaServer` ile açılan merkezi kayıt defteri.

**Eureka Client** — Kendini Eureka Server'a kaydeden ve diğer servisleri onun üzerinden bulan bir mikroservis.

**DiscoveryClient** — Kayıt defterine düşük seviyeli, doğrudan sorgu yapmayı sağlayan Spring Cloud arayüzü.

**Self-Preservation Mode** — Eureka Server'ın, çok sayıda heartbeat kaybını gerçek bir servis çöküşü yerine kendi ağ sorunu olarak yorumlayıp instance silmeyi durdurduğu koruma modu.
