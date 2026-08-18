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
- **Dil, Faz 64'ten beri URL path'inin bir parçası, query parametresi değil:**
  gerçek içerik `/en/topics/{slug}` ve `/tr/topics/{slug}` altında (anasayfa: `/en`,
  `/tr`); çıplak `/` yalnızca `Accept-Language`'e göre 302 ile yönlendiren bir
  negotiator, eski `/topics/{slug}?lang=..` URL'leri ise 301 ile yeni adrese
  yönlendiriliyor (SEO gerekçesi: hreflang ile bağlanabilen, bağımsız indexlenebilir
  URL'ler — bkz. Faz 64 notu). Yeni bir sayfa/route eklerken dili HER ZAMAN
  `{lang:en|tr}` regex-kısıtlı bir path variable olarak ekle, query parametresi olarak
  DEĞİL.
- **Mutlak URL üretmek gereken her yerde (hreflang, canonical, Open Graph/Twitter meta,
  JSON-LD, sitemap.xml) `app.base-url` kullanılır, asla sabit kodlanmış bir domain
  DEĞİL** — bkz. Faz 65 notu. `application.yml`'de dev varsayılanı
  (`http://localhost:8080`), `application-prod.yml`'de production değeri
  (`https://www.learnforgex.com`) tanımlı; her `Model` alan controller'a
  `GlobalModelAttributes` (`@ControllerAdvice`) aracılığıyla `baseUrl` model
  attribute'u olarak otomatik enjekte edilir, `ResponseEntity` döndüren
  controller'lar (örn. `SitemapController`) kendi constructor'ına
  `@Value("${app.base-url}")` ile alır. Yeni bir konu sayfası türü eklenirse
  `topic.html`'deki hreflang/canonical/OG deseni (yalnızca GERÇEKTEN yayında olan
  dillere hreflang ver, x-default İngilizce'ye düşer) referans alınmalı.
- **`th:inline="javascript"` (JSON-LD `<script>` bloklarında kullanılır) `/*<![CDATA[*/
  ... /*]]>*/` sarmalayıcısı OLMADAN yazılır** — bkz. Faz 66 notu. Bu proje HTML5 çıktı
  üretiyor (XHTML strict değil), ve bu CDATA sarmalayıcı (bazı Thymeleaf örneklerinde
  görülür) attoparser'ın `<![CDATA[`'i gerçek bir CDATA bölümü açılışı sanmasına, script
  içeriğinin metin düğümlerinin yanlış parçalanmasına ve `TemplateInputException:
  Incomplete structure: "/*"` hatasına yol açtığı canlı ortamda GERÇEKTEN doğrulandı.
  Yeni bir `th:inline="javascript"` bloğu eklerken CDATA sarmalayıcı EKLEME.
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
- **React course'unda her kategori, gerçek ve çalıştırılabilir bir "Pratik Proje" ile
  biter (Faz 30'dan itibaren kalıcı kural).** Java/Spring derslerindeki `## Ek: Mini
  Proje` (gömülü, tek başına derlenmeyen `.java` dosyaları) React kategorileri için
  kullanılmaz — bunun yerine, kategori bittiğinde ayrı bir repo'da
  (`react-course-projects`, GitHub'da `cdurgun/react-course-projects`) o kategorinin
  tüm kavramlarını birleştiren küçük, gerçek bir Vite/React uygulaması yazılır,
  `npm run build` ile derlemesi doğrulanır, `main` branch'ine commit edilip
  `{kategori-slug}-v1` gibi bir tag ile "dondurulur". İlgili konunun markdown'ında
  (genelde son ana konunun, örn. `jsx`'in EN kategorinin son topic'i olduğu React
  Fundamentals'ta olduğu gibi) bir `## Pratik Proje` bölümü açılıp bu tag'in GitHub
  linkine ve `git clone` + `npm install` + `npm run dev` talimatına yer verilir. Bu
  proje **yalnızca o kategoriye kadar öğretilmiş kavramları kullanır** — state, hook,
  `.map()` ile liste render'ı gibi henüz işlenmemiş kavramlara asla atıfta bulunmaz.
  Ayrı, uzun ömürlü branch'ler **kullanılmaz** — tüm kategori projeleri `main` üzerinde,
  yalnızca tag'lerle versiyonlanır (bkz. Faz 30, "Bilinen Kısıtlar"). `react-course-
  projects` repo kökünde bir **npm workspaces** kurulumu var (`package.json`'da
  `"workspaces": ["projects/*"]`) — yeni bir kategori projesi eklerken `projects/`
  altına yeni bir klasör (kendi `package.json`'ıyla) koymak yeterli, ayrıca bir kurulum
  adımı gerekmez; workspaces otomatik olarak onu da kapsar. Amaç, her proje klasöründe
  ayrı `node_modules` birikmesini önlemek — `npm install` yalnızca repo kökünde bir kez
  çalıştırılır.

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
| 29 | Components & Props kategorisi — Components (6 ana, 4 örnek, BEGINNER), Props (7 ana, 4 örnek, BEGINNER), Component Composition (5 ana + 1 ek, 5 örnek, BEGINNER) — React course'unun ikinci kategorisi; sade dil kararı devam ediyor. Component Composition'daki `## Ek: Mini Proje` (`CardBase.jsx`+`CardDemo.jsx`) Faz 30'da kaldırıldı (bkz. aşağısı) | ✅ TR+EN |
| 30 | "Pratik Proje" standardı: ayrı `react-course-projects` repo'su kuruldu, React Fundamentals (7 ana + Pratik Proje, embed yok değişikliği) ve Components & Props (Component Composition'daki gömülü mini proje kaldırılıp linkle değiştirildi) için gerçek, `npm run build` ile doğrulanmış Vite/React demo projeleri retroaktif olarak yazıldı; bu, tüm gelecek React kategorileri için kalıcı bir kural oldu (bkz. "Mimari" ve "Bilinen Kısıtlar") | ✅ |
| 31 | State & Events kategorisi — Events (7 ana, 5 örnek, BEGINNER), State (7 ana, 5 örnek, BEGINNER), Conditional Rendering (5 ana, 4 örnek, BEGINNER), Lists & Keys (6 ana + Pratik Proje, 4 örnek, BEGINNER) — React course'unun üçüncü kategorisi; kullanıcının "React'in en önemli bölümü" dediği kısım, ilk kez `useState`/state kullanan ve `.map()` ile liste render eden konular; `react-course-projects`'e üçüncü proje (`state-events`, bir görev listesi demosu) eklendi (bkz. "Bilinen Kısıtlar") | ✅ TR+EN |
| 32 | Hooks kategorisi — What Are Hooks? (5 ana, 2 örnek, INTERMEDIATE), useEffect (7 ana, 5 örnek, INTERMEDIATE), useRef (5 ana, 4 örnek, INTERMEDIATE), useMemo & useCallback (6 ana, 4 örnek, INTERMEDIATE), Custom Hooks (6 ana + Pratik Proje, 3 örnek, INTERMEDIATE) — React course'unun dördüncü kategorisi; kullanıcı onayıyla zorluk seviyesi bu kategoriden itibaren INTERMEDIATE'e çekildi; `react-course-projects`'e dördüncü proje (`hooks`, tur kaydı yapan bir kronometre demosu) eklendi (bkz. "Bilinen Kısıtlar") | ✅ TR+EN |
| 33 | Forms kategorisi — Controlled Components (6 ana, 5 örnek, INTERMEDIATE), Form Handling (7 ana + Pratik Proje, 5 örnek, INTERMEDIATE) — React course'unun beşinci kategorisi; ChatGPT planındaki üçüncü topic (Form Libraries) kullanıcı kararıyla atlandı; önceki kategorilerde bilinçli kaçınılan "controlled input" deseni burada ilk kez tam işlendi; `react-course-projects`'e beşinci proje (`forms`, bir kayıt formu demosu) eklendi (bkz. "Bilinen Kısıtlar") | ✅ TR+EN |
| 34 | Routing kategorisi — React Router Basics (7 ana, 5 örnek, INTERMEDIATE), Route Parameters & Navigation (7 ana + Pratik Proje, 5 örnek, INTERMEDIATE) — React course'unun altıncı kategorisi; ChatGPT planındaki tek bir büyük topic (Topic 19 — React Router, 8 kavram) kullanıcı kararıyla ikiye bölündü; `react-router-dom` yerine yeni birleşik `react-router` v8 paketi kullanıldı (bkz. "Bilinen Kısıtlar"); `react-course-projects`'e altıncı proje (`routing`, `/courses`/`/courses/java`/`/courses/java/enum` şemalı bir kurs gezinme demosu) eklendi | ✅ TR+EN |
| 35 | API & Data Fetching kategorisi — Fetching Data (6 ana, 5 örnek, INTERMEDIATE), React + REST API (8 ana + Pratik Proje, 5 örnek, INTERMEDIATE) — React course'unun yedinci kategorisi; ChatGPT planındaki üçüncü topic (API Data Management / TanStack Query) kullanıcı kararıyla şimdilik atlandı; backend olarak gerçek Spring Boot yerine `json-server` (gerçek bir sunucu başlatılıp GET/POST/PUT/DELETE + CORS doğrulanarak) kullanıldı (bkz. "Bilinen Kısıtlar"); `react-course-projects`'e yedinci proje (`api-data-fetching`, json-server'a bağlanan bir kurs CRUD demosu) eklendi | ✅ TR+EN |
| 36 | State Management kategorisi — Sharing State (6 ana, 5 örnek, INTERMEDIATE), Context API (7 ana + Pratik Proje, 5 örnek, INTERMEDIATE) — React course'unun sekizinci kategorisi; ChatGPT planındaki üçüncü topic (State Management Libraries / Redux Toolkit, Zustand) Forms ve API & Data Fetching'teki aynı desenle (planın kendi "daha sonra ekleyebiliriz" notuyla) şimdilik atlandı, bu kez ayrıca sorulmadı; `react-course-projects`'e sekizinci proje (`state-management`, lifting state up + Context API'yi birleştiren bir kurs listesi/favoriler demosu) eklendi | ✅ TR+EN |
| 37 | Advanced React kategorisi — React Performance (6 ana, 5 örnek), Error Boundaries (6 ana, 5 örnek), Lazy Loading & Code Splitting (5 ana, 4 örnek), Suspense (5 ana, 4 örnek), Portals (6 ana + Pratik Proje, 4 örnek) — React course'unun dokuzuncu kategorisi; kategori adı ve içerik karmaşıklığı gerekçesiyle zorluk seviyesi ADVANCED'a yükseltildi; kursun İLK class component'i (Error Boundaries, hook karşılığı yok) burada tanıtıldı; `react-course-projects`'e dokuzuncu proje (`advanced-react`, memo+error boundary+lazy/Suspense+portal'ı birleştiren bir demo) eklendi (bkz. "Bilinen Kısıtlar") | ✅ TR+EN |
| 38 | Testing kategorisi — Component Testing (6 ana, 4 örnek, INTERMEDIATE), User Interaction Testing (7 ana + Pratik Proje, 4 örnek, INTERMEDIATE) — React course'unun onuncu kategorisi; ChatGPT planındaki tek bir topic (Topic 31 — React Testing: Vitest, RTL, component testing, user interaction testing) kendi alt-madde başlıklarına göre ikiye bölündü; Vitest 4.1.10 + React Testing Library 16.3.2 + user-event 14.6.4 + jest-dom 7.0.1 gerçek npm install ile doğrulandı; embed regex'inin (`\{\{(\w+)\.(\w+)}}`) çok-noktalı dosya adlarını (`Component.test.jsx`) desteklemediği keşfedildi, örnek dosyaları tek-nokta convention'ıyla (component+test aynı dosyada) yazıldı; `react-course-projects`'e onuncu proje (`testing`, arama+kayıt demosu + dört gerçek `.test.jsx` dosyası, `npm test` ile doğrulandı) eklendi (bkz. "Bilinen Kısıtlar") | ✅ TR+EN |
| 39 | Production kategorisi — Build & Deployment (7 ana, 2 örnek, INTERMEDIATE), React + Spring Boot Deployment (7 ana + Pratik Proje, 3 örnek, INTERMEDIATE) — React course'unun on birinci ve SON kategorisi (ChatGPT'nin orijinal 11 kategorilik planı tamamlandı); kullanıcının "Vercel'e deploy adımı koyalım mı?" önerisi araştırılıp (Vercel'in Spring Boot'u zero-config desteklemediği doğrulandı) iki ayrı pratik projeye dönüştürüldü: statik bir React app (Vercel) + gerçek bir Spring Boot REST API (Render, Docker) + React (Vercel), CORS + ortam değişkenleriyle bağlı; kullanıcı KENDİ Vercel/Render hesabıyla GERÇEKTEN deploy etti, canlı URL'ler WebFetch ile doğrulandı; bu fazın ortasında `react-course-projects`'teki git tag kullanımı da terk edildi (bkz. "Bilinen Kısıtlar") | ✅ TR+EN |
| 40 | Microservices kategorisi (spring-boot kursu, 3. kategori) açıldı — `microservices-fundamentals` (17 ana bölüm, 0 örnek/kod yok — bilinçli karar, INTERMEDIATE, title sonradan "Microservices Temelleri"/"Microservices Fundamentals" olarak düzeltildi — kullanıcı sidebar'da başlığın 3 kez tekrarlandığını fark etti) — monolit vs mikroservis, servis sınırları (bounded context), database per service, dağıtık sistemlerin getirdiği yeni zorluklar, CAP teoremi, Conway Yasası, "modüler monolith", karar kriterleri; `spring-boot-microservice-basics` (13 ana bölüm, 5 örnek — kategorinin İLK kod içeren topic'i, INTERMEDIATE) — tek bir mikroservisin (`order-service`) yapılandırılması: `@SpringBootApplication` giriş noktası, kendi `application.yml`'i (port/uygulama adı/veritabanı, Twelve-Factor App'e kısa bakışla), REST controller/service/domain model üçlüsü, `spring-boot-starter-actuator` ile health check; ChatGPT'nin 12 topic'lik planı wave'lere bölündü, ilk dalganın (3 topic) ilk ikisi yazıldı, kalan 11 aday konu henüz DB'ye seed edilmedi; pratik proje ayrı, izole bir repoda (`microservices-course-projects`, öneri onaylandı) olacak, wave'in son topic'inde (`inter-service-communication`) teslim edilecek; sandbox'ta artık Java 21/Maven kurulu ama Maven Central proxy'den engelli (bkz. "Bilinen Kısıtlar"); kullanıcı kendi ortamında uygulamayı çalıştırıp `spring-boot-microservice-basics`/EN'de canlı bir HTTP 500 hatası buldu ve raporladı — `MarkdownService.applyCallouts`, `Matcher.replaceAll(Function)`'ın replacement'ı `quoteReplacement` ile sarmaması yüzünden callout içindeki `${ORDERS_DB_PASSWORD}` metnini named-group referansı sanıp patlıyordu; `injectCodeExamples`'taki güvenli manuel `appendReplacement` deseniyle düzeltildi (bu kategoride bulunan ilk gerçek uygulama kodu hatası, kullanıcının kendi ortamında yeniden derleme/restart gerektiriyor); wave'in üçüncü ve son topic'i `inter-service-communication` (13 ana bölüm + Pratik Proje, 8 örnek, INTERMEDIATE) yazıldı — `order-service`'in yanına ikinci bir mikroservis (`inventory-service`, port 8082) eklenip Spring 6.1'in `RestClient`'ıyla senkron bir REST çağrısı kuruldu (404 ile bağlantı hatasının ayrıştırılması, `InventoryServiceUnavailableException`, servisler arası DTO ayrımı — `StockCheckResponse` vs `InventoryItem`, `@Value` ile yapılandırılan base URL); React kategorilerindeki "Pratik Proje" standardının Maven karşılığı ilk kez uygulandı — ayrı, izole `microservices-course-projects` reposu (npm workspaces yerine kardeş klasörler, `projects/inter-service-communication/{order-service,inventory-service}/`) gerçek, çalıştırılabilir iki servisle kuruldu, git tag KULLANILMADI (react-course-projects'teki güncel kuralla tutarlı); **wave 1 (3 topic) TR+EN tamamlandı**, kalan 9 aday konu için devam kararı kullanıcıyla birlikte verilecek | ✅ TR+EN |
| 41 | Microservices'e ARA VERİLDİ (wave 1 tamamlanmış durumda, istendiğinde devam edilecek); `java` kursuna dördüncü kategori açıldı — `functional-interfaces-streams` ("Functional Interfaces & Streams", sort_order=4) — kullanıcının ChatGPT'nin 11 maddelik planını ikiye (Functional Interfaces / Streams) bölme sorusuna karşı TEK kategori önerildi ve onaylandı (gerekçe: "Functional Interface → Lambda → Stream → Intermediate → Terminal" zincirini sürekli gösterme hedefi, 9 topic'e kadar çıkmış precedent — Spring MVC, ikiye bölünseydi "Functional Interfaces" kategorisinin yalnızca 2 topic'ten oluşacak olması); 7 topic'lik plan çıkarıldı, ilk topic `lambda-expressions` (11 ana bölüm, 4 örnek, INTERMEDIATE) yazıldı — parametre yazım kuralları (sıfır/tek/çoklu), expression vs block body, target typing, effectively final değişken yakalama, anonymous inner class'a karşı `this` farkı; `oop` kategorisindeki `interface` dersinin zaten var olan "Functional Interface ve Lambda" bölümüne çapraz referans verilip TEKRAR anlatılmadı, doğrudan derinleşildi; kullanıcının onayıyla Faz 12'den beri geçerli "derleme yok" kuralına istisna yapıldı — bu kategori saf JDK olduğu için (Spring Boot'un aksine Maven Central'a bağımlı değil) 4 örnek de gerçekten `javac`+`java` ile derlenip çalıştırılarak çıktıları doğrulandı (bu arada `Class.getSimpleName()`'in anonymous class'larda boş string döndüğü keşfedildi, `getName()`'e çevrildi); aynı fazda ikinci topic `built-in-functional-interfaces` (13 ana bölüm, 6 örnek, INTERMEDIATE, başlık sidebar için "Mikroservis Yapılandırma" precedent'iyle kısaltıldı) da TR+EN birlikte yazıldı — `Predicate<T>`, `Function<T,R>`, `Consumer<T>`/`Supplier<T>`, `UnaryOperator<T>`/`BinaryOperator<T>` ve dört method reference biçimi (`Class::staticMethod`, `object::instanceMethod` bound, `Class::instanceMethod` unbound, `Class::new` constructor reference — bir `record Point` ile); `lambda-expressions`'daki target typing bölümüne ve `interface`'teki functional interface bölümüne çapraz referans verildi; aynı sandbox-compile süreciyle 6 örnek de gerçekten `javac`+`java` ile doğrulandı | ✅ TR+EN |
| 42 | Kullanıcı, Faz 41'de yazılan iki topic'in (`lambda-expressions`, `built-in-functional-interfaces`) TR/EN ders metninin ilk paragrafında yer alan "Örnekler gerçekten derlenip çalıştırılarak doğrulandı." / "Examples were actually compiled and run to verify them." cümlesini fark edip çıkarılmasını istedi — içerik dosyalarından kaldırıldı; migration'lardaki (V179, V182) `summary` alanları da İLK ÖNCE (YANLIŞLIKLA) elle düzenlendi, bu hatanın düzeltmesi Faz 43'te (bkz. aşağısı) yapıldı; bundan sonraki topic'lerde bu tür bir cümle hiç yazılmayacak (kullanıcı isteği, kalıcı kural). Aynı fazda üçüncü topic `stream-fundamentals` (13 ana bölüm, 6 örnek, INTERMEDIATE, sort_order=3) TR+EN yazıldı — orijinal 7 topic'lik plandaki "Stream API" ve "Intermediate Operations" maddeleri tek topic'te birleştirildi (gerekçe: ikisi kavramsal olarak ayrılamayacak kadar iç içe); Stream nedir (veri saklamayan tek geçişlik pipeline), source (`stream()`/`Stream.of()`/`Arrays.stream()`/`Stream.iterate()`), pipeline'ın üç aşaması, `filter()`/`map()`/`flatMap()`, `distinct()`/`sorted()`/`peek()`, `limit()`/`skip()`, lazy evaluation, ve stream'in tek kullanımlık doğası (`IllegalStateException` gerçek olarak yakalanıp gösterildi); kullanıcının paylaştığı `names.stream().filter(...).map(...).toList()` örneği "Neden Var?" bölümünde `interface`/`lambda-expressions`/`built-in-functional-interfaces`'in bir araya geldiği nokta olarak doğrudan kullanıldı; 6 örnek yine sandbox-compile süreciyle gerçekten doğrulandı (bu doğrulama artık yalnızca migration yorumlarında belgeleniyor, ders metninde değil) | ✅ TR+EN |
| 43 | HATA DÜZELTMESİ: kullanıcı uygulamayı çalıştırınca gerçek bir Flyway hatası aldı — "Migration checksum mismatch for migration version 179/182" — Faz 42'de V179/V182'nin yerinde (in-place) düzenlenmesi YANLIŞTI, bu migration'lar kullanıcının kendi veritabanında ÇOKTAN uygulanmıştı (CLAUDE.md'nin "asla uygulanmış migration'ı düzenleme" kuralının tam olarak uyarmaya çalıştığı durum); `V179`/`V182` orijinal haline (cümle geri eklenerek) döndürüldü, checksum'lar eski haline döndü; asıl düzeltme (cümlenin `summary` alanından kaldırılması) yeni bir migration'la (`V188`, dört `topic_translation` satırına UPDATE) doğru şekilde uygulandı; ders metninin kendisi bu hatadan etkilenmedi (DB'de değil dosya sisteminde tutuluyor); kullanıcı düzeltmeyi kendi ortamında çalıştırıp hatasız olduğunu doğruladı | ✅ Düzeltildi |
| 44 | Kategorinin dördüncü topic'i `terminal-operations` (V189-V191, sort_order=4, INTERMEDIATE, 14 ana bölüm, 6 örnek) TR+EN yazıldı — `forEach()`, `reduce()` (üç overload), `count()`, `min()`/`max()`, `findFirst()`/`findAny()`, `anyMatch()`/`allMatch()`/`noneMatch()`, `toList()`/`toArray()`; `collect()`'in asıl gücü (Collectors) bilinçli olarak DAHIL EDİLMEDİ, bir sonraki topic'e (`collectors`) ayrıldı; `stream-fundamentals`'daki "Stream Pipeline: Source, Intermediate, Terminal" bölümüne ve `built-in-functional-interfaces`'teki `Class::new`'e çapraz referans verildi. GERÇEK BİR KEŞİF: `ShortCircuitExample.java` ilk yazımda "count() her elemanı işler, kısa devre yapmaz" varsayımıyla yazılmıştı; sandbox'ta gerçekten çalıştırılınca bunun YANLIŞ olduğu ortaya çıktı — `Stream.of(1,2,3).peek(...).count()` çalıştırıldığında `peek()`'in içindeki yazdırma satırı HİÇ ÇALIŞMADI, çünkü JDK source'un boyutu bilindiğinde `count()`'u pipeline'ı hiç çalıştırmadan doğrudan hesaplayabiliyor (Stream.count() javadoc'unda belgelenen kasıtlı bir optimizasyon); örnek kod ve ders metni bu gerçek gözlemi yansıtacak şekilde yazıldı — sandbox-compile sürecinin (Faz 41'den beri) tam olarak bunun için var olduğunu gösteren bir örnek. Kullanıcı isteğiyle (Faz 42) ders metninde "derlenip doğrulandı" cümlesi yok, doğrulama yalnızca migration yorumunda | ✅ TR+EN |
| 45 | Kategorinin beşinci topic'i `collectors` (V192-V194, sort_order=5, INTERMEDIATE, 13 ana bölüm, 6 örnek) TR+EN yazıldı — bir `Collector`'ın üç bileşeni (supplier/accumulator/combiner, kavramsal giriş), `Collectors.toList()`/`toSet()` (`toList()`'in `Stream.toList()`'in aksine MUTABLE olduğu vurgulandı), `joining()` (3 overload), `groupingBy()` (+ downstream collector olarak `counting()`/`mapping()`), `partitioningBy()` (her iki anahtarın da her zaman var olması, `groupingBy()`'dan farkı), `toMap()` (iki argümanlı hali çakışan anahtarda gerçek bir `IllegalStateException` fırlatıp yakalanarak gösterildi, üç argümanlı merge fonksiyonu hali); `terminal-operations`'taki "toList() ve toArray(): Basit Koleksiyona Dönüştürme" bölümüne çapraz referans verildi — `Stream.toList()` (immutable) ile `collect(Collectors.toList())` (mutable) farkı iki dersi birbirine bağlayan ana nokta oldu. 6 örnek sandbox-compile süreciyle gerçekten doğrulandı (yalnızca migration yorumunda belgeleniyor, ders metninde değil) | ✅ TR+EN |
| 46 | Kategorinin altıncı topic'i `optional` (V195-V197, sort_order=6, INTERMEDIATE, 13 ana bölüm, 6 örnek) TR+EN yazıldı — `Optional<T>`'ın var olma sebebi, `of()`/`ofNullable()`/`empty()`, `isPresent()`/`isEmpty()`/`get()`, `orElse()` vs `orElseGet()` (eager vs lazy — gerçek çalıştırma çıktısıyla doğrulandı: `orElse()`'in argümanı Optional DOLU olsa bile her zaman hesaplanıyor, `orElseGet()`'in Supplier'ı yalnızca BOŞSA çağrılıyor), `orElseThrow()` (iki biçim), `map()`/`flatMap()` (Stream'deki aynı iç içelik probleminin Optional karşılığı), `ifPresent()`/`ifPresentOrElse()`, `filter()`; `terminal-operations`'taki Optional dönen beş metoda çapraz referans verildi. 6 örnek sandbox-compile süreciyle gerçekten doğrulandı (yalnızca migration yorumunda belgeleniyor) | ✅ TR+EN |
| 47 | Kategorinin yedinci ve SON topic'i `primitive-parallel-streams` (V198-V200, sort_order=7, INTERMEDIATE, 15 ana bölüm, 6 örnek) TR+EN yazıldı — bu, kullanıcının "kalan 2 topiği bitirebilirsin" onayıyla `functional-interfaces-streams` kategorisinin PLANLANAN 7 TOPIC'İNİN TAMAMINI tamamlıyor. Kapsam: `IntStream`/`LongStream`/`DoubleStream` (autoboxing maliyeti), `range()`/`rangeClosed()`/`of()`, `sum()`/`average()`/`max()`/`min()`, `boxed()`/`mapToObj()` ve `mapToInt()`/`mapToLong()`/`mapToDouble()` köprüleri, `parallelStream()`/`.parallel()`, `forEach()` vs `forEachOrdered()`, thread-safe olmayan paylaşılan durum tuzağı, ne zaman kullanılmalı, neden her zaman daha hızlı olmadığı. ÜÇ GERÇEK GÖZLEM: (1) `ParallelOrderingExample.java` — aynı 10 elemanlı listede paralel `forEach()` sırayı gerçekten bozdu, `forEachOrdered()` korudu; (2) `ParallelPitfallExample.java` — 100.000 elemanlı listede thread-safe olmayan bir `ArrayList`'e paralel yazmak, hiçbir istisna fırlatmadan, çalıştırmadan çalıştırmaya 96.901-100.000 arası değişen boyutlar üretti (gerçek, sessiz bir veri yarışı); (3) EN ÖNEMLİSİ: `ParallelOverheadExample.java`'nın İLK YAZIMI, ısıtmasız (no-warmup) tek seferlik bir `nanoTime()` karşılaştırmasıyla YANLIŞ bir sonuç verdi — sıralı yol, sırf ilk çalışan yol olduğu için (JIT henüz devrede değilken) paralelden defalarca daha yavaş çıktı, beklenenin tam tersi; örnek her iki yolu da 10.000 kez ısıtıp SONRA ölçecek şekilde yeniden yazıldı, ısıtılmış ölçümle sonuç beklenen yöne döndü (sıralı ~15ms, paralel ~41ms) — sandbox-compile sürecinin tam olarak önlemeye çalıştığı türden bir hataydı, gerçek çalıştırma olmasaydı ders yanlış bir iddiayla yayınlanabilirdi. 6 örnek sandbox-compile süreciyle gerçekten doğrulandı. **KATEGORİ TAMAMLANDI: `functional-interfaces-streams` artık 7/7 topic TR+EN tamamlanmış durumda** | ✅ TR+EN, KATEGORİ TAMAMLANDI |
| 48 | Marka/kimlik eklendi: kullanıcı `learnforgex.com` domain'ini satın aldı (ChatGPT'nin önerdiği "learnforge" alınmış olduğu için "learnforgex" alınmış), site adının nereye konacağını sordu ve bir ikon istedi. Bir SVG ikon tasarlandı (64x64 viewBox, koyu lacivert/slate gradient köşeli kare zemin üzerinde, turuncu/amber gradient'li iki köşeli parantez `<` `>` -- kod/geliştirici temasını temsil ediyor -- ortadaki boşlukta küçük bir 4 uçlu kıvılcım/yıldız, "forge" (dövmek/işlemek) temasına gönderme) -- Playwright ile (bu sandbox'ta headless Chromium kurulu) gerçek bir HTML sayfasına render edilip ekran görüntüsü alınarak 16px/32px/64px'te ve hem açık hem koyu zeminde görsel olarak doğrulandı, ilk tasarım onaylandı (iterasyon gerekmedi). Üretilen dosyalar (`static/img/`): `favicon.svg` (yalnızca ikon), `logo.svg`/`logo-dark.svg` (ikon + "LearnForgeX" kelime markası, sırasıyla açık/koyu zemin için, `<text>` elemanıyla taşınabilir tek SVG), `favicon.ico`/`favicon-16.png`/`favicon-32.png`/`apple-touch-icon.png` (ImageMagick `convert` ile SVG'den PNG/ICO'ya çevrilerek üretildi -- `rsvg-convert` kurulu değildi, bu yüzden önce Playwright ile şeffaf arka planlı 512x512 PNG render edilip oradan küçültüldü). Site adı üç yere kondu: (1) navbar (`fragments/layout.html` :: navbar) -- ikon + "Learn**Forge**X" kelime markası, "Forge" hecesi `.brand-accent` (#fbbf24, ikondaki amber gradient'le eşleşen düz renk, `custom.css`'e eklendi) ile vurgulanıyor; (2) footer -- aynı kelime markası, "Learning Platform" yerine; (3) her iki sayfanın `<title>` etiketi -- anasayfada `'LearnForgeX — ' + #{home.heading}`, konu sayfalarında mevcut SEO title/topic title'a `' | LearnForgeX'` soneki eklendi (SEO/browser-tab tutarlılığı için yaygın pratik). `home.heading`'deki ("Java Öğrenim Platformu"/"Java Learning Platform") açıklayıcı slogan BİLİNÇLİ OLARAK değiştirilmedi -- marka adı (LearnForgeX) ile açıklayıcı slogan ayrı, tamamlayıcı roller (çoğu gerçek sitede olduğu gibi). `favicon.svg`/`favicon-32.png`/`favicon-16.png`/`apple-touch-icon.png` her iki `<head>`'e (`index.html`, `topic.html`) `<link rel="icon">`/`<link rel="apple-touch-icon">` olarak eklendi; `favicon.ico` ayrıca `static/` kökününe de kopyalandı (tarayıcıların `<link>` etiketini görmeden önce varsayılan olarak istediği `/favicon.ico` için). `README.md`'nin başlığı da "Learning Platform"dan "LearnForgeX"e güncellendi, canlı adres notu eklendi | ✅ Uygulandı |
| 49 | HATA DÜZELTMESİ: kullanıcı uygulamayı çalıştırınca `V198__primitive_parallel_streams_topic.sql`'de gerçek bir Flyway hatası aldı -- `ERROR: value too long for type character varying(500)`. Kök neden: `topic_translation.seo_description` sütunu `VARCHAR(500)` (bkz. `V1__init_schema.sql`), ama TR `seo_description` 542, EN `seo_description` 504 karakterdi -- her iki dilde de sınırı aşıyordu (`title`/`seo_title` VARCHAR(255) sınırları içindeydi, `summary` zaten TEXT/sınırsız). Bu, Faz 43'teki checksum-mismatch hatasından FARKLI bir durum: migration script hata fırlatıp transaction rollback olduğu (PostgreSQL'de DDL/DML transactional) için flyway_schema_history'e HİÇ satır yazılmadı -- yani V198 kullanıcının veritabanında hiçbir zaman "uygulanmış" sayılmadı, bu yüzden immutability kuralını ihlal etmeden DOĞRUDAN V198'i düzenlemek güvenliydi (yeni bir düzeltme migration'ı gerekmedi). İki `seo_description` metni anlam kaybı olmadan kısaltıldı (TR 482, EN 463 karaktere indirildi), apostrof-ikileme kontrolü tekrar yapıldı. Kategorideki TÜM diğer migration'lar (V179-V200) aynı script ile taranıp `title`/`seo_title`/`seo_description` sınırları için kontrol edildi, başka ihlal bulunmadı. **KALICI KURAL:** bundan sonra yazılacak her migration'da `seo_description` alanı için (Python ile) karakter sayısı 500'ü (idealde ~480'i) aşmadığından emin olunacak -- bu VARCHAR(500) sınırı artık standart doğrulama adımlarından biri (apostrof-ikileme kontrolüyle aynı anda yapılabilir) | ✅ Düzeltildi |
| 50 | Navbar'daki logonun altına marka sloganı eklendi: kullanıcıya "Forge your skills" ve "Build your software skills" seçenekleri sunuldu, gerekçeyle ("Forge" kelimesi marka adıyla ("LearnForgeX") kelime oyunu kuruyor, daha kısa, navbar'a daha iyi sığıyor) "Forge your skills" önerildi ve kullanıcı onayladı. `fragments/layout.html` :: navbar -- marka adı (`Learn<span class="brand-accent">Forge</span>X`) artık `d-flex flex-column lh-1` bir sarmalayıcı içinde, altında `<small class="navbar-tagline">Forge your skills</small>`; `custom.css`'e `.navbar-tagline` kuralı eklendi (0.65rem, uppercase, `rgba(255,255,255,.55)` -- navbar-dark zemine göre soluk/ikincil metin rengi). Slogan bilinçli olarak Türkçeye çevrilmedi -- "Forge" kelime oyunu çeviride kaybolacağından, kısa İngilizce marka sloganlarının yerelleştirilmeden bırakılması tercih edildi (yaygın pratik). Playwright ile hem masaüstü hem 375px mobil genişlikte görsel olarak doğrulandı, navbar iki satırlı marka bloğuyla düzgün büyüyor, TR/EN dil butonlarıyla çakışmıyor; navbar `sticky`/`fixed` olmadığı için sağdaki TOC'un `sticky-top` konumlanmasını etkilemiyor | ✅ Uygulandı |
| 51 | Kullanıcı, ChatGPT'nin `java-basics`'i genişletme önerisini (String, Arrays, Scanner, Wrapper Classes & Autoboxing, Date & Time API, File I/O, Enum, Record, Reflection + ayrı bir "Collections" ve "Functional Programming" kategorisi) paylaşıp yorum istedi. Değerlendirme: Enum/Records/Reflection/Date & Time API zaten `java-basics`'te mevcuttu, "Functional Programming" önerisi de zaten `functional-interfaces-streams` olarak tamamlanmıştı (farklı isim/gruplama, aynı kapsam) -- gerçekten yeni olan: String, Arrays, Scanner, Wrapper Classes & Autoboxing, File I/O (java-basics'e 5 yeni topic) ve tamamen yeni bir Collections kategorisi. Reflection'ın DB'de `difficulty=ADVANCED` olmasına rağmen java-basics'te erken sırada (sort_order=3) durmasının tutarsız olduğu tespit edildi (ileride düzeltilecek, henüz yapılmadı). ChatGPT'nin Collections alt maddelerini (List, ArrayList, LinkedList, Set, HashSet, Map, HashMap, Queue, Collections Utility -- 9 madde) ayrı ayrı topic yapma önerisine katılınmadı -- bu projenin yerleşik pratiğiyle (`built-in-functional-interfaces`'in 4 interface tipini + method reference'ları TEK topic'te toplaması gibi) 4 topic'e indirgenmesi önerildi: Lists, Sets, Maps, Queues & Collections Utility. Ayrıca bağımsız bir gözlem paylaşıldı: Collections kategorisi gerçek bir içerik boşluğunu dolduruyor -- `collectors` topic'i (functional-interfaces-streams) zaten `groupingBy()` gibi `Map<K,List<V>>` üreten API'leri anlatıyor ama List/Set/Map temellerini anlatan hiçbir topic yoktu. Kullanıcı onayladı ("Önce Collections kategorisini yapabilirsin"). `java` kursuna yeni kategori: `collections` (V201, sort_order=2, java-basics(1) ile oop arasına -- oop(2→3), concurrency(3→4), functional-interfaces-streams(4→5) kaydırıldı, yalnızca `category.sort_order` UPDATE edildi, hiçbir topic'e dokunulmadı). İlk topic `lists` (V201-V203, sort_order=1, BEGINNER, 20 dk, 12 ana bölüm, 6 örnek) TR+EN yazıldı -- `List` arayüzü (sıralı + indeksli + tekrar edenlere izin verir), `ArrayList`/`LinkedList` implementasyon farkı, temel işlemler (`add`/`get`/`set`/`remove`/`contains`/`indexOf`), `List.of()`/`Collections.unmodifiableList()`/`List.copyOf()` (immutable liste vs. görünüm vs. bağımsız kopya farkı), `Iterator`/`ListIterator` ile güvenli dolaşma (`ConcurrentModificationException`), `List.sort(Comparator)` + `Comparator.comparing().thenComparing()`, `subList()`/`toArray()`. GERÇEK ÖLÇÜM (sandbox-compile, bu kategori de saf JDK): `ArrayListVsLinkedListExample.java`, Faz 47'deki ısıtma dersini (warmed-up measurement) burada da uyguladı -- 20.000 elemanlı listede 3.000 kez `get(middle)`, ArrayList'te ölçülemeyecek kadar hızlı (0 ms), LinkedList'te ~48 ms; 20.000 kez `add(0,...)` ise ArrayList'te ~16-17 ms, LinkedList'te ~1 ms -- beklenen O(1)/O(n) farkını gerçek çalıştırmayla doğruladı. `List<Integer>.remove(int)` vs `remove(Object)` karışıklığı da gerçek bir uyarı olarak (`remove(2)` index'i siler, değeri değil) hem koda hem derse işlendi. Kategorinin ilk topic'i olduğu için (henüz hiçbir Collections/java-basics ileri konusu yazılmadığından) çapraz referans verilmedi -- sonraki 3 topic'te (Sets, Maps, Queues & Collections Utility) `lists`'e geriye dönük referans verilecek | ✅ TR+EN |
| 52 | Kullanıcı onayıyla ("KOntrol ettim, devam edebilirsin") Collections kategorisinin ikinci topic'i `sets` (V204-V206, sort_order=2, BEGINNER, 20 dk, 12 ana bölüm, 6 örnek) TR+EN yazıldı -- `Set` arayüzü (tekrar eden elemanlara izin vermez, index erişimi yok), `HashSet`/`LinkedHashSet`/`TreeSet` implementasyon farkları, `TreeSet`'in `NavigableSet` metotları (`first`/`last`/`higher`/`lower`/`ceiling`/`floor`/`headSet`/`tailSet`), `equals()`/`hashCode()` sözleşmesinin `HashSet` için neden kritik olduğu, küme işlemleri (`addAll`/`retainAll`/`removeAll` ile birleşim/kesişim/fark). "Lists" dersine geriye dönük çapraz referans verildi (intro paragrafında). GERÇEK KEŞİF: `HashSetEqualsHashCodeExample.java`, `equals()`/`hashCode()` override edilmeden `HashSet`'e eklenen iki "değerce eşit" (aynı x/y) nesnenin GERÇEKTEN farklı sayıldığını (boyut=2, override edilince boyut=1) canlı çalıştırmayla gösterdi -- varsayımla değil, gerçek `System.out` çıktısıyla doğrulandı. GERÇEK ÖLÇÜM: `SetPerformanceExample.java` iki aşamalı ölçüm yaptı -- (1) 20.000 elemanlı koleksiyonda 2.000 kez `contains()`: `List` ~70-90 ms, `HashSet`/`TreeSet` ölçülemeyecek kadar hızlı (0 ms); (2) bu ölçekte `HashSet`/`TreeSet` farkı görünmediği için 200.000 elemana/tekrara çıkarıldı: `HashSet` ~9-10 ms, `TreeSet` ~15-21 ms -- O(1)/O(log n) farkı ancak büyük ölçekte gerçekten ölçülebilir hâle geldi (ilk denemede `TreeSet`'in ayrı bir avantajı görülmedi, bu da ders metnine dürüstçe yansıtıldı). 6 örnek sandbox-compile süreciyle gerçekten doğrulandı | ✅ TR+EN |
| 53 | HATA DÜZELTMESİ: kullanıcı, `lists`/`sets` örnek dosyalarındaki (`examples/{topic-slug}/*.java`) kod yorumlarının ve `System.out.println()` metinlerinin Türkçe kaldığını fark etti -- bir ekran görüntüsüyle gösterdi (EN sayfasında gömülü kodun içinde Türkçe metin görünüyordu). KÖK NEDEN: mimari gereği örnek dosyalar dile göre AYRILMIYOR -- `examples/{topic-slug}/` klasöründeki TEK bir `.java` dosyası hem `content/tr/{slug}.md` hem `content/en/{slug}.md`'ye aynı `{{Example.java}}` embed'iyle gömülüyor (bkz. "Mimari"). `functional-interfaces-streams` kategorisinde (Faz 41'den beri) örnekler zaten İngilizce yazılmıştı (tam olarak bu yüzden -- tek kaynak, iki dilde de doğru görünmeli); ama bu oturumda `lists`/`sets` yazılırken (Faz 51/52) bu kurala dikkat edilmeden yanlışlıkla Türkçe yorum/çıktı metniyle yazıldı -- bu bir REGRESYONDU. Kullanıcı "Belki ileride kod örneklerini Türkçeye çeviren bir geliştirme yapabiliriz" diyerek, dile göre ayrı örnek dosyaları (per-language code example) desteğinin İLERİDE bir mimari geliştirme olabileceğini ama ŞİMDİLİK tek, paylaşılan kaynağın İngilizce olmasının doğru olduğunu ima etti. DÜZELTME: `lists`/`sets`'teki 12 örnek dosyasının TAMAMI (yorumlar + `println()` string'leri + `LinkedHashSetExample.java`'daki meyve isimleri) İngilizceye çevrildi, hepsi yeniden `javac`+`java` ile gerçekten derlenip çalıştırılarak MANTIK/ÇIKTI DEĞİŞMEDİĞİ doğrulandı. Bu sırada küçük bir keşif: `LinkedHashSetExample.java`'da ilk seçilen İngilizce meyve isimleri (`banana/apple/kiwi/pear`) tesadüfen HashSet ile LinkedHashSet'te AYNI sırayı üretti (dersin göstermeye çalıştığı "sıralar farklı olabilir" noktasını zayıflatıyordu) -- birkaç kelime kombinasyonu gerçekten denenip (`mango/apple/kiwi/grape`) HashSet/LinkedHashSet'in GERÇEKTEN farklı sıra ürettiği doğrulanan bir kombinasyon seçildi. `content/tr/lists.md` ve `content/tr/sets.md` (ve EN karşılıkları) kontrol edildi, hiçbiri örnek çıktısından birebir Türkçe/İngilizce metin alıntılamıyor (yalnızca kavramsal açıklama), bu yüzden ders metinlerinde değişiklik gerekmedi. **KALICI KURAL (Faz 41'den beri geçerliydi, şimdi netleştirildi):** bundan sonra yazılacak her `examples/{topic-slug}/*.java` (ve `.jsx` vb.) dosyasındaki TÜM yorum ve string literal (println çıktıları dahil) İNGİLİZCE yazılacak -- örnek dosyalar dile göre ayrılmadığı için tek kaynak her iki dilde de doğru görünmeli. NOT: `java-basics`/`oop`/`react`/`spring-boot` kategorilerindeki ~170 ÖNCEDEN VAR OLAN örnek dosyasında da aynı sorun var (bu proje boyunca hep böyleydi, bu oturuma özgü değil) -- kullanıcıya sorulduğunda ("Şimdilik dokunma, sonra konuşuruz") bunlara ŞİMDİLİK DOKUNULMAMASI, ileride ayrı bir görev olarak ele alınması kararlaştırıldı. Bu ~170 dosya bilinçli olarak Türkçe bırakıldı, unutulmadı | ✅ Düzeltildi |
| 54 | Kullanıcı onayıyla ("Olur devam edebilirsin") Collections kategorisinin üçüncü topic'i `maps` (V207-V209, sort_order=3, BEGINNER, 20 dk, 12 ana bölüm, 6 örnek) TR+EN yazıldı -- örnekler Faz 53'te netleştirilen kurala uyularak baştan İNGİLİZCE yazıldı (yorumlar + println çıktıları), regresyon tekrarlanmadı. Kapsam: `Map<K,V>` arayüzü (`Collection`'ı genişletmez, ayrı bir hiyerarşi), `HashMap`/`LinkedHashMap`/`TreeMap` farkları (Set'teki üçlüyle birebir paralel), `NavigableMap` metotları (`firstKey`/`lastKey`/`higherKey`/`lowerKey`/`ceilingKey`/`floorKey`/`headMap`/`tailMap`), immutable map'ler (`Map.of()`/`Map.ofEntries()`/`Map.entry()`/`Collections.unmodifiableMap()`/`Map.copyOf()`), Java 8'in modern API'si (`getOrDefault()`/`putIfAbsent()`/`computeIfAbsent()`/`computeIfPresent()`/`merge()` -- kelime sayımı ve isimleri ilk harfe göre gruplama örnekleriyle), ve `entrySet()` ile `keySet()+get()` arasındaki performans farkı. "Sets" dersine iki yerde geriye dönük çapraz referans verildi: intro paragrafında (Set'in "her eleman bir kez" fikrinin Map'te "her anahtar bir kez + değer"e genişlemesi) ve equals()/hashCode() uyarısında (tam başlık alıntısıyla: "equals() ve hashCode() Sözleşmesi"). GERÇEK ÖLÇÜM: `MapIterationPerformanceExample.java`, 200.000 girişlik bir `HashMap`'te değerleri 50 kez toplayan iki dolaşma yolunu ölçtü -- `entrySet()` ~120-145 ms, `keySet()+get()` (her eleman için gereksiz bir ikinci arama yapıyor) ~140-170 ms; fark birden fazla çalıştırmada tutarlı çıktı. Yazım sırasında `seo_description` alanları (TR 518, EN 500 karakter) VARCHAR(500) sınırına takıldı/yaklaştı -- Faz 49'daki dersin doğrudan uygulanmasıyla (karakter sayısı kontrolü artık standart adım) her iki metin de yayınlanmadan ÖNCE kısaltıldı (TR 441, EN 429), migration hiç sorunlu hâle gelmeden düzeltildi. 6 örnek sandbox-compile süreciyle gerçekten doğrulandı | ✅ TR+EN |
| 55 | Kullanıcı onayıyla ("devam edebilirsin") Collections kategorisinin dördüncü ve SON topic'i `queues-collections-utility` (V210-V212, sort_order=4, BEGINNER, 20 dk, 12 ana bölüm, 6 örnek) TR+EN yazıldı -- örnekler baştan İNGİLİZCE yazıldı (yorumlar + println çıktıları), Faz 53 kuralına uyuldu. **BU MİGRATION'LA `collections` KATEGORİSİ TAMAMLANDI (4/4 topic: Lists, Sets, Maps, Queues & Collections Utility)** -- `functional-interfaces-streams`'in tamamlanmasıyla aynı desende. Kapsam: `Queue`/`Deque` arayüzleri (her işlem için iki paralel metot ailesi -- istisna fırlatan `add()`/`remove()`/`element()` vs. özel değer dönen `offer()`/`poll()`/`peek()`), `Deque`'ın her iki uçtan erişimi (`addFirst`/`addLast`/`removeFirst`/`removeLast`/`peekFirst`/`peekLast`), `ArrayDeque`'ın hem kuyruk hem stack (`push()`/`pop()`) olarak `java.util.Stack`'e (resmi javadoc önerisiyle) ve `LinkedList`'e tercih edilmesi, `PriorityQueue`'nun heap tabanlı yapısı, ve `Collections` yardımcı sınıfının statik metotları (`sort`/`reverse`/`shuffle`/`max`/`min`/`frequency`/`binarySearch` + `emptyList`/`singletonList`/`nCopies` factory metotları). Queue/Deque ve Collections Utility, "Primitive & Parallel Streams" dersinde uygulanan aynı gerekçeyle (kısa, bağımsız alt konuları tek topic'te birleştirmek) tek topic'te toplandı. GERÇEK KEŞİF: `PriorityQueueExample.java`, bir `PriorityQueue`'yu doğrudan `System.out.println()` ile yazdırmanın SIRALI ÇIKTI VERMEDİĞİNİ canlı çalıştırmayla gösterdi -- gerçek çıktı `[10, 20, 40, 50, 30]` (heap invariant'ı yalnızca kökün en küçük olmasını garanti eder, geri kalanı için sıra garantisi yoktur); sıralı çıktı için tekrar tekrar `poll()` çağırmak gerektiği hem kodda hem derste gösterildi. GERÇEK ÖLÇÜM: `ArrayDequeVsLinkedListPerformanceExample.java`, 5 milyon `offer()`+`poll()` çiftinde `ArrayDeque`'ı `LinkedList`'e karşı ölçtü -- birkaç parametre denemesinden sonra (500k tur/50k ısıtma önce tutarsız sonuçlar verdi, 5M tur/500k ısıtmaya çıkarılarak daha kararlı hâle getirildi) `ArrayDeque` çoğu çalıştırmada belirgin şekilde daha hızlı çıktı (örn. ~40ms'ye karşı ~55-60ms), ama fark her çalıştırmada aynı oranda değildi -- bu run-to-run değişkenlik dürüstçe derste `LinkedList`'in her eleman için ayrı node nesnesi tahsis etmesinin garbage collector üzerinde değişken baskı yaratmasına bağlandı (`ArrayDeque` hiçbir çalıştırmada daha yavaş ölçülmedi). 6 örnek sandbox-compile süreciyle gerçekten doğrulandı, Türkçe karakter taraması temiz çıktı verdi | ✅ TR+EN — KATEGORİ TAMAMLANDI |
| 56 | Kullanıcı isteğiyle ("Java Basics kategorisine dönebiliriz istersen. String topic sanırım ilk konu? Enum'dan önce gelmesi lazım") `java-basics` kategorisine yeni bir topic eklendi: `string` (V213-V215, sort_order=1, BEGINNER, 20 dk, 12 ana bölüm, 6 örnek) TR+EN yazıldı. `string` kategorinin İLK konusu olarak eklendi -- mevcut `enum`/`records`/`reflection`/`date-time` topic'lerinin `sort_order`'ı Faz 51'deki `collections` kategori-ekleme deseniyle aynı yöntemle bir kaydırıldı (1,2,3,4 → 2,3,4,5; yalnızca `topic.sort_order` UPDATE edildi, başka hiçbir alana dokunulmadı). İçerik, bu oturumda Collections kategorisi için netleşen standart yapıyı izliyor (intro → Nedir?/Neden Var?/Tarihçe → 6 mekanik bölüm + embed → Best Practices → Yaygın Hatalar → Özet/Cheat Sheet/Terimler Sözlüğü) -- `enum`'ın kendi (daha eski, çok sayıda küçük başlıklı) yapısından bilinçli olarak farklı, çünkü CLAUDE.md'nin güncel standart içerik kuralı bu. Kapsam: `String`'in IMMUTABLE tasarımı ve nedeni (thread-safety, önbelleklenen hashCode, string pool), string pool ile `==` vs `equals()` tuzağı (`new String(...)`'in her zaman ayrı nesne olması, compile-time constant folding'in `"hel"+"lo"`'yu literal'e dönüştürmesi ama runtime birleştirmenin dönüştürmemesi), `+` ile birleştirmenin O(n²) maliyeti vs `StringBuilder`'ın amortized O(1)'i, `StringBuilder`/`StringBuffer` farkı, `String.format()`/`formatted()` ve text block'lar (Java 15+), ve split/join/replace/trim/strip gibi yardımcı metotlar. GERÇEK ÖLÇÜM: `StringConcatenationPerformanceExample.java`, ısıtılmış bir ölçümle (binlerce ısıtma turu sonrası) 30.000 parçadan bir string oluştururken `+` operatörünü `StringBuilder`'a karşı ölçtü -- `+` tutarlı şekilde onlarca milisaniye sürdü (~63-80 ms, çalıştırmalar arasında değişti), `StringBuilder` bu ölçekte ölçülemeyecek kadar hızlıydı (0 ms). GERÇEK DAVRANIŞ DOĞRULAMASI: `StringPoolAndEqualityExample.java`, iki literal'in `==` ile `true`, `new String(...)`'in `false`, `intern()` sonrası tekrar `true`, ve compile-time sabit ifadenin (`"hel"+"lo"`) `true` ama runtime birleştirmenin (`prefix+"lo"`) `false` verdiğini canlı çalıştırmayla kanıtladı. Ayrıca `String.format("%.2f", 19.999)`'un kesme değil YUVARLAMA yaptığı (`"20.00"` sonucu) gerçek çalıştırmayla doğrulanıp uyarı olarak derse işlendi. 6 örnek sandbox-compile süreciyle gerçekten doğrulandı, Türkçe karakter taraması temiz çıktı verdi. NOT: `reflection`'ın DB'de `difficulty=ADVANCED` olmasına rağmen erken sırada (Faz 51'de tespit edilmişti, şimdi sort_order=4) durmasının tutarsızlığı bu Faz'da DÜZELTİLMEDİ -- kapsam dışı bırakıldı, ileride ayrı bir görev olarak ele alınabilir | ✅ TR+EN |
| 57 | Kullanıcı isteğiyle ("Arrays ile devam edebilirsin") `java-basics` kategorisine üçüncü topic eklendi: `arrays` (V216-V218, sort_order=2, BEGINNER, 20 dk, 12 ana bölüm, 6 örnek) TR+EN yazıldı. `arrays`, `string`'den (Faz 56) hemen sonra ikinci konu olarak eklendi -- `enum`/`records`/`reflection`/`date-time` topic'lerinin `sort_order`'ı yine aynı kaydırma deseniyle bir artırıldı (2,3,4,5 → 3,4,5,6; yalnızca `sort_order >= 2` olan kayıtlar, `string`'in sort_order=1'i sabit kaldı). Kapsam: dizilerin sabit boyutlu/aynı tipten/bitişik bellek yapısı ve bunun `ArrayList` gibi üst düzey koleksiyonların O(1) erişim performansının GERÇEK kaynağı olduğu, çok boyutlu diziler (jagged array dahil, `Arrays.toString()`'in nested dizilerde YANLIŞ araç olduğu ve `Arrays.deepToString()` gerektiği), `Arrays` yardımcı sınıfı (`sort`/`binarySearch`/`equals`/`fill`/`copyOf`/`copyOfRange`), array covariance ve bunun `ArrayStoreException` riski (generic'lerin -- `List<T>`'in invariant olması sayesinde -- bilerek önlediği bir tuzak olarak "String" dersindeki `==` vs `equals()` tuzağına paralel anlatıldı), `Arrays.asList()`'in kopya değil sabit boyutlu bir GÖRÜNÜM (view) olduğu, ve varargs (`Type... args`). GERÇEK DOĞRULAMA: `ArrayCovarianceExample.java`, bir `Integer[]`'in `Number[]` değişkenine atanıp içine bir `Double` yazılmaya çalışıldığında gerçek bir `ArrayStoreException` fırlattığını canlı çalıştırmayla kanıtladı; `ArraysVsCollectionsExample.java`, `Arrays.asList()`'in döndürdüğü listenin gerçekten orijinal diziyi GÖRÜNÜM olarak sardığını (diziyi doğrudan değiştirince listenin de değiştiğini) ve `add()`'in gerçekten `UnsupportedOperationException` fırlattığını doğruladı. "String" dersine iki yerde geriye dönük çapraz referans verildi (Arrays.equals() ile == tuzağı paralelinde, ve varargs'ın printf/String.format() ile ilişkisinde). 6 örnek sandbox-compile süreciyle gerçekten doğrulandı, Türkçe karakter taraması temiz çıktı verdi | ✅ TR+EN |
| 58 | Kullanıcı isteğiyle ("Scanner la devam edebilirsin?") `java-basics` kategorisine dördüncü topic eklendi: `scanner` (V219-V221, sort_order=3, BEGINNER, 20 dk, 12 ana bölüm, 6 örnek) TR+EN yazıldı. `scanner`, `arrays`'ten (Faz 57) hemen sonra üçüncü konu olarak eklendi -- `enum`/`records`/`reflection`/`date-time` topic'lerinin `sort_order`'ı yine aynı kaydırma deseniyle bir artırıldı (3,4,5,6 → 4,5,6,7; yalnızca `sort_order >= 3` olan kayıtlar, `string`=1 ve `arrays`=2 sabit kaldı). Kapsam: `Scanner`'ın token tabanlı okuma modeli (`next()`/`nextInt()`/`nextDouble()`/`hasNext...()`), klasik `nextInt()` + `nextLine()` tuzağı (`nextInt()`'in ardından gelen satır sonunu tüketmemesi), `useDelimiter()` ile özel ayırıcılar (regex tabanlı, tek karakterle sınırlı değil), `File` üzerinden okuma (try-with-resources ile), `Scanner` ile `BufferedReader` arasındaki gerçek bir performans farkı, ve `InputMismatchException`/`NoSuchElementException` istisna yönetimi ("Queues & Collections Utility" dersindeki `offer()`/`poll()` vs `add()`/`remove()` paraleliyle anlatıldı). GERÇEK DOĞRULAMA: `ScannerNextIntNextLinePitfallExample.java`, simüle edilmiş bir konsol girdisiyle (`ByteArrayInputStream`), `nextInt()`'ten hemen sonra gelen `nextLine()`'ın gerçekten BOŞ bir string döndürdüğünü canlı çalıştırmayla kanıtladı -- ve fazladan bir `nextLine()` ile düzeltildiğini gösterdi; `ScannerExceptionHandlingExample.java`, bir `InputMismatchException` sonrası "uyumsuz" token'ın TÜKETİLMEDİĞİNİ (hâlâ `next()` ile okunabildiğini) doğruladı. GERÇEK ÖLÇÜM: `ScannerVsBufferedReaderPerformanceExample.java`, ısıtılmış bir ölçümle (50 tur ısıtma sonrası) 50.000 satırlık bir metni okurken `Scanner.nextLine()`'ı `BufferedReader.readLine()`'a karşı ölçtü -- `Scanner` tutarlı şekilde ~6 ms, `BufferedReader` ~1 ms sürdü (birden fazla çalıştırmada AYNI sonuç, olağanüstü kararlı bir ölçüm). "Queues & Collections Utility" dersine bir yerde çapraz referans verildi (checkable-vs-exception deseni paraleli). 6 örnek sandbox-compile süreciyle gerçekten doğrulandı, Türkçe karakter taraması temiz çıktı verdi | ✅ TR+EN |
| 59 | Kullanıcı onayıyla ("Olur devam edebilirsin") `java-basics` kategorisine beşinci topic eklendi: `wrapper-classes` (Wrapper Classes & Autoboxing, V222-V224, sort_order=4, BEGINNER, 20 dk, 12 ana bölüm, 6 örnek) TR+EN yazıldı. `wrapper-classes`, `scanner`'dan (Faz 58) hemen sonra dördüncü konu olarak eklendi -- `enum`/`records`/`reflection`/`date-time` topic'lerinin `sort_order`'ı yine aynı kaydırma deseniyle bir artırıldı (4,5,6,7 → 5,6,7,8; yalnızca `sort_order >= 4` olan kayıtlar, `string`=1/`arrays`=2/`scanner`=3 sabit kaldı). Kapsam: ilkel tiplerin nesne karşılıkları (`Integer`/`Double`/`Boolean` vb.), autoboxing/autounboxing (Java 5, generic'lerin ilkel tiplerle çalışamaması sorununu çözüyor), Integer önbellekleme (-128..127) ve bunun "String" dersindeki string pool `==` vs `equals()` tuzağına BİREBİR PARALEL kendi `==` tuzağı, `null` bir wrapper'ı unboxing yapmanın gerçek bir `NullPointerException` fırlattığı (özellikle `Map.get()` ile), autoboxing'in sıkı döngülerdeki gizli performans maliyeti, wrapper yardımcı metotları (`parseXxx`/`compare`/`toBinaryString`, "Scanner" dersindeki `InputMismatchException` paraleli olarak `NumberFormatException`), ve wrapper sınıflarının generic koleksiyonları (`List<Integer>`) mümkün kılması. GERÇEK DOĞRULAMA: `IntegerCachingExample.java`, 100 için `==` ile `true`, 200 için `==` ile `false` döndüğünü canlı çalıştırmayla kanıtladı; `AutoboxingNullPointerExample.java`, hem `null` bir `Integer`'ı aritmetikte kullanmanın hem de `Map.get()`'in eksik bir anahtar için döndürdüğü `null`'ın unboxing edilmesinin gerçek birer `NullPointerException` fırlattığını doğruladı. GERÇEK ÖLÇÜM: `AutoboxingPerformanceExample.java`, ısıtılmış bir ölçümle (2 milyon tur ısıtma sonrası) 20 milyon sayıyı toplarken ilkel `long` biriktiriciyi wrapper `Long` biriktiriciye karşı ölçtü -- ilkel tutarlı şekilde ~7 ms, wrapper ise ~35-39 ms sürdü (birden fazla çalıştırmada tutarlı çıktı). "String" ve "Scanner" derslerine üç yerde geriye dönük çapraz referans verildi. 6 örnek sandbox-compile süreciyle gerçekten doğrulandı, Türkçe karakter taraması temiz çıktı verdi | ✅ TR+EN |
| 60 | Kullanıcı isteğiyle ("Evet file konusuna devam edelim, ekteki 2 java sınıfında geçen File I/O komutlarına mutlaka yer verelim. Eğer çok uzun olacaksa 2 topic'e bölebilirsin") -- kullanıcı kendi eğitim setinden iki alıştırma dosyası (`FileReading.java`, `FileWriting.java`, `com.amigoscode._2_developers._11_files` paketinden) paylaştı ve bu dosyalardaki TÜM File I/O komutlarının kapsanmasını istedi. Kapsam çok geniş olduğu için File I/O İKİYE bölündü: `file-reading` ve `file-writing` (bu, `functional-interfaces-streams`/`collections`'ta uygulanan "kısa konuları BİRLEŞTİRME" pratiğinin TERSİ bir karar). Bu Faz, `wrapper-classes`'ten (Faz 59) sonraki altıncı topic olan `file-reading`'i (V225-V227, sort_order=5, BEGINNER, 20 dk, 12 ana bölüm, 6 örnek) TR+EN kapsıyor -- `enum`/`records`/`reflection`/`date-time` yine bir kaydırıldı (5,6,7,8 → 6,7,8,9; yalnızca `sort_order >= 5`, `string`=1/`arrays`=2/`scanner`=3/`wrapper-classes`=4 sabit kaldı). `FileReading.java`'daki TÜM metotlar kapsandı: `Files.readAllLines()`, `BufferedReader`+`FileReader` (try-with-resources), satır sayma (`Files.readAllLines().size()` VE `Files.lines().count()`), `Files.readAllLines().stream().filter()` ile kelime arama, `Files.readString()`, ve istisna yönetimi. Kapsam ayrıca genişletildi: `java.io` vs `java.nio.file` (NIO.2) tarihçesi, `Path`/`Files` temelleri, `Files.lines()`'ın LAZY + `Closeable` olduğu detayı. GERÇEK KEŞİF: `FileReadingExceptionHandlingExample.java`, `Files.readString()`'in eksik bir dosya için GERÇEKTEN `NoSuchFileException` fırlattığını (`FileNotFoundException` DEĞİL) kanıtladı -- ve kullanıcının orijinal alıştırma kodundaki TAM olarak aynı `catch (FileNotFoundException | NoSuchFileException e)` deseni test edilerek `FileNotFoundException` dalının bu çağrı için hiçbir zaman tetiklenmediği doğrulandı (`FileNotFoundException`'ın gerçekten klasik `FileReader`'dan geldiği ayrıca kanıtlandı). 6 örnek sandbox-compile süreciyle gerçekten doğrulandı, Türkçe karakter taraması temiz çıktı verdi | ✅ TR+EN |
| 61 | Faz 60'ın devamı: File I/O'nun ikinci yarısı `file-writing` (V228-V230, sort_order=6, BEGINNER, 20 dk, 12 ana bölüm, 6 örnek) TR+EN yazıldı -- `file-reading`'den hemen sonra yedinci konu olarak eklendi, `enum`/`records`/`reflection`/`date-time` yine bir kaydırıldı (6,7,8,9 → 7,8,9,10; yalnızca `sort_order >= 6`, önceki 5 java-basics topic'i sabit kaldı). Kullanıcının paylaştığı `FileWriting.java`'daki TÜM metotlar kapsandı: `Files.writeString()` (oluştur/üzerine yaz), `Files.writeString()` + `StandardOpenOption.APPEND` (sona ekleme), `Files.write(path, List<String>)` (satır satır yazma), `BufferedWriter`+`FileWriter` (try-with-resources, `write()`+`newLine()`), `Files.copy()` + `StandardCopyOption.REPLACE_EXISTING` (dosya kopyalama), ve CSV yazma (`String.join(",", array)` ile). Kapsam ayrıca genişletildi: `Files.createDirectories()`, ve kullanıcının orijinal `main()` metodundaki dizin temizleme deseni (`Files.walk().sorted(Comparator.reverseOrder()).forEach(delete)`) ayrı bir bölüm olarak ele alındı. GERÇEK DOĞRULAMA: `AppendToFileExample.java` yazılırken, `StandardOpenOption.APPEND` TEK BAŞINA henüz var olmayan bir dosyada kullanıldığında GERÇEKTEN `NoSuchFileException` fırlattığı ayrı bir test dosyasıyla doğrulandı (`CREATE` ile birlikte kullanılınca sorunsuz çalıştığı da doğrulandı); `CopyAndDirectoryExample.java`, `Files.copy()`'nin `REPLACE_EXISTING` olmadan ikinci çağrıda gerçek bir `FileAlreadyExistsException` fırlattığını, ve `Files.walk()+reverseOrder()` deseninin bir dizin ağacını (dosyalar dahil) eksiksiz sildiğini canlı çalıştırmayla kanıtladı. **BU MİGRATION'LA File I/O KONUSU (file-reading + file-writing, kullanıcının isteğiyle iki topic'e bölünmüş hâliyle) TAMAMLANDI** -- bu, ChatGPT'nin Faz 51'de önerdiği ve kullanıcının onayladığı 5 yeni java-basics topic'inin (String, Arrays, Scanner, Wrapper Classes & Autoboxing, File I/O) SONUNCUSU ve java-basics'e bu oturumda eklenen TOPLAM 6. ve 7. topic. 6 örnek sandbox-compile süreciyle gerçekten doğrulandı, Türkçe karakter taraması temiz çıktı verdi | ✅ TR+EN |
| 62 | Kullanıcı isteğiyle ("Microservices de kalan konulardan ilkine devam edebilirsin") Faz 41'de ARA VERİLEN Microservices kategorisine geri dönüldü. Kalan 9 aday konudan (Service Discovery/Eureka, API Gateway, Resilience4j, Configuration Management, Event-Driven/Kafka, Distributed Transactions, Observability, Security, Deployment -- orijinal ChatGPT sıralamasındaki göreli sırayla) İLKİ, `service-discovery-eureka` (V231-V233, sort_order=4, INTERMEDIATE, 24 dk, 12 ana bölüm, 7 örnek), `inter-service-communication`'dan (wave 1'in son topic'i) sonraki dördüncü topic olarak eklendi -- TR+EN aynı fazda (topic 2'den beri geçerli ritim). Kapsam: `inter-service-communication`'daki sabit kodlanmış `@Value` URL'in (order-service'in inventory-service'i bulma yöntemi) neden ölçeklenmediği, Eureka Server (`@EnableEurekaServer`, kendi bağımsız uygulaması, tek düğümlü kurulumda `register-with-eureka`/`fetch-registry=false`), Eureka Client (`spring.application.name`'in artık yalnızca log için değil, keşif anahtarı olması), `DiscoveryClient` ile düşük seviyeli doğrudan sorgu, `@LoadBalanced RestClient.Builder` ile servisi İSİMLE çağırma (`StockClient`'ın `@Value` URL'den servis ismine geçen DOĞRUDAN evrimi -- 404/bağlantı hatası ayrımı ve `InventoryServiceUnavailableException` DEĞİŞMEDİ, yalnızca base URL'in kaynağı değişti), heartbeat/eviction/self-preservation modu (yerel geliştirmede kapatılan bir servisin bir süre "kayıtlı" görünmeye devam etmesi gibi kafa karıştırıcı gerçek davranış dahil), ve Eureka'nın CAP teoreminin AP tarafını seçmesi ("Microservices Fundamentals" dersindeki "CAP Teoremine Kısa Bir Bakış" bölümüne geriye dönük çapraz referansla). Dürüstlük notu bilinçli olarak eklendi: Netflix'in kendi iç altyapısında Eureka 2.0'ı 2018 civarında bıraktığı ve Kubernetes'in kendi servis keşfi olduğunda Eureka'nın genellikle gerekmediği açıkça belirtildi -- Eureka'yı tek/güncel çözümmüş gibi sunmaktan kaçınıldı. "Spring Boot Microservice Basics" ve "Inter-Service Communication" derslerine üç yerde geriye dönük çapraz referans verildi (tam H2 başlık alıntılarıyla, TR/EN ayrı ayrı doğrulandı). SANDBOX KISITI (kategori boyunca geçerli, Faz 40'ta belirlendi): Maven Central bu sandbox'tan engelli olduğu için 7 örnek (`EurekaServerApplication`, `EurekaServerConfig.yml`, `OrderServiceEurekaConfig.yml`, `DiscoveryClientExample`, `LoadBalancedRestClientConfig`, `StockClientWithDiscovery`, `StockCheckResponse` -- ikincisi `inter-service-communication`'dan değişmeden kopyalandı, kategori genelinde "her topic'in örnek klasörü kendi başına eksiksiz olmalı" deseniyle tutarlı) gerçek `mvn`/Spring Cloud ile derlenip çalıştırılamadı -- kod, önceki iki topic'in zaten dikkatle yazılmış ve kullanıcı tarafından kendi ortamında doğrulanmış desenlerine (RestClient, `@Value`, controller/service ayrımı, `@PathVariable` kullanımı) sadık kalınarak elle yazıldı; kullanıcının Faz 40'ta onayladığı "her topic bitince test" ritmi gereği kendi ortamında doğrulaması istenecek. `## Ek: Mini Proje`/`## Pratik Proje` YOK (kategori kuralı gereği, pratik proje yalnızca bir wave'in SON topic'inde geliyor -- kalan 9 konu için wave 2 planı/son topic'i henüz belirlenmedi). Durum: `service-discovery-eureka` **TR+EN tamamlandı**, kalan 8 aday konu hâlâ DB'ye seed edilmedi | ✅ TR+EN |
| 63 | Kullanıcı, `learnforgex.com` production'da (Railway) navbar logosunun yerel/gizli-mod görünümünden farklı (büyümüş, beyaz) göründüğünü bildirdi. Kod incelemesi: proje tarihinde tek bir logo tasarımı var (Faz 48'de tasarlandı, hiç değişmedi), yani "iki farklı versiyon" kodda değil. Gizli pencerede doğru geldiği, normal pencerede bozuk/beyaz göründüğü kullanıcı tarafından doğrulandı -- kök neden production kodu değil, kullanıcının normal Chrome profilinin Faz 48 öncesi (veya asset içeriği değişmeden önceki) bir favicon/logo yanıtını agresif biçimde önbelleğe almış olması (tarayıcılar favicon tipi kaynakları normal Cache-Control kurallarının ötesinde, hard refresh'e bile dirençli şekilde önbellekler). Kalıcı çözüm olarak TÜM favicon/logo referanslarına cache-busting query param'ı (`?v=2`) eklendi -- Thymeleaf `@{...(v=2)}` sözdizimiyle: `fragments/layout.html`'deki navbar `<img>` (`/img/favicon.svg`), ve `index.html`/`topic.html`'in `<head>`'indeki dört `<link rel="icon"/apple-touch-icon">` etiketi (`favicon.svg`, `favicon-32.png`, `favicon-16.png`, `apple-touch-icon.png`) -- toplam 3 dosyada 11 referans güncellendi. Bu, kullanıcının kendi tarayıcısındaki eski önbelleği bu oturumda temizlemez (kullanıcı yine de bir kez cache temizlemesi/hard refresh yapması önerildi) ama URL artık değiştiği için TÜM ziyaretçilerin tarayıcısı yeni deploy'dan sonra otomatik olarak taze dosyayı çekecek, gelecekte logo tekrar değişirse aynı sorun tekrarlanmayacak (yalnızca `v=` değerini artırmak yeterli olacak) | ✅ Uygulandı |

| 64 | Kullanıcı, ChatGPT ile learnforgex.com'un SEO/büyüme stratejisini tartıştı ve önceliklendirilmiş bir plan onayladı: (1) teknik SEO temeli -- dil URL yapısını path-bazlı yapmak + hreflang, sitemap.xml, robots.txt, canonical, Open Graph/Twitter meta, Course schema JSON-LD; (2) daha sonra 170 legacy Türkçe-yorumlu örnek dosyasının normalize edilmesi. Bu Faz, madde (1)'in İLK alt adımını kapsıyor: kod incelemesiyle tespit edilen kritik bulgu -- dil ayrımının `/topics/{slug}?lang=tr|en` query parametresiyle yapılması, `hreflang`/canonical/sitemap.xml/robots.txt'in hiçbirinin olmaması -- sonucu, kullanıcıya 3 URL şeması seçeneği sunuldu (AskUserQuestion), kullanıcı EN AZ RİSKLİ olanı seçti: `/en/topics/{slug}` ve `/tr/topics/{slug}` (yalnızca dil öneki, mevcut `/topics/` segmenti korunuyor). Uygulama: `LangParamLocaleResolver` artık önce URI'nin ilk path segmentinden dil çözüyor (`?lang=` hâlâ ikincil kaynak olarak destekleniyor). `HomeController`'a iki endpoint eklendi: `/{lang:en\|tr}` (gerçek anasayfa) ve çıplak `/` (302 ile `Accept-Language`'e göre `/en` ya da `/tr`'ye yönlendiren bir "negotiator" -- Google'ın çok-dilli site rehberinin önerdiği desen). `TopicController`'ın sınıf-seviyesi `@RequestMapping("/topics")`'i kaldırıldı (artık iki farklı path şekli olduğu için tek bir ortak önek kalmadı): `/{lang:en\|tr}/topics/{slug}` gerçek içeriği render ediyor, `/topics/{slug}` (eski `?lang=` URL'leri) artık 301 (kalıcı) ile yeni adrese yönlendiriyor -- Google zaten taramışsa index'ini aktarması için. `{lang:en\|tr}` regex kısıtı bilinçli eklendi: kısıt olmasaydı `/favicon.ico` gibi tek-segmentli statik kaynak istekleri de bu mapping'e düşüp yanlışlıkla 404 dönerdi (statik kaynak handler'ı, regex kısıtlı literal mapping'lerden DAHA DÜŞÜK önceliğe sahip). Tüm template'lerdeki linkler (`layout.html` navbar/sidebar, `index.html`, `topic.html` -- toplam 8 yer) yeni path yapısına güncellendi. RİPPLE ETKİSİ (kapsamlı bir şekilde taranıp düzeltildi): `spring-mvc-testing` konusunun gerçek `TopicController`/`HomeController`'ı test eden iki örnek dosyası (`TopicControllerWebMvcTest.java`, `HomeControllerTest.java`) artık YANLIŞ senaryolar test ediyordu (eski `lang` query param için 400 dönme testi, eski `/` isteğinin 200 dönmesi testi) -- ikisi de yeni gerçek davranışı test edecek şekilde YENİDEN YAZILDI (400 testi, artık gerçekten var olan `/topics/{slug}` → 301 redirect testine dönüştürüldü; `/` testi 302 negotiator testine, `/en` için ayrı bir 200 testine bölündü). Ayrıca `spring-mvc` kursunun 5 konusu (`spring-mvc-fundamentals`, `mapping-annotations-http-methods`, `path-variables-request-parameters`, `request-response-handling`, `spring-mvc-views-thymeleaf`) TR+EN, bu projenin gerçek controller'larının ESKİ URL/imza şeklini düz metinde veya kod parçacığında alıntılıyordu -- hepsi taranıp güncellendi (`path-variables-request-parameters`'daki `lang` query-param-vs-path-variable örneği özellikle yeniden kurgulandı: artık `show(...)`'daki ZORUNLU path variable `lang` ile `legacyRedirect(...)`'teki GERÇEKTEN opsiyonel `@RequestParam` `lang`'i karşılaştırıyor -- ayrımın zamanla nasıl değiştiğinin dürüst bir örneği). Her düzenlemeden sonra TR/EN H2 başlık sayıları ve embed setleri programatik olarak karşılaştırılıp eşitliği doğrulandı. SANDBOX KISITI (Microservices kategorisiyle aynı, bu kez TÜM projeyi kapsıyor): Maven Central bu sandbox'tan engelli olduğu için ne ana uygulama ne de değiştirilen örnek dosyaları (`TopicControllerWebMvcTest.java`, `HomeControllerTest.java`, `LinkExpressionExample.java`'nın yalnızca yorum satırı değişti) gerçekten derlenip test edilemedi -- değişiklikler Spring MVC'nin path-matching özgüllük kurallarına (literal > regex-kısıtlı variable > düz variable, "Common Mistakes" bölümünde zaten öğretilen ilke) dikkatle sadık kalınarak elle yapıldı. Kalan alt adımlar (hreflang, canonical, Open Graph/Twitter meta, Course schema JSON-LD, sitemap.xml, robots.txt) henüz uygulanmadı | ✅ Uygulandı |

