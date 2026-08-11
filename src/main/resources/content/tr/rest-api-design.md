# REST API Tasarımı

Advanced Spring MVC dersi, bir isteğin **etrafına** nasıl davranış eklendiğini
(interceptor, CORS, multipart) ele aldı -- bu ders ise isteğin/yanıtın **kendi
şekline** dönüyor. Request ve Response Handling'de `@RequestBody`,
`ResponseEntity` ve HTTP durum kodlarını, Validation & Exception Handling'de de
`ProblemDetail` ile standart hata gövdelerini görmüştük -- bu ders, bu
araçların üzerine, gerçek dünya REST API'lerinin sıkça karşılaştığı beş somut
tasarım sorununu ekliyor: entity'yi dışarı sızdırmadan veri taşımak (DTO), büyük
koleksiyonları parça parça döndürmek (pagination/sorting/filtering), bir API'yi
geriye dönük uyumluluğu bozmadan değiştirmek (versioning), bir isteğin
istemeden iki kez işlenmesini önlemek (idempotency) ve yanıtın kendi
navigasyonunu taşıması (HATEOAS).

## REST API Tasarımı Nedir?

REST (Representational State Transfer), Request ve Response Handling ve Path
Variable'lar ve Request Parametreleri derslerinde zaten kullandığımız
ilkelerin (kaynaklar URL'lerle temsil edilir, HTTP metotları anlamlı bir
sözleşme taşır, yanıtlar durum kodlarıyla konuşur) bir mimari stildir. Bu ders,
o ilkeleri **tek bir endpoint'in** ötesine, bir API'nin **bütününün** nasıl
tasarlanacağına taşıyor:

```java
// "REST'e uygun" tek bir endpoint yeterli değil -- bir API'nin tümü tutarlı
// olmalı: aynı hata şekli, aynı sayfalama deseni, aynı versiyonlama stratejisi.
@GetMapping("/api/v1/topics")
ResponseEntity<PagedResponse<TopicSummary>> listTopics(Pageable pageable) { ... }
```

## Neden Var?

Her endpoint kendi kuralını icat ederse (biri sayfalamayı `?page=`/`?offset=`
diye farklı adlandırır, biri hatayı düz metin diğeri JSON döner), bir API'yi
tüketen istemci her endpoint için ayrı bir zihinsel model kurmak zorunda kalır.
Validation & Exception Handling'de `@RestControllerAdvice`'ın hata gövdesini
**tek bir yere** topladığını görmüştük -- bu dersteki desenlerin (DTO,
pagination shape, versioning stratejisi) hepsi aynı motivasyonu paylaşıyor:
tutarlılığı endpoint'ler arasında merkezi ve öngörülebilir kılmak.

## Tarihçe

REST terimi, Roy Fielding'in 2000 doktora tezinde tanımlandı -- HTTP'nin
kendisiyle aynı yaşta bir mimari stil değil, HTTP'nin **doğru kullanımı**
üzerine bir gözlem. HATEOAS, Fielding'in orijinal tezinin bir parçasıydı, ama
pratikte en az benimsenen ilke oldu -- çoğu "REST API" aslında HATEOAS'sız,
düz JSON döndüren bir HTTP API. Spring HATEOAS projesi 2012'de bu boşluğu
doldurmak için başladı (bu projede kullanılmıyor, bkz. "HATEOAS Nedir? (Kısa
Bakış)"). Idempotency-Key header deseni, Stripe'ın API'sinin 2017'de
popülerleştirdiği, sonradan IETF taslağına dönüşen bir konvansiyon. API
versioning stratejileri arasındaki URI vs header tartışması ise 2010'lardan
beri süregelen, hâlâ kesin bir tek doğrusu olmayan bir tasarım tercihi.

## Entity'yi Doğrudan Dışarı Vermenin Riskleri: Neden DTO?

Bir JPA entity'sini doğrudan `@RestController`'dan döndürmek cazip görünür --
Jackson zaten onu JSON'a çevirebilir. Ama bunun iki gerçek riski var:

{{EntityLeakageRiskExample.java}}

Birincisi: entity, veritabanının ihtiyaç duyduğu **her** alanı taşır --
`passwordHash`, iç notlar gibi hiçbir istemcinin görmemesi gereken alanlar da
dahil. İkincisi: gerçek bir entity'de lazy-loaded bir koleksiyon (`@ManyToOne(FetchType.LAZY)`
gibi, bu projenin `TopicRepository`'sinde de gördüğümüz), serialization sırasında
dokunulursa `LazyInitializationException` fırlatabilir -- bu proje bu riski
`findBySlugWithCategoryAndCourse`'daki join fetch ile baştan çözüyor, ama genel
prensip aynı: entity'nin iç yapısını API sözleşmesine sızdırma.

