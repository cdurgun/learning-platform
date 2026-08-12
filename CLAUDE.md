# Proje Bağlamı: Learning Platform

Bu, Türkçe/İngilizce içerik sunan bir Java öğrenim sitesi. Aşağıdaki bağlamı okuyup
projeye bu kurallara **birebir uyarak** devam et.

## Teknoloji Yığını

Spring Boot 4.1, Java 21, Thymeleaf + Bootstrap 5, PostgreSQL + Flyway, CommonMark
(markdown render — yalnızca çekirdek CommonMark + `commonmark-ext-heading-anchor`,
**GFM tables extension'ı yok**, markdown tablosu kullanma), highlight.js. Paket kökü:
`com.cdurgun.learning`.

## Mimari — Bunlar Kesinlikle Değişmeyecek Kurallar

- **DB sadece metadata tutar.** Hiyerarşi: `Course > Category > Topic >
  TopicTranslation`, ayrıca `CodeExample`. Ders içeriğinin kendisi asla DB'de değil,
  `src/main/resources/content/{lang}/{slug}.md` dosyalarındadır (tek doğruluk kaynağı).
- **Java örnekleri gerçek, derlenebilir `.java` dosyalarıdır:**
  `src/main/resources/examples/{topic-slug}/*.java`. Markdown içinde
  `{{DosyaAdi.java}}` yazılınca `MarkdownService` bunu fenced code block'a çevirir.
  Bu dosyalar **default package**'ta, **İngilizce yorumlarla** yazılır (TR/EN her iki
  markdown da aynı dosyaları paylaşır). Aynı topic klasöründe farklı dosyalarda aynı
  sınıf adının (`Book`, `Animal`, `Duck` gibi) tekrar tekrar kullanılması **normaldir**
  — her `.java` dosyası bağımsız bir derleme birimi, birlikte derlenmezler.
