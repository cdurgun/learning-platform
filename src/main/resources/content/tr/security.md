# Security

Bu kategorideki her ders şimdiye kadar order-service ve inventory-service'in kendilerini çağıran her şeye basitçe güvendiğini varsaydı. Odak başka yerdeyken makul bir sadeleştirmeydi -- ama gerçek bir sistemin, bu kursun şimdiye kadar hiç değinmediği iki soruya cevap vermesi gerekir: bu isteği yapan kim, ve istediklerini yapmasına izin var mı? Bu ders, Spring Security'yi kursa ilk kez tanıtıyor, özellikle bu kategorinin servisleriyle sınırlı olarak.

## Bir Mikroservis Sistemi İçin Security Ne Demek?

Tek bir uygulamada, security genellikle ön kapıda tek bir giriş kontrolü demektir. Bir mikroservis sisteminde, isteği alan HER servisin -- yalnızca herkese açık internete bakanın değil -- "bu kim, ve bunu yapmasına izin var mı" sorusuna kendi cevabı olması gerekir, çünkü bir istek, yanlış yapılandırma yüzünden ya da bilinçli olarak, herkese açık olana (api-gateway) hiç dokunmayan yollardan bir iç servise (inventory-service) ulaşabilir.

## Neden Var?

Herhangi bir kimlik kontrolü olmadan, order-service'in ağına ulaşabilen HERHANGİ bir istek sipariş verebilir, ve inventory-service'e doğrudan ulaşabilen herhangi bir istek api-gateway'i tamamen atlayabilir -- api-gateway'in sağladığı yönlendirme ve sistem geneli konular (API Gateway dersine bakınız) kolaylık ve yapıdır, tek başlarına bir güvenlik sınırı değil. Yalnızca api-gateway'de kimlik kontrolü yapıp sonra her iç çağrıya koşulsuz güvenen bir sistem, yalnızca EN AZ korunan iç yolu kadar güvenlidir.

## Tarihçe

HTTP API'leri için token-tabanlı kimlik doğrulama, tek sayfa uygulamaları ve mobil istemciler 2010'lar boyunca sunucu-render edilmiş, session-cookie-tabanlı girişlerin yerini aldıkça baskın desen haline geldi -- herhangi bir servisin bağımsız olarak doğrulayabildiği stateless bir token, paylaşılan bir sunucu-taraflı session'ın hiçbir zaman uyamayacağı kadar dağıtık bir sistemin şekline uyar. RFC 7519'da (2015) standartlaştırılan JSON Web Token (JWT), tam olarak kendi kendine yeterli ve bağımsız olarak doğrulanabilir olduğu için ("JWT: Kendi Kendine Yeterli, Doğrulanabilir Bir Kimlik" bölümüne bakınız) o token için en yaygın şekil haline geldi -- hiçbir servisin, bir isteği yapanın kim olduğunu kontrol etmek için merkezi bir session deposuna geri çağrı yapmasına gerek yok.

## Authentication vs Authorization: İki Farklı Soru

Bu iki kelime genellikle gevşek kullanılır, ama gerçekten farklı sorulara cevap verirler. Authentication "bu kim?" diye sorar -- bir kimliği doğrulamak, tipik olarak bir token'ın imzasını kontrol ederek. Authorization "BU kimliğin BUNU yapmasına izin var mı?" diye sorar -- authentication başarılı olduktan SONRA gerçekleşen tamamen ayrı bir karar ("Authorization: Bir Endpoint'i Role Göre Kısıtlamak" bölümüne bakınız). Bir istek authenticated (gerçek, geçerli bir kimlik) olabilir ve yine de unauthorized olabilir (o kimliğin istediğini yapmasına yalnızca izin yok).

## JWT: Kendi Kendine Yeterli, Doğrulanabilir Bir Kimlik

