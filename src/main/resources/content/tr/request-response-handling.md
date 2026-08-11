# Request ve Response Handling

Spring MVC Temelleri dersinde `@ResponseBody`/`@RestController`'ın bir nesneyi
otomatik olarak JSON'a çevirdiğini görmüştük, Mapping Annotation'ları dersinde
`consumes`/`produces`'ı tanımıştık. Bu derste bu mekanizmaların **perde arkasına**
iniyoruz: `@RequestBody`'nin bir JSON gövdesini nasıl bir Java nesnesine çevirdiğini,
`ResponseEntity` ile yanıtı tam olarak nasıl kontrol edeceğini, HTTP durum
kodlarının her birinin ne zaman kullanılacağını, ve content negotiation'ın istemci
ile sunucu arasında nasıl bir "anlaşma" olduğunu.

## Request ve Response Handling Nedir?

Bir HTTP isteğinin ve yanıtının, path/query string/header'ların ötesinde bir de
**gövdesi** (body) vardır -- genelde JSON, isteğe göre XML ya da başka bir format.
`@RequestBody` bu gövdeyi okur, `@ResponseBody`/`ResponseEntity` gövdeyi yazar:

```java
@PostMapping("/users")
public ResponseEntity<User> create(@RequestBody CreateUserRequest request) {
    // request, isteğin JSON gövdesinden otomatik dolduruldu
    User created = ...;
    return ResponseEntity.status(HttpStatus.CREATED).body(created);
    // created, yanıtın JSON gövdesine otomatik yazılacak
}
```

## Neden Var?

Path variable'lar ve query parametreleri (bir önceki derste gördüğümüz gibi) tek tek,
adlandırılmış değerler taşımak için idealdir -- ama karmaşık, iç içe yapılar (bir
adres, birden fazla alan içeren bir sipariş) için pratik değildir; her alan için ayrı
bir `@RequestParam` yazmak gerekirdi. Gövde, tüm bu veriyi **tek bir yapılandırılmış
belge** olarak taşımanın yolu. Benzer şekilde, dönüş değerini olduğu gibi (200 OK,
JSON) döndürmek çoğu durumda yeterlidir, ama gerçek bir API'nin durum kodunu,
header'larını (`Location`, özel header'lar) ve içerik türünü isteğe göre ayarlaması
gerekir -- bu kontrolü `ResponseEntity` sağlar.

## Tarihçe

Spring MVC Temelleri dersinin "Tarihçe" bölümünde bahsettiğimiz gibi, `@RequestBody`
ve `@ResponseBody`, `@PathVariable` ile birlikte Spring 3.0'da (2009) geldi --
üçü de aynı hedefe hizmet ediyordu: REST tarzı, JSON tabanlı API'leri Spring MVC'nin
ilk günlerindeki view-odaklı (HTML döndüren) modelin yanında ilk sınıf vatandaş
yapmak. `ResponseEntity` de aynı dönemde eklendi -- yalnızca gövdeyi değil, durum
kodunu ve header'ları da tek bir nesnede taşıyabilen bir sarmalayıcı olarak.

## @RequestBody: İstek Gövdesini Nesneye Çevirmek

`@RequestBody`, isteğin **tüm** gövdesini okuyup bir Java nesnesine çevirir --
`@RequestParam`/`@PathVariable`'ın aksine, tek bir adlandırılmış değeri değil,
gövdenin tamamını hedefler:

{{RequestBodyBasicExample.java}}

İstek gövdesindeki `{"name": "...", "email": "..."}` JSON'ı, `CreateUserRequest`
record'unun alanlarına isim eşleşmesiyle otomatik dolduruluyor. Bu dönüşümü kimin
yaptığını "HttpMessageConverter: @RequestBody/@ResponseBody'nin Perde Arkası"
bölümünde göreceğiz.

## HttpMessageConverter: @RequestBody/@ResponseBody'nin Perde Arkası

