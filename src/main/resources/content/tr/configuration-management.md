# Configuration Management

Bu kurstaki her servis kendi yapılandırmasını kendi `application.yml`'inde tuttu -- order-service'in port ve datasource ayarları ("Mikroservis Yapılandırma" dersinin "Kendi `application.yml`'i: Port, Uygulama Adı ve Veritabanı" bölümüne bakınız), Eureka client ayarları ("Servis Keşfi ve Eureka" dersine bakınız), ve şimdi Resilience4j örnekleri ("Resilience4j" dersine bakınız). Bu, birkaç servis için gayet iyi -- ama yirmi servisin AYNI datasource pool-size ayarına ihtiyaç duyduğunu, ya da bir değerin HEPSİNDE AYNI ANDA değişmesi gerektiğini hayal edin. Aynı bloğu yirmi `application.yml` dosyasına kopyala-yapıştır yapmak, ve değiştiğinde yirmisini de düzenlemek, ölçeklenmiyor. Bu ders, yapılandırmayı bunun yerine merkezileştiren parçayı tanıtıyor: Spring Cloud Config.

## Configuration Management Nedir?

Mikroservis anlamında yapılandırma yönetimi, yapılandırmayı onu kullanan uygulamaların İÇİNDE değil, her servisin kendi paketlenmiş kodunda tekrarlamak yerine, TEK bir merkezi yerde tutmaktır. Bir Config Server, kendisinden isimle isteyen HERHANGİ bir servise, başlangıçta (ve bu dersin göreceği gibi bazen yeniden başlatmaya bile gerek kalmadan) yapılandırmayı AĞ üzerinden sunar.

## Neden Var?

Birçok serviste tekrarlanan yapılandırma iki gerçek sorun yaratır: birincisi, gerçekten PAYLAŞILAN bir değerin (bir bağlantı havuzu boyutu, bir feature flag, üçüncü taraf bir API'nin base URL'i) her serviste kendi dosyasında ayrı ayrı güncellenmesi gerekir -- birini atlamak kolay, ve her servis, kodunu hiç etkilemeyen bir değeri almak için kendi yeniden deploy'unu ister. İkincisi, bazı yapılandırmaların ortama göre FARKLI olması gerekir (staging'de bir veritabanı URL'i, production'da başka) -- her biri için tüm dosyayı çoğaltmadan. Yapılandırmayı tek bir sunucuda merkezileştirmek, ortam bazlı override desteğiyle ("Profiller: Farklı Ortamlar İçin Farklı Yapılandırma" bölümüne bakınız), her ikisini de çözer.

## Tarihçe

Spring Cloud Config, Eureka ve Zuul'la (bkz. "Servis Keşfi ve Eureka" ve "API Gateway" derslerinin "Tarihçe" bölümleri) yaklaşık 2015'te birlikte yayınlanan, Spring ekosistemine getirilen aynı Netflix-OSS-ilhamlı araç dalgasının bir parçası, orijinal Spring Cloud projelerinden biriydi. Eureka'nın aksine, hiçbir Netflix kütüphanesi üzerine kurulu değil -- her dağıtık sistemin er ya da geç karşılaştığı bir soruna Spring-native bir cevap, ve bugün hâlâ Spring Cloud içinde aktif olarak bakımı yapılıyor.

## Config Server'ı Kurmak

config-server, eureka-server gibi, KENDİ BAŞINA bağımsız bir Spring Boot uygulaması -- bu kursta order-service, inventory-service, eureka-server ve api-gateway'in yanında beşincisi.

{{ConfigServerApplication.java}}
{{ConfigServerConfig.yml}}

> 💡 Tip
> Bu ders, örneği kendi içinde tam (self-contained) tutmak için Config Server'ın bir Git deposu yerine "native" backend'ini (yerel bir dosya sistemi/classpath dizini) kullanıyor -- production'da, `spring.cloud.config.server.git.uri`'nin gerçek bir Git deposuna işaret etmesi çok daha yaygın, çünkü yapılandırma değişikliklerine kodla aynı sürüm geçmişini ve review sürecini kazandırır.

## Config Repository: Yapılandırma Aslında Nerede Yaşıyor?