## DTO Deseni: Record ile İstek/Yanıt Ayrımı

Çözüm, API'nin gerçekten ihtiyaç duyduğu şekli **ayrıca** tanımlamak:

{{DtoRecordExample.java}}

Record dersinde gördüğümüz gibi, bir record immutable ve özlü -- her biri tek
bir yönü (istek ya da yanıt) tanımlar. `CreateUserRequest`'in `id` alanı yok
(henüz yok çünkü), `UserResponse`'un `password` alanı yok (asla dışarı
çıkmaması gerektiği için). Tek bir paylaşılan "User" şekli bu iki kısıtı aynı
anda ifade edemezdi.

## Entity ↔ DTO Dönüşümü: Elle Mapping

DTO deseni, bir şeyin ikisi arasında **dönüştürmesiyle** anlam kazanır:

{{EntityToDtoMappingExample.java}}

Bu projenin ölçeğinde elle yazılmış bir `toDto(...)` metodu gayet
sürdürülebilir. Daha büyük kod tabanlarında, DTO sayısı onlarcaya çıkıp
alanlar sık değiştiğinde, bu dönüşümü elle senkron tutmak hataya açık hâle
gelir -- MapStruct gibi bir mapping kütüphanesi (derleme zamanında aynı
metodu otomatik üretir) genelde bu noktada devreye girer.

## Sayfalama (Pagination): Pageable ve Page<T>

Büyük bir koleksiyonu tek seferde döndürmek yerine, parça parça vermek:

{{PaginationExample.java}}

`Pageable`/`Page`, bu projenin `TopicRepository`'sinin de miras aldığı
`JpaRepository` ailesinden -- `@RestController` metodun bir parametresi
`Pageable` tipindeyse, Spring bunu `?page=`/`?size=`/`?sort=` query
parametrelerinden otomatik çözer, elle parse etmeye gerek kalmaz.
`page.getTotalElements()`/`getTotalPages()`, istemcinin kaç sayfa daha
olduğunu bilmesini sağlar.

## Sıralama (Sorting): Sort ile Çoklu Alan

`Sort`, `Pageable` ile birlikte çalışır ve birden fazla alanla
zincirlenebilir:

{{SortingExample.java}}

`Sort.by(Sort.Direction.ASC, "difficulty").and(Sort.by(Sort.Direction.DESC, "title"))`,
istemcinin `?sort=difficulty,asc&sort=title,desc` ile isteyeceği sıralamanın
sunucu tarafındaki karşılığı -- Spring bu query parametrelerini otomatik olarak
tam da bu `Sort` nesnesine çözer.

## Filtreleme: Query Parametreleriyle Dinamik Sorgu

Path Variable'lar ve Request Parametreleri'nde `@RequestParam`'ın opsiyonel
olabileceğini görmüştük -- filtreleme de tam olarak bunun üzerine kurulu:

{{DynamicFilterExample.java}}

Her filtre parametresi opsiyonel: mevcutsa sonucu daraltır, yoksa hiç
etkilemez (`true` dönen bir predicate ile). Gerçek bir repository'de bu
mantık genelde veritabanına, bir `WHERE` cümlesine ya da (çok sayıda opsiyonel
alan için) bir JPA `Specification`'a taşınır -- ama temel fikir aynı: her
filtre, sağlanmamışsa "hiçbir şeyi eleme" davranışına düşer.

## Sayfalanmış Yanıtın Şekli: content, totalElements, totalPages

Bir `Page<T>`'i doğrudan controller'dan döndürmek çalışır, ama Spring Data'nın
kendisi bunu önermiyor -- `PageImpl`'in iç alanları belgeli, kararlı bir
sözleşme değil ve varsayılan JSON şekli sürümler arasında değişebiliyor:

{{PagedResponseShapeExample.java}}

Çözüm, DTO desenindeki fikrin aynısı: `Page<T>`'i, bu projenin **kendi**
belgeleyebileceği, alan adlarını **kendi** kontrol ettiği bir
`PagedResponse<T>`'e sarmalamak. `Page<T>`'in dahili serialization'ı hangi
Spring Data sürümünde nasıl değişirse değişsin, bu record'un şekli yalnızca bu
proje değiştirirse değişir.

