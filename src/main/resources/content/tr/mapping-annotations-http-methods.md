# Mapping Annotation'ları ve HTTP Metotları

Spring MVC Temelleri dersinde `@GetMapping`'i yalnızca yüzeysel gördük -- bir path'i
bir metoda bağlayan tek bir annotation olarak. Bu derste mapping annotation'larının
tüm ailesine (`@RequestMapping` ve beş kısayoluna), her birinin hangi HTTP metoduna
karşılık geldiğine ve HTTP metotlarının kendi anlamsal kurallarına (safe, idempotent)
giriyoruz. "Aynı Path, Farklı HTTP Metotları" bölümünde, Fundamentals dersindeki
`RequestRouterSimulation` mini projesinin uyarısında bıraktığımız eksiği -- HTTP
metodu ayrımı -- de tamamlayacağız.

## Mapping Annotation'ları Nedir?

Mapping annotation'ları, bir controller metodunun **hangi HTTP isteğine** yanıt
vereceğini bildiren annotation'lardır -- bir path (`"/users"`), isteğe bağlı bir HTTP
metodu, ve isteğe bağlı diğer koşullar (content type, header'lar) tanımlarlar:

```java
@Controller
class UserController {
    @GetMapping("/users")       // path: /users, HTTP metodu: GET
    public String list() { ... }
}
```

Bu tanım, Spring MVC Temelleri dersinde gördüğümüz `HandlerMapping`'in okuduğu tam
olarak bu bilgi -- "HandlerMapping ve HandlerAdapter: DispatcherServlet'in İçinde
Neler Oluyor?" bölümündeki `buildHandlerMapping` simülasyonumuzun, gerçek Spring'de
karşılık geldiği mekanizma.

## Neden Var?

Mapping annotation'ları olmasaydı, DispatcherServlet'e "bu path'e, bu HTTP metoduyla
gelen istek, şu metoda gitsin" bilgisini başka bir yerden (XML, elle yazılmış bir
routing tablosu) vermek gerekirdi -- Spring MVC Temelleri dersinin "Tarihçe"
bölümünde bahsettiğimiz, 2004'teki XML tabanlı `<bean>` eşlemeleri tam olarak buydu.
Annotation'lar bu bilgiyi, metodun **kendi üzerinde**, kodun yanında tutar -- yeni bir
endpoint eklemek, yeni bir metot yazıp üzerine annotation koymaktan ibarettir.

## Tarihçe

