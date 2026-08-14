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

Migration'lar V1'den V160'a kadar uygulandı. İki kurs var: `java` kursunda üç kategori
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
    db/migration/{konu-slug}/     Flyway migration'ları, konu bazlı alt klasörlerde (V1..V160)
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