Gerçek yapılandırma değerleri -- servis başına bir YAML dosyası, o servisin `spring.application.name`'iyle eşleşecek şekilde adlandırılmış -- herhangi bir servisin kendi paketlenmiş kodundan tamamen ayrı, Config Repository'de yaşar.

{{OrderServiceExternalConfig.yml}}

Bu dosyanın yalnızca gerçekten MERKEZİLEŞTİRMEYE değer olanı içerdiğine dikkat edin -- `server.port` ve `spring.application.name` order-service'in kendi yerel `application.yml`'inde kalır, çünkü bir servisin Config Server'a herhangi bir şey İSTEMEDEN önce kendi kimliğini ve portunu bilmesi gerekir.

## order-service'i Bir Config Client Yapmak

order-service'in MEVCUT `application.yml`'ine eklenen tek bir özellik, onu başlangıçta config-server'dan yapılandırma çekip birleştirir hale getiren şey.

{{OrderServiceConfigClientConfig.yml}}

## Profiller: Farklı Ortamlar İçin Farklı Yapılandırma

Bir Config Repository dosyası PROFİL'e göre daha da bölünebilir -- `order-service-staging.yml` ve `order-service-production.yml`, yukarıdaki temel `order-service.yml`'in yanında, order-service hangi profille başlatıldığına bağlı olarak (örneğin `spring.profiles.active=staging`) onu override eder ya da ona ekleme yapar. Bu, Spring Boot'un yerelde zaten kullandığı AYNI profil mekanizması (bu projenin kendi `application-dev.yml`/`application-prod.yml` deseni, `application-dev.yml`'in `application.yml`'i override etmesi, tanıdık geliyorsa) -- Config Server bunu yalnızca yerel dosyalar yerine merkezi barındırılan dosyalara uyguluyor.

## Yeniden Başlatmadan Yapılandırmayı Yenilemek: @RefreshScope

Varsayılan olarak, `@Value` ile enjekte edilen bir özellik yalnızca BİR KEZ, Spring bean'i oluştururken okunur -- bir Config Repository dosyasını sonradan düzenlemenin zaten çalışan bir servis üzerinde HİÇBİR etkisi olmaz. `@RefreshScope` bunu değiştirir: bir refresh tetiklendiğinde (o servisin kendi `/actuator/refresh` endpoint'ine bir `POST`), bean'in atılıp yeniden oluşturulmasına, `@Value`'larını yeniden okumasına izin verir.

{{RefreshableGreetingController.java}}

> ⚠️ Warning
> Tek bir `/actuator/refresh` çağrısı yalnızca ÇAĞRILDIĞI TEK servisi yeniler -- birçok servisle, hepsini elle tetiklemek, dosyaları elle düzenlemekten çok daha iyi ölçeklenmez. Spring Cloud Bus (bir refresh olayını paylaşılan bir message broker üzerinden tüm servislere BİRDEN yayınlamak) bunu çözer, ama bu dersin kapsamı dışında -- bir sistemde birkaçtan fazla servis olduğunda var olduğunu bilmekte fayda var.

## Sırlar (Secrets): Config Server'ın Düz Metin Olarak SAKLAMAMASI Gerekenler

Her şey bir Config Repository dosyasına düz metin olarak ait değil -- bir veritabanı şifresi, ortama göre değiştiği anlamda bir yapılandırmadır, ama onu şifrelenmemiş bir dosyada (özel bir Git deposunda bile) saklamak gerçek bir güvenlik riski. Spring Cloud Config tek tek değerleri şifrelemeyi destekler, ve özel sır (secret) araçları (en yaygın eşleşme HashiCorp Vault) tam olarak bunun için var -- bu ders, gerçekten hassas değer için `${ORDERS_DB_PASSWORD}`'ü ("Mikroservis Yapılandırma" dersine bakınız) bir ortam değişkeni olarak kullanmaya devam ediyor, ve yalnızca sır OLMAYAN yapılandırmayı merkezileştiriyor.

## Best Practices