Spring MVC Temelleri dersinin "Tarihçe" bölümünde bu ailenin genel zaman çizelgesini
görmüştük: `@RequestMapping`, Spring 2.5 (2007) ile geldi; `@GetMapping` gibi
kısayollar ise çok daha sonra, Spring 4.3 (2016) ile eklendi. Aradaki dokuz yılda
geliştiriciler `@RequestMapping(method = RequestMethod.GET)` yazmak zorundaydı --
tekrarlayıcı ve `method` parametresini unutmaya açık (unutulduğunda mapping, **her**
HTTP metodunu kabul eder, bu da "Desteklenmeyen Bir HTTP Metodu İstendiğinde: 405
Method Not Allowed" bölümünde göreceğimiz hatayı gizler). Spring 4.3, beş HTTP metodu
için beş kısayol (`@GetMapping`, `@PostMapping`, `@PutMapping`, `@PatchMapping`,
`@DeleteMapping`) ekleyerek bu tekrarı ortadan kaldırdı.

## @RequestMapping: Temel Mapping Annotation'ı

Aile ağacının kökü `@RequestMapping`'dir -- `method` attribute'u ile herhangi bir HTTP
metodunu (ya da hiçbirini belirtmeyip hepsini) eşleyebilir:

{{RequestMappingBaseExample.java}}

`method` verilmediğinde, `@RequestMapping` path'e gelen **her** HTTP metodunu kabul
eder -- `anyMethod()` hem `GET` hem `POST` hem `DELETE` isteğine yanıt verir. Bu
nadiren istenen bir davranıştır; "HTTP Metodu ile CRUD İşlemleri Arasındaki Eşleme"
bölümünde göreceğimiz gibi, her HTTP metodunun kendine has bir anlamı vardır ve bunu
belirsiz bırakmak genelde bir tasarım hatasıdır.

## @GetMapping, @PostMapping ve Diğer Kısayollar

Beş kısayol annotation'ı, `@RequestMapping`'in üzerine kurulu birer meta-annotation'dır
-- her biri `method` attribute'unu senin için önceden doldurur:

{{ShortcutMappingAnnotationsExample.java}}

`@GetMapping("/users")`, tam olarak
`@RequestMapping(path = "/users", method = RequestMethod.GET)` ile aynı şeydir --
yalnızca daha kısa ve niyeti ilk bakışta netleştiriyor. Gerçek bir kaynak (`resource`)
controller'ı, tipik olarak bu beşinden birer tane taşır -- listeleme, oluşturma, tam
güncelleme, kısmi güncelleme, silme.

## Sınıf ve Metot Seviyesinde @RequestMapping'i Birleştirmek

`@RequestMapping`, sınıf seviyesinde kullanıldığında bir **ortak önek** tanımlar --
sınıf içindeki her metot, kendi path'ini bu önekin devamı olarak tanımlar:

{{ClassLevelRequestMappingExample.java}}

Bu, bu projenin kendi `TopicController`'ının kullandığı desenin ta kendisi -- Spring
MVC Temelleri dersinin "Bu Projenin Kendi Controller'ları: Gerçek Bir Spring MVC
Örneği" bölümünde bıraktığımız sözü burada tutuyoruz; ayrıntısını "Bu Projenin Kendi
Mapping'leri: Gerçek Bir Örnek" bölümünde göreceğiz. `search()` metodunun path'i
(`/users/search`), `getOne()`'ın path variable'lı path'iyle (`/users/{id}`)
çakışmaz -- Spring'in path eşleştirmesi, **sabit (literal) segmentleri her zaman
değişken segmentlerden daha spesifik sayar**, tanımlama sırası önemli değildir.

## Content Type Belirtmek: consumes ve produces

Bir mapping, yalnızca path ve HTTP metoduyla değil, **hangi içerik türünü kabul
ettiği/ürettiği** ile de daraltılabilir:

{{ConsumesProducesExample.java}}

Aynı path (`/orders`) ve aynı HTTP metodu (`POST`) burada **iki kez** tanımlı --
`consumes`/`produces` sayesinde çakışmıyorlar, çünkü DispatcherServlet, isteğin
`Content-Type`/`Accept` header'larına bakarak hangisinin devreye gireceğine karar
verir. `@RequestBody` burada örneği gerçekçi tutmak için kullanıldı; kendisini
ayrıntısıyla ileriki bir derste (Request & Response Handling) göreceğiz.

## HTTP Metotları: Safe ve Idempotent Kavramları

HTTP spesifikasyonu, her metoda iki önemli özellik atfeder: **safe** (sunucu
durumunu değiştirmemeli) ve **idempotent** (bir kez ya da yüz kez çağırmak, sonucu
aynı bırakmalı). `GET`'in ikisi de olması **zorunludur**:

{{SafeAndIdempotentExample.java}}

`viewArticle()` (GET) kaç kez çağrılırsa çağrılsın `views` değişmiyor -- safe.
`recordView()` (POST) ise her çağrıda durumu değiştiriyor -- ne safe ne idempotent.
Bu ayrım, "PUT vs PATCH: Tam Güncelleme vs Kısmi Güncelleme" ve "DELETE ve
Idempotency" bölümlerinde her metodu tek tek değerlendirirken referans noktamız
olacak.

## Aynı Path, Farklı HTTP Metotları

Spring MVC Temelleri dersinin son mini projesindeki uyarıyı hatırla:
`RequestRouterSimulation`, yalnızca path'e bakıyordu, aynı path'e farklı HTTP
metotlarıyla gelen istekleri ayıramıyordu. Bunu şimdi düzeltiyoruz:

{{HttpMethodDisambiguationExample.java}}

`RouteKey` artık yalnızca path değil, `(path, method)` **çiftini** anahtar olarak
kullanıyor -- `/article`'a gelen bir `GET`, `view()`'a; aynı path'e gelen bir `POST`,
`publish()`'e gidiyor. Eşleşen bir `(path, method)` çifti yoksa (`DELETE /article`
gibi), gerçek Spring'in de döneceği yanıt tam olarak bunun karşılığı: **405 Method Not
Allowed** -- 404 değil, çünkü path'in kendisi var, sadece o HTTP metodunda değil.

