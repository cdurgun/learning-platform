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

**Şu an proje durumu (Faz 76 itibarıyla):** 4 kurs (`java`, `spring-boot`,
`react`, `ai`), migration'lar V1'den V252'ye kadar uygulandı. `ai` kursunda 3
kategori tamamlandı (`ai-fundamentals`, `large-language-models`, `tools-mcp` —
her biri 4 topic), "AI Agents" kategorisi (Wave 4) kullanıcı onayı bekliyor.
Kesin sayılar ve tam liste için `docs/phase-log.md`.

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