- **Gerçekten PAYLAŞILAN ya da koddan bağımsız değişen değerleri merkezileştir** (havuz boyutları, feature flag'ler, üçüncü taraf URL'leri) -- bir servisin kendi kimliğini (port, uygulama adı) kendi yerel `application.yml`'inde bırak.
- **Ortama özgü override'lar için profilleri kullan**, elle neredeyse birebir aynı ayrı dosyalar tutmak yerine.
- **Canlı güncellemeye ihtiyaç duyan bean'leri BİLİNÇLİ OLARAK `@RefreshScope` ile işaretle, HER YERE değil** -- refresh yapmanın gerçek bir maliyeti var (bean yeniden oluşturma), ve çoğu bean buna hiç ihtiyaç duymaz.
- **Sırları hiçbir zaman bir Config Repository dosyasına düz metin olarak koyma** -- şifreleme ya da özel bir sır aracı kullan, tıpkı bu dersin `ORDERS_DB_PASSWORD`'ü merkezileştirmek yerine bir ortam değişkeni olarak tutmaya devam etmesi gibi.

## Yaygın Hatalar

- **`server.port` ya da `spring.application.name`'i merkezileştirmek.** Bir servisin, Config Server'a herhangi bir şey İSTEMEDEN önce, ikisine de YEREL olarak ihtiyacı var.
- **Bir Config Repository dosyasını düzenleyip çalışan bir servisin bunu HEMEN almasını beklemek.** `@RefreshScope` ve açık bir refresh çağrısı (ya da Spring Cloud Bus) olmadan, bir sonraki yeniden başlatmaya kadar hiçbir şey değişmez.
- **Bir veritabanı şifresini ya da API anahtarını bir Config Repository dosyasına düz metin olarak saklamak.** Özel bir depoda bile olsa, bu gerçek bir kimlik bilgisi sızıntısı bekliyor demek -- yukarıdaki "Sırlar" bölümüne bakınız.
- **`@RefreshScope`'u "ne olur ne olmaz" diye her bean'e uygulamak.** Bean oluşturmaya gerçek bir ek yük bindirir ve pratikte çalışma zamanında hiç değişmeyen bean'ler için bir bean'in yaşam döngüsü hakkında düşünmeyi karmaşıklaştırır.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Configuration management, yapılandırmayı onu kullanan servislerin DIŞINDA merkezileştirir. Spring Cloud Config'in Config Server'ı (`@EnableConfigServer`), servis başına YAML dosyalarını bir Config Repository'den (production'da bir Git deposu, burada yerel bir dizin) sunar; bir servis, tek bir `spring.config.import` özelliğiyle bir Config Client'a dönüşür. Profiller, bir Config Repository dosyasının ortam başına override edilmesine izin verir -- bu projenin kendi `application-dev.yml`/`application-prod.yml`'inin yerelde zaten çalıştığı AYNI şekilde. `@RefreshScope`, bir bean'in `/actuator/refresh` tarafından tetiklenen, yeniden başlatma olmadan yeni yapılandırmayı almasını sağlar. Sırlar hiçbir zaman bir Config Repository dosyasına düz metin olarak ait değildir.

Hızlı referans:

```java
@SpringBootApplication
@EnableConfigServer
public class ConfigServerApplication { ... }   // kendi başına bir Spring Boot
                                                // uygulaması, yalnızca yapılandırma sunar

// order-service'in application.yml'i
// spring.config.import: "configserver:http://localhost:8888"

@RestController
@RefreshScope                                  // refresh'te @Value'ı yeniden okur,
class SomeController {                         // yalnızca başlangıçta değil
    @Value("${greeting.message}")
    private String greetingMessage;
}
```

**Terimler Sözlüğü**

**Config Server** — `@EnableConfigServer` ile etkinleştirilen, servis başına yapılandırmayı ağ üzerinden sunan bir Spring Boot uygulaması.

**Config Repository** — Gerçek yapılandırma dosyalarının yaşadığı yer -- production'da bir Git deposu, bu dersin örneğinde yerel bir dizin.

**Config Client** — Başlangıçta bir Config Server'dan `spring.config.import` üzerinden yapılandırma çekip birleştiren bir servis.

**Profil (Profile)** — Bir temel yapılandırma dosyasını override eden ya da genişleten, adlandırılmış bir yapılandırma varyantı (ör. staging, production).

**`@RefreshScope`** — Bir bean'in `@Value` ile enjekte edilen özelliklerinin, yalnızca başlangıçta değil, bir refresh tetiklendiğinde yeniden okunmasını sağlayan bir annotation.