## PUT vs PATCH: Tam Güncelleme vs Kısmi Güncelleme

İkisi de "güncelleme" anlamına gelir, ama farklı sözleşmelerle: `PUT`, kaynağın
**tamamını** yeni haliyle değiştirir (gönderilmeyen alanlar kaybolur); `PATCH`,
yalnızca gönderilen alanları günceller:

{{PutVsPatchExample.java}}

`update()` (PATCH) yalnızca `city`'yi değiştiriyor, `name` dokunulmadan kalıyor.
`replace()` (PUT) ise `profile.clear()` ile önce her şeyi siliyor, sonra yalnızca
gönderilen alanları geri koyuyor -- `name` gönderilmediği için tamamen kayboluyor. Bu
karışıklık, API tasarımında en sık karşılaşılan hata kaynaklarından biri: PATCH
isteği bekleyen bir istemcinin, yanlışlıkla PUT çağırıp diğer alanları silmesi.

## DELETE ve Idempotency

`DELETE`, "HTTP Metotları: Safe ve Idempotent Kavramları" bölümündeki tanıma göre
idempotent olmalıdır -- ama bunun ne anlama geldiği ilk bakışta göründüğünden daha
ince bir noktadır:

{{DeleteIdempotencyExample.java}}

İlk `delete(1L)` çağrısı `204 No Content` döner (kitap gerçekten silindi), ikinci
çağrı `404 Not Found` döner (kitap zaten yok) -- **iki farklı HTTP durum kodu**. Yine
de idempotent'tir, çünkü idempotency HTTP durum kodunun aynı kalmasını değil,
**sunucudaki nihai durumun** aynı kalmasını gerektirir -- her iki çağrıdan sonra da
kitap 1 veritabanında yok.

## HTTP Metodu ile CRUD İşlemleri Arasındaki Eşleme

Gördüğümüz beş HTTP metodu, CRUD (Create/Read/Update/Delete) işlemleriyle şu şekilde
eşlenir:

- **GET** → Read (safe + idempotent) -- "HTTP Metotları: Safe ve Idempotent
  Kavramları" bölümünde gördüğümüz `viewArticle()`
- **POST** → Create (ne safe ne idempotent) -- her çağrı yeni bir kaynak yaratır ya da
  durumu değiştirir
- **PUT** → Update, tam değiştirme (idempotent, safe değil) -- aynı `PUT` isteğini iki
  kez göndermek, kaynağı ilk seferkiyle aynı son duruma getirir
- **PATCH** → Update, kısmi değiştirme (genelde idempotent kabul edilir, ama HTTP
  spesifikasyonu bunu garanti etmez -- "alanı 1 artır" gibi bir PATCH idempotent
  olmaz)
- **DELETE** → Delete (idempotent, safe değil) -- "DELETE ve Idempotency"
  bölümünde gördüğümüz gibi, durum kodu değişse de nihai durum sabit kalır

## Desteklenmeyen Bir HTTP Metodu İstendiğinde: 405 Method Not Allowed

"Aynı Path, Farklı HTTP Metotları" bölümündeki simülasyonumuzun ürettiği
`"405 Method Not Allowed"` mesajı, uydurma bir davranış değil -- gerçek
DispatcherServlet'in yaptığı tam olarak bu: bir path için **en az bir** mapping
bulunuyorsa ama istenen HTTP metoduyla eşleşen yoksa, 404 (path yok) değil,
**405** (path var, bu metotla değil) döner. Bu ayrım önemlidir -- bir istemci 405
aldığında, path'i doğru yazdığını ama yanlış HTTP metodunu kullandığını anlayabilir;
404'te bu bilgiyi kaybeder.

