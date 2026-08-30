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
  KENDİSİNE sabit yazılı, hiçbir çağıran taraf override edemez). **DİKKAT:**
  sabit quiz'in soru üyeliği (`quiz_question_link`) `Question.status`'tan
  TAMAMEN BAĞIMSIZDIR — `QuizService.loadQuiz()` hiçbir status filtresi
  uygulamaz, yalnızca `quiz_question_link`'te ne varsa onu döner. Yani bir
  soruyu `PUBLISHED` yapmak onu OTOMATİK OLARAK hiçbir topic'in sabit
  quiz'ine EKLEMEZ (yalnızca havuza girmesini sağlar, Practice/Quiz Area'da
  görünür hale getirir) — bir topic'in sabit quiz'ine yeni soru eklemek AYRI,
  açık bir `quiz_question_link` seed adımı gerektirir (bkz. `enum/V291`,
  `git-fundamentals/V467`/`V468` — topic slug + language + quiz slug ile
  portable şekilde resolve edilen quiz'e link'leyen migration deseni).
  Puanlama
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

**GÜNCELLEME (Faz 139):** Yeni bir top-level **Quiz Area** eklendi --
kategori-kapsamlı, rastgele soru çekilen, yeniden kullanılabilir quiz
tanımları (`QuizDefinition`, `course` FK + kategorilerle `@ManyToMany`,
boş kategori kümesi = tüm kurs konvansiyonu). Var olan sabit/topic-gömülü
`Quiz`/`QuizQuestion`/`QuizService`'e HİÇ DOKUNULMADI -- Quiz Area
BİLİNÇLİ OLARAK ayrı, ek bir kavram (bkz. "Mimari" bölümündeki Faz 87
maddesi, Question Pool). Sidebar'da (`fragments/layout.html`) course
ağacından bağımsız, kendi "QUIZ" bölümü var (`QuizNav`/
`QuizNavigationService`, `GlobalModelAttributes`'e sitewide enjekte
edilir). Submit/puanlama YENİDEN YAZILMADI -- `PracticeService.submit`
AYNEN kullanılacak (draw tarafı yeni, submit tarafı Practice ile paylaşılan).
`java` kursu için gerçek seed (`basic-java`=`java-basics`+`control-flow`,
`advanced-java`=`exceptions`+`generics`+`collections`+`oop`+`concurrency`+
`functional-interfaces-streams`, `all-java`=tüm kurs) V430'da eklendi;
`spring-boot`/`react` kursları için henüz eklenmedi (kullanıcının açık
talimatıyla sonraki bir faza bırakıldı). Migration'lar şu an V1'den
**V430'a kadar boşluksuz**. **Soru çekme/cevap gönderme UI akışı
(controller + `quiz-play.html` + CSRF muafiyeti) HENÜZ EKLENMEDİ** --
şu anki durum yalnızca nav + veri modeli + seed, kullanıcının onayını
bekleyen ayrı bir sonraki faz. Ayrıntılı uygulama akışı için
`docs/phase-log.md`'de "Faz 139"u grep'le.

