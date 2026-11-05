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
- **"Beklenen Çıktı" paneli (Faz 177):** bir `.java` gömmesinin yanında
  `examples/{slug}/{Ad}.out` varsa kod bloğunun altında programın gerçek stdout'u
  gösterilir. `.out` ELLE YAZILMAZ ve elle düzeltilmez: yalnızca
  `scripts/example_outputs.py generate` (izole Docker, sabit imaj digest'i) üretir,
  insan incelemesinden sonra `promote` yayına taşır ve
  `scripts/example-outputs/manifest.tsv`'ye hash'leriyle yazar. Çıktısı Java API
  sözleşmesiyle sabit olmayan örnekler (HashMap/HashSet sırası, paralel stream,
  thread, zaman, rastgelelik, ağ/süreç/ortam değişkeni) çalıştırmada aynı çıksa bile
  panele ALINMAZ. Dosya kullanan örnekler YALNIZCA kendi oluşturdukları dosyaları
  göreli adla, çalışma dizininin içinde okuyup yazıyorsa panele girebilir: her çalıştırma
  temiz, boş ve izole bir çalışma dizininde başlar (sandbox'ın kendi `/tmp`'si; derlenmiş
  sınıflar onun dışında, salt okunur), panel de o dizindeki İLK çalıştırmayı gösterir --
  okuyucunun dizininde önceden var olan dosyalar varsayılmaz. Mutlak, `~`'li ya da `..`
  ile dışarı çıkan yollar, `toAbsolutePath()` gibi makineye göre değişen yol metinleri,
  `createTemp*` adları, sıralanmamış dizin listeleri (`Files.list/walk/find`), dosya
  zamanı/sahibi/izinleri ve Javadoc'ta "optional specific exception" olan
  `java.nio.file` istisnalarına (`NoSuchFileException`, `FileAlreadyExistsException`
  vb.) dayanan dallar ENGELLİ kalır (`scripts/example_outputs.py`, `CONTRACT_FLAGS`).
  Satır sonu Linux `\n`'dir; `newLine()`/`Files.write(path, lines)` yalnızca not düşer.
  Aynı dersin başka dosyasındaki tipi kullanan örnek o dosyayla (companion, zincirleme
  bulunur) birlikte derlenir: tip derste tam bir dosyada tanımlı olmalı, yoksa örnek
  `MULTI_FILE` kalır; companion'ın JDK dışı import'u ve sözleşme bayrakları örneğe de
  uygulanır, hash'i manifest'in `companions` sütununa yazılır.
  `ExampleOutputManifestTest`, `.out`'u olan bir `.java` ya da companion'ı değişince
  build'i kırar: çıktıyı yeniden üret + incele ya da `.out`'u ve manifest satırını sil.
  Panel eklemek sayfada görünen örneği değiştirdiği için iki dilin `updated_at`'ini de ilerletir
  (aşağıdaki tarih kuralı, örn. `functional-interfaces-streams/V1139`). Dalga akışı
  (Faz 178): `generate --topic SLUG [--dry-run]` → kullanıcı `review.tsv`'de her
  örneğe ayrı `approve`/`reject` verir → `promote --review` (tek hata varsa hiçbir
  dosya yazılmaz); çalıştırmadan önce `--dry-run` listesi gösterilir. Staging (Faz 180'den
  beri) kökteki git-ignored `.example-outputs/` dizinidir, `target/` DEĞİL -- herhangi bir
  oturumun `mvn clean`'i incelenmemiş çıktıları silmesin diye; `StagingLocationTest` bunu korur.
- **DB ↔ dosya bağlantısı yalnızca slug convention ile kurulur**, path hiçbir zaman
  DB'de saklanmaz: `content/{language}/{topic.slug}.md` ve
  `examples/{topic.slug}/{example_name}.{ext}`.
- **Yayın durumu çeviri seviyesindedir:** `Topic`'te `published` yok,
  `TopicTranslation`'da var — bir dil yayında, diğeri taslak olabilir (örn. TR yayında,
  EN henüz taslak). Yeni bir konu eklerken önce TR'yi `published = true`, EN'i
  `published = false` olarak ekle; EN çevirisi bitince ayrı bir migration'la yayına al.
