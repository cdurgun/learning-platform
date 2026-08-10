# Spring Boot Auto-Configuration ve Properties

Component Scanning dersinde bean'lerin container tarafından nasıl bulunduğunu, Spring
IoC Container dersinde ise bean'lerin nasıl tanımlandığını ve yaşam döngüsünün nasıl
işlediğini gördük. Bu son derste, Spring Boot'un bu ikisinin üzerine kattığı üçüncü
katmana bakıyoruz: `@SpringBootApplication` ve auto-configuration'ın perde arkasında
nasıl çalıştığına, `application.yml`'den `@Value`/`@ConfigurationProperties` ile
property okumaya, `@Profile` ile ortama özel yapılandırmaya, ve `ApplicationEvent` ile
container'ın kendi kendine haber vermesine. Bu dersin sonunda, projenin kendi
`application.yml` dosyalarının ve `LearningPlatformApplication`'daki tek bir
`@SpringBootApplication` satırının aslında neyi temsil ettiğini tam olarak
anlayacaksın.

## Spring Boot Auto-Configuration Nedir?

Auto-configuration, classpath'te hangi kütüphanelerin bulunduğuna bakarak Spring
Boot'un -- sen hiçbir `@Bean` metodu yazmadan -- senin yerine bean'ler kaydetmesidir.
Örneğin bu projede `spring-boot-starter-data-jpa` ve `postgresql` bağımlılığı olduğu
için, Spring Boot bir `DataSource` bean'i, bir `EntityManagerFactory` bean'i ve bir
JPA `TransactionManager` bean'i otomatik olarak kurar -- hiçbirini `WebConfig` gibi bir
`@Configuration` sınıfında elle tanımlamadık:

```java
// Elle yazsaydık (asla yazmıyoruz, Spring Boot bizim yerimize yapıyor):
@Configuration
class ManualDataSourceConfig {
    @Bean
    DataSource dataSource() {
        HikariDataSource ds = new HikariDataSource();
        ds.setJdbcUrl("jdbc:postgresql://localhost:5433/learning");
        ds.setUsername("learning");
        ds.setPassword("learning");
        return ds;
    }
}
```

`application.yml`'deki `spring.datasource.*` anahtarlarını yazman dışında, yukarıdaki
gibi bir sınıfı hiç görmedin -- çünkü auto-configuration, classpath'te
`org.postgresql.Driver` ve `spring-boot-starter-data-jpa`'yı görüp bu bean'i senin
yerine kaydediyor.

## Neden Var?

Component Scanning dersinde Java Config'in tekrarlayıcı olduğunu, component
scanning'in bunu sınıfın kendi üzerine taşıyarak azalttığını görmüştük. Ama component
scanning yalnızca **senin kendi sınıfların** için işe yarar -- `DataSource`,
`EntityManagerFactory`, `RequestMappingHandlerMapping` gibi bean'ler senin yazmadığın,
üçüncü parti kütüphanelerin sınıflarıdır; bunlara `@Component` ekleyemezsin (bkz.
Component Scanning dersindeki "Component Scanning vs Java Config: Ne Zaman Hangisi?").

Auto-configuration olmasaydı, her yeni Spring Boot projesinde yukarıdaki gibi
düzinelerce `@Bean` metodunu -- `DataSource`, `TransactionManager`,
`RequestMappingHandlerMapping`, `ViewResolver`, `ObjectMapper`, ve daha fazlasını --
elle yazman gerekirdi. Auto-configuration, "classpath'te şu kütüphane varsa, muhtemelen
şu bean'lere ihtiyacın vardır" varsayımını framework'ün kendisine taşır -- sen yalnızca
`application.yml`'de birkaç property ile bu varsayılanları özelleştirirsin.

## Tarihçe