Bir JWT kendi claim'lerini (kim yayınladı, kimi tanımlıyor, hangi rolleri ya da scope'ları veriyor, ne zaman süresi doluyor) ve bunların hepsi üzerinde kriptografik bir imza taşır -- yayınlayanın public key'ine sahip herhangi bir servis imzayı doğrulayabilir ve claim'lere güvenebilir, BU spesifik kontrol için yayınlayana hiç doğrudan bağlanmadan. Bu, api-gateway ve order-service'in ikisinin de AYNI token'ı bağımsız olarak doğrulayabilmesini sağlayan şey ("Gateway'de Bir JWT'yi Doğrulamak" ve "Gateway Tek Başına Neden Yetmiyor" bölümlerine bakınız).

## Gateway'de Bir JWT'yi Doğrulamak

api-gateway, dış bir isteği gören ilk servis, bu yüzden hiç geçerli token taşımayan bir isteği reddetmek için doğal ilk yer.

{{ApiGatewaySecurityConfig.java}}
{{ApiGatewayJwtConfig.yml}}

> 💡 Tip
> Bu kurs, bu derse kadar hiçbir yerde Spring Security kullanmadı -- bu projenin quiz özelliği için inşa edilen AI ingestion endpoint'i, bunun yerine bilinçli olarak elle yazılmış bir `X-Api-Key` kontrolü kullandı, özellikle tek bir internal endpoint için tüm bir security framework'ü eklemek orantısız olacağı için. Gerçek kullanıcı kimliğini işleyen, herkese açık bir gateway, Spring Security'yi getirmeyi haklı çıkaran tam olarak bu türden bir durum.

## Gateway Tek Başına Neden Yetmiyor: Servisler Arasında Zero Trust

order-service kendisine ulaşan her isteğe basitçe güvenseydi, api-gateway'i atlayan HERHANGİ bir yol -- yanlış yapılandırılmış bir rota, bir iç ağda doğrudan ulaşılabilir bir servis, birinin gateway'den geçirmeyi unuttuğu gelecekteki bir servis -- hiçbir korumaya sahip olmazdı. Zero trust, order-service'in JWT'yi de KENDİSİ, bağımsız olarak doğrulaması anlamına gelir, "muhtemelen zaten kontrol edilmiştir" diye varsaymak yerine.

{{OrderServiceSecurityConfig.java}}
{{OrderServiceJwtConfig.yml}}

> ⚠️ Warning
> `OrderServiceJwtConfig.yml`'in `ApiGatewayJwtConfig.yml` ile AYNI `issuer-uri`'ye işaret ettiğine dikkat edin -- her iki servis de AYNI kimlik sağlayıcısından AYNI token'ları, tamamen bağımsız olarak doğruluyor. Hiçbir servis diğerine "bunu zaten kontrol ettin mi?" diye sormuyor.

## Authorization: Bir Endpoint'i Role Göre Kısıtlamak

Bir istek authenticate olduktan sonra, `OrderServiceSecurityConfig`'in `.hasRole("customer")` kuralı (yukarıya bakınız) kimin özellikle sipariş verebileceğine dair AYRI kararı verir -- o role sahip olmayan authenticated bir kimlik, eksik ya da geçersiz bir token'ın üreteceği `401 Unauthorized` DEĞİL, `403 Forbidden` alır.

## Kimliği Yaymak: Correlation Id'nin Security Karşılığı

order-service'in kendi JWT'si, `ResilientStockClient` üzerinden inventory-service'i çağırdığında (Resilience4j dersine bakınız) otomatik olarak yanında gitmez -- Observability dersinin correlation id için kapattığı AYNI boşluk, şimdi kimlik için.

{{RestClientBearerTokenInterceptor.java}}

## Best Practices

- **İsteği alan HER serviste kimliği doğrula, yalnızca herkese açık internete bakanda değil** -- "Gateway Tek Başına Neden Yetmiyor" bölümüne bakınız.
- **Authentication ve authorization'ı ayrı konular olarak tut**, birbirine yakın yapılandırılmış olsalar bile (`OrderServiceSecurityConfig`'te olduğu gibi) -- "Authentication vs Authorization" bölümüne bakınız.
- **Kimliği servis sınırları boyunca bilinçli olarak yay**, correlation id'nin yayıldığı AYNI şekilde -- `RestClientBearerTokenInterceptor`'a, ve onun ayna olduğu Observability dersinin `RestClientCorrelationIdInterceptor`'ına bakınız.
- **Health check endpoint'lerini herkese açık tut** (yukarıdaki `.pathMatchers("/actuator/health").permitAll()`'a bakınız) -- load balancer'ların ve orkestratörlerin bunlara bir token olmadan ulaşması gerekir.

