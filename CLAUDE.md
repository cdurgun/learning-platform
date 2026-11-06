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

- **DB sadece metadata tutar; DB ↔ dosya bağlantısı yalnızca slug convention ile
  kurulur.** Hiyerarşi: `Course > Category > Topic > TopicTranslation`, ayrıca
  `CodeExample`. Ders içeriği asla DB'de değil, `src/main/resources/content/{lang}/{slug}.md`
  dosyalarındadır (tek doğruluk kaynağı); örnekler
  `examples/{topic.slug}/{example_name}.{ext}`. Path hiçbir zaman DB'de saklanmaz,
  `topic.slug`'dan türetilir.
- **Java örnekleri gerçek, derlenebilir dosyalardır; embed sistemi Faz 27'den itibaren
  uzantıdan bağımsızdır.** Örnekler `src/main/resources/examples/{topic-slug}/*.java`;
  markdown'da `{{DosyaAdi.ext}}` yazılınca `MarkdownService` bunu fenced code block'a
  çevirir. `EXAMPLE_PLACEHOLDER` regex'i uzantıyı ikinci yakalama grubu olarak okur,
  `CodeExampleResolver.resolve(slug, name, extension)` dosya yolunu bu uzantıyla kurar,
  code block'un dil etiketi (` ```jsx ` gibi) de bu uzantıdan gelir; React `.jsx`
  dosyaları Java örnekleriyle **birebir aynı mekanizmayla** gömülür (yeni bir "React
  embed sistemi" yazma; `highlight.js@11.9.0` "jsx"i "javascript" alias'ı olarak tanır,
  bkz. "Bilinen Kısıtlar"). Java dosyaları **default package**'ta, **İngilizce
  yorumlarla** yazılır (TR/EN markdown aynı dosyaları paylaşır); aynı topic klasöründe
  farklı dosyalarda aynı sınıf adı (`Book`, `Animal`, `Duck`) **normaldir** — her
  `.java` bağımsız bir derleme birimidir. Bir `.java` gömmesinin yanındaki `.out` ve
  "Beklenen Çıktı" paneli için aşağıdaki "Beklenen Çıktı" maddesine ve
  `docs/architecture-rationale.md` §3'e bak.
- **"Beklenen Çıktı" paneli (Faz 177):** bir `.java` gömmesinin yanında
  `examples/{slug}/{Ad}.out` varsa kod bloğunun altında programın gerçek stdout'u
  gösterilir. `.out` ELLE YAZILMAZ ve elle düzeltilmez: yalnızca
  `scripts/example_outputs.py generate` (izole Docker, sabit imaj digest'i) üretir,
  insan incelemesinden sonra `promote` yayına taşır ve
  `scripts/example-outputs/manifest.tsv`'ye hash'leriyle yazar. Çıktısı Java API
  sözleşmesiyle sabit olmayan örnekler (HashMap/HashSet sırası, paralel stream,
  thread, zaman, rastgelelik, ağ/süreç/ortam değişkeni) çalıştırmada aynı çıksa bile
  panele ALINMAZ. Dosya kullanan örnek YALNIZCA kendi oluşturduğu dosyaları göreli adla,
  temiz ve izole çalışma dizininde kullanıyorsa girebilir; mutlak, `~`'li ya da `..`
  yollar, `createTemp*`, sırasız dizin listeleri, dosya zamanı/sahibi/izinleri ve
  Javadoc'ta "optional specific exception" olan `java.nio.file` dalları ENGELLİ kalır
  (`scripts/example_outputs.py`, `CONTRACT_FLAGS`). Aynı dersin başka dosyasındaki tipi
  kullanan örnek o dosyayla (companion) birlikte derlenir ve hash'i manifest'in
  `companions` sütununa yazılır; tip tam bir dosyada tanımlı değilse örnek `MULTI_FILE`
  kalır. `ExampleOutputManifestTest` (örneği çalıştırmaz, yalnızca dosyaları ve
  manifest hash'lerini karşılaştırır), `.out`'u olan bir `.java` ya da companion'ı
  değişince build'i kırar: eski çıktı artık geçersizdir. Örnek hâlâ sözleşmeyle sabit
  bir çıktı üretiyorsa doğru çözüm çıktıyı yeniden üretmek (`generate`), incelemek ve
  `promote` etmektir; `.out`'u ve manifest satırını silmek yalnızca panel o örnekte
  artık kullanılmayacaksa seçenektir. Panel eklemek sayfada görünen örneği değiştirdiği için iki dilin
  `updated_at`'ini de ilerletir (aşağıdaki tarih kuralı, örn.
  `functional-interfaces-streams/V1139`). Dalga akışı (Faz 178): `generate --topic SLUG
  [--dry-run]` → kullanıcı `review.tsv`'de her örneğe ayrı `approve`/`reject` verir →
  `promote --review` (tek hata varsa hiçbir dosya yazılmaz). `--dry-run` her örneğin
  ön-kontrol sonucunu listeler, hiçbir şey çalıştırmaz ve yazmaz; çalıştırmadan önce bu
  liste gösterilir. Staging (Faz 180) kökteki
  git-ignored `.example-outputs/` dizinidir, `target/` DEĞİL (`mvn clean` incelenmemiş
  çıktıları silmesin; `StagingLocationTest` korur). Bayrak tabloları, satır sonu notu ve
  gerekçeler: `docs/architecture-rationale.md` §3.
- **Yayın durumu çeviri seviyesindedir:** `Topic`'te `published` yok,
  `TopicTranslation`'da var — bir dil yayında, diğeri taslak olabilir (örn. TR yayında,
  EN henüz taslak). Yeni bir konu eklerken önce TR'yi `published = true`, EN'i
  `published = false` olarak ekle; EN çevirisi bitince ayrı bir migration'la yayına al.