## Bu Projenin Kendi Mapping'leri: Gerçek Bir Örnek

Bu dersteki mekanizmaları, projenin kendi kaynak kodunda görebilirsin.
`HomeController`, sınıf seviyesinde hiçbir `@RequestMapping` taşımaz -- iki
endpoint'i (`@GetMapping("/")` ve `@GetMapping("/{lang:en|tr}")`) ortak bir literal
önek paylaşmadığı için zaten paylaşılacak bir şey yok. `TopicController` ise bir
zamanlar "Sınıf ve Metot Seviyesinde @RequestMapping'i Birleştirmek" bölümünün ders
kitabı örneğiydi -- sınıf seviyesinde `@RequestMapping("/topics")`, metot seviyesinde
`@GetMapping("/{slug}")` -- ta ki ikinci bir mapping şekli (eski URL'leri
yönlendiren `/topics/{slug}`, gerçek `/{lang:en|tr}/topics/{slug}`'in yanına)
eklenip artık ilkiyle tek bir sınıf-seviyesi önek paylaşamayana kadar. O noktada
sınıf seviyesindeki `@RequestMapping` kaldırıldı, her metot artık kendi tam path'ini
tanımlıyor -- paylaşılan bir önekin ne zaman kendini amorti etmekten çıktığına dair
gerçek, küçük bir örnek. Her iki controller de yalnızca `GET` isteklerine yanıt verir
-- bu proje şu an salt-okunur bir içerik sitesi olduğu için `POST`/`PUT`/`PATCH`/
`DELETE` hiç kullanılmıyor; bu kategorinin sonraki konularında (Request & Response
Handling, REST API Design) bu diğer metotları gerektirecek bir JSON API senaryosunu
ele alacağız.

## Best Practices

- **Her zaman en spesifik kısayolu kullan, çıplak `@RequestMapping`'i yalnızca
  gerçekten birden fazla HTTP metodu kabul etmen gerektiğinde tercih et** -- `method`
  belirtmeden bırakılan bir `@RequestMapping`, "Tarihçe" bölümünde bahsettiğimiz gibi
  her metodu sessizce kabul eder, bu genelde istenmeyen bir davranıştır.
- **HTTP metodunun anlamına sadık kal: GET'te veri değiştirme, DELETE'te idempotent
  ol** -- "HTTP Metotları: Safe ve Idempotent Kavramları" bölümündeki kurallara
  uymayan bir API, önbellekleme/retry gibi HTTP altyapısının varsaydığı davranışları
  bozar.
- **PUT ile PATCH'i birbirinin yerine kullanma** -- "PUT vs PATCH: Tam Güncelleme vs
  Kısmi Güncelleme" bölümünde gördüğümüz gibi, yanlış seçim istemeden veri kaybına
  yol açabilir.
- **Ortak bir path öneki olan endpoint'lerde sınıf seviyesinde `@RequestMapping`
  kullan** -- bu projenin kendi `TopicController`'ının yaptığı gibi (bkz. "Bu
  Projenin Kendi Mapping'leri: Gerçek Bir Örnek"), her metotta öneki tekrar yazmak
  yerine.

## Yaygın Hatalar

**1. `@RequestMapping`'e `method` yazmayı unutup, mapping'in yalnızca beklenen HTTP
metoduna yanıt verdiğini sanmak.** `method` verilmezse **her** HTTP metodu kabul
edilir -- bu, yanlışlıkla bir `DELETE` isteğinin bir "salt okunur" endpoint'e
ulaşmasına izin verebilir (bkz. "@RequestMapping: Temel Mapping Annotation'ı").

**2. `/users/{id}` ile `/users/search` gibi bir literal path'in çakışacağını
düşünüp, tanımlama sırasını değiştirerek "düzeltmeye" çalışmak.** Spring, literal
segmentleri her zaman değişken segmentlerden daha spesifik sayar -- sıralama hiç
önemli değildir (bkz. "Sınıf ve Metot Seviyesinde @RequestMapping'i Birleştirmek").

**3. GET ile veri değiştiren bir endpoint yazmak ("kolay test edilsin" diye
tarayıcıdan tıklanabilir bir silme linki gibi).** Bu, GET'in safe olması gerektiği
kuralını çiğner -- bir önbellek, bir bot ya da bir tarayıcı ön-yükleme özelliği bu
GET isteğini beklenmedik şekilde tekrar tetikleyebilir (bkz. "HTTP Metotları: Safe ve
Idempotent Kavramları").

**4. PATCH isteği gönderirken PUT semantiğini beklemek (yani gönderilmeyen alanların
korunacağını değil, silineceğini sanmak) ya da tam tersi.** İkisinin sözleşmesi
kasıtlı olarak farklıdır -- hangisinin çağrıldığı, gönderilmeyen alanların akıbetini
belirler (bkz. "PUT vs PATCH: Tam Güncelleme vs Kısmi Güncelleme").

**5. DELETE'in idempotent olmasını, "ikinci çağrı da aynı durum kodunu döner" diye
yanlış yorumlamak.** İdempotency, durum kodunun değil, **sunucudaki nihai durumun**
aynı kalmasıyla ilgilidir -- ilk çağrı 204, ikincisi 404 dönebilir, ikisi de
idempotent'tir (bkz. "DELETE ve Idempotency").

**6. Desteklenmeyen bir HTTP metoduyla gelen isteğe 404 dönmesini beklemek.** Path
gerçekten mevcutsa ama o HTTP metoduyla eşleşen bir mapping yoksa, doğru yanıt 405'tir
-- 404, path'in kendisinin hiç bulunamadığı durumlar içindir (bkz. "Desteklenmeyen Bir
HTTP Metodu İstendiğinde: 405 Method Not Allowed").

## Özet, Cheat Sheet ve Terimler Sözlüğü

Mapping annotation'ları, bir controller metodunu path + HTTP metodu (+ isteğe bağlı
content type) kombinasyonuna bağlar; her HTTP metodunun kendine has safe/idempotent
kuralları vardır. Öne çıkan noktalar:

- `@RequestMapping`: temel annotation, `method` verilmezse her HTTP metodunu kabul
  eder
- `@GetMapping`/`@PostMapping`/`@PutMapping`/`@PatchMapping`/`@DeleteMapping`: beş
  HTTP metodu için kısayollar, `@RequestMapping(method=...)`'in meta-annotation'ları
- Sınıf seviyesinde `@RequestMapping`: ortak path öneki, metot seviyesindeki path'lerle
  birleşir
- `consumes`/`produces`: aynı path + HTTP metodu kombinasyonunu, content type'a göre
  ayrıştırır
- Safe: sunucu durumunu değiştirmez (yalnızca GET zorunlu)
- Idempotent: N kez çağırmak, 1 kez çağırmakla aynı **nihai durumu** üretir (GET,
  PUT, DELETE zorunlu; POST değil; PATCH garantili değil)
- 405 Method Not Allowed: path var ama bu HTTP metoduyla mapping yok (404'ten farklı)

Hızlı referans:

```java
@RequestMapping(path = "/x", method = RequestMethod.GET)  // temel form
@GetMapping("/x")           // kısayolu -- ikisi eşdeğer

@RequestMapping("/users")   // sınıf seviyesinde ortak önek
class UserController {
    @GetMapping                    // GET /users
    @GetMapping("/{id}")           // GET /users/{id}
    @PostMapping                   // POST /users
    @PutMapping("/{id}")           // PUT /users/{id}     -- tam değiştirme
    @PatchMapping("/{id}")         // PATCH /users/{id}   -- kısmi değiştirme
    @DeleteMapping("/{id}")        // DELETE /users/{id}  -- idempotent
}

@PostMapping(path = "/orders", consumes = MediaType.APPLICATION_JSON_VALUE)
// yalnızca Content-Type: application/json olan isteklerle eşleşir
```

**Terimler Sözlüğü**

**Mapping annotation** — Bir controller metodunu, bir path + HTTP metodu (+ isteğe
bağlı diğer koşullar) kombinasyonuna bağlayan annotation ailesi.

**`@RequestMapping`** — Ailenin temel annotation'ı; `method` attribute'uyla herhangi
bir HTTP metodunu eşleyebilir, verilmezse hepsini kabul eder.

**Meta-annotation** — Başka bir annotation'ın üzerine kurulu, onu belirli bir
attribute değeriyle önceden yapılandıran annotation (`@GetMapping`,
`@RequestMapping(method=GET)`'in meta-annotation'ıdır).

**Safe (HTTP metodu)** — Çağrıldığında sunucu durumunu değiştirmeyen HTTP metodu
özelliği; yalnızca GET (ve HEAD/OPTIONS) için zorunludur.

**Idempotent (HTTP metodu)** — N kez çağrıldığında, sunucudaki nihai durumun 1 kez
çağrılmışçasına aynı kalmasını garanti eden HTTP metodu özelliği.

**405 Method Not Allowed** — Path'in var olduğu ama istenen HTTP metoduyla eşleşen
bir mapping bulunamadığı durumda dönen HTTP durum kodu.

**`consumes`/`produces`** — Bir mapping'i, isteğin `Content-Type`/`Accept`
header'larına göre daraltan mapping annotation attribute'ları.

## Ek: Mini Proje — Basit Bir Kitap CRUD API'si

Bu dersteki her annotation'ı, tek bir controller'da, gerçek bir kaynak üzerinde bir
araya getiriyoruz:

{{BookCrudController.java}}

{{BookCrudDemo.java}}

`BookCrudController`, "Sınıf ve Metot Seviyesinde @RequestMapping'i Birleştirmek"
bölümünde gördüğümüz sınıf seviyesi önek deseniyle (`@RequestMapping("/api/books")`)
başlıyor; `list()`/`getOne()`/`create()`/`replace()`/`delete()`, sırasıyla
`@GetMapping`/`@GetMapping("/{id}")`/`@PostMapping`/`@PutMapping("/{id}")`/
`@DeleteMapping("/{id}")` ile beş CRUD işlemini kapsıyor. `BookCrudDemo`, "Spring MVC
Temelleri" dersindeki `ProductCatalogDemo`'da yaptığımız gibi, gerçek bir
DispatcherServlet olmadan controller metotlarını doğrudan çağırarak tüm akışı
(oluştur → listele → güncelle → sil → tekrar sorgula) uçtan uca çalıştırıyor.

## Ek: Mini Proje — HTTP Metodu Duyarlı Bir Router Simülasyonu

Son mini proje, Spring MVC Temelleri dersindeki `RequestRouterSimulation`'ı,
"Aynı Path, Farklı HTTP Metotları" bölümünde tanıttığımız `(path, method)` anahtarıyla
birleştiriyor:

{{RouterWithMethodSimulation.java}}

{{RouterWithMethodDemo.java}}

`RouterWithMethodSimulation.register(...)`, artık `@GetMapping`, `@PostMapping` ve
`@DeleteMapping`'in **üçünü de** okuyup aynı registry'ye, `RouteKey(path, method)`
anahtarıyla ekliyor. `ArticleApiHandlers` ve `CommentApiHandlers` birbirinden
habersiz iki ayrı "controller", ama `dispatch(...)` ikisini de tek bir yerden, hem
path hem HTTP metoduna göre doğru şekilde buluyor -- Fundamentals dersindeki mini
projenin bıraktığı eksiğin tam çözümü.

> 💡 Tip
> `dispatch("/articles", RequestMethod.DELETE)` çağrısının `"405 Method Not Allowed"`
> dönmesine dikkat et -- `/articles` path'i registry'de var (`GET` ve `POST` için),
> ama `DELETE` için yok. Bu, "Desteklenmeyen Bir HTTP Metodu İstendiğinde: 405 Method
> Not Allowed" bölümünde gördüğümüz 404/405 ayrımının, elle yazılmış bir simülasyonda
> bile doğal olarak ortaya çıktığını gösteriyor.