| 65 | Faz 64'ün devamı ("Sıradaki adıma geçebilirsin"): Adım 1'in kalan alt adımları (hreflang, canonical, Open Graph/Twitter meta, Course/LearningResource JSON-LD, sitemap.xml, robots.txt) tamamlandı — teknik SEO temeli artık BİTTİ. Yeni bir `app.base-url` config değeri eklendi (`application.yml`: `http://localhost:8080`, `application-prod.yml`: `https://www.learnforgex.com`) — mutlak URL gerektiren her yerde kullanılıyor, hiçbir yerde domain sabit kodlanmadı. Yeni `GlobalModelAttributes` (`@ControllerAdvice`) bunu `baseUrl` model attribute'u olarak TÜM `Model` alan controller'lara otomatik enjekte ediyor. `topic.html`'e eklenenler: (1) İçerik bu dilde yoksa `<meta name="robots" content="noindex, follow">` + (varsa) diğer dile canonical — ince/duplike içerik indexlenmesin; (2) içerik varsa: kendi path'ine canonical, yalnızca GERÇEKTEN yayında olan dillere hreflang (otherLanguageAvailable=false iken diğer dile hreflang VERİLMİYOR — henüz içeriği olmayan bir sayfayı Google'a "eşdeğer" diye sunmamak için), x-default her zaman İngilizce'ye (İngilizce yoksa mevcut tek dile) düşüyor; (3) Open Graph (og:type=article, og:title/description/url/image, og:locale + varsa og:locale:alternate) + Twitter Card (summary_large_image); (4) JSON-LD `LearningResource` (name/description/url/inLanguage/learningResourceType/educationalLevel/isPartOf Course/provider Organization), `th:inline="javascript"` + `/*[[expr]]*/` işaretçileriyle. `index.html`'e eklenenler: canonical + hreflang (en/tr her ikisi HER ZAMAN mevcut, otherLanguageAvailable kontrolüne gerek yok) + Open Graph/Twitter (og:type=website) + JSON-LD `WebSite`+`Organization`. YENİ Open Graph görseli üretildi: `static/img/og-image.png` (1200×630, marka renkleri/logosuyla tutarlı — koyu lacivert/slate gradient zemin, ikon rozeti, "LearnForgeX" kelime markası, "Forge your skills" sloganı) — `rsvg-convert` bu sandbox'ta da kurulu değildi (Faz 48'deki notla aynı durum), bu kez `cairosvg` Python paketiyle (pip ile kuruldu) tek bir SVG'den doğrudan PNG'ye render edildi, üretilen görsel görüntülenerek görsel olarak doğrulandı. `TopicTranslationRepository`'ye yeni `findAllPublishedWithTopic()` metodu eklendi (join fetch, N+1'siz). Yeni `SitemapController` (`/sitemap.xml`, `produces=APPLICATION_XML`) sitemap'i ELLE üretiyor (proje boyutu için ayrı bir kütüphane gerekmiyor) — `Topic`'in hiçbir timestamp alanı olmadığı için `<lastmod>` BİLİNÇLİ OLARAK EKLENMEDİ (uydurma tarih vermektense hiç vermemek tercih edildi); her `<url>` kendi `<xhtml:link rel="alternate" hreflang="...">` cross-reference'larını taşıyor (topic.html'deki aynı kural: yalnızca yayında olan diller, x-default İngilizce'ye düşer); çıktı slug'a göre alfabetik/deterministik (TreeMap) sıralı. Yeni `static/robots.txt` (`Allow: /`, `Sitemap: https://www.learnforgex.com/sitemap.xml`). `{lang:en|tr}` regex kısıtı sayesinde (Faz 64) `/robots.txt`/`/sitemap.xml` hiçbir zaman `HomeController`'ın `/{lang}` mapping'ine düşmüyor (tek segment ama "en"/"tr" değil), statik kaynak handler'ı ile yeni `SitemapController` mapping'i doğru şekilde devreye giriyor. Mimari bölümüne `app.base-url` kuralı yeni bir madde olarak eklendi. SANDBOX KISITI (Faz 64 ile aynı, bu Faz'da da geçerli): Maven Central engelli olduğu için `GlobalModelAttributes`, `SitemapController`, `TopicTranslationRepository`'nin yeni metodu, ve `topic.html`/`index.html`'in yeni `<head>` blokları gerçekten derlenip/render edilip test edilemedi — HTML etiket dengesi/JSON-LD sözdizimi bu sandbox'ta bağımsız bir Python tabanlı ayrıştırıcıyla (`html.parser`) programatik olarak doğrulandı, Java dosyaları brace/paren dengesi kontrol edildi, ama gerçek bir Thymeleaf render veya `mvn test` çalıştırılmadı — kullanıcının kendi ortamında `mvn compile`/`mvn test` ve gerçek bir sayfa görüntüleyip `view-source:`/Google'ın Rich Results Test aracıyla JSON-LD'yi doğrulaması ÖNERİLİR. **BU FAZ'LA ADIM 1 (teknik SEO temeli) TAMAMLANDI** — kullanıcının onayladığı önceliklendirilmiş planın 2. maddesi (170 legacy Türkçe-yorumlu örnek dosyasının normalize edilmesi) hâlâ kullanıcının ayrı onayını bekliyor, henüz başlanmadı | ✅ Uygulandı |

| 66 | HATA DÜZELTMESİ: kullanıcı, Faz 65'te eklenen JSON-LD `<script>` bloklarıyla anasayfayı (`/`) çalıştırınca gerçek bir `org.thymeleaf.exceptions.TemplateInputException` aldı — kök hata: `TextParseException: (Line = 2, Column = 5) Incomplete structure: "/*"`, `AbstractStandardInliner.inlineSwitchTemplateMode`'dan geliyordu. KÖK NEDEN: `topic.html`/`index.html`'deki JSON-LD `<script th:inline="javascript">` blokları, bazı Thymeleaf örneklerinde görülen `/*<![CDATA[*/ ... /*]]>*/` sarmalayıcısıyla yazılmıştı — ama bu proje HTML5 çıktı üretiyor (XHTML strict DEĞİL), ve attoparser (Thymeleaf'in markup ayrıştırıcısı) `<![CDATA[`/`]]>` dizilerini script içeriğinde bile GERÇEK bir CDATA bölümü açılışı/kapanışı olarak yorumluyor — bu da metin düğümünün üç parçaya bölünmesine yol açıyor: (1) "<![CDATA["'e kadar olan `/*` parçası (kendi başına eksik/kapatılmamış bir yorum olarak text-inline edilmeye çalışılıyor — TAM OLARAK hatanın oluştuğu satır/sütun: satır 2, sütun 5, dosyadaki `/*<![CDATA[*/` satırıyla birebir eşleşiyor), (2) CDATA bölümünün kendisi (ayrı bir `handleCDATASection` olayıyla işleniyor, muhtemelen text-inliner'a hiç uğramıyor), (3) `]]>`'den sonraki `*/` parçası. DÜZELTME: her iki dosyadaki JSON-LD bloklarından CDATA sarmalayıcı (`/*<![CDATA[*/` ve `/*]]>*/` satırları) tamamen kaldırıldı — geriye yalnızca `th:inline="javascript"` + ham JSON + `/*[[expr]]*/` işaretçileri kaldı (Thymeleaf'in HTML5 için resmi olarak da desteklediği, CDATA'sız en basit biçim). Mimari bölümüne KALICI KURAL olarak yeni bir madde eklendi: bu projede `th:inline="javascript"` blokları CDATA sarmalayıcı OLMADAN yazılacak. SANDBOX KISITI (Faz 64/65 ile aynı): bu düzeltme yine gerçek bir Thymeleaf render ile bu sandbox'ta doğrulanamadı (Maven Central engelli, `curl` ile `repo1.maven.org`'a bağlantı denendi ve `403 CONNECT tunnel failed` ile doğrulandı — yalnızca npm/pip/crates/go proxy kayıt defterlerine izin veriliyor) — düzeltme, hatanın stack trace'indeki tam satır/sütun bilgisiyle (satır 2, sütun 5 → dosyadaki CDATA açılış satırıyla birebir örtüşüyor) ve attoparser'ın CDATA bölümlerini script içeriğinde bile özel olarak tanıdığı bilgisiyle GEREKÇELENDİRİLEREK yapıldı; **kullanıcının bu düzeltmeyi kendi ortamında yeniden çalıştırıp doğrulaması ÖNEMLE tavsiye edilir** — bu, Faz 65'te "muhtemelen doğru" varsayılan bir kod parçasının GERÇEKTEN yanlış çıktığı, sandbox-doğrulamasının (Maven Central engeliyle) bu oturum boyunca en büyük kör noktası olduğunu gösteren somut bir örnek | ✅ Düzeltildi |

Migration'lar V1'den V233'e kadar uygulandı (V188, Faz 42'deki checksum mismatch
hatasını düzeltmek için V179/V182'yi orijinal haline döndürüp asıl düzeltmeyi doğru
şekilde UPDATE olarak uyguluyor -- bkz. Faz 42/43 notu; V198, Faz 49'da `seo_description`
VARCHAR(500) sınır aşımı için doğrudan düzeltildi -- bu migration hiç uygulanmamıştı,
bkz. Faz 49 notu). İki kurs var: `java` kursunda beş kategori
(`category.sort_order`): `java-basics`(1) — string=1 (V213'te eklendi, EN'i
V215'te yayına alındı, bkz. Faz 56), arrays=2 (V216'da eklendi, EN'i V218'de
yayına alındı, bkz. Faz 57), scanner=3 (V219'da eklendi, EN'i V221'de yayına
alındı, bkz. Faz 58), wrapper-classes=4 (V222'de eklendi, EN'i V224'te yayına
alındı, bkz. Faz 59), file-reading=5 (V225'te eklendi, EN'i V227'de yayına
alındı, bkz. Faz 60), file-writing=6 (V228'de eklendi, EN'i V230'da yayına
alındı, bkz. Faz 61; enum/records/reflection/date-time toplamda altı kez
kaydırıldı), enum=7, records=8, reflection=9,
date-time=10; `collections`(2, V201'de eklendi, bkz. Faz 51/52/53/54/55,
**KATEGORİ TAMAMLANDI, 4/4 topic**) — lists=1 (V201'de eklendi, EN'i V203'te yayına
alındı), sets=2 (V204'te eklendi, EN'i V206'da yayına alındı), maps=3 (V207'de
eklendi, EN'i V209'da yayına alındı), queues-collections-utility=4 (V210'da eklendi,
EN'i V212'de yayına alındı); `oop`(3,
"Object-Oriented Programming", eskiden 2) —
interface=1, abstract-class=2, inheritance=3, polymorphism=4 (V51'de java-basics'ten
taşındı); `concurrency`(4, eskiden 3) — threads=1;
`functional-interfaces-streams`(5, "Functional Interfaces & Streams", eskiden 4,
V179'da eklendi) — lambda-expressions=1 (V179'da eklendi, EN'i V181'de yayına alındı),
built-in-functional-interfaces=2 (V182'de eklendi, EN'i V184'te yayına alındı),
stream-fundamentals=3 (V185'te eklendi, EN'i V187'de yayına alındı),
terminal-operations=4 (V189'da eklendi, EN'i V191'de yayına alındı),
collectors=5 (V192'de eklendi, EN'i V194'te yayına alındı),
optional=6 (V195'te eklendi, EN'i V197'de yayına alındı),
primitive-parallel-streams=7 (V198'de eklendi, EN'i V200'de yayına alındı). **Kategori
TAMAMLANDI — planlanan 7/7 topic TR+EN tamam** (bkz. Faz 41/42/44/45/46/47).
`spring-boot` kursunda (V58'de eklendi) bir kategori: `spring-core`(1) —
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
Faz 40'ta `spring-boot` kursuna üçüncü bir kategori açıldı: `microservices`(3) —
microservices-fundamentals=1 (V169'da eklendi, teori ağırlıklı, kod örneği yok),
spring-boot-microservice-basics=2 (V173'te eklendi, EN'i V175'te yayına alındı,
`order-service` -- port 8081), inter-service-communication=3 (V176'da eklendi, EN'i
V178'de yayına alındı, `inventory-service` -- port 8082, `RestClient` ile senkron
çağrı), service-discovery-eureka=4 (V231'de eklendi, EN'i V233'te yayına alındı,
Faz 62 -- Eureka Server/Client, `DiscoveryClient`, `@LoadBalanced RestClient`).
Kategori bir dizi "wave" hâlinde ilerliyor (bkz. Faz 40/41/62 notları); kalan 8
aday konu (API Gateway, Resilience4j, Configuration Management, Event-Driven/Kafka,
Distributed Transactions, Observability, Security, Deployment) hâlâ DB'ye seed
edilmedi. Bu kategorideki kod örnekleri, Maven Central'ın bu sandbox'tan engelli
olması nedeniyle gerçek `mvn`/Spring Cloud ile derlenip çalıştırılamıyor -- elle,
dikkatle, mevcut desenlere sadık kalınarak yazılıyor ve kullanıcı tarafından kendi
ortamında test ediliyor.

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
alındı).

**Faz 30'da "Pratik Proje" standardı kuruldu ve retroaktif olarak uygulandı.**
Kullanıcı, kendi fikrini ve ChatGPT'nin buna verdiği yanıtı paylaştı: her React
kategorisi, o kategorideki kavramları birleştiren gerçek, çalıştırılabilir bir
proje ile bitmeli, ayrı bir GitHub reposunda tutulmalı. Üç açık soru
`AskUserQuestion` ile soruldu, kullanıcı üçünde de önerilen seçeneği onayladı:
(1) ayrı yeni bir repo (`react-course-projects`, `learning-platform`'dan bağımsız);
(2) gömülü, tek başına çalışmayan `## Ek: Mini Proje` deseni tamamen terk edilip
gerçek proje + link ile değiştirilsin; (3) bu, yalnızca bundan sonraki kategoriler
için değil, zaten tamamlanmış React Fundamentals ve Components & Props için de
retroaktif olarak şimdi yazılsın. Yapılanlar: `react-course-projects` reposu
(bkz. "Bilinen Kısıtlar") iki proje ile kuruldu (`react-fundamentals`,
`components-props`), ikisi de `npm run build` ile gerçek bir production build
olarak doğrulandı; `component-composition.md`'deki (TR+EN) `## Ek: Mini Proje`
bölümü kaldırılıp yerine Components & Props Demo'ya link veren bir
`## Pratik Proje` bölümü kondu (başlık sayısı 5→5, embed sayısı 5→3); `jsx.md`'ye
(TR+EN) React Fundamentals Demo'ya link veren yeni bir `## Pratik Proje` bölümü
eklendi (başlık sayısı 7→8); V132 migration'ı ile artık kullanılmayan
`CardBase`/`CardDemo` `code_example` satırları silindi, `examples/
component-composition/CardBase.jsx` ve `CardDemo.jsx` dosyaları da diskten
kaldırıldı. Bu artık kalıcı bir mimari kural (bkz. "Mimari" bölümü) — React
course'undaki her yeni kategori, kendi Pratik Proje'siyle birlikte teslim
edilecek. Aynı fazın devamında iki küçük iyileştirme daha yapıldı (bkz.
"Bilinen Kısıtlar"): `react-course-projects` npm workspaces'e geçirildi
(kullanıcının fark ettiği, her proje klasöründe ayrı `node_modules`
birikmesi sorununu çözmek için), ve iki demo projedeki (`react-fundamentals`,
`components-props`) ekrana basılan tüm metinler Türkçe'den İngilizce'ye
çevrildi (kod yorumları Türkçe kaldı).

**Faz 31'de üçüncü kategori eklendi: `state-events`(3)** — events=1, state=2,
conditional-rendering=3, lists-and-keys=4 (dördü de V133'te eklendi, EN'i
V136'da yayına alındı). `react-course-projects`'e üçüncü proje
(`state-events`, `state-events-v1` tag'i) eklendi, `lists-and-keys.md`'ye
(TR+EN) bu projeye link veren bir `## Pratik Proje` bölümü kondu (başlık
sayısı 5→6).

**Faz 32'de dördüncü kategori eklendi: `hooks`(4)** — what-are-hooks=1,
use-effect=2, use-ref=3, use-memo-use-callback=4, custom-hooks=5 (beşi de
V137'de eklendi, EN'i V140'ta yayına alındı). Kullanıcı onayıyla, bu
kategoriden itibaren zorluk seviyesi **INTERMEDIATE**'e çekildi -- önceki
üç kategori (React Fundamentals, Components & Props, State & Events) hep
BEGINNER'dı. `react-course-projects`'e dördüncü proje (`hooks`, `hooks-v1`
tag'i) eklendi, `custom-hooks.md`'ye (TR+EN) bu projeye link veren bir
`## Pratik Proje` bölümü kondu (başlık sayısı 5→6).

**Faz 33'te beşinci kategori eklendi: `forms`(5)** — controlled-components=1,
form-handling=2 (ikisi de V141'de eklendi, EN'i V144'te yayına alındı).
ChatGPT'nin orijinal planındaki üçüncü topic (Form Libraries — React Hook
Form, Zod) kullanıcı kararıyla atlandı; `AskUserQuestion` ile soruldu,
planın kendisinin de "ilk React öğreniminde şart değil" dediği bu konu
şimdilik dışarıda bırakıldı. Zorluk seviyesi Hooks'tan (Faz 32) devam
ederek INTERMEDIATE. React course'u artık beş kategori/23 yayında topic'e
sahip; kalan altı kategori (Forms'tan sonra ChatGPT planındaki sıradaki:
Routing, API & Data Fetching, State Management, Advanced React, Testing,
Production) henüz planlanmadı/DB'ye seed edilmedi. `react-course-projects`'e
beşinci proje (`forms`, `forms-v1` tag'i) eklendi, `form-handling.md`'ye
(TR+EN) bu projeye link veren bir `## Pratik Proje` bölümü kondu (başlık
sayısı 6→7).

**Faz 34'te altıncı kategori eklendi: `routing`(6)** — react-router-basics=1,
route-parameters-navigation=2 (ikisi de V145'te eklendi, EN'i V148'de
yayına alındı). ChatGPT'nin orijinal planındaki tek bir topic (Topic 19 —
React Router; Routes, Route parameters, Nested routes, Navigation, Link,
NavLink, useNavigate, useParams — 8 kavram, diğer topic'lerin genelde
4-5 kavramına kıyasla belirgin şekilde büyük) `AskUserQuestion` ile
soruldu, kullanıcı "2 topic'e böl" seçeneğini onayladı: React Router
Basics (BrowserRouter, Routes, Route, Link, NavLink, Not Found) ve Route
Parameters & Navigation (useParams, Outlet ile nested route'lar,
useNavigate). Zorluk seviyesi Forms'tan (Faz 33) devam ederek
INTERMEDIATE. **Paket kararı:** `react-router-dom` yerine, Temmuz 2026'da
yayınlanan birleşik `react-router` v8 paketi kullanıldı — bu, npm
registry'den doğrudan indirilip incelenerek VE gerçek bir Vite build'i
çalıştırılarak doğrulandı (bkz. "Bilinen Kısıtlar"). `react-course-projects`'e
altıncı proje (`routing`, `routing-v1` tag'i) eklendi — öğrenme
platformunun kendi kurs yapısına benzeyen bir kurs gezinme uygulaması
(`/courses`, `/courses/:courseSlug`, `/courses/:courseSlug/:topicSlug`),
`route-parameters-navigation.md`'ye (TR+EN) bu projeye link veren bir
`## Pratik Proje` bölümü kondu (başlık sayısı 6→7).

**Faz 35'te yedinci kategori eklendi: `api-data-fetching`(7)** —
fetching-data=1, react-rest-api=2 (ikisi de V149'da eklendi, EN'i
V152'de yayına alındı). ChatGPT'nin orijinal planındaki üçüncü topic
(Topic 22 — API Data Management, TanStack Query: caching, refetching,
mutations) `AskUserQuestion` ile soruldu, kullanıcı "Şimdilik bırak
(2 topic)" seçti -- Forms'taki Form Libraries kararına benzer şekilde,
yeni bir npm bağımlılığı gerektiren bu konu şimdilik ertelendi.
**Backend kararı:** Topic 21'in "React → HTTP → Spring Boot →
PostgreSQL" şeması `AskUserQuestion` ile soruldu (json-server / gerçek
Spring Boot endpoint'i / public test API seçenekleriyle), kullanıcı
"json-server ile sahte API" seçti -- gerçek üretim Java koduna
dokunulmadı. Zorluk seviyesi Routing'ten (Faz 34) devam ederek
INTERMEDIATE. `react-course-projects`'e yedinci proje
(`api-data-fetching`, json-server'a bağlanan bir kurs CRUD demosu)
eklendi, `react-rest-api.md`'ye (TR+EN) bu projeye link veren bir
`## Pratik Proje` bölümü kondu (başlık sayısı 7→8).

**Faz 36'da sekizinci kategori eklendi: `state-management`(8)** —
sharing-state=1, context-api=2 (ikisi de V153'te eklendi, EN'i V156'da
yayına alındı). ChatGPT'nin orijinal planındaki üçüncü topic (Topic 25
— State Management Libraries: Redux Toolkit, Zustand) atlandı --
planın kendisi bu konuyu "Bunları ayrı ayrı daha sonra ekleyebiliriz"
notuyla işaretlemişti, Forms'taki (Faz 33) ve API & Data Fetching'teki
(Faz 35) aynı desenle birebir örtüştüğü için bu kez ayrıca
`AskUserQuestion` sorulmadı, doğrudan kararla ilerlendi. Zorluk seviyesi
API & Data Fetching'ten devam ederek INTERMEDIATE. `react-course-projects`'e
sekizinci proje (`state-management`, lifting state up ile arama + Context
API ile favoriler'i birleştiren bir kurs listesi demosu) eklendi,
`context-api.md`'ye (TR+EN) bu projeye link veren bir `## Pratik Proje`
bölümü kondu (başlık sayısı 6→7).

**Faz 37'de dokuzuncu kategori eklendi: `advanced-react`(9)** —
react-performance=1, error-boundaries=2, lazy-loading-code-splitting=3,
suspense=4, portals=5 (beşi de V157'de eklendi, EN'i V160'ta yayına
alındı). ChatGPT'nin planındaki beş topic'in (React Performance, Error
Boundaries, Lazy Loading & Code Splitting, Suspense, Portals) HİÇBİRİ
"sonraya bırakılabilir" notuyla işaretlenmemişti -- önceki üç
kategorinin aksine, hepsi olduğu gibi alındı (Hooks'la aynı büyüklükte,
5 topic). **Zorluk kararı:** kategori adının kendisi "Advanced React"
olduğu ve içerik gerçekten daha karmaşık olduğu için (kursun İLK class
component'i -- error boundary'ler hook'larla yazılamıyor --, dynamic
import(), Suspense, Portal'lar) zorluk seviyesi INTERMEDIATE'den
ADVANCED'a yükseltildi; bu, Java kursundaki "Advanced Spring MVC"
kategorisinin aynı isim-bazlı gerekçeyle ADVANCED olmasıyla tutarlı,
`AskUserQuestion` sorulmadı. `react-course-projects`'e dokuzuncu proje
(`advanced-react`, `React.memo` + bir Error Boundary + `React.lazy`/
`Suspense` ile code splitting + bir Portal modal'ı birleştiren bir
demo) eklendi, `portals.md`'ye (TR+EN) bu projeye link veren bir
`## Pratik Proje` bölümü kondu (başlık sayısı 5→6).

**Faz 38'de onuncu kategori eklendi: `testing`(10)** — component-testing=1,
user-interaction-testing=2 (ikisi de V161'de eklendi, EN'i V164'te yayına
alındı). ChatGPT'nin planındaki tek bir topic (Topic 31 — React Testing:
Vitest, React Testing Library, Component testing, User interaction
testing) önceki "sonraya bırakma" kararlarından farklı bir karar
türüyle -- içerik azaltılmadan, planın kendi alt-madde başlıkları
esas alınarak -- ikiye bölündü: `component-testing` (kurulum, render+
screen, getByRole/getByLabelText, jest-dom matcher'ları, koşullu render
testi) ve `user-interaction-testing` (user-event, tıklama/yazma/form
gönderimi, asenkron UI güncellemeleri). `AskUserQuestion` sorulmadı --
bölünme planın kendi metnindeki iki doğal gruba birebir karşılık
geliyordu. **Doğrulama:** `/tmp/testingcheck` adlı bir scratch projede
gerçek npm install ile Vitest 4.1.10, @testing-library/react 16.3.2,
@testing-library/user-event 14.6.4, @testing-library/jest-dom 7.0.1
kuruldu; render/screen/getByText/getByRole/getByLabelText/
toBeInTheDocument/toBeDisabled/toBeEnabled/userEvent.setup().click/type/
vi.fn()/toHaveBeenCalledWith/findByText kalıplarının HEPSİ gerçek
`npx vitest run` ile ÇALIŞTIRILIP geçirildi (12/12 test). **Önemli
teknik keşif:** `MarkdownService`'teki embed regex'i
(`\{\{(\w+)\.(\w+)}}`) exampleName grubunda nokta karakterine izin
vermediği için, gerçek dünyada yaygın "Component.test.jsx"
isimlendirmesi `{{Component.test.jsx}}` olarak GÖMÜLEMEZ (Python'da
doğrudan test edilip doğrulandı) -- bu yüzden `examples/` altındaki 8
dosya, kursun geri kalanıyla aynı tek-nokta convention'ını (component
ve testi AYNI dosyada birleştirerek, ör. `UserEventClickExample.jsx`)
kullanıyor; `react-course-projects`'teki GERÇEK pratik proje bu
kısıtlamaya tabi değil, orada idiomatik `Component.test.jsx`
isimlendirmesi kullanıldı. `react-course-projects`'e onuncu proje
(`testing`, arama+kayıt uygulaması + `SearchBar`/`CourseList`/
`EnrollForm`'un her biri için birer `.test.jsx` + App'i bütün olarak
test eden bir integration testi, `npm test` ve `npm run build` ile
doğrulandı) eklendi, `user-interaction-testing.md`'ye (TR+EN) bu
projeye link veren bir `## Pratik Proje` bölümü kondu (başlık sayısı
6→7) -- kurs genelindeki kuralla tutarlı olarak, kategorinin İLK
topic'inde (`component-testing`) Pratik Proje bölümü YOK, yalnızca
SON topic'te var.

**Faz 39'da on birinci ve SON kategori eklendi: `production`(11)** --
build-deployment=1, react-spring-boot-deployment=2 (ikisi de V165'te
eklendi, EN'i V168'de yayına alındı). Kullanıcı "projeyi Vercel'e nasıl
deploy edebileceğimizi gösteren bir adım koyabilir miyiz?" diye sordu --
bu, ChatGPT'nin orijinal planındaki son kategoriye (Topic 32 — Build &
Deployment, Topic 33 — React + Spring Boot Deployment) tam denk düştü.
**Araştırma:** Vercel'in resmi "Backends on Vercel" dokümantasyonu
(`vercel.com/docs/frameworks/backend`) WebFetch ile çekildi -- zero-config
backend listesinde (Express, FastAPI, Flask, NestJS, Hono vb.) Java/Spring
Boot YOK, bir GitHub topluluk tartışması da bunu doğruluyordu. Bu bulgu
kullanıcıya sunulup birlikte karar verildi: kullanıcının kendi önerisiyle
("iki ayrı proje olsun, birincisi Vercel'de statik backend'siz, ikincisinde
Render kullan") kategori iki topic/pratik projeye ayrıldı.
**Mimari:** `build-deployment` -- tamamen statik bir React app (backend
yok), `npm run build`/ortam değişkenleri (`VITE_APP_VERSION` ile bir rozet,
`VITE_SHOW_BETA_BANNER` ile bir feature flag) anlatıyor. `react-spring-boot-
deployment` -- gerçek bir Spring Boot REST API'si (`backend/fullstack-
deployment`, `react-course-projects`'in npm workspaces glob'unun DIŞINDA,
Java/Maven, Spring Boot 4.1.0, Java 21) + ona `fetch` ile bağlanan bir React
app; CORS, Advanced Spring MVC'deki `addCorsMappings` deseninin bir
`CORS_ALLOWED_ORIGIN` ortam değişkeniyle production'a uyarlanmış hali.
Render'a Docker ile deploy için repo köküne bir `render.yaml` (Blueprint)
eklendi -- syntax'ı (`runtime: docker`, `dockerfilePath`/`dockerContext`,
`healthCheckPath`, `envVars`+`sync: false`) WebFetch ile Render'ın güncel
Blueprint dokümantasyonundan doğrulandı.
**Sandbox kısıtı:** bu fazda sandbox'ta yalnızca Java 11 vardı; JDK 21/Maven
kurmak için gereken hiçbir domain (download.java.net, api.adoptium.net,
GitHub release-assets, ports.ubuntu.com) proxy allowlist'inden geçmedi --
Spring Boot mini-backend'i burada GERÇEKTEN derleyip çalıştıramadım. Bunun
yerine kod, kursun zaten doğrulanmış `@RestController`/`addCorsMappings`
örneklerine birebir dayanarak dikkatle yazıldı, kullanıcıya deploy öncesi
yerel `mvn spring-boot:run` denemesi önerildi. **Operasyonel karar:**
gerçek Vercel/Render hesaplarına erişimim olmadığı için, `AskUserQuestion`
ile soruldu, kullanıcı "sen kendi hesabınla deploy et, bana adımları söyle"
yerine (bu seçenek metninde ben zaten "kullanıcı kendi hesabıyla deploy
eder" anlamını kastetmiştim) tam da bu şekilde ilerledi: ben config
dosyalarını ve tam deploy adımlarını (README'lerde) hazırladım, kullanıcı
KENDİ Vercel/Render hesabıyla gerçekten deploy etti. **Doğrulama:**
kullanıcının paylaştığı canlı URL'ler WebFetch ile test edildi --
`/api/health` → `{"status":"ok"}`, `/api/courses` → gerçek JSON (Java/
React/Spring Boot), Vercel sayfalarının HTML `<title>`'ları doğru projeyle
eşleşiyordu; tarayıcı erişimim olmadığı için CORS'un uçtan uca çalıştığını
(React'in Render'daki backend'den veri çekip ekranda gösterdiğini) kullanıcı
bir ekran görüntüsüyle doğruladı. `react-course-projects`'e on birinci ve
on ikinci proje (`build-deployment`, `fullstack-deployment` + `backend/
fullstack-deployment`) eklendi, canlı URL'ler `build-deployment.md` ve
`react-spring-boot-deployment.md`'ye (TR+EN) işlendi.
**Ayrı karar (bu fazın ortasında):** kullanıcı, benim attığım bir git
tag'inin (`production-v1`) kendi GERÇEK GitHub reposuna hiç yansımadığını
fark edip sorguladı -- bu, `react-course-projects`'teki git tag kullanımının
TAMAMEN terk edilmesine yol açtı (ayrıntı için bkz. "Bilinen Kısıtlar").

**Faz 40'ta `spring-boot` kursuna üçüncü bir kategori açıldı: `microservices`(3)**
(spring-core=1, spring-mvc=2'den sonra). Kullanıcı, ChatGPT'nin hazırladığı 12
topic'lik bir mikroservis planını (Microservices Nedir, Spring Boot Microservice,
Service Discovery/Eureka, API Gateway, Inter-service Communication, Resilience4j,
Configuration Management, Event-Driven/Kafka, Distributed Transactions,
Observability, Security, Deployment) paylaştı; ayrı bir Claude oturumunda
değerlendirilip şu kararlara varıldı ve bu fazda onaylandı: (1) 12 topic'i baştan
taahhüt etmeden, küçük dalgalar (wave) hâlinde ilerlenecek -- ilk dalga yalnızca
üç topic: `microservices-fundamentals` (teori, kod yok), `spring-boot-microservice-
basics` (tek servis yapılandırması, ilk kod örnekleri), `inter-service-
communication` (senkron REST çağrıları + kategori sonu Pratik Proje); kalan dokuz
aday konu (Eureka, Gateway, Resilience4j, Config Mgmt, Kafka, Distributed Tx,
Observability, Security, Deployment) henüz DB'ye seed edilmedi, ilk dalga
bittiğinde birlikte karar verilecek; (2) pratik proje, `react-course-projects`
deseninin birebir aynısıyla, `learning-platform`'dan tamamen ayrı, izole bir repo
olacak: `microservices-course-projects` (öneri onaylandı) -- `projects/{topic-
slug}/` altında her biri kendi `pom.xml`'iyle bağımsız Maven projeleri (npm
workspaces'in Maven karşılığı yok, bu yüzden kardeş klasörler kullanılacak); (3)
sandbox kısıtı erkenden doğrulandı -- bkz. "Bilinen Kısıtlar"daki güncellenmiş
Faz 40 notu; (4) altyapı ağırlıklı konularda (Kafka/Eureka/Docker Compose/
Kubernetes) test ritmi `AskUserQuestion` ile soruldu, kullanıcı "her topic
bitince" seçeneğini onayladı -- her yeni altyapı konusu yazılır yazılmaz somut
doğrulama adımları verilip kullanıcıdan hemen test istenecek.

İlk topic **`microservices-fundamentals`** (V169, INTERMEDIATE, estimated_minutes
tahmini 20) yazıldı -- monolit vs mikroservis, monolitin sınırları, servis
sınırlarının (business capability / Domain-Driven Design'ın bounded context'i)
nasıl belirlendiği, database per service ve "distributed monolith" anti-pattern'i,
dağıtık sistemlerin getirdiği yeni zorluklar (ağ güvenilmezliği, partial failure,
eventual consistency), CAP teoremine kısa bakış, Conway Yasası, "modüler
monolith" ara yolu, monolith/mikroservis karar kriterleri. Kullanıcı kararıyla
bilinçli olarak **kod yok** -- React Fundamentals'ın ilk konularındaki (Faz 28)
"teori ağırlıklı, henüz kod yazmaya başlamıyoruz" desenine bilinçli bir referansla,
ama Java/Spring kursunun genel kapanış yapısına (Best Practices/Yaygın Hatalar/
Özet ve Terimler Sözlüğü) uygun şekilde; bu yüzden `## Ek: Mini Proje` yok (pratik
proje kategori sonunda, ayrı repoda gelecek) ve migration'da `code_example` satırı
yok (0 embed, `what-is-react`/`creating-a-react-application` ile aynı desen).
Kullanıcı bu fazda önce yalnızca **TR** içeriğin yazılmasını istedi (Faz 20
öncesi ritme -- TR tamamlanınca ayrı onayla EN'e geçmek -- bilinçli bir dönüş,
yeni ve daha yüksek riskli bir kategori olduğu için); `topic_translation`'ın EN
satırı V169'da YOK. Kullanıcı TR'yi onayladıktan ("devam edebilirsin") sonra EN
çevirisi de aynı fazda tamamlandı -- `content/en/microservices-fundamentals.md`
TR ile birebir aynı yapı (17/17 başlık, 0/0 embed) ile yazıldı, `bkz.`/`see`
çapraz referanslarının ilgili H2 başlığıyla birebir eşleştiği bir Python
scriptiyle hem TR hem EN için ayrı ayrı doğrulandı (CLAUDE.md kuralı gereği).
V170 EN çevirisini `published=false` ekliyor, V171 yayına alıyor (react-
fundamentals/V124+V127 ile aynı iki adımlı desen). **Faz 40 küçük düzeltme:**
kullanıcı kendi ortamında sayfayı görüntüleyip bir ekran görüntüsü paylaştı --
`topic.title` (breadcrumb + H1) ile markdown'ın ilk H2'si aynı metni
("Microservices Nedir?") üç kez art arda gösteriyordu. `title`,
`spring-mvc-fundamentals`'taki (V88) TR/EN desenine uyacak şekilde "Microservices
Temelleri"/"Microservices Fundamentals" olarak değiştirildi (slug'la da tutarlı
hâle geldi), ilk H2 olduğu gibi kaldı; `summary`/`seo_title`/`seo_description`
bilinçli olarak değişmedi (spring-mvc-fundamentals'ta da aynı "title Temelleri,
seo_title Nedir" farkı var). V169 kullanıcının kendi ortamında ZATEN
UYGULANMIŞ olduğu için (ekran görüntüsüyle doğrulandı), "Flyway migration'ları
asla geriye dönük değiştirilmez" kuralı gereği V169 doğrudan düzenlenmedi --
ayrı bir `V172__update_microservices_fundamentals_title.sql` eklendi. Durum:
`microservices-fundamentals` **TR+EN tamamlandı**.

**Wave 1'in ikinci topic'i: `spring-boot-microservice-basics`** (V173-V175, TR+EN
aynı fazda -- kullanıcı bu kez "geçebilirsin, türkçe ve ingilizcesini
tamamlayabilirsin" dedi, topic 1'deki temkinli "önce yalnızca TR" ritmi
tekrarlanmadı). TR başlık kararı önce `AskUserQuestion` ile netleştirildi:
"Mikroservis Yapılandırma" (24 karakter) seçildi -- ilk öneri olan "Spring Boot
ile Tek Bir Mikroservis Yapılandırmak" (49 karakter) kullanıcı tarafından
sidebar için "çok uzun" bulunup reddedildi (mevcut en uzun TR başlık 46
karakter, sidebar'da ellipsis/truncate YOK, uzun başlıklar satır satır
kırılıyor -- bu proje için yeni bir öğrenilen ders, gelecekte başlık
önerirken göz önünde bulundurulmalı). EN karşılığı "Microservice
Configuration" (27 karakter). Kategorinin İLK KOD içeren topic'i -- tek bir
mikroservisin (`order-service`) baştan sona yapılandırılması: `@SpringBootApplication`
giriş noktası (`learning-platform`'un kendi ana sınıfıyla yapısal olarak
aynı), kendi `application.yml`'i (server.port, spring.application.name,
spring.datasource -- Twelve-Factor App'e (2011, Heroku) kısa bir tarihçe
bakışıyla motive edildi), REST controller/service/domain model üçlüsü
(`OrderController`/`OrderService`/`Order` -- dependency-injection'daki
`NotificationDispatcher`/`NotificationDispatcherDemo` çiftiyle aynı "birbirine
bağımlı, birlikte okunacak dosya grubu" deseninde), ve `spring-boot-starter-actuator`
ile health check (`GET /actuator/health`). 5 örnek (4 `.java` + 1 `.yml` --
embed sisteminin gördüğü üçüncü farklı uzantı, `.jsx`'ten sonra); highlight.js'in
"yml"i ayrı bir dil olarak tanıdığı npm ile ayrıca doğrulandı (Faz 27'deki jsx
doğrulamasıyla aynı yöntem). `ResponseEntity`/`HttpStatus` kullanımı, projenin
`request-response-handling`/`rest-api-design` konularındaki gerçek kullanımla
birebir aynı desende yazıldı (tutarlılık için bilerek kontrol edildi). Kod bu
sandbox'ta gerçek `mvn`/`spring-boot:run` ile derlenip çalıştırılamadı (Maven
Central engelli, bkz. "Bilinen Kısıtlar") -- kullanıcının kendi ortamında
doğrulaması istenecek (kullanıcının onayladığı "her topic bitince test" ritmi).
`## Ek: Mini Proje` yine YOK -- kategori kuralı gereği (bkz. Mimari), pratik
proje yalnızca wave'in son topic'inde (`inter-service-communication`), ayrı
`microservices-course-projects` reposunda gelecek.

**Faz 40 -- gerçek bir uygulama hatası bulundu ve düzeltildi (`MarkdownService`
`applyCallouts` bug'ı):** kullanıcı kendi ortamında uygulamayı gerçekten
çalıştırıp `spring-boot-microservice-basics`'in EN sayfasını açtığında
`Whitelabel Error Page` (HTTP 500) aldı; stack trace
`IllegalArgumentException: named capturing group is missing trailing '}'`,
`MarkdownService.applyCallouts(MarkdownService.java:108)` ← `render` ←
`TopicController.show`. Kök neden: `applyCallouts`,
`Matcher.replaceAll(Function<MatchResult,String>)` (Java 9+ shorthand
overload) kullanıyordu; bu overload'ın JDK implementasyonu, replacer
fonksiyonunun döndürdüğü metni `appendReplacement`'a
`Matcher.quoteReplacement(...)` ile SARMADAN geçiriyor -- oysa birkaç satır
yukarısındaki `injectCodeExamples` bunu zaten doğru yapıyordu. EN Warning
callout'unun gövdesinde geçen `` `password: ${ORDERS_DB_PASSWORD}` `` metni,
`appendReplacement`'ın regex-backreference/named-group parser'ı tarafından
yakalandı; Java'nın named-group söz dizimi alt tireye izin vermediği için
istisna fırlatıldı. Düzeltme: `applyCallouts` artık `TIP_BLOCKQUOTE` ve
`WARNING_BLOCKQUOTE` için ortak, güvenli bir `replaceCallouts` yardımcı
metodunu kullanıyor -- `injectCodeExamples` ile birebir aynı desende, manuel
`Matcher.find()` / `appendReplacement(result, Matcher.quoteReplacement(...))`
/ `appendTail(result)` döngüsü. Kodda `Matcher.replaceAll(Function)`
kullanılan başka bir yer olmadığı grep ile doğrulandı. Bu, kategori boyunca
bulunan ilk **gerçek uygulama kodu hatası** -- önceki notlar (sandbox
kısıtları, başlık uzunluğu) içerik/ortam sorunlarıydı, bu ise
`src/main/java`'da bir defect. Bu yüzden kullanıcının kendi ortamında projeyi
**yeniden derleyip** (`mvn clean install` veya IDE rebuild) uygulamayı
**yeniden başlatması** gerekiyor -- Faz 29'daki "eski derlenmiş sınıflar
kaynak değişikliğini yansıtmaz" dersiyle aynı kategoriden bir hatırlatma.
İçerikteki `${ORDERS_DB_PASSWORD}` metni bilerek DEĞİŞTİRİLMEDİ (kod
seviyesinde düzeltildi, içerik zaten doğru ve pedagojik olarak gerekli --
gerçek bir ortam değişkeni referansı örneği); ama gelecekte benzer bir
callout yazılırken `${...}` içeren örnek metinlerin bu hatayı tetikleyebileceği
akılda tutulmalı (artık kod düzeltildiği için tetiklemeyecek, ama not
edilmeye değer bir örnek). Durum: `spring-boot-microservice-basics`
**TR+EN tamamlandı VE canlı hata düzeltildi**.

**Wave 1'in üçüncü ve son topic'i: `inter-service-communication`** (V176-V178, TR+EN
aynı fazda). `order-service`'in yanına ikinci bir mikroservis (`inventory-service`,
port `8082`, kendi `inventory_db`'si) eklenip, `order-service`'ten `inventory-service`'e
Spring Framework 6.1'in senkron istemcisi `RestClient` ile bir çağrı kuruldu (ek
bağımlılık gerekmedi, `spring-boot-starter-web` zaten `RestClient`'ı sağlıyor -- eski
`RestTemplate`/reaktif `WebClient` yerine bilinçli tercih, gerekçesi dersin "Tarihçe"
bölümünde). 13 ana bölüm + Pratik Proje, 8 örnek (7 `.java` + 1 `.yml`) -- kategorinin
en yoğun topic'i. Öne çıkan tasarım kararları: (1) `StockClient`, HTTP 404
(`HttpClientErrorException.NotFound`, "üretim tanınmıyor" -- servis ayakta, düzgün bir
"hayır") ile bağlantı hatasını (`ResourceAccessException`, servise hiç ulaşılamıyor)
bilerek iki ayrı `catch` bloğunda ayırıyor, ikincisini kendi anlamlı istisnasına
(`InventoryServiceUnavailableException`) çeviriyor; (2) `order-service`, `inventory-service`'in
`InventoryItem`'ını değil kendi `StockCheckResponse` DTO'sunu kullanıyor -- REST API
Tasarımı dersindeki DTO mantığının servisler arası hâli, iki servisin domain modelini
kod seviyesinde birbirinden bağımsız tutuyor; (3) base URL sabit kodlanmadı,
`@Value("${services.inventory-service.url}")` ile `application.yml`'den okunuyor
(Autoconfiguration & Properties dersine çapraz referans). Ders bilinçli olarak yalnızca
SENKRON iletişimi kapsıyor (CAP teoreminin Tutarlılık/Consistency tarafı) -- asenkron
(Event-Driven/Kafka, Availability tarafı) kursun ilerleyen olası bir konusu olarak
ayrıca işaretlendi, karıştırılmadı.

Bu topic, kategori kuralı gereği `## Ek: Mini Proje` içermiyor -- bunun yerine, React
kategorilerindeki "Pratik Proje" standardının (bkz. Faz 30) birebir Java/Maven karşılığı
ilk kez burada uygulandı: ayrı, izole bir repo (`microservices-course-projects`) gerçek,
çalıştırılabilir `order-service`+`inventory-service` projeleriyle kuruldu --
`react-course-projects`'ten TEK farkı, Maven'de npm workspaces karşılığı olmadığı için
her projenin kendi bağımsız `pom.xml`'iyle kardeş klasörler (sibling folders) hâlinde
tutulması (`projects/inter-service-communication/{order-service,inventory-service}/`).
Pratik proje, ders koduna bilerek küçük bir ekleme yaptı: `GlobalExceptionHandler`
(`@RestControllerAdvice`), `IllegalArgumentException`'ı 400'e,
`InventoryServiceUnavailableException`'ı 503'e çeviriyor -- ders örneklerinde
odağı dağıtmamak için yoktu, ama "gerçek, çalıştırılabilir" bir demo için eklendi (bkz.
projenin kendi `README.md`'si). **Teslimden sonra, kullanıcı IntelliJ'de projeyi
incelerken** her iki controller'da da bir `findAll` endpoint'i eksik olduğunu fark edip
istedi: `InventoryController`/`InventoryService`'e `GET /inventory` (tüm ürünlerin stok
durumu, `productName`'e göre sıralı), `OrderController`/`OrderService`'e `GET /orders`
(tüm siparişler) eklendi -- yalnızca pratik projede, ders içeriğine (markdown +
migration'lar) DOKUNULMADI, çünkü ders kasıtlı olarak yalnızca `POST`/`GET /{id}`
çiftini işliyor ve `findAll` pedagojik olarak gerekli değildi. Projenin `README.md`'si
yeni endpoint'lerin `curl` örnekleriyle güncellendi, `.gitignore` de (repo kökünde,
Maven/IntelliJ/VS Code/OS/log/`.env` kalıplarıyla) bu fazda genişletildi.
`react-course-projects`'teki güncel kural (Testing
kategorisinden sonra git tag TERK EDİLDİ, bkz. aşağıdaki madde) baştan uygulandı: hiç tag
atılmadı, `## Pratik Proje` linki doğrudan
`.../tree/main/projects/inter-service-communication` biçiminde. **Sandbox kısıtı burada
da geçerli:** Maven Central engelli olduğu için bu proje de gerçek bir `mvn
spring-boot:run` ile derlenip çalıştırılamadı -- kod, `learning-platform`'un ve dersin
zaten dikkatle yazılmış örneklerine dayanarak yazıldı, kullanıcının kendi ortamında
doğrulaması gerekiyor (projenin `README.md`'sinde hazır `curl` komutları var). **Ayrıca,
`react-course-projects` ile aynı kısıt burada da geçerli:** bu sandbox'ın gerçek
`github.com/cdurgun/microservices-course-projects` reposuna push yetkisi/erişimi yok --
kullanıcı, paylaşılan zip'i açıp bu reposunu (henüz yoksa) kendisi GitHub'da oluşturup
push etmeli (`react-course-projects` ile aynı operasyonel model, bkz. "Bilinen
Kısıtlar").

**Durum: wave 1 (3 topic: `microservices-fundamentals`, `spring-boot-microservice-basics`,
`inter-service-communication`) TR+EN tamamlandı.** Kalan 9 aday konu (Service
Discovery/Eureka, API Gateway, Resilience4j, Configuration Management, Event-Driven/Kafka,
Distributed Transactions, Observability, Security, Deployment) hâlâ DB'ye seed edilmedi --
orijinal kararın (bkz. yukarısı, madde 1) gereği, devam etmeden önce kullanıcıyla birlikte
hangi topic'lerin/hangi sırayla bir sonraki dalgayı oluşturacağına karar verilecek.

**Faz 62'de kullanıcı isteğiyle ("Microservices de kalan konulardan ilkine devam
edebilirsin") kategoriye GERİ DÖNÜLDÜ**: kalan 9 aday konudan ilki, `service-discovery-eureka`
(V231-V233, sort_order=4) TR+EN tamamlandı -- ayrıntı için Faz 62 notuna bkz. **Güncel
durum: 4 topic tamamlandı (`microservices-fundamentals`, `spring-boot-microservice-basics`,
`inter-service-communication`, `service-discovery-eureka`), kalan 8 aday konu (API Gateway,
Resilience4j, Configuration Management, Event-Driven/Kafka, Distributed Transactions,
Observability, Security, Deployment) hâlâ DB'ye seed edilmedi.**

**Faz 41'de kullanıcı isteğiyle Microservices'e ARA VERİLDİ** (wave 1 tamamlanmış
durumda, istendiğinde geri dönülecek -- bkz. yukarıdaki Faz 62 notu, artık geri dönüldü)
ve `java` kursuna yeni, dördüncü bir kategori
açıldı: **`functional-interfaces-streams`** ("Functional Interfaces & Streams",
V179'da, `java-basics`/`oop`/`concurrency`'den sonra sort_order=4). Kullanıcı
ChatGPT'nin hazırladığı 11 maddelik bir planı ("Functional Interface", "Built-in
Functional Interfaces", "Method References", "Lambda Expressions", "Stream API",
"Intermediate/Terminal Operations", "Collectors", "Optional", "Primitive Streams",
"Parallel Streams") paylaşıp bunun tek bir kategori mi yoksa "Functional Interfaces" ve
"Streams" diye ikiye mi bölünmesi gerektiğini sordu. Önerim (**tek kategori**, kullanıcı
onayladı), gerekçesi: (1) kullanıcının vurguladığı "Functional Interface -> Lambda ->
Stream -> Intermediate -> Terminal" zincirini sürekli gösterme hedefi bir kategori
sınırıyla bölünmeden daha iyi korunuyor; (2) precedent'te tek kategoride 9 topic'e kadar
çıkılmış (Spring MVC), planlanan 7 topic bunun altında; (3) ikiye bölünseydi
"Functional Interfaces" kategorisi yalnızca 2 topic'ten oluşurdu, mevcut kategorilerin
hepsi 3+ topic içeriyor. Planlanan 7 topic (ChatGPT'nin 11 maddesi, bu projenin "bir
topic = 5-9 kavram" büyüklüğüne göre gruplandı): 1) `lambda-expressions` (yazıldı), 2)
built-in functional interfaces + method references, 3) Stream API fundamentals +
intermediate operations, 4) terminal operations, 5) collectors, 6) optional, 7)
primitive + parallel streams.

**Önemli bir bulgu, planı doğrudan etkiledi:** bu konu sıfırdan başlamıyor -- `oop`
kategorisindeki `interface` dersinde zaten bir "Functional Interface ve Lambda"
bölümü var (functional interface tanımı, `@FunctionalInterface`, lambda'nın bağlantısı,
`java.util.function`'a kısa referans, `FunctionalInterfaceExample.java` örneği). Yeni
kategorinin ilk topic'i (`lambda-expressions`) bunu TEKRARLAMIYOR -- kısa bir tanıtım
paragrafıyla `interface` dersinin "Functional Interface ve Lambda" bölümüne çapraz
referans verip oradan derinleşiyor (parametre yazım kuralları, expression/block body
ayrımı, target typing, effectively final, anonymous class farkı -- hiçbiri `interface`
dersinde yoktu).

**Sandbox avantajı, kullanıcı onayıyla kullanıldı:** bu kategori Spring Boot'un aksine
hiçbir dış bağımlılığa ihtiyaç duymuyor (`java.util.function`/`java.util.stream` saf
JDK) -- Microservices'te Maven Central engelliyken burada hiç sorun değil. Kullanıcı
"derleyebilirsin" dedi -- Faz 12'den beri geçerli olan "yazıldıktan sonra derleme yok"
varsayılan kuralına BİLİNÇLİ bir istisna: `lambda-expressions`'ın 4 örneği
(`LambdaSyntaxAndReturnExample`, `TargetTypingExample`, `EffectivelyFinalExample`,
`AnonymousClassVsLambdaExample`) önce ayrı bir scratch klasöründe yazılıp gerçekten
`javac`+`java` ile derlenip çalıştırıldı, çıktılar (`AYSE!`, `[item, item]`,
`[Al, Ayse, Ahmet]`, `AnonymousClassVsLambdaExample$1` gibi) doğrudan gözlemlenip
ders metnine/yorumlara işlendi -- tahmin değil, gerçek doğrulama. (Bu arada bir
detay bulundu: `Class.getSimpleName()` anonymous class'lar için boş string döner --
örnek `getName()`'e çevrildi, `AnonymousClassVsLambdaExample$1` gibi okunabilir bir
çıktı versin diye.) TR+EN aynı fazda yazıldı (Faz 20 sonundaki standart ritim), 11
ana bölüm + 4 örnek. Durum: `lambda-expressions` **TR+EN tamamlandı**.

**Aynı fazda, kullanıcının "olur devam edebilirsin" onayıyla ikinci topic
`built-in-functional-interfaces`** de yazıldı (V182-V184, sort_order=2, INTERMEDIATE,
13 ana bölüm + 6 örnek). `java.util.function` paketindeki hazır interface'leri kapsıyor:
`Predicate<T>` (`test`, `negate()`/`and()`/`or()`), `Function<T,R>` (`apply`,
`andThen()`/`compose()`), `Consumer<T>` ve `Supplier<T>` (yan etki vs. tembel üretim),
`UnaryOperator<T>`/`BinaryOperator<T>` (Function/BiFunction'ın aynı-tip özel halleri,
`BinaryOperator.maxBy()`/`minBy()` dahil), ve dört method reference biçimi
(`Class::staticMethod`, `object::instanceMethod` "bound", `Class::instanceMethod`
"unbound", `Class::new` constructor reference -- bu sonuncusu bir `record Point` ile
gösterildi). İçerik hem `interface` dersinin "Functional Interface ve Lambda"
bölümüne hem de `lambda-expressions`'ın "Lambda'nın Functional Interface ile
Bağlantısı: Target Typing" bölümüne çapraz referans veriyor, hiçbirini tekrarlamıyor.
Sidebar başlığı, içerik "Built-in Functional Interfaces & Method References"i
kapsasa da, "Mikroservis Yapılandırma" precedent'iyle tutarlı olarak kısaca
"Built-in Functional Interfaces" bırakıldı (TR ve EN'de aynı -- bu kursta Java'ya
özgü teknik terimler zaten "Interface"/"Record"/"Enum" gibi TR başlıklarda da
İngilizce bırakılıyor). Aynı sandbox-compile süreciyle 6 örnek de
`/tmp/work/scratch/builtin-fi/` altında gerçekten `javac`+`java` ile derlenip
çalıştırıldı, çıktılar (`true`/`false`/`true`/`true`/`false`, `5`/`25`/`3`,
`hi`/`HI`/`[a]`, `HI!`/`HEY!`/`9`/`hello`, `42`/`Hello, world`/`true`,
`[]`/`hi`/`Point[x=3, y=4]`) doğrudan gözlemlenip ders metnine işlendi, sonra
`examples/built-in-functional-interfaces/` altına kopyalandı. TR+EN aynı fazda
yazıldı. Durum: `built-in-functional-interfaces` **TR+EN tamamlandı**.

**Faz 42'de kullanıcı bir stil düzeltmesi istedi:** Faz 41'de yazılan iki dersin (TR ve
EN) ilk paragrafında "Örnekler gerçekten derlenip çalıştırılarak doğrulandı."/"Examples
were actually compiled and run to verify them." cümlesi vardı -- kullanıcı bunun ders
metninde gereksiz olduğunu belirtip çıkarılmasını, bundan sonraki topic'lerde de hiç
yazılmamasını istedi. İçerik dosyalarından (`lambda-expressions.md` TR+EN, ders metni
DB'de değil dosya sisteminde tutulduğu için bu değişiklik sorunsuz) kaldırıldı.

**HATA VE DÜZELTME:** aynı cümlenin tekrar ettiği `V179`/`V182` migration'larının
`summary` alanları da İLK ÖNCE yanlışlıkla yerinde (in-place) düzenlenmişti -- "bu
migration'lar henüz kullanıcıya uygulanmamıştır" varsayımıyla. Bu varsayım YANLIŞTI:
kullanıcı uygulamayı çalıştırınca gerçek bir Flyway hatası aldı -- "Migration checksum
mismatch for migration version 179/182" -- yani bu migration'lar kullanıcının kendi
veritabanında ÇOKTAN uygulanmıştı, tam da CLAUDE.md'nin "asla uygulanmış migration'ı
düzenleme" kuralının uyarmaya çalıştığı durum. Düzeltme: `V179` ve `V182` orijinal
haline (cümle geri eklenerek, checksum'lar eski haline dönecek şekilde) geri
döndürüldü; asıl düzeltme (cümlenin `summary` alanından kaldırılması) doğru şekilde
yeni bir migration'la (`V188`, iki topic'in dört `topic_translation` satırına UPDATE)
uygulandı. Ders: bu kategori aynı oturumda yazılıyor olsa bile, kullanıcı zip'i alıp
KENDİ ortamında bir kez `mvn`/uygulamayı çalıştırdıysa migration UYGULANMIŞ sayılır --
"aynı oturumda yazıldı" kesinlik ifade etmez, migration immutability kuralı
şüpheli durumda da geçerli sayılmalı, mutlaka yeni migration tercih edilmeli.
Migration yorumlarındaki (`-- ... doğrulandı` gibi) iç süreç notları bilinçli olarak
dokunulmadan bırakıldı -- kullanıcının itirazı ders metnindeki/summary'deki kullanıcıya
görünen cümleyeydi, geliştirici yorumlarına değil. Sandbox-compile süreci (bkz.
yukarısı, "Sandbox avantajı") kalıcı bir uygulama olarak devam ediyor, yalnızca artık
ders metninde bundan bahsedilmiyor.

**Aynı fazda üçüncü topic `stream-fundamentals`** de yazıldı (V185-V187, sort_order=3,
INTERMEDIATE, 13 ana bölüm + 6 örnek). Orijinal 7 topic'lik plandaki 5. ve 6. maddeler
("Stream API" ve "Intermediate Operations") tek topic'te birleştirildi -- ikisi
kavramsal olarak ayrılmayacak kadar iç içe (Stream'in ne olduğu ile filter/map gibi
intermediate operation'lar aynı derste doğal olarak akıyor). Kapsam: Stream'in veri
saklamayan, tek geçişlik bir pipeline olması; source (`stream()`, `Stream.of()`,
`Arrays.stream()`, `Stream.iterate()`); pipeline'ın üç aşaması (source/intermediate/
terminal); `filter()`/`map()`/`flatMap()` (`flatMap()`'in `map()`'in ürettiği
"stream'lerin stream'i" tuzağını nasıl çözdüğü dahil); `distinct()`/`sorted()`/`peek()`;
`limit()`/`skip()` (sayfalama örneğiyle); lazy evaluation; ve stream'in tek kullanımlık
doğası -- `LazyEvaluationExample.java`, gerçek bir `IllegalStateException`'ı yakalayıp
mesajını (`stream has already been operated upon or closed`) yazdırarak bunu somut
gösteriyor. Kullanıcının paylaştığı `names.stream().filter(name -> name.startsWith("A"))
.map(String::toUpperCase).toList()` örneği, "Neden Var?" bölümünde `interface`
(functional interface temeli), `lambda-expressions` (lambda ve method reference
sözdizimi) ve `built-in-functional-interfaces` (`Predicate`/`Function`) derslerinin bir
araya geldiği somut nokta olarak birebir kullanıldı. 6 örnek yine aynı sandbox-compile
süreciyle (`/tmp/work/scratch/stream-fundamentals/`) gerçekten `javac`+`java` ile
derlenip çalıştırılarak doğrulandı -- bu doğrulama artık (Faz 42 kararıyla) yalnızca
migration yorumlarında belgeleniyor, ders metninde değil. TR+EN aynı fazda yazıldı.
Durum: `stream-fundamentals` **TR+EN tamamlandı**.

**Faz 43'te, kullanıcının Faz 42 zip'ini kendi ortamında çalıştırmasıyla gerçek bir
Flyway hatası ortaya çıktı:** "Migration checksum mismatch for migration version
179/182". Faz 42'de V179/V182'nin summary alanları yerinde (in-place) düzenlenmişti --
bu, bu migration'ların kullanıcının veritabanında henüz uygulanmadığı YANLIŞ
varsayımıyla yapılmıştı; gerçekte kullanıcı bunları çoktan uygulamıştı. Düzeltme:
V179/V182 tamamen orijinal haline (cümle geri eklenerek) döndürüldü, checksum'lar eski
haline döndü; asıl istenen değişiklik (cümlenin `summary` alanından kaldırılması) yeni
bir migration'la (`V188`) doğru şekilde `UPDATE` olarak uygulandı. Ders metninin
kendisi bu hatadan hiç etkilenmedi çünkü DB'de değil dosya sisteminde tutuluyor.
Kullanıcı düzeltmeyi kendi ortamında çalıştırıp hatasız olduğunu doğruladı. **Kalıcı
ders:** bir migration "bu oturumda yazıldı" diye henüz uygulanmamış SAYILAMAZ --
kullanıcı zip'i teslim alıp kendi ortamında bir kez çalıştırdıysa migration
UYGULANMIŞ'tır; şüpheli durumda immutability kuralı ihlal edilmemeli, her zaman yeni
migration tercih edilmeli.

**Aynı fazda (Faz 44) dördüncü topic `terminal-operations`** yazıldı (V189-V191,
sort_order=4, INTERMEDIATE, 14 ana bölüm + 6 örnek). Kapsam: `forEach()` (yan etki),
`reduce()` (üç overload -- identity'li/identity'siz/combiner'lı), `count()`, `min()`/
`max()` (Comparator gerektiren, `Optional<T>` dönen), `findFirst()`/`findAny()`
(`Optional<T>`), `anyMatch()`/`allMatch()`/`noneMatch()` (kısa devre yapan `boolean`
kontroller), `toList()`/`toArray()`. `collect()`'in asıl gücü (özellikle
`Collectors` sınıfı) BİLİNÇLİ OLARAK bu topic'e dahil edilmedi, bir sonraki topic'e
(`collectors`) ayrıldı -- yalnızca `toList()`'in (Java 16, `collect(Collectors.
toList())`'in unmodifiable kısayolu) dolaylı bir bahsi var. `stream-fundamentals`'daki
"Stream Pipeline: Source, Intermediate, Terminal" bölümüne ve `built-in-functional-
interfaces`'teki `Class::new`'e (toArray()'in constructor reference argümanı için)
çapraz referans verildi.

**Gerçek bir keşif, sandbox-compile sürecinin tam olarak var olma sebebini
gösterdi:** `ShortCircuitExample.java` ilk yazımda "count() kısa devre yapmaz, her
elemanı işlemek zorundadır" varsayımıyla yazılmıştı (`anyMatch()`/`findFirst()` gibi
kısa devre YAPAN operation'larla karşılaştırma amacıyla). Sandbox'ta gerçekten
derlenip çalıştırılınca bu varsayımın YANLIŞ olduğu ortaya çıktı:
`Stream.of(1,2,3).peek(n -> System.out.println("counting: " + n)).count()`
çalıştırıldığında `peek()`'in içindeki yazdırma satırı **hiç çalışmadı** -- `total: 3`
doğrudan yazdırıldı, hiçbir `counting: n` satırı olmadan. Bunun sebebi JDK'nın
`Stream.count()` javadoc'unda açıkça belgelenen, kasıtlı bir optimizasyon: source'un
boyutu bilindiğinde (burada `Stream.of(1,2,3)`, SIZED bir source) `count()` pipeline'ı
hiç çalıştırmadan doğrudan hesaplanabilir. Kod yorumu ve "Kısa Devre ve count()'un
Şaşırtıcı Davranışı" bölümü, ilk (yanlış) varsayım yerine bu gerçek gözlemi
yansıtacak şekilde yazıldı. Kullanıcı isteğiyle (Faz 42) ders metninde bir
"derlenip doğrulandı" cümlesi yok, bu doğrulama yalnızca migration yorumunda
belgeleniyor. TR+EN aynı fazda yazıldı. Durum: `terminal-operations` **TR+EN
tamamlandı**.

**Aynı fazda (Faz 45) beşinci topic `collectors`** yazıldı (V192-V194, sort_order=5,
INTERMEDIATE, 13 ana bölüm + 6 örnek). Kapsam: bir `Collector`'ın üç bileşeni
(supplier/accumulator/combiner, kavramsal bir giriş -- kendi `Collector`'ınızı
yazmayı öğretmiyor, yalnızca `Collectors` sınıfının bunu nasıl sizin için hazır
kurduğunu anlatıyor), `Collectors.toList()`/`toSet()`, `joining()` (3 overload:
argümansız, ayraçlı, ayraç+önek/sonek'li), `groupingBy()` (+ downstream collector
olarak `counting()`/`mapping()`), `partitioningBy()` (her iki anahtarın da her zaman
var olması, `groupingBy()`'dan bu farkı), `toMap()` (iki argümanlı hali çakışan
anahtarda gerçek bir `IllegalStateException` fırlatıp yakalanarak gösterildi, üç
argümanlı `BinaryOperator` ile merge fonksiyonu hali). `terminal-operations`'taki
"toList() ve toArray(): Basit Koleksiyona Dönüştürme" bölümüne çapraz referans
verildi -- `Stream.toList()`'in (immutable) `collect(Collectors.toList())`'ten
(mutable) farkı, bu iki dersi birbirine bağlayan ana nokta oldu (`ToListToSetExample.java`
bu farkı gerçekten `mutableList.add(...)`'in başarılı olmasıyla gösteriyor). 6 örnek
yine aynı sandbox-compile süreciyle (`/tmp/work/scratch/collectors/`) gerçekten
`javac`+`java` ile derlenip çalıştırılarak doğrulandı -- bu doğrulama yalnızca
migration yorumunda belgeleniyor, ders metninde değil (Faz 42 kararı). TR+EN aynı
fazda yazıldı. Durum: `collectors` **TR+EN tamamlandı**.

**Kullanıcının "çabuk bitiriyorsun :) kalan 2 topiği bitirebilirsin" onayıyla, aynı
fazda kategorinin son iki topic'i de arka arkaya yazıldı.**

**Altıncı topic `optional`** (V195-V197, sort_order=6, INTERMEDIATE, 13 ana bölüm + 6
örnek). Kapsam: `Optional<T>`'ın var olma sebebi (null güvenliğini tip sistemine
taşımak), `of()`/`ofNullable()`/`empty()` ile oluşturma, `isPresent()`/`isEmpty()`/
`get()`, `orElse()` vs `orElseGet()`, `orElseThrow()` (iki biçim), `map()`/`flatMap()`
(Stream'deki aynı iç içelik probleminin Optional karşılığı), `ifPresent()`/
`ifPresentOrElse()`, `filter()`. `terminal-operations`'taki `Optional<T>` dönen beş
metoda (`reduce(accumulator)`/`min()`/`max()`/`findFirst()`/`findAny()`) çapraz
referans verildi. **Gerçek gözlem:** `OrElseExample.java`, `orElse()`'in argümanının
Optional DOLU olsa bile her zaman hesaplandığını, `orElseGet()`'in `Supplier`'ının ise
yalnızca Optional BOŞSA çağrıldığını, her çağrıdan önce bir `System.out.println` ile
gerçek çalıştırma çıktısıyla doğruladı (`"computing default: orElse, present"` satırı
gerçekten yazdırıldı, `"computing default: orElseGet, present"` satırı ise hiç
yazdırılmadı) -- varsayımla değil, gözlemle. Durum: `optional` **TR+EN tamamlandı**.

**Yedinci ve SON topic `primitive-parallel-streams`** (V198-V200, sort_order=7,
INTERMEDIATE, 15 ana bölüm + 6 örnek) -- bu, `functional-interfaces-streams`
kategorisinin planlanan 7 topic'inin TAMAMINI tamamlıyor. Kapsam: `IntStream`/
`LongStream`/`DoubleStream` (autoboxing maliyetinden kaçınmak), `range()`/
`rangeClosed()`/`of()`, primitive'e özel `sum()`/`average()`/`max()`/`min()`,
`boxed()`/`mapToObj()` ve `mapToInt()`/`mapToLong()`/`mapToDouble()` köprüleri,
`parallelStream()`/`.parallel()`, `forEach()` vs `forEachOrdered()` sıralama farkı,
thread-safe olmayan paylaşılan durum tuzağı, ne zaman kullanılmalı, ve neden her
zaman daha hızlı olmadığı.

**Bu topic'te ÜÇ ayrı gerçek gözlem yapıldı, üçü de sandbox-compile sürecinin tam
olarak var olma sebebini gösterdi:**

1. `ParallelOrderingExample.java`: aynı 10 elemanlı listede `parallelStream().forEach()`
   sırayı GERÇEKTEN bozdu (`unordered.equals(numbers)` çalıştırmada `false` çıktı),
   `forEachOrdered()` ise korudu (`true`) -- dokümantasyondaki iddia gerçek
   çalıştırmayla doğrulandı.
2. `ParallelPitfallExample.java`: 100.000 elemanlı bir listede, thread-safe olmayan bir
   `ArrayList`'e paralel `forEach()` ile yazmak, HİÇBİR İSTİSNA FIRLATMADAN, farklı
   çalıştırmalarda 96.901 ile 100.000 arasında değişen boyutlar üretti (bazı
   çalıştırmalarda şans eseri doğru bile çıktı) -- gerçek, sessiz bir veri yarışı,
   ders metninde tam olarak gözlemlenen sayılarla anlatıldı.
3. **En önemlisi:** `ParallelOverheadExample.java`'nın İLK YAZIMI, ısıtmasız
   (no-warmup) tek seferlik bir `nanoTime()` karşılaştırmasıyla YANLIŞ bir sonuç
   verdi -- sıralı yol, sırf İLK çalışan yol olduğu için (JIT henüz devreye
   girmemişken yorumlanarak/interpreted çalıştığı için), paralelden defalarca daha
   yavaş çıktı; bu, beklenen "küçük veride sıralı kazanır" anlatısının TAM TERSİYDİ.
   Aynı ölçüm 4 kez tekrarlandı, hepsinde aynı (yanlış) sonuç çıktı -- rastgele bir
   gürültü değil, sistematik bir warmup artefaktıydı. Örnek, her iki yolu da 10.000
   kez önce ısıtıp SONRA ölçecek şekilde yeniden yazıldı; ısıtılmış ölçümle sonuç
   beklenen yöne döndü (sıralı ~15ms, paralel ~41ms, birden fazla çalıştırmada
   tutarlı). Bu, sandbox-compile sürecinin ("gerçekten çalıştır, gözlemle, varsayımla
   yazma") tam olarak önlemeye çalıştığı türden bir hataydı -- gerçek çalıştırma
   olmasaydı bu ders, yanlış bir performans iddiasıyla yayınlanabilirdi.

`built-in-functional-interfaces`'e ve `collectors`'a (`Collectors.toList()` ile
thread-safe toplama, `ParallelPitfallExample.java`'daki doğru çözüm) çapraz referans
verildi. Kullanıcı isteğiyle (Faz 42) ders metninde genel bir "derlenip doğrulandı"
cümlesi yok, ama bu topic'teki SPESİFİK gözlemler (ms değerleri, gözlemlenen boyut
aralığı) doğrudan ders metninde kullanıldı -- bunlar genelleme değil, somut veri
noktaları olduğu için kullanıcının itirazının kapsamına girmiyor. TR+EN aynı fazda
yazıldı. Durum: `primitive-parallel-streams` **TR+EN tamamlandı**.

**KATEGORİ TAMAMLANDI:** `functional-interfaces-streams` kategorisi, ChatGPT'nin
orijinal 11 maddelik planından türetilen 7 topic'in TAMAMIYLA (`lambda-expressions`,
`built-in-functional-interfaces`, `stream-fundamentals`, `terminal-operations`,
`collectors`, `optional`, `primitive-parallel-streams`) TR+EN tamamlanmış durumda.
Microservices kategorisi hâlâ ARA VERİLMİŞ durumda (bkz. yukarısı, kalan 9 aday konu),
kullanıcı istediğinde devam edilecek.

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
    db/migration/{konu-slug}/     Flyway migration'ları, konu bazlı alt klasörlerde (V1..V168)
    templates/                    Thymeleaf şablonları (Bootstrap + highlight.js)
    static/css/custom.css         Sidebar accordion (.sidebar-toggle/.chevron) dahil özel stiller
    static/img/                   LearnForgeX marka varlıkları (favicon.svg/logo.svg/logo-dark.svg,
                                   favicon.ico/-16.png/-32.png, apple-touch-icon.png -- Faz 48)
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
  bu satır önceki fazlardan kalma, ortam farklıysa güncel durumu bash ile doğrula. **Güncel
  durum (Faz 40):** bu oturumda `java 21.0.10` ve `mvn 3.9.11` GERÇEKTEN kurulu (`java
  -version`/`mvn -version` ile doğrulandı) -- önceki fazlardan farklı, JDK artık mevcut.
  Ama Maven Central (`repo.maven.apache.org`, `repo1.maven.org`) proxy'den hâlâ 403 ile
  engelleniyor, Gradle dağıtım sunucusu da aynı şekilde, ve `~/.m2` önbelleği yok (`find /
  -iname .m2` boş döndü, `learning-platform`'un kendi bağımlılıkları da hiçbir yerde cache'li
  değil) -- yani hiçbir Spring Boot/harici Maven bağımlılığı indirilemiyor, `mvn compile`/
  `spring-boot:run` bu ortamda çalışmıyor. Yalnızca harici bağımlılık gerektirmeyen saf JDK
  kodu `javac` ile gerçekten derlenebilir (bu, microservices kategorisindeki mikroservis
  kodları için geçerli değil -- hepsi `spring-boot-starter-web` gibi bağımlılıklar
  gerektiriyor). `registry.npmjs.org` ve `pypi.org` ise erişilebilir durumda (React
  kursundaki gibi npm doğrulamaları hâlâ mümkün). Microservices kategorisi için sonuç:
  Production kategorisindeki (Faz 39) ritim aynen uygulanıyor -- Spring Boot kodu kursun
  zaten doğrulanmış örneklerine dayanarak dikkatle yazılıyor, gerçek `mvn`/`spring-
  boot:run` doğrulaması her topic bitince kullanıcıdan isteniyor (kullanıcı
  `AskUserQuestion` ile bu ritmi onayladı). Ortam farklıysa (özellikle Maven Central
  erişimi) güncel durumu bash ile yeniden doğrula. **Faz 41'de bu tam olarak gerçekleşti:**
  `functional-interfaces-streams` kategorisi (`java.util.function`/`java.util.stream`,
  saf JDK, hiçbir Maven bağımlılığı yok) için kullanıcı "derleyebilirsin" dedi --
  `lambda-expressions`'ın 4 örneği önce `/tmp/work/scratch/` altında yazılıp gerçek
  `javac`+`java` ile derlenip çalıştırıldı, çıktılar gözlemlenip ders metnine işlendi,
  SONRA `examples/lambda-expressions/`'a kopyalandı. Bu kategori için istisna kalıcı --
  yeni topic yazılırken (built-in functional interfaces, streams, collectors vb.) aynı
  yöntemi (önce scratch'te derle/çalıştır, doğrula, sonra asıl `examples/` klasörüne
  kopyala) tekrarla, `javac`/`java` çıktısındaki `Picked up JAVA_TOOL_OPTIONS...` uyarı
  satırını yok say (zararsız, proxy/truststore ortam değişkenlerinden geliyor).
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
  bildirdiği bağımsız bir görsel hata İKİ turda düzeltildi: `topic.html`'deki dil
  değiştirme butonu ("TR"/"EN"), başlık/özet bloğuyla aynı satırdaydı ve sağda durması
  bekleniyordu, ama özet metni yeterince uzun olduğunda (JSX, sonra Component
  Composition konusunda olduğu gibi) buton yeni bir satıra, sola düşüyordu. **1. tur**
  (başarısız): satır `d-flex justify-content-between ... flex-wrap` ile kuruluydu;
  bunu `.topic-header-info { min-width: 0; }` + `flex-grow-1`/`flex-shrink-0`
  class'larıyla düzeltmeye çalıştım (flex item'ların varsayılan `min-width: auto`
  davranışı, flex-wrap'in ne zaman devreye gireceğini etkiliyor) -- ama kullanıcı bunun
  hâlâ olduğunu bildirdi; flex-wrap'in "satıra sığmıyorsa yeni satıra geç" kararı bu
  min-width ayarına rağmen güvenilir çalışmadı. **2. tur:** satır tamamen CSS Grid'e
  çevrildi -- `.topic-header { display: grid; grid-template-columns: 1fr auto; }` (yeni
  class, Bootstrap'in d-flex/justify-content-between/flex-wrap utility'leri kaldırıldı).
  Grid, flexbox'tan farklı olarak "satır kırılsın mı" diye bir karar vermez -- 2 sütunluk
  bir grid'de 2 item her zaman kendi sütununda kalır, ikinci sütun (buton) asla ilk
  sütunun altına düşemez; yalnızca ilk sütunun genişliği daralır/metin içeride kırılır
  (`min-width: 0` burada da hâlâ gerekli, grid item'ların da aynı varsayılan davranışı
  var). Bu, yapısal olarak flex-wrap'teki belirsizliği ortadan kaldıran daha sağlam bir
  çözüm. Bu ortamda gerçek bir tarayıcı yok (Puppeteer/Playwright denendi, Chromium
  indirmesi `storage.googleapis.com`'a erişim olmadığı için başarısız oldu) -- bu yüzden
  2. tur da görsel olarak koşarak doğrulanamadı, yalnızca CSS Grid'in spesifikasyon
  düzeyinde garantisiyle (flexbox'taki gibi bir "satır kırılması" mekanizması yok)
  düzeltildi. **Doğrulandı (kullanıcı geri bildirimi):** CSS Grid çözümü doğru --
  kullanıcı ilk seferde hâlâ eski görünümü gördü, ama bunun sebebi CSS'in kendisi değil,
  `target/classes/static/custom.css`'in `src/main/resources`'taki güncel dosyayı
  yansıtmaması (Spring Boot statik dosyaları classpath'ten sunar; kaynak dosya
  değişince uygulamayı **tam olarak rebuild etmeden** -- `mvn clean install` gibi --
  eski dosya sunulmaya devam eder) -- projeyi rebuild edince buton beklendiği gibi
  sağda sabit kaldı. Bu, `docker compose up -d`'nin eski container'ı port eşlemesi
  güncellenmeden başlatması (Faz öncesindeki DB bağlantı hatası) ile aynı kökten bir
  ders: bu projede kaynak dosya değişiklikleri, ilgili katman (Docker container,
  Maven classpath) **yeniden oluşturulmadan** çalışan uygulamaya yansımıyor.

- **Faz 30 — `react-course-projects` reposu ve "Pratik Proje" standardı.**
  `learning-platform`'dan ayrı, yeni bir repo olarak `react-course-projects/`
  hazırlandı (henüz GitHub'a push edilmedi — bu ortamda GitHub MCP connector'ı yok,
  `mcp__mcp-registry__search_mcp_registry` ile `["github","git","repository"]`
  anahtar kelimeleriyle arandı, sonuç bulunamadı; repo yerel olarak `git init` +
  commit + tag ile hazırlandı, push işlemi kullanıcının kendisi tarafından
  yapılmalı). Yapı: `projects/{kategori-slug}/` altında her biri bağımsız bir Vite
  uygulaması, hepsi `main` branch'inde; ayrı, uzun ömürlü branch'ler **yok** — bunun
  yerine her proje kategori "donduğunda" bir tag alır (`react-fundamentals-v1`,
  `components-props-v1`). Bu, kullanıcının ChatGPT'den aldığı branch-tabanlı öneriye
  göre bilinçli bir sapma: uzun ömürlü branch'ler zamanla `main`'den sapar ve
  birleştirme karmaşası yaratabilir, oysa "tag ile donan, hepsi main'de duran
  klasörler" hem daha basit hem de ders içeriğinin belirli bir tag'e sabit link
  vermesini kolaylaştırıyor. Her iki proje de (`react-fundamentals`,
  `components-props`) gerçek `npm install` + `npm run build` (Vite production
  build, esbuild/rollup tabanlı) ile derlendi — bu ortamda tarayıcı olmadığı için
  (bkz. Faz 29'daki Puppeteer notu) daha önce yalnızca Babel ile syntax
  doğrulaması yapılıyordu, `npm run build` bundan daha güçlü bir doğrulama: gerçek
  import/bundling hatalarını da yakalar. Build sonrası `node_modules`/`dist`/
  `package-lock.json` silindi (outputs klasöründeki dosyalar normalde
  silinemiyor/yeniden adlandırılamıyor — `allow_cowork_file_delete` ile özel izin
  istendi). Her iki proje de, o kategoriye kadar öğretilen kavramların **dışına
  hiç çıkmıyor** (`react-fundamentals`: yalnızca JSX/ifadeler/attribute/ternary
  önizleme, state/hook/event yok; `components-props`: component'ler + props
  (destructuring/default) + composition (`children`), yine state/hook/`.map()`
  yok) — bu kısıt kod yorumlarında da açıkça belirtiliyor. `component-composition.md`
  (TR+EN) ve `jsx.md` (TR+EN) güncellendi (bkz. yukarıdaki Faz 30 paragrafı),
  V132 migration'ı ile `CardBase`/`CardDemo` `code_example` satırları silindi.
  **Ek not (aynı fazın devamı):** kullanıcı, her proje klasöründe ayrı `npm install`
  yapılırsa disk üzerinde birden fazla `node_modules` biriktiğini fark etti;
  `react-course-projects` repo köküne bir `package.json` (`"workspaces":
  ["projects/*"]`) eklenerek **npm workspaces**'e geçildi — artık `npm install`
  yalnızca repo kökünde bir kez çalıştırılır, tüm projeler ortak bir kök
  `node_modules`'ü paylaşır. Alt klasöre girip doğrudan `npm run dev` çalıştırmak
  hâlâ çalışır (Node'un modül çözümlemesi klasör ağacında yukarı doğru arar), ya da
  kökten çıkmadan `npm run dev -w projects/{proje}` kullanılabilir — her ikisi de
  gerçek `npm install` + workspace-level `npm run build` ile bu ortamda test edildi.
  Repo henüz push edilmediği için bu değişiklik doğrudan `main`'e commit'lendi,
  var olan tag'ler (`react-fundamentals-v1`, `components-props-v1`) **taşınmadı** —
  onlar hâlâ kendi kategorilerinin o anki (workspaces öncesi, bağımsız
  `npm install`'lı) donmuş halini gösteriyor; ders içeriğindeki `git clone` +
  `cd react-course-projects && npm install` talimatları her zaman `main`'in en
  güncel halini (yani workspaces akışını) klonlar, tag linkleri yalnızca GitHub'da
  o kategorinin kod hâlini taramak için kullanılıyor.
  **İkinci ek not (aynı fazın devamı):** kullanıcı, React örneklerinin ekranda
  gösterdiği metinlerin İngilizce olmasını istedi ("Sadece React course
  projects'i vermen yeterli" -- yalnızca `react-course-projects` teslim edildi,
  `learning-platform` zip'i bu adımda paylaşılmadı). `react-fundamentals` ve
  `components-props` projelerindeki ekrana basılan tüm metinler (başlıklar,
  mesajlar, badge etiketleri, `alt` attribute'ları, `<html lang>`) İngilizce'ye
  çevrildi -- kod yorumları (Türkçe anlatım, ekrana yansımıyor) kasıtlı olarak
  değiştirilmedi. Her iki proje de `npm run build` ile yeniden doğrulandı, build
  çıktısındaki JS bundle'ları Türkçe kelimeler için grep'lenerek hiç Türkçe metin
  kalmadığı teyit edildi. Bu, State & Events'teki (Faz 31) `state-events` projesi
  için de baştan geçerli -- yeni projeler artık ekran metni İngilizce yazılarak
  oluşturuluyor.
- **Faz 31 — State & Events kategorisi, ilk kez state/hook ve liste render'ı.**
  Kullanıcının "React'in en önemli bölümü" dediği kategori: Events, State,
  Conditional Rendering, Lists & Keys (ChatGPT planındaki Topic 7-8-9-10).
  Kavram sırası kasıtlı ve dikkatle korundu: `events.md`'deki örnekler yalnızca
  `console.log` kullanıyor, `useState` YOK -- state kavramı henüz tanıtılmadı.
  `state.md` ilk kez gerçek `useState` kullanıyor (React Fundamentals ve
  Components & Props'ta bilinçli olarak kaçınılan kavram, bkz. Faz 28/29 notları).
  `conditional-rendering.md`, `jsx.md`'deki kısa ternary önizlemesini (`if`/`&&`
  dahil) derinleştiriyor. `lists-and-keys.md`, ilk kez `.map()` ile liste render
  ediyor. Sade dil kararı devam ediyor, hiçbir topic'te `## Ek: Mini Proje` yok.
  18 örnek dosyasının tamamı yine Node + `@babel/preset-react` ile
  syntax-doğrulandı. `react-course-projects`'e üçüncü proje (`state-events`,
  basit bir görev listesi/task list uygulaması) eklendi -- bu proje ilk kez
  gerçek `useState` kullanan pratik proje, ve kasıtlı olarak henüz işlenmemiş
  "Forms" kategorisinin controlled component deseninden (input'u `value={state}`
  ile bağlamak) kaçınıyor: yeni görev input'u yalnızca `onChange` ile okunuyor,
  `value` prop'una geri bağlanmıyor, form `event.target.reset()` ile (plain DOM
  API, hook gerektirmez) temizleniyor. Görev tamamlama/tamamlamama toggle'ı da
  bir checkbox'ın `checked` prop'u yerine `<li onClick={...}>` ile yapıldı --
  aynı "Forms'a henüz değinme" kısıtı nedeniyle. Proje `npm run build` ile
  doğrulandı, `state-events-v1` tag'i atandı, `lists-and-keys.md`'ye (TR+EN)
  bu projeye link veren bir `## Pratik Proje` bölümü eklendi.
- **Faz 32 — Hooks kategorisi, zorluk seviyesi INTERMEDIATE'e geçti.**
  ChatGPT'nin kendi planında "bunu ayrı bir kategori yapardım" dediği kısım:
  What Are Hooks?, useEffect, useRef, useMemo & useCallback, Custom Hooks
  (ChatGPT planındaki Topic 11-15). Kullanıcıya `AskUserQuestion` ile
  zorluk seviyesi soruldu, "INTERMEDIATE
  (Önerilen)" seçildi -- React Fundamentals/Components & Props/State &
  Events hep BEGINNER'dı, hooks bir seviye daha karmaşık olduğu için
  bilinçli bir yükseliş. Sade dil kuralı yine geçerli, yalnızca zorluk
  rozeti değişti. Kavram sırası kasıtlı: `what-are-hooks.md`, State &
  Events'te zaten kullanılan `useState`'i "hook" olarak yeniden çerçeveliyor;
  `use-effect.md` ilk kez side effect/dependency array/cleanup işliyor;
  `use-ref.md`'nin son bölümü `useRef`'i `useEffect` ile birlikte kullanan
  bir örnek de içeriyor (önceki derste öğrenileni pekiştirmek için);
  `use-memo-use-callback.md`, memoization'ı VE -- kritik biçimde -- ne
  zaman KULLANILMAMASI gerektiğini (erken optimizasyon) anlatıyor;
  `custom-hooks.md`, ChatGPT'nin önerdiği `useFetch` örneğini basitleştirilmiş
  haliyle kullanıyor, hata yönetimi gibi konuların ileride "API & Data
  Fetching" kategorisinde işleneceği açıkça belirtiliyor. 18 örnek dosyasının
  tamamı yine Node + `@babel/preset-react` ile syntax-doğrulandı.
  `react-course-projects`'e dördüncü proje (`hooks`, tur/lap kaydı yapan bir
  kronometre uygulaması) eklendi -- bir custom hook (`useStopwatch`) içinde
  `useEffect`+cleanup ile `setInterval` yönetimi, `useRef` ile hem bir DOM
  elementine erişip otomatik kaydırma yapmak hem de render'ı tetiklemeyen
  kalıcı bir tur-id sayacı tutmak, `useMemo` ile en iyi turu yalnızca liste
  değiştiğinde hesaplamak, `useCallback` ile bir fonksiyon referansını sabit
  tutmak kullanılıyor. Tur listesi, Lists & Keys dersindeki kurala bilinçli
  şekilde uyularak `key` olarak index DEĞİL, her tura verilen kalıcı bir id
  ile render ediliyor (State & Events'teki `state-events` projesinin de
  aynı kurala uyduğu gibi). Proje `npm run build` ile doğrulandı, `hooks-v1`
  tag'i atandı, `custom-hooks.md`'ye (TR+EN) bu projeye link veren bir
  `## Pratik Proje` bölümü eklendi.
- **Faz 33 — Forms kategorisi, kullanıcı kararıyla önceki iki kategoride
  bilinçli kaçınılan controlled input deseni ilk kez tam işlendi.**
  Kullanıcı "Forms konusuna devam edebilirsin" dedi; ChatGPT'nin planındaki
  üç topic'ten (Controlled Components, Form Handling, Form Libraries)
  üçüncüsü hakkında `AskUserQuestion` ile soru soruldu, çünkü planın
  kendisi bile bu konuyu "daha sonra eklenebilir, ilk React öğreniminde
  şart değil" notuyla işaretlemişti -- kullanıcı "Yalnızca 2 konu
  (Önerilen)" seçti, Form Libraries (React Hook Form, Zod) şimdilik
  atlandı. `controlled-components.md`, State & Events'teki `state-events`
  projesinde ve Hooks'taki `hooks` projesinde BİLİNÇLİ OLARAK kaçınılan
  "`value={state}` ile input'u kontrol etmek" desenini ilk kez tam bir
  derste işliyor (her iki projenin kod yorumlarında da bu kısıtın
  açıkça belirtildiğini hatırlat -- artık bu kısıt kalktı, çünkü konu
  şimdi resmi olarak işlendi). `form-handling.md`, bunu gerçek bir forma
  (gönderim, çoklu alan, validation, hata mesajları) genişletiyor. Zorluk
  seviyesi Hooks'tan devam ederek INTERMEDIATE. 10 örnek dosyasının
  tamamı yine Node + `@babel/preset-react` ile syntax-doğrulandı; bir
  migration'da (`V141`) apostrof kaçışı ("...&& ile conditional
  rendering'le...") SQL string'ini erken kapatıyordu, apostrof parity
  kontrolüyle (çift sayı kontrolü) fark edilip düzeltildi -- yazarken
  dikkat edilmesi gereken bir örnek daha. `react-course-projects`'e
  beşinci proje (`forms`, bir kayıt/sign-up formu) eklendi -- controlled
  input'lar, tek state nesnesinde çoklu alan yönetimi, gönderim öncesi
  tam form validation'ı, ve geçerli gönderimde Conditional Rendering'den
  öğrenilen "koşula göre farklı component döndürme" deseniyle tamamen
  farklı bir ekran (hoş geldin mesajı) gösteriliyor. Proje `npm run build`
  ile doğrulandı, `forms-v1` tag'i atandı, `form-handling.md`'ye (TR+EN)
  bu projeye link veren bir `## Pratik Proje` bölümü eklendi. Kullanıcı bu
  fazdan itibaren zip paketleme adımı için onay istenmesine gerek
  olmadığını belirtti -- bundan sonraki fazlarda içerik onayı hâlâ
  gerektiğinde soruluyor (bkz. bu fazın başındaki AskUserQuestion), ama
  iş bitince zip'ler otomatik paketlenip paylaşılıyor.
- **Faz 34 — Routing kategorisi, react-router-dom yerine yeni birleşik
  react-router v8 paketi kullanıldı; tek büyük ChatGPT topic'i ikiye
  bölündü.** Kullanıcı "Tamamdır, başlayabilirsin yeni konuya" dedi;
  ChatGPT'nin planındaki Topic 19 — React Router tek bir topic olarak
  8 kavram listeliyordu (Routes, Route parameters, Nested routes,
  Navigation, Link, NavLink, useNavigate, useParams) -- diğer
  topic'lerin genelde 4-5 kavramına kıyasla belirgin şekilde büyüktü,
  bu yüzden `AskUserQuestion` ile soruldu, kullanıcı "2 topic'e böl
  (Önerilen)" seçti: React Router Basics (Routes, Link, NavLink) ve
  Route Parameters & Navigation (route parametreleri, useParams, nested
  routes, useNavigate). **Paket araştırması:** eğitim içeriği yazılmadan
  ÖNCE, canlı tarihe göre (~Ağustos 2026) güncel React Router paketi
  doğrulandı -- `WebSearch` ile Temmuz 2026'da react-router v8'in
  react-router-dom paketini TAMAMEN KALDIRDIĞI (birleşik `react-router`
  paketine geçildiği, React >=19.2.7 peer dependency'si gerektirdiği)
  öğrenildi; `reactrouter.com/changelog` ve `npmjs.com` sayfalarını
  `web_fetch` ile çekme denemeleri başarısız oldu (token limiti aşımı,
  timeout), bunun yerine `registry.npmjs.org`'un ham JSON API'sine
  doğrudan `curl` atılarak react-router@8.3.0'ın (react-router-dom
  hâlâ npm'de mevcut ama artık güncel olmayan 7.18.2'de) doğru sürüm
  olduğu doğrulandı. Ardından `/tmp` altında gerçek bir Vite projesi
  kurulup `npm install react-router@8.3.0` ile paket indirildi,
  `BrowserRouter`/`Routes`/`Route`/`Link`/`NavLink`/`useParams`/
  `useNavigate`/`Outlet`'i doğrudan `"react-router"`'dan import eden
  (react-router-dom'a HİÇ ihtiyaç duymayan) bir test App.jsx yazılıp
  gerçek bir `npm run build` ile derlendi -- yalnızca `.d.ts` dosyasını
  okumak yerine gerçek bir build çalıştırılarak doğrulandı, tıpkı bu
  oturumdaki diğer her teknik iddianın (highlight.js, Babel syntax,
  önceki her pratik proje) doğrulandığı gibi. 10 örnek dosyasının
  tamamı Node + `@babel/preset-react` ile syntax-doğrulandı; TR/EN
  başlık ve embed parity kontrolleri (7/7 ve 7/7 başlık, 5/5 ve 5/5
  embed) sorunsuz geçti; migration'larda literal `${` ve apostrof
  parity kontrolleri temiz çıktı. Zorluk seviyesi Forms'tan devam
  ederek INTERMEDIATE. `react-course-projects`'e altıncı proje
  (`routing`) eklendi -- öğrenme platformunun kendi kurs yapısına
  benzeyen bir kurs gezinme uygulaması: `/`, `/courses`, `/courses/new`
  (bir "kurs ekle" formu; gönderilince `useNavigate` ile `/courses`'a
  yönlendiriyor), `/courses/:courseSlug` (bir kursun konu listesi,
  `Outlet` içeriyor), `/courses/:courseSlug/:topicSlug` (nested route,
  `useNavigate(-1)` ile "Back" butonu). Yalnızca bu iki topic'te
  öğretilen react-router kavramları kullanıldı -- örneğin "index route"
  ya da üst seviye bir `Layout`+`Outlet` sarmalayıcısı (derslerde
  öğretilmedi) yerine, `NavBar` doğrudan `Routes`'un yanında render
  edildi (React Router Basics dersindeki `MultiPageNavExample` ile
  aynı desen). Proje `npm run build` ile doğrulandı (üretim JS
  bundle'ında Türkçe karakter taraması da yapıldı, temiz çıktı),
  `routing-v1` tag'i atandı, `route-parameters-navigation.md`'ye
  (TR+EN) bu projeye link veren bir `## Pratik Proje` bölümü eklendi.
  Zip paketleme, Faz 33'teki standing instruction gereği onay
  beklenmeden yapıldı.
- **Faz 35 — API & Data Fetching kategorisi, backend olarak gerçek
  Spring Boot yerine json-server kullanıldı; TanStack Query topic'i
  ertelendi.** Kullanıcı, ChatGPT planındaki 7. bölümü ("API & Data
  Fetching ⭐", Topic 20-22) paylaştı. İki genuine karar noktası vardı,
  ikisi de `AskUserQuestion` ile soruldu: (1) Topic 21'in "React → HTTP
  → Spring Boot → PostgreSQL" şeması için hangi backend kullanılacağı --
  üç seçenek sunuldu (json-server, learning-platform'un kendi Spring
  Boot'una gerçek `@RestController` eklemek, ya da public bir test API),
  kullanıcı "json-server ile sahte API (Önerilen)" seçti; gerçek üretim
  Java koduna hiç dokunulmadı, React tarafındaki kod (`src/api.js`)
  gerçek bir Spring Boot API'sine bağlanırken de birebir aynı olacak
  şekilde yazıldı. (2) Topic 22 (API Data Management / TanStack Query)
  -- Forms'taki Form Libraries kararına benzer şekilde, yeni bir npm
  bağımlılığı gerektirdiği için soruldu, kullanıcı "Şimdilik bırak
  (2 topic)" seçti, TanStack Query şimdilik dışarıda bırakıldı.
  **json-server araştırması:** npm registry'den güncel sürüm
  (1.0.0-beta.15) doğrulandı; bu sürümün CLI'ı eski v0.17'den FARKLI
  olduğu için (`--watch` flag'i yok, `--help` çıktısı çok daha sade)
  `npx json-server --help` ile gerçek CLI incelendi, ardından gerçek bir
  sunucu başlatılıp `curl` ile GET/POST/PUT/DELETE'in tam bir round-trip'i
  ve CORS header'ları (`Access-Control-Allow-Origin: *`, varsayılan
  olarak açık) doğrulandı -- POST'ta id'nin sunucu tarafından
  otomatik/rastgele üretildiği (sıralı tamsayı DEĞİL) fark edildi ve
  örnek/proje koduna bu şekilde yansıtıldı. `fetching-data.md`, saf
  `fetch`+`.then()` zinciriyle GET/loading/error/POST/PUT-DELETE'i tek
  tek işliyor; `react-rest-api.md`, bunları `async`/`await` + bir
  `api.js` modülü deseniyle birleştirip gerçek bir CRUD akışına
  (listeleme, oluşturma, silme, mutasyon sonrası immutability ile
  state güncelleme) genişletiyor, ilk bölümünde React→HTTP→Backend→
  Veritabanı akışını Spring Boot'a referansla (kavramsal olarak, kod
  olmadan) anlatıyor. Zorluk seviyesi Routing'ten devam ederek
  INTERMEDIATE. 10 örnek dosyasının tamamı Node + `@babel/preset-react`
  ile syntax-doğrulandı (async/await, Babel'in preset-react'i tek
  başına -- preset-env olmadan -- de doğru parse ediyor); TR/EN başlık
  ve embed parity kontrolleri (6/6 ve 8/8 başlık, 5/5 ve 5/5 embed)
  sorunsuz geçti; migration'larda literal `${` ve apostrof parity
  kontrolleri temiz çıktı. `react-course-projects`'e yedinci proje
  (`api-data-fetching`) eklendi -- `db.json`'dan beslenen bir json-server
  (`npm run server`, port 3000) ve ayrı bir Vite dev sunucusu (`npm run
  dev`, port 5173) gerektiren iki-süreçli bir kurulum; `src/api.js`,
  `getCourses`/`createCourse`/`deleteCourse` fonksiyonlarını dışa
  aktarıyor (gerçek bir proje olduğu için, embed örneklerinin aksine,
  component'ler bu modülü GERÇEKTEN import ediyor). Proje `npm run
  build` ile doğrulandı, ayrıca json-server GERÇEKTEN başlatılıp tam bir
  GET→POST→DELETE round-trip'i `curl` ile test edildi (üretim JS
  bundle'ında Türkçe karakter taraması da temiz çıktı), `api-data-
  fetching-v1` tag'i atandı, `react-rest-api.md`'ye (TR+EN) bu projeye
  link veren bir `## Pratik Proje` bölümü eklendi. Zip paketleme, Faz
  33'teki standing instruction gereği onay beklenmeden yapıldı.
- **Faz 36 — State Management kategorisi, Redux Toolkit/Zustand topic'i
  artık üçüncü kez tekrarlanan bir desenle (soru sorulmadan) atlandı.**
  Kullanıcı "Olur devam edebilirsin" dedi; ChatGPT'nin planındaki üçüncü
  topic'in (Topic 25 — State Management Libraries) kendi notu "Bunları
  ayrı ayrı daha sonra ekleyebiliriz" -- bu, Forms'taki Form Libraries
  (Faz 33) ve API & Data Fetching'teki TanStack Query (Faz 35) ile
  BİREBİR aynı "ileri seviye/opsiyonel kütüphane, sonraya bırakılabilir"
  çerçevesi. Üç kategoridir aynı tercih tutarlı olduğu için, bu kez
  `AskUserQuestion` sorulmadı -- doğrudan 2 topic'le (Sharing State,
  Context API) ilerlendi, karar CLAUDE.md'de şeffaf şekilde belgelendi.
  `sharing-state.md`, iki kardeş component'in aynı state'e ihtiyaç
  duyduğu "sorunu" (ayrı state'ler, birbirini göremiyor) göstererek
  başlıyor, `LiftingStateUpExample`+`SyncedSiblingsExample` ile "state'i
  ortak ataya taşımak" çözümünü iki farklı senaryoda (liste filtreleme +
  senkron kardeş input'lar) pekiştiriyor, sonra `PropsDrillingExample`+
  `WhyPropsDrillingHurtsExample` ile bir sonraki dersi motive eden
  problemi (derin ağaçta zorunlu prop aktarımı) gösteriyor.
  `context-api.md`, aynı derin-ağaç örneğini Context ile YENİDEN YAZARAK
  (`AvoidingPropsDrillingExample`) çözümü somutlaştırıyor,
  `ContextWithStateExample` ile Context'in yalnızca sabit değer değil
  state+updater çiftini de taşıyabildiğini, `CustomContextHookExample`
  ile de Hooks dersindeki custom hook deseniyle birleşen "professional"
  kalıbı (`useTheme()` gibi, Provider dışında kullanılırsa hata
  fırlatan) gösteriyor; `DefaultValueExample`, Provider olmadığında
  `createContext`'e verilen varsayılan değerin kullanıldığı gotcha'yı
  ayrıca ele alıyor. Zorluk seviyesi API & Data Fetching'ten devam
  ederek INTERMEDIATE. 10 örnek dosyasının tamamı Node +
  `@babel/preset-react` ile syntax-doğrulandı; TR/EN başlık ve embed
  parity kontrolleri (6/6 ve 7/7 başlık, 5/5 ve 5/5 embed) sorunsuz
  geçti; migration'larda literal `${` ve apostrof parity kontrolleri
  temiz çıktı. `react-course-projects`'e sekizinci proje
  (`state-management`) eklendi -- iki topic'i TEK bir uygulamada
  birleştiren bir kurs listesi: arama metni `App`'te tutulup
  (lifting state up) `SearchBar`+`CourseList`'e props ile aktarılıyor;
  favori kurslar bir `FavoritesContext` (`createContext`+`Provider`+
  `useFavorites()` custom hook) ile yönetiliyor, hem başlıktaki
  `FavoritesBadge` hem listenin İÇİNDEKİ her `CourseItem` bu context'i
  hiçbir props drilling olmadan okuyor/güncelliyor. Proje `npm run
  build` ile doğrulandı (üretim JS bundle'ında Türkçe karakter
  taraması da temiz çıktı), `state-management-v1` tag'i atandı,
  `context-api.md`'ye (TR+EN) bu projeye link veren bir
  `## Pratik Proje` bölümü eklendi. Zip paketleme, Faz 33'teki standing
  instruction gereği onay beklenmeden yapıldı. **Sandbox notu:** bu faz
  sırasında `react-course-projects` klasörü `react-course-projects 2`
  olarak (muhtemelen kullanıcının bilgisayarındaki bir dosya
  senkronizasyon çakışması nedeniyle) yeniden adlandırılmış halde
  bulundu -- orijinal isimdeki klasör hiç yoktu, yalnızca " 2" soneki
  olan kopya vardı, ama git geçmişi (tüm commit'ler ve tag'ler) eksiksiz
  ve doğruydu. Çalışmaya bu yeni yoldan devam edildi, klasör yeniden
  adlandırılmaya ÇALIŞILMADI (kullanıcının kendi dosya sisteminde neye
  sebep olacağı belirsiz olduğu için). Kullanıcıya bu durum ayrıca
  bildirilmedi çünkü iş akışını etkilemedi, ama ileride benzer bir
  " 2"/" 3" soneki fark edilirse aynı şekilde davranılmalı: klasörü
  yeniden adlandırmaya çalışmadan, mevcut olan yolda çalışmaya devam et.
- **Faz 37 — Advanced React kategorisi, kursun İLK class component'i
  (Error Boundaries) ve zorluk seviyesinin ADVANCED'a yükselmesi.**
  Kullanıcı "olur devam edebilirsin" dedi; ChatGPT'nin planındaki beş
  topic'in (Topic 26-30) HİÇBİRİ "sonraya bırakılabilir" notu
  içermiyordu, hepsi olduğu gibi alındı. **Zorluk kararı** kendiliğinden
  verildi (AskUserQuestion sorulmadan) -- kategori adının kendisi
  "Advanced React" olması VE içeriğin gerçekten daha karmaşık olması
  (bkz. aşağı) yeterince açık bir sinyaldi; bu, Java kursundaki "Advanced
  Spring MVC" kategorisinin (Faz 24) aynı isim-bazlı gerekçeyle ADVANCED
  olmasıyla tutarlı bir karar.
  **Araştırma/doğrulama:** Error Boundaries dersini yazmadan önce
  WebSearch'te "React 19'da useErrorBoundary hook'u eklendi" diye YANLIŞ
  bir iddiayla karşılaşıldı (bir GitHub demo reposunun kendi
  başlığından kaynaklanıyordu, resmi bir React özelliği DEĞİL) -- bu,
  gerçek `react@19.2.8` paketi npm'den indirilip
  `react.development.js`'teki TÜM `exports.use*` satırları grep'lenerek
  çürütüldü: böyle bir hook yok, error boundary'ler hâlâ yalnızca class
  component + `static getDerivedStateFromError` ile yazılabiliyor. Aynı
  doğrulamada `use`, `Profiler`, `Suspense`, `lazy`, `Component`
  (react'te) ve `createPortal` (react-dom'da) gerçek export'lar olarak
  teyit edildi -- bu oturumdaki diğer her teknik iddianın (react-router
  v8, json-server v1beta) doğrulandığı gibi, ders içeriği yazılmadan
  ÖNCE gerçek paket incelendi.
  `react-performance.md`, State & Events/Hooks'ta öğrenilen `useMemo`/
  `useCallback`'i doğrudan performans bağlamında tekrar ele alıp yeni
  `React.memo`'yu ekliyor -- `memo` + `useCallback` kombinasyonunun
  (fonksiyon prop'ları için) gerekliliği ayrı bir örnekte gösteriliyor;
  gerçek React export'u olan `<Profiler>` component'i de (React
  DevTools Profiler sekmesinin arkasındaki mekanizma) bir örnekte
  kullanıldı. `error-boundaries.md`, açıkça "bu, kursun İLK class
  component'i" uyarısıyla başlıyor; `getDerivedStateFromError`,
  `componentDidCatch`, birden fazla küçük boundary kullanmanın faydası,
  ve error boundary'lerin YAKALAMADIĞI hata türleri (event handler'lar,
  async kod, boundary'nin kendisi) ayrı ayrı işleniyor.
  `lazy-loading-code-splitting.md`, Routing dersindeki route'ları
  `React.lazy` ile bölmeyi (route-based code splitting), named
  export'larla lazy kullanmanın küçük uyarlamasını, ve koşullu lazy
  loading'i gösteriyor. `suspense.md`, Lazy Loading'te yalnızca
  `lazy()`'yle görülen Suspense'i derinleştiriyor -- iç içe Suspense
  sınırları, React 19'un `use()` hook'uyla (KOŞULLU çağrılabilen tek
  hook) bir Promise'i Suspense'e entegre etmek, ve ÖNEMLİ bir gotcha:
  API & Data Fetching'teki `useEffect`+`fetch` deseninin Suspense'i
  OTOMATİK tetiklemediği açıkça vurgulanıyor. `portals.md`,
  `createPortal` ile modal'lar, ve Portal'ların en şaşırtıcı davranışı
  olan event bubbling'in gerçek DOM'a değil React'in component ağacına
  göre işlemesini gösteriyor.
  22 örnek dosyasının tamamı Node + `@babel/preset-react` ile
  syntax-doğrulandı; TR/EN başlık ve embed parity kontrolleri (5 topic,
  hepsi eşleşti) sorunsuz geçti; migration'larda literal `${` ve
  apostrof parity kontrolleri temiz çıktı.
  `react-course-projects`'e dokuzuncu proje (`advanced-react`) eklendi
  -- dört ana deseni birleştiren tek bir uygulama: `CourseList`
  (`memo` ile sarmalı), `ErrorBoundary` (kursun tek class component'i,
  `BuggyWidget`'ın fırlattığı hatayı yakalıyor), `CourseDetails`
  (`React.lazy` ile yüklenen, `Suspense` fallback'li bir modal içeriği),
  `Modal` (`createPortal` ile `document.body`'ye render edilen).
  `npm run build` çıktısında `CourseDetails`'in GERÇEKTEN ayrı bir chunk
  (`CourseDetails-*.js`) olarak üretildiği doğrulandı -- code
  splitting'in yalnızca teoride değil, gerçek build çıktısında da
  çalıştığının somut kanıtı. Proje `npm run build` ile doğrulandı
  (üretim JS bundle'ında Türkçe karakter taraması da temiz çıktı),
  `advanced-react-v1` tag'i atandı, `portals.md`'ye (TR+EN) bu projeye
  link veren bir `## Pratik Proje` bölümü eklendi. Zip paketleme, Faz
  33'teki standing instruction gereği onay beklenmeden yapıldı.
  **Sandbox notu:** bu fazda HEM `react-course-projects` HEM
  `learning-platform` için dosya senkronizasyon çakışmaları yaşandı --
  `react-course-projects` ve `react-course-projects 2` birlikte var
  oldu (ikisi de aynı, güncel git geçmişine sahipti, " 2" olan
  working tree'si daha güncel olduğu için o kullanıldı); daha ciddi
  olarak, `learning-platform` (git'siz, düz bir klasör) tarafında
  **tek bir dosya değil, tüm working directory** bozulmuş çıktı:
  `project/learning-platform/learning-platform/` yalnızca Faz 37'de
  yazılan 5 Advanced React örnek/içerik klasörü ve migration'ları
  içeriyordu -- o faza kadarki TÜM önceki Java/Spring ve React
  kategorileri (46 TR + 46 EN içerik dosyası, 32 migration klasörü,
  44 örnek klasörü) o kopyada YOKTU. Asıl tam ve güncel kopya ayrı bir
  sync-çakışma klasöründe (`project 2/learning-platform/learning-platform/`)
  bulundu -- Faz 36 sonuna kadar her şey sağlamdı, sadece Faz 37'nin
  (Advanced React) yeni dosyaları eksikti. Kurtarma: Faz 37'nin 5 örnek
  klasörü, 10 içerik dosyası (TR+EN), `advanced-react` migration
  klasörü ve güncel CLAUDE.md, `project`'ten `project 2`'ye kopyalanarak
  birleştirildi; `diff -rq` ile iki klasör karşılaştırılıp `project`'te
  olup `project 2`'de olmayan hiçbir dosya kalmadığı doğrulandı. Ayrıca
  bu birleştirme sırasında `project 2` içinde daha eski bir sandbox
  hatasından kalma iki boş "brace expansion" klasörü bulundu (muhtemelen
  geçmişte `mkdir -p .../{a,b,c}` gibi bir komutun kabuk tarafından
  genişletilmeden literal çalışmasından kalma): `resources/{db` ve
  `java/.../learning/{domain,repository,service,controller}` -- ikisi
  de içi boş olduğu (0 dosya) doğrulanıp silindi, gerçek `db/` ve
  `domain/repository/service/controller/` klasörleri zaten ayrıca ve
  doğru şekilde mevcuttu. **Öğrenilen ders:** `learning-platform`
  git'siz olduğu için (yalnızca `react-course-projects`'in bir güvenlik
  ağı var), dosya kaybı riski daha yüksek ve daha geniş kapsamlı olabilir
  -- ileride benzer bir "dosya eksik" durumu fark edilirse, (1) önce
  olası " 2"/" 3" sonekli kopya klasörlerde aynı dosyanın daha yeni/tam
  bir sürümü olup olmadığı kontrol edilmeli, (2) `diff -rq` ile iki aday
  klasör karşılaştırılıp hangi tarafın gerçekten eksiksiz olduğu
  doğrulanmalı, (3) paketleme öncesi olası boş "brace expansion" artefakt
  klasörleri için (`{...,...}` içeren isimler) bir tarama yapılmalı --
  komple yeniden yazmaya girişilmeden önce.

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

- **`react-course-projects`'te git tag kullanımı, Testing kategorisinden (dahil)
  sonra kullanıcı kararıyla TERK EDİLDİ.** Gerekçe: benim bu repoda yaptığım
  `git tag` işlemi yalnızca KENDİ sandbox'ımdaki yerel git geçmişine uygulanıyor
  -- kullanıcının gerçek GitHub reposuna (`github.com/cdurgun/react-course-projects`)
  hiçbir zaman doğrudan erişimim/push yetkim olmadı. Kullanıcı her fazda paylaştığım
  zip'i açıp KENDİSİ push ediyor; normal `git push` tag'leri GÖNDERMEZ, `git push
  --tags` gibi ekstra bir adım gerekir -- bu adım hem kafa karıştırıcıydı hem de
  Production kategorisinde ("Vercel'e nasıl deploy ederiz?" tartışması sırasında)
  kullanıcı tarafından fark edilip sorgulandı. Kullanıcıyla konuşulup karar verildi:
  Testing'e kadar (dahil, `react-fundamentals-v1`...`testing-v1`) atılmış tag'ler
  DOKUNULMADAN repoda bırakıldı (tarihsel referans, silinmesi veri kaybı riski
  taşımıyordu ama gerek de yoktu); ama Production kategorisi için önce yanlışlıkla
  atılan `production-v1` tag'i SİLİNDİ, ve TÜM kategorilerin (Testing ve öncesi
  dahil, 10 kategori × TR+EN = 20 dosya) `## Pratik Proje` linkleri, tag'e değil
  `main` branch'ine işaret edecek şekilde güncellendi (`.../tree/{slug}-v1/...`
  → `.../tree/main/...`). Bundan sonra: YENİ bir React kategorisi/proje eklendiğinde
  artık `git tag` ATILMAYACAK, `## Pratik Proje` linkleri doğrudan
  `.../tree/main/projects/{proje}` formatında yazılacak. `react-course-projects/README.md`
  bu değişikliği açıklayan bir not içeriyor.
- **`microservices-course-projects` (Faz 40'ta kuruldu) aynı kısıta tabi: bu sandbox'ın
  gerçek `github.com/cdurgun/microservices-course-projects` reposuna hiçbir zaman push
  yetkim/erişimim olmadı** -- `react-course-projects`'teki aynı operasyonel model
  geçerli: ben projeyi bu sandbox'ta yazıp zip'le teslim ediyorum, kullanıcı KENDİSİ bu
  reposunu (henüz yoksa) GitHub'da oluşturup zip'in içeriğini push ediyor. Baştan
  `react-course-projects`'in GÜNCEL kuralıyla kuruldu: hiç `git tag` atılmadı,
  `## Pratik Proje` linkleri doğrudan `.../tree/main/projects/{proje}` formatında. Maven
  projeleri için npm workspaces karşılığı olmadığından, `react-course-projects`'ten
  farklı olarak proje klasörleri workspace değil, her biri kendi bağımsız `pom.xml`'iyle
  kardeş klasörler (`projects/{proje}/{servis-adı}/`). Bu repodaki kod da (React
  projeleri gibi) bu sandbox'ta gerçek bir derleyiciyle (`mvn spring-boot:run`, Maven
  Central engelli) doğrulanamadı -- kullanıcının kendi ortamında çalıştırıp doğrulaması
  gerekiyor.