`@RequestBody`/`@ResponseBody`, JSON dönüşümünü kendileri yapmaz -- bir
`HttpMessageConverter`'a devrederler; JSON için bu converter, doğrudan burada
kullandığımız Jackson `ObjectMapper`'ın kendisidir:

{{HttpMessageConverterExample.java}}

`spring-boot-starter-web`, bu converter'ı otomatik olarak yapılandırıp bir bean
olarak kaydeder -- Spring Boot Auto-Configuration & Properties dersinde gördüğümüz
auto-configuration mekanizmasının bir başka örneği. Gerçek bir istekte
`mapper.readValue(...)`'ı sen çağırmazsın, DispatcherServlet senin adına çağırır;
burada gördüğün, her isteğin/yanıtın arkasında gerçekleşenin birebir aynısı.

## İç İçe Nesneler ve Listelerin Deserialize Edilmesi

`@RequestBody`, düz (flat) nesnelerle sınırlı değil -- Jackson, her seviyede eşleşen
bir Java tipi olduğu sürece iç içe nesneleri ve listeleri de özyinelemeli olarak
deserialize eder:

{{NestedObjectDeserializationExample.java}}

`OrderRequest`'in içindeki `shippingAddress` (bir `Address` nesnesi) ve `items`
(bir `List<String>`), tek bir `readValue(...)` çağrısıyla, hiçbir elle yazılmış
dönüşüm kodu olmadan tam olarak dolduruluyor -- Jackson, JSON'ın yapısını Java
tipinin yapısıyla adım adım eşliyor.

## Eksik ya da Fazla Alanlar: Jackson Nasıl Davranır?

JSON'da eksik olan bir alanla, JSON'da olup Java tarafında karşılığı olmayan fazla
bir alan, Jackson'da çok farklı iki davranışa yol açar:

{{UnknownFieldsToleranceExample.java}}

`email` alanı eksik olduğunda, hiçbir hata olmadan sessizce `null` atanıyor.
`age` diye bilinmeyen bir alan geldiğinde ise `UnrecognizedPropertyException`
fırlatılıyor -- Jackson'ın varsayılan ayarı, tanımadığı alanları **reddetmek**tir.
Eksik alanlar için hiçbir "zorunlu" kontrolü yoktur -- bunu Bean Validation
sağlıyor, bir sonraki derste (Validation & Exception Handling) ele alacağımız konu.

## ResponseEntity: Yanıtı Tam Kontrol Etmek

Düz bir nesne döndürmek her zaman `200 OK` gönderir. `ResponseEntity`, gövdeyle
birlikte durum kodunun tam kontrolünü sağlar:

{{ResponseEntityBasicExample.java}}

Ürün bulunduğunda `ResponseEntity.ok(name)` ile `200`, bulunamadığında
`ResponseEntity.status(HttpStatus.NOT_FOUND).build()` ile `404` dönüyor -- aynı
metot, koşula göre iki farklı durum kodu üretebiliyor; bu, düz bir dönüş değeriyle
mümkün olmayan bir esneklik.

## ResponseEntity ile Header Eklemek

`ResponseEntity`'nin builder'ı, durum koduyla birlikte header da ekleyebilir -- en
yaygın örnek, yeni oluşturulan bir kaynağın adresini bildiren `Location`:

{{ResponseEntityHeadersExample.java}}

`ResponseEntity.created(location)`, hem `201 Created` durumunu hem de `Location`
header'ını tek satırda ayarlıyor; `.header(...)` ile ek, özel header'lar da
eklenebiliyor. İstemci, `Location` header'ından yeni kaynağın URL'sini okuyup
doğrudan ona gidebilir.

## HTTP Durum Kodları: Ne Zaman Hangisi

Durum kodları rastgele seçilmez -- her biri istemciye belirli, standartlaşmış bir
anlam iletir:

- **2xx**: istek başarıyla işlendi (bkz. "2xx Başarı Kodları: 200, 201, 204")
- **4xx**: istekte bir sorun var -- istemci bir şeyi düzeltmeli (bkz. "4xx İstemci
  Hataları: 400, 401, 403, 404, 409")
- **5xx**: istek geçerliydi ama sunucu tarafında bir hata oluştu (bkz. "5xx Sunucu
  Hataları: 500")

Bu üç kategoriyi ayırt etmek önemlidir: bir istemci 4xx aldığında isteğini
değiştirmeden tekrar denemenin anlamı yoktur (aynı hata tekrar oluşur); 5xx
aldığında ise -- isteğin kendisi geçerli olduğu için -- bir süre sonra tekrar
denemek makul olabilir.

## 2xx Başarı Kodları: 200, 201, 204

En sık karşılaşılan üç başarı kodu, farklı senaryolara karşılık gelir:

{{StatusCode2xxExample.java}}

`200 OK`, normal bir başarılı okuma/güncelleme (gövdeli). `201 Created`, yeni bir
kaynak oluşturuldu (genelde "ResponseEntity ile Header Eklemek" bölümünde gördüğümüz
`Location` header'ıyla birlikte). `204 No Content`, işlem başarılı ama geri
gönderilecek bir gövde yok -- Mapping Annotation'ları dersindeki "DELETE ve
Idempotency" bölümünde de gördüğümüz kod.

## 4xx İstemci Hataları: 400, 401, 403, 404, 409

Beş yaygın 4xx kodu, `ResponseStatusException` ile (bu projenin kendi
`TopicController`'ının da kullandığı sınıf) fırlatılıyor:

{{StatusCode4xxExample.java}}

`400 Bad Request`: gövde/parametre geçersiz (`amount` negatif). `401 Unauthorized`:
istemci hiç kimlik doğrulamamış. `403 Forbidden`: istemci kimliği belli ama bu
kaynağa erişim yetkisi yok -- 401'den farkı, "kim olduğunu biliyoruz, yine de
izin yok" olması. `404 Not Found`: kaynak yok. `409 Conflict`: istek biçim
olarak geçerli, ama sunucudaki mevcut durumla çelişiyor (bakiyesi olan bir hesabı
kapatmaya çalışmak gibi).

## 5xx Sunucu Hataları: 500

4xx'in aksine, `500` genelde **kasıtlı olarak** döndürülmez -- kimsenin
yakalamadığı bir exception'a Spring'in verdiği varsayılan yanıttır:

{{StatusCode5xxExample.java}}

`ArithmeticException`, ne bir `ResponseStatusException` ne de (bir sonraki derste
göreceğimiz) bir `@ExceptionHandler` tarafından yakalanıyor -- DispatcherServlet'in
varsayılan hata işleyicisi devreye girip istemciye genel bir `500 Internal Server
Error` döndürüyor; exception'ın ayrıntıları yalnızca sunucu loglarında kalıyor,
istemciye hiç sızmıyor.

## Content Negotiation: Accept ile Temsil Seçmek

Content negotiation, istemci (`Accept` header'ıyla) ve sunucunun (`produces`
attribute'uyla), aynı kaynağın **hangi temsilini** değiş tokuş edeceği konusunda
anlaşmasıdır:

{{ContentNegotiationExample.java}}

Aynı path (`/products/1`) iki farklı `produces` değeriyle iki kez tanımlı --
`Accept: application/json` gönderen bir istemci `asJson()`'a, `Accept:
application/xml` gönderen bir istemci `asXml()`'e yönlendiriliyor. Bu, Mapping
Annotation'ları dersindeki `consumes`/`produces` bölümünün bir uzantısı -- orada
`consumes`, giden isteğin türünü; burada `produces`+`Accept`, dönen yanıtın türünü
belirliyor.

## Desteklenmeyen Bir Temsil İstendiğinde: 406 Not Acceptable

Bir istemci, sunucunun **hiçbir mapping'inin üretmediği** bir temsil isterse
(`Accept: text/csv` gibi, önceki bölümün örneğinde), DispatcherServlet `404` değil
`406 Not Acceptable` döner -- path var, ama istenen temsil hiçbir mapping'de yok.
Bu, Mapping Annotation'ları dersindeki "Desteklenmeyen Bir HTTP Metodu
İstendiğinde: 405 Method Not Allowed" bölümündeki mantığın bir başka boyutu: 404
(path yok), 405 (path var, metot yok), 406 (path ve metot var, temsil yok) --
üçü de "bir şey eksik ama tam olarak ne" sorusuna farklı, spesifik bir cevap verir.

## Bu Projenin Kendi Response'ları: Gerçek Bir Örnek

Bu dersteki mekanizmaları, `TopicController`'ın kendi kodunda görebilirsin --
proje şu an salt-okunur bir HTML sitesi olduğu için `@RequestBody`/`ResponseEntity`
kullanmıyor, ama "4xx İstemci Hataları: 400, 401, 403, 404, 409" bölümünde gördüğümüz `ResponseStatusException`
zaten gerçekten kullanılıyor:

```java
Topic topic = topicRepository.findBySlugWithCategoryAndCourse(slug)
        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Konu bulunamadı: " + slug));
// ...
throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Bilinmeyen dil: " + lang);
```

İlki, path variable'la (bir önceki dersin "Path Variable mi, Query Parameter mı? Ne
Zaman Hangisi" ayrımını hatırlarsak) kimliklendirilen bir kaynak bulunamadığında
`404`; ikincisi,
`lang` query parametresi açıkça verilmiş ama geçersiz bir değer taşıdığında `400`
döndürüyor -- ikisi de bu derste gördüğümüz kodlarla birebir aynı sınıfı, aynı
mekanizmayı kullanıyor.

## Best Practices

- **Gerçekten yeni bir kaynak oluşturduğunda `201` + `Location` header'ını kullan,
  yalnızca `200` ile yetinme** -- "ResponseEntity ile Header Eklemek" bölümünde
  gördüğümüz gibi, istemcinin yeni kaynağın adresini elle inşa etmesine gerek
  kalmaz.
- **401 ile 403'ü karıştırma** -- "4xx İstemci Hataları: 400, 401, 403, 404, 409" bölümünde gördüğümüz gibi,
  biri kimlik doğrulamanın hiç yapılmadığını, diğeri kimliğin bilindiğini ama
  yetkinin olmadığını ifade eder; bu ayrım istemcinin doğru aksiyonu almasını
  sağlar (401'de giriş yap, 403'te farklı bir hesap dene).
- **500'ü asla kasıtlı olarak döndürme** -- "5xx Sunucu Hataları: 500" bölümünde
  gördüğümüz gibi, bu kod "beklenmeyen bir hata oldu" anlamına gelir; beklenen her
  hata durumu bir `ResponseStatusException` (ya da bir sonraki derste göreceğimiz
  `@ExceptionHandler`) ile ele alınmalıdır.
- **`@RequestBody` ile gelen veriye asla körü körüne güvenme** -- "Eksik ya da
  Fazla Alanlar: Jackson Nasıl Davranır?" bölümünde gördüğümüz gibi, Jackson
  yalnızca **biçimi** doğrular
  (JSON geçerli mi, tipler uyuşuyor mu); iş kurallarını (pozitif miktar, boş
  olmayan isim gibi) doğrulamak sana kalır -- bir sonraki ders bu doğrulamayı
  otomatikleştiren `@Valid`'i tanıtacak.

## Yaygın Hatalar

**1. `@RequestBody`'nin, `@RequestParam` gibi tek bir alanı okuduğunu sanmak.**
`@RequestBody` **tüm** gövdeyi tek bir nesneye çevirir -- birden fazla `@RequestBody`
parametresi aynı metotta olamaz, çünkü gövde yalnızca bir kez okunabilir (bkz.
"@RequestBody: İstek Gövdesini Nesneye Çevirmek").

**2. Jackson'ın bilinmeyen JSON alanlarını sessizce yok sayacağını varsaymak.**
Varsayılan davranış tam tersi -- fazladan bir alan, isteği tamamen reddeder (bkz.
"Eksik ya da Fazla Alanlar: Jackson Nasıl Davranır?"). Bu varsayımla yazılmış bir
istemci kodu, sunucu tarafında yeni bir alan eklendiğinde beklenmedik `400`'lerle
karşılaşabilir.

**3. Her başarı durumunda düşünmeden `200` dönmek, `201`/`204`'ü hiç kullanmamak.**
"2xx Başarı Kodları: 200, 201, 204" bölümünde gördüğümüz ayrım, istemcinin (özellikle
otomatikleştirilmiş bir istemcinin) yanıtı doğru yorumlamasını sağlar -- bir
oluşturma isteğinin `200` mü `201` mi döndüğü, istemcinin davranışını değiştirebilir.

**4. Bir iş kuralı ihlalini (örn. bakiyesi olan hesabı kapatma) `400 Bad Request`
ile karıştırmak.** İstek biçim olarak tamamen geçerliyse ama sunucudaki mevcut
durumla çelişiyorsa, doğru kod `409 Conflict`'tir -- `400`, isteğin **kendisinin**
hatalı olduğu durumlar içindir (bkz. "4xx İstemci Hataları: 400, 401, 403, 404,
409").

**5. `Accept` header'ını yok sayıp her zaman aynı formatı (örn. sadece JSON)
döndürmek, sonra bir istemci XML beklediğinde neden `406` aldığını anlamamak.**
"Content Negotiation: Accept ile Temsil Seçmek" ve "Desteklenmeyen Bir Temsil İstendiğinde: 406 Not
Acceptable" bölümlerinde gördüğümüz gibi, `406`, sunucunun o path için hiçbir
`produces`'ının istenen `Accept` ile eşleşmediği anlamına gelir.

## Özet, Cheat Sheet ve Terimler Sözlüğü

Request ve response handling, bir HTTP isteğinin/yanıtının gövdesini okuma/yazma
(`@RequestBody`/`ResponseEntity`), hangi durum kodunun ne zaman kullanılacağı ve
istemci-sunucu arasındaki temsil anlaşmasıdır (content negotiation). Öne çıkan
noktalar:

- `@RequestBody`: isteğin tüm gövdesini bir Java nesnesine çevirir, bir
  `HttpMessageConverter` (JSON için Jackson `ObjectMapper`) aracılığıyla
- `ResponseEntity`: durum kodu + header'lar + gövdeyi tek bir nesnede taşır;
  `.ok()`, `.status(...)`, `.created(uri)`, `.noContent()` gibi builder metotları var
- Jackson, bilinmeyen JSON alanlarını **varsayılan olarak reddeder**, eksik
  alanlara ise sessizce `null` atar
- 2xx: başarı (200 okuma/güncelleme, 201 oluşturma, 204 gövdesiz başarı)
- 4xx: istemci hatası (400 geçersiz istek, 401 kimlik doğrulanmamış, 403 yetkisiz,
  404 bulunamadı, 409 çelişki)
- 5xx: sunucu hatası, genelde kasıtsız (500, yakalanmamış exception'ların
  varsayılanı)
- 406 Not Acceptable: path var ama `Accept` ile eşleşen bir `produces` yok

Hızlı referans:

```java
@PostMapping("/resource")
ResponseEntity<Void> create(@RequestBody CreateRequest request) {
    // ... doğrulama, kaydetme ...
    return ResponseEntity.created(URI.create("/resource/" + id)).build();  // 201
}

@GetMapping("/resource/{id}")
ResponseEntity<Resource> getOne(@PathVariable Long id) {
    Resource found = ...;
    return found != null
        ? ResponseEntity.ok(found)                                        // 200
        : ResponseEntity.status(HttpStatus.NOT_FOUND).build();            // 404
}

@DeleteMapping("/resource/{id}")
ResponseEntity<Void> delete(@PathVariable Long id) {
    // ...
    return ResponseEntity.noContent().build();                            // 204
}

// Herhangi bir yerden 4xx fırlatmak:
throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "sebep");
throw new ResponseStatusException(HttpStatus.CONFLICT, "sebep");
```

**Terimler Sözlüğü**

**`@RequestBody`** — Bir HTTP isteğinin tüm gövdesini bir Java nesnesine
deserialize eden annotation.

**`ResponseEntity`** — Durum kodu, header'lar ve gövdeyi tek bir nesnede taşıyan,
yanıt üzerinde tam kontrol sağlayan sarmalayıcı sınıf.

**`HttpMessageConverter`** — `@RequestBody`/`@ResponseBody`'nin, gövde ile Java
nesnesi arasındaki gerçek dönüşümü devrettiği bileşen (JSON için Jackson
`ObjectMapper` tabanlı).

**`ResponseStatusException`** — Bir controller metodunun herhangi bir yerinden
fırlatılarak DispatcherServlet'e belirli bir HTTP durum kodu döndürtmesini sağlayan
sınıf.

**Content negotiation** — İstemci (`Accept` header'ı) ve sunucunun (`produces`),
aynı kaynağın hangi temsilinin değiş tokuş edileceği konusunda anlaşması.

**404 Not Found** — İstenen kaynağın (path'in kendisinin) bulunamadığı durumda
dönen HTTP durum kodu.

**406 Not Acceptable** — Path var ama istemcinin `Accept` header'ıyla eşleşen bir
`produces` temsili olmadığında dönen HTTP durum kodu.

**409 Conflict** — İstek biçim olarak geçerli ama sunucudaki mevcut durumla
çeliştiğinde dönen HTTP durum kodu.

**500 Internal Server Error** — Hiçbir yerde yakalanmamış bir exception için
Spring'in döndürdüğü varsayılan HTTP durum kodu.

## Ek: Mini Proje — Sipariş Oluşturma API'si

Bu dersteki her mekanizmayı, gerçekçi bir sipariş oluşturma/okuma API'sinde bir
araya getiriyoruz:

{{OrderApiController.java}}

{{OrderApiDemo.java}}

`create(...)`, "Eksik ya da Fazla Alanlar: Jackson Nasıl Davranır?" bölümünde bahsettiğimiz manuel doğrulamayı
(`item`/`quantity` kontrolleri) yapıyor, geçersizse "4xx İstemci Hataları: 400, 401, 403, 404, 409"
bölümündeki `ResponseStatusException` ile `400` fırlatıyor; geçerliyse
"ResponseEntity ile Header Eklemek" bölümündeki desenle `201` + `Location`
döndürüyor. `OrderApiDemo`, hem başarı hem hata yollarını, gerçek bir
DispatcherServlet olmadan doğrudan metot çağrısıyla çalıştırıyor.

## Ek: Mini Proje — Elle Yazılmış Bir HttpMessageConverter Zinciri Simülasyonu

Son mini proje, "HttpMessageConverter: @RequestBody/@ResponseBody'nin Perde
Arkası" ve "Content Negotiation: Accept ile Temsil Seçmek" bölümlerini tek bir
mekanizmada birleştiriyor -- birden fazla converter'ın, `Accept`'e göre
seçilmesi:

{{MessageConverterSimulation.java}}

{{MessageConverterDemo.java}}

`writers` haritası, gerçek Spring'in `List<HttpMessageConverter<?>>`'ının minik bir
modeli -- her biri bir media type'ı "iddia ediyor". `write(...)`, `acceptHeader`'a
uyan bir converter bulamazsa "Desteklenmeyen Bir Temsil İstendiğinde: 406 Not
Acceptable" bölümünde gördüğümüz kodu üretiyor -- gerçek DispatcherServlet'in
yaptığı seçimin, elle yazılmış hâli.

> 💡 Tip
> `read(...)`'in `HttpMessageConverterExample`'daki `ObjectMapper` kullanımıyla,
> `write(...)`'ın da aynı örnekteki JSON dalıyla birebir aynı olduğuna dikkat et --
> bu mini proje yeni bir mekanizma icat etmiyor, dersin başından beri gördüğümüz
> parçaları tek bir "converter seçimi" akışında birleştiriyor.
