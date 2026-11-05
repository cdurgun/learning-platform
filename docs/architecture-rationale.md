# Mimari kuralların gerekçeleri

`CLAUDE.md` kuralları söyler; bu dosya **neden** var olduklarını, geçmişte hangi sorunu çözdüklerini
ve istisnalarını anlatır. CLAUDE.md'nin kopyası değildir: kuralın tam metni orada, burada yalnızca
gerekçe ve bağlam vardır. Bir kuralı değiştirmeden önce ilgili bölümü okuyun: `grep -n "^## " docs/architecture-rationale.md`.

Her bölümde: **Kural** (tek satır işaretçi), **Gerekçe**, **Geçmiş / karşılaşılan sorun**,
**İstisnalar ve sınırlar**, **Kaynaklar**. Kaynak dosya kendi başına yeterliyse (ör. script başlığı)
ayrıntı orada bırakılır, burada tekrarlanmaz. "Kaynakta yok" ya da "çıkarım" diye işaretli cümleler
doğrulanmamıştır.

---

## 1. Çeviri tarihleri: `published_at` / `updated_at` ve `datePublished` kararı

**Kural:** `topic_translation.published_at` ve `updated_at` (`DATE`, `core/V1137`); `updated_at` yalnızca
migration'la değişir; `published_at` hiçbir yerde yayınlanmaz. (CLAUDE.md, "Mimari", "Her çevirinin iki tarihi vardır".)

**Gerekçe: neden iki tarih, neden çeviri seviyesinde.** Ders sayfasındaki "Son güncelleme" satırını,
JSON-LD `dateModified`'ı ve sitemap `<lastmod>`'unu `updated_at` besler (SEO/AdSense planı). EN ve TR
ayrı dosyalardır ve farklı günlerde değişir, bu yüzden tarih `Topic`'te değil çeviride durur
(V1137 başlığı).

**Gerekçe: neden tarihler otomatik değil.** İçerik `content/{lang}/{slug}.md` dosyasında yaşar; DB satırı
dosya değişince kendiliğinden değişmez. Bu yüzden tarihler git'ten ya da çalışma anında türetilmez, yalnızca
migration'la değişir (CLAUDE.md). V1137'nin ilk doldurması da bu ilkeyi izledi: tarihler git geçmişinden bir kez
çıkarılıp sabit değer olarak yazıldı, çünkü "çalışan uygulama git'e bakmaz, her ortam aynı tarihleri alır"
(V1137 başlığı). Tarihi ilerletmek bu yüzden bilinçli bir migration adımıdır, ve
`content-check` skill'i yalnızca *unutulmuş* ilerletmeyi raporlar (tarihi kendisi hesaplamaz ya da değiştirmez).

**Gerekçe: neden `datePublished` YOK (kalıcı karar).** `published_at` mevcut 336 çevirinin
`content/{dil}/{slug}.md` dosyasının **git'teki ilk commit tarihidir**. Sitenin gerçek yayın tarihi değildir:
bazı EN çeviriler commit edildikten sonra yayına alındı, bu yüzden değer birkaç gün erken olabilir.
Gerçek yayın tarihini garanti etmeyen bir değeri sayfada, JSON-LD `datePublished` olarak ya da sitemap'te
yayınlamak yanlış bir iddia olurdu. Bu yüzden kolon ve entity alanı yalnızca **iç kayıt** olarak durur
(ileride gerçek yayın tarihleri elde edilirse kullanılabilir). **`datePublished` eklenmemelidir.**

**Kural 1-4, her birinin nedeni:**