- **Her çevirinin iki tarihi vardır: `topic_translation.published_at` ve `updated_at`
  (`DATE`, `core/V1137`).** `updated_at` ders sayfasındaki "Son güncelleme" satırını,
  JSON-LD'deki `dateModified`'ı ve sitemap'teki `<lastmod>`'u besler. `published_at`
  HİÇBİR YERDE YAYINLANMAZ (sayfada, JSON-LD'de `datePublished` olarak ya da sitemap'te) —
  yalnızca iç kayıttır; gerçek yayın tarihini garanti etmediği için bilinçli bir karar,
  `datePublished` EKLEME. Bu tarihler
  OTOMATİK DEĞİLDİR: git'ten ya da çalışma anında türetilmez, yalnızca migration'la
  değişir (içerik dosyada yaşadığı için DB satırı kendiliğinden değişmez). Kurallar:
  (1) Bir dersin gövdesi (`content/{lang}/{slug}.md`) ya da sayfada görünen örnek kodu
  (`examples/{slug}/*`) ANLAMLI biçimde değişirse, aynı commit'te o slug + dil için
  `updated_at`'i AÇIK bir tarihle (`DATE '2026-11-03'` gibi) ilerleten bir migration
  yaz. Metin değişikliği yalnızca kendi dilini, örnek kod değişikliği (dosyalar ortak
  olduğu için) iki dili de ilerletir. Yazım hatası, `seo_title`/`seo_description`,
  şablon ve stil değişiklikleri tarihi DEĞİŞTİRMEZ. (2) Yeni ders migration'larının
  `INSERT`'i değişmeden çalışır: iki kolon `DEFAULT CURRENT_DATE` taşır, yani tarih
  migration'ın o ortamda uygulandığı gün olur. (3) EN çevirisi sonradan yayına alınırken
  (`publish_{slug}_english` migration'ı) `updated_at` yayın günüyle AÇIKÇA yazılır —
  taslak satır eklendiği günün tarihini taşır. (4) `published_at` bir
  kez yazıldıktan sonra değiştirilmez; `updated_at >= published_at` DB kısıtıdır.
  Mevcut 336 çevirinin `published_at` değeri dosyanın git'teki İLK COMMIT tarihidir,
  sitenin gerçek yayın tarihi değildir (bkz. `docs/google-seo-adsense-plan.md`).
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
- **Flyway placeholder değiştirme KAPALIDIR** (`application.yml`:
  `spring.flyway.placeholder-replacement: false`; dev/prod/test profilleri geçersiz
  kılmaz) — migration dosyalarında (yorum satırları dahil) literal `${...}`
  kullanılabilir. Bu ayarı açmadan ya da bir profilde değiştirmeden önce
  `grep -rl '\${' src/main/resources/db/migration` ile migration'ları tara ve etkisini
  değerlendir: ayar açıkken eşleşen her `${...}` "No value provided for placeholder"
  hatasıyla **tüm uygulamanın başlamasını engeller**. Gerekçe ve geçmiş:
  `docs/architecture-rationale.md` §2.
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
  MANUAL/CLAUDE/N8N/OPENAI) taşıyan genel bir havuz sorusu. Eski `QuizOption` →
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
  doğru cevabı KABUL ETMEZ). **AI/n8n ingestion, insan incelemesi ve
  auto-publish** için aşağıdaki "Ingestion", "Question Review" ve "Auto-publish"
  maddelerine bak. **Şema (`V287`-`V293`, core/enum alt klasörlerinde):**
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
  anasayfa ve tüm kursların ders içeriği anonim erişime tamamen açık kalır.
  GÜNCELLEME (Faz 160/161): Java DIŞINDAKİ kursların quiz'leri ve Practice'i
  giriş gerektiriyor** (aşağıdaki Faz 160 maddesine bakın). Spring Security, session-based form
  login — JWT/token tabanlı oturum bilinçli olarak kullanılmıyor (sunucu tarafında
  render edilen bir Thymeleaf uygulaması için gereksiz karmaşıklık olurdu); Faz
  185'teki Google girişi kimliği OAuth2/OIDC ile doğrular, oturum yine
  session-based kalır (aşağıdaki "Google ile devam et" maddesine bakın). Kullanıcı
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