Spring Boot, 2014'te 1.0 sürümüyle çıktı -- o zamana kadar bir Spring uygulaması
kurmak, XML tabanlı yapılandırma (Spring IoC Container dersindeki "Tarihçe"
bölümünde bahsettiğimiz `ClassPathXmlApplicationContext` dönemi) ya da onlarca elle
yazılmış `@Bean` metoduyla saatler sürebiliyordu. Spring Boot'un temel vaadi "convention
over configuration" idi: makul varsayılanlarla başla, yalnızca varsayılandan
sapmak istediğinde bir şey yaz.

`@EnableAutoConfiguration` (ve onu saran `@SpringBootApplication`) bu vaadin teknik
temelidir. Başlangıçta `META-INF/spring.factories` dosyasında listelenen auto-configuration
sınıflarını okuyordu; Spring Boot 2.7'de (2022) bu mekanizma, daha hızlı ve daha açık
olan `META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`
dosyasına taşındı -- bu proje Spring Boot 4.1 kullandığı için (bkz. `pom.xml`), yeni
mekanizmayı kullanıyor. `@ConditionalOnClass`, `@ConditionalOnMissingBean` gibi
`@Conditional` türevleri de 1.0'dan beri auto-configuration'ın temelini oluşturuyor.

## @SpringBootApplication: Üç Anotasyonun Birleşimi

`LearningPlatformApplication` sınıfının üzerindeki tek `@SpringBootApplication`
annotation'ı aslında üç ayrı annotation'ın birleşimidir -- ikisini zaten önceki
derslerden tanıyoruz:

{{SpringBootApplicationExample.java}}

`@SpringBootConfiguration`, `@Configuration`'ın (Spring IoC Container dersi) özel bir
türevidir. `@ComponentScan`, Component Scanning dersinde gördüğümüz, argümansız
kullanıldığında kendi paketini (ve alt paketlerini) tarayan annotation'ın ta kendisi --
bu yüzden `com.cdurgun.learning` altındaki her `@Controller`/`@Service` elle
kaydedilmeden bulunuyor. Üçüncüsü, bu dersin asıl konusu olan `@EnableAutoConfiguration`.

## @Conditional Ailesi ve Auto-Configuration Mekanizması

Auto-configuration'ın kalbinde `@Conditional` ailesi yatar: bir bean'in ya da tüm bir
`@Configuration` sınıfının, belirli bir koşul sağlandığında (ya da sağlanmadığında)
kaydedilmesini sağlayan annotation'lar. `@EnableAutoConfiguration` işleme girdiğinde,
Spring Boot'un kendi `spring-boot-autoconfigure` modülündeki yüzlerce
`@Configuration` sınıfını (`DataSourceAutoConfiguration`,
`JpaRepositoriesAutoConfiguration`, `ThymeleafAutoConfiguration` gibi) sırayla dener --
her biri kendi `@Conditional` annotation'larıyla korunur, ve koşulu sağlamayan hiçbir
şey kaydedilmez. En sık kullanılan iki türevi -- `@ConditionalOnClass` ve
`@ConditionalOnMissingBean` -- sonraki iki bölümde kendi ellerimizle kullanacağız.

## @ConditionalOnClass: Sınıf Classpath'te Varsa

`@ConditionalOnClass`, "bu bean'i yalnızca belirtilen sınıf classpath'te varsa
kaydet" der -- gerçek `DataSourceAutoConfiguration`'ın, yalnızca bir JDBC sürücüsü
projenin bağımlılıklarında varsa devreye girmesiyle aynı mekanizma:

{{ConditionalOnClassExample.java}}

`com.fasterxml.jackson.databind.ObjectMapper` gerçekten classpath'te olduğu için
(Jackson, `spring-boot-starter-web` üzerinden dolaylı olarak geliyor) ilk bean
kaydediliyor; uydurma bir sınıf adı verdiğimiz ikinci bean ise sessizce atlanıyor --
hiçbir hata fırlatılmıyor, bean sadece hiç var olmamış gibi davranıyor.

## @ConditionalOnMissingBean: Kullanıcı Kendi Bean'ini Tanımladıysa

`@ConditionalOnMissingBean`, kütüphanelerin "makul bir varsayılan sunuyorum, ama sen
kendi bean'ini tanımlarsan onu kullan" demesini sağlar -- gerçek Spring Boot'ta
`ObjectMapper`, `RestTemplateBuilder` gibi birçok bean tam olarak bu şekilde
davranır:

{{ConditionalOnMissingBeanExample.java}}

Sıralama burada kritik: uygulamanın kendi `@Configuration` sınıfı, kütüphanenin
varsayılanını tanımlayan sınıftan **önce** işlenmeli -- gerçek Spring Boot'ta bu,
auto-configuration sınıflarının her zaman uygulamanın kendi `@Configuration`
sınıflarından **sonra** işlenmesiyle garanti edilir, tam olarak bu yüzden kendi
tanımladığın bir bean her zaman auto-configuration'ın varsayılanının önüne geçer.

## Kendi Auto-Configuration'ımızı Yazmak

Gerçek bir Spring Boot starter'ının nasıl göründüğünü küçük ölçekte kendimiz
yazarak görelim -- `@ConditionalOnProperty`, bir özelliğin tamamen `application.yml`'den
açılıp kapatılmasını sağlar:

{{CustomAutoConfigurationExample.java}}

`matchIfMissing = false` sayesinde, property hiç tanımlanmamışsa bean varsayılan olarak
**kapalı** kalıyor -- gerçek Spring Boot'taki birçok isteğe bağlı özelliğin
(`spring.cache.type`, `management.endpoints.web.exposure.include` gibi) davranışıyla
aynı: sen açıkça istemeden devreye girmiyor.

## application.properties ve application.yml

Spring Boot iki eşdeğer dosya formatını destekler: düz `key=value` satırlarından
oluşan `application.properties`, ve iç içe geçmiş yapıyı girintiyle ifade eden
`application.yml`. Bu proje YAML'ı tercih ediyor -- kendi `application.yml`
dosyasından bir parça:

```yaml
spring:
  application:
    name: learning-platform
  profiles:
    active: dev
  thymeleaf:
    cache: false

server:
  port: 8080
```

Aynı ayarlar `.properties` formatında şöyle görünürdü: `spring.application.name=learning-platform`,
`spring.profiles.active=dev`, `spring.thymeleaf.cache=false`, `server.port=8080`. İkisi
de aynı düz nokta-ayrılmış property anahtarlarına (`spring.thymeleaf.cache` gibi)
çözümlenir -- YAML sadece bunu iç içe girintilerle daha az tekrarlı yazmanı sağlar.
Sonraki bölümlerde bu anahtarları `@Value` ve `@ConfigurationProperties` ile Java
tarafında nasıl okuyacağımızı göreceğiz.

## @Value ile Tekil Property Enjeksiyonu

`@Value`, `application.yml`'den tek bir property'yi doğrudan bir alana ya da
constructor parametresine enjekte eder -- en basit okuma yöntemi, ama hiçbir
gruplama sunmaz:

{{ValueInjectionExample.java}}

`${app.greeting.prefix:Hello}` ifadesindeki `:Hello` kısmı, property hiç
tanımlanmamışsa kullanılacak varsayılan değeri belirtir -- property zorunlu değilse
uygulamanın çökmesini önler. Kod örneğindeki yorumda da belirtildiği gibi, saf Spring
IoC Container'da (Spring Boot olmadan) `${...}` yer tutucularının çalışması için
`PropertySourcesPlaceholderConfigurer` bean'ini elle tanımlaman gerekir -- Spring
Boot'ta bunu hiç yazmazsın, çünkü `@EnableAutoConfiguration` bunu senin için otomatik
kaydeder. Bu, "Neden Var?" bölümünde bahsettiğimiz tam olarak o türden bir
tekrarı ortadan kaldırma örneği.

## @ConfigurationProperties ile Gruplanmış Property'ler

`@Value`'nun aksine, `@ConfigurationProperties` aynı önekle (prefix) başlayan bütün
bir property ailesini tek, tipli bir nesneye bağlar:

{{ConfigurationPropertiesExample.java}}