## API Versioning: URI Versioning vs Header Versioning

Bir API zamanla değişir -- eski istemcileri kırmadan yeni bir şekil sunmanın
iki yaygın yolu:

{{ApiVersioningExample.java}}

URI versioning (`/api/v1/...` vs `/api/v2/...`), Mapping Annotation'ları ve
HTTP Metotları dersinde gördüğümüz `@GetMapping`'in path'inin bir parçası --
gözden kaçırılması imkansız, ama "v1"/"v2" istemcinin her URL'sine sonsuza
kadar sızar. Header versioning (`Api-Version: 2`), Path Variable'lar ve Request
Parametreleri dersindeki `@RequestHeader`'ı kullanır -- URL hiç değişmez, ama
versiyon artık URL'e bakarak görünmez, dokümantasyona bağımlı hâle gelir.

## Idempotency Nedir? Doğal Olarak Idempotent Metotlar

Bir işlem, bir kez çağrılmasıyla N kez çağrılması **aynı sonucu**
üretiyorsa idempotent'tir:

{{IdempotentMethodsExample.java}}

`PUT` ve `DELETE`, doğaları gereği idempotent -- aynı `PUT`'u iki kez
göndermek, kaynağı aynı son duruma getirir; aynı `DELETE`'i iki kez göndermek,
kaynağı "yok" durumunda bırakır (ikinci çağrı hiçbir şey değiştirmez). `POST`
ise **değil** -- her çağrı, tanımı gereği yeni bir kaynak yaratır. Bu ayrım,
Mapping Annotation'ları ve HTTP Metotları dersinin "HTTP Metotları: Safe ve
Idempotent Kavramları" bölümünde tanıtılmıştı; burada gerçekten çalıştırıp
doğruluyoruz.

## Idempotency-Key Header'ı ile POST'u Idempotent Yapmak

`POST`'un idempotent olmaması gerçek bir sorun yaratır: bir istemci zaman
aşımından sonra isteği tekrar denediğinde, sunucunun isteği ilk kez mi işlediği
belirsizdir. Çözüm, istemcinin ürettiği bir anahtarla sunucunun "bunu daha
önce gördüm" diyebilmesi:

{{IdempotencyKeyExample.java}}

İstemci, mantıksal bir işlem için tek bir `Idempotency-Key` üretir (genelde
bir UUID) ve her denemede aynı anahtarı gönderir. Sunucu, o anahtarı daha önce
işlediyse **yeni bir kaynak yaratmadan** ilk sonucu döndürür -- ikinci
çağrının etkisi, ilk çağrının etkisiyle birebir aynı, yani `POST` artık
efektif olarak idempotent.

## HATEOAS Nedir? (Kısa Bakış)

HATEOAS, bir yanıtın yalnızca veri değil, istemcinin **sıradaki adımlarını**
da taşımasıdır:

{{HateoasConceptExample.java}}

İstemci, `next` linkini takip ederken bu projenin URL şemasını
(`/api/topics/{slug}`) hiç bilmek zorunda kalmaz -- sunucunun verdiği linki
izler. Bu proje gerçek `spring-hateoas` kütüphanesini kullanmıyor (proje
bağımlılıklarında yok), bu yüzden yukarıdaki örnek elle kurulmuş bir `links`
map'i -- ama fikir, bu projenin kendi `topic.html`'inin
`previousTopic`/`nextTopic` ile yaptığının (bkz. Spring MVC Views ve Thymeleaf
dersi) JSON karşılığı: sunucu, "önceki"/"sonraki" neresi biliyor, istemcinin
bilmesine gerek yok.

## Best Practices

- **API'yi tüketen istemcinin hiç görmemesi gereken alanları (şifre hash'i, iç
  notlar, dahili ID'ler) bir DTO ile açıkça filtrele** -- entity'yi doğrudan
  döndürmek bunu unutmayı kolaylaştırır (bkz. "Entity'yi Doğrudan Dışarı
  Vermenin Riskleri: Neden DTO?").
- **Sayfalanmış yanıtları kendi kontrolündeki bir DTO'yla sarmala, `Page<T>`'i
  doğrudan döndürme** -- Spring Data'nın kendisi bunu önerir (bkz.
  "Sayfalanmış Yanıtın Şekli: content, totalElements, totalPages").