1. *Anlamlı içerik değişimi → aynı commit'te, o slug + dil için, AÇIK tarihli (`DATE '2026-11-03'` gibi) bir `updated_at` migration'ı.*
   Metin değişikliği yalnızca kendi dilini ilerletir. Örnek kod (`examples/{slug}/*`) iki dilin ortak
   kaynağı olduğu için iki dili birden ilerletir (örnek: `functional-interfaces-streams/V1139`).
   Yazım hatası, `seo_title`/`seo_description`, şablon ve stil değişiklikleri tarihi ilerletmez (V1137 başlığı: "SEO
   açıklaması, şablon ve stil değişiklikleri sayılmadı"; SEO açıklamaları `V1135`/`V1136`). *Çıkarım:* bu değişiklikler dersin
   öğretici içeriğini değiştirmediği için "Son güncelleme" iddiası oluşturmaz; kaynaklarda gerekçe yazılı değil.
2. *Yeni ders migration'ının `INSERT`'i değişmeden çalışır.* İki kolon `DEFAULT CURRENT_DATE` taşır;
   tarih migration'ın o ortamda uygulandığı gün olur. V1137'de varsayılan bilerek **en sona** verildi:
   mevcut 336 satıra uygulanmasın, yalnızca bundan sonra tarih vermeyen `INSERT`'ler için olsun.
3. *EN yayına alınırken (`publish_{slug}_english` migration'ı) `updated_at` yayın günüyle AÇIKÇA yazılır.* EN çeviri taslak olarak eklendiği günün
   tarihini taşır (kural 2). *Çıkarım (kaynakta gerekçe yok):* yayına alındığı gün çeviri sayfada ilk kez görünür olduğu için
   tarih taslak ekleme gününü değil yayın gününü yansıtır.
4. *`published_at` yazıldıktan sonra değişmez; `updated_at >= published_at` DB kısıtıdır*
   (`chk_topic_translation_updated_not_before_published`, V1137). Kısıtın amacı kaynakta yazılı değil; *çıkarım:* hatalı
   bir `UPDATE`'in `updated_at`'i `published_at`'ın gerisine sarmasını DB seviyesinde reddeder.

**Doğrulanmamış çıkarım (tarihsel gerekçe bilinmiyor):** *güncelleme* migration'larında tarih neden `CURRENT_DATE` yerine açık
yazılıyor, ama *yeni ders* `INSERT`'inde `DEFAULT CURRENT_DATE` kabul ediliyor? Makul bir okuma: açık tarih **tekrarlanabilirlik**
sağlar (aynı migration her ortamda ve her zaman aynı tarihi yazar; geç deploy edilen bir güncelleme düzenleme günü yerine deploy gününü
yazmaz), `CURRENT_DATE` ise **yeni kaydın tarihini** belirlemek içindir. Bu okuma proje sahibi tarafından makul bulundu ama
tarihsel gerekçe olarak doğrulanmış bir karar DEĞİLDİR; hiçbir dokümanda yazılı değil.

**Geçmiş / sınırlar.**
- V1137 sırası bilinçli: kolonlar önce boş bırakılabilir eklenir, 336 satır slug + dil ile doldurulur,
  sonra `NOT NULL` yapılır. Bir satır atlanırsa `NOT NULL` adımı hata verir ve migration geri alınır.
- **V1137'nin ilk yorum satırı hâlâ `datePublished`'dan söz eder** (yani kararın öncesindeki planı yansıtır);
  uygulanmış migration değiştirilemediği için düzeltilmedi. Bu yorum bir kural değildir.
- `updated_at` hesabı: ders dosyasının ve gömdüğü örnek dosyaların son commit tarihlerinden geç olanı.
  `96d8121` (2026-08-18) ve `179f9e3` (2026-10-06) toplu commit'leri gerçek metin değişikliği içerdiği için dahil edildi.
- `content-check` slug düzeyinde eşleştirir; yanlış DİLİN tarihinin ilerletilmesini yakalamaz ve yalnızca push'tan önce işe yarar.

**Kaynaklar:** `src/main/resources/db/migration/core/V1137__add_topic_translation_dates.sql` (başlık yorumu);
`docs/google-seo-adsense-plan.md` ("`published_at` gerçek yayın tarihi değildir" sınırlaması, Bakım kuralı);
`.claude/skills/content-check/SKILL.md` (tarih bulguları ve sınırları).

---

## 2. Flyway `${...}`: placeholder replacement kapalı; literal kullanım ve ayarı değiştirme riski

**Kural (CLAUDE.md'de kısa):** Flyway placeholder replacement `application.yml`'de kapalıdır (`placeholder-replacement: false`);
migration dosyalarında literal `${...}` bu ayarla kullanılabilir. **Ayarı değiştirmeden önce mevcut migration'lar taranmalıdır**
(literal `${...}` içeren dosyalar ayar açılırsa uygulamayı durdurur). (CLAUDE.md, "Mimari", Flyway maddesi.)

**Teknik neden (ayar kapalı değilken).** Flyway'in varsayılan placeholder sözdizimi tam olarak `${...}`'dır ve placeholder
değiştirme betiğin tamamına (SQL yorumları dahil) uygulanır. Eşleşen her `${...}` için bir placeholder değeri beklenir; yoksa
`No value provided for placeholder: ${...}` hatası verir ve **tüm uygulama başlamaz** (Flyway `migrate` aşamasında düşer).
`@{...}` ve `#{...}` tetiklemez; yalnızca `$` önekli olan tetikler.

**Geçmiş.** Faz 23'te `spring-mvc-views-thymeleaf` migration'ları (V108) Thymeleaf'in `${...}` değişken ifadesinden söz ederken bu hata
gerçekten yaşandı (phase-log Faz 24 satırı: "V108'de yaşanan Flyway `${...}` placeholder hatası"). Çözüm o zaman migration'larda
"dolar-süslü-parantez" yazmaktı; eski CLAUDE.md kuralı bu çözümdü. Sonra `spring-mvc-views-thymeleaf` quiz soruları dersin konusu gereği gerçek
Thymeleaf `${...}` sözdizimini soru metni/`code_snippet` içinde göstermek zorunda kaldı (hata `question-promotion/V699`'da GERÇEKTEN
doğrulandı: `No value provided for placeholder: ${topic.title}`). Çözüm, mekanizmayı proje genelinde kapatmaktı:
`spring.flyway.placeholder-replacement: false` (commit `ae192be`, 2026-09-02). `application.yml` yorumu bunun geriye dönük uyumlu olduğunu
söyler: hiçbir mevcut migration Flyway placeholder'larına bağımlı değildi. Phase-log Faz 166 satırı da kaydeder ("migration'da
dolar-süslü-parantez artık hata vermiyor").

**Doğrulama (2026-11-03).** `application-prod.yml`, `application-dev.yml`, `application-test.yml` ayarı geçersiz kılmıyor;
migration klasöründe **32 dosya** literal `${` içeriyor ve uygulama başlıyor; tam test seti (725 test, Flyway sıfırdan) geçiyor.

**İstisnalar ve sınırlar.**
- Ayar kapalıyken Flyway'in placeholder özelliği hiçbir migration'da kullanılamaz (proje kullanmıyor; kod taramasında bağımlılık yok).
- Ayar açılır ya da bir profil onu geçersiz kılarsa, bu 32 dosya (ve bundan sonra eklenecekler) uygulamayı yeniden durdurur. Bu yüzden
  değiştirmeden önce `grep -rl '\${' src/main/resources/db/migration` ile taramak gerekir.
- `docs/deepseek-ai-tutor-plan.md` (satır 451) hâlâ eski kuralı ("never write a literal dollar-curly-brace placeholder") "CLAUDE.md rules to
  follow" altında sayar: tarihsel bir plan metni, değiştirilmedi.

**Kaynaklar:** `src/main/resources/application.yml` (flyway bloğu yorumu); `docs/phase-log.md` Faz 24, Faz 166; `git log -S placeholder-replacement`.

---

## 3. "Beklenen Çıktı" sözleşmesi: neden bazı çıktılar panele alınmaz

**Kural:** `.out` yalnızca `scripts/example_outputs.py` ile üretilir ve elle yazılmaz/düzeltilmez; API sözleşmesiyle sabit olmayan çıktılar
panele alınmaz. (CLAUDE.md, "Mimari", "'Beklenen Çıktı' paneli".) **Ayrıntı ve düzenli ifadeler kod yorumlarındadır:** bayrakların tam listesi ve tarayan kalıplar `CONTRACT_FLAGS` ile `BLOCKING_FLAGS`'te, bayrak başına inceleme notları `RISK_NOTES`'ta; izolasyon, varyantlar, companion ve inceleme akışı script başlığında; manifest/hash
kuralı `ExampleOutputManifestTest` Javadoc'unda; staging konumu `StagingLocationTest`'te (Python, `scripts/example-outputs/test_example_outputs.py`).
Bu bölüm, script'i açmadan uyulabilmesi için kuralları ve gerekçelerini özetler; fark olursa script geçerlidir. Script'te ilgili davranış değiştiğinde bu bölüm de aynı değişiklikte gözden geçirilmelidir.

**İlke.** Panel "bu programın çıktısı budur" iddiasıdır; aynı çıktının birkaç çalıştırmada çıkması bunu kanıtlamaz (script yorumu: pilotta paralel
örnekler 9 varyantın hepsinde aynı baytları yazdı). Bu yüzden **engelleyici** bayrak hiçbir `.out` hazırlanmaması demektir; bilgilendirici bayrak
yalnızca insan incelemesine işaret eder.

**`HashMap`/`HashSet` sırası (`hash-order`).** `HashMap` Javadoc'u yineleme sırası için garanti vermez ve sıranın zamanla sabit kalacağını da
garanti etmez (Javadoc bilgisi; script yorumu yalnızca "iteration order of hash-based collections" der). Belirli bir JVM'de tekrarlanabilir
görünmesi sözleşme değildir. Aynı mantık `toSet`/`groupingBy`/`toMap`/`partitioningBy` ve `Set.of`/`Map.of` için geçerlidir.

**Dosya örnekleri.** Serbest: kendi oluşturduğu dosyaları *göreli adla*, her çalıştırmada temiz/boş/yazılabilir çalışma dizininde (sandbox `/tmp`;
sınıflar dışarıda, salt okunur) okuyup yazan örnek; panel o dizindeki **ilk** çalıştırmayı gösterir, önceden var olan dosya varsayılmaz. Engelli:

| Bayrak | Engellenen | Neden |
|---|---|---|
| `cwd-path` | mutlak, `~`'li, `..` ile çıkan yol; `toAbsolutePath()`/`getCanonicalPath()` vb. | makine yolunu yazdırır |
| `temp-file` | `createTempFile`/`createTempDirectory` | rastgele ad (`x1234567890.txt`), her çalıştırmada farklı |
| `directory-order` | `Files.list/walk/find`, `DirectoryStream`, `File.list/listFiles` | sırasız ("not in any particular order") |
| `file-metadata` | dosya zamanı, sahibi, izinleri, dosya sistemi bilgisi | makineyi ve anı anlatır |
| `optional-file-exception` | `java.nio.file` Javadoc'unda "(optional specific exception)" olan: `NoSuchFileException`, `FileAlreadyExistsException`, `DirectoryNotEmptyException`, `NotDirectoryException`, `AccessDeniedException`, `NotLinkException`, `FileSystemLoopException` | provider düz `IOException` atabilir; hangi `catch` dalının çalışacağı API ile sabit değil. `FileNotFoundException` (`FileReader`/`FileInputStream`/`FileOutputStream`) *belirtilmiştir*, engellenmez |
| `line-separator` (bilgi) | `newLine()`, `Files.write(path, lines)` | panel Linux `\n`; yalnızca not düşer (`println`/`printf("%n")` işaretlenmez) |

**Diğer engelleyici bayraklar** (hepsi `BLOCKING_FLAGS`; bu çıktıların hiçbiri panele girmez):

| Bayrak | Kapsam | Neden |
|---|---|---|
| `parallel`, `concurrency` | `parallel()`, `Thread`, `Executor`, `CompletableFuture` | zamanlama/sıra API ile sabit değil |
| `time`, `random` | `now()`, `currentTimeMillis`, `nanoTime`; `Random`, `Math.random`, `UUID.randomUUID` | her çalıştırmada farklı |
| `stdin` | `System.in`, `System.console()` | sandbox boş stdin verir; ders girdisi olmadan çıktı yanıltır (`new Scanner(String)` işaretlenmez) |
| `default-env` | `ZoneId.systemDefault`, `Locale.getDefault`, `Charset.defaultCharset`, `System.getProperty`, `availableProcessors`, `ofLocalized*` | JVM varsayılanları makineyi anlatır |
| `scanner-locale` | `Scanner` ile ondalık sayı okuma (`useLocale` ile sabitlenmediyse) | ondalık ayırıcı locale'e bağlı (`scanner-locale-set` bilgi bayrağıdır) |
| `external-io` | ağ, `ProcessBuilder`, `System.getenv`, `InetAddress` | dış dünyaya bağlı |
| `identity-text`, `object-identity`, `lambda-identity` | `hashCode()`, `toString()`i olmayan nesne, lambda/anonim sınıf metni (`Dog@1b6d3586`) | kimlik metni çalıştırmaya göre değişir |
| `optional-text` | `Optional` yazdırma | Javadoc: biçim "unspecified" |
| `priority-queue-order` | `PriorityQueue`'yu yazdırma/dolaşma/kopyalama | iterator sırası garanti değil (`poll`/`peek` serbest) |
| `count-elision` | `count()` ile biten pipeline'da `peek`/`println` | kaynak boyutu biliniyorsa pipeline atlanabilir |
| `reflection-order` | `getDeclaredFields/Methods/...()` | Javadoc: "not sorted and not in any particular order" (HotSpot'un bildirim sırasını koruması sözleşme değil) |

**Bilgilendirici bayraklar** panelden dışlamaz, yalnızca insan incelemesine not düşer: `fail-fast` (`ConcurrentModificationException`), `locale-format`, `floating-point-text`, `stream-side-effects`, `local-file`, `deletes-files`, `main-args`, `exception-text`, `stderr`. Stderr'e yazan koşu hiç panele alınmaz (yalnızca stdout gösterilir).

**İstisna mesajı kuralı (`exception-message`, `56ef740`, 2026-11-03).** İnsan incelemesi kuralı: mesaj yalnızca programın *kendi* istisna kurucusuna verdiği
*string literal* ise onaylanır; JDK'nın ürettiği mesajlar (`"/ by zero"`, `"For input string: ..."`, index mesajları) ve değişken/çalışma zamanı verisinden
kurulanlar, her parça ayrıca sabit gösterilmedikçe reddedilir (`RISK_NOTES`). Nedeni script'te yazılı değil (çıkarım: JDK mesajları API ile sabit değil).

**Companion, `.out` ve manifest.** Aynı dersin başka dosyasındaki tipi kullanan örnek o dosyayla (zincirleme) derlenir; tip dersin tam *bir* dosyasında
tanımlı olmalı, yoksa örnek `MULTI_FILE` kalır. Companion'ın JDK dışı import'u ve bayrakları örneğe de uygulanır, hash'i `manifest.tsv` `companions`
sütununa yazılır. `ExampleOutputManifestTest`, `.out`'u olan bir `.java` ya da companion'ı değişince **ve** `.out` elle değiştirilince build'i kırar. Çıkış yolu:
çıktıyı yeniden üret + incele (`generate` → `promote`), ya da `.out`'u ve manifest satırını sil.

**Akış, staging, tarih.** Panele yalnızca insan incelemesinden sonra girilir (`generate` izole Docker + sabit imaj digest'i → `review.tsv`'de örnek başına `approve`/`reject`
→ `promote --review`: tek hata varsa hiçbir dosya yazılmaz; önce `--dry-run` listesi gösterilir). Staging, `mvn clean` incelenmemiş çıktıları silmesin diye
`target/` dışındaki git-ignored `.example-outputs/`'tadır (Faz 180). Panel eklemek sayfada görünen örneği değiştirdiği, örnek dosyalar iki dilin ortak kaynağı olduğu için
iki dilin `updated_at`'ini ilerletir (bkz. §1, kural 1).

**Kaynaklar:** `scripts/example_outputs.py`; `ExampleOutputManifestTest`; `StagingLocationTest`; `docs/phase-log.md` Faz 177-181, 189-193.

## 4. Internal API ve `X-Api-Key` fail-closed

**Kural:** `/api/internal/**` yalnızca `X-Api-Key` ile; anahtar yapılandırılmamışsa istekler reddedilir.
n8n PostgreSQL'e ya da prod'a doğrudan bağlanmaz; yalnızca `/api/internal/**` HTTP uç noktalarını çağırır (ingest, salt-okunur okumalar, bayrakla kapalı `auto-publish`). (CLAUDE.md, "Mimari": Faz 87 maddesi ve Faz 144-148 güncellemeleri.)

**Kimlik doğrulama modeli.** Bu yol tarayıcı oturumu olmayan makineden makineye bir çağrıdır, bu yüzden
Spring Security'nin form girişi değil, paylaşılan sır (`QuizIngestApiKeyInterceptor`) kullanılır:
`X-Api-Key` başlığı `quiz.ingest.api-key` (`QUIZ_INGEST_API_KEY`) ile `MessageDigest.isEqual` ile **sabit
zamanlı** karşılaştırılır (zamanlama saldırısına karşı). Interceptor yalnızca `/api/internal/**`'e bağlıdır
(`WebConfig`); diğer rotalar bu kontrole tabi değildir.

**Neden fail-closed.** Ortam değişkeni verilmezse anahtar boş kalır; interceptor bu durumda "her isteği kabul et"e
değil, **tüm istekleri reddetmeye** düşer (HTTP 503, "ingestion endpoint is not configured"; yanlış/eksik başlık
401). Prod'da değişkenin unutulması böylece sessiz bir güvenlik açığı değil, yalnızca devre dışı bir uç nokta olur.

**Spring Security ile ilişki.** `SecurityConfig`'te `/api/internal/**` için ayrı bir yetki kuralı yoktur
(`anyRequest().permitAll()`; kod yorumu: "AI ingestion -- kendi X-Api-Key interceptor'ıyla zaten korunuyor") ve bu yol
CSRF'ten muaftır (tarayıcı oturumu yok): bu rotaların **tek** erişim kontrolü interceptor'dur. Bu yüzden interceptor'un
fail-closed davranışı önemlidir. *(Not: `QuizIngestApiKeyInterceptor` Javadoc'u "proje henüz Spring Security
kullanmıyor" diyor; bu Faz 138'den önceki bir durumdur ve artık yanlıştır. Kod yorumu, kural değil.)*

**Ingestion sunucuyu ezer.** Her soru `status = PENDING_REVIEW` ile kaydedilir; `QuestionIngestRequest`'te `status`
alanı **yoktur** (bir runtime kontrolü değil, DTO tasarımıyla imkânsızlık). `source` ise (eski genel `AI` değeri hiçbir gerçek satırda kullanılmamıştı, `MANUAL, CLAUDE, N8N` ile değiştirildi) çağıranın beyanıdır ama sıkı bir
izin listesine (`parseEnum`: `MANUAL`, `CLAUDE`, `N8N`, `OPENAI`) karşı doğrulanır: `source` güvenlik açısından hassas
değildir, `status` hassastır.

**n8n sınırı.** Generation workflow'larının ihtiyaç duyduğu salt-okunur veriler (konu metadata'sı, ham markdown,
mevcut sorular, çeviri adayları) n8n'in Postgres'e ya da dosya sistemine bağlanmasına izin vermemek için
**ayrı salt-okunur uç noktalar** olarak eklendi (`GenerationToolingController`/`Service`: `Question` YAZMAZ), hepsi aynı
interceptor altında. API anahtarı workflow dosyasına yazılmaz, `{{$env.QUIZ_INGEST_API_KEY}}` ile verilir. Submit
adımlarında `retryOnFail: false` + `onError: continueRegularOutput` açıkça ayarlıdır, çünkü otomatik retry ikinci bir
satır (duplicate) yaratabilir.

**İkinci anahtar: `auto-publish`.** `POST /api/internal/questions/{id}/auto-publish`, `quiz.auto-publish.enabled`
(`QUIZ_AUTO_PUBLISH_ENABLED`, varsayılan `false`) açıkça `true` olmadıkça 503 döner. Aynı `X-Api-Key` ile korunur;
bu *ayrı bir kimlik doğrulama değil*, ikinci, bilinçli bir açma/kapama anahtarıdır.

**Kaynaklar:** `QuizIngestApiKeyInterceptor`, `WebConfig`, `SecurityConfig` (CSRF muafiyet listesi), `application.yml` (`quiz.*`
yorumları); `docs/phase-log.md` Faz 87, 144, 145, 146, 148; `n8n/README.md`.

---

## 5. Development → Production promotion ve `EXPORT_SOURCE_DB_*` ayrımı

**Kural:** yeni soru üretimi/incelemesi hiçbir zaman migration olarak yazılmaz; yalnızca *promotion* bir
migration'dır; export script yalnızca AÇIK dev id listesi alır ve hiçbir veritabanına YAZMAZ (üretilen migration'ın prod'a yazılması
yalnızca normal deploy'da Flyway ile olur).
(CLAUDE.md, "Mimari" / Faz 143 güncellemesi.)

**Neden üretim migration olarak yazılmaz (gerçek bir tasarım hatasından).** Önceki taslak, `PENDING_REVIEW`
içeriği bir migration'la seed edip sonra bir `UPDATE` migration'ıyla "publish" etmeyi öneriyordu. Ama projenin
Flyway kurulumunda dev/prod için **ayrı migration lokasyonu yok** (`spring.flyway.locations` tek, profil bazında
değişmiyor). Seed migration'ı er ya da geç prod'da da çalışırdı; bir `UPDATE` yerine yeni bir promotion `INSERT`'i ise
prod'da gerçek bir **duplicate satır** yaratırdı. Nihai tasarım: üretim/inceleme yalnızca dev'e canlı API ile
(`QuestionIngestController`, kaynağı fark etmez); yalnızca onaylanan soru doğrudan `status = 'PUBLISHED'` ile tek bir
`INSERT` migration'ı (`db/migration/question-promotion/`) olarak taşınır.

**`EXPORT_SOURCE_DB_*` ≠ `DB_*` gerekçesi.** Script kaynağı `psql` ile **yalnızca SELECT** ile okur ve hiçbir veritabanına yazmaz; ama
bağlandığı sunucuyu yalnızca `EXPORT_SOURCE_DB_*` belirler (host izin listesi ya da salt-okunur transaction yoktur,
`scripts/export_approved_questions.py` `:50-54`, `:82-83`). Ortam değişkeni adları, `application-prod.yml`'in okuduğu `DB_URL`/`DB_USERNAME`/`DB_PASSWORD`'den
**kasıtlı olarak farklıdır** (`EXPORT_SOURCE_DB_HOST/PORT/NAME/USER/PASSWORD`): kullanıcı kabuğunda ilgisiz bir sebeple
prod kimlik bilgilerini dışa aktarmış olsa bile script bunları yanlışlıkla **devralamaz**. Varsayılanlar projenin kendi
`docker-compose.yml` dev kurulumuna (`localhost:5433`, `learning`) eşittir.

**Sınır (script kodundan doğrulandı):** koruma *isimlendirme* ile sağlanır, bir kimlik duvarı değildir: biri
`EXPORT_SOURCE_DB_HOST`'u bilerek prod'a işaret ederse script bağlanır ve (yalnızca SELECT ile) oradan okur. Güvence, yanlışlıkla
prod kimlik bilgisi devralmamak ve scriptin hiçbir yere yazmamasıdır. Script'in docstring'indeki "NEVER connects to production…
by construction" ifadesi yalnızca varsayılan yapılandırma için doğrudur.

**Diğer koruma kararları (kullanıcı kararı, Faz 143).**
- **Asla "tüm PUBLISHED" yok:** yalnızca açıkça verilen dev `question.id`'ler (kullanıcının bilinçli kararı; script başlığı: "never a blanket 'export everything PUBLISHED' query").
- **Statü kontrolü:** `PUBLISHED` olmayan (PENDING_REVIEW/REJECTED/DRAFT) tek bir id bile **tüm batch'i** açık bir hatayla iptal eder
  (sessizce atlamak kısmi/yanıltıcı çıktı üretirdi); seçeneği olmayan soru da reddedilir.
- **Tekrar-promote önleme bir SÜREÇ sorumluluğudur,** yapısal koruma iddia edilmez: migration başlığındaki dev id listesi
  tek kayıttır; `promoted_at` kolonu ya da unique constraint bilinçli olarak EKLENMEDİ (migration'lar ve Java kodu taranarak doğrulandı: yalnızca 7
  promotion migration'ının yorumunda "yok" diye geçer; canlı DB sorgulanmadı).
- **Taşınabilirlik:** topic dev `topic.id` ile değil `slug` alt sorgusuyla çözülür; dev id'ler yalnızca dokümantasyon/provenance
  (hiçbir SQL'de FK değeri değil); `reviewed_by`/`reviewed_at` dev satırından aynen kopyalanır (gerçek inceleme provenance'ı korunur,
  yeni bir "promoted_at" damgası yok). Flyway sürüm numarası klasör taranarak otomatik belirlenir.

**Kaynaklar:** `scripts/export_approved_questions.py` (başlık docstring'i, `SOURCE_DB_*`); `docs/phase-log.md` Faz 143;
`docs/known-constraints.md` ("Faz D").

---

## 6. Google ile giriş: hesap bağlama politikası

**Kural:** Google kimliği `sub` ile tanınır, e-postayla değil; e-postası eşleşen mevcut hesap otomatik bağlanmaz; ADMIN
Google'la giremez. (CLAUDE.md, "Mimari", "Google ile devam et".)

**Neden `sub`, e-posta değil.** Faz 185 kaydı yalnızca "Google hesabı e-postayla değil `sub` ile tanınır" der. Gerekçe (genel OIDC ilkesi, projeye özgü kayıt değil): `sub` hesabın kalıcı kimliğidir, e-posta değişebilir.
Eşleme `user_identity(provider, provider_subject)` ile yapılır (`UNIQUE(provider, provider_subject)` ve `UNIQUE(user_id, provider)`).
Profil fotoğrafı ve token DB'ye yazılmaz.

**Neden e-postası eşleşen hesaba OTOMATİK bağlanmaz (kullanıcı kararı 1).** Kayıtta e-posta **doğrulanmıyor**.
Kaynak (phase-log Faz 185): "önceden kaydedilmiş bir e-posta hesap ele geçirmeye yol açardı". Yani kayıtta e-posta sahipliği
kanıtlanmadığı için, e-postaya güvenerek otomatik bağlamak **hesap ele geçirme** yolu olurdu. Bu yüzden o hesabın **şifresi** istenir
(`/{lang}/login/google/link`, 5 yanlış denemede akış biter). Google'dan gelen `email_verified` değilse kimlik reddedilir.

**Diğer politika kararları.**
- Yeni Google kullanıcısı, kayıt formundaki AYNI **Kullanım Koşulları** kutusunu işaretlemeden hesap açılmaz
  (`created_at` = onay anı, kayıt formuyla aynı kural).
- Bağlı olmayan doğrulanmış kimlik **giriş sayılmaz**: 10 dakikalık, session'a bağlı `PendingGoogleSignIn` olarak bekler.
- **Yetki yalnızca `app_user.role`'den:** principal'ın `getName()`'i yerel e-postadır (`GlobalModelAttributes` ve Question Review
  `reviewedBy` bunu varsayar); Google claim'leri yetki vermez.
- Hesap açma/bağlama sonrası eski session kapatılıp yenisi açılır (session fixation ve yeni CSRF token); bütün POST'lar CSRF korumalı.
- Şifresiz (yalnızca Google'la açılmış) hesap şifre formundan giremez; hata, "kullanıcı yok" ile aynıdır (bilgi sızdırmaz).
- E-posta kayıtta, Google eşleştirmesinde ve şifreyle girişte AYNI kuralla normalize edilir (`UserRegistrationService.normalizeEmail`:
  `trim()` + `toLowerCase(Locale.ROOT)`). `Locale.ROOT` seçimi, `tr-TR` varsayılan dilde `I`→`ı` (noktasız) dönüşümünün
  eşleşmeyi bozmasını önler. `lower(email)` unique index'i bilinçli eklenmedi (migration + prod verisi önce kontrol edilmeli).

**ADMIN hesabı Google'la bağlanamaz/giremez (inceleme bulgusu F4, kullanıcı kararı).** Kural tek yerde:
`GoogleAccountService.allowsGoogleSignIn(User)` (`role != ADMIN`, rol her seferinde DB'deki güncel satırdan). Üç noktada uygulanır:
(1) `GoogleOidcUserService.loadUser`: bağlı hesap ADMIN ise `google_admin_not_allowed`, oturum açılmaz; e-postası bir ADMIN hesabına ait
henüz bağlı olmayan kimlik de parola sayfasından ÖNCE reddedilir; (2) `GoogleAccountService.link`: hedef ADMIN ise **şifreye bakılmadan**
`NOT_LINKABLE` (bağlama formu yönetici şifresini denemek için kullanılamasın); (3) `createAccount`'un "zaten bağlı" kısa yolu.
Kullanıcıya gösterilen mesaj rolü/nedeni söylemeyen genel bir cümledir (`google_link_unavailable`).
**İstisnalar/sınırlar:** sonradan ADMIN yapılan hesabın `user_identity` satırı SİLİNMEZ, yalnızca kullanılamaz; yalnızca Google'la açılmış
(şifresiz) bir hesap ADMIN yapılırsa **hiçbir giriş yolu kalmaz**; yönetici yapılacak hesabın şifresi olmalıdır. Unlink arayüzü yok.

**Teknik kararlar.** İstemci yalnızca `GOOGLE_CLIENT_ID` **ve** `GOOGLE_CLIENT_SECRET` verilince kurulur (`GoogleSignInConfig`;
Boot'un `spring.security.oauth2.client.*` özellikleri bilinçli kullanılmadı, çünkü boş client-id uygulamayı açtırmazdı); yoksa buton gizli,
şifreyle giriş aynen çalışır. İki değişken birlikte verilmeli: yalnızca `GOOGLE_CLIENT_ID` verilirse `GoogleSignInConfig`'teki `Assert.hasText`
uygulamayı başlatmaz (bilinçli fail-fast; yanlış yapılandırma sessizce Google girişsiz kalmasın). PKCE gizli istemciye rağmen açıktır (derinlemesine savunma). Redirect URI `app.base-url` + `/login/oauth2/code/google`. Prod session çerezi
`Secure` + `SameSite=Lax`: **`Strict` olamaz**, çünkü Google dönüşü siteler arası üst-seviye GET'tir ve Strict çerezi göndermez (akış kırılır);
`Secure` ise proxy arkasında Tomcat bağlantıyı http sandığı için canlıda eksik görüldü ve `application-prod.yml`'de eklendi.
Scope yalnızca `openid email profile`; ID token imzası/issuer/audience/süre/nonce ve `state` Spring tarafından doğrulanır, aynı `state`
ikinci kez kullanılamaz.

**Uygulama noktaları (ADMIN erken reddi).** `GoogleOidcUserService.loadUser` ve `GoogleSignInController.render`, ikisi de
`GoogleAccountService.isGoogleSignInBlockedForEmail` üzerinden `allowsGoogleSignIn`'e sorar (kural yine tek yerde). Prod doğrulamaları
(2026-10-24/25) ve deployment kimlikleri phase-log Faz 185 satırındadır. **Etkinleştirme/yeniden kurulum adımları (Google Console, redirect URI,
izin ekranı, Railway değişkenleri) güvenlik kuralı değil işletim bilgisidir: `docs/google-sign-in-operations.md`.**

**Kaynaklar:** `docs/phase-log.md` Faz 185 (tam anlatım); `docs/google-sign-in-operations.md` (işletim); `GoogleAccountService`, `GoogleOidcUserService`, `GoogleSignInConfig`,
`application-prod.yml`; `docs/known-constraints.md`.

---

## 7. Soru havuzu ve yayınlama kuralları

**Kural:** `status='PUBLISHED'` filtresi pool sorgusuna sabit; sabit quiz üyeliği statüden bağımsızdır; ingestion hep `PENDING_REVIEW`.
(CLAUDE.md, "Mimari", Faz 87 maddesi.)

**Neden genel bir "soru havuzu".** Eski "bir soru = doğrudan bir quiz'e ait" modeli, AI/n8n'in sürekli yeni soru üreteceği, sabit quiz'lerin ve
rastgele bir Practice modunun aynı soruları farklı biçimde tüketeceği bir sisteme yetmedi. `Question` artık topic+language'e bağlı ama hiçbir `Quiz`'e
bağlı olmak zorunda değil; `Quiz` ↔ `Question` ilişkisi `quiz_question_link`'te (`position`, TEK sıralama kaynağı).

**Neden `status='PUBLISHED'` filtresi sorgunun KENDİSİNE sabit.** `PENDING_REVIEW`/`REJECTED`/`DRAFT` sorular Practice/Quiz Area havuzuna
sızmamalı; filtre `QuestionRepository.findRandomPublishedPool` native sorgusuna yazılıdır, hiçbir çağıran override edemez.
**Sabit quiz üyeliği ise statüden bağımsızdır:** `QuizService.loadQuiz()` hiçbir status filtresi uygulamaz. Yani bir soruyu `PUBLISHED`
yapmak onu OTOMATİK olarak hiçbir topic'in sabit quiz'ine eklemez (yalnızca havuza girer: Practice/Quiz Area). Sabit quiz'e soru eklemek ayrı,
açık bir `quiz_question_link` seed adımıdır (topic + language + quiz slug ile portable çözen migration deseni).

**Neden `ON DELETE RESTRICT` (`quiz_question_link.question_id`).** Canlı bir sabit quiz'in parçası olan soru hard-delete edilemesin; kaldırmak
isteyen `status = REJECTED` yapar.

**Puanlama (`QuestionScorer`).** İki modda AYNI kural: seçilen şık id kümesi doğru şık id kümesiyle **birebir** eşleşmeli; `MULTIPLE_CHOICE`
kısmi doğruyu kabul etmez. Practice'te submit tam kapsama zorunlu değil (sabit quiz'in aksine); her cevap bağımsız doğrulanır: soru var mı, hâlâ
`PUBLISHED` mi, dile ait mi.

**Ingestion doğrulaması.** Tip başına doğru-şık-sayısı: `SINGLE_CHOICE`/`CODE_OUTPUT` tam bir, `MULTIPLE_CHOICE` bir veya daha fazla. `CODE_OUTPUT` için `codeSnippet` zorunlu, diğer tiplerde yasak (topic sayfası kodu mevcut `hljs.highlightAll()` ile çizer, ayrı JS gerekmedi). Bu doğrulama DB'de değil servis/ingestion
katmanındadır: global "soru başına en fazla bir doğru şık" kısıtı (`uq_quiz_option_one_correct_per_question`) `MULTIPLE_CHOICE`'ı DB seviyesinde
engellediği için kaldırıldı. **Gerçek hata:** V288 bu kısıtı yalnızca yeniden ADLANDIRMIŞTI; düzeltme `V293`'te `DROP INDEX` ile yapıldı (bu bir table
CONSTRAINT değil, bir partial UNIQUE INDEX'ti: `ALTER TABLE ... DROP CONSTRAINT` yanlış olurdu), ve `idx_question_pool` (`topic_id, language, type,
difficulty, status`) eklendi.

**Neden `Quiz.passThreshold` `BigDecimal`.** Kolon `NUMERIC(3,2)`'dir (kesin ondalık); `Double` map'lenince Hibernate'in `ddl-auto: validate`
şema doğrulaması `float(53)` beklediği için gerçek `NUMERIC` kolonla çakışır. Aynı kural `AiUsageLog.estimated_cost_usd` (`NUMERIC(12,6)`) için de geçerlidir:
NUMERIC/DECIMAL kolonlu her yeni alan `BigDecimal` olmalı.

**Tarayıcı sözleşmesi (Faz 88, gerçek bir regresyon).** Faz 87'de `QuizSubmitRequest` düz `{selectedOptionIds}` gövdesinden gruplu
`answers[{questionId, selectedOptionIds}]`'e geçti ve `quiz.js`'in aynı fazda güncellendiği RAPORLANDI, ama gerçekte değiştirilmemişti:
kullanıcının kendi tarayıcısında `400 Bad Request` ("answers is required") ile ortaya çıktı; `renderResults()` de artık var olmayan tekil
`selectedOptionId`/`correctOptionId` alanlarını okuyordu. Ayrıca `topic.html` `MULTIPLE_CHOICE` için hâlâ `radio` çiziyordu (tarayıcıda birden fazla
şık seçilemezdi). Düzeltme: `collectAnswers()` her soru için ayrı `{questionId, selectedOptionIds}` toplar, `th:type` tipe göre `checkbox`/`radio`
seçer (`quiz.js` genel `:checked` sorgusu kullandığı için başka JS değişikliği gerekmedi), backend DOKUNULMADI. **Ders:** istemci/sunucu sözleşmesi
değişince "güncellendi" demek yetmez, gerçek tarayıcıda uçtan uca doğrulanır. `CODE_OUTPUT` sorularında kod yalnızca `codeSnippet`'te durur; AI'nın
yanlışlıkla `question` metnine de gömdüğü çitli kod bloğu yalnızca *sunumda* düşürülür (`QuestionReviewView.questionDisplayText()`, DB'deki `question`
sütununa dokunmaz; Faz 147).

**Yayınlama (Question Review, Faz 141/142).** `publish`/`reject` yalnızca `PENDING_REVIEW`'dan geçişe izin verir; zaten `PUBLISHED`/`REJECTED`
bir soruya tekrar çağrı `409 Conflict` döner ve satırı değiştirmez; `reviewedBy`/`reviewedAt` doldurulur. Public havuza sızma/dışlanma ek kod
gerektirmez: pool sorgusunun sabit filtresi `publish()` anında soruyu otomatik uygun yapar. *(CLAUDE.md'nin Faz 87 maddesindeki "review için ayrı
admin arayüzü YOK" cümlesi Faz 141/142'den beri güncel değildir.)* Admin arayüzü `/{lang}/admin/questions` (ADMIN); Publish/Reject formları
CSRF korumalıdır (anonim JSON uç noktalarının aksine muaf DEĞİL).

**Quiz soru eklerken: önce shell'i kontrol et (Faz 157).** Bazı kursların topic-oluşturma migration'ları (`docker`, `git-github`) o topic için EN+TR quiz
shell'ini (`INSERT INTO quiz ... slug='default'`) içerik yazılırken ZATEN ekler; `ai`/`postgresql` eklemez. Standart dört dosyalık desen (promotion +
shell + EN link + TR link) körü körüne tekrarlanınca disposable-DB doğrulaması gerçek bir `duplicate key ... quiz_topic_id_language_slug_key`
hatasıyla başarısız oldu. **Kalıcı ders:** yeni quiz soruları eklemeden önce `grep -rl "INSERT INTO quiz"` ile topic'in migration'ları taranır;
shell varsa yalnızca promotion + link yazılır.

**Quiz Area ve seed'ler (Faz 139).** Quiz Area (`QuizDefinition`: `course` FK + kategorilerle `@ManyToMany`) sabit quiz'e ve Practice'e eklenen AYRI bir
kavramdır; onların yerine geçmez. **Boş kategori kümesi = tüm kurs** (`QuizDefinition` Javadoc'u). Soru çekme tarafı Quiz Area'ya özgüdür, submit/puanlama ise
`PracticeService.submit` ile paylaşılır. **Seed durumu (2026-11-05 migration taraması, `db/migration/quiz-area/`):** `java` için `V430`
(`basic-java` = `java-basics` + `control-flow`; `advanced-java` = `exceptions` + `generics` + `collections` + `oop` + `concurrency` +
`functional-interfaces-streams`; `all-java` = tüm kurs), `spring-boot` için `V1015`, `ai` için `V1064`. `react`, `postgresql`, `git-github` ve `docker`
kurslarının henüz `quiz_definition` seed'i yoktur. Bu liste zamanla bayatlar; yeniden doğrulamak için
`grep -rl "INSERT INTO quiz_definition" src/main/resources/db/migration`.

**Kaynaklar:** `docs/phase-log.md` Faz 87, 88, 139, 141, 142, 150, 157; `docs/known-constraints.md` ("Faz 157"); `QuestionRepository`,
`QuizService`, `QuestionScorer`, `QuestionReviewService`.