## Yaygın Hatalar

- **api-gateway'in authentication kontrolüne sistemin TEK güvenlik sınırı olarak güvenmek.** Başka bir yoldan ulaşılabilir herhangi bir iç servis, kimliği KENDİSİ doğrulamadıkça hiçbir korumaya sahip değildir -- "Gateway Tek Başına Neden Yetmiyor" bölümüne bakınız.
- **Bir `401`'i bir `403` ile karıştırmak.** `401 Unauthorized`, authentication'ın kendisinin başarısız olduğu anlamına gelir (token yok, ya da geçersiz); `403 Forbidden`, authentication'ın başarılı olduğu ama authorization'ın olmadığı anlamına gelir -- ikisini karıştırmak gerçek bir erişim sorununu debug etmeyi çok zorlaştırır.
- **Kimliği alt akıştaki bir servis çağrısına yaymayı unutmak.** `RestClientBearerTokenInterceptor` olmadan, inventory-service order-service'ten tamamen unauthenticated bir istek alır, ORİJİNAL dış istek düzgün authenticate edilmiş olsa bile.
- **Authorization mantığını bir controller metodunun içine dağınık `if` ifadeleri olarak koymak**, bir servisin diğer security kurallarının zaten yaşadığı yerde (`OrderServiceSecurityConfig`) tanımlamak yerine -- dağıtmak, bir servisin gerçek erişim kurallarını tek bir yerde denetlemeyi zorlaştırır.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Bir mikroservis sisteminde security, isteği alabilecek her servisin kimin sorduğuna (authentication) ve ne yapmasına izin olduğuna (authorization) kendi cevabına ihtiyaç duyması demektir -- yalnızca api-gateway'in kontrolüne güvenmek diğer her yolu korumasız bırakır. JWT'ler, yayınlayanın public key'ine sahip herhangi bir servisin bağımsız olarak kontrol edebileceği doğrulanabilir bir kimlik taşır -- bu, hem api-gateway'in hem order-service'in AYNI token'ı merkezi bir depoya geri çağrı yapmadan doğrulayabilmesini sağlayan şey. Kimlik, tıpkı bir correlation id gibi, servis sınırları boyunca bilinçli olarak yayılmalıdır.

Hızlı referans:

```java
@EnableWebSecurity
class SomeServiceSecurityConfig {
    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
                .authorizeHttpRequests(requests -> requests
                        .requestMatchers("/actuator/health").permitAll()
                        .anyRequest().authenticated())
                .oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt -> {}))
                .build();
    }
}

// application.yml
// spring.security.oauth2.resourceserver.jwt.issuer-uri: https://auth.example.com/
```

**Terimler Sözlüğü**

**Authentication** — Bir isteği kimin yaptığını, tipik olarak bir token'ın imzasını kontrol ederek doğrulamak.

**Authorization** — Zaten authenticate olmuş bir kimliğin belirli bir şeyi yapmasına izin olup olmadığına karar vermek.

**JWT (JSON Web Token)** — Kendi kimlik claim'lerini taşıyan, yayınlayanın public key'ine sahip herhangi bir tarafça bağımsız olarak doğrulanabilir, kriptografik olarak imzalanmış kendi kendine yeterli bir token.

**Zero Trust** — Hiçbir servisin bir isteğin başka bir yerde zaten doğrulanmış olduğunu varsaymaması, kimliği kendisinin doğrulaması gerektiği ilkesi.

**Resource Server** — JWT'leri doğrulamak ve claim'lerine dayalı erişim kurallarını uygulamak üzere yapılandırılmış bir servis (burada order-service ya da api-gateway gibi).