- **Embed sistemi Faz 27'den itibaren uzantıdan bağımsız:** `{{DosyaAdi.ext}}` söz
  dizimi artık genel — `MarkdownService`'teki `EXAMPLE_PLACEHOLDER` regex'i uzantıyı
  ikinci bir yakalama grubu olarak okuyor, `CodeExampleResolver.resolve(slug, name,
  extension)` bu uzantıyla dosya yolunu kuruyor, ve üretilen fenced code block'un dil
  etiketi (` ```jsx ` gibi) doğrudan bu uzantıdan geliyor. React kategorisi için
  `.jsx` dosyaları bu sayede Java örnekleriyle **birebir aynı mekanizmayla** gömülebilir
  — yeni bir "React embed sistemi" yazmaya gerek yok. `highlight.js@11.9.0`'ın "jsx"i
  "javascript" grammar'ının bir alias'ı olarak tanıdığı, bağımsız olarak doğrulandı
  (bkz. "Bilinen Kısıtlar").
- **DB ↔ dosya bağlantısı yalnızca slug convention ile kurulur**, path hiçbir zaman
  DB'de saklanmaz: `content/{language}/{topic.slug}.md` ve
  `examples/{topic.slug}/{example_name}.{ext}`.
- **Yayın durumu çeviri seviyesindedir:** `Topic`'te `published` yok,
  `TopicTranslation`'da var — bir dil yayında, diğeri taslak olabilir (örn. TR yayında,
  EN henüz taslak). Yeni bir konu eklerken önce TR'yi `published = true`, EN'i
  `published = false` olarak ekle; EN çevirisi bitince ayrı bir migration'la yayına al.
- **`> 💡 Tip` / `> ⚠️ Warning` blockquote'ları** Bootstrap alert'e çevrilir —
  **tek paragraf olmalı**, içine boş satır ya da code fence **konamaz** (regex tabanlı
  post-process, çok paragraflı blockquote'ları desteklemiyor). Code fence'ler her zaman
  blockquote'un dışına, sibling olarak konur.
- **Bölüm/section referansları her zaman isimle verilir** ("Alanları Okumak"
  bölümünde...), **asla numarayla değil** ("Bölüm 3'te..." yazma). Bir bölüme referans
  verirken, o bölümün H2 başlığıyla **birebir aynı metni** tırnak içinde kullan — TR ve
  EN dosyaları ayrı ayrı doğrulanmalı.
- **i18n:** `?lang=tr|en`. UI metinleri `messages*.properties`'de, içerik çevirisi
  (`content/{lang}/*.md` + `TopicTranslation`) tamamen ayrı bir katman. **Varsayılan dil
  İngilizce** (`LangParamLocaleResolver.DEFAULT_LOCALE`) — `lang` parametresi yoksa/
  bozuksa arayüz de içerik de İngilizce'ye düşer. `HomeController`/`TopicController`,
  `lang` verilmediğinde `LocaleContextHolder.getLocale()`'i (yani bu resolver'ın
  sonucunu) kullanır — kendi başına ayrı bir varsayılan **tanımlama**; aksi halde arayüz
  ile içerik dili birbirinden sapar (Faz 12'de yaşanan gerçek bir hataydı).
- **Flyway migration numaraları sıralı ve geçmişe dönük asla değiştirilmez** — her
  değişiklik yeni bir `V{n}__aciklama.sql` dosyası. SQL string literal'lerinde Türkçe
  apostrof geçen metinlerde (`Interface'in` gibi) SQL escaping'i (`''`) unutma.
- **Migration dosyalarında (yorum satırları dahil) literal `${...}` yazma** —
  Flyway'in varsayılan placeholder sözdizimi tam olarak `${...}` ve dosyanın
  tamamını (SQL yorumları dahil) bu kalıba karşı tarıyor; eşleşen her `${...}`
  için bir placeholder değeri bekliyor, yoksa "No value provided for
  placeholder" hatasıyla **tüm uygulama başlamıyor** (Faz 23'te
  `spring-mvc-views-thymeleaf` migration'larında Thymeleaf'in `${...}` değişken
  ifadesinden bahsederken gerçekten yaşandı). Thymeleaf'ten bahseden bir migration
  yazarken `${...}` yerine "dolar-süslü-parantez" gibi betimleyici bir ifade
  kullan — `@{...}` ve `#{...}` sorun değil, yalnızca `$` önekli olan tetikliyor.
- **Migration dosyaları `db/migration/{konu-slug}/` alt klasörlerinde tutulur**
  (`core/`, `enum/`, `record/`, ... `threads/`) — Flyway, `classpath:db/migration`
  konumunu recursive taradığı için alt klasör derinliği versiyon sırasını etkilemez, bu
  yalnızca dosya sistemi düzeyinde bir organizasyon. Yeni bir konu eklerken migration'ları
  o konunun kendi alt klasörüne koy.
- **Birden fazla `Category` olabilir** (Faz 11'den itibaren: `java-basics` +
  `concurrency`) — `category.sort_order` kategoriler arası sırayı, `topic.sort_order` ise
  **yalnızca kendi kategorisi içinde** sırayı belirler (`TopicRepository` sorgusu
  `WHERE category_id = ?` ile scoped'dır). Yeni bir kategori açarken `topic.sort_order`'ı
  1'den başlat, önceki kategorilerin numaralarını devam ettirme.

## Örnek Yazım İlkeleri (Faz 18'den itibaren, tüm konular için geçerli)

- Eğitim amaçlı örneklerde **sadelik ve anlaşılırlık, production-seviyesi eksiksizlikten
  önce gelir.** Bir örnek, konu özellikle gerektirmediği sürece production-ready ya da
  bağımsız derlenebilir olmak zorunda değil.
- Anlatılan kavramla doğrudan ilgili olmayan katmanları (gereksiz DTO, service,
  repository, configuration, exception handling, boilerplate) ekleme.
- Her örnek **tek bir ana kavramı** göstersin; o kavramı anlaşılır kılacak en az
  kod kullanılsın.
- Bir örnek çalıştırılabilir olarak tasarlandıysa gerçekten derlenip doğru çalışmalı;
  değilse odaklı bir kod snippet'i olarak kabul edilsin ve sırf bağımsız derlensin diye
  gereksiz altyapı eklenmesin.

## İçerik Yazım Formatı (Her Yeni Konu İçin)

Enum → Record → Reflection → Interface → Abstract Class → Inheritance → Polymorphism →
Threads → Date & Time API konularında oturmuş kalıp:

1. Başlıksız bir giriş paragrafı, sonra `## Konu Nedir?`, `## Neden Var?`, `## Tarihçe`
   ile açılış (ilk üç bölüm genelde inline kod snippet'i kullanır, `{{}}` dosyası değil).
2. Orta bölümler, her biri bir mekaniği tanıtıp genelde bir `{{ÖrnekDosyası.java}}`
   gömer; anlatım önceki bölümlere isimle referans verir.
3. `## Best Practices`, `## Yaygın Hatalar`, `## Özet, Cheat Sheet ve Terimler
   Sözlüğü` ile kapanış (Özet'te hem madde madde özet hem bir kod cheat sheet'i hem
   terimler sözlüğü olur).
4. `## Ek: Mini Proje — ...` şeklinde 2 adet ek bölüm — her biri genelde 2 `.java`
   dosyası (bir "base" + bir "demo") kullanır.
5. **Interview Questions ("Mülakat Soruları") artık kullanılmıyor** — bu, kullanıcı
   kararıyla Abstract Class'tan itibaren atlandı, yeni konularda da atla.

Her konu için ~15-20 ana bölüm + 2 mini proje eki, ~15-17 kod örneği hedeflenir. DB
tarafında desen: `V{n}__{slug}_topic.sql` (iskelet) → `V{n+1}__{slug}_sections_1_to_N.sql`
(ilk yarı örnek metadata'sı) → `V{n+2}__update_{slug}_estimated_minutes.sql` (ara
güncelleme) → `V{n+3}__{slug}_sections_N_to_ek.sql` (ikinci yarı + ekler) →
`V{n+4}__update_{slug}_estimated_minutes.sql` (son güncelleme) →
`V{n+5}__publish_{slug}_english.sql` (EN yayına alma).

## Tamamlanan Fazlar

| Faz | Konu | Durum |
|---|---|---|
| 1 | Proje iskeleti, navigasyon (breadcrumb, prev/next), sağ TOC | ✅ |
| 2 | Enum (~19 bölüm) | ✅ TR+EN |
| 3 | Navigasyon (`category.sort_order`, zorluk/süre rozeti) | ✅ |
| 4 | TOC (sağda "Bu sayfada", CommonMark heading-anchor) | ✅ |
| 5 | Record (17 ana + 2 ek, 21 örnek) | ✅ TR+EN |
| 6 | Reflection (17 ana + 2 ek, 15 örnek, ADVANCED) | ✅ TR+EN |
| 7 | Interface (20 ana + 2 ek, 17 örnek) | ✅ TR+EN |
| 8 | Abstract Class (19 ana + 2 ek, 15 örnek) | ✅ TR+EN |
| 9 | Inheritance (19 ana + 2 ek, 17 örnek) | ✅ TR+EN |
| 10 | Polymorphism (16 ana + 2 ek, 14 örnek — Inheritance'la kasıtlı çakışmasız) | ✅ TR+EN |
| 11 | Threads (18 ana + 2 ek, 16 örnek, ADVANCED — yeni "Concurrency" kategorisinin ilk konusu) | ✅ TR+EN |
| 12 | Date & Time API (21 ana + 2 ek, 19 örnek, INTERMEDIATE — java.time paketi) | ✅ TR+EN |
| 13 | Dependency Injection & IoC (17 ana + 2 ek, 14 örnek, INTERMEDIATE — yeni "Spring Boot" kursunun, "Spring Core" kategorisinin ilk konusu; Spring'e değinmeden saf Java ile) | ✅ TR+EN |
| 14 | Spring IoC Container & Bean Lifecycle (20 ana + 2 ek, 16 örnek, ADVANCED — Spring Core'un ikinci konusu; gerçek `AnnotationConfigApplicationContext` kullanan ilk konu) | ✅ TR+EN |
| 15 | Component Scanning & Configuration (17 ana + 2 ek, 14 örnek, INTERMEDIATE — Spring Core'un üçüncü konusu; `@Component`/`@Service`/`@Repository`/`@Controller`, `@Autowired`, `@Qualifier`/`@Primary`) | ✅ TR+EN |
| 16 | Spring Boot Auto-Configuration & Properties (22 ana + 2 ek, 14 örnek, ADVANCED — Spring Core'un dördüncü ve planlanan son konusu; `@SpringBootApplication`, `@Conditional` ailesi, `@Value`/`@ConfigurationProperties`, `@Profile`, `ApplicationEvent`) | ✅ TR+EN |
| 17 | Transaction Management (24 ana + 2 ek, 13 örnek, ADVANCED — Spring Core'a kullanıcı isteğiyle eklenen bonus beşinci konu; `@Transactional`'ın proxy tabanlı mekanizması, rollback kuralları, propagation (`REQUIRED`/`REQUIRES_NEW`), self-invocation tuzağı, isolation levels, `readOnly`, `TransactionTemplate`, `@TransactionalEventListener`) | ✅ TR+EN |
| 18 | Spring MVC Fundamentals (19 ana + 2 ek, 11 örnek, INTERMEDIATE — yeni "Spring MVC" kategorisinin ilk konusu; MVC deseni, DispatcherServlet/HandlerMapping/HandlerAdapter (reflection tabanlı simülasyonla), `@Controller` vs `@RestController`, `Model`, `ViewResolver`, embedded Tomcat, Spring MVC vs WebFlux) | ✅ TR+EN |
| 19 | Mapping Annotation'ları ve HTTP Metotları (17 ana + 2 ek, 12 örnek, INTERMEDIATE — Spring MVC kategorisinin ikinci konusu; orijinal "Request Mapping & HTTP Methods" planının kullanıcı kararıyla bölünmüş ilk parçası; `@RequestMapping` ve beş kısayolu, consumes/produces, safe/idempotent semantiği, PUT vs PATCH, 405 Method Not Allowed) | ✅ TR+EN |
| 20 | Path Variable'lar ve Request Parametreleri (17 ana + 2 ek, 14 örnek, INTERMEDIATE — Spring MVC kategorisinin üçüncü konusu; bölünmenin ikinci ve son parçası; `@PathVariable`, `@RequestParam`, `@RequestHeader`, List/Map bağlama, `ConversionService` ile tip dönüşümü, path variable vs query parameter ayrımı) | ✅ TR+EN |
| 21 | Request ve Response Handling (19 ana + 2 ek, 14 örnek, INTERMEDIATE — Spring MVC kategorisinin dördüncü konusu; `@RequestBody`/`HttpMessageConverter`, `ResponseEntity`, 2xx/4xx/5xx HTTP durum kodları, content negotiation ve 406 Not Acceptable) | ✅ TR+EN |
| 22 | Validation & Exception Handling (18 ana + 2 ek, 14 örnek, INTERMEDIATE — Spring MVC kategorisinin beşinci konusu; Bean Validation (`@NotNull`/`@NotEmpty`/`@NotBlank`, `@Size`/`@Min`/`@Max`, `@Email`/`@Pattern`), `@Valid` ve `Validator`/`ConstraintViolation` mekanizması, iç içe nesnelerde cascading, `@ExceptionHandler`, `@RestControllerAdvice`, RFC 7807 `ProblemDetail` — artık gerçek `spring-boot-starter-validation` ile) | ✅ TR+EN |
| 23 | Spring MVC Views ve Thymeleaf (19 ana + 2 ek, 15 örnek, INTERMEDIATE — Spring MVC kategorisinin altıncı konusu; `Model`/`ModelMap`/`ModelAndView`, Thymeleaf'in "natural templating" felsefesi, `${...}`/`@{...}`/`#{...}` ifadeleri, `th:text`/`th:utext`, `th:if`/`th:unless`, `th:each`, `th:fragment`/`th:insert`/`th:replace`, SpringEL seçim ifadeleri (`.?[...]` / `#vars`, projenin gerçek sidebar bug'ına referansla), `th:object`/`th:field` (kısa bakış), MVC vs REST — ilk kez `org.thymeleaf.TemplateEngine`'i doğrudan kullanan konu, projenin kendi `fragments/layout.html`/`topic.html`'ine referansla) | ✅ TR+EN |
| 24 | Advanced Spring MVC (18 ana + 2 ek, 16 örnek, ADVANCED — Spring MVC kategorisinin yedinci ve ilk ADVANCED konusu; `HandlerInterceptor` (`preHandle`/`postHandle`/`afterCompletion`), Filter vs Interceptor, `WebMvcConfigurer` ile interceptor kaydı ve global CORS, same-origin policy/preflight/`@CrossOrigin`, `MultipartFile` ile dosya yükleme ve boyut sınırları — gerçek Spring API'lerini (`HandlerInterceptor`, `WebMvcConfigurer`, `CorsConfiguration`, `MultipartFile`) container olmadan, `java.lang.reflect.Proxy` ile sahte Servlet nesneleri üreterek kullanan konu; V108'de yaşanan Flyway `${...}` placeholder hatasından sonra ilk konu, migration'larda literal dolar-süslü-parantez yazılmadı) | ✅ TR+EN |
| 25 | REST API Tasarımı (17 ana + 2 ek, 15 örnek, ADVANCED — Spring MVC kategorisinin sekizinci konusu; entity'yi doğrudan dışarı vermenin riskleri ve DTO deseni (record ile istek/yanıt ayrımı), gerçek `Pageable`/`Page<T>`/`Sort` (bu projenin `TopicRepository`'sinin de miras aldığı `JpaRepository` ailesinden) ile sayfalama/sıralama, query parametreleriyle filtreleme, `Page<T>`'i doğrudan dönmek yerine kararlı bir `PagedResponse<T>` DTO'suna sarmalama (Spring Data'nın kendi tavsiyesi), URI vs header API versioning, idempotency ve `Idempotency-Key` header'ı ile `POST`'u idempotent yapma, HATEOAS (kısa bakış — `spring-hateoas` projede yok, elle kurulmuş bir `links` map'iyle anlatıldı)) | ✅ TR+EN |
| 26 | Spring MVC'de Test Yazmak (17 ana + 2 ek, 14 örnek, ADVANCED — Spring MVC kategorisinin dokuzuncu ve planlanan son konusu; `MockMvc`/`@WebMvcTest` ile web katmanı slice testleri, `MockMvcBuilders.standaloneSetup(...)` ile Spring context'siz `main()`-çalıştırılabilir testler, `@MockitoBean` ile bağımlılık sahteleme (`@MockBean`'in Spring Boot 4.1.0'da kaldırılan yerine), `model()`/`view()`/`jsonPath()`/`content()`/`header()` matcher aileleri, `MockMultipartFile` (test-scope, `InMemoryMultipartFile`'ın aksine gerçek sınıf kullanıldı), bu projenin gerçek `HomeController`'ı ve altı bağımlılıklı `TopicController`'ı için gerçek `@WebMvcTest` testleri (`TopicTestFixtures` ile Lombok `@Builder` fixture'ları) — bu migration'la Spring MVC kategorisinin planlanan dokuz topic'i tamamlandı) | ✅ TR+EN |
| 27 | Embed sisteminin `.jsx` desteği için genelleştirilmesi (kod değişikliği, yeni içerik değil — bkz. "Bilinen Kısıtlar") | ✅ |
| 28 | React Fundamentals kategorisi — What Is React? (8 ana, embed yok, BEGINNER), Creating a React Application (7 ana, embed yok, BEGINNER), JSX (7 ana, 5 örnek, BEGINNER) — yeni "React" course'unun ilk kategorisi; kullanıcı kararıyla **bilinçli olarak sade bir dille**, mini proje eki olmadan yazıldı (bkz. "Bilinen Kısıtlar") | ✅ TR+EN |
| 29 | Components & Props kategorisi — Components (6 ana, 4 örnek, BEGINNER), Props (7 ana, 4 örnek, BEGINNER), Component Composition (5 ana + 1 ek, 5 örnek, BEGINNER) — React course'unun ikinci kategorisi; sade dil kararı devam ediyor, ama bu kategoriden itibaren gerçek mini projeler başladı (Component Composition'daki tek "## Ek: Mini Proje" — yeniden kullanılabilir bir Card component'i, `CardBase.jsx`+`CardDemo.jsx`) | ✅ TR+EN |

Migration'lar V1'den V131'e kadar uygulandı. İki kurs var: `java` kursunda üç kategori
(`category.sort_order`): `java-basics`(1) — enum=1, records=2, reflection=3,
date-time=4; `oop`(2, "Object-Oriented Programming") — interface=1, abstract-class=2,
inheritance=3, polymorphism=4 (V51'de java-basics'ten taşındı); `concurrency`(3) —
threads=1. `spring-boot` kursunda (V58'de eklendi) bir kategori: `spring-core`(1) —
dependency-injection=1, spring-ioc-container=2 (V64'te eklendi), component-scanning=3
(V70'te eklendi, EN'i V75'te yayına alındı), autoconfiguration-properties=4 (V76'da
eklendi, EN'i V81'de yayına alındı), transaction-management=5 (V82'de eklendi, EN'i
V87'de yayına alındı). ExecutorService/CompletableFuture ve Modern Concurrency
(virtual threads), concurrency kategorisinde ayrı, sonraki konular olarak
planlanıyor. Spring Core kategorisi, planlanan dörtlünün (bkz. Faz 13 tartışması)
tamamlanmasının ardından kullanıcı isteğiyle beşinci bir konuyla (Transaction
Management) genişletildi -- artık beş topic'in beşi de (Dependency Injection & IoC,
Spring IoC Container & Bean Lifecycle, Component Scanning & Configuration, Spring
Boot Auto-Configuration & Properties, Transaction Management) TR+EN tamamlandı.
Faz 18'de `spring-boot` kursuna ikinci kategori eklendi: `spring-mvc`(2) --
spring-mvc-fundamentals=1 (V88'de eklendi, EN'i V91'de yayına alındı),
mapping-annotations-http-methods=2 (V92'de eklendi, EN'i V95'te yayına alındı),
path-variables-request-parameters=3 (V96'da eklendi, EN'i V99'da yayına alındı),
request-response-handling=4 (V100'de eklendi, EN'i V103'te yayına alındı),
validation-exception-handling=5 (V104'te eklendi, EN'i V107'de yayına alındı),
spring-mvc-views-thymeleaf=6 (V108'de eklendi, EN'i V111'de yayına alındı),
advanced-spring-mvc=7 (V112'de eklendi, EN'i V115'te yayına alındı),
rest-api-design=8 (V116'da eklendi, EN'i V119'da yayına alındı),
spring-mvc-testing=9 (V120'de eklendi, EN'i V123'te yayına alındı) —
Spring MVC kategorisinin planlanan dokuz topic'i de tamamlandı.
Dokuz topic'lik planı (bkz. "Sıradaki Adım") için `spring-boot-starter-validation`
bağımlılığı `pom.xml`'e eklendi, validation-exception-handling konusuyla birlikte
gerçek `jakarta.validation`/Hibernate Validator kullanıma girdi.

**Faz 28'de üçüncü bir Course eklendi: `react`** (course.slug = 'react', V124'te
oluşturuldu). İlk kategorisi `react-fundamentals`(1) — what-is-react=1,
creating-a-react-application=2, jsx=3 (üçü de V124'te eklendi, EN'i V127'de yayına
alındı). Kullanıcı ChatGPT'nin hazırladığı 33 topic'lik/11 kategorili bir React kurs
planını paylaştı; kategori kategori ilerleme kararıyla (bkz. Spring MVC'deki aynı
ritim) devam ediliyor. `Course` tablosunda `sort_order` olmadığı için (bkz. aşağıdaki
"Bilinen Kısıtlar") React, `NavigationService.buildNavigation()`'ın listelediği
kurslar arasında otomatik olarak üçüncü sırada (java, spring-boot, react) görünüyor.

**Faz 29'da ikinci kategori eklendi: `components-props`(2)** — components=1,
props=2, component-composition=3 (üçü de V128'de eklendi, EN'i V131'de yayına
alındı). React course'u artık iki kategori/altı yayında topic'e sahip; kalan dokuz
kategori (Components & Props'tan sonra ChatGPT planındaki sıradaki: State & Events,
Hooks, Forms, Routing, API & Data Fetching, State Management, Advanced React,
Testing, Production) henüz planlanmadı/DB'ye seed edilmedi.

## Proje Yapısı

```
src/main/java/com/cdurgun/learning/
    domain/          Course, Category, Topic, TopicTranslation, CodeExample, Language, Difficulty
    domain/converter/ Language <-> DB (tr/en kodu) dönüştürücüsü
    repository/      Spring Data JPA repository'leri
    service/         ContentResolver, CodeExampleResolver, MarkdownService, NavigationService
    controller/      HomeController, TopicController
    config/          LangParamLocaleResolver, WebConfig
    web/nav/         Sidebar/anasayfa navigasyon DTO'ları (CourseNav)

src/main/resources/
    content/{tr,en}/{slug}.md     Ders içerikleri (tek doğruluk kaynağı)
    examples/{slug}/*.java        Gerçek, derlenebilir kod örnekleri
    db/migration/{konu-slug}/     Flyway migration'ları, konu bazlı alt klasörlerde (V1..V131)
    templates/                    Thymeleaf şablonları (Bootstrap + highlight.js)
    static/css/custom.css         Sidebar accordion (.sidebar-toggle/.chevron) dahil özel stiller
    messages*.properties          Arayüz metni çevirileri
```

## Bilinen Kısıtlar / Dikkat Edilecekler

- `javac` **Faz 12'den itibaren kullanıcı kararıyla artık yazıldıktan sonra
  derlenip çalıştırılmıyor** (`mvn`/`javac` derlemeleri gözle görülür oturum
  maliyeti/limit tüketiyor) — yeni `.java` dosyalarını yazarken elle dikkatli
  gözden geçir (özellikle çok satırlı `//` yorumları, parantez/noktalı virgül),
  ama artık gerçek bir derleyici doğrulaması **yapma**. Kullanıcı özellikle isterse ya da
  bir dosya sıra dışı derecede riskliyse (deadlock/timeout içeren thread örnekleri gibi)
  istisna olarak derleyebilirsin. Not (Faz 23): bu oturumda ortamda yalnızca bir Java 11
  JRE bulundu, `javac` **yoktu** ve Maven local repo/internet erişimi de yoktu (proxy
  allowlist'i `repo.maven.apache.org`'u engelliyor) — yani derleme zaten mümkün değildi;
  bu satır önceki fazlardan kalma, ortam farklıysa güncel durumu bash ile doğrula.
- Çok satırlı `//` yorumlarında her satırın başına `//` tekrar yazılmalı — daha önce bir
  örnekte (`ModifierRulesExample.java`) bunu unutup gerçek bir derleme hatası bırakmıştım,
  yazarken kontrol et.
- Markdown tablosu **yazma** — proje bunu render edemiyor, karşılaştırmalar için madde
  işaretli liste kullan.
- `Course` tablosunda `sort_order` **yok** — `NavigationService.buildNavigation()`,
  `courseRepository.findAll()`'ın döndürdüğü sıraya güveniyor (pratikte id/insert sırası).
  Tek kurs varken bu hiç sorun değildi; artık `java` + `spring-boot` iki kurs olduğu için,
  üçüncü bir kurs eklenecekse ya da kurs sırası değişecekse bu, `Category`/`Topic`'teki
  gibi gerçek bir `sort_order` kolonu gerektirebilir — şimdilik id sırası (java=1,
  spring-boot=2) istenen sırayla aynı olduğu için dokunmadık.
- Spring örnekleri (`examples/dependency-injection/` gibi), OOP/Enum örneklerinin aksine
  bazen birbirine gerçekten bağımlı sınıflar içerebilir (aynı dosya içinde interface +
  implementasyon + kullanan sınıf) — hâlâ **default package**'ta ve dosyalar birbirinden
  bağımsız derlenir, ama "her `.java` dosyası kendi başına anlamlı bir demo olsun" kuralı
  gevşetildi; gerçek Spring annotation'ları (`@Component`, `@Service`, `@Autowired`)
  projenin kendi `spring-boot-starter-web` bağımlılığından geldiği için import olarak
  geçerli, ama container olmadan elbette çalıştırılamazlar (bkz. `SpringPreviewExample`).
- `spring-boot-starter-validation` **Faz 18'de eklendi**, **Faz 22'de** (Validation &
  Exception Handling konusu) fiilen kullanıma girdi — `@NotBlank`/`@Email`/`@Valid`
  artık gerçek `jakarta.validation`/Hibernate Validator üzerinden çalışıyor. Faz 16'da yazılan
  `autoconfiguration-properties` konusundaki `ConfigurationPropertiesValidationExample.
  java` ise bu bağımlılık projede yokken yazıldığı için elle bir `@PostConstruct`
  doğrulaması kullanıyor (bkz. içerikteki "Validating @ConfigurationProperties"
  bölümü) — bu, geriye dönük bir tutarsızlık değil, o an geçerli olan kısıtın
  belgelenmiş hâli; geçmiş içerik güncellenmedi. `@ConditionalOnClass`/
  `@ConditionalOnMissingBean`/`@ConditionalOnProperty` gibi
  `org.springframework.boot.autoconfigure.condition` sınıfları
  `spring-boot-starter-web`'in taşıdığı `spring-boot-autoconfigure` üzerinden geçerli.
- Bu ortamda gerçek bir Postgres bağlantısı yok, bu yüzden `transaction-management`
  konusundaki canlı kod örnekleri gerçek bir `DataSource`/`JpaTransactionManager` yerine
  elle yazılmış, `AbstractPlatformTransactionManager`'dan türeyen minik bir
  `PlatformTransactionManager` kullanıyor (`LedgerTransactionInfra.java` --
  `Ledger`/`LedgerTransactionManager`, `TransactionSynchronizationManager`'a bağlı,
  commit-only-append/rollback-discard tamponlarıyla çalışıyor; `PROPAGATION_REQUIRES_NEW`
  doğru izolasyonla test edilip doğrulandı). İçerikte bunun yalnızca bu ortam için bir
  öğretim aracı olduğu, gerçek projelerde hiç yazılmadığı açıkça belirtiliyor. Isolation
  levels, PostgreSQL isolation, dirty checking, lazy loading ve testing transactions
  bölümlerinin gerçek eşzamanlı transaction/DB gerektirmesi nedeniyle canlı kod örneği
  yok -- kavramsal (Kısa Bakış) ya da bu projenin gerçek kaynak koduna (`TopicRepository.
  findBySlugWithCategoryAndCourse`, `@ManyToOne(FetchType.LAZY)` alanları) referansla
  anlatılıyor.
- Sidebar (`fragments/layout.html :: sidebar`) artık kategori bazlı açılır/kapanır
  (accordion) — konu sayısı arttıkça menünün sürekli uzamasını önlemek için, yalnızca
  aktif konuyu içeren kategori (`CategoryNav.topics().?[#this.slug() == #vars.activeTopicSlug]`
  SpringEL selection'ı ile) varsayılan olarak açık gelir, diğerleri kapalı başlar.
  Not: `.?[...]` seçim ifadesi içinde `#this`, kapsamı TopicNavItem'a çeviriyor —
  dıştaki Thymeleaf context değişkenine (`activeTopicSlug`) önekiz erişmeye çalışmak
  `SpelEvaluationException: Property or field 'activeTopicSlug' cannot be found on
  object of type '...TopicNavItem'` hatası veriyordu; `#vars.activeTopicSlug` ile
  düzeltildi — seçim/projection ifadeleri içinde dış değişkenlere her zaman `#vars.`
  ile eriş.
  Bootstrap'in `data-bs-toggle="collapse"` mekanizmasını kullanıyor — bu yüzden
  `bootstrap.bundle.min.js` artık hem `index.html` hem `topic.html`'de yükleniyor
  (önceden hiçbir sayfa Bootstrap JS yüklemiyordu, yalnızca CSS). Kurs seviyesi
  (JAVA/SPRING BOOT) kasıtlı olarak collapse'siz bırakıldı — büyümenin asıl kaynağı
  kategori içindeki konu sayısı, kurs sayısı değil.
- `examples/spring-mvc-views-thymeleaf/` (**Faz 23**), projenin `org.thymeleaf.TemplateEngine`'i
  ilk kez **doğrudan** (Spring container'ı olmadan) kullandığı konu — önceki konularda
  Thymeleaf yalnızca deklaratif olarak `templates/*.html`'de kullanılıyordu. Örnekler bilinçli
  olarak düz `new TemplateEngine()` + `StringTemplateResolver` kullanıyor (`thymeleaf-spring6`'ın
  `SpringStandardDialect`'i değil) -- hem paket adı belirsizliğinden (Spring Boot 4.1/Spring 7 ile
  hangi `thymeleaf-springN` artifact'inin geldiği bu ortamda doğrulanamadı, bkz. yukarıdaki
  derleyici notu) kaçınmak hem de `#vars`/`.?[...]` gibi mekanizmaların zaten Standard
  Dialect'in (OGNL) bir parçası olduğu için Spring entegrasyonu gerektirmemesinden ötürü.
  Record alanlarına erişim bu yüzden her yerde parantezli (`topic.title()`), tıpkı projenin
  gerçek `fragments/layout.html`'indeki gibi -- OGNL'nin de SpringEL gibi açık metot çağrısını
  desteklemesi sayesinde bu, hem OGNL hem SpringEL altında doğru çalışır. `#{...}` (mesaj
  ifadeleri) canlı bir `IMessageResolver` kurmak yerine `java.util.ResourceBundle` ile taklit
  edildi (imzası belirsiz bir arayüzü ezberden implemente etme riskini almamak için) --
  `MessageExpressionExample.java`'daki yorum bunu açıkça belirtiyor. `th:object`/`th:field`
  (form binding) de gerçek bir `BindingResult`/`RequestDataValueProcessor` kurmadan, yalnızca
  ne ürettiklerini gösteren bir simülasyon (`FormBindingExample.java`) -- proje henüz form
  içermiyor.
- `examples/advanced-spring-mvc/` (**Faz 24**), gerçek `jakarta.servlet.http.HttpServletRequest`/
  `HttpServletResponse` olmadan bir `HandlerInterceptor`'ı çalıştırmak için
  `java.lang.reflect.Proxy` ile minimal, yalnızca kullanılan metotları implemente eden sahte
  Servlet nesneleri üretiyor (`AuthLoggingInterceptorExample`, `RequestLoggingInterceptorDemo`) --
  bir mocking kütüphanesi (Mockito) projenin ana (main) bağımlılıklarında yok (yalnızca
  `spring-boot-starter-test` üzerinden test-scope'ta var, `examples/` klasöründeki dosyalar
  main-scope varsayımıyla yazılıyor), bu yüzden JDK'nın kendi `Proxy` mekanizması (Reflection
  dersinde görülen `getAnnotation` ile aynı ailede) tercih edildi. Aynı gerekçeyle
  `MultipartFile` için de `org.springframework.mock.web.MockMultipartFile` (test-scope)
  yerine arayüzü elle implemente eden küçük bir `InMemoryMultipartFile` kullanıldı
  (`MultipartUploadControllerExample`, `FileUploadCorsDemo`).
- `examples/spring-mvc-testing/` (**Faz 26**), Advanced Spring MVC'nin aksine, gerçekten
  `spring-boot-starter-test`'e (dolayısıyla Mockito'ya ve `org.springframework.mock.web.
  MockMultipartFile`'a) ihtiyaç duyan tek konu -- bu dersin konusu zaten test altyapısının
  kendisi olduğu için önceki fazlardaki "main-scope'ta test-scope kütüphanesi kullanma"
  kısıtı burada uygulanmıyor. `@MockBean` yerine her yerde **yalnızca `@MockitoBean`**
  (`org.springframework.test.context.bean.override.mockito.MockitoBean`) kullanıldı --
  `@MockBean`, Spring Boot 3.4'ten beri deprecated ve bu projenin kullandığı 4.1.0'da
  kaldırıldı (WebSearch ile doğrulandı, kod yazılmadan önce). Dosyaların çoğu yine de
  `MockMvcBuilders.standaloneSetup(...)` kullanarak (Spring context olmadan) projenin
  "her `.java` dosyası `main()` ile çalışabilir" kuralına uyuyor -- yalnızca gerçek
  `@WebMvcTest`/`@MockitoBean` gerektiren dosyalar (`MockitoBeanExample`,
  `HomeControllerTest`, `TopicControllerWebMvcTest`) istisna olarak JUnit test sınıfı
  (`mvn test` ile çalışır, `main()` yok). `TopicControllerWebMvcTest`, bu projenin gerçek
  `TopicController`'ının altı bağımlılığının tamamını (`TopicRepository`,
  `TopicTranslationRepository`, `ContentResolver`, `MarkdownService`, `NavigationService`,
  `MessageSource`) `@MockitoBean` ile sahteliyor ve başarılı senaryoda gerçek
  `templates/topic.html`'i (production'daki ile aynı tipte mock değerlerle) render ediyor.
- **Faz 27 — Embed sisteminin `.jsx` desteği için genelleştirilmesi (React kategorisine
  hazırlık).** Kullanıcı ChatGPT'nin hazırladığı bir React kurs planını (`.odt`, 33 topic /
  11 kategori) paylaştı; içerik yazımına başlamadan önce, kullanıcı kararıyla önce
  altyapı düzeltildi ve mevcut sistemin bozulmadığı doğrulandı. Yapılanlar:
  `MarkdownService.EXAMPLE_PLACEHOLDER` regex'i `\{\{(\w+)\.java}}`'dan
  `\{\{(\w+)\.(\w+)}}`'a genelleştirildi (uzantı artık ikinci yakalama grubu);
  `CodeExampleResolver.resolve(topicSlug, exampleName)` imzası
  `resolve(topicSlug, exampleName, extension)`'a çevrildi (tek çağıran `MarkdownService`
  olduğu için başka bir yer etkilenmedi, `src/test`'te de referans yoktu). Bu ortamda
  `mvn`/`javac` olmadığı için (bkz. yukarıdaki not) doğrulama iki şekilde yapıldı: (1)
  projedeki **682 mevcut `{{...}}` embed'inin tamamı** Python'da hem eski hem yeni regex
  ile paralel çalıştırıldı — sıfır uyuşmazlık, sıfır eksik dosya (her biri hâlâ
  `examples/{slug}/{name}.java` yolunda fiziksel olarak mevcut) — yani mevcut içerik için
  üretilen çıktı birebir öncekiyle aynı; (2) `highlight.js@11.9.0` (projenin CDN'den
  yüklediği tam sürüm) npm ile ayrı bir sandbox'ta kurulup `hljs.getLanguage('jsx')` ve
  `hljs.highlight(..., {language: 'jsx'})` ile test edildi — "jsx", "javascript"
  grammar'ının kayıtlı bir alias'ı, örnek bir JSX snippet'i hatasız highlight edildi.
  Sonuç: React örnekleri için ayrı bir "JS embed sistemi" ya da frontend değişikliği
  gerekmiyor, `{{Ad.jsx}}` yazmak yeterli. Kullanıcı sonrasında kategori kategori
  ilerlemeye karar verdi (bkz. Faz 28).
- **Faz 28 — React Fundamentals kategorisi, bilinçli olarak sade bir dille.** Kullanıcı
  açıkça istedi: React kursu "basite indirgenmiş bir dille, mümkün olduğunca kolay
  örneklerle" anlatılsın — bu, Java/Spring derslerindeki yoğun, çok referanslı,
  "neden böyle tasarlandı" tartışmalarıyla dolu üsluptan **kasıtlı bir sapma**, yeni bir
  hata değil. Buna göre: cümleler kısa ve doğrudan, gereksiz meta yorum yok, örnekler
  (`examples/jsx/*.jsx`) tek bir kavramı gösteren birkaç satırlık kod parçaları. İlk üç
  konu (`what-is-react`: 8 ana başlık embed yok; `creating-a-react-application`: 7 ana
  başlık embed yok, yalnızca inline `bash`/`json`/`text` snippet'leri; `jsx`: 7 ana
  başlık + 5 örnek) **hiçbiri `## Ek: Mini Proje` içermiyor** — Java/Spring'deki
  "her konu 2 mini proje ekiyle biter" kuralı burada bilinçli olarak uygulanmadı, çünkü
  bu üç konu henüz kod yazmaya yeni başlıyor (Topic 1-2'de hiç kod yok); gerçek mini
  projeler "Components & Props" kategorisinden itibaren gelecek. Üç konu da BEGINNER
  işaretlendi. `examples/jsx/*.jsx` dosyaları, Node + `@babel/preset-react` (ayrı bir
  sandbox'a npm ile kurulup) `transformSync(...)` ile syntax-doğrulandı — beşi de
  hatasız derlendi; bu, Java örneklerinde hiç sahip olmadığımız gerçek bir derleyici
  doğrulaması. React course'unun kalan kategorileri (bkz. kullanıcının paylaştığı
  orijinal ChatGPT planı) sırayla, aynı ritimde (plan+örnek onayı → TR+EN → migration)
  ele alınacak.
- **Faz 29 — Components & Props kategorisi, ve topic.html'de bir CSS düzeltmesi.**
  Sade dil kararı (Faz 28) bu kategoride de geçerli, ama kullanıcının onayladığı gibi
  bu kategoriden itibaren gerçek mini projeler başladı: `component-composition`
  konusunun TEK "## Ek: Mini Proje" bölümü (`CardBase.jsx` + `CardDemo.jsx`) --
  Java/Spring derslerindeki "her konu 2 mini proje ekiyle biter" kuralı burada hâlâ
  uygulanmıyor, `components` ve `props` hiç ek içermiyor. 13 örnek dosyasının tamamı
  yine Node + `@babel/preset-react` ile syntax-doğrulandı. Ayrıca bu fazda, kullanıcının
  bildirdiği bağımsız bir görsel hata düzeltildi: `topic.html`'deki dil değiştirme
  butonu ("TR"/"EN"), başlık/özet bloğuyla aynı flex satırındaydı
  (`d-flex justify-content-between ... flex-wrap`) ve `justify-content-between` ile
  sağda durması bekleniyordu -- ama flex item'ların varsayılan `min-width: auto`
  davranışı yüzünden, özet metni yeterince uzun olduğunda (JSX konusunda olduğu gibi)
  başlık bloğu butona satırda yer bırakmıyor, `flex-wrap` devreye girip butonu yeni bir
  satıra, tek başına, sola düşürüyordu -- kısa özetli konularda hiç görünmeyen, yalnızca
  uzun özetlerde ortaya çıkan bir hataydı. Düzeltme: başlık/özet bloğuna
  `.topic-header-info { min-width: 0; }` (yeni, `custom.css`'e eklendi) ve
  `flex-grow-1` class'ı, dil butonuna da `flex-shrink-0` eklendi -- böylece blok
  gerektiğinde küçülüp metin normal kırılıyor, buton her zaman sağda kalıyor. Bu
  ortamda gerçek bir tarayıcı olmadığı için görsel olarak koşarak doğrulanamadı,
  yalnızca CSS akıl yürütmesiyle (flexbox'ın iyi bilinen bir "min-width: auto"
  tuzağı) düzeltildi -- kullanıcı sonucu kendi tarayıcısında teyit etmeli.

Spring Core kategorisinin beş topic'i de (Faz 13-17) TR+EN tamamlandıktan sonra,
kullanıcı `spring-boot` kursuna ikinci bir kategori eklenmesini istedi: **Spring
MVC** (`spring-mvc`, `category.sort_order=2`, `topic.sort_order` 1'den başlar).
Kullanıcının paylaştığı ChatGPT taslağı değerlendirilip onaylandı, sekiz topic
planlandı:

1. `spring-mvc-fundamentals` (INTERMEDIATE) — DispatcherServlet, MVC akışı,
   `@Controller` vs `@RestController`, embedded Tomcat
2. `request-mapping-http-methods` (INTERMEDIATE) — `@GetMapping` ailesi,
   `@PathVariable`, `@RequestParam`, `@RequestHeader`
3. `request-response-handling` (INTERMEDIATE) — `@RequestBody`, `ResponseEntity`,
   status code'lar, content negotiation
4. `validation-exception-handling` (INTERMEDIATE) — Bean Validation (`@Valid`,
   `@NotBlank`, ...), `@RestControllerAdvice`, `ProblemDetail` — artık gerçek
   `spring-boot-starter-validation` ile (bkz. "Bilinen Kısıtlar")
5. `spring-mvc-views-thymeleaf` (INTERMEDIATE) — `Model`/`ModelAndView`,
   Thymeleaf temelleri, MVC vs REST karşılaştırması; projenin kendi
   `layout.html`/`topic.html`'ine referansla anlatılacak
6. `advanced-spring-mvc` (ADVANCED) — `HandlerInterceptor`, filter vs interceptor,
   `WebMvcConfigurer`, CORS, multipart file upload
7. `rest-api-design` (ADVANCED) — DTO, pagination/sorting/filtering, API
   versioning, idempotency, HATEOAS (kısa bakış — `spring-hateoas` projede yok)
8. `spring-mvc-testing` (ADVANCED) — `MockMvc`, `@WebMvcTest`
   (`spring-boot-starter-test` zaten projede var)

Faz 18'den itibaren "Örnek Yazım İlkeleri" bölümündeki sadelik kuralı geçerli.
Sıra: konu konu, TR tamamlanınca onay alıp EN'e geçme ritmi (bkz. Faz 13-17).

**Durum:** Dokuz topic'in **tamamı TR+EN tamamlandı**: `spring-mvc-fundamentals` (V88-V91),
`mapping-annotations-http-methods` (V92-V95), `path-variables-request-parameters`
(V96-V99), `request-response-handling` (V100-V103), `validation-exception-handling`
(V104-V107), `spring-mvc-views-thymeleaf` (V108-V111), `advanced-spring-mvc`
(V112-V115), `rest-api-design` (V116-V119), `spring-mvc-testing` (V120-V123) —
**Spring MVC kategorisi tamamlandı.** Kullanıcı kararıyla, orijinal sekiz
topic'lik plandaki "Request Mapping & HTTP Methods" (ChatGPT taslağının
kendisinin de "oldukça kapsamlı olabilir" dediği konu) ikiye bölündü -- kategori
dokuz topic'e çıktı:

1. `spring-mvc-fundamentals` ✅ TR+EN
2. `mapping-annotations-http-methods` ✅ TR+EN
3. `path-variables-request-parameters` ✅ TR+EN (bölünmenin ikinci ve son parçası)
4. `request-response-handling` ✅ TR+EN -- `@RequestBody`/`HttpMessageConverter`,
   `ResponseEntity`, 2xx/4xx/5xx durum kodları, content negotiation
5. `validation-exception-handling` ✅ TR+EN -- Bean Validation (`@NotNull`/`@NotEmpty`/
   `@NotBlank`, `@Size`/`@Min`/`@Max`, `@Email`/`@Pattern`), `@Valid`, cascading,
   `@ExceptionHandler`, `@RestControllerAdvice`, RFC 7807 `ProblemDetail`
6. `spring-mvc-views-thymeleaf` ✅ TR+EN -- `Model`/`ModelMap`/`ModelAndView`,
   Thymeleaf'in "natural templating" felsefesi, `${...}`/`@{...}`/`#{...}`,
   `th:if`/`th:each`/`th:fragment`, SpringEL seçim ifadeleri (`.?[...]`/`#vars`),
   `th:object`/`th:field` (kısa bakış), MVC vs REST (bkz. "Bilinen Kısıtlar")
7. `advanced-spring-mvc` ✅ TR+EN -- `HandlerInterceptor`
   (`preHandle`/`postHandle`/`afterCompletion`), filter vs interceptor,
   `WebMvcConfigurer` ile interceptor kaydı ve global CORS, same-origin
   policy/preflight/`@CrossOrigin`, `MultipartFile` ile dosya yükleme (bkz.
   "Bilinen Kısıtlar")
8. `rest-api-design` ✅ TR+EN -- entity'yi doğrudan dışarı vermenin riskleri ve
   DTO deseni, `Pageable`/`Page<T>`/`Sort` ile sayfalama/sıralama, query
   parametreleriyle filtreleme, `PagedResponse<T>` ile kararlı yanıt şekli,
   URI vs header API versioning, idempotency ve `Idempotency-Key`, HATEOAS
   (kısa bakış)
9. `spring-mvc-testing` ✅ TR+EN -- `MockMvc`/`@WebMvcTest` ile slice testleri,
   `standaloneSetup(...)` ile context'siz `main()`-testleri, `@MockitoBean`
   ile bağımlılık sahteleme, `model()`/`view()`/`jsonPath()` matcher'ları,
   bu projenin gerçek `HomeController`/`TopicController`'ı için gerçek testler
   (`spring-boot-starter-test` zaten projede vardı)

**Spring MVC kategorisi (dokuz topic) artık tamamlandı** -- kategori altında
planlanan yeni bir konu yok; bir sonraki adım kullanıcının kararına bağlı
(yeni bir kategori/kurs mu, yoksa mevcut kategorilerden birine bonus bir
konu mu -- bkz. Faz 17'deki Transaction Management örneği).

**Kullanıcı kararıyla (Faz 20'nin sonunda) artık her topic'in TR'si bitince EN'i de
onay beklemeden yazılıyor** -- Faz 13'teki ilk dörtlü hariç, önceki fazlarda TR/EN
arasında ayrı onay istenen ritim Faz 21'den itibaren terk edildi; her topic tek bir
fazda TR+EN tamamlanmış olarak teslim ediliyor.