**GÜNCELLEME (Faz 141):** **Question Review** mimarisi eklendi -- önce
ayrıntılı bir mimari öneri sunulup onaylandı (bkz.
`docs/question-review-promotion-proposal.md`), sonra iki küçük fazda
uygulandı. **Faz A (ADMIN yetkilendirmesi):** `SecurityConfig`'e tek bir
kural eklendi -- `/{lang:en|tr}/admin/**` → `hasRole("ADMIN")`. Yeni bir
yetkilendirme mekanizması KURULMADI: `Role.ADMIN` ve
`CustomUserDetailsService`'in `"ROLE_" + role.name()` authority'si Faz
138'den beri zaten vardı, hiç kullanılmıyordu. Kullanıcının kendi dev
hesabını ADMIN'e yükseltmesi ELLE yapıldı (migration YOK, rol-yönetim
arayüzü YOK). **Faz B (Question Review UI, yalnızca listeleme):** yeni
`QuestionReviewController` (`GET /{lang}/admin/questions`),
`QuestionReviewService.listPending()`, `web/review/QuestionReviewView`
DTO'su (public quiz DTO'larının aksine `correct` alanını BİLİNÇLİ OLARAK
gizlemiyor -- kimlik doğrulanmış bir ADMIN görünümü), yeni
`admin/question-review.html` (Publish/Reject butonları KASITLI OLARAK
`disabled`, hiçbir forma bağlı değil -- Faz C'ye bırakıldı). **Güncel
davranış:** yalnızca `ADMIN` rolü `/{lang}/admin/questions`'a erişebiliyor
(USER 403, anonim login'e yönlendiriliyor), `PENDING_REVIEW` sorular
listelenip doğru şıkkıyla birlikte incelenebiliyor, Publish/Reject HENÜZ
YOK; `PENDING_REVIEW` sorular public quiz'lerde (Practice/Quiz
Area/sabit quiz) HÂLÂ görünmüyor -- bu, Faz B'de hiç değişmeyen,
`QuestionRepository`'nin pool sorgularına zaten sabit yazılı
`status='PUBLISHED'` filtresinden geliyor (bkz. Faz 87/139). Hem otomatik
testle (69/69) hem gerçek canlı uygulamaya karşı (geçici ADMIN/USER
hesaplarıyla gerçek `/en/login` akışı üzerinden) doğrulandı. Migration'lar
hâlâ V1'den **V430'a kadar boşluksuz** (bu fazlarda yeni migration YOK).
Ayrıntılı uygulama akışı için `docs/phase-log.md`'de "Faz 141"i grep'le.

**GÜNCELLEME (Faz 142):** Question Review'in eksik parçası, **Publish/
Reject**, eklendi. `QuestionReviewService.publish`/`reject` -- yalnızca
`PENDING_REVIEW`'dan geçişe izin veriyor (zaten PUBLISHED/REJECTED bir
soruya tekrar çağrılırsa `409 Conflict`, satır değişmez), `reviewedBy`/
`reviewedAt`'i (Faz 87'den beri var, hiç kullanılmıyordu) artık gerçekten
dolduruyor. Yeni `POST /{lang}/admin/questions/{id}/publish`/`.../reject`
-- Faz A'nın `hasRole("ADMIN")` kuralına otomatik giriyor,
`SecurityConfig`'te ek değişiklik gerekmedi; CSRF muafiyet listesine
BİLİNÇLİ OLARAK eklenmedi (login/register/logout formlarıyla aynı
kategori -- kimlik doğrulanmış gerçek tarayıcı formu). `admin/question-
review.html`'deki butonlar artık gerçek POST formları (Faz B'deki
`disabled` durumdan). **Public havuza sızma/dışlanma hiçbir yeni kod
gerektirmedi** -- `QuestionRepository`'nin sabit `status='PUBLISHED'`
filtresi (Faz 87) `publish()`'in hemen ardından soruyu otomatik uygun
hale getiriyor; gerçek canlı uygulamaya karşı `/en/practice`'e yapılan
bir HTTP çağrısıyla doğrulandı. Hem otomatik testle (75/75) hem gerçek
canlı uygulamaya karşı (409 double-processing koruması dahil)
doğrulandı. Migration'lar hâlâ V1'den **V430'a kadar boşluksuz**.
Ayrıntılı uygulama akışı için `docs/phase-log.md`'de "Faz 142"yi grep'le.