- **Versioning stratejini API'nin başından (ya da en azından ilk kırıcı
  değişiklikten önce) seç ve tutarlı uygula** -- yarı yolda URI'den header'a
  (ya da tersine) geçmek, mevcut tüm istemcileri kırar (bkz. "API Versioning:
  URI Versioning vs Header Versioning").
- **Yan etkisi olan (ödeme, sipariş oluşturma gibi) `POST` endpoint'lerinde
  `Idempotency-Key`'i ciddiye al** -- ağ zaman aşımları gerçek ve sık; bu
  desen olmadan bir tekrar deneme, çift ücretlendirme gibi somut kullanıcı
  zararlarına yol açabilir (bkz. "Idempotency-Key Header'ı ile POST'u
  Idempotent Yapmak").

## Yaygın Hatalar

**1. Entity'yi "şimdilik" doğrudan döndürüp DTO'yu sonraya bırakmak.** Bir kez
istemciler entity'nin şekline bağımlı hâle geldikten sonra, aradan bir DTO
eklemek geriye dönük uyumluluğu bozan bir değişikliğe dönüşür -- DTO'yu en
başından kurmak, sonradan eklemekten çok daha ucuzdur (bkz. "Entity'yi
Doğrudan Dışarı Vermenin Riskleri: Neden DTO?").

**2. Sayfalama parametrelerini (`page`, `size`, `sort`) elle `@RequestParam`
ile okuyup `Pageable`'ı hiç kullanmamak.** Bu, Spring'in zaten çözdüğü bir
sorunu yeniden çözmek demektir -- `Pageable` parametresi aynı işi, doğrulama
ve varsayılan değerlerle birlikte, tek satırda yapar (bkz. "Sayfalama
(Pagination): Pageable ve Page<T>").

**3. Filtre parametrelerinin `null` olabileceğini unutup doğrudan
`.equals(...)` çağırmak.** `category.equals(t.category())` gibi bir kod,
`category` sağlanmadığında `NullPointerException` fırlatır -- her opsiyonel
filtre, "sağlanmadıysa etkisiz" davranışını açıkça ifade etmeli (bkz.
"Filtreleme: Query Parametreleriyle Dinamik Sorgu").

**4. URI versioning ile header versioning'i aynı API içinde karıştırmak.**
Bazı endpoint'ler `/api/v1/...`, bazıları `Api-Version` header'ı kullanırsa,
istemci için hangi stratejinin geçerli olduğunu tahmin etmek zorlaşır -- bir
API tek bir stratejide tutarlı kalmalı (bkz. "API Versioning: URI Versioning
vs Header Versioning").

**5. `Idempotency-Key`'i sunucu tarafında süresiz saklamak.** Gerçek bir
uygulamada anahtarlar bir süre sonra (örneğin 24 saat) temizlenmeli --
aksi hâlde bellek/depolama sınırsız büyür; bu örnekteki `Map`, süre sonu
mantığı olmadan yalnızca fikri gösteriyor (bkz. "Idempotency-Key Header'ı ile
POST'u Idempotent Yapmak").

**6. HATEOAS linklerini yalnızca dokümantasyonda tanımlayıp yanıta hiç
koymamak.** HATEOAS'ın bütün amacı, istemcinin dokümantasyona değil **yanıtın
kendisine** bakarak sıradaki adımı bulabilmesi -- yalnızca dokümante edilmiş
ama yanıtta olmayan bir link, HATEOAS değil, sıradan bir API sözleşmesidir
(bkz. "HATEOAS Nedir? (Kısa Bakış)").

## Özet, Cheat Sheet ve Terimler Sözlüğü

REST API tasarımı, tek bir endpoint'in doğru çalışmasının ötesinde, bir
API'nin **bütününün** tutarlı, öngörülebilir ve geriye dönük uyumlu
kalmasıyla ilgili. Öne çıkan noktalar:

- DTO: API sözleşmesini entity'nin iç yapısından ayıran, istek/yanıt için ayrı
  şekiller tanımlayan desen
- `Pageable`/`Page<T>`/`Sort`: sayfalama ve sıralamanın Spring Data'daki karşılığı,
  query parametrelerinden otomatik çözülür
- Filtreleme: her query parametresi opsiyonel, sağlanmadığında sonucu
  etkilemeyen bir predicate
- `PagedResponse<T>`: `Page<T>`'in kararsız iç yapısı yerine, projenin kendi
  kontrolündeki sayfalama şekli
- URI versioning: versiyon path'te (`/api/v1/...`) -- görünür ama kalıcı
- Header versioning: versiyon bir header'da (`Api-Version`) -- URL sabit
  kalır ama versiyon görünmez
- Idempotent: bir kez ya da N kez çağrılması aynı sonucu üreten işlem
  (`GET`/`PUT`/`DELETE` doğal olarak, `POST` değil)
- `Idempotency-Key`: istemcinin ürettiği, sunucunun "bu isteği daha önce
  işledim" diyebilmesini sağlayan header
- HATEOAS: yanıtın veri yanında istemcinin sıradaki adımlarını (linkler) de
  taşıması

Hızlı referans:

```java
@RestController
class TopicApiController {

    @GetMapping("/api/v1/topics")
    PagedResponse<TopicSummary> list(
            @RequestParam(required = false) String category,
            Pageable pageable) {
        // filtrele -> sayfala -> DTO'ya sarmala
        return PagedResponse.from(repository.findAll(pageable));
    }

    @PostMapping("/api/v1/orders")
    ResponseEntity<OrderResponse> createOrder(
            @RequestHeader("Idempotency-Key") String key,
            @RequestBody CreateOrderRequest request) {
        OrderResponse existing = seenKeys.get(key);
        if (existing != null) return ResponseEntity.ok(existing);
        // ... yeni kaynağı oluştur, seenKeys'e ekle ...
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
}
```

**Terimler Sözlüğü**

**DTO (Data Transfer Object)** — API sözleşmesi için tasarlanmış, veritabanı
entity'sinden bağımsız veri şekli.

**`Pageable`** — Sayfa numarası, boyutu ve sıralamayı taşıyan, query
parametrelerinden otomatik çözülen Spring Data arayüzü.

**`Page<T>`** — Bir sayfanın içeriğini (`content`) ve toplam eleman/sayfa
sayısını birlikte taşıyan Spring Data arayüzü.

**`Sort`** — Bir ya da daha fazla alana göre, yön (`ASC`/`DESC`) belirtilerek
sıralama tanımlayan Spring Data tipi.

**URI versioning** — API versiyonunun URL path'inin bir parçası olduğu
versiyonlama stratejisi.

**Header versioning** — API versiyonunun bir HTTP header'ıyla belirtildiği,
URL'in sabit kaldığı versiyonlama stratejisi.

**Idempotent** — Bir kez çağrılmasıyla N kez çağrılması aynı sonucu üreten
işlem.

**`Idempotency-Key`** — İstemcinin ürettiği, sunucunun bir isteği daha önce
işleyip işlemediğini anlamasını sağlayan HTTP header'ı.

**HATEOAS (Hypermedia as the Engine of Application State)** — Bir API
yanıtının, veri yanında istemcinin izleyebileceği linkleri de taşıması
gerektiğini söyleyen REST ilkesi.

## Ek: Mini Proje — Sayfalanmış ve Filtrelenmiş Konu Kataloğu API'si

Bu dersin üç veri şekillendirme mekaniğini (filtreleme, sayfalama/sıralama,
kararlı bir yanıt şekli) tek bir katalog endpoint'inde birleştiriyoruz:

{{PaginatedCatalogController.java}}

{{PaginatedCatalogDemo.java}}

`listTopics`, `@RequestParam(required = false) String category` ile opsiyonel
bir filtre, `Pageable` ile sayfalama/sıralama alıyor, ve sonucu
`PagedResponseShapeExample`'daki gibi kararlı bir `PagedResponse<T>`'e
sarmalıyor. `PaginatedCatalogDemo`, filtre uygulanmadan ve `category`
filtresiyle iki farklı çağrı yaparak, `totalElements`'in filtrelenmiş kümeyi
yansıttığını (tüm katalogu değil) gösteriyor.

## Ek: Mini Proje — Idempotency Key Destekli Sipariş Oluşturma

Son mini proje, DTO desenini `Idempotency-Key` mekanizmasıyla gerçek bir
`@PostMapping`/`ResponseEntity` üzerinde birleştiriyor:

{{IdempotentOrderController.java}}

{{IdempotentOrderDemo.java}}

`createOrder`, `CreateOrderRequest`/`OrderResponse` DTO çiftini kullanıyor,
`@RequestHeader("Idempotency-Key")` ile istemcinin anahtarını okuyor, ve daha
önce görülmemiş bir anahtar için `201 Created`, daha önce görülmüş bir anahtar
için `200 OK` (aynı gövdeyle) dönüyor. `IdempotentOrderDemo`, aynı anahtarla
yapılan bir "retry"ın aynı sipariş ID'sini döndürdüğünü, farklı bir anahtarın
ise gerçekten yeni bir sipariş yarattığını gösteriyor.