- **Her çevirinin iki tarihi vardır: `topic_translation.published_at` ve `updated_at`
  (`DATE`, `core/V1137`).** `updated_at` ders sayfasındaki "Son güncelleme" satırını,
  JSON-LD'deki `dateModified`'ı ve sitemap'teki `<lastmod>`'u besler. `published_at`
  HİÇBİR YERDE YAYINLANMAZ (sayfada, JSON-LD'de `datePublished` olarak ya da sitemap'te)
  — yalnızca iç kayıttır, `datePublished` EKLEME. İki tarih de OTOMATİK DEĞİLDİR:
  git'ten ya da çalışma anında türetilmez, yalnızca migration'la değişir. Kurallar:
  (1) Bir dersin gövdesi (`content/{lang}/{slug}.md`) ya da sayfada görünen örnek kodu
  (`examples/{slug}/*`) ANLAMLI biçimde değişirse, aynı commit'te o slug + dil için
  `updated_at`'i AÇIK bir tarihle (`DATE '2026-11-03'` gibi) ilerleten bir migration
  yaz. Metin değişikliği yalnızca kendi dilini, örnek kod değişikliği (dosyalar ortak
  olduğu için) iki dili de ilerletir. Yazım hatası, `seo_title`/`seo_description`,
  şablon ve stil değişiklikleri tarihi DEĞİŞTİRMEZ. (2) Yeni ders migration'larının
  `INSERT`'i değişmeden çalışır: iki kolon `DEFAULT CURRENT_DATE` taşır, yani tarih
  migration'ın o ortamda uygulandığı gün olur. (3) EN çevirisi sonradan yayına alınırken
  (`publish_{slug}_english` migration'ı) `updated_at` yayın günüyle AÇIKÇA yazılır —
  taslak satır eklendiği günün tarihini taşır. (4) `published_at` bir kez yazıldıktan
  sonra değiştirilmez; `updated_at >= published_at` DB kısıtıdır. Mevcut 336 çevirinin
  `published_at` değeri dosyanın git'teki İLK COMMIT tarihidir, sitenin gerçek yayın
  tarihi değildir. Gerekçe ve ayrıntı: `docs/architecture-rationale.md` §1,
  `docs/google-seo-adsense-plan.md`.
- **Dil, Faz 64'ten beri URL path'inin bir parçası, query parametresi değil:**
  gerçek içerik `/en/topics/{slug}` ve `/tr/topics/{slug}` altında (anasayfa: `/en`,
  `/tr`); eski `/topics/{slug}?lang=..` URL'leri 301 ile yeni adrese yönlendirilir
  (SEO: hreflang ile bağlanabilen, bağımsız indexlenebilir URL'ler, bkz. Faz 64 notu).
  Yeni bir sayfa/route eklerken dili HER ZAMAN `{lang:en|tr}` regex-kısıtlı bir path
  variable olarak ekle, query parametresi olarak DEĞİL. `LangParamLocaleResolver` önce
  path'in ilk segmentine bakar, bulamazsa `?lang=` parametresine bakar; `?lang=`
  YALNIZCA eski yer imleri/linkler için geriye dönük uyumluluk fallback'idir (bu yedek
  ve çıplak `/` negotiator'ı), yeni route'larda kullanılmaz. **Çıplak `/` bir
  negotiator'dır; varsayılan dili Faz 69'dan itibaren DAİMA İngilizce'dir,
  `Accept-Language` başlığı BİLİNÇLİ OLARAK dikkate ALINMAZ** (Faz 64'teki ilk tasarım
  tarayıcı diline bakıyordu, kullanıcı beklenmedik `/tr` yönlendirmesi nedeniyle
  değiştirilmesini istedi — kalıcı ürün kararı, "eski hâline" DÖNÜLMEMELİ; bkz. Faz 69
  notu). Path ve `?lang=` yoksa/bozuksa arayüz de içerik de İngilizce'ye düşer
  (`LangParamLocaleResolver.DEFAULT_LOCALE`). **i18n:** UI metinleri
  `messages*.properties`'de, içerik çevirisi (`content/{lang}/*.md` +
  `TopicTranslation`) ayrı bir katmandır; controller'lar dili `{lang:en|tr}` path
  variable'ından alır ve kendi başlarına ayrı bir varsayılan **tanımlamaz**, aksi halde
  arayüz ile içerik dili birbirinden sapar (Faz 12'de yaşanan gerçek bir hataydı).
- **Mutlak URL üretmek gereken her yerde (hreflang, canonical, Open Graph/Twitter meta,
  JSON-LD, sitemap.xml) `app.base-url` kullanılır, asla sabit kodlanmış bir domain
  DEĞİL** — bkz. Faz 65 notu. Değer `application.yml`'de (dev) ve
  `application-prod.yml`'de (production) tanımlı. `Model` alan controller'lara
  `GlobalModelAttributes` (`@ControllerAdvice`) `baseUrl` attribute'unu enjekte eder;
  `ResponseEntity` döndüren controller'lar (örn. `SitemapController`)
  `@Value("${app.base-url}")` kullanır. Yeni bir konu sayfası türünde `topic.html`'deki
  hreflang/canonical/OG deseni referans alınır: hreflang yalnızca GERÇEKTEN yayında olan
  dillere verilir, x-default İngilizce'ye düşer.
- **`th:inline="javascript"` (JSON-LD `<script>` bloklarında kullanılır) `/*<![CDATA[*/
  ... /*]]>*/` sarmalayıcısı OLMADAN yazılır; yeni bir blokta CDATA sarmalayıcı EKLEME.**
  Proje HTML5 çıktı üretiyor (XHTML strict değil); sarmalayıcı attoparser'ın `<![CDATA[`'i
  gerçek bir CDATA açılışı sanmasına ve `TemplateInputException: Incomplete structure:
  "/*"` hatasına yol açar (canlı ortamda GERÇEKTEN doğrulandı). Gerekçe: `topic.html`
  içindeki yorum ve `docs/phase-log.md` Faz 66 notu.
- **Sidebar, Faz 68'den itibaren `lg` altında Bootstrap'in `offcanvas-lg` bileşenidir**
  (`fragments/layout.html :: sidebar`, `#sidebarOffcanvas`); navbar'daki `d-lg-none`
  hamburger butonu açar, navbar `sticky-top`'tır. İki ZORUNLU tuzak: (1) `offcanvas-body`
  `d-block` taşımalı (Bootstrap'in `.offcanvas-lg .offcanvas-body` kuralı lg+ ekranda
  `display:flex` verir; `d-block`'un `!important`'ı bunu geçersiz kılar). (2) Sağdaki TOC
  (`topic.html`, `.toc-sticky`) navbar'ın altına gizlenmesin diye `top: 4.25rem` kullanır
  VE `align-self: flex-start` İÇERMELİDİR — yoksa `.row`'un varsayılan `align-items:
  stretch`'i TOC'u `main` ile aynı yüksekliğe gerer ve `position: sticky` hiç çalışmaz
  (Playwright ile doğrulanmış gerçek hata). Yeni bir sticky/offcanvas aynı deseni
  izlemeli. Ölçümler ve gerekçe: `static/css/custom.css` yorumu, `docs/phase-log.md`
  Faz 68.
- **`> 💡 Tip` / `> ⚠️ Warning` blockquote'ları** Bootstrap alert'e çevrilir —
  **tek paragraf olmalı**, içine boş satır ya da code fence **konamaz** (regex tabanlı
  post-process, çok paragraflı blockquote'ları desteklemiyor). Code fence'ler her zaman
  blockquote'un dışına, sibling olarak konur.
- **Bölüm/section referansları her zaman isimle verilir** ("Alanları Okumak"
  bölümünde...), **asla numarayla değil** ("Bölüm 3'te..." yazma). Bir bölüme referans
  verirken, o bölümün H2 başlığıyla **birebir aynı metni** tırnak içinde kullan — TR ve
  EN dosyaları ayrı ayrı doğrulanmalı.
- **Flyway migration numaraları sıralı ve geçmişe dönük asla değiştirilmez** — her
  değişiklik yeni bir `V{n}__aciklama.sql` dosyası. SQL string literal'lerinde Türkçe
  apostrof geçen metinlerde (`Interface'in` gibi) SQL escaping'i (`''`) unutma.
  Migration'lar `db/migration/{konu-slug}/` alt klasörlerinde tutulur (`core/`, `enum/`,
  `record/`, ... `threads/`); Flyway `classpath:db/migration`'ı recursive taradığı için
  alt klasör derinliği versiyon sırasını etkilemez (yalnızca dosya sistemi
  organizasyonu). Yeni bir konu eklerken migration'ları o konunun kendi alt klasörüne
  koy. **Doğrulama:** Maven Flyway plugin'i (`mvn flyway:migrate`) `application.yml`'i
  okumaz (`placeholderReplacement` varsayılanı true), uygulamanın gerçek yolunu
  doğrulamaz. Migration'lar Spring Boot test yaklaşımıyla doğrulanır: uygulama
  yapılandırmasıyla çalışan Spring Boot testi (`LearningPlatformApplicationTests`) Flyway'i
  uygulamanın kendi yolundan çalıştırır. `quiz-questions` skill'indeki 9a bunu geçici bir
  PostgreSQL container'ına karşı yapar (günlük testlerden ÖNCE, zorunlu); 9b günlük
  testlerdir (kalıcı `learning_test`) ve yeni migration doğrulaması yerine geçmez.
- **Flyway placeholder değiştirme KAPALIDIR** (`application.yml`:
  `spring.flyway.placeholder-replacement: false`; dev/prod/test profilleri geçersiz
  kılmaz) — migration dosyalarında (yorum satırları dahil) literal `${...}`
  kullanılabilir. Bu ayarı açmadan ya da bir profilde değiştirmeden önce
  `grep -rl '\${' src/main/resources/db/migration` ile migration'ları tara ve etkisini
  değerlendir: ayar açıkken eşleşen her `${...}` "No value provided for placeholder"
  hatasıyla **tüm uygulamanın başlamasını engeller**. Gerekçe ve geçmiş:
  `docs/architecture-rationale.md` §2.
- **Birden fazla `Category` olabilir:** `category.sort_order` kategoriler arası sırayı,
  `topic.sort_order` ise **yalnızca kendi kategorisi içinde** sırayı belirler (kategori
  kapsamlı sorgu: `TopicRepository.findByCategoryIdOrderBySortOrderAsc`). Yeni bir
  kategoride `topic.sort_order` 1'den başlar; önceki kategorilerin numaraları devam
  ettirilmez.
- **React course'unda her kategori, gerçek ve çalıştırılabilir bir "Pratik Proje" ile
  biter (Faz 30'dan itibaren kalıcı kural).** Java/Spring derslerindeki `## Ek: Mini
  Proje` (gömülü `.java` dosyaları) React kategorileri için kullanılmaz; bunun yerine,
  kategori bittiğinde ayrı bir repo'da (`react-course-projects`, GitHub'da
  `cdurgun/react-course-projects`) o kategorinin kavramlarını birleştiren küçük, gerçek
  bir Vite/React uygulaması yazılır, `npm run build` ile derlemesi doğrulanır, `main`
  branch'ine commit edilip `{kategori-slug}-v1` gibi bir tag ile "dondurulur". İlgili
  konunun markdown'ında (genelde kategorinin son ana konusu, örn. React Fundamentals'ta
  `jsx`) bir `## Pratik Proje` bölümü bu tag'in GitHub linkini ve `git clone` + `npm
  install` + `npm run dev` talimatını verir. Proje **yalnızca o kategoriye kadar
  öğretilmiş kavramları kullanır** — state, hook, `.map()` ile liste render'ı gibi henüz
  işlenmemiş kavramlara asla atıfta bulunmaz. Ayrı, uzun ömürlü branch'ler
  **kullanılmaz**: tüm kategori projeleri `main` üzerinde, yalnızca tag'lerle
  versiyonlanır. Repo kökü npm workspaces kullanır (`"workspaces": ["projects/*"]`): yeni
  proje, `projects/` altına kendi `package.json`'lı bir klasör koymaktır, `npm install`
  yalnızca kökte bir kez çalışır; ayrıntı: `docs/known-constraints.md` (Faz 30).
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
  CODE_OUTPUT), `difficulty` (mevcut `Difficulty` enum'u), `status` (`QuestionStatus`:
  DRAFT/PENDING_REVIEW/PUBLISHED/REJECTED) ve `source` (`QuestionSource`:
  MANUAL/CLAUDE/N8N/OPENAI) taşıyan genel bir havuz sorusu. Eski `QuizOption` →
  `QuestionOption`'a yeniden adlandırıldı (anlamı değişmedi). **`QuizQuestion`
  ADI KORUNDU ama anlamı tamamen değişti** — artık bir soru DEĞİL, yeni `Quiz`
  entity'si (bir topic+language'e bağlı, editoryal olarak KÜRE edilmiş/curated,
  `slug`+`title`+`passThreshold` taşıyan **sabit quiz**) ile `Question`
  arasında bir İLİŞKİ/join entity'si — hangi sorunun hangi quiz'de hangi
  sırada (`position`) yer aldığını tutar; eski anlamıyla (bir soru olarak)
  KULLANMA. Üç ayrı kavram aynı `Question` havuzunu tüketir: **sabit quiz**
  (`QuizService`, `/{lang}/topics/{topicSlug}/quiz/{quizSlug}/submit`), **Practice
  modu** (`PracticeService`, `/{lang}/practice`, topic/language/difficulty/type
  filtreli RASTGELE seçim; hiçbir `Quiz` satırına ihtiyaç duymaz) ve **Quiz Area**
  (`QuizDefinition`: kategori-kapsamlı, yeniden kullanılabilir tanım; sabit
  quiz'in ve Practice'in yerine GEÇMEZ, ayrı bir kavramdır; submit/puanlamayı
  `PracticeService.submit` ile paylaşır -- bkz. Faz Geçmişi bölümündeki Faz 139
  notu ve `docs/architecture-rationale.md` §7). Practice ve Quiz Area havuzdan
  yalnızca `status = 'PUBLISHED'` soruları çeker (bu filtre sorgunun KENDİSİNE sabit
  yazılı, hiçbir çağıran taraf override edemez). **DİKKAT:**
  sabit quiz'in soru üyeliği (`quiz_question_link`) `Question.status`'tan
  TAMAMEN BAĞIMSIZDIR — `QuizService.loadQuiz()` hiçbir status filtresi
  uygulamaz, yalnızca `quiz_question_link`'te ne varsa onu döner. Yani bir
  soruyu `PUBLISHED` yapmak onu OTOMATİK OLARAK hiçbir topic'in sabit
  quiz'ine EKLEMEZ (yalnızca havuza girmesini sağlar, Practice/Quiz Area'da
  görünür hale getirir) — bir topic'in sabit quiz'ine yeni soru eklemek AYRI,
  açık bir `quiz_question_link` seed adımı gerektirir (bkz. `enum/V291`,
  `git-fundamentals/V467`/`V468` — topic slug + language + quiz slug ile
  portable şekilde resolve edilen quiz'e link'leyen migration deseni).
  Puanlama (`QuestionScorer`) her iki modda AYNI kuralı kullanır: seçilen şık id
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
  eşleşmeye dikkat et. **CODE_OUTPUT soruları:** kod YALNIZCA `codeSnippet`
  (+ `codeLanguage`) alanında tutulur, `question` metninde fenced blok olarak
  tekrarlanmaz (tekrarlanmışsa admin ekranında
  `QuestionReviewView.questionDisplayText()` bunu yalnızca SUNUMDA düşürür, DB'deki
  `question` sütunu değişmez); quiz şablonunda (`fragments/quiz.html`) MEVCUT
  highlight.js entegrasyonuyla (`hljs.highlightAll()`, ayrı bir JS değişikliği
  GEREKMEDİ) render edilir. Gerekçe: `docs/architecture-rationale.md` §7; akış:
  `docs/phase-log.md` "Faz 87".
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
  DOKUNULMADI). Ayrıca `fragments/quiz.html`'deki şık `<input>`'u da (`MULTIPLE_CHOICE`
  hâlâ radio render ediyordu, tarayıcı seviyesinde birden fazla şık SEÇİLEMEZDİ)
  `th:type="${q.type()...} ? 'checkbox' : 'radio'"` ile düzeltildi (`quiz.js`
  zaten generic `:checked` sorgusu kullandığı için başka bir JS değişikliği
  GEREKMEDİ). **Doğrulama, kullanıcının kendi ortamında GERÇEK bir tarayıcıda
  yapıldı:** sabit enum quiz'i (5 SINGLE_CHOICE soru) grouped `answers`
  sözleşmesiyle sorunsuz submit edildi; AI ingestion endpoint'i (`POST
  /api/internal/questions/ingest`) gerçek bir `curl` çağrısıyla test edildi
  (`201`, `PENDING_REVIEW` döndü), sonuç bir `MULTIPLE_CHOICE` soru
  manuel olarak `PUBLISHED`'a çekilip `quiz_question_link`'e geçici (migration
  DEĞİL, elle SQL) eklendi, tarayıcıda checkbox olarak render edildiği,
  birden fazla şıkkın aynı anda seçilebildiği ve iki doğru şık seçilince
  quiz'in **6/6 — Passed** sonucu döndürdüğü doğrulandı. Ayrıntı ve
  gerekçe: `docs/architecture-rationale.md` §7 ("Tarayıcı sözleşmesi").
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
  şeklinde kullanır. `SecurityConfig`'teki `authorizeHttpRequests` kuralları
  sırayla değerlendirilir, ilk eşleşen kazanır: `/{lang:en|tr}/admin/**` →
  `hasRole("ADMIN")`; course'u URL'den belirlenebilen quiz rotaları
  (`/{lang:en|tr}/topics/{slug}/quiz/**`, `/{lang:en|tr}/quiz/{definitionSlug}[/**]`)
  → `CourseAccessPolicy`; geri kalan her şey `anyRequest().permitAll()` (anasayfa,
  ders içeriği, Practice API -- course kontrolü serviste --, AI ingestion -- kendi
  `X-Api-Key` interceptor'ıyla). Yeni bir gated (yalnızca girişli kullanıcıya açık)
  sayfa eklenirse kuralı `anyRequest().permitAll()`'dan ÖNCE ekle — var olan
  hiçbir rota bu değişiklikten etkilenmemeli. **CSRF koruması artık varsayılan
  olarak açık** — gerçek Thymeleaf formları (`th:action`) `${_csrf.token}`
  hidden input'uyla korunmalı (bkz. `login.html`/`register.html`/navbar logout
  formu), ama tarayıcı oturumu olmadan çağrılan anonim JSON POST uç noktaları
  `SecurityConfig`'te `csrf().ignoringRequestMatchers(...)` ile bilinçli olarak muaf
  tutuldu; liste YALNIZCA şunlardır: `/api/internal/**` (AI ingestion ve diğer n8n
  uç noktaları; kendi `X-Api-Key` interceptor'ıyla korunur),
  `/{lang:en|tr}/topics/*/quiz/*/submit` (sabit quiz), `/{lang:en|tr}/practice/submit`
  (Practice) ve `/{lang:en|tr}/quiz/*/submit` (Quiz Area). Bu listenin dışındaki her
  POST CSRF korumalıdır. Yeni bir anonim/oturumsuz POST API eklenirse aynı
  muafiyet listesine eklenmeli.
  **AI Tutor (DeepSeek) güvenlik kuralı:** varsayılan olarak KAPALIDIR; yalnızca
  `AI_TUTOR_ENABLED=true` VE `DEEPSEEK_API_KEY` birlikte verilince çalışır (biri
  eksikse uygulama yine açılır, tutor devre dışı kalır). Rotaları
  `/{lang:en|tr}/admin/ai-tutor/**` olduğu için yukarıdaki `/admin/**` →
  `hasRole("ADMIN")` kuralı onları da korur: yalnızca ADMIN erişir. JSON uç noktaları
  (`.../messages`, `.../conversations/*`) CSRF'ten muaf DEĞİLDİR (oturum adına para
  harcarlar) ve muafiyet listesine eklenmemelidir. API anahtarı yalnızca ortam
  değişkeninden okunur, repoya yazılmaz. Ayrıntı: `docs/deepseek-ai-tutor-plan.md`.

- **"Google ile devam et" (Faz 185) aynı session modeline eklenen ikinci giriş yolu,
  token tabanlı oturum DEĞİL.** Google hesabı `user_identity.provider_subject` (`sub`)
  ile tanınır, e-postayla DEĞİL; principal'ın `getName()`'i her giriş yolunda YEREL
  e-postadır ve yetki YALNIZCA `app_user.role`'den gelir (`LocalOidcUser`,
  `GoogleAccountService`). E-postası eşleşen mevcut hesap ASLA otomatik bağlanmaz
  (kayıtta e-posta doğrulanmıyor) -- o hesabın şifresi istenir; yeni Google hesabı
  Kullanım Koşulları kutusu işaretlenmeden açılmaz. Bağlı olmayan kimliğin e-postası
  doğrulanmamışsa (`email_verified`) giriş reddedilir; doğrulanmış kimlik giriş SAYILMAZ,
  session'da bekler (`PendingGoogleSignIn`, 10 dk). ADMIN hesabı Google'la bağlanamaz ve
  giriş yapamaz (kural tek yerde: `GoogleAccountService.allowsGoogleSignIn`); e-postası bir
  ADMIN hesabına ait, henüz bağlı olmayan kimlik de parola isteyen bağlama sayfasından ÖNCE
  reddedilir (`GoogleOidcUserService.loadUser` + `GoogleSignInController.render`, ikisi de
  `GoogleAccountService.isGoogleSignInBlockedForEmail` üzerinden `allowsGoogleSignIn`'e
  sorar). İstemci yalnızca `GOOGLE_CLIENT_ID`/`GOOGLE_CLIENT_SECRET` verilince kurulur,
  ikisi de yoksa buton gizli; ikisi BİRLİKTE verilmeli -- yalnızca client-id verilirse
  uygulama açılmaz. Prod session çerezi `SameSite=Lax` KALMALI (Strict Google dönüşünü
  kırar). E-posta kayıtta, Google eşleştirmesinde ve şifreyle girişte AYNI kuralla
  (`UserRegistrationService.normalizeEmail`: `trim()` + `toLowerCase(Locale.ROOT)`)
  normalize edilir -- yeni bir e-posta araması da bunu kullanmalı. Etkinleştirme tarifi:
  `docs/google-sign-in-operations.md`. Tarihli doğrulamalar, deployment kimlikleri ve açık
  bulgular (F2, F5, F6): `docs/phase-log.md` Faz 185.
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

**ZIP teslimatı (Faz 75 kararı, koşullu hâle getirildi):**

- Git deposuna erişim varsa Git üzerinden çalış; ZIP gerekmez.
- Erişim yoksa YALNIZCA bu görevde oluşturulan/değiştirilen dosyaları ZIP'e
  al, tüm projeyi tekrar paketleme (tam proje zip'i yalnızca kullanıcı açıkça
  isterse). Zip kökü `learning-platform`, yollar proje köküne göre korunur
  (ör. `src/main/resources/content/tr/{slug}.md`); `target/`, `node_modules/`,
  `.git/` ve diğer üretilmiş dosyalar hariç. Zip'ten önce değişen dosya
  listesini çıkarıp yalnızca bunların girdiğini doğrula.

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

Biten fazlar `docs/phase-log.md` tablosuna eklenir, CLAUDE.md'ye değil; buraya
yalnızca yeni kurs/kategori, mimari karar ya da CLAUDE.md organizasyon değişikliği
gibi kilometre taşları özetlenir. Yeni bir konuya ya da karara başlamadan önce
phase-log'u ilgili anahtar kelimeyle (kategori slug'ı, teknik terim, "Faz N")
`grep`'le, baştan sona `Read` etme. İsimlendirme konvansiyonu, migration deseni ve
daha önce çözülmüş hata sınıfları için önce oraya bak.

**GÜNCELLEME (Faz 96):** `spring-boot` kursunun `microservices` kategorisi
artık **12/12 topic TR+EN tamamlandı** (`microservices-fundamentals`'tan
`deployment`'a kadar, Faz 40'ta wave'lere bölünen orijinal ChatGPT planının
tamamı) -- migration'lar şu an V1'den **V317'ye kadar boşluksuz**. Kategori
kuralı gereği bir "Pratik Proje" eklenebilecek doğal nokta bu, ama ayrı bir
repo/tag/build gerektirdiği için henüz üretilmedi, kullanıcının ayrı bir
kararı bekleniyor.

**GÜNCELLEME (Faz 114):** `spring-boot` kursunun `advanced-spring` kategorisi
(4 topic, TR+EN) tamamlandı; spring-core/spring-mvc/microservices'in içine değil,
kendi ayrı üst-seviye kategorisidir. **Kapsam kuralı (yalnızca Spring Boot,
Spring Data JPA ve PostgreSQL kurslarında geçerli):** bu kurslarda yeni bir
konu, mevcut konularda ZATEN kapsamlıca işlenmiş temelleri tekrar öğretmez;
yalnızca o konuların bilinçli açık bıraktığı boşlukları doldurur ve gerçek
migration başlıklarıyla doğrulanmış çapraz referans verir. İstisna: müfredata ilk
kez giren yeni bir teknoloji (`spring-batch`) temellerden başlar.
`spring-boot-starter-batch` pom.xml'de bir bağımlılık DEĞİL; bu kategorinin
örnekleri, `microservices`'in Kafka/Eureka örnekleri gibi, elle yazılmış ve
derlenmemiştir. Bu kural Java ve React kurslarına genellenmez. Kullanıcının açık
talimatı gereği bu kategoriye henüz bir Pratik Proje eklenmedi. Ayrıntı:
`docs/phase-log.md` (Faz 110-114).

**GÜNCELLEME (Faz 139):** **Quiz Area** (`QuizDefinition`: `course` FK +
kategorilerle `@ManyToMany`) sabit quiz'in (`Quiz`/`QuizService`) ve Practice'in
YERİNE GEÇMEZ; bilinçli olarak ayrı, ek bir kavramdır ve var olan sabit quiz
koduna dokunulmadı (bkz. "Mimari" bölümündeki Faz 87 maddesi, Question Pool).
**Boş kategori kümesi = tüm kurs.** Soru çekme (draw) tarafı Quiz Area'ya özgüdür;
submit/puanlama YENİDEN YAZILMADI, `PracticeService.submit` Practice ile
paylaşılır. Hangi kurslarda `quiz_definition` seed'i olduğu:
`docs/architecture-rationale.md` §7. Ayrıntı: `docs/phase-log.md` "Faz 139".

**Quiz sorusu eklemek:** `.claude/skills/quiz-questions` skill'i tek doğruluk kaynağıdır
(4-7 çift, `INSERT INTO quiz` shell kontrolü, `NOT EXISTS`/`ON CONFLICT DO NOTHING` link
migration'ları, auto-publish ve diğer yayın yolları, MULTIPLE_CHOICE kuralı). Skill'siz de
unutulmaması gereken kural: bir topic'e quiz sorusu eklemeden önce o topic'in var olan
migration'larında `grep -rl "INSERT INTO quiz"` ile quiz shell'inin zaten eklenip eklenmediğini
tara; ekleniyorsa shell migration'ı yazma (`duplicate key` hatası). Kurs bazlı kapsam ve
tarihçe: `docs/phase-log.md` (Faz 150, Faz 155-159); shell hatasının hikâyesi:
`docs/known-constraints.md` ("Faz 157").

**GÜNCELLEME (Faz 154):** YEDİNCİ Course olarak **`docker` kursu** eklendi
(`course.sort_order=7`; `docker-fundamentals` 4 + `docker-in-practice` 5 topic,
hepsi TR+EN). İçerik jenerik Docker örnekleri değil, bu projenin kendi gerçeklerine
(`pom.xml` coordinate'leri, `application-prod.yml`, Spring Data JPA kursunun gerçek
topic başlıkları) topraklanır. **Bilinçli istisna:** kapanış dersi
`docker-practical-project`, React'in ayrı repo + tag kuralına (yukarıdaki "React
course'unda her kategori..." maddesi, Faz 30) UYMAZ ve derste gömülü kalır:
teslim edilen şey config + küçük bir Spring Boot/PostgreSQL uygulamasıdır, ayrı bir
build/tag yaşam döngüsü gerektiren bir istemci projesi değil. Docker örnekleri bu
ortamda gerçekten çalıştırılıp doğrulanabilir (bkz. "Bilinen Kısıtlar", "Docker
Engine var"). Ayrıntı: `docs/phase-log.md` "Faz 154".

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
  ve `.claude/skills/deploy-check` Python testleri; Maven başarısız olursa Surefire
  raporları artifact olarak yüklenir. Yerelde aynı koşul: JDK 21, `TZ=Europe/Istanbul` ve 5433'te `learning_test` DB'si (testler
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