**GÜNCELLEME (Faz 143):** Question Review'in son parçası, **Development →
Production promotion**, eklendi -- kod değil, iki küçük araç: `scripts/
export_approved_questions.py` + ince bir `scripts/export-approved-
questions.sh` sarmalayıcısı. Yalnızca AÇIKÇA verilen dev question id'lerini
işler (`export-approved-questions.sh 101 102 103`) -- asla "tüm PUBLISHED
sorular" gibi kapsayıcı bir varsayılan kullanmaz (kullanıcının bilinçli
kararı). Yeni soru ÜRETİMİ/incelemesi HÂLÂ hiçbir zaman bir migration
olarak yazılmıyor (yalnızca `QuestionIngestController` üzerinden dev'e
canlı INSERT) -- yalnızca PROMOTION bir Flyway migration'ı, `db/migration/
question-promotion/` alt klasöründe, her zaman doğrudan `status='PUBLISHED'`
ile tek bir INSERT (bkz. "Mimari" bölümündeki Faz 87 maddesi). Script
production'a HİÇBİR ŞEKİLDE bağlanamaz -- yapısal olarak: env değişkeni
isimleri (`EXPORT_SOURCE_DB_*`) `application-prod.yml`'in okuduklarından
(`DB_URL`/`DB_USERNAME`/`DB_PASSWORD`) kasıtlı olarak farklı. Tekrar-promote
önleme bu aşamada bir SÜREÇ sorumluluğu (migration başlığındaki dev id
listesi) -- yeni bir `promoted_at` kolonu/unique constraint BİLİNÇLİ OLARAK
EKLENMEDİ. Doğrulama gerçek bir atılabilir Postgres container'ında (tüm 431
migration sıfırdan) yapıldı, prod'a hiç dokunulmadı. Ayrıntılı uygulama
akışı için `docs/phase-log.md`'de "Faz 143"ü grep'le.

**GÜNCELLEME (Faz 144):** **Question Ingestion / Authoring API** netleştirildi
-- manuel yazım/Claude/n8n'in ortak giriş noktası. Var olan
`QuestionIngestController`/`QuestionIngestService`/`QuizIngestApiKeyInterceptor`
mimarisi (Faz 87/D) zaten gereksinimlerin neredeyse tamamını karşılıyordu --
**yeni bir API/servis YARATILMADI**, yalnızca genişletildi. `QuestionSource`
enum'u `MANUAL, AI` yerine `MANUAL, CLAUDE, N8N` oldu (eski genel `AI`
hiçbir gerçek satırda hiç kullanılmamıştı). `QuestionIngestRequest`'e yeni
bir `source` alanı eklendi -- `status`'un AKSİNE (o hâlâ DTO'da hiç YOK,
hâlâ bir imkansızlık) `source` güvenlik açısından hassas değil, çağıranın
kendini beyan etmesine izin veriliyor ama var olan `parseEnum` yardımcısıyla
sıkı bir izin listesine (yalnızca MANUAL/CLAUDE/N8N) karşı doğrulanıyor.
Hiçbir migration/şema değişikliği YOK (`source` zaten VARCHAR, CHECK
constraint yok). Hem otomatik testle (80/80) hem gerçek canlı uygulamaya
karşı doğrulandı -- ingest edilen `PENDING_REVIEW` soru gerçek `/en/practice`
havuzundan tamamen izole kaldı, gerçek Question Review ekranında doğru
`source` ile göründü. Ayrıntılı uygulama akışı için `docs/phase-log.md`'de
"Faz 144"ü grep'le.

**GÜNCELLEME (Faz 145):** **n8n → Question Ingestion API'nin ilk GERÇEK
uçtan uca entegrasyonu** kuruldu -- yerel makinede zaten cache'li olan
gerçek bir `n8n` Docker image'ıyla (simülasyon değil). Yeni `n8n/`
dizini: `workflows/question-ingestion-test-batch.json` (Manual Trigger →
Code node [3 gerçek `enum` sorusu üretir] → HTTP Request [var olan
`/api/internal/questions/ingest`'e POST]) + `README.md`. n8n
PostgreSQL'e ya da production'a HİÇ bağlanmıyor, yalnızca var olan
Ingestion API'yi çağırıyor -- workflow'da başka hiçbir bağlantı düğümü
yok. `retryOnFail: false` + `onError: "continueRegularOutput"` AÇIKÇA
ayarlandı (duplicate yaratabilecek bir retry'a karşı). API-key,
workflow dosyasına hiç yazılmadan `{{$env.QUIZ_INGEST_API_KEY}}`
ifadesiyle veriliyor. Gerçek n8n CLI ile (`import:workflow` +
`execute --id`) çalıştırılıp gerçek dev DB'ye karşı doğrulandı: 3
soru `source=N8N`/`PENDING_REVIEW` olarak eklendi, `/en/practice`'ten
izole kaldı, Question Review ekranında doğru göründü; ayrı bir bozuk-
topic-slug testiyle 400 hatasının duplicate yaratmadan görünür şekilde
raporlandığı da doğrulandı. Test verisi temizlendi, Publish/Reject'e
dokunulmadı. Ayrıntılı uygulama akışı için `docs/phase-log.md`'de
"Faz 145"i grep'le.

**GÜNCELLEME (Faz 146):** **Büyük ölçekli soru üretim workflow'u** önce
plan mode'da tasarlanıp onaylandı (H2 başlıkları kavramsal KAPSAM
tanımlar ama literal kelime-eşleşme gerekliliği DEĞİLDİR -- content-fit
LLM prompt'unun gerçek ders metnine topraklanmasıyla sağlanır, Validate
Output yalnızca YAPISAL doğrulama yapar), sonra `enum` topic'iyle
sınırlı, kontrollü bir ilk test olarak uygulandı. n8n'in Postgres'e/dosya
sistemine doğrudan bağlanması hâlâ YASAK olduğu için üç yeni salt-okunur
`/api/internal/**` uç noktası eklendi: `GET /api/internal/topics/{slug}`
(metadata), `GET /api/internal/topics/{slug}/content?lang=..` (ham
markdown), `GET /api/internal/questions/existing?topicSlug=..&language=..`
(id+question, TÜM statüler -- duplicate kontrolü için). Yeni
`GenerationToolingController`/`GenerationToolingService` (yalnızca okur,
`Question` YAZMAZ) -- hiçbir yeni güvenlik kodu yok, üçü de var olan
`/api/internal/**`/`QuizIngestApiKeyInterceptor` kapsamında. Yeni
`n8n/workflows/question-generation-enum-test.json` (9 düğüm: Topic
Selection → Load Topic Content → Build Generation Spec → Generate Batch
→ Parse Generated Questions → Validate Output → Duplicate Check → Submit
Valid Questions → Record Results). **Bu sandbox'ta kullanılabilir bir
`ANTHROPIC_API_KEY` YOK** (gerçek bir HTTP çağrısı `api.anthropic.com`'dan
GERÇEK bir `401 invalid x-api-key` döndürdü) -- `Generate Batch` bu yüzden
Faz 145'teki AYNI teknikle (elle/Claude tarafından yazılmış, ders içeriğine
gerçekten topraklanmış bir Code node, Anthropic'in YANIT ŞEKLİYLE birebir
aynı biçimde) bir stand-in'e çevrildi, akışın geri kalanı DEĞİŞMEDEN gerçek
çalıştı. **Ayrıca `n8n execute` CLI'ının workflow'daki `pinData`'yı hiç
dikkate almadığı da bu Faz'da keşfedildi** (bkz. `docs/known-constraints.md`
"Faz 146"). Üretilen 6 soru (3 EN + 3 TR, `EnumSet`/`EnumMap`/`Singleton
Pattern`'e topraklı) gerçek Ingestion API'ye submit edilip gerçek dev DB'de
`status=PENDING_REVIEW`/`source=N8N` olarak doğrulandı, `status='PUBLISHED'`
sayımı 0, gerçek `/en/admin/questions` ekranında (geçici bir ADMIN hesabıyla)
göründüğü teyit edildi. Test verisi/geçici hesap temizlendi. Migration'lar
hâlâ V1'den **V430'a kadar boşluksuz** (bu Faz'da migration YOK). Kullanıcının
açık talimatıyla büyük ölçekli/çok-topic'li üretim BİLİNÇLİ OLARAK bu Faz'ın
dışında bırakıldı -- sonraki adım için onay bekleniyor. Ayrıntılı uygulama
akışı için `docs/phase-log.md`'de "Faz 146"yı grep'le.

**GÜNCELLEME (Faz 147):** **`Generate Batch` düğümü gerçek OpenAI'a geçirildi**
ve iki gerçek, ücretli çağrıyla `enum` topic'inde uçtan uca doğrulandı. n8n'in
kalıcı SQLite'ında zaten var olan bir credential ("OpenAI account",
`openAiApi` tipi) yalnızca `id`/`name`/`type` salt-okunur sorgulanarak
bulundu (şifreli anahtar hiç okunmadı/yazdırılmadı), `Generate Batch` artık
`https://api.openai.com/v1/chat/completions`'ı n8n'in KENDİ credential
mekanizmasıyla (`predefinedCredentialType`/`openAiApi`) çağırıyor.
`QuestionSource`'a `MANUAL`/`CLAUDE`/`N8N` ile AYNI desende yeni bir `OPENAI`
değeri eklendi. **İki gerçek çağrıda üç yeni bug bulunup düzeltildi** (hiçbiri
için ikinci bir ücretli çağrı YAPILMADI -- kaçırılan sorular, halihazırda
alınmış gerçek yanıt yeniden oynatılarak kurtarıldı): `Load Topic Content`
`onlyLanguage`/`overrideCount`'u kaybediyordu; gerçek HTTP Request düğümü
`item.json`'ı API yanıtıyla değiştirdiği için `topicSlug`/`language`
kayboluyordu (`itemMatching` ile düzeltildi); CODE_OUTPUT prompt düzeltmesi
kodu `question` metninden `codeSnippet`'e taşıyınca TÜM CODE_OUTPUT
sorularının `question` metni aynı jenerik cümle olduğu için `Duplicate
Check` birbirinden farklı iki kodu yanlışlıkla kopya sandı (`question +
codeSnippet` birlikte karşılaştırılarak düzeltildi). **Kalite incelemesi +
prompt iyileştirmesi:** ilk 3 sorudan biri aşırı tanım-tabanlı, biri de
açıklaması yalnızca doğru şıkkı gerekçelendirip yanlışları hiç ele
almıyordu bulundu; `buildPrompt()` batch başına en fazla bir tanım sorusuna
izin verecek, gerçekçi distractor isteyecek, açıklamaların en yakın yanlış
şıkkı da ele almasını isteyecek, aynı cümle kalıbının tekrarını
yasaklayacak, ve CODE_OUTPUT kodunun yalnızca `codeSnippet`'te olmasını
zorunlu kılacak şekilde yeniden yazıldı. **CODE_OUTPUT render hatası**
(kodun hem `codeSnippet`'te hem `question` metninde ham fenced blok olarak
tekrarlanıp admin ekranında ters tırnaklarla düz metin görünmesi) SUNUM
KATMANINDA düzeltildi -- yeni `QuestionReviewView.questionDisplayText()`
(`codeSnippet` doluysa `question`'daki fenced bloğu ekrandan düşüren
türetilmiş bir görünüm metodu, DB'deki `question` sütununu HİÇ değiştirmez),
`admin/question-review.html` artık bunu çağırıyor. **Kullanıcının manuel
kalite kararıyla** id 43 (aşırı basit) ve id 49 (id 44 ile pedagojik olarak
yedünk, ikisi de `valueOf(String)` test ediyor) REJECTED, id 44/45/46/47/48
PUBLISHED edildi -- gerçek `/en/admin/questions/{id}/publish|reject` uç
noktalarıyla, `reviewedBy`/`reviewedAt`'in dolduğu, 5 PUBLISHED sorunun
gerçek `PracticeService`/`QuizService` native sorgusunun sonuç kümesinde
göründüğü, ve 43-49 dışında hiçbir satırın etkilenmediği doğrulandı. Dev DB
sonucu: 17 soru (10 orijinal `PUBLISHED`/`MANUAL` + 5 yeni
`PUBLISHED`/`OPENAI` + 2 `REJECTED`/`OPENAI`). Testler **90/90**. Migration'lar
hâlâ V1'den **V430'a kadar boşluksuz** (bu Faz'da migration YOK). Büyük
ölçekli/çok-topic'li üretim HÂLÂ bu Faz'ın dışında. Ayrıntılı uygulama
akışı için `docs/phase-log.md`'de "Faz 147"yi grep'le.

**GÜNCELLEME (Faz 148):** **EN->TR çeviri workflow'u** eklendi -- mevcut
PUBLISHED/PENDING_REVIEW EN sorularının TR karşılıklarını üretip
`PENDING_REVIEW`/`source=OPENAI` olarak ekliyor, `correct`/şık yapısı/
`difficulty`/`type`/`codeSnippet`/`topic` HİÇBİRİ modelin çıktısından
alınmıyor -- hep orijinal EN sorudan birebir kopyalanıyor. Yeni salt-okunur
`GET /api/internal/questions/for-translation` (`source` alanı dahil --
`MANUAL` kaynaklı sorular, bu projede zaten EN+TR ÇİFTİ yazıldığı için
çeviri adayı listesinden atlanıyor). Yeni `n8n/workflows/question-
translation-en-to-tr.json` (8 düğüm). **Üç gerçek bulgu keşfedilip
düzeltildi:** (1) `MANUAL` ön-filtresi olmadan ilk çalıştırma, zaten TR
karşılığı olan sorulara redundant, farklı-kelime-kalıplı TR kopyaları
üretti (fuzzy dedup'ın 0.6 Jaccard eşiğinin altında kaldı) -- yapısal
filtreyle düzeltildi; (2) Faz 147'nin `comparableText()`'i CODE_OUTPUT'lar
için hâlâ yetersizdi (paylaşılan boilerplate + "son satır" bazen anlamsız
bir `}` oluyordu) -- parantez/noktalı-virgül temizlenmiş SON ANLAMLI
satırı karşılaştıracak şekilde düzeltildi, HER İKİ workflow'a da uygulandı;
(3) **n8n'in HTTP transport katmanında, Türkçe metni ARA SIRA ama
DETERMİNİSTİK şekilde CJK karakterlerine bozan bir encoding hatası**
bulundu (4 ayrı gerçek çağrıda da AYNI bozuk çıktı) -- kök nedeni bu
sandbox'tan izole edilemedi, bunun yerine `Validate Translation`'a bir CJK-
koruma regex'i eklendi (4/4 çalıştırmada bozuk çeviriyi submit'ten önce
yakalayıp eledi, bkz. `docs/known-constraints.md` "Faz 148"). 4. denemeden
sonra bu TEK soru 5. bir ücretli çağrı yerine elle çevrilip submit edildi.
**Generation workflow'u da varsayılana döndürüldü:** `Topic Selection`'daki
tek-dil zorlaması kaldırıldı -- artık her yeni üretim hem EN hem TR
bağımsız olarak (her biri kendi gerçek markdown dosyasına topraklanarak)
üretecek. Sonuç: 5 EN sorunun (44/45/46/47/48) TAMAMI bir TR karşılığına
sahip (53/54/57/55/58), topic/type/difficulty/codeSnippet/doğru-şık-deseni
birebir eşleşiyor, hiçbiri PUBLISHED değil -- kullanıcının onayı
bekleniyor. Testler **92/92**. Migration'lar hâlâ V1'den **V430'a kadar
boşluksuz** (bu Faz'da migration YOK). Ayrıntılı uygulama akışı için
`docs/phase-log.md`'de "Faz 148"i grep'le.

**GÜNCELLEME (Faz 150):** **`git-github` kursunun TÜM 11 topic'i (2
kategori: `git-fundamentals` 6/6, `advanced-git` 5/5) artık "Test Your
Knowledge" quiz'ine sahip -- kurs artık uçtan uca 220 soruyla (110 EN +
110 TR) tamamlandı.** Bu Faz'da 9 topic (`undoing-changes`,
`branches-and-merging`, `github-and-remotes`, `pull-requests`,
`rebase-and-squash`, `merge-conflicts`, `stash`,
`advanced-git-and-best-practices`, `practical-git-github-workflow`) --
`git-fundamentals`/`working-with-commits` zaten Faz 148'den önce
tamamlanmıştı (bkz. V467-V470) -- ayrı kullanıcı isteklerinde, AYNI
kurulmuş desenle işlendi: her topic için 10 EN + 10 TR soru (genelde
7 SINGLE_CHOICE + 3 MULTIPLE_CHOICE, MULTIPLE_CHOICE'ta her zaman tam
2 doğru şık) gerçek AI-Judge auto-publish endpoint'i (`POST
/api/internal/questions/{id}/auto-publish`) ile PUBLISHED edildi,
sonra V467-V468'in portable promotion-migration deseniyle (topic/quiz
slug'larından dinamik id çözümü, `NOT EXISTS` + `ON CONFLICT DO
NOTHING` duplicate-güvenliği) mevcut sabit quiz'e pozisyon 1-10'da
link'lendi. **4 topic'te (`stash` 1, `advanced-git-and-best-practices`
2, `practical-git-github-workflow` 1) CODE_OUTPUT tipi soru da
kullanıldı** -- her biri dersin GERÇEKTEN gömdüğü bir komut çıktısı
örneğine (`git stash list`, `git reflog`, `git blame`,
`FullWorkflowDemo.sh`'ın rebase-conflict çıktısı) dayanıyor, hiçbiri
zorlama değil (proje kuralı: CODE_OUTPUT yalnızca genuine bir
komut-çıktısı yorumlama senaryosu varsa kullanılır). Her topic
sonrasında AYNI doğrulama seti çalıştırıldı: yapısal SQL kontrolü (4
şık, tip başına doğru sayısı), near-duplicate taraması (yalnızca
boilerplate soru-kalıbı örtüşmesi olan yanlış pozitifler elendi),
doğru-cevap harf dağılımının hesaplanıp raporlanması (her topic'te
dengeliydi, tek bir harf en fazla 4/13 -- matematiksel olarak
kaçınılmaz), atılabilir bir `postgres:16-alpine` container'ında
sıfırdan fresh-DB migration doğrulaması + idempotency re-run,
mevcut dev DB'de idempotency re-run, gerçek HTTP quiz submit'i (tam
doğru → tam skor, kısmi MULTIPLE_CHOICE → o soru yanlış), ve `mvn
test` (Faz 140 workaround'uyla, her seferinde 100/100). Migration'lar
şu an V1'den **V488'e kadar boşluksuz**. Bu Faz sırasında bir gerçek,
sandbox-özel bulgu keşfedildi: `mvn -o flyway:migrate`'in
`target/classes`'ı (derlenmiş çıktı) taradığı, `src/main/resources`'ı
DEĞİL -- yeni bir migration eklenip hemen disposable-DB doğrulamasına
geçilirse migration SESSİZCE atlanıyor (bkz.
`docs/known-constraints.md` "Faz 149"). Ayrıntılı uygulama akışı için
`docs/phase-log.md`'de "Faz 150"yi grep'le.

## Proje Yapısı

```
src/main/java/com/cdurgun/learning/
    domain/          Course, Category, Topic, TopicTranslation, CodeExample, Language, Difficulty,
                     Question, QuestionOption, QuestionType, QuestionStatus, QuestionSource (soru
                     havuzu -- Faz 87), Quiz, QuizQuestion (Quiz<->Question join/sıra entity'si),
                     User, Role (opsiyonel kimlik doğrulama -- Faz 138), QuizDefinition (Quiz Area
                     kapsam tanımı, course FK + Category ile @ManyToMany -- Faz 139)
    domain/converter/ Language <-> DB (tr/en kodu) dönüştürücüsü
    repository/      Spring Data JPA repository'leri (UserRepository, QuizDefinitionRepository dahil)
    service/         ContentResolver, CodeExampleResolver, MarkdownService, NavigationService,
                     QuizService (sabit quiz), PracticeService (soru havuzu/Practice), QuestionScorer
                     (paylaşılan puanlama kuralı), QuestionIngestService (manuel/Claude/n8n
                     ortak ingestion giriş noktası -- Faz 144),
                     CustomUserDetailsService, UserRegistrationService (Faz 138), QuizDefinitionService
                     (Quiz Area draw -- Faz 139), QuizNavigationService (Quiz Area sidebar nav -- Faz 139),
                     QuestionReviewService (listeleme + publish/reject, `status='PENDING_REVIEW'`
                     dışında 409 -- Faz 141/142), GenerationToolingService (salt-okunur, n8n'in
                     soru üretim workflow'u için topic metadata/içerik/mevcut-soru okuması --
                     hiçbir Question YAZMAZ, Faz 146)
    controller/      HomeController, TopicController, PracticeController, QuestionIngestController,
                     AuthController (login/register sayfaları -- Faz 138), QuestionReviewController
                     (ADMIN-only: `GET /{lang}/admin/questions`, `POST .../{id}/publish`,
                     `POST .../{id}/reject` -- Faz 141/142), GenerationToolingController
                     (salt-okunur `/api/internal/topics/{slug}[/content]` +
                     `/api/internal/questions/existing` -- Faz 146; `/api/internal/
                     questions/for-translation` -- Faz 148)
    config/          LangParamLocaleResolver, WebConfig, QuizIngestApiKeyInterceptor (ingestion
                     rotasını X-Api-Key ile korur), SecurityConfig (Faz 141'den itibaren
                     `/{lang:en|tr}/admin/**` → `hasRole("ADMIN")` kuralı da içeriyor), LangPath (Faz 138)
    web/nav/         Sidebar/anasayfa navigasyon DTO'ları (CourseNav, QuizNav -- Faz 139)
    web/quiz/        Sabit quiz + Practice GET/submit DTO'ları (QuizQuestionView, QuestionView,
                     QuizAnswer, QuizSubmitRequest/Response, PracticeSubmitRequest/Response, ...)
    web/ingest/      AI ingestion istek/yanıt DTO'ları (QuestionIngestRequest/Option/Response)
    web/auth/        Kayıt formu bağlama DTO'su (RegisterForm -- Faz 138)
    web/review/      Question Review DTO'su (QuestionReviewView + nested ReviewOptionView --
                     `correct` alanını BİLİNÇLİ OLARAK gizlemiyor, public DTO'ların aksine -- Faz 141;
                     `questionDisplayText()` -- CODE_OUTPUT'ta `question`'a AI'nın yanlışlıkla
                     gömdüğü fenced kod bloğunu sunumdan düşüren türetilmiş görünüm metodu,
                     DB'ye hiç dokunmaz -- Faz 147)
    web/internal/    Generation tooling DTO'ları (TopicMetadataResponse, ExistingQuestionView --
                     Faz 146; TranslationSourceQuestionView -- EN->TR çeviri workflow'u için
                     tam soru+şık verisi, `source` alanı dahil -- Faz 148)

src/main/resources/
    content/{tr,en}/{slug}.md     Ders içerikleri (tek doğruluk kaynağı)
    examples/{slug}/*.java        Gerçek, derlenebilir kod örnekleri
    db/migration/{konu-slug}/     Flyway migration'ları, konu bazlı alt klasörlerde (V1..V430,
                                   quiz-area/ -- Faz 139, question-promotion/ -- promotion
                                   script'inin ürettiği migration'lar için, Faz 143)
    templates/                    Thymeleaf şablonları (Bootstrap + highlight.js)
    templates/auth/               login.html / register.html (Faz 138)
    templates/admin/              question-review.html -- ADMIN-only, Publish/Reject artık
                                   gerçek CSRF-korumalı POST formları (Faz 141/142)
    static/css/custom.css         Sidebar accordion (.sidebar-toggle/.chevron) dahil özel stiller
    static/img/                   LearnForgeX marka varlıkları (favicon.svg/logo.svg/logo-dark.svg,
                                   favicon.ico/-16.png/-32.png, apple-touch-icon.png -- Faz 48)
    messages*.properties          Arayüz metni çevirileri
```

scripts/
    export_approved_questions.py  Development→Production question promotion export --
                                   yalnızca AÇIK dev question id listesi, salt-okunur,
                                   production'a bağlanamaz (bkz. Faz 143)
    export-approved-questions.sh  Yukarıdakinin ince CLI sarmalayıcısı

n8n/
    workflows/question-ingestion-test-batch.json  Manual Trigger → Code → HTTP Request
                                   (var olan Ingestion API'ye POST) -- PostgreSQL'e/prod'a
                                   hiç bağlanmıyor (bkz. Faz 145)
    workflows/question-generation-enum-test.json  9 düğümlü büyük ölçekli soru üretim
                                   pipeline'ı (Topic Selection → ... → Record Results) --
                                   Faz 147'de gerçek OpenAI'a geçirildi, Faz 148'de
                                   varsayılana (hem EN hem TR, hesaplanmış soru sayısı)
                                   döndürüldü
    workflows/question-translation-en-to-tr.json  8 düğümlü EN->TR çeviri pipeline'ı --
                                   mevcut PUBLISHED/PENDING_REVIEW EN sorularını çevirir,
                                   `correct`/tip/zorluk/kod/topic'i hiç değiştirmez
                                   (bkz. Faz 148)
    README.md                     Kurulum/çalıştırma talimatı (env değişkenleri, n8n CLI)

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
- **GÜNCELLEME (Faz 140):** `mvn -o compile`/`mvn -o test`'in Lombok'u offline
  hiç işleyememesi (aşağıdaki madde) bir Maven/plugin-çözümleme sorunu -- Lombok'un
  KENDİSİ değil. `~/.m2`'de ZATEN cache'lenmiş bağımlılıklarla, `javac`'ı Lombok
  jar'ını `-processorpath`+`-proc:full` ile DOĞRUDAN çağırmak GERÇEK bir derleme
  (main+test, sıfır hata) üretiyor -- bu classpath'le testler de (`junit-platform-
  launcher` ile) ve hatta uygulamanın kendisi de (`java -cp ... 
  LearningPlatformApplication`, gerçek Tomcat+Postgres+Flyway) GERÇEKTEN
  çalıştırılabiliyor, `curl` ile uçtan uca doğrulama dahil. Ayrıntılı komut
  tarifi için `docs/known-constraints.md`'de "Faz 140"ı grep'le -- bu, önceki
  "mvn kullanılamaz" sonucunu geçersiz KILMIYOR, yalnızca bir workaround'un var
  olduğunu belgeliyor; kullanıcının kendi `mvn clean test`'i hâlâ nihai kaynak.
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
