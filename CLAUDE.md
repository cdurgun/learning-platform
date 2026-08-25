# Proje Bağlamı: Learning Platform

Bu, Türkçe/İngilizce içerik sunan bir Java öğrenim sitesi. Aşağıdaki bağlamı okuyup
projeye bu kurallara **birebir uyarak** devam et.

**Bu dosya Faz 76'da kısaltıldı.** İki büyük bölüm ayrı `docs/` dosyalarına
taşındı — hiçbir bilgi silinmedi: `docs/phase-log.md` (Faz 1-75'in tam, ayrıntılı
anlatımı) ve `docs/known-constraints.md` (tüm bilinen kısıtların tam kronolojik
geçmişi). Bu iki dosya otomatik yüklenmez — ilgili göreve göre `grep` ile aranmalı
(bkz. aşağıdaki "Faz Geçmişi ve Kararlar" ve "Bilinen Kısıtlar" bölümleri).

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
  `/tr`); çıplak `/` bir negotiator, eski `/topics/{slug}?lang=..` URL'leri ise 301 ile
  yeni adrese yönlendiriliyor (SEO gerekçesi: hreflang ile bağlanabilen, bağımsız
  indexlenebilir URL'ler — bkz. Faz 64 notu). Yeni bir sayfa/route eklerken dili HER
  ZAMAN `{lang:en|tr}` regex-kısıtlı bir path variable olarak ekle, query parametresi
  olarak DEĞİL. **Negotiator'ın (`/`) varsayılan dili Faz 69'dan itibaren DAİMA
  İngilizce'dir, `Accept-Language` başlığı BİLİNÇLİ OLARAK dikkate ALINMAZ** — bkz. Faz
  69 notu (Faz 64'teki ilk tasarım tarayıcı diline bakıyordu, kullanıcı bunun kendi
  ziyaretlerinde beklenmedik şekilde `/tr`'ye yönlendirdiğini fark edip DEĞİŞTİRİLMESİNİ
  istedi — bu artık kalıcı, bilinçli bir ürün kararı, yanlışlıkla "eski hâline"
  DÖNÜLMEMELİ).
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
- **Sidebar, Faz 68'den itibaren `lg` altında Bootstrap'in responsive `offcanvas-lg`
  bileşenidir** (`fragments/layout.html :: sidebar` — `<aside id="sidebarOffcanvas"
  class="offcanvas-lg offcanvas-start ...">`), navbar'da `d-lg-none` bir hamburger
  butonu (`data-bs-toggle="offcanvas" data-bs-target="#sidebarOffcanvas"`) bunu açar.
  `offcanvas-body`'nin `d-block` sınıfı ZORUNLU (Bootstrap'in kendi `.offcanvas-lg
  .offcanvas-body` kuralı lg+ ekranda `display:flex` verir, `d-block`'un `!important`'ı
  bunu geçersiz kılıp orijinal blok düzenini korur). Navbar `sticky-top`. Sağdaki TOC
  (`topic.html`, `.toc-sticky`) navbar'ın altına gizlenmesin diye `top: 4.25rem`
  kullanır VE `align-self: flex-start` İÇERMELİDİR — bu olmadan Bootstrap `.row`'un
  varsayılan `align-items: stretch`'i TOC'u `main` sütunuyla aynı yüksekliğe gerer ve
  `position: sticky` hiçbir şekilde çalışmaz (bkz. Faz 68 notu, Playwright ile GERÇEKTEN
  doğrulanmış bir hata). Bu sayfalara benzer yeni bir sticky/offcanvas eklenirse aynı
  desen (`align-self: flex-start` + gerçek navbar yüksekliğine göre `top` offset'i)
  tekrarlanmalı.
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
- **`ai-development-tools` kategorisindeki (Claude Code, ileride Cursor/GitHub
  Copilot vb.) derslerde, CLI/araç davranışına dair sürüme bağımlı HİÇBİR iddia
  kullanıcının kendi gerçek terminal oturumunda doğrulanmadan kesin gerçek gibi
  yazılmaz (Faz 81/82'de kullanıcının bağlayıcı şartı).** Doğrulama hibrit
  yöntemle yapılır: resmi dokümantasyon (WebSearch/WebFetch) ana kaynak,
  versiyon/hesaba duyarlı ya da belirsiz noktalar kullanıcının kendi CLI
  oturumunda canlı test edilir/kullanıcıdan istenir. Derste kesinlik iddia
  edilen her ekran metni/komut davranışı ya gerçek bir kullanıcı gözlemine
  (ekran görüntüsü, terminal çıktısı, `--help` metni) ya da resmi dokümana
  atıfla yazılır; ikisi de yoksa bir `⚠️ Warning` blockquote'uyla açıkça hedge
  edilir ve gözlemlenen sürüm/tarih/hesap türü belirtilir (bkz. "Faz 81",
  "Faz 82" — gerçek session ID gibi kullanıcıya özel/hassas bilgiler de asla
  derste yayınlanmaz, `<placeholder>` ile değiştirilir).
- **Quiz sistemi Faz 87'de genel bir "soru havuzu" (Question Pool) mimarisine
  yeniden tasarlandı — eski "bir soru = doğrudan bir quiz'e ait" varsayımı
  kalıcı olarak terk edildi.** Eski `QuizQuestion` → `Question`'a yeniden
  adlandırıldı: artık topic+language'e bağlı ama hiçbir `Quiz`'e bağlı OLMAK
  ZORUNDA olmayan, `type` (`QuestionType`: SINGLE_CHOICE/MULTIPLE_CHOICE/
  CODE_OUTPUT), `difficulty` (mevcut `Difficulty` enum'u yeniden kullanılıyor,
  yeni bir enum YARATILMADI), `status` (`QuestionStatus`:
  DRAFT/PENDING_REVIEW/PUBLISHED/REJECTED) ve `source` (`QuestionSource`:
  MANUAL/AI) taşıyan genel bir havuz sorusu. Eski `QuizOption` →
  `QuestionOption`'a yeniden adlandırıldı (anlamı değişmedi). `QuizQuestion`
  ADI KORUNDU ama anlamı tamamen değişti — artık bir soru DEĞİL, yeni `Quiz`
  entity'si (bir topic+language'e bağlı, editoryal olarak KÜRE edilmiş/curated,
  `slug`+`title`+`passThreshold` taşıyan **sabit quiz**) ile `Question`
  arasında bir İLİŞKİ/join entity'si — hangi sorunun hangi quiz'de hangi
  sırada (`position`) yer aldığını tutar. **Sabit quiz** (`QuizService`,
  `/{lang}/topics/{topicSlug}/quiz/{quizSlug}/submit` — artık genel, eskiden
  yalnızca `enum`'a hardcode'du) ile **Practice modu** (`PracticeService`,
  `/{lang}/practice`, topic/language/difficulty/type filtreli RASTGELE
  seçim) böylece aynı `Question` havuzunu iki farklı şekilde tüketiyor —
  Practice hiçbir `Quiz` satırına ihtiyaç duymuyor, yalnızca
  `status = 'PUBLISHED'` sorular arasından çekiyor (bu filtre sorgunun
  KENDİSİNE sabit yazılı, hiçbir çağıran taraf override edemez). Puanlama
  (`QuestionScorer`) her iki modda AYNI kuralı kullanır: seçilen şık id
  kümesi doğru şık id kümesiyle BİREBİR eşleşmeli (MULTIPLE_CHOICE kısmi
  doğru cevabı KABUL ETMEZ). **AI/n8n ingestion** (`POST
  /api/internal/questions/ingest`, `QuizIngestApiKeyInterceptor` ile
  `X-Api-Key` korumalı — anahtar `quiz.ingest.api-key`/`QUIZ_INGEST_API_KEY`
  env'den, YAPILANDIRILMAMIŞSA istekler REDDEDİLİR/fail-closed) her zaman
  `status = PENDING_REVIEW` + `source = AI` ile kaydeder — istek gövdesinde
  (`QuestionIngestRequest`) bu iki alan BİLİNÇLİ OLARAK YOK, yani "sunucu
  ezer" kuralı bir runtime kontrolüne değil DTO tasarımına dayanıyor; tip
  başına doğru-şık-sayısı doğrulaması (SINGLE_CHOICE/CODE_OUTPUT tam bir,
  MULTIPLE_CHOICE bir veya daha fazla) burada yapılır. Review için ayrı bir
  admin arayüzü YOK (bilinçli v1 sadeleştirmesi) — inceleme,
  `status`/`reviewed_by`/`reviewed_at` kolonları üzerinden doğrudan DB
  `UPDATE`'iyle yapılır. **Şema (`V287`-`V293`, core/enum alt klasörlerinde):**
  eski `quiz_question`/`quiz_option` tabloları yerinde `question`/
  `question_option`'a yeniden adlandırılıp yeni kolonlar eklendi; yeni
  `quiz`+`quiz_question_link` tabloları kuruldu; eski enum quiz verisi bu
  modele taşındı (`sort_order` → `quiz_question_link.position`, sonra
  `question.sort_order` kolonu düşürüldü); GLOBAL "soru başına en fazla bir
  doğru şık" kısıtı (`uq_quiz_option_one_correct_per_question`, V259)
  kaldırılıp `idx_question_pool` (`topic_id, language, type, difficulty,
  status`) kompozit index'iyle değiştirildi — MULTIPLE_CHOICE artık DB
  seviyesinde ENGELLENMİYOR, tip-farkındalı doğrulama servis/ingestion
  katmanına taşındı. `quiz_question_link.question_id` KASITLI OLARAK
  `ON DELETE RESTRICT` — canlı bir sabit quiz'in parçası olan bir soru
  hard-delete edilemez, kaldırmak isteyen `question.status = REJECTED`
  yapmalı. `Quiz.passThreshold` BİLİNÇLİ OLARAK `BigDecimal` (DB
  `NUMERIC(3,2)`) — `Double`/`Float` kullanılırsa Hibernate'in
  `ddl-auto: validate` şema doğrulaması `float(53)` bekleyip gerçek
  `NUMERIC` kolonuyla çakışır; NUMERIC/DECIMAL kolonlu her yeni alanda bu
  eşleşmeye dikkat et. CODE_OUTPUT sorular `topic.html`'de `codeSnippet`/
  `codeLanguage` alanları üzerinden MEVCUT highlight.js entegrasyonuyla
  (`hljs.highlightAll()`, ayrı bir JS değişikliği GEREKMEDİ) render edilir.
  Ayrıntılı uygulama akışı için `docs/phase-log.md`'de "Faz 87"yi grep'le.
- **Faz 88'de GERÇEK bir regresyon bulunup düzeltildi ve grouped `answers`
  sözleşmesi uçtan uca (gerçek tarayıcıda) doğrulandı — bkz. `docs/phase-log.md`
  "Faz 88".** `static/js/quiz.js`, Faz 87'de `QuizSubmitRequest`/`QuizAnswer`
  gruplu sözleşmeye geçildiğinde AYNI FAZDA güncellendiği RAPORLANMIŞTI ama
  gerçekte hiç değiştirilmemişti — kullanıcının kendi tarayıcısında GERÇEK bir
  `400 Bad Request` (`"answers is required"`) ile ortaya çıktı, hâlâ eski düz
  `{selectedOptionIds: [...]}` gövdesini gönderiyordu; `renderResults()` de
  hâlâ artık var olmayan tekil `selectedOptionId`/`correctOptionId` alanlarını
  okuyordu. İkisi de düzeltildi (`collectAnswers()` her soru için ayrı
  `{questionId, selectedOptionIds}` topluyor, backend `QuizService`/`QuizAnswer`
  DOKUNULMADI). Ayrıca `topic.html`'deki şık `<input>`'u da (`MULTIPLE_CHOICE`
  hâlâ radio render ediyordu, tarayıcı seviyesinde birden fazla şık SEÇİLEMEZDİ)
  `th:type="${q.type()...} ? 'checkbox' : 'radio'"` ile düzeltildi (`quiz.js`
  zaten generic `:checked` sorgusu kullandığı için başka bir JS değişikliği
  GEREKMEDİ). **Doğrulama, kullanıcının kendi ortamında GERÇEK bir tarayıcıda
  yapıldı:** sabit enum quiz'i (5 SINGLE_CHOICE soru) grouped `answers`
  sözleşmesiyle sorunsuz submit edildi; AI ingestion endpoint'i (`POST
  /api/internal/questions/ingest`) gerçek bir `curl` çağrısıyla test edildi
  (`201`, `PENDING_REVIEW`/`AI` döndü), sonuç bir `MULTIPLE_CHOICE` soru
  manuel olarak `PUBLISHED`'a çekilip `quiz_question_link`'e geçici (migration
  DEĞİL, elle SQL) eklendi, tarayıcıda checkbox olarak render edildiği,
  birden fazla şıkkın aynı anda seçilebildiği ve iki doğru şık seçilince
  quiz'in **6/6 — Passed** sonucu döndürdüğü doğrulandı. Kullanıcının kendi
  ortamında `mvn clean test`: **43 test, 0 hata, 0 başarısızlık, BUILD
  SUCCESS.** Bu sandbox'ta `mvn -o test` hâlâ Lombok'un offline modda hiç
  annotation processing yapmaması yüzünden tamamlanamıyor (bkz.
  `docs/known-constraints.md`) — kod defektiyle İLGİSİZ, kullanıcının kendi
  ortamı asıl doğrulama kaynağı.
- **Kullanıcı kimlik doğrulaması Faz 138'de eklendi, opsiyonel bir katman —
  var olan public öğrenim deneyimi (anasayfa, kurs/kategori/konu sayfaları,
  sabit quiz submit) anonim erişime tamamen açık kalır, hiçbir mevcut rotanın
  önüne bir "giriş yap" kapısı KONMADI.** Spring Security, session-based form
  login — JWT/OAuth2 bilinçli olarak kullanılmıyor (sunucu tarafında render
  edilen bir Thymeleaf uygulaması için gereksiz karmaşıklık olurdu). Kullanıcı
  hesabı `User` entity'si (`app_user` tablosu — `user` Postgres'te ayrılmış
  anahtar kelime olduğu için kaçınıldı), şifreler her zaman BCrypt ile encode
  edilir, düz metin asla DB'ye yazılmaz. Login/register/logout rotaları,
  projenin geri kalanıyla AYNI `{lang:en|tr}` path-değişkeni deseninde
  (`/{lang}/login`, `/{lang}/register`, `/{lang}/logout`) — Spring Security
  6.4+'ın varsayılan `PathPatternRequestMatcher`'ı MVC ile aynı `{var:regex}`
  söz dizimini desteklediği için `loginProcessingUrl`/`logoutUrl` de doğrudan
  bu kalıpla verilir, ayrı bir wildcard/regex çözümüne gerek yok. Başarı/hata/
  logout sonrası hangi dile yönlendirileceği isteğin URI'sinin ilk path
  segmentinden okunur (`config/LangPath`, `LangParamLocaleResolver`'daki aynı
  mantığın küçük bir tekrarı). `GlobalModelAttributes`, her sayfaya otomatik
  `currentUserDisplayName` (girişli değilse `null`) enjekte eder — navbar
  (`fragments/layout.html`) bunu TR/EN dil butonlarının HEMEN SOLUNDA
  `[ Sign in ] [ TR ] [ EN ]` / `[ Kullanıcı Adı ] [ Logout ] [ TR ] [ EN ]`
  şeklinde kullanır. Yeni bir gated (yalnızca girişli kullanıcıya açık) sayfa
  eklenirse `SecurityConfig`'teki `authorizeHttpRequests` bloğuna (şu an
  bilinçli olarak `anyRequest().permitAll()`) bir kural eklenmeli — var olan
  hiçbir rota bu değişiklikten etkilenmemeli. **CSRF koruması artık varsayılan
  olarak açık** — gerçek Thymeleaf formları (`th:action`) `${_csrf.token}`
  hidden input'uyla korunmalı (bkz. `login.html`/`register.html`/navbar logout
  formu), ama tarayıcı oturumu olmadan çağrılan anonim JSON POST uç noktaları
  (sabit quiz submit, Practice submit, AI ingestion) `SecurityConfig`'te
  `csrf().ignoringRequestMatchers(...)` ile bilinçli olarak muaf tutuldu — yeni
  bir anonim/oturumsuz POST API eklenirse aynı muafiyet listesine eklenmeli.

## Token ve Bağlam Verimliliği (Faz 75'ten itibaren, kullanıcı+ChatGPT kararı)

Bu proje büyük ve sürekli büyüyor. Gereksiz dosya okuma hem yavaşlatır hem
maliyeti artırır. Kural seti:

- **Her görev için önce tam olarak hangi Course/Category/Topic/özelliğin
  değiştiğini belirle**, yalnızca o işe doğrudan gereken dosyaları oku.
- **Bir konvansiyonu anlamak için tek bir temsili mevcut dosya yeterli** —
  aynı türden (ör. aynı kategori deseni) 5-6 dosyayı art arda okumaya
  gerek yok.
- **İlgisiz kursları/kategorileri/konuları, ilgisiz Markdown/Java/React
  dosyalarını ya da örnekleri `Read` ile İÇERİĞE ÇEKME** — bu, context'i
  gereksiz yere şişirir.
- **İlgisiz kodu refactor etme; kullanıcı açıkça istemedikçe tamamlanmış
  içeriği değiştirme.**
- **İSTİSNA — çapraz referans/tutarlılık doğrulaması hâlâ proje geneline
  bakmalı, ama script ile, `Read` ile değil.** Bir bölümün tırnak içinde
  başka bir bölüme yaptığı atfın gerçek başlıkla birebir eşleştiğini
  doğrulamak (Faz 70/71/72/74'te gerçek hatalar bu şekilde bulundu — bkz.
  ilgili Faz notları) `Read` ile dosya dosya gezmeyi DEĞİL, bir Python/grep
  script'inin tüm `content/*/*.md`'deki H1/H2 başlıklarını toplayıp
  karşılaştırmasını gerektirir — dosyaların TAMAMI değil, script'in ürettiği
  kısa "eşleşmedi" listesi context'e girer. Bu tarama HER ZAMAN serbest ve
  teşvik edilir; yasak olan `Read` ile ilgisiz dosyaların tam içeriğini
  context'e çekmek, script ile yapısal tarama değil.
- Kod örnekleri için zaten geçerli olan kural aşağıdaki "Örnek Yazım
  İlkeleri"nde — burada tekrar edilmiyor, orası tek doğruluk kaynağı.

**ZIP teslimatı (Faz 75'ten itibaren DEĞİŞTİ — kullanıcı kararı):**

- Artık HER ZAMAN tam proje zip'i DEĞİL, **yalnızca o görev için
  oluşturulan/değiştirilen dosyalar** zip'lenir (kullanıcı kendi yerel
  kopyasına bunları üzerine kopyalayıp birleştiriyor — proje Maven/Spring
  olduğu için eksik dosya olmadıkça derlenmeye devam eder).
- Zip kökü **`learning-platform`** olarak kalır (ChatGPT'nin önerdiği
  `java-learning-platform` kullanıcı tarafından reddedildi — gerçek klasör
  adıyla tutarsız olurdu, ayrıca proje artık yalnızca Java değil dört kurs
  içeriyor).
- Orijinal dizin yapısı proje köküne göre korunur (ör.
  `src/main/resources/content/tr/{slug}.md`).
- Değişmemiş dosyalar asla tekrar eklenmez/kopyalanmaz; `target/`,
  `node_modules/`, `.git/`, build çıktıları ve diğer üretilmiş dosyalar
  hariç tutulur.
- **Zip oluşturmadan önce:** (1) bu görev için değişen dosyaların listesini
  çıkar, (2) yalnızca bunların zip'e girdiğini doğrula, (3) zip kökünün
  `learning-platform` olduğunu doğrula, (4) değişmemiş/üretilmiş dosyaların
  dışarıda kaldığını doğrula.
- Tam proje zip'i yalnızca kullanıcı açıkça isterse üretilir.

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
6. **TR ve EN markdown'ların H2 sayısı/sırası artık BİREBİR AYNI OLMAK ZORUNDA
   DEĞİL (Faz 74'ten itibaren, kullanıcı kararı).** Faz 70-73 arası her fazda TR/EN H2
   başlık sayıları programatik olarak eşitlenip doğrulanıyordu; kullanıcı bunun katı bir
   kural OLMAMASI gerektiğini, her dilin kendi başına en özgün/doğal şekilde
   yazılabileceğini belirtti (bkz. Faz 74 notu — `building-an-mcp-server` konusunun
   TR'si önce ChatGPT'nin önerdiği çok daha ayrıntılı, adım adım bir yapıya
   genişletildi, sonra EN aynı yapıyı BİREBİR ÇEVİRİ olarak değil, İngilizce'de doğal
   okunan kendi haliyle yazıldı — ikisi de 16 H2'ye çıktı ama bu bir tesadüf, bir
   zorunluluk değil). Çapraz referans doğrulaması (bir bölümün kendi H1/H2 başlığına
   tırnak içinde birebir atıf yapması) HÂLÂ her dil için AYRI AYRI geçerli ve
   doğrulanmalı — kaldırılan yalnızca "iki dilin başlık SAYISI eşit olmalı" kısmı.

Her konu için ~15-20 ana bölüm + 2 mini proje eki, ~15-17 kod örneği hedeflenir. DB
tarafında desen: `V{n}__{slug}_topic.sql` (iskelet) → `V{n+1}__{slug}_sections_1_to_N.sql`
(ilk yarı örnek metadata'sı) → `V{n+2}__update_{slug}_estimated_minutes.sql` (ara
güncelleme) → `V{n+3}__{slug}_sections_N_to_ek.sql` (ikinci yarı + ekler) →
`V{n+4}__update_{slug}_estimated_minutes.sql` (son güncelleme) →
`V{n+5}__publish_{slug}_english.sql` (EN yayına alma).

## Faz Geçmişi ve Kararlar

**Faz 76'da CLAUDE.md'yi küçültmek için taşındı** (kullanıcı+ChatGPT kararı,
bkz. Faz 75/76 notları — özet aşağıda "Bilinen Kısıtlar" bölümünde de var).
76 fazın (Faz 1'den bu yana) TAM, ayrıntılı anlatımı artık burada değil,
**`docs/phase-log.md`**'de — hiçbir şey silinmedi, birebir taşındı.

**KALICI KURAL (Faz 76'dan itibaren):** yeni bir Faz tamamlandığında, tablo
satırı artık CLAUDE.md'ye DEĞİL, doğrudan `docs/phase-log.md`'nin "Tamamlanan
Fazlar" tablosuna eklenir. Buradaki (aşağıdaki) özet yalnızca büyük/kilometre
taşı niteliğindeki değişikliklerde (yeni kategori/kurs, mimari karar, CLAUDE.md
organizasyon değişikliği) güncellenir — HER Faz'da değil, aksi hâlde CLAUDE.md
yeniden şişmeye başlar.

**Yeni bir konuya/karara başlamadan önce şunu yap:** `docs/phase-log.md`'yi
`grep`'le (ilgili anahtar kelimeyle — bir kategori slug'ı, bir teknik terim, "Faz
N" gibi). Bu dosyayı `Read` ile baştan sona okumaya GEREK YOK — script/grep ile
arama yeterli (bkz. "Token ve Bağlam Verimliliği" yukarıda). Özellikle şunlar
için mutlaka önce oraya bak: bir kategori/topic'in isimlendirme konvansiyonu,
bir migration deseni, daha önce çözülmüş bir hata sınıfı, ya da "bunu daha önce
nasıl yapmıştık" sorusu.

**Şu an proje durumu (Faz 82 itibarıyla):** 4 kurs (`java`, `spring-boot`,
`react`, `ai`). `ai` kursunda artık 5 kategori var: `ai-fundamentals`,
`large-language-models`, `tools-mcp`, `ai-agents` (her biri 4 topic, TR+EN
tamamlandı) ve **`ai-development-tools`** (artık İKİ topic): `developing-
with-claude-code` (V263-V265, TR+EN ikisi de yayında, bkz. "Faz 81") ve
yeni `claude-code-cli-commands` (V266-V267, TR published=true + EN
published=false -- içerik yazıldı ama kullanıcı henüz incelemedi, bkz. "Faz
82"). **GÜNCELLEME (Faz 87):** V259-V262 (Quiz özelliği, `enum` konusu)
artık BU sandbox kopyasında da mevcut -- daha önce burada "kullanıcının
kendi yerel ortamındaki numaralarla çakışmasın diye kasıtlı olarak
atlandı" deniyordu, bu artık tarihsel bir not, güncel durum değil. Migration'lar
şu an V1'den **V293'e kadar boşluksuz** mevcut: V259-V262 orijinal Quiz
şeması+içeriği, V263-V267 `ai-development-tools` kategorisi, V287-V293 ise
Quiz'in genel bir "soru havuzu" (Question Pool) mimarisine yeniden
tasarlanması (bkz. "Faz 87" ve yukarıdaki "Mimari" bölümündeki ilgili madde).
**GÜNCELLEME (Faz 96):** `spring-boot` kursunun `microservices` kategorisi
artık **12/12 topic TR+EN tamamlandı** (`microservices-fundamentals`'tan
`deployment`'a kadar, Faz 40'ta wave'lere bölünen orijinal ChatGPT planının
tamamı) -- migration'lar şu an V1'den **V317'ye kadar boşluksuz**. Kategori
kuralı gereği bir "Pratik Proje" eklenebilecek doğal nokta bu, ama ayrı bir
repo/tag/build gerektirdiği için henüz üretilmedi, kullanıcının ayrı bir
kararı bekleniyor. **GÜNCELLEME (Faz 104):** `java` kursuna Faz 97-104
arasında eklenen **`exceptions` kategorisi artık 7/7 topic TR+EN
tamamlandı** (`introduction-to-exceptions`, `try-catch-finally`,
`exception-hierarchy`, `checked-vs-unchecked-exceptions`,
`throw-and-throws`, `custom-exceptions`, `exception-handling-best-
practices` -- kendi ayrı üst-seviye kategorisi, Faz 99'da `java-basics`'ten
ayrıldı, bkz. "Mimari" bölümü). Migration'lar şu an V1'den **V339'a kadar
boşluksuz**. **GÜNCELLEME (Faz 109):** `java` kursuna `exceptions`'ın hemen
ardına, Faz 105-109 arasında eklenen **`generics` kategorisi artık 6/6 topic
TR+EN tamamlandı** (`introduction-to-generics`, `generic-methods`,
`bounded-type-parameters`, `wildcards`, `generics-with-collections`,
`type-erasure-and-generic-limitations` -- kendi ayrı üst-seviye kategorisi,
`java-basics` içine hiç konulmadı, `exceptions`/Faz 99 ile aynı desen).
Kullanıcının açık talimatı gereği bu kategoriye bir Pratik Proje
eklenmedi. Migration'lar şu an V1'den **V358'e kadar boşluksuz**.
**GÜNCELLEME (Faz 114):** `spring-boot` kursuna, spring-core(1)/spring-
mvc(2)/microservices(3)'ten sonra sort_order=4'e eklenen **`advanced-
spring` kategorisi artık 4/4 topic TR+EN tamamlandı**: `java-bean-
validation` (Faz 110), `exception-handling` (Faz 111), `task-execution-
and-scheduling` (Faz 112, `@Async`/`CompletableFuture` anlatımı Faz
113'te pedagojik olarak genişletildi), `spring-batch` (Faz 114) --
spring-core/spring-mvc/microservices'in İÇİNE değil, kendi ayrı üst-
seviye kategorisi. Kullanıcının orijinal "Scheduling and Batch Jobs"
fikri Faz 112'de ikiye bölünmüştü, ikinci yarısı (`spring-batch`) Faz
114'te tamamlandı. **ÖNEMLİ:** ilk üç topic BİLİNÇLİ OLARAK mevcut Spring
topic'lerinin (spring-mvc'deki `validation-exception-handling` Faz 22,
spring-core'daki `transaction-management` Faz 82, `java` kursundaki
`threads` Faz 45) ZATEN kapsamlıca işlediği temelleri TEKRAR ÖĞRETMİYOR
-- yalnızca o topic'lerin üzerine inşa edilen, gerçekten yeni/daha derin
materyale odaklanıyor. `spring-batch` bunun İSTİSNASI -- müfredata İLK
KEZ giren tamamen yeni bir teknoloji olduğu için temellerden başlıyor,
TEK tutarlı bir çalışan örnek (CSV'den sipariş içe aktarma) etrafında
kurulu (bkz. Faz 110/111/112/113/114 notları). `spring-boot-starter-batch`
pom.xml'de bir bağımlılık DEĞİL -- `microservices` kategorisinin Kafka/
Eureka örnekleriyle AYNI kısıt (elle, dikkatle yazılmış, derlenmemiş
örnekler). Kullanıcının açık talimatı gereği bu kategoriye henüz bir
Pratik Proje eklenmedi. Migration'lar şu an V1'den **V371'e kadar
boşluksuz**.

**GÜNCELLEME (Faz 123):** `spring-boot` kursuna, spring-core(1)/spring-
mvc(2)/microservices(3)/advanced-spring(4)'ten sonra sort_order=5'e
eklenen **`spring-data-jpa` kategorisi artık 9/9 topic TR+EN tamamlandı**:
`jpa-hibernate-and-spring-data-jpa` (Faz 115), `entities-and-repositories`
(Faz 116), `query-methods-and-jpql` (Faz 117), `pagination-sorting-and-
projections` (Faz 118), `dynamic-queries-with-specifications` (Faz 119),
`relationships-fetching-and-n-plus-1` (Faz 120), `persistence-context-
and-locking` (Faz 121), `jpa-auditing` (Faz 122), `testing-spring-data-
jpa` (Faz 123) -- spring-core/spring-mvc/microservices/advanced-spring'in
İÇİNE değil, kendi ayrı üst-seviye kategorisi. Kategori, içerik
yazılmadan önce kullanıcının PLAN MODE'da onayladığı 9 topic'lik bir
roadmap'e göre inşa edildi (bkz. Faz 115 notu). **ÖNEMLİ:** bu kategori,
mevcut Spring topic'lerinin (spring-core'daki `transaction-management`
Faz 82 -- `@Transactional`/dirty checking/lazy loading/`LazyInitialization
Exception`/`join fetch`/open-in-view; spring-mvc'deki `rest-api-design`
Faz -- `Pageable`/`Page`/`Sort`'un controller-seviyesi çözümlenmesi VE
`spring-mvc-testing`'in `@DataJpaTest`'i yalnızca isim olarak anması)
ZATEN kapsamlıca işlediği temelleri TEKRAR ÖĞRETMİYOR -- yalnızca o
topic'lerin bilinçli olarak açık bıraktığı boşlukları (repository-
seviyesi gerçek sayfalama, `Specification`, N+1'in kendisi, persistence
context'in NEDEN dirty checking'i mümkün kıldığı, `@DataJpaTest`'in
gerçek implementasyonu) dolduruyor, gerçek migration başlıklarıyla
doğrulanmış referanslarla. Birçok topic, bu projenin GERÇEK kodundan
(`Topic`/`Category`/`TopicRepository`/`QuizQuestion`/`QuestionIngestService`/
`application-test.yml`'in kendi yorumu) doğrudan alınan motivasyon ve
örnekler kullandı, uydurma paralel bir domain model yaratmak yerine.
Kullanıcının açık talimatı gereği bu kategoriye bir Pratik Proje
eklenmedi. Migration'lar şu an V1'den **V399'a kadar boşluksuz**. Kesin
sayılar ve tam liste için `docs/phase-log.md`.

**GÜNCELLEME (Faz 133):** java/spring-boot/react/ai'dan sonra BEŞİNCİ,
bağımsız top-level course olarak Faz 124'te açılan **`postgresql`
kursunun `postgresql-foundations` kategorisi artık 10/10 topic TR+EN
tamamlandı**: `postgresql-and-the-relational-model` (Faz 124),
`connecting-to-postgresql` (Faz 125), `databases-schemas-tables-and-
basic-sql` (Faz 126), `postgresql-data-types` (Faz 127), `constraints-
and-keys` (Faz 128), `inserting-updating-and-deleting-data` (Faz 129),
`select-and-filtering` (Faz 130), `sorting-limiting-and-pagination` (Faz
131), `joins` (Faz 132), `aggregation-and-group-by` (Faz 133) --
kullanıcının PLAN MODE'da onayladığı 14 topic'lik roadmap'in (bkz. Faz
124 notu) ilk 10'u, sırayla, her birinde durup onay beklenerek. **ÖNEMLİ:**
bu kategori, bu projenin Spring Data JPA kategorisinin (Faz 115-123)
`Pageable`/`Sort`/`@OneToMany`/`join fetch` gibi Java-seviyesi API'lerin
ZATEN kapsadığı hiçbir şeyi TEKRAR ÖĞRETMİYOR -- yalnızca o API'lerin
ALTINDA gerçekte hangi ham SQL'e (`LIMIT`/`OFFSET`, gerçek `JOIN`,
`GROUP BY`) dönüştüğünü gösteriyor, her seferinde ilgili Spring Data JPA
topic'ine gerçek migration başlığıyla doğrulanmış referansla. Kategorinin
neredeyse her örneği bu projenin GERÇEK şemasından/kodundan: `V1__init_
schema.sql`'in kendisi (`CREATE TABLE`, `ON DELETE CASCADE`), gerçek
`quiz_question_link`'in `ON DELETE RESTRICT`'i (kendi gerçek migration
yorumuyla), gerçek `TopicRepository.findBySlugWithCategoryAndCourse`
JPQL `join fetch`'i, ve bu projenin kendi gerçek iki-adımlı TR/EN yayın
iş akışını bulan bir `LEFT JOIN` sorgusu. Kullanıcının açık talimatı
gereği bu kategoriye bir Pratik Proje eklenmedi. Migration'lar şu an
V1'den **V419'a kadar boşluksuz**. Kesin sayılar ve tam liste için
`docs/phase-log.md`.

**GÜNCELLEME (Faz 137):** `postgresql` kursunun `advanced-postgresql`
kategorisi de (Faz 134-137) **4/4 topic TR+EN tamamlandı**:
`subqueries-ctes-and-window-functions` (Faz 134), `postgresql-specific-
data-types` (Faz 135), `indexes-and-query-performance-with-explain`
(Faz 136), `transactions-and-concurrency-in-postgresql` (Faz 137) --
bu son topic'le **TÜM `postgresql` kursu (14/14 topic, 2 kategori)
TAMAMLANDI** (bkz. Faz 124'teki onaylanmış 14 topic'lik roadmap). Bu
kategori, Foundations'ın aksine, bilinçli olarak PostgreSQL'e özgü
derinliğin yoğunlaştığı yer: `subqueries-ctes-and-window-functions`
korelasyonlu subquery/CTE/window fonksiyonlarını GROUP BY'ın aksine
satırları çökertmeden hesaplama olarak öğretti; `postgresql-specific-
data-types`, UUID/JSONB/array'leri -- bu projenin gerçek şemasının
HİÇBİRİNİ kullanmadığı AÇIKÇA belirtilerek, tüm örnekler illüstratif
olarak etiketlenerek -- kapsadı; `indexes-and-query-performance-with-
explain`, "Sorting, Limiting, and Pagination"ın (Faz 131) `OFFSET`
maliyeti ve "Constraints and Keys"in (Faz 128) otomatik PK index'i
ileri referanslarını, bu projenin kendi gerçek `idx_topic_category`
index'iyle kapattı; `transactions-and-concurrency-in-postgresql`,
`BEGIN`/`COMMIT`/`ROLLBACK`/MVCC/`SELECT ... FOR UPDATE`/deadlock'ı,
"Transaction Management"in (Faz 82) isolation kapsamını (dirty/non-
repeatable/phantom read, `READ_COMMITTED` varsayılanı) hiç TEKRARLAMADAN
işledi. Kursun her topic'i, Spring Data JPA kursunun (Faz 115-123)
Java-seviyesi API'lerinin (`Pageable`, `@OneToMany`/`join fetch`,
`@Lock`) ALTINDA gerçekte hangi ham SQL'e dönüştüğünü gösterdi, hiçbirini
tekrar öğretmeden -- her ikisi de gerçek migration başlıklarıyla
doğrulanmış çapraz referanslarla. Kullanıcının açık talimatı gereği bu
kursa hiçbir yerinde bir Pratik Proje eklenmedi. Migration'lar şu an
V1'den **V427'ye kadar boşluksuz**. Kesin sayılar ve tam liste için
`docs/phase-log.md`.

**GÜNCELLEME (Faz 138):** İçerik dışı, mimari bir ekleme -- opsiyonel
**kullanıcı kimlik doğrulaması** (Spring Security, session-based, BCrypt)
eklendi (ayrıntılar için "Mimari" bölümündeki ilgili madde). `app_user`
tablosu (V428), `User`/`Role` entity'leri, `AuthController`
(`/{lang}/login`, `/{lang}/register`), navbar'da "Sign in" / "[Kullanıcı
Adı] [Logout]" durumu. Var olan hiçbir public rota etkilenmedi -- v1'de
gated hiçbir kaynak yok. Migration'lar şu an V1'den **V428'e kadar
boşluksuz**. Kullanıcının kendi ortamında `mvn clean test`: **53 test, 0
hata, 0 başarısızlık, BUILD SUCCESS** (yeni `AuthenticationFlowTest`in 5
testi dahil). **Boot 4 gotcha'sı:** `@AutoConfigureMockMvc` artık
`spring-boot-starter-test`'te DEĞİL, ayrı bir `spring-boot-starter-webmvc-
test` starter'ında (paket `org.springframework.boot.webmvc.test.
autoconfigure`) -- MockMvc kullanan yeni bir test eklenirse bu starter
gerekli (bkz. `pom.xml`). Ayrıntılı uygulama akışı için `docs/phase-log.md`'de
"Faz 138"i grep'le.

## Proje Yapısı

```
src/main/java/com/cdurgun/learning/
    domain/          Course, Category, Topic, TopicTranslation, CodeExample, Language, Difficulty,
                     Question, QuestionOption, QuestionType, QuestionStatus, QuestionSource (soru
                     havuzu -- Faz 87), Quiz, QuizQuestion (Quiz<->Question join/sıra entity'si),
                     User, Role (opsiyonel kimlik doğrulama -- Faz 138)
    domain/converter/ Language <-> DB (tr/en kodu) dönüştürücüsü
    repository/      Spring Data JPA repository'leri (UserRepository dahil)
    service/         ContentResolver, CodeExampleResolver, MarkdownService, NavigationService,
                     QuizService (sabit quiz), PracticeService (soru havuzu/Practice), QuestionScorer
                     (paylaşılan puanlama kuralı), QuestionIngestService (AI/n8n ingestion),
                     CustomUserDetailsService, UserRegistrationService (Faz 138)
    controller/      HomeController, TopicController, PracticeController, QuestionIngestController,
                     AuthController (login/register sayfaları -- Faz 138)
    config/          LangParamLocaleResolver, WebConfig, QuizIngestApiKeyInterceptor (ingestion
                     rotasını X-Api-Key ile korur), SecurityConfig, LangPath (Faz 138)
    web/nav/         Sidebar/anasayfa navigasyon DTO'ları (CourseNav)
    web/quiz/        Sabit quiz + Practice GET/submit DTO'ları (QuizQuestionView, QuestionView,
                     QuizAnswer, QuizSubmitRequest/Response, PracticeSubmitRequest/Response, ...)
    web/ingest/      AI ingestion istek/yanıt DTO'ları (QuestionIngestRequest/Option/Response)
    web/auth/        Kayıt formu bağlama DTO'su (RegisterForm -- Faz 138)

src/main/resources/
    content/{tr,en}/{slug}.md     Ders içerikleri (tek doğruluk kaynağı)
    examples/{slug}/*.java        Gerçek, derlenebilir kod örnekleri
    db/migration/{konu-slug}/     Flyway migration'ları, konu bazlı alt klasörlerde (V1..V428)
    templates/                    Thymeleaf şablonları (Bootstrap + highlight.js)
    templates/auth/               login.html / register.html (Faz 138)
    static/css/custom.css         Sidebar accordion (.sidebar-toggle/.chevron) dahil özel stiller
    static/img/                   LearnForgeX marka varlıkları (favicon.svg/logo.svg/logo-dark.svg,
                                   favicon.ico/-16.png/-32.png, apple-touch-icon.png -- Faz 48)
    messages*.properties          Arayüz metni çevirileri
```

## Bilinen Kısıtlar / Dikkat Edilecekler (Güncel Durum Özeti)

**Faz 76'da CLAUDE.md'yi küçültmek için özetlendi.** Tam kronolojik geçmiş
(bir kısıtın nasıl keşfedildiği, hangi fazda değiştiği) artık
**`docs/known-constraints.md`**'de — hiçbir şey silinmedi, birebir taşındı.
Aşağıdaki, en son doğrulanmış durumun kısa özeti; ortam oturumdan oturuma
değişebileceği için, görev bu kısıtlardan birine gerçekten bağlıysa **önce
bash ile yeniden doğrula** (ör. `mvn -version`, `curl -I https://repo.maven.apache.org`).

- **Maven Central (`repo.maven.apache.org`, `repo1.maven.org`) bu sandbox'ta
  engelli** (proxy 403 döndürüyor) — Spring Boot/harici Maven bağımlılığı
  gerektiren hiçbir Java kodu (`mvn compile`, `spring-boot:run`) gerçekten
  derlenip çalıştırılamıyor. Yalnızca harici bağımlılık gerektirmeyen saf JDK
  kodu (`java.util.*` gibi) `javac`/`java` ile gerçekten derlenebilir.
- **`javac`/`java` ile gerçek derleme, Faz 12'den beri varsayılan olarak
  YAPILMIYOR** (oturum maliyeti/limit nedeniyle) — yeni `.java` dosyaları elle
  dikkatli yazılıp gözden geçirilir. İstisna: kullanıcı özellikle isterse, ya da
  dosya sıra dışı riskliyse (deadlock/timeout içeren thread örnekleri gibi),
  ya da kod saf JDK ise (Maven bağımlılığı yok) — bu durumda önce
  `/tmp/.../scratch/`'te derleyip çalıştır, sonra doğrulanmış hâliyle asıl
  `examples/` klasörüne kopyala (bkz. Node/TypeScript için de aynı yöntem,
  Faz 72 notu).
- **`registry.npmjs.org` ve `pypi.org` bu sandbox'ta ERİŞİLEBİLİR** — React
  (`.jsx`) ve Node/TypeScript (MCP SDK gibi) kodu `npm install` ile gerçekten
  kurulup derlenip çalıştırılarak doğrulanabilir; bu, Java/Spring'in aksine
  gerçek bir uçtan uca doğrulama imkânı sunar (bkz. Faz 41, 72).
- **`cdn.jsdelivr.net` bu sandbox'ta ERİŞİLEMİYOR** (Faz 68'de keşfedildi) —
  Playwright ile bir sayfa doğrulaması Bootstrap'e bağımlıysa, CDN linki
  kullanma; önce `npm install bootstrap@{sürüm} --no-save` ile yerel bir kopya
  indirip mock HTML'de ona göreli yol ver (aksi hâlde sayfa stilsiz/boş render
  olur, yanıltıcı sonuç verir).
- **Ayrı, uzun ömürlü git branch'leri kullanılmıyor** — `react-course-projects`/
  `microservices-course-projects` gibi kurs-proje repoları `main` üzerinde, yalnızca
  tag'lerle versiyonlanıyor.
- Çok satırlı `//` Java yorumlarında her satırın başına `//` tekrar yazılmalı
  (bir örnekte bunu unutup gerçek bir derleme hatası bırakılmıştı) — yazarken kontrol et.

Daha fazla ayrıntı, geçmiş hata örnekleri, ve her kısıtın hangi fazda nasıl
keşfedildiği için `docs/known-constraints.md`'yi grep'le.
