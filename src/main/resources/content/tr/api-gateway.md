# API Gateway

Şimdiye kadar bu kurstaki mikroservislere yapılan her çağrı BAŞKA bir mikroservisten geldi -- order-service'in inventory-service'i önce sabit kodlanmış bir URL'le ("Servisler Arası İletişim" dersi), sonra Eureka üzerinden isimle çağırması ("Servis Keşfi ve Eureka" dersinin "Load-Balanced RestClient ile İsimle Çağrı Yapmak" bölümü) gibi. Ama gerçek sistemlerde DIŞARIDAN gelen istemciler de vardır -- bir tarayıcı, bir mobil uygulama -- ve bu istemciler Eureka ağının İÇİNDE çalışmaz, servis isimlerini bilmez, "orders" ile "inventory"'nin ayrı uygulamalar olduğunu bile bilmesine gerek yoktur. Bu ders, dış istemcilerle mikroservis sisteminin tamamı arasına giren parçayı tanıtıyor: API Gateway.

## API Gateway Nedir?

API Gateway, bir mikroservis kümesinin ÖNÜNDE duran TEK bir giriş noktasıdır. Dış bir istemci her isteğini TEK bir adrese gönderir (gateway'e); gateway isteğe bakıp onu asıl işleyecek servise -- order-service'e, inventory-service'e, ya da ileride eklenecek herhangi bir servise -- YÖNLENDİRİR. İstemci hiçbir zaman order-service ya da inventory-service'le doğrudan konuşmaz, gerçek adreslerini bilmesine hiç gerek kalmaz.

## Neden Var?

Gateway olmadan, dış bir istemcinin HER mikroservisin adresini ayrı ayrı bilmesi gerekirdi -- ve bu adres listesi bir servis her taşındığında/ölçeklendiğinde/yeniden adlandırıldığında değişirdi. Daha kötüsü, tek bir giriş noktası olmadan, sistemin TAMAMINI ilgilendiren konular (kimlik doğrulama, rate limiting, istek loglama) HER serviste AYRI AYRI yeniden yazılmak zorunda kalırdı. API Gateway iki sorunu birden çözer: istemcilerin hatırlaması gereken TEK bir adres, ve sistem geneli konuların uygulanacağı TEK bir yer -- order-service ile inventory-service'in aynı mantığı tekrar tekrar yeniden icat etmesi yerine.

## Tarihçe

Netflix, yaygın kullanılan ilk API gateway'lerinden birini -- Zuul'u -- 2013 civarında, Eureka'yı da üreten aynı iç altyapı için inşa etti ("Servis Keşfi ve Eureka" dersinin "Tarihçe" bölümüne bakınız). Zuul 1 bloklayan (blocking), istek başına bir thread kullanan, eski Servlet modeli üzerine kuruluydu. 2018'de tanıtılan Spring Cloud Gateway, Spring Cloud'un modern cevabı -- baştan itibaren Spring WebFlux (reaktif, non-blocking) üzerine kurulu, çünkü bir gateway sistemdeki HER isteğin yolunun üzerinde durur ve istek başına bir thread tutmadan çok sayıda eşzamanlı bağlantıyı işlemekten en çok fayda gören parça odur. Bu ders Spring Cloud Gateway kullanıyor.

## Gateway Uygulamasını Kurmak

api-gateway KENDİ BAŞINA bir Spring Boot uygulaması -- bu kursta order-service, inventory-service ve eureka-server'ın yanında dördüncüsü. Kendi iş mantığı, kendi veritabanı yok; tek işi istekleri almak ve yönlendirmek.

{{ApiGatewayApplication.java}}
{{ApiGatewayConfig.yml}}

> 💡 Tip
> api-gateway, order-service ve inventory-service'in aynı nedenle Eureka client'ı OLDUĞU gibi, o da bir Eureka client'ıdır -- istekleri yönlendirebilmek için servis isimlerini gerçek adreslere çözmesi gerekir (aşağıdaki "lb:// ile Keşif Tabanlı Yönlendirme" bölümüne bakınız).

## Rota Yapılandırması: Predicate'ler ve Filtreler

ROTA (route), gateway'in temel yapı taşı -- üç şeyin birlikte oluşturduğu bir bütün: bir PREDICATE (gelen bir isteğe bu rotanın uygulanıp uygulanmayacağına karar veren koşul, en yaygın olarak istek yoluyla eşleşme), bir URI (eşleşen isteğin nereye yönlendirileceği), ve isteğe bağlı bir veya daha fazla FİLTRE (istek ya da yanıt üzerinde yol boyunca uygulanan dönüşümler).

{{GatewayRoutesConfig.yml}}

## lb:// ile Keşif Tabanlı Yönlendirme

Yukarıdaki rota yapılandırmasındaki `lb://order-service` URI'sine dikkat edin -- bu, "Servis Keşfi ve Eureka" dersindeki `@LoadBalanced RestClient`'ın `http://inventory-service`'i çağırmasıyla (dersin "Load-Balanced RestClient ile İsimle Çağrı Yapmak" bölümüne bakınız) AYNI fikir: `lb://` gerçek bir protokol değil, Spring Cloud Gateway'e `order-service`'i Eureka üzerinden çözmesini ve o isim altında o anda kayıtlı kaç örnek varsa aralarında yük dengelemesi yapmasını söyler. Gateway'in order-service'in gerçek host ve portunu hiçbir yerde sabit kodlamasına hiç gerek kalmaz.

## Özel Bir Filtre Yazmak

`StripPrefix` (yukarıda kullanıldı) gibi hazır filtreler yaygın durumları karşılar, ama bir gateway `GlobalFilter` üzerinden her istekte özel kod da çalıştırabilir. Bu, kursun İLK REAKTİF kodu -- Spring Cloud Gateway, order-service ve inventory-service'in controller'larının kullandığı bloklayan Spring MVC'nin aksine Spring WebFlux üzerinde çalışır.

{{RequestLoggingGlobalFilter.java}}

> ⚠️ Warning
> Bir `GlobalFilter`'ın `filter(...)` metodu `Mono<Void>` döndürmeli ve çağıran thread'i ASLA BLOKLAMAMALI (JDBC çağrısı yok, `Thread.sleep` yok, bloklayan I/O yok) -- Spring WebFlux, tüm eşzamanlı istekler arasında paylaşılan küçük, sabit sayıda thread çalıştırır; bunlardan birini bile bloklamak ilgisiz istekleri de durdurur.

## Sistem Geneli Konular Nereye Ait?

Gateway, hangi servisin isteği sonunda işleyeceğinden BAĞIMSIZ olarak HER isteği ilgilendiren konular için doğal bir yer -- örneğin bir correlation id atamak, böylece dış bir istek ileride birden fazla iç servis üzerinden izlenebilir.

{{CorrelationIdGatewayFilter.java}}

> 💡 Tip
> Bu ders yalnızca correlation id'yi ATIYOR -- onu order-service ile inventory-service arasındaki giden çağrılara GERÇEKTEN aktarmak ve log satırlarını birbirine bağlamak için kullanmak, yakında gelecek Observability dersinin konusu.

## Bir Gateway'in YAPMAMASI Gerekenler

Gateway zaten her isteği gördüğü için içine iş mantığı koymak cazip gelebilir -- ama bu, iş kurallarını onları SAHİPLENEN servislerden ÇIKARIP hiçbir domain bilgisi olmayan bir altyapı parçasına TAŞIR. Bir gateway yönlendirmeli, ve gerçekten İSTEĞİN kendisiyle ilgili konuları (kimlik doğrulama, rate limiting, loglama, correlation id'ler) uygulamalı -- örneğin bir siparişin geçerli olup olmadığına karar VERMEMELİ. O karar, tıpkı öncekiler gibi, order-service'e ait.

## Best Practices

- **Servisi İSİMLE (`lb://servis-adı`) yönlendir, asla sabit kodlanmış bir host:port ile değil** -- `@LoadBalanced RestClient` ile aynı gerekçe ("Servis Keşfi ve Eureka" dersine bakınız).
- **Filtreleri istek/yanıt konularına odaklı tut** (loglama, correlation id'ler, header'lar) -- iş kararına benzeyen her şeyi sahibi olan servise geri it.
- **api-gateway'i de kendi `spring.application.name`'iyle Eureka'ya kaydet** -- gateway'in kendisine keşif üzerinden hiçbir şey yönlendirilmese bile, onu registry'de diğer her servisin yanında görünür tutar.
- **Global filtreleri `Ordered` ile bilinçli olarak sırala** -- bir correlation id atayan filtre, onu kullanan bir loglama filtresinden ÖNCE çalışmalı.

## Yaygın Hatalar

- **İş mantığını (doğrulama, hesaplama) doğrudan bir gateway filtresinin İÇİNE koymak.** O mantık, her isteğin geçtiği paylaşılan altyapıya değil, sahibi olan mikroservise ait.
- **Thread'i BLOKLAYAN bir `GlobalFilter` yazmak** (bir JDBC çağrısı, `Thread.sleep`) -- Spring WebFlux'in thread modeli, aynı hatayı bloklayan bir Spring MVC controller'da yapmaktan ÇOK daha yıkıcı hale getiriyor.
- **Bir rotanın `uri`'sinde alt akıştaki servisin host:port'unu sabit kodlamak**, `lb://servis-adı` kullanmak yerine -- Service Discovery'nin çözmeye çalıştığı sorunu birebir yeniden yaratır.
- **Gateway'in birden fazla servisin yanıtını TEK bir yanıtta birleştirmesini beklemek.** Sade Spring Cloud Gateway TEK bir isteği TEK bir servise yönlendirir; birden fazla çağrıyı tek bir yanıtta birleştirmek farklı bir desendir (genellikle Backend for Frontend olarak anılır), bu dersin kapsamı dışında.

## Özet, Cheat Sheet ve Terimler Sözlüğü

API Gateway, dış istemcilerin tek tek mikroservisler yerine konuştuğu tek bir giriş noktasıdır. Spring Cloud Gateway rotaları predicate'lerden (bir rotanın ne zaman uygulandığı), bir URI'den (nereye yönlendirdiği, genellikle Eureka üzerinden çözülen `lb://servis-adı`) ve filtrelerden (yol boyunca uygulanan dönüşümler) oluşur -- hem `StripPrefix` gibi hazır filtreler hem de Spring WebFlux üzerinde çalışan ve ASLA bloklamaması gereken özel `GlobalFilter`'lar. Gateway, istek seviyesindeki, sistem geneli konular (correlation id'ler, loglama) için doğru yerdir -- iş mantığı için ASLA, o her zaman sahibi olan serviste kalır.

Hızlı referans:

```java
@SpringBootApplication
public class ApiGatewayApplication { ... }   // kendi başına bir Spring Boot
                                              // uygulaması, kendi iş mantığı yok

// application.yml
// spring.cloud.gateway.routes:
//   - id: orders-route
//     uri: lb://order-service               // servis ADI, Eureka üzerinden çözülür
//     predicates:
//       - Path=/orders/**
//     filters:
//       - StripPrefix=0

@Component
class SomeGlobalFilter implements GlobalFilter, Ordered {
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        return chain.filter(exchange);       // isteği ileriye yönlendirir
    }
}
```

**Terimler Sözlüğü**

**API Gateway** — Dış istekleri doğru iç mikroservise yönlendiren tek bir giriş noktası.

**Rota (Route)** — Gateway'in temel yapı taşı: bir predicate, bir hedef URI, ve isteğe bağlı filtreler.

**Predicate** — Gelen bir isteğe bir rotanın uygulanıp uygulanmayacağına karar veren koşul (en yaygın olarak bir yol/path deseni).

**GlobalFilter** — Gateway'den geçen HER istekte çalışan, Spring WebFlux üzerinde reaktif olarak yazılan özel kod.

**`lb://`** — Spring Cloud Gateway'e sabit bir adres yerine bir servis ismini Eureka üzerinden çözmesini ve örnekleri arasında yük dengelemesi yapmasını söyleyen sahte bir protokol.