- **"Google ile devam et" (Faz 185) aynı session modeline eklenen ikinci giriş yolu,
  token tabanlı oturum DEĞİL.** Google hesabı `user_identity.provider_subject` (`sub`)
  ile tanınır, e-postayla DEĞİL; principal'ın `getName()`'i her giriş yolunda YEREL
  e-postadır ve yetki YALNIZCA `app_user.role`'den gelir (`LocalOidcUser`,
  `GoogleAccountService`). E-postası eşleşen mevcut hesap ASLA otomatik bağlanmaz
  (kayıtta e-posta doğrulanmıyor) -- o hesabın şifresi istenir; yeni Google hesabı
  Kullanım Koşulları kutusu işaretlenmeden açılmaz. ADMIN hesabı Google'la bağlanamaz
  ve giriş yapamaz (kural tek yerde: `GoogleAccountService.allowsGoogleSignIn`). Bağlı
  olmayan doğrulanmış kimlik giriş SAYILMAZ, session'da bekler (`PendingGoogleSignIn`,
  10 dk). İstemci yalnızca `GOOGLE_CLIENT_ID`/`GOOGLE_CLIENT_SECRET` verilince kurulur,
  yoksa buton gizli. Prod session çerezi `SameSite=Lax` KALMALI (Strict Google dönüşünü
  kırar). E-posta kayıtta, Google eşleştirmesinde ve şifreyle girişte AYNI kuralla
  (`UserRegistrationService.normalizeEmail`: `trim()` + `toLowerCase(Locale.ROOT)`)
  normalize edilir -- yeni bir e-posta araması da bunu kullanmalı. **Durum (2026-10-24):**
  kod `4f623e3` ile canlıda (V1148 uygulandı) ama Google girişi KAPALI -- Railway'de
  `GOOGLE_*` yok, düğme görünmüyor, şifreyle giriş aynen çalışıyor; prod istemcisiyle gerçek
  uçtan uca test YAPILMADI; F2/F5/F6 açık. Açmak için: Google Console'da prod OAuth istemcisi
  (redirect birebir `https://www.learnforgex.com/login/oauth2/code/google`, izin ekranının
  yayın durumu kontrol edilir), Railway'e İKİ değişkeni BİRLİKTE ekle (yalnızca client-id
  verilirse uygulama açılmaz), yeniden deploy, sonra canlıda yeni hesap + bağlama + ADMIN
  reddi denenir. **Güncelleme (2026-10-25, production):** yukarıdaki "KAPALI" durumu artık güncel
  değil -- kullanıcı gerçek Google hesabıyla prod'da test etti: Google ile yeni hesap açma, Google
  ile giriş ve mevcut hesabı bağlama çalıştı, sayfa yenilenince oturum korundu, çıkış/giriş de
  denendi. OAuth istemcisi ve Railway ayarları bu oturumda okunmadı. **Güncelleme (2026-10-25,
  ADMIN erken reddi):** e-postası bir ADMIN hesabına ait, henüz bağlı olmayan Google kimliği artık
  parola isteyen bağlama sayfasından ÖNCE reddediliyor (`GoogleOidcUserService.loadUser` +
  `GoogleSignInController.render`, ikisi de `GoogleAccountService.isGoogleSignInBlockedForEmail`
  üzerinden `allowsGoogleSignIn`'e soruyor) -- F6'nın ADMIN kısmı kapandı, şifresiz hesap kısmı
  açık; tam suite 306/306. Bu düzeltme henüz production'a deploy edilmedi ve gerçek Google OAuth
  ile doğrulanmadı. **Güncelleme (2026-10-25, sonra):** `7c5e12d` canlıda (deployment `6012f866`);
  ADMIN hesabıyla gerçek Google girişi parola sayfasına girmeden reddedildi (deploy logunda
  `google_admin_not_allowed`). `linkUnavailable` mesajı rolü/nedeni söylemeyen genel bir cümleye
  çevrildi, eşleme ve EN/TR metni testli (309/309); bu mesaj değişikliği henüz canlıda değil.
  Ayrıntı: `docs/phase-log.md` "185".
- **Course seviyesi erişim kuralı (Faz 160, Faz 161'de DARALTILDI): ders içeriği
  (topic sayfası + PDF) TÜM kurslarda anonim okumaya açıktır; giriş yalnızca Java
  DIŞINDAKİ kursların etkileşimli özellikleri (sabit quiz, Quiz Area, Practice)
  için gerekir.** Faz 161'deki daraltma bilinçli bir SEO/AdSense kararı (bkz.
  `docs/google-seo-adsense-plan.md`) -- ders sayfaları yanlışlıkla yeniden login
  arkasına ALINMAMALI, aksi hâlde arama motorları içeriğin çoğunu göremez. Kuralın
  TEK kaynağı `config/CourseAccessPolicy` -- "java herkese açık" bilgisi
  controller/template/serviste TEKRAR YAZILMAZ, hepsi policy'ye sorar. Zorlama iki
  katmanda: course'u URL'den belirlenebilen rotalar
  (`/{lang}/topics/{slug}/quiz/**` -- sabit quiz submit;
  `/{lang}/quiz/{definitionSlug}[/**]` -- Quiz Area) `SecurityConfig`'te policy'nin
  `AuthorizationManager`'larıyla; course'u istek gövdesinden/havuzdan belirlenen
  yerler (`PracticeService.draw`/`submit`) serviste, soru içeriği
  yüklenmeden/puanlamadan ÖNCE. Anonim + korunan sayfa GET (Quiz Area) → login'e
  302; anonim + korunan JSON uç noktası (3 submit + `/{lang}/practice`) →
  gövdesiz, yönlendirmesiz 401. Anonim bir ziyaretçi Java dışı bir topic
  sayfasında quiz sorularını GÖRMEZ (`TopicController` soruları hiç yüklemez,
  `quizLocked` ile bir giriş çağrısı gösterilir). Menüde kurs/konu linkleri
  herkese açık; kilitli Quiz Area grupları GİZLENMEZ, `QuizNav.accessible()` ile
  devre dışı çizilir. Sitemap yayındaki TÜM kursların topic'lerini listeler.
  Quiz/soru içeriğini yeni bir yoldan açığa çıkaran bir rota/özellik eklenirse
  AYNI policy'ye bağlanmalı (ayrıntı: `docs/phase-log.md` "Faz 160", "Faz 161").

- **Ingestion (`POST /api/internal/questions/ingest`):** `QuizIngestApiKeyInterceptor`
  yalnızca `/api/internal/**` için `X-Api-Key` ister (sabit-zamanlı karşılaştırma; anahtar
  `quiz.ingest.api-key`/`QUIZ_INGEST_API_KEY` env'den). Anahtar YAPILANDIRILMAMIŞSA `503`
  (fail-closed), anahtar yanlışsa `401`. Bu yol CSRF'den muaftır, yani tek kapı interceptor'dır.
  `QuestionIngestRequest`'te `status` alanı BİLİNÇLİ OLARAK YOKTUR: sunucu her soruyu
  `PENDING_REVIEW` ile kaydeder ("sunucu ezer" kuralı DTO tasarımına dayanır).
  `source` alanı VARDIR ve zorunludur (eksik/boş → `400`); değeri `QuestionSource` izin
  listesinden (`MANUAL`, `CLAUDE`, `N8N`, `OPENAI`) biri olmalıdır, dışı `400`. `source`
  denetim amaçlıdır, hiçbir yetki kararını etkilemez. Tip başına doğru şık sayısı burada
  doğrulanır: SINGLE_CHOICE/CODE_OUTPUT tam bir, MULTIPLE_CHOICE en az bir (tam iki gibi
  bir zorunluluk YOKTUR).
- **Question Review (insan incelemesi):** `/{lang:en|tr}/admin/**` (yalnızca Question
  Review değil, TÜM admin rotaları) `SecurityConfig`'te `hasRole("ADMIN")` ile korunur;
  yetki yalnızca `app_user.role`'den gelir (`ROLE_` + rol adı). Kod hiçbir yerde ADMIN
  atamaz (kayıt ve Google yolu hep `Role.USER`); ADMIN yükseltmesi kod dışında elle
  yapılır, rol-yönetim arayüzü ya da migration'ı yoktur. `GET .../admin/questions`
  yalnızca `PENDING_REVIEW` soruları listeler ve doğru şıkkı ADMIN'e gösterir (public
  DTO'lardan farklı, bilinçli). `POST .../admin/questions/{id}/publish|reject`
  (`QuestionReviewService`) yalnızca `PENDING_REVIEW`'dan geçişe izin verir: başka
  durumdaki ya da eşzamanlı güncellenmiş soru `409` alır ve değişmez; `reviewed_by`
  (oturumdaki kullanıcı) ve `reviewed_at` doldurulur. Bunlar gerçek tarayıcı formlarıdır
  ve CSRF'ye muaf DEĞİLDİR (muaf liste yalnızca `/api/internal/**` ile üç quiz/practice
  submit yoludur); formlar `_csrf` token'ı taşır. `PUBLISHED` yapmak soruyu public havuza
  sokar ama hiçbir sabit quiz'e eklemez (yukarıdaki Faz 87 maddesi).
- **Auto-publish (Question Review'dan AYRI bir mekanizma):** `POST
  /api/internal/questions/{id}/auto-publish`, n8n'in AI Judge yolu içindir, bir insan
  formu değildir. Aynı `X-Api-Key` interceptor'ı korur VE ikinci bir anahtar gerekir:
  `quiz.auto-publish.enabled` (`QUIZ_AUTO_PUBLISH_ENABLED`), varsayılan `false`; kapalıyken
  uç nokta `503` döner. Durum geçişi insan Publish/Reject'iyle AYNI
  `QuestionReviewService.transition()` kuralını kullanır (yalnızca `PENDING_REVIEW`,
  aksi `409`); `reviewed_by` sabit `n8n-ai-judge`'dır. Yeni bir yayın yolu eklenirse bu
  iki mekanizmayı karıştırma: ikisi de aynı geçiş kuralına bağlanmalı.
- **Promotion (dev → prod):** yeni soru ÜRETİMİ/incelemesi hiçbir zaman migration olmaz;
  yalnızca promotion migration'dır (`db/migration/question-promotion/`, her zaman
  `status='PUBLISHED'`). `scripts/export_approved_questions.py` yalnızca AÇIK dev
  `question.id` listesiyle çalışır (asla "tüm PUBLISHED"); listedeki tek bir soru bile
  `PUBLISHED` değilse TÜM parti iptal edilir; var olan migration dosyasının üzerine yazmaz.
  Script hiçbir veritabanına YAZMAZ: yalnızca `EXPORT_SOURCE_DB_*` ile verilen sunucuya
  `psql` ile SELECT atar (varsayılan yerel dev). Host izin listesi ya da salt-okunur
  doğrulaması YOKTUR: bu değişkenler bilerek prod'a ayarlanırsa script oradan okur.
  Değişken adları, prod'un `DB_URL`/`DB_USERNAME`/`DB_PASSWORD`'ünden kasıtlı olarak
  farklıdır; koruma kazara kimlik bilgisi devralmaya karşıdır. Prod'a yazma yalnızca
  üretilen migration'ın normal deploy'da Flyway ile uygulanmasıyla olur. Tekrar-promote
  önleme bir SÜREÇ sorumluluğudur (migration başlığındaki dev id listesi); `promoted_at`
  kolonu ya da unique constraint YOKTUR (migration ve Java kodunda doğrulandı, canlı DB
  sorgulanmadı). Gerekçe: `docs/architecture-rationale.md`.
- **n8n sınırı ve soru üretimi:** n8n Postgres'e, prod'a ya da dosya sistemine DOĞRUDAN
  bağlanmaz; yalnızca `/api/internal/**` HTTP uç noktalarını `X-Api-Key` ile çağırır:
  ingestion, salt-okunur okumalar (`GenerationToolingController`: topic metadata/içerik,
  mevcut sorular, çeviri adayları; hiçbir `Question` yazmaz) ve bayrakla kapalı
  auto-publish. Workflow'larda `retryOnFail: false` (retry duplicate yaratabilir) ve API
  anahtarı `$env`'den okunur, dosyaya yazılmaz; ayrıntı `n8n/README.md`. Üretimde H2
  başlıkları konunun kavramsal KAPSAMINI tanımlar, kelime-eşleşme şartı DEĞİLDİR: içerik
  uyumu prompt'un gerçek ders metnine topraklanmasıyla sağlanır, `Validate Output`
  yalnızca YAPISAL doğrulama yapar.
- **CODE_OUTPUT soruları:** kod YALNIZCA `codeSnippet` (+ `codeLanguage`) alanında tutulur,
  `question` metninde fenced blok olarak tekrarlanmaz. Tekrarlanmışsa admin ekranında
  `QuestionReviewView.questionDisplayText()` bunu yalnızca SUNUMDA düşürür, DB'deki
  `question` sütunu değişmez.

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
AYNEN kullanır (draw tarafı yeni, submit tarafı Practice ile paylaşılan).
`java` kursu için gerçek seed (`basic-java`=`java-basics`+`control-flow`,
`advanced-java`=`exceptions`+`generics`+`collections`+`oop`+`concurrency`+
`functional-interfaces-streams`, `all-java`=tüm kurs) V430'da eklendi;
`spring-boot` ve `ai` kursları için seed'ler sonradan eklendi;
`react`, `postgresql`, `git-github` ve `docker` kurslarının henüz bir
`quiz_definition` seed'i yok (migration taraması, 2026-11-05). Soru
çekme/cevap gönderme UI'ı vardır (`quiz-play.html`, CSRF muafiyetli submit rotası). Ayrıntılı uygulama akışı için
`docs/phase-log.md`'de "Faz 139"u grep'le.

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

**Quiz sorusu eklemek:** `.claude/skills/quiz-questions` skill'i tek doğruluk kaynağıdır
(4-7 çift, `INSERT INTO quiz` shell kontrolü, `NOT EXISTS`/`ON CONFLICT DO NOTHING` link
migration'ları, auto-publish ve diğer yayın yolları, MULTIPLE_CHOICE kuralı). Skill'siz de
unutulmaması gereken kural: bir topic'e quiz sorusu eklemeden önce o topic'in var olan
migration'larında `grep -rl "INSERT INTO quiz"` ile quiz shell'inin zaten eklenip eklenmediğini
tara; ekleniyorsa shell migration'ı yazma (`duplicate key` hatası). Kurs bazlı kapsam ve
tarihçe: `docs/phase-log.md` (Faz 150, Faz 155-159); shell hatasının hikâyesi:
`docs/known-constraints.md` ("Faz 157").

**GÜNCELLEME (Faz 154):** java/spring-boot/react/ai/postgresql/git-github'den
sonra YEDİNCİ Course olarak **`docker` kursu eklendi** (`course.sort_order=7`)
-- Java/Spring Boot'u zaten bilen ama Docker'ı bilmeyen bir geliştirici için,
yalnızca komut listesi değil Docker'ın gerçek Java geliştirme akışına nasıl
oturduğunu öğreten bir müfredat. **2 kategori, 9 topic, hepsi TR+EN, tek
seferde tüm kurs değil topic-topic kullanıcı onayıyla inşa edildi**
(kullanıcının açık pacing kararı, postgresql/git-github'daki desenle aynı):
`docker-fundamentals` (sort_order=1, 4 topic -- `what-is-docker`,
`docker-cli-fundamentals`, `docker-images-and-dockerfiles`,
`dockerizing-a-spring-boot-application`) ve `docker-in-practice`
(sort_order=2, 5 topic -- `docker-networking`, `docker-volumes`,
`docker-compose`, `production-docker-for-java-applications`,
`docker-practical-project`). Migration'lar V493-V519 (course+category+topic
shell → code_example/quiz-shell sections → publish-english, git-github'ın
V432/V433/V434 üçlü-dosya deseninin BİREBİR aynısı; `docker-networking`'in
V505'i AYRICA 2. kategoriyi de kuruyor, `rebase-and-squash`'ın V450'siyle
aynı desen). **İçerik bu projenin kendi gerçek gerçeklerine sıkı sıkıya
topraklandı** -- jenerik Docker örnekleri değil: `pom.xml`'deki gerçek
coordinate'ler (`com.cdurgun:learning-platform:0.1.0-SNAPSHOT`, Java 21),
`application-prod.yml`'in kendi gerçek yorumu (sırların ortam
değişkenlerinden okunması), ve Spring Data JPA kursundaki gerçek topic
başlıklarına ("Entities and the Repository Abstraction", "JPA, Hibernate,
and Spring Data JPA") doğrulanmış çapraz referanslar. `docker-practical-
project` (kapanış dersi), React kategorilerinin ayrı-repo/tag konvansiyonu
(Faz 30) yerine BİLİNÇLİ OLARAK gömülü kaldı -- deliverable config + küçük
bir uygulama olduğu için, ayrı bir build/tag yaşam döngüsü gerektiren bir
client-side proje değil; kendi self-contained "task tracker" Spring Boot +
PostgreSQL uygulaması (tek dosyada nested `@Entity`/`Repository`/
`@RestController`, bu kodun kendi çok-sınıflı örnek konvansiyonuyla aynı,
bkz. `EnumeratedFieldExample.java`), kursun her önceki dersinin (multi-stage
build, non-root user, `HEALTHCHECK`, named volume, otomatik networking,
sağlık-koşullu `depends_on`) üzerine hiçbir yeni mekanizma eklemeden inşa
ediyor. **Kullanıcının ayrı bir "full-course review" isteği üzerine
kapsamlı, salt-okunur bir doğrulama geçişi yapıldı** (migration sıralaması,
FK çözümlemesi, quiz shell tutarlılığı, `code_example`↔`{{}}` embed 1:1
karşılığı, TR/EN self-reference doğruluğu, script reproducibility) ve GERÇEK
4 sorun bulundu/düzeltildi: (1) `docker-images-and-dockerfiles`'ta 2
`code_example` satırı (`CmdOnlyDockerfile`, `EntrypointDefaultCmdDockerfile`)
hiçbir `{{}}` embed'ine karşılık gelmiyordu -- CMD vs ENTRYPOINT içeriği
yanlışlıkla elle tekrar yazılmıştı, gerçek embed'lerle değiştirildi; (2)
`docker-cli-fundamentals`'ta iki kesik self-reference (`docker stop`/`docker
start` ve `docker ps` komut soneki eksikti); (3)
`production-docker-for-java-applications`'ta bir kesik self-reference
(`(Layer Caching)` soneki eksikti); (4) `docker-volumes`'un
`VolumePersistenceDemo.sh`'ı, kendi oluşturmadığı bir `--network`'e bağımlıydı
-- temiz bir ortamda tek başına çalıştırılırsa başarısız olurdu, flag
kaldırıldı. **Bu geçişte ayrıca bu sandbox'ta GERÇEKTEN çalışan bir Docker
Engine olduğu keşfedildi** (`docker --version` → 29.6.2, ZATEN çalışan
gerçek container'lar: `postgres:16-alpine` adıyla `learning-platform-db`,
ve n8n) -- bkz. `docs/known-constraints.md` "Faz 154", bu daha önce hiç
doğrulanmamış, gelecekteki Docker kursu bakımı için önemli bir yetenek.
Tüm değişiklikler tek bir commit'te (`17531cb`) birleştirildi -- projenin
iki önceden var olan ilgisiz untracked dosyası (`AGENTS.md`,
`scripts/promote-published-questions.sql`) BİLİNÇLİ OLARAK commit'e dahil
edilmedi. Ayrıntılı uygulama akışı için `docs/phase-log.md`'de "Faz 154"i
grep'le.

## Dokümanlar ve Skill'ler

Bu dosya yalnızca KURALLARI taşır; gerekçe, tarihçe ve işletim adımları aşağıdaki dosyalardadır.
Hiçbiri otomatik yüklenmez: göreve göre `grep` ile ara, baştan sona `Read` ile okuma.

- `docs/phase-log.md` -- tamamlanan fazların tablosu (konu/kategori adı, migration deseni, daha önce
  çözülmüş hata sınıfı). Yeni bir karardan önce burada ara.
- `docs/known-constraints.md` -- kısıtların tam kronolojik geçmişi ve workaround tarifleri.
- `docs/architecture-rationale.md` -- Mimari kuralların NEDENİ (kuralın kendisi burada, Mimari'de).
  Başlıklar: çeviri tarihleri (`published_at`/`updated_at`), Flyway `${...}`, "Beklenen Çıktı"
  sözleşmesi (bayrak tabloları dahil), Internal API ve `X-Api-Key`, dev -> prod promotion,
  Google hesap bağlama politikası, soru havuzu ve yayınlama. İlgili kuralı değiştirmeden önce oku;
  `scripts/example_outputs.py` davranışı değişirse "Beklenen Çıktı" bölümü de gözden geçirilmeli.
- `docs/google-sign-in-operations.md` -- Google girişini açma/yeniden kurma runbook'u (kural değil).
- `docs/google-seo-adsense-plan.md` -- SEO/AdSense yol haritası ve kararları (ders sayfalarının
  anonim açık kalması gerekçesi dahil).
- `docs/deepseek-ai-tutor-plan.md` -- AI Tutor mimarisi ve devreye alma planı; güncel durum için
  planın kendisine bak, burada tarihli durum tutulmaz.
- `docs/mcp-server-plan.md`, `docs/skills-plan.md`, `docs/ProjectPlan.md` -- ilgili plan dokümanları.
- `n8n/README.md` -- n8n workflow'larının kapsamı ve çalıştırılması.
- Skill'ler (`.claude/skills/`): `content-check` (ders içeriğini yalnızca raporlar: bölüm atıfları,
  `{{Dosya.ext}}` gömmeleri, migration'lar, SEO uzunlukları; içerik değişikliğinden sonra, commit'ten
  önce), `deploy-check` (push'tan sonra canlı site ve Railway deployment kontrolü),
  `quiz-questions` (bir topic'e quiz sorusu ve migration'ları yazma).

## Proje Yapısı

Aşağıdaki liste yönlendirme içindir, tam sınıf listesi değildir; ayrıntı için dizine bak.

```
src/main/java/com/cdurgun/learning/
    domain/          JPA entity'leri ve enum'lar: Course > Category > Topic > TopicTranslation,
                     CodeExample; soru havuzu (Question, QuestionOption, QuestionType/Status/Source),
                     Quiz + QuizQuestion (Quiz<->Question join/sıra entity'si), QuizDefinition
                     (Quiz Area kapsam tanımı); User, Role, UserIdentity (kimlik doğrulama/Google);
                     AiUsageLog (AI Tutor); converter/ (Language <-> DB tr/en kodu)
    repository/      Spring Data JPA repository'leri
    service/         İçerik ve render: ContentResolver, CodeExampleResolver, MarkdownService,
                     NavigationService, PdfExportService. Quiz: QuizService (sabit quiz),
                     PracticeService (soru havuzu), QuestionScorer (paylaşılan puanlama),
                     QuizDefinitionService + QuizNavigationService (Quiz Area).
                     Soru hattı: QuestionIngestService, QuestionReviewService (listeleme +
                     publish/reject + auto-publish geçişi), GenerationToolingService
                     (n8n için salt-okunur okuma, hiçbir Question YAZMAZ).
                     Kimlik: CustomUserDetailsService, UserRegistrationService,
                     GoogleAccountService, GoogleOidcUserService. ai/ = AI Tutor
    controller/      HomeController, CourseController, TopicController, PageController,
                     SitemapController, PracticeController, QuizAreaController, AuthController,
                     GoogleSignInController, AiTutor*Controller; soru hattı:
                     QuestionIngestController, QuestionAutoPublishController,
                     QuestionReviewController (ADMIN-only), GenerationToolingController
    config/          SecurityConfig, CourseAccessPolicy, GoogleSignInConfig, WebConfig,
                     LangParamLocaleResolver, LangPath, QuizIngestApiKeyInterceptor
                     (`/api/internal/**` için X-Api-Key), AiTutor* yapılandırması
    web/             DTO'lar, alan başına alt paket: nav/ (CourseNav, QuizNav), quiz/, ingest/,
                     publish/, internal/, review/ (QuestionReviewView -- `correct` alanını
                     BİLİNÇLİ OLARAK gizlemez, ADMIN görünümü), auth/, ai/

src/main/resources/
    content/{tr,en}/{slug}.md     Ders içerikleri (tek doğruluk kaynağı)
    examples/{slug}/*.java        Gerçek, derlenebilir kod örnekleri (+ üretilmiş `.out` dosyaları)
    pages/{en,tr}/               Statik sayfalar (about, contact, privacy, terms)
    fonts/                        PDF dışa aktarımı için DejaVu fontları
    db/migration/{konu-slug}/     Flyway migration'ları, konu bazlı alt klasörlerde
                                   (quiz-area/, question-promotion/, auth/, ai-tutor/ dahil)
    templates/                    Thymeleaf şablonları; auth/ (login/register), admin/
                                   (question-review.html -- CSRF'li POST formları), fragments/, error/
    static/                       css/ (custom.css), js/, img/ (LearnForgeX marka varlıkları,
                                   favicon'lar, og-image), robots.txt
    messages*.properties          Arayüz metni çevirileri
    application*.yml              Yapılandırma (dev/prod/test profilleri)

scripts/
    example_outputs.py            "Beklenen Çıktı" üretim/inceleme/promote aracı
    example-outputs/              manifest.tsv ve Python testleri (bkz. Mimari, "Beklenen Çıktı")
    export_approved_questions.py  Dev -> prod soru promotion export'u: yalnızca AÇIK dev
                                   question id listesi; hiçbir veritabanına YAZMAZ, yalnızca
                                   `EXPORT_SOURCE_DB_*` ile verilen sunucudan SELECT eder
                                   (bkz. Mimari, "Promotion")
    export-approved-questions.sh  Yukarıdakinin ince CLI sarmalayıcısı

n8n/
    README.md                     Workflow'ların kapsamı, env değişkenleri, n8n CLI kullanımı
    workflows/question-ingestion-test-batch.json   Yalnızca ingestion uç noktasını çağırır
    workflows/question-generation-enum-test.json   Soru üretim hattı: salt-okunur okumalar,
                                   OpenAI, kopya kontrolü, ingestion, AI Judge + (bayrakla
                                   açılan) auto-publish
    workflows/question-translation-en-to-tr.json   EN -> TR çeviri hattı: `correct`/tip/zorluk/
                                   kod/topic'i modelden DEĞİL EN sorusundan kopyalar

.github/workflows/test.yml        CI (bkz. "Bilinen Kısıtlar", test doğrulaması)
```

## Bilinen Kısıtlar / Dikkat Edilecekler (Güncel Durum Özeti)

Tam kronolojik geçmiş (bir kısıtın nasıl keşfedildiği, hangi fazda değiştiği)
**`docs/known-constraints.md`**'de; hiçbir şey silinmedi. Aşağıdaki, kısa özettir.
Ortam oturumdan oturuma değişir (eski Claude sandbox'ı, kullanıcının kendi Mac'i):
görev bir kısıta gerçekten bağlıysa **önce bash ile yeniden doğrula** (`mvn -version`,
`curl -sI https://repo.maven.apache.org`, `docker ps`).

- **Maven'ı JDK 21 ile çalıştır (kullanıcının Mac'inde varsayılan JDK 26'dır).**
  `pom.xml` `java.version` = 21; Lombok sürümü Spring Boot 4.1.0 BOM'undan gelir (1.18.46).
  JDK 26 ile temiz bir `mvn compile`, Lombok'un ürettiği erişimciler (ör. `getCategory()`)
  için çok sayıda "cannot find symbol" hatasıyla başarısız olur; aynı kaynak JDK 21 ile
  derlenir (2026-11-05'te doğrulandı; JDK 22-25 denenmedi, kök neden izole edilmedi).
  Her `mvn`/`spring-boot:run` öncesi `JAVA_HOME`'u JDK 21'e çevir:
  `export JAVA_HOME=$(/usr/libexec/java_home -v 21)`. CI de Temurin 21 kullanır.
- **Test doğrulaması: GitHub Actions CI** (`.github/workflows/test.yml`; `main`'e her
  push, her pull request, elle `workflow_dispatch`): Temurin 21, `postgres:16-alpine`
  servis container'ı (5433, `application-test.yml` ile aynı DB/kullanıcı; Flyway şemayı
  sıfırdan kurar), `TZ=Europe/Istanbul`, `mvn -B test`, ardından `scripts/example-outputs`
  Python testleri; Maven başarısız olursa Surefire raporları artifact olarak yüklenir.
  Yerelde aynı koşul: JDK 21, `TZ=Europe/Istanbul` ve 5433'te `learning_test` DB'si (testler
  `application-test.yml`'deki adresi kullanır; mevcut container'lara dokunmamak için atılabilir
  bir container ve `SPRING_DATASOURCE_URL` ile başka port kullanılabilir).
  **Railway'in build'i `mvn ... -DskipTests` çalıştırır, yani deploy testleri HİÇ çalıştırmaz.**
  Workflow'un kendisi deploy'u durdurmaz; Railway panelindeki "Wait for CI" ayarı kullanıcı
  tarafından ETKİN olarak doğrulandı (2026-10-24) ama deploy'u CI'a gerçekten beklettiği
  bağımsız olarak KANITLANMADI -- push'tan sonra CI sonucunu ve deploy-check'i yine ayrı ayrı
  kontrol et. Bir değişikliğin test kanıtı: o commit'in CI çalıştırması + yerelde JDK 21 ile
  `mvn test`.
- **Eski Claude sandbox'ının kısıtları (ortama bağlı, o ortamda gözlemlendi):** Maven Central
  (`repo.maven.apache.org`) proxy 403 veriyordu, bu yüzden `mvn compile`/`test` çalışmıyordu
  (workaround: `javac`'ı Lombok jar'ını `-processorpath`+`-proc:full` ile doğrudan çağırmak,
  ayrıntı `docs/known-constraints.md` "Faz 140"); `cdn.jsdelivr.net` erişilemiyordu (Playwright
  doğrulamasında Bootstrap'i `npm install bootstrap --no-save` ile yerel kopyadan ver);
  `registry.npmjs.org` ve `pypi.org` erişilebilirdi. **Kullanıcının Mac'inde (2026-11-05)
  Maven Central, npm, PyPI ve jsdelivr'e erişim vardır**; bu maddelerden hangisinin geçerli
  olduğunu ortamda doğrula.
- **Docker Engine var** (sandbox'ta 29.6.2, kullanıcının Mac'inde 29.8.0 görüldü) --
  `docker` kursunun örnekleri (`docker build`/`run`/`compose up`) gerçekten çalıştırılıp
  doğrulanabilir. Çalışan container'lar arasında projenin kendi dev veritabanı
  (`learning-platform-db`, `postgres:16-alpine`) ve n8n vardır: HİÇBİRİ durdurulmamalı,
  silinmemeli, testler onlara bağlanmamalı; yeni test container'ı çakışmayan bir `--name` alır.
- **`javac`/`java` ile gerçek derleme, Faz 12'den beri varsayılan olarak YAPILMIYOR** (oturum
  maliyeti/limit nedeniyle) -- yeni `.java` dosyaları elle dikkatli yazılıp gözden geçirilir.
  İstisna: kullanıcı özellikle isterse, dosya sıra dışı riskliyse (deadlock/timeout içeren
  thread örnekleri gibi) ya da kod saf JDK ise (Maven bağımlılığı yok) -- bu durumda önce
  scratch dizininde derleyip çalıştır, sonra doğrulanmış hâliyle asıl `examples/` klasörüne
  kopyala (Node/TypeScript için de aynı yöntem, Faz 72 notu).
- **Ayrı, uzun ömürlü git branch'leri kullanılmıyor** -- `react-course-projects`/
  `microservices-course-projects` gibi kurs-proje repoları `main` üzerinde, yalnızca
  tag'lerle versiyonlanıyor.
- **MockMvc testleri:** Boot 4'te paket ve starter değişti; ayrıntı
  `docs/known-constraints.md` ("Boot 4: `@AutoConfigureMockMvc`").
- Çok satırlı `//` Java yorumlarında her satırın başına `//` tekrar yazılmalı
  (bir örnekte bunu unutup gerçek bir derleme hatası bırakılmıştı) -- yazarken kontrol et.

Daha fazla ayrıntı, geçmiş hata örnekleri ve her kısıtın hangi fazda nasıl keşfedildiği
için `docs/known-constraints.md`'yi grep'le.