`app.mail.tls-enabled` (YAML'da kullanılacağı gibi kebab-case) otomatik olarak
`tlsEnabled` alanına bağlanıyor -- Spring Boot'un "relaxed binding" (esnek bağlama)
kuralları, kebab-case, camelCase ve UPPER_SNAKE_CASE'i (ortam değişkenleri için) aynı
property olarak kabul eder. Bu proje henüz kendi `@ConfigurationProperties` sınıfını
tanımlamıyor -- "Bu Projenin Kendi application.yml ve Config Sınıfları" bölümünde buna
tekrar döneceğiz.

## @ConfigurationProperties Validasyonu

Gerçek projelerde `@ConfigurationProperties`, `jakarta.validation` annotation'ları
(`@NotBlank`, `@Min` gibi) ve `@Validated` ile doğrulanır -- bu, `spring-boot-starter-validation`
bağımlılığını gerektirir, ki bu projede yok (bkz. `pom.xml`). Aynı güvenliği elle,
`@PostConstruct` ile kuruyoruz:

{{ConfigurationPropertiesValidationExample.java}}

Geçersiz bir `max-attempts` değeri, uygulamanın "0 deneme hakkı" gibi anlamsız bir
durumla sessizce çalışmaya devam etmesi yerine, başlangıçta (`context.refresh()`
sırasında) açıkça başarısız oluyor -- Spring IoC Container dersindeki
`@PostConstruct`/`@PreDestroy` bölümünde gördüğümüz yaşam döngüsü kancasının,
burada "fail fast" (erken başarısız ol) için kullanılmış hâli.

## Profiles: @Profile ile Ortama Özel Bean'ler

`@Profile`, aynı arayüzün birbirinden tamamen farklı iki implementasyonunun kaynak
kodda yan yana durmasını, ama yalnızca birinin -- aktif profile göre -- gerçekten
kaydedilmesini sağlar:

{{ProfileExample.java}}

Bu, tam olarak bu projenin `application-dev.yml`, `application-test.yml` ve
`application-prod.yml` arasında geçiş yaparken kullandığı mekanizma -- yalnızca
property değerleri değil, bean'lerin kendisi bile ortama göre değişebilir.

## Profile'a Özel application-{profile}.yml Dosyaları

Bu projenin dört `application*.yml` dosyası var: temel ayarları içeren
`application.yml`, ve üç profile özel dosya. `application.yml`'deki
`spring.profiles.active: dev` satırı, hangi profilin varsayılan olarak aktif
olacağını belirler:

```yaml
# application-dev.yml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5433/learning
  jpa:
    show-sql: true

# application-prod.yml
spring:
  datasource:
    url: ${DB_URL}
  jpa:
    show-sql: false
```

`application-prod.yml`'de `${DB_URL}` gibi ifadeler, "External Configuration: Property
Kaynaklarının Öncelik Sırası" bölümünde göreceğimiz ortam değişkenlerinden okunuyor --
gizli bilgiler (veritabanı
şifresi gibi) hiçbir zaman repoya yazılmıyor. Aktif profil `spring.profiles.active`
ile (ya da bir ortam değişkeniyle) değiştirildiğinde, Spring Boot ilgili
`application-{profile}.yml` dosyasını temel `application.yml`'in üzerine katman
katman uygular.

## External Configuration: Property Kaynaklarının Öncelik Sırası

Bir property birden fazla kaynakta tanımlıysa (mesela hem `application.yml`'de hem
bir ortam değişkeninde), Spring Boot hangisinin kazanacağına sıkı bir öncelik
sırasıyla karar verir. En yüksek öncelikliden en düşüğe doğru başlıca kaynaklar: komut
satırı argümanları, ortam değişkenleri, `application-{profile}.yml`, ve en altta temel
`application.yml`. Bu sıralamayı kendi elimizle simüle edelim:

{{PropertySourceOrderExample.java}}

Bu, tam olarak "Profile'a Özel application-{profile}.yml Dosyaları" bölümünde
gördüğümüz `${DB_URL}` ifadesinin neden işe yaradığını açıklıyor: prodüksiyonda
gerçek bir ortam değişkeni, `application-prod.yml`'deki yer tutucunun üzerine
katmanlanıyor.

## Ortam Değişkenleri ve Komut Satırı Argümanları

Property kaynaklarının en yüksek öncelikli ikisi -- ortam değişkenleri ve komut
satırı argümanları -- koddan tamamen bağımsız, dağıtım zamanında belirlenir. Bir
Spring Boot uygulaması `java -jar app.jar --server.port=9090` şeklinde başlatılırsa,
bu değer `application.yml`'deki her şeyin önüne geçer; aynı şekilde
`SERVER_PORT=9090` ortam değişkeni de (Spring Boot, `SERVER_PORT`'u otomatik olarak
`server.port`'a çevirir) aynı etkiyi yapar. Bu, sırrı (veritabanı şifresi gibi) hiç
repoya yazmadan, sadece dağıtım ortamında enjekte etmenin standart yoludur --
`application-prod.yml`'deki `${DB_URL}`, `${DB_USERNAME}`, `${DB_PASSWORD}` tam olarak
bunu yapıyor.

## ApplicationEvent ve @EventListener

Container, kendi yaşam döngüsü boyunca event'ler yayınlar, ve senin kendi
sınıfların da kendi event'lerini yayınlayıp dinleyebilir -- yayınlayan ile dinleyen
arasında hiçbir doğrudan bağımlılık olmadan:

{{ApplicationEventExample.java}}

`@EventListener`, `ApplicationListener<T>` arayüzünü implemente etmenin modern,
annotation tabanlı alternatifi -- hiçbir arayüz gerekmiyor, metot imzasındaki
parametre tipi hangi event'in dinleneceğini belirliyor. `ContextRefreshedEvent`,
container'ın kendi yayınladığı event'lerden biri; bir sonraki bölümde Spring Boot'un
bunun üzerine eklediği kendi event'lerine bakıyoruz.

## Spring Boot'un Kendi Event'leri (Kısa Bakış)

Saf Spring IoC Container'ın `ContextRefreshedEvent`'ine ek olarak, Spring Boot
`SpringApplication.run(...)` sırasında kendi event zincirini de yayınlar:
`ApplicationStartingEvent` (en başta), `ApplicationEnvironmentPreparedEvent`
(Environment hazırlandığında, ama context henüz oluşmadan), `ApplicationContextInitializedEvent`,
`ApplicationPreparedEvent`, ardından container'ın kendi `ContextRefreshedEvent`'i, ve
en sonda `ApplicationReadyEvent` -- "her şey, gömülü sunucu (embedded server) da dahil,
tamamen hazır" sinyali. Bu event'ler yalnızca gerçek `SpringApplication.run(...)` ile
başlatılan bir uygulamada oluşur -- bu dersteki örneklerin kullandığı sade
`AnnotationConfigApplicationContext` bunları tetiklemez, bu yüzden burada ayrı bir kod
örneği yok. Pratikte en sık kullanılan ikisi `ApplicationReadyEvent` (arka plan
işlerini başlatmak için) ve `ApplicationFailedEvent`'tir (başlatma başarısız
olduğunda temizlik yapmak için).

## Bu Projenin Kendi application.yml ve Config Sınıfları

Bu projenin `application.yml`'i, auto-configuration'ın gerçek hayatta nasıl
kullanıldığının iyi bir örneği: `spring.datasource.*`, `spring.jpa.*`,
`spring.thymeleaf.*`, `spring.flyway.*` anahtarlarının hiçbiri elle yazılmış bir
`@Bean` metoduna karşılık gelmiyor -- hepsi, ilgili auto-configuration sınıflarının
(`DataSourceAutoConfiguration`, `JpaBaseConfiguration`, `ThymeleafAutoConfiguration`,
`FlywayAutoConfiguration`) okuduğu, önceden tanımlı property'ler. Projenin kendi
yazdığı tek `@Configuration` sınıfı `WebConfig` (Spring IoC Container dersinde
gördüğümüz), ve o da bir `LocaleResolver` bean'i tanımlıyor -- Spring Boot'un kendi
`LocaleResolver` auto-configuration'ının **yerine** geçiyor, çünkü
`WebMvcAutoConfiguration`'ın kendi `localeResolver` bean'i tam olarak
`@ConditionalOnMissingBean` ile korunuyor (bkz.
"@ConditionalOnMissingBean: Kullanıcı Kendi Bean'ini Tanımladıysa"). Projede henüz
hiçbir `@Value` ya da `@ConfigurationProperties` kullanılmıyor -- tüm ayarlar,
Spring Boot'un kendi auto-configuration sınıflarının doğrudan okuduğu standart
`spring.*`/`server.*` anahtarları.

## Best Practices

- **Auto-configuration'ı önce anla, sonra güven** -- hangi bean'in neden kaydedildiğini
  bilmeden "sihir" gibi görmek, bir şey beklenmedik çalıştığında hata ayıklamayı
  imkânsız hâle getirir (bkz. "@Conditional Ailesi ve Auto-Configuration Mekanizması").
- **Property gruplarını `@ConfigurationProperties` ile, tekil değerleri `@Value` ile
  oku** -- birbiriyle ilişkili birden fazla ayar varsa, tek tek `@Value` yerine
  gruplanmış bir sınıf çok daha bakımı kolay bir yaklaşımdır (bkz.
  "@ConfigurationProperties ile Gruplanmış Property'ler").
- **Sırları (şifre, API anahtarı) asla `application.yml`'e yazma, ortam
  değişkenlerinden oku** -- bu projenin `application-prod.yml`'i tam olarak bunu
  yapıyor (bkz. "Ortam Değişkenleri ve Komut Satırı Argümanları").
- **`@ConditionalOnMissingBean` ile korunan varsayılanları geçersiz kılmak için,
  aynı tipte kendi bean'ini tanımlamak yeterlidir** -- ekstra bir "kapat" anahtarı
  aramana gerek yok (bkz. "@ConditionalOnMissingBean: Kullanıcı Kendi Bean'ini
  Tanımladıysa").
- **`@ConfigurationProperties` ile gelen ayarları başlangıçta doğrula, çalışma
  zamanında değil** -- geçersiz bir ayarla sessizce çalışmak yerine erken ve
  açıkça başarısız olmak, hatayı üretimde değil başlangıçta yakalar (bkz.
  "@ConfigurationProperties Validasyonu").

## Yaygın Hatalar

**1. `@Value("${...}")`'in saf Spring IoC Container'da (Spring Boot olmadan) otomatik
çalışacağını sanmak.** `PropertySourcesPlaceholderConfigurer` bean'i elle
tanımlanmadan `${...}` yer tutucuları hiç çözümlenmez (bkz. "@Value ile Tekil Property
Enjeksiyonu").

**2. `@ConfigurationProperties` sınıfını yazıp `@EnableConfigurationProperties` (ya da
`@ConfigurationPropertiesScan`) eklemeyi unutmak.** Sınıfın kendisi `@Component`
değildir -- container'a "bunu bağla" demeden hiçbir bean oluşmaz (bkz.
"@ConfigurationProperties ile Gruplanmış Property'ler").

**3. `@ConditionalOnProperty`'de `matchIfMissing`'i unutmak.** Varsayılan davranış
(`matchIfMissing = false`) property hiç tanımlanmamışsa bean'i **kaydetmemektir** --
"varsayılan olarak açık" bir özellik istiyorsan bunu açıkça belirtmen gerekir (bkz.
"Kendi Auto-Configuration'ımızı Yazmak").

**4. `@Profile` ile korunan bir bean'i, o profil aktif değilken `getBean(...)` ile
almaya çalışmak.** Bean hiç kaydedilmediği için bu, `NoSuchBeanDefinitionException`
ile sonuçlanır -- Component Scanning dersindeki `@Component` eklenmemiş bir sınıfla
aynı sonuç (bkz. "Profiles: @Profile ile Ortama Özel Bean'ler").

**5. Property kaynaklarının önceliğini yanlış hatırlamak, ve "neden ortam değişkenim
`application.yml`'i geçersiz kılmıyor" diye şaşırmak.** Ortam değişkenleri
`application.yml`'den her zaman daha yüksek öncelikli olmalı -- eğer geçersiz kılmıyorsa,
muhtemelen değişken adı yanlış yazılmıştır (bkz. "External Configuration: Property
Kaynaklarının Öncelik Sırası").

**6. `ApplicationReadyEvent` gibi Spring Boot'a özel bir event'i, sade bir
`AnnotationConfigApplicationContext` ile test etmeye çalışmak.** Bu event'ler yalnızca
gerçek `SpringApplication.run(...)` ile tetiklenir -- `ContextRefreshedEvent` ile
karıştırılmamalı (bkz. "Spring Boot'un Kendi Event'leri (Kısa Bakış)").

## Özet, Cheat Sheet ve Terimler Sözlüğü

Auto-configuration, Spring Boot'un classpath'teki kütüphanelere bakarak senin yerine
bean kaydetmesidir; `@Value` ve `@ConfigurationProperties`, `application.yml`'deki
ayarları Java koduna taşımanın iki yolu; `@Profile` ortama göre farklı bean'ler
seçmeyi, `ApplicationEvent`/`@EventListener` ise container'ın (ve senin kendi
kodunun) birbirine gevşek bağlı şekilde haber vermesini sağlar. Önemli noktalar:

- `@SpringBootApplication` = `@SpringBootConfiguration` + `@EnableAutoConfiguration` +
  `@ComponentScan`
- `@ConditionalOnClass`/`@ConditionalOnMissingBean`/`@ConditionalOnProperty`: auto-configuration'ın
  bean kaydedip kaydetmeyeceğine karar verdiği koşullar
- `@Value("${key:default}")`: tekil property, isteğe bağlı varsayılan değerle
- `@ConfigurationProperties(prefix = "...")` + `@EnableConfigurationProperties`:
  gruplanmış, tipli property ailesi
- `@Profile("name")`: yalnızca belirtilen profil aktifken kaydedilen bean
- Property kaynak önceliği (yüksekten düşüğe): komut satırı argümanları > ortam
  değişkenleri > `application-{profile}.yml` > `application.yml`
- `ApplicationEvent` + `ApplicationEventPublisher` + `@EventListener`: yayıncı ile
  dinleyici arasında doğrudan bağımlılık olmadan haberleşme

Hızlı referans:

```java
@SpringBootApplication  // = @SpringBootConfiguration + @EnableAutoConfiguration + @ComponentScan
class MyApplication { }

@Configuration
class MyAutoConfiguration {
    @Bean
    @ConditionalOnClass(name = "some.library.Class")
    @ConditionalOnMissingBean
    @ConditionalOnProperty(name = "app.feature.enabled", havingValue = "true", matchIfMissing = false)
    MyBean myBean() { return new MyBean(); }
}

class MyService {
    @Value("${app.setting:default}")
    private String setting;
}

@ConfigurationProperties(prefix = "app.settings")
class MySettings {
    private String name;
    // getter/setter
}

@Configuration
@EnableConfigurationProperties(MySettings.class)
class SettingsConfig {
    @Bean
    @Profile("prod")
    MyBean prodBean() { return new MyBean(); }
}

@Component
class MyListener {
    @EventListener
    void onEvent(MyEvent event) { }
}
```

**Terimler Sözlüğü**

**Auto-configuration** — Spring Boot'un, classpath'teki kütüphanelere bakarak
senin yerine bean kaydetmesi.

**`@SpringBootApplication`** — `@SpringBootConfiguration`, `@EnableAutoConfiguration`
ve `@ComponentScan`'i tek bir annotation'da birleştiren kolaylık annotation'ı.

**`@Conditional`** — Bir bean'in ya da `@Configuration` sınıfının, belirli bir koşul
sağlandığında (ya da sağlanmadığında) kaydedilmesini sağlayan annotation ailesinin
temeli.

**`@ConditionalOnClass`** — Belirtilen sınıf classpath'te varsa bean'i kaydeden koşul.

**`@ConditionalOnMissingBean`** — Belirtilen tipte başka bir bean henüz yoksa
kaydeden koşul; kütüphane varsayılanlarının kullanıcı tanımlı bean'lere yenilmesini
sağlar.

**`@ConditionalOnProperty`** — Belirtilen property belirli bir değere sahipse (ya da
hiç yoksa `matchIfMissing`'e göre) bean'i kaydeden koşul.

**`@Value`** — `application.yml`'den tek bir property'yi bir alana/parametreye
enjekte eden annotation.

**`@ConfigurationProperties`** — Ortak bir önekle başlayan bir property ailesini
tek, tipli bir nesneye bağlayan annotation.

**`@Profile`** — Bir bean'in yalnızca belirtilen profil(ler) aktifken kaydedilmesini
sağlayan annotation.

**`ApplicationEvent`** — Container tarafından ya da uygulama kodu tarafından
yayınlanabilen, `@EventListener`/`ApplicationListener` ile dinlenebilen olay nesnesi.

## Ek: Mini Proje — Feature Toggle Sistemi

Bu mini proje, `@ConfigurationProperties` (bir feature flag ailesi) ile
`@ConditionalOnProperty` (tek bir flag'in bütün bir bean'in var olup olmayacağına
karar vermesi) ve Component Scanning dersindeki `@Primary`'yi bir araya getiriyor:

{{FeatureToggleConfig.java}}

{{FeatureToggleDemo.java}}

`app.features.flags.*` altındaki her anahtar `FeatureToggles` bean'inin `flags`
map'ine bağlanırken, `app.features.ai-recommendations` bambaşka bir mekanizmayla --
`@ConditionalOnProperty` ile -- bir bean'in var olup olmayacağına karar veriyor. İkisi
aynı prefix'i paylaşsa da, birbirinden tamamen bağımsız iki yol: biri bir Java
nesnesine bağlanan veri, diğeri container'ın kendisine "bu bean'i hiç oluşturma"
diyen bir koşul.

> 💡 Tip
> `aiRecommendationEngine()` üzerindeki `@Primary`, tam olarak Component Scanning
> dersindeki "@Primary: Varsayılan Aday Belirlemek" bölümünde gördüğümüz mekanizma --
> iki bean aynı anda var olduğunda, hangisinin varsayılan olarak kazanacağını
> belirliyor.

## Ek: Mini Proje — Bildirim Ayarları Yöneticisi

Son mini proje, bu dersin neredeyse tüm konularını bir araya getiriyor:
`@ConfigurationProperties` ile gruplanmış ayarlar, `@Profile` ile ortama özel
davranış, ve ayarlar yüklendiğinde yayınlanan bir `ApplicationEvent`:

{{NotificationSettingsApp.java}}

{{NotificationSettingsDemo.java}}

`SettingsLoader`, `@PostConstruct` ile (Spring IoC Container dersindeki
"@PostConstruct ve @PreDestroy" bölümü) ayarlar enjekte edildikten hemen sonra bir
`SettingsLoadedEvent` yayınlıyor -- `SettingsAuditListener` bu event'i, `SettingsLoader`
sınıfının varlığından bile haberdar olmadan dinliyor. `prod` profili aktifken
`slowRetryWarning` bean'i, başka herhangi bir profilde (`!prod`) ise
`fastRetryWarning` bean'i kaydediliyor -- ikisi asla aynı anda var olmuyor.

> ⚠️ Warning
> `@Profile("!prod")` gibi olumsuzlama ifadeleri kullanışlıdır, ama dikkatli
> kullanılmalı: `dev`, `test`, ya da hiçbir profil aktif değilken bile `!prod` koşulu
> sağlanır -- "prod olmayan her durum" ile "yalnızca dev" aynı şey değildir, ve bu
> ikisini karıştırmak yanlış bean'in yanlış ortamda kaydedilmesine yol açabilir.
