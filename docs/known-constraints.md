# Bilinen Kısıtlar / Dikkat Edilecekler (Tam Geçmiş)

Bu dosya, `CLAUDE.md`'den Faz 76'da taşındı (dosyayı küçültmek için).
İçerik hiç değiştirilmedi, birebir taşındı. `CLAUDE.md`'de bunun kısa bir
GÜNCEL DURUM özeti var -- buradaki tam kronolojik geçmiş, bir kısıtın nasıl
keşfedildiğini/değiştiğini anlamak için.

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
- **DÜZELTİLDİ (Faz 70):** `Course` tablosunda uzun süredir `sort_order` yoktu,
  `NavigationService.buildNavigation()` `courseRepository.findAll()`'ın döndürdüğü
  sıraya (pratikte id/insert sırası) güveniyordu — dördüncü bir kurs (`ai`) eklenirken
  bu artık `V234__course_sort_order.sql` ile gerçek bir `sort_order` kolonuyla
  çözüldü (`Category`/`Topic`'teki desenin birebir aynısı), `Course.java`/
  `CourseRepository`/`NavigationService` güncellendi (bkz. "Faz 70" paragrafı). Bu
  madde yalnızca tarihsel referans için tutuluyor.
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
- **`cdn.jsdelivr.net` bu sandbox'ta erişilemiyor (Faz 68'de keşfedildi):** proje
  gerçekte Bootstrap CSS/JS'i CDN'den yüklüyor (`topic.html`/`index.html`'deki
  `<link>`/`<script>` etiketleri, production'da/tarayıcıda sorunsuz çalışır), ama bu
  sandbox içindeki Playwright testlerinde CDN linki sessizce yüklenemiyor ve sayfa
  TAMAMEN stilsiz/varsayılan tarayıcı görünümüyle render ediliyor -- bu, ilk denemede
  fark edilmeden yanlış sonuçlara (ör. "sticky çalışmıyor", "class'lar etkisiz" gibi
  aslında CSS hiç yüklenmediği için ortaya çıkan yanıltıcı ölçümlere) yol açabiliyor.
  Bootstrap'e bağımlı bir Playwright doğrulaması gerektiğinde: önce `npm install
  bootstrap@{sürüm} --no-save` ile npm registry'den (bu sandbox'ta erişilebilir) yerel
  bir kopya indirilmeli, mock HTML dosyasında CDN linki yerine bu yerel
  `bootstrap.css`/`bootstrap.bundle.min.js` dosyalarına göreli yol verilmeli. Faz 68'de
  bu sayede gerçek bir hata (TOC'un sticky-top'unun hiç çalışmaması, bkz. Faz 68 notu)
  tespit edilebildi -- CDN'li ilk denemede sayfa stilsiz render olduğu için bu hata
  görünmüyordu.
- **Zaten teslim edilmiş bir migration dosyasına -- kullanıcı onu kendi ortamında
  çalıştırmış olabileceği için -- bir daha ASLA dokunulmaz, küçük bir yorum satırı
  düzeltmesi bile olsa (Faz 83'te gerçek bir hatayla keşfedildi):** if / else topic'i
  onaylandıktan sonra V268'in yorumuna (Number Guessing Game'in hangi topic'e
  gömüleceği kararı) küçük bir not eklendi -- ama kullanıcı V268'i daha önce zaten
  kendi ortamında ÇALIŞTIRMIŞTI. Flyway her migration'ın checksum'ını
  `flyway_schema_history` tablosunda saklar ve bir sonraki başlatmada dosya
  içeriğini bu checksum'a karşı doğrular -- yorum satırı gibi işlevsel olmayan bir
  değişiklik bile checksum'ı değiştirir. Kullanıcı gerçek hatayı bildirdi:
  `FlywayValidateException: Migration checksum mismatch for migration version 268`
  ("Applied to database" vs "Resolved locally" farklı checksum'lar), uygulama hiç
  başlamadı. Düzeltme: V268 birebir orijinal içeriğine geri alındı (checksum eski
  hâline döndü), kullanıcı dosyayı değiştirip yeniden çalıştırarak sorunu doğruladı.
  CLAUDE.md'nin "migration numaraları geçmişe dönük asla değiştirilmez" kuralı zaten
  bunu söylüyordu ama bu, bir yorum-satırı düzeltmesinin bile kural kapsamında
  olduğunun canlı kanıtı oldu -- bir migration dosyası TESLİM EDİLDİKTEN sonra
  (kullanıcı henüz çalıştırmadığını doğrulamadıkça) üzerinde hiçbir düzenleme
  yapılmamalı, ek/düzeltme her zaman YENİ bir migration dosyası olmalı.
- **Bir migration dosyasının kendisi teslim edilmese/geç teslim edilse bile,
  daha YÜKSEK numaralı migration'lar önce uygulanırsa Flyway varsayılan
  ayarlarla başlamayı reddeder (Faz 84 sonrasında gerçek bir hatayla
  keşfedildi):** switch topic'inin EN yayın migration'ı (V273) ilk switch
  teslimatına dahil edilmeyi UNUTULDU (bkz. yukarıdaki madde) ve kullanıcıya
  V273'ten SONRA gelen for-loop/enhanced-for-loop/while-do-while migration'ları
  (V274-V282) içeren bir zip önce ulaştı; kullanıcı bunu çalıştırıp V274-V282'yi
  uyguladı. V273 daha sonra ayrı bir küçük zip'le gönderildiğinde, Flyway
  `flyway_schema_history` tablosunda V274-V282'nin zaten uygulanmış olduğunu,
  V273'ün ise (classpath'te dosya olarak "resolved" ama DB'de "applied" DEĞİL)
  bir BOŞLUK oluşturduğunu görüp gerçek bir hata verdi: `Detected resolved
  migration not applied to database: 273` (`Migrations have failed
  validation`, `outOfOrder=true` önerisiyle). Kök neden yine bir teslimat
  sıralaması hatası -- bu proje `spring.flyway.out-of-order` ayarını hiç
  set ETMİYOR (varsayılan `false`), yani Flyway her zaman "en son uygulanan
  versiyondan DAHA DÜŞÜK numaralı, henüz uygulanmamış bir migration" durumunu
  hata olarak görür. **Düzeltme/kalıcı ders:** (1) migration dosyaları HER
  ZAMAN oluşturuldukları anda (aynı görev/zip içinde) teslim edilmeli, "sıradaki
  topic'e geçip sonra topluca gönderirim" gibi bir gecikme asla YAPILMAMALI --
  bu tam olarak bu hatayı doğuran alışkanlık; (2) böyle bir boşluk gerçekleşirse
  tek seferlik düzeltme, `application.yml`'e GEÇİCİ olarak
  `spring.flyway.out-of-order: true` eklemek (ya da çalıştırırken
  `-Dspring.flyway.out-of-order=true` JVM argümanı vermek), uygulamayı bir kez
  başlatıp eksik migration'ın (`V273` gibi) uygulanmasını sağlamak, sonra bu
  ayarı KALDIRMAK -- kalıcı olarak `true` bırakmak, gelecekteki gerçek sıralama
  hatalarını sessizce maskeler.
- **`git mv` ile yeniden adlandırılan bir dosyaya yapılan sonraki `Write`/`Edit`
  çağrıları -- ve freed-up eski isimde yeniden yaratılan yeni bir dosya --
  bu sandbox'ta sessizce diskte kalıcı olmayabiliyor (Faz 87'de Question Pool
  yeniden tasarımı sırasında gerçek bir hatayla keşfedildi):** `QuizQuestion`
  → `Question`, `QuizOption` → `QuestionOption` (ve karşılık gelen repository
  dosyaları) `git mv` ile yeniden adlandırılıp ardından `Write`/`Edit` ile
  gerçek entity içeriği yazıldı; aynı fazda, freed-up olan eski `QuizQuestion`
  ismiyle YENİ bir dosya (join entity) yaratıldı. Araç her adımda "başarılı"
  raporladı, sonraki `Edit` çağrıları bile eski içerikle eşleşen `old_string`
  bulup başarıyla uyguladı (yani aracın kendi iç durumu tutarlıydı) -- ama
  kullanıcının kendi ortamındaki GERÇEK `mvn test` çalıştırıldığında bu ALTI
  dosyanın DÖRDÜ diskte 0 byte, İKİSİ (freed-up isimdeki yeni dosyalar)
  TAMAMEN EKSİK çıktı. Bu sandbox'taki `mvn -o compile` bunu YAKALAYAMADI
  çünkü zaten (aşağıdaki Lombok maddesine bkz.) tamamen ilgisiz dosyalarda
  bile aynı "cannot find symbol" hatasını veriyordu -- gerçek sinyal yalnızca
  kullanıcının kendi ortamındaki derlemeden geldi. **Kalıcı ders:** bir dosya
  `git mv` ile yeniden adlandırıldıktan SONRA (hedef dosyaya içerik yazarken,
  ya da freed-up eski isimde yeni bir dosya yaratırken), o dosyanın gerçek
  disk içeriğini (`wc -c`, `ls -la`) Bash ile DOĞRUDAN doğrulamadan araç
  raporuna güvenme -- şüpheli bir durumda (özellikle `git mv` sonrası bir
  isim yeniden kullanılıyorsa) tüm ilgili dosyaları `find ... -size 0` ile
  tara, gerekirse içeriği Bash heredoc (`cat > dosya <<'EOF' ... EOF`) ile
  doğrudan yazarak araç önbelleğini bypass et. **Faz 88'de aynı dersin farklı
  bir versiyonu tekrar yaşandı:** bu kez dosya bozulmadı, ama bir faz özeti
  "`quiz.js` bu fazda yeniden yazıldı" diye RAPORLADI ve bu YANLIŞTI -- dosya
  gerçekte hiç değiştirilmemişti, kullanıcı kendi tarayıcısında gerçek bir
  `400 Bad Request` ile fark etti. **Genişletilmiş ders:** yalnızca `git mv`
  sonrası değil, HER "X dosyası güncellendi/yeniden yazıldı" iddiası şüpheli
  -- kritik bir dosya için (özellikle önceki bir fazın özetine güvenerek
  "zaten yapıldı" varsayılıyorsa) iddiayı kabul etmeden önce dosyanın gerçek
  disk içeriğini (`cat`/`grep` ile beklenen anahtar kelimeyi ara) doğrudan
  doğrula.
- **Bu sandbox'ta `mvn -o` (offline) ile Lombok annotation processing hiç
  çalışmıyor -- `~/.m2`'de Lombok jar'ının BİRDEN FAZLA sürümü (1.18.4'ten
  1.18.46'ya kadar) MEVCUT olsa bile (Faz 87'de doğrulandı, önceki fazlardaki
  "Maven Central engelli, hiçbir bağımlılık indirilemiyor" genellemesinin
  ötesinde daha spesifik bir bulgu):** bu ortamda `mvn -o compile`/`mvn -o
  test` her zaman, tamamen ilgisiz dosyalarda bile (`NavigationService`,
  `PdfExportService`, `SitemapController` gibi bu oturumda hiç dokunulmamış
  dosyalar), Lombok'un ürettiği HER getter/setter/builder için "cannot find
  symbol" hatası veriyor -- bu, kod defektinin DEĞİL, annotation processor'ın
  bu offline Maven çalıştırmasında hiç devreye girmemesinin kanıtı (yalnızca
  gerçek tip/paket hataları -- "cannot find symbol: class ..." ya da "package
  ... does not exist" -- gerçek bir koddaki hatayı gösterir, "cannot find
  symbol: method getX()" TEK BAŞINA göstermez). **Sonuç:** bu sandbox'ta
  `mvn compile`/`mvn test` çalıştırmak, bir değişikliğin GERÇEKTEN
  derlenip/geçtiğini doğrulamak için KULLANILAMAZ -- yalnızca gerçek tip/paket
  seviyesi hataları (eksik/yanlış adlandırılmış sınıf, import) ayıklamak için
  sınırlı bir sinyal verir; asıl derleme/test doğrulaması HER ZAMAN kullanıcının
  kendi ortamından istenmeli (bkz. Faz 87 -- kullanıcının kendi `mvn clean
  test`'i hem gerçek bir tip hatasını hem gerçek bir şema/Hibernate hatasını
  başarıyla yakaladı, bu sandbox'taki hiçbir `mvn` çalıştırması ikisini de
  gösteremedi). **Faz 88'de yeniden doğrulandı:** quiz.js regresyonu +
  MULTIPLE_CHOICE checkbox düzeltmesinden SONRA kullanıcının kendi ortamında
  `mvn clean test` tekrar çalıştırıldı -- `Tests run: 43, Failures: 0, Errors:
  0, Skipped: 0`, `BUILD SUCCESS` -- bu sandbox'taki `mvn -o test` ise yine
  aynı ilgisiz-dosya "cannot find symbol" desenini verdi. Bu ortamdaki hiçbir
  `mvn` çalıştırması artık bir doğrulama sinyali olarak KULLANILMAMALI,
  yalnızca kullanıcının kendi ortamındaki sonuç güvenilir kabul edilmeli.
- **GÜNCELLEME (Faz 140/Quiz Area Phase 6): `mvn`'in KENDİSİ (maven-compiler-plugin'in
  Lombok annotation processor'ı bu offline çalıştırmada devreye SOKAMAMASI) bozuk --
  Lombok'un kendisi ya da JDK'nın annotation processing'i DEĞİL.** Doğrudan `javac`
  çağrısına Lombok jar'ını `-processorpath` ile VE `-proc:full` ile açıkça verildiğinde
  (`~/.m2`'deki gerçek Lombok jar'ı, örn. `lombok-1.18.46.jar`, `mvn -o -q
  dependency:build-classpath` ile üretilen tam classpath'e ek olarak), annotation
  processing GERÇEKTEN çalışıyor -- tüm proje (main + test kaynakları), gerçek Lombok
  getter/setter/builder'larıyla, SIFIR hatayla derleniyor (`javap` ile üretilen
  `.class` dosyalarında gerçek `getCourse()`/`getCategories()` vb. metotların VAR
  olduğu doğrulandı). Bu classpath'e `-parameters` bayrağı da eklenirse (Spring'in
  `@PathVariable`/`@RequestParam` reflection'ı için gerekli), `junit-platform-launcher`
  ile küçük bir `RunTests.java` (bkz. bu Faz'ın oturum geçmişi) TÜM test suite'ini
  GERÇEKTEN çalıştırabiliyor -- gerçek Postgres'e karşı (`@SpringBootTest` dahil,
  `AuthenticationFlowTest`'in MockMvc'si dahil), gerçek Flyway migration'larıyla.
  Aynı sınıf dosyaları + tam classpath ile `com.cdurgun.learning.LearningPlatformApplication`
  `main`'i DOĞRUDAN `java -cp ...` ile başlatılıp GERÇEK bir HTTP sunucusu (Tomcat)
  ayağa kaldırılabiliyor, `curl` ile gerçek uçtan uca istek/yanıt doğrulaması
  yapılabiliyor -- bu, önceki fazlarda "Maven Central engelli, Spring Boot hiç
  çalıştırılamıyor" olarak genellenen kısıtın KISMEN aşılabildiği anlamına geliyor
  (KISITLI: yalnızca `~/.m2`'de ZATEN cache'lenmiş bağımlılıklarla; yeni bir
  bağımlılık eklenirse hâlâ indirilemez). **Bu, önceki fazlardaki "bu sandbox'ta
  `mvn compile`/`mvn test` KULLANILAMAZ" sonucunu GEÇERSİZ KILMAZ** (`mvn` KOMUTUNUN
  KENDİSİ hâlâ bozuk) -- yalnızca bunun yerine kullanılabilecek, önceki fazlarda
  denenmemiş bir MANUEL workaround'un var olduğunu belgeliyor. Yeni bir Faz'da tam
  derleme/test/gerçek-DB doğrulaması gerekiyorsa önce bu workaround denenmeli (özet:
  `dependency:build-classpath` ile classpath üret, Lombok jar'ını hem classpath'e hem
  `-processorpath`'e ekle, `-proc:full -parameters` ile `javac` çağır) -- kullanıcının
  kendi ortamındaki `mvn clean test` HÂLÂ nihai/en güvenilir doğrulama kaynağı olmaya
  devam ediyor, bu workaround onun YERİNE değil, sandbox içi ek bir güven katmanı
  olarak kullanılmalı. **Faz 141'de (Question Review, Faz A/B) YENİDEN doğrulandı** --
  aynı workaround'la hem tam test suite (69/69) hem canlı uygulamaya karşı gerçek
  ADMIN/USER/anonim HTTP istekleri sorunsuz çalıştı, ayrıca yeni bir sorun ÇIKMADI.
  **Faz 142'de (Publish/Reject) BİR KEZ DAHA doğrulandı** -- tam suite 75/75, ayrıca
  canlı uygulamaya karşı gerçek publish/reject POST'ları (CSRF token'ı dahil), 409
  double-processing koruması, ve `/en/practice`'in publish edilen soruyu ANINDA
  havuza aldığı/reddedileni dışarıda bıraktığı gerçek bir HTTP çağrısıyla doğrulandı.
- **GÜNCELLEME (Faz 143, Question Review Promotion): gerçek dev/prod'a HİÇ dokunmadan
  bir Flyway migration'ını uçtan uca doğrulamanın yeni, tekrar kullanılabilir bir yolu
  keşfedildi/kullanıldı -- `~/.m2`'de zaten cache'lenmiş bir `postgres:16-alpine` Docker
  image'ı ile, gerçek dev/prod portlarından TAMAMEN farklı bir portta (bu Faz'da 5555),
  ATILABİLİR (disposable) bir Postgres container'ı ayağa kaldırılıp `mvn -o flyway:migrate`
  bu container'a karşı çalıştırıldı -- projenin TÜM migration geçmişi (bu Faz'da V1..V431)
  sıfırdan, gerçek Flyway ile (kod yolu prod'da kullanılanla BİREBİR aynı) uygulanabiliyor,
  sonuç gerçek SQL sorgularıyla incelenip, `flyway:migrate`'in ikinci bir çalıştırmasıyla
  idempotency de doğrulanabiliyor. İş bitince `docker rm -f` ile container TAMAMEN
  siliniyor, gerçek dev DB'ye (`learning`, port 5433) hiçbir zaman dokunulmuyor. Yeni bir
  migration'ın (özellikle veri migration'larının) gerçek etkisini görmek gerektiğinde bu
  yöntem, gerçek dev DB'yi geçici olarak bozma riskine girmeden kullanılabilir.
- **EKLEME (Faz 149, undoing-changes quiz'i, Faz 143'teki disposable-DB yöntemine
  gotcha): `mvn -o flyway:migrate`'in `-Dflyway.locations=classpath:db/migration`'ı,
  `src/main/resources/db/migration`'ı DEĞİL, `target/classes/db/migration`'ı (Maven'in
  derlenmiş kaynak çıktısı) tarar.** Bu Faz'da yeni yazılan iki migration dosyası
  (`undoing-changes/V471`/`V472`) `src/main/resources`'a eklendikten hemen sonra
  disposable container'a karşı `mvn -o flyway:migrate` çalıştırıldığında migration'lar
  SESSİZCE atlandı (`Current version: 470`, hata YOK) -- `target/classes` daha önceki bir
  build'den kalma, henüz senkronize edilmemişti. `cp -r src/main/resources/* target/classes/`
  ile senkronize edildikten SONRA aynı komut V471/V472'yi doğru şekilde uyguladı. Bu, Faz
  140'taki `javac`/`java -cp` workaround'unda ZATEN elle yapılan resource-kopyalama adımının
  (`cp -r src/main/resources/* $SCRATCH/classes/`) `mvn -o flyway:migrate` için de AYRICA
  gerekli olduğu anlamına geliyor -- iki workaround birbirinden BAĞIMSIZ, `javac`
  çalıştırması `target/classes`'a yazmaz. Yeni bir migration dosyası eklendikten sonra
  Faz 143'teki disposable-DB yöntemi kullanılacaksa, `mvn -o flyway:migrate`'ten ÖNCE
  `target/classes`'ın güncel olduğu (ya taze bir `cp -r` ile ya da başarılı bir
  `mvn -o compile`/`test-compile` ile) doğrulanmalı, aksi halde "migration bulunamadı"
  değil, DAHA SİNSİ bir "migration sessizce atlandı" sonucu alınır.
- **KRİTİK, GÜNCEL BİR BUL (Faz 151, `question-generation-enum-test.json`'ın ilk
  gerçek `string` topic'i çalıştırması): bu sandbox'ta kurulu n8n sürümünde
  (`docker.n8n.io/n8nio/n8n:latest`, bu Faz'da tespit edilen sürüm 2.35.3),
  `AI Judge` node'unun kullandığı `this.helpers.httpRequestWithAuthentication`
  Code Node API'si ARTIK DESTEKLENMİYOR -- her çağrı anında (ağa hiç
  çıkmadan) `"The function \"helpers.httpRequestWithAuthentication\" is not
  supported in the Code Node"` hatasıyla senkron olarak başarısız oluyor.**
  Bu, `AI Judge` node'unun kendi try/catch'i tarafından REJECT-eşdeğeri olarak
  yakalanıyor (tasarım gereği doğru davranış -- ASLA belirsiz/başarısız bir
  judge çağrısında otomatik APPROVE etmiyor), bu yüzden pipeline'ın geri kalanı
  (submission, Post-Ingest Status Decision) hatasız çalışmaya devam ediyor ama
  **`judgeApproved` her zaman 0 çıkıyor, dolayısıyla `autoPublished` de her
  zaman 0** -- yani şu anki n8n sürümünde bu workflow ASLA otomatik publish
  ÜRETEMEZ, yalnızca `PENDING_REVIEW` sorular üretebilir. Gerçek bir OpenAI
  entegrasyon/versiyon hatası olduğu, `Generate Batch`'in gerçek yanıt süresiyle
  (16621ms, gerçek bir tamamlama çağrısıyla tutarlı) `AI Judge`'ın 18 kalem
  için toplam yalnızca 35ms sürmesi (18 gerçek OpenAI çağrısı için İMKANSIZ
  ölçüde hızlı, ağa hiç çıkılmadığının kanıtı) karşılaştırılarak sayısal olarak
  doğrulandı. **Kök neden, `Generate Batch`'in kullandığı
  `this.helpers.httpRequest(...)` (kimlik doğrulamasını n8n'in dahili
  credential mekanizmasıyla `authentication: "predefinedCredentialType"`
  parametresiyle KENDİSİ hallediyor) ile `AI Judge`'ın kullandığı
  `this.helpers.httpRequestWithAuthentication.call(this, "openAiApi", ...)`
  (kimlik bilgisini Code Node içinden AÇIKÇA enjekte etmeye çalışan farklı bir
  API) arasındaki farktır** -- ilki hâlâ destekleniyor, ikincisi n8n'in Code
  Node sandbox'ından (muhtemelen bir n8n 2.x kırıcı değişikliği, workflow'un
  yazıldığı sürümden SONRA) kaldırılmış. **Düzeltme bu Faz'da YAPILMADI**
  (kullanıcının açık talimatıyla: yalnızca `Topic Selection` düğümüne
  dokunulmasına izin verildi, `AI Judge`'ın kendisi bu görevin kapsamı
  dışındaydı) -- gelecekte gerçek auto-publish gerekiyorsa, `AI Judge`
  node'unun kimlik doğrulama çağrısı `Generate Batch`'in kullandığı AYNI
  `this.helpers.httpRequest(...)` + `authentication: "predefinedCredentialType"`
  desenine geçirilmeli. Bu Faz'da bu bug nedeniyle 14 gerçek soru (8 EN + 6 TR,
  `string` topic'i, id 318-331) `PENDING_REVIEW`/`source=OPENAI` olarak dev
  DB'de kaldı, hiçbiri publish edilmedi -- kullanıcının Judge sonucunu bypass
  etme/manuel publish etme talimatı olmadığı için BİLİNÇLİ OLARAK
  dokunulmadı. **Ayrıca, aynı çalıştırmada ikinci bir gerçek bulgu:** üretilen
  MULTIPLE_CHOICE sorularının bir kısmı (id 319, 324) tam 2 değil 3 doğru şıkla
  geldi -- `Build Generation Spec`'in prompt'u MULTIPLE_CHOICE için "bir ya da
  daha fazla doğru şık" istiyor (`Validate Output` da yalnızca "≥1" doğruluyor),
  "tam olarak 2" kısıtı workflow'un KENDİSİNE hiç yazılı değil (bu, önceki Git
  kursu sorularında Claude'un kendi kararıyla uyguladığı bir kural, n8n
  pipeline'ının kodlanmış bir gereksinimi DEĞİL) -- gelecekte "tam olarak 2"
  gerekiyorsa bu, `Build Generation Spec`'in prompt'una VE `Validate Output`'un
  doğrulamasına AÇIKÇA eklenmesi gereken bir değişikliktir, şu an ikisinde de
  yok.
- **GÜNCELLEME (Faz 152, Faz 151'in düzeltmesi): `AI Judge` node'u, tek bir Code
  node yerine 5 node'a bölünerek DÜZELTİLDİ ve gerçek bir OpenAI çağrısıyla
  DOĞRULANDI -- bu, projenin n8n Code Node sandbox kısıtı için genel, tekrar
  kullanılabilir bir çözüm deseni oluşturuyor.** Kök neden tam olarak izole
  edildi: n8n'in JS Task Runner'ı (`@n8n/task-runner`'ın `runner-types.js`
  dosyası, `docker exec n8n sh -c "cat .../runner-types.js"` ile okunarak
  doğrulandı) Code node'lara yalnızca sabit, kısa bir `EXPOSED_RPC_METHODS`
  listesi sunuyor (`helpers.httpRequest`, `helpers.request`, birkaç binary-data
  yardımcısı) -- `helpers.httpRequestWithAuthentication` (ve
  `requestWithAuthenticationPaginated`, `getSSHClient` gibi bir dizi başka
  yardımcı) `UNSUPPORTED_HELPER_FUNCTIONS` listesinde AÇIKÇA yer alıyor ve
  çağrıldığı an (ağa hiç çıkmadan) senkron bir `UnsupportedFunctionError`
  fırlatıyor. Bu, Code node'ların bir credential'ı KENDİ JS'lerinden asla
  KULLANAMAYACAĞI anlamına geliyor -- `this.getCredentials(...)` bile
  `EXPOSED_RPC_METHODS`'ta YOK. **Tek güvenli/desteklenen çözüm: kimlik
  doğrulaması gereken HTTP çağrısını, `Generate Batch`'in zaten kullandığı
  AYNI deseni (`n8n-nodes-base.httpRequest` node tipi,
  `authentication: "predefinedCredentialType"`, `nodeCredentialType: "openAiApi"`,
  `credentials` alanında AYNI credential id) kullanan GERÇEK bir HTTP Request
  node'una taşımak** -- bu node tipi Code node sandbox'ından TAMAMEN ayrı
  çalışıyor, kısıt ona hiç uygulanmıyor. Tek bir Code node'un yerine 5 node
  geldi: `AI Judge Prep` (Code -- uygunluk kontrolü + ders içeriği fetch +
  prompt oluşturma, kimlik bilgisi YOK) → `AI Judge Route` (IF -- yalnızca
  `needsJudgeCall===true` olan kalemleri OpenAI çağrısına yönlendiriyor, uygun
  olmayanlar sıfır maliyetle atlanıyor, ORİJİNAL tasarımdaki "boşa OpenAI
  çağrısı yok" davranışı BİREBİR korundu) → `AI Judge Call OpenAI` (gerçek HTTP
  Request node, `Generate Batch` ile AYNI credential/authentication deseni) →
  `AI Judge Parse Verdict` (Code -- yanıtı ayrıştırır, HER TÜRLÜ hata/eksik
  alan/beklenmeyen verdict AYNI REJECT-eşdeğeri fail-safe'e düşer, hiçbir
  zaman varsayılan APPROVE YOK; HTTP node `item.json`'ı ham API yanıtıyla
  DEĞİŞTİRDİĞİ için orijinal soru alanları `$("AI Judge Prep").itemMatching(i)`
  ile geri kazanılıyor -- `Parse Generated Questions`'ın `Build Generation
  Spec`'e karşı ZATEN kullandığı AYNI desen, Faz 147'de bulunmuş) →
  `AI Judge Merge` (Merge node, `mode: "append"`, IF'in TRUE/FALSE iki dalını
  tek akışa geri birleştiriyor, `Submit Valid Questions`'a value akıyor).
  **Gerçek bir OpenAI çağrısıyla doğrulandı:** `string` topic'i için ikinci
  gerçek çalıştırmada `AI Judge Call OpenAI`, yönlendirilen 10 kalem için
  toplam 2526ms sürdü (18 kalemin tamamı için önceki bozuk sürümün 35ms'siyle
  TEZAT, 10 gerçek API round-trip'i için makul bir süre) -- gerçek verdict'ler
  üretti (4 APPROVE, 6 REJECT), `Post-Ingest Status Decision` bu 4 APPROVE'u
  gerçekten auto-publish etti (dev DB'de `status='PUBLISHED'`, gerçek
  `reviewed_by='n8n-ai-judge'`, gerçek FARKLI `reviewed_at` zaman damgaları --
  hiçbiri elle/bypass ile YAZILMADI, tamamen `POST .../auto-publish`
  endpoint'inin kendi davranışı), 6 REJECT `PENDING_REVIEW`'da kaldı (`reviewed_by`
  NULL). **Bu Faz'da OpenAI credential'ına (`sfmqlEISp7fEml6j`, "OpenAI
  account") HİÇ dokunulmadı** -- ne yeniden oluşturuldu, ne decrypt edildi, ne
  yazdırıldı; yalnızca `Generate Batch`'in zaten kullandığı REFERANS (id+name)
  yeni node'a KOPYALANDI. Anahtar hiçbir zaman bu Code node'ların içine
  girmedi. **Gelecekte benzer bir "Code node içinden kimlik doğrulamalı bir
  API çağırma" ihtiyacı doğarsa, bu 5-node deseni (Prep → Route (IF) → gerçek
  HTTP node → Parse → Merge) doğrudan tekrar kullanılabilir** -- Code node'un
  KENDİSİNDEN kimlik doğrulamalı bir istek atmaya ASLA çalışılmamalı, bu
  n8n sürümünde (2.35.3) yapısal olarak imkansız.
- **BİLİNÇLİ bir sınır (Faz 143, `scripts/export_approved_questions.py`): bu proje şu an
  tekrar-promote'a karşı YAPISAL bir koruma (örn. `promoted_at` kolonu, `question` üzerinde
  bir unique constraint) SAĞLAMIYOR** -- Flyway'in kendi `flyway_schema_history`'si yalnızca
  AYNI migration dosyasının iki kez UYGULANMASINI engelliyor, FARKLI bir migration'ın AYNI
  mantıksal soruyu bir daha promote etmesini DEĞİL. Bu, kullanıcının bilinçli kararıyla
  ERTELENDİ (bkz. plan modu çıktısı, "Adjustment 2") -- tekrar-promote önleme şu an bir
  SÜREÇ sorumluluğu: her promotion migration'ının başlık yorumu tam olarak hangi dev
  question id'lerinin dahil edildiğini kaydediyor, yeni bir promotion migration'ı
  yazmadan önce `db/migration/question-promotion/*.sql` başlıkları bu id'ler için
  grep'lenmeli. Promotion sıklaşırsa (tek seferlik ~138 sorudan çok daha fazla batch)
  bir `promoted_at` kolonu eklemek doğal bir sonraki adım olur, ama şu an İMPLEMENTE
  EDİLMEDİ.
- **GÜNCELLEME (Faz 145, n8n entegrasyonu): `docker.n8n.io/n8nio/n8n:latest` yerel
  olarak ZATEN cache'liydi, bu yüzden n8n workflow'ları bu sandbox'ta simülasyon
  değil GERÇEK bir n8n instance'ıyla test edilebiliyor.** Tekrar kullanılabilir
  komut dizisi: (1) `docker volume create <ad>` -- KALICI bir volume, aksi halde
  her `docker run --rm` n8n'in TÜM DB migration geçmişini (~150+ migration) sıfırdan
  çalıştırıyor, ki bu hem yavaş hem gereksiz; (2) `n8n import:workflow --input=...`
  ile workflow JSON'ı içe aktar -- JSON'ın üst seviyede bir `"id"` alanı OLMALI
  (yoksa `SQLITE_CONSTRAINT: NOT NULL constraint failed: workflow_entity.id` ile
  patlıyor, n8n export'unun ürettiği dosyalarda bu alan zaten var ama elle
  yazılan bir workflow'da unutulması kolay); (3) `n8n execute --id=<id>` ile
  ÇALIŞTIR -- `--file` bayrağı DEPRECATED ama hâlâ var, `--id` tercih edilmeli;
  (4) workflow ifadelerinde `$env` kullanmak için (API key gibi sırları workflow
  dosyasına YAZMADAN ortam değişkeninden okumak üzere) `-e
  N8N_BLOCK_ENV_ACCESS_IN_NODE=false` GEREKLİ -- varsayılan olarak n8n bunu
  engelliyor (`"error": "access to env vars denied"`); (5) n8n container'ından
  host makinedeki bir sürece (bu projenin durumunda host'ta `java -cp ...`
  ile çalışan Spring Boot uygulaması) erişmek için `http://host.docker.internal:
  <port>` kullanılabiliyor (bu Docker Desktop kurulumunda doğrulandı). Bitince
  `docker volume rm <ad>` ile TAMAMEN temizlenebiliyor, gerçek dev DB'ye hiçbir
  kalıntı bırakmıyor (n8n kendi ayrı SQLite DB'sinde çalışıyor, projenin Postgres'ine
  hiç dokunmuyor).
- **Microservices kategorisindeki `event-driven-kafka` konusu (Faz 92), kategorinin
  diğer topic'lerinden FARKLI bir doğrulama önkoşulu getiriyor:** eureka-server,
  api-gateway, config-server gibi önceki topic'ler yalnızca "bir Spring Boot
  uygulaması daha" gerektiriyordu (Maven Central engeli aşılınca kullanıcının kendi
  ortamında doğrudan çalıştırılabilir); `event-driven-kafka` ise GERÇEK bir Kafka
  broker'ının (örn. Docker ile) ayrıca ayakta olmasını gerektiriyor -- kullanıcı bu
  topic'i kendi ortamında doğrularken önce bir Kafka broker başlatmalı, aksi halde
  order-service/inventory-service `spring.kafka.bootstrap-servers`'a bağlanamaz.
- **`{{ÖrnekDosyası.ext}}` embed placeholder'larında ÖRNEK DOSYA ADI tire (`-`)
  İÇEREMEZ (Faz 94'te `observability` konusu yazılırken gerçek bir hatayla
  keşfedildi):** `MarkdownService.EXAMPLE_PLACEHOLDER` regex'i (`\{\{(\w+)\.(\w+)}}`,
  bkz. CLAUDE.md'nin embed sistemi maddesi) hem dosya adı hem uzantı için `\w+`
  kullanıyor -- bu yalnızca harf/rakam/alt çizgiyi kapsar, tireyi KAPSAMAZ. İlk
  yazılan `logback-spring.xml` dosyası bu yüzden hiç eşleşmeyip sayfada düz metin
  olarak `{{logback-spring.xml}}` görünecekti; `LogbackJsonConfig.xml`'e yeniden
  adlandırılarak düzeltildi (proje genelinde başka hiçbir örnek dosyasında tire
  olmadığı ayrıca doğrulandı). Yeni bir örnek dosyası yaratırken PascalCase/camelCase
  kullan, tire İÇEREN bir dosya adı YAZMA -- bu kısıt gerçek bir Postgres/Flyway
  çalıştırmasıyla değil, yalnızca içeriği gözle/grep'le inceleyerek fark edildi,
  bu yüzden gelecekte de dikkatli kontrol gerekiyor.
- **GÜNCELLEME (Faz 146, büyük ölçekli soru üretim workflow'u): `n8n execute --id=...`
  CLI komutu, workflow JSON'undaki üst seviye `"pinData"` alanını HİÇ dikkate almıyor
  -- yalnızca n8n'in kendi editör UI'ı pinData'yı onurlandırıyor gibi görünüyor.**
  Bu, gerçek bir denemeyle keşfedildi: bir HTTP Request düğümüne (`Generate Batch`,
  Anthropic Messages API'ye POST) pinData ile sahte bir yanıt bağlanmıştı, ama
  `n8n execute` çalıştırıldığında düğüm GERÇEKTEN `api.anthropic.com`'a bağlandı ve
  (bu sandbox'ta kullanılabilir bir `ANTHROPIC_API_KEY` olmadığı için) gerçek bir
  `401 invalid x-api-key` yanıtıyla başarısız oldu -- pinData sessizce YOK SAYILDI.
  **Sonuç:** CLI-only (UI'sız) bir n8n testinde, henüz kimlik bilgisi/API erişimi
  olmayan bir dış çağrı düğümünü test etmek gerekiyorsa, pinData'ya GÜVENME --
  bunun yerine o düğümü GEÇİCİ OLARAK, gerçek dış API'nin yanıt ŞEKLİYLE birebir
  aynı çıktıyı üreten bir Code node'a çevir (Faz 145'in `Build Test Questions`
  düğününde zaten kullanılan teknikle aynı) -- böylece downstream düğümlerin TAMAMI
  değişmeden, gerçekten çalışır durumda kalır. **İkinci, ilişkili bir hata da bu
  Faz'da keşfedildi:** bu şekilde bir Code node'u "dış API stand-in'i" yaparken,
  düğümün döndürdüğü `json` nesnesi INPUT item'ın kendi alanlarını (ör.
  `topicSlug`/`language`) AÇIKÇA taşımazsa (`{ json: { ...yeni alanlar } }` gibi
  input'u tamamen değiştiren bir dönüş), sonraki düğümler bu alanları `undefined`
  olarak görür -- gerçek bir örnekte bu, `Duplicate Check` aşamasında bozuk bir URL
  yüzünden gerçek bir `404` hatasına yol açtı (kök neden: `topicSlug`/`language`
  `Generate Batch` stand-in'inin çıktısında hiç yoktu). Yeni bir stand-in/mock Code
  node yazarken input item'ın ileride gereken tüm alanlarını çıktıya AÇIKÇA
  kopyalamak gerekiyor, `...item.json` ile yaymak yerine yeni bir nesne kurmak bu
  hatayı kolayca gizliyor.
- **GÜNCELLEME (Faz 148, EN->TR çeviri workflow'u): bu n8n Docker image'ında,
  OpenAI'dan gelen Türkçe (non-ASCII/diyakritikli) metin, HTTP transport
  katmanında ARA SIRA ve DETERMİNİSTİK şekilde bozuluyor -- UTF-8 baytları
  CJK (Çince/Japonca/Korece) aralığı karakterlere dönüşüyor (`"için"` ->
  `"i莽in"`, `"döner"` -> `"d枚ner"`).** Bu, aynı EN sorunun çevirisi 4 AYRI
  gerçek OpenAI çağrısında da (dördünde de bayt-bayt AYNI bozuk çıktı) tekrar
  üretildi -- rastgele bir gürültü DEĞİL, bu spesifik metin/yanıt için
  deterministik bir hata. Kaynağı uygulama kodu (workflow JS'i) DEĞİL, n8n'in
  kendi HTTP client/response-decode katmanı gibi görünüyor -- Code node'daki
  JS'te hiçbir encoding/decoding işlemi YOK, `this.helpers.httpRequest(...)`
  çağrısının `json: true` seçeneğiyle otomatik ayrıştırdığı yanıt zaten bozuk
  geliyor. Kök neden bu sandbox'tan tam olarak izole edilip DÜZELTİLEMEDİ
  (n8n'in kendi bağımlılık zincirinde bir yerde) -- bunun yerine bir
  UYGULAMA-SEVİYESİ SAVUNMA eklendi: `Validate Translation` aşamasına, Türkçe
  metinde ASLA olmaması gereken CJK Unified Ideographs aralığını
  (`/[一-鿿]/`) arayan ucuz bir regex kontrolü -- bu, 4 çalıştırmanın
  4'ünde de bozuk çeviriyi submit edilmeden ÖNCE yakalayıp elemeyi başardı,
  hiçbir bozuk satır dev DB'ye hiç yazılmadı. **Gelecekte n8n üzerinden
  ÇOK-BAYTLI/diyakritikli dil (Türkçe, ama aynı sınıf başka diller de) üreten
  her workflow'a bu CJK-koruma kontrolünün (ya da dile göre uyarlanmış bir
  benzerinin) eklenmesi ÖNERİLİR** -- bu, tek bir soruya özel bir tuhaflık
  değil, gözlemlenen davranış transport katmanında olduğu için teorik olarak
  herhangi bir çok-baytlı yanıtı etkileyebilir.
- **Promotion-style bir migration'ın (`WITH ... RETURNING` + `NOT EXISTS`
  idempotency deseni, bkz. `question-promotion/V431`, `git-fundamentals/V467`/
  `V468`) fallback (satır henüz yoksa oluşturma) dalındaki içerik, migration
  YAZILIRKEN mevcut olan ham veriyi değil, o verinin GEÇMESİ GEREKEN NİHAİ
  durumunu (ör. `status='PUBLISHED'`, gerçek `reviewed_by`/`reviewed_at`)
  yansıtmalı -- git-fundamentals'ın Türkçe quiz sorularını linkleyen `V468`
  yazılırken gerçek bir hatayla keşfedildi:** ilk yazılan `V468`, sorular
  henüz PUBLISH edilmeden ÖNCE (`status='PENDING_REVIEW'` iken) export edilen
  içerikle üretilmişti. Bu hata, migration'ı ÜRETEN dev DB'ye (`learning`)
  karşı görünmedi -- o DB'de sorular zaten canlı ingestion ile mevcuttu, migration'ın
  `NOT EXISTS` kontrolü var olan satırları buldu ve fallback dalını hiç
  ÇALIŞTIRMADAN "başarılı" oldu. Sorun yalnızca `mvn test`'in ayrı, temiz
  `learning_test` veritabanında migration'ı SIFIRDAN çalıştırmasıyla ortaya
  çıktı: fallback dalı bu kez GERÇEKTEN çalıştı ve 10 `PENDING_REVIEW` satırı
  oluşturdu, bu da `QuestionReviewControllerTest.noPendingQuestionsShowsEmptyState`'i
  beklenmedik şekilde bozdu. **Kalıcı ders:** (1) bir promotion migration'ı
  yazmadan önce içerik, migration'ın temsil etmesi istenen nihai durumdan
  (review/publish TAMAMLANDIKTAN) SONRA export edilmeli; (2) böyle bir
  migration'ı yalnızca onu ÜRETEN dev DB'ye karşı test etmek YETERSİZ --
  dev DB'de zaten var olan satırlar `NOT EXISTS` kontrolüyle eşleşip fallback
  dalını hiç çalıştırmadan migration'ı "başarılı" gösterebilir; gerçek
  doğrulama MUTLAKA (a) tamamen boş/disposable bir Postgres container'ında
  (bkz. Faz 143'teki teknik) VE (b) `mvn test`'in kullandığı ayrı
  `learning_test` veritabanında da yapılmalı, yalnızca dev DB'ye bakmak
  yetmez.
