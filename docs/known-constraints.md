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
