# CLAUDE.md sadeleştirme: dış referans envanteri (Aşama 1)

Geçici çalışma dokümanı (`docs/claude-md-trim` dalı). Sadeleştirme bitince silinebilir ya da
`architecture-rationale.md`'ye bir "bağımlılıklar" bölümü olarak taşınabilir.
Taban: `CLAUDE.md` 89.126 bayt, 1.196 satır (HEAD `56ef740`, 2026-11-03).

Hiçbir kod CLAUDE.md'yi **okumuyor ya da ayrıştırmıyor** (`open`, `Path`, `Files.read` taraması
temiz): bütün referanslar yorum, dokümantasyon ya da ders metni. Bu yüzden kısaltma hiçbir
derlemeyi/testi kırmaz; asıl risk, referansların işaret ettiği KURALIN kaybolması.

## 1. Canlı kod, yapılandırma ve skill referansları (düzenlenebilir)

| Referans veren | Ne diyor | CLAUDE.md'de kalması gereken |
|---|---|---|
| `SecurityConfig.java:49` | `{lang:en\|tr}` path değişkeni (bkz. "Mimari") | "Mimari" başlığı + dil URL kuralı |
| `SecurityConfig.java:125` | yeni anonim POST API'si CSRF muafiyet listesine eklenir (bkz. "Mimari") | CSRF muafiyet kuralı (Faz 138 maddesi) |
| `GoogleSignInSession.java:29` | varsayılan dil İngilizce | i18n: varsayılan dil kuralı |
| `GoogleSignInConfig.java:21` | redirect URI `app.base-url`'den ("mutlak URL...") | `app.base-url` kuralı |
| `TopicController.java:199` | `show()`'a kasıtlı dokunulmadı (bkz. CLAUDE.md "ilgisiz kodu refactor etme") | "Token ve Bağlam Verimliliği" bölümündeki **"İlgisiz kodu refactor etme"** kuralı (kelimeleri aynen) |
| `AiUsageLog.java:100` | `NUMERIC` kolon → `BigDecimal` | NUMERIC/`BigDecimal` kuralı (Faz 87 maddesi) |
| `application.yml:16` | Flyway placeholder: "Migration dosyalarında..." | Flyway `${...}` kuralı, başlığıyla |
| `topic-pdf.html:6,12` | "CLAUDE.md kod-blokları kararı: v1'de düz monospace" (**CLAUDE.md'de bu karar yok**, yalnızca phase-log'da, dolayısıyla zaten kopuk); "tek doğruluk kaynağı, bkz. 'Mimari'" | "Mimari" başlığı + içerik tek kaynak kuralı |
| `content-check/SKILL.md:84`, `check_content.py:614` | `updated_at` kuralı (bkz. "Mimari") | Tarih kuralı 1-4, "Mimari" altında |
| `n8n/workflows/question-generation-enum-test.json:44` | H2 anahtarı: CLAUDE.md "Icerik Yazim Formati" | "İçerik Yazım Formatı" bölümü (H2 yapısı) |
| `examples/spring-mvc-views-thymeleaf/SelectionExpressionExample.java:18` | "Known Constraints" (SpelEvaluationException) | Bilinen Kısıtlar içinde bu kısıt (`docs/known-constraints.md`'de de var mı: Aşama 3'te doğrulanacak) |
| `examples/spring-mvc-views-thymeleaf/FormBindingExample.java:5` | "Example Writing Principles" (bağlantısız katman ekleme) | "Örnek Yazım İlkeleri" bölümü |

Not: son iki satır İngilizce başlık adı veriyor ("Known Constraints", "Example Writing Principles");
CLAUDE.md'deki gerçek başlıklar Türkçe. Bu iki yorum ZATEN tam eşleşmiyor.

## 2. Yayındaki ders içeriği: CLAUDE.md'den alıntı yapan cümleler (EN + TR)

Bunlar okuyucuya CLAUDE.md'nin bir şey söylediğini iddia ediyor. Kural silinirse ders yanlış olur.

| Ders | İddia | Korunacak kural |
|---|---|---|
| `developing-with-claude-code` (EN `:237`, `:249`) | migration numaraları klasörden bağımsız tek global dizi, alt klasörler yalnızca dosya sistemi düzeni | Flyway: alt klasör yalnızca düzen |
| aynı (EN `:381`, `:485`) | "Flyway migration numbers are sequential and never renumbered retroactively" (tırnaklı) | Flyway: sıralı, geriye dönük asla değişmez |
| aynı (`:73`, `:430`-`:432`, `:519`, `:536`) | genel anlatım ("CLAUDE.md kökte, otomatik okunur") | Kural değil, dosyanın varlığı |
| `claude-code-cli-commands` (`:183`-`:186`) | "Compact instructions" bölümü eklenebilir | Kural değil, Claude Code özelliği |
| `joins`, `inserting-updating-and-deleting-data` | iki adımlı yayın (TR hemen, EN sonra) CLAUDE.md'de belgeli | "Yayın durumu çeviri seviyesinde" + iki adım |
| `databases-schemas-tables-and-basic-sql` (`:62`) | `topic_translation` tasarım gerekçesi CLAUDE.md ile aynı | "Yayın durumu çeviri seviyesinde" |
| `postgresql-specific-data-types` (`:18`) | "tek uygulamalı mimari CLAUDE.md'de bilinçli kısıt olarak belgeli" | **CLAUDE.md'de böyle açık bir ifade bulunamadı.** Zaten gevşek bir referans, değiştirmem, raporda işaretliyorum |

## 3. Docs referansları

- `docs/skills-plan.md` §6 ve §8: daha önce (2026-10-05) aynı sadeleştirme planlanmıştı. Orada ek karar:
  eski sandbox iddialarının (Maven Central engelli, `mvn -o`/Lombok, ZIP teslimatı, `cdn.jsdelivr.net`,
  "javac yapılmıyor") bu makinede geçersiz olduğu tek tek doğrulanmış; ve **Maven'ın varsayılan JDK 26 ile
  çalışıp Lombok'u kırdığı, `JAVA_HOME`'un JDK 21 olması gerektiği** CLAUDE.md'de eksik gerçek kısıt.
  Bu bilgi şu an yalnızca kullanıcı hafızasında ve skills-plan'da.
- `docs/google-seo-adsense-plan.md:415`: `updated_at` kuralı (bkz. "Mimari").
- `docs/deepseek-ai-tutor-plan.md:451, :1274-:1276`: CLAUDE.md'deki `${...}` kuralına uyulacağı; AI Tutor için bir "CLAUDE.md notu" planlanmış ama dağıtım sonrası yazılacağı bekletilmiş.
- `docs/mcp-server-plan.md:454, :533`: MCP için yeni bir mimari bullet planı (henüz yazılmamış).
- `docs/phase-log.md` (57) ve `docs/known-constraints.md` (6): tarihsel anlatım, dokunulmaz.

## 4. Donmuş (değiştirilemez) referanslar: Flyway migration yorumları

~60 migration dosyası yorumlarında CLAUDE.md'ye atıf yapıyor. Flyway checksum'ı yüzünden bu dosyalar
DEĞİŞTİRİLEMEZ. Birçoğu zaten **artık var olmayan başlıklara** atıf yapıyor ("Sıradaki Adım",
"Faz Geçmişi", "Kesinlikle Değişmeyecek Kurallar", "Faz 55/60/61 notu", "Faz 87 maddesi"). Bunlar
şu an da çözülemiyor; sadeleştirme durumu değiştirmez. Yaşayan olanlar:

- `updated_at` kuralı (15 migration dosyasında "updated_at kuralı" ifadesi geçiyor)
- Flyway placeholder hatası (Faz 23), `"Kesinlikle Değişmeyecek Kurallar"` (başlık adı artık "Mimari...")
- `topic.sort_order` kategoriye özel
- "iki adımlı yayın" kuralı, "DB ↔ dosya" slug bağı
- Quiz havuzu "Faz 87 maddesi" (soru içeriği yalnızca ingestion API'den)
- `CLAUDE.md` dosyasının KENDİSİ hakkındaki quiz sorusu migration'ları (V1129, V1131, V1132: dosya adı, kural değil)

**Sonuç:** "updated_at kuralı", "Flyway placeholder", "sort_order kategoriye özel", "iki adımlı yayın",
"DB ↔ dosya" kuralları adlarıyla CLAUDE.md'de bulunabilir kalmalı. "Mimari" başlığı korunur.

## 5. Korunacak başlık adları

`## Mimari — Bunlar Kesinlikle Değişmeyecek Kurallar` (adı aynen), `## İçerik Yazım Formatı (Her Yeni
Konu İçin)`, `## Örnek Yazım İlkeleri`, `## Bilinen Kısıtlar`. Başlıkların sonundaki parantez açıklamaları
(`(Faz 18'den itibaren ...)`) kısaltılabilir; ilk kelimeler aynı kalır.

## 6. Yazılı olmayan ama kaybolmaması gereken

- CLAUDE.md'de olmayan, ama kodun/skill'in referans verdiği: yok (tarama temiz).
- Kullanıcı hafızasında olup CLAUDE.md'de olmayan: JDK 21 / `JAVA_HOME` (skills-plan §8 de bunu CLAUDE.md'ye alınması gereken kısıt sayıyor).

## 7. Taban durum (Aşama 1, 2026-11-03, HEAD `56ef740`)

- `CLAUDE.md`: 89.126 bayt, 1.196 satır. Tahmini ~21.000 token (bayt/4,24; gerçek `/context` ölçümü ayrıca eklenecek).
- `mvn -B test` (JDK 21, `TZ=Europe/Istanbul`): **725 test, 0 hata, 0 başarısızlık, 0 atlanan, BUILD SUCCESS**, 1 dk 02 sn.
  Yalıtım: tek kullanımlık `postgres:16-alpine` container'ı (127.0.0.1:5443), `SPRING_DATASOURCE_URL` ile; var olan
  hiçbir DB container'ına dokunulmadı. Test sonrası container silindi.
- `scripts/example-outputs` Python testleri: 139 test, OK. `deploy-check` Python testleri: 23 test, OK.

### Gerçek token ölçümü (Aşama 1, `/context`, yeni oturum)

- `Memory files: 45.6k` token (%11,4): **CLAUDE.md ~45k**, MEMORY.md 596 token.
- Bu, bayt/4,24 tahminiyle (~21k) **uyuşmuyor**: gerçek oran yaklaşık **1,98 bayt/token** (Türkçe + kod + sembol yoğun metin, ASCII dışı karakterler çok baytlı).
- Bu belge ve sonraki raporlardaki bütün token tahminleri **1,98 bayt/token** ile hesaplanır. `/context` değeri yuvarlanmış (±~1k).
- `/usage` ekranındaki "21k tokens per request" ile `/context`'teki 45k farkı açıklanamadı; karar `/context` ölçümüne dayanır.

## 8. Gerekçe defteri (Aşama 2): kural → kaynak → hedef

Hedef: `docs/architecture-rationale.md` (§ numaraları aşağıda). "CLAUDE.md" sütunu, kuralın bugünkü başladığı satırı gösterir.
İşaretler: **✔** anlam ve kapsam aynı · **◐** yeniden ifade/kısaltma, anlam ve istisna korunmuş · **➕** hedefte kaynaktan gelen ek
(kaynağı belirtildi) · **⚠** bulgu/karar gerekir · **↺** CLAUDE.md'de KALACAK (taşınmadı).
Her satır elle, kaynak metin ile hedef metin yan yana okunarak işaretlendi; script yalnızca ek kontroldü (bölüm 9).

### 8.1 Tarih kuralı + `datePublished` (CLAUDE.md `:79`) → rationale §1

| # | Kaynaktaki iddia | Hedef | İşaret | Not |
|---|---|---|---|---|
| T1 | İki kolon, `DATE`, `core/V1137` | §1 Kural satırı | ✔ | |
| T2 | `updated_at` → "Son güncelleme", JSON-LD `dateModified`, sitemap `<lastmod>` | §1 Gerekçe (ilk paragraf) | ✔ | |
| T3 | `published_at` hiçbir yerde yayınlanmaz (sayfa, `datePublished`, sitemap); gerçek yayın tarihini garanti etmediği için; `datePublished` EKLEME | §1 "neden `datePublished` YOK" | ✔ | Ek ayrıntı (EN çeviriler commit sonrası yayına alındı, "birkaç gün erken") kaynağı: seo-plan satır 392-399 ➕ |
| T4 | Tarihler otomatik değil; git'ten/çalışma anında türetilmez; yalnızca migration; içerik dosyada yaşadığı için DB kendiliğinden değişmez | §1 "neden tarihler otomatik değil" | ✔ | V1137 başlığı alıntısı yalnızca ilk doldurma için; metin buna göre düzeltildi |
| T5 | Kural 1: açık tarihli migration; metin yalnız kendi dili, örnek kod iki dil; yazım/`seo_*`/şablon/stil tarihi değiştirmez | §1 Kural 1 | ✔ | `V1139` örneği korundu |
| T6 | Kural 2: `INSERT` değişmeden; `DEFAULT CURRENT_DATE` | §1 Kural 2 | ◐➕ | "varsayılan en sona verildi" ayrıntısı V1137 başlığından |
| T7 | Kural 3: EN yayında `publish_{slug}_english` + açık `updated_at` | §1 Kural 3 | ✔ | Migration adı eklendi (ilk taslakta eksikti) |
| T8 | Kural 4: `published_at` değişmez; `updated_at >= published_at` DB kısıtı | §1 Kural 4 | ➕ | Kısıt adı V1137'den; "neden" cümlesi kaynakta yok, kısıt mantığından |
| T9 | Mevcut 336 çevirinin `published_at` = ilk commit tarihi | §1 `datePublished` bölümü | ✔ | |
| T10 | (kaynakta yok) güncelleme migration'ında neden açık tarih? | §1 "Kaynakta yok (çıkarım)" | ⚠ | **Hiçbir dokümanda gerekçe yok.** Çıkarım olarak işaretli; kullanıcı onayı/bilgisi gerek |
| T11 | (kaynakta yok) `V1137` ilk yorum satırı `datePublished`'dan söz eder | §1 Geçmiş | ➕ | seo-plan satır 399-400'den |

### 8.2 Flyway `${...}` (CLAUDE.md `:162`) → rationale §2

| # | Kaynaktaki iddia | Hedef | İşaret | Not |
|---|---|---|---|---|
| F1 | Varsayılan placeholder sözdizimi tam olarak `${...}`; yorumlar dahil dosyanın tamamı taranır | §2 Teknik neden | ✔ | |
| F2 | Eşleşen her biri için değer beklenir; yoksa `No value provided for placeholder` ve TÜM uygulama başlamaz | §2 Teknik neden | ✔ | |
| F3 | Faz 23, `spring-mvc-views-thymeleaf`; Thymeleaf `${...}`'dan bahsederken yaşandı | §2 Geçmiş | ◐ | Migration numarası V108 phase-log Faz 24 satırından ➕ |
| F4 | "dolar-süslü-parantez" yaz; `@{...}`/`#{...}` sorun değil, yalnızca `$` önekli tetikler | §2 Teknik neden + Geçmiş | ✔ | |
| F5 | (kaynakta yok) `placeholder-replacement: false` | §2 "Güncel durum" | ⚠ | **Bulgu:** kural artık teknik olarak zorunlu değil (bölüm 10'da ayrıntı). Silmeyi/korumayı kullanıcı seçecek |

Flyway'in diğer kuralları (migration'lar sıralı ve geriye dönük değişmez, alt klasör yalnızca düzen, apostrof `''`, `sort_order`): ↺ CLAUDE.md'de kalır; gerekçe zaten kısa ve yayındaki dersler alıntılıyor.

### 8.3 "Beklenen Çıktı" (CLAUDE.md `:40`) → rationale §3

| # | Kaynaktaki iddia | Hedef | İşaret | Not |
|---|---|---|---|---|
| E1 | `.out` varsa kod bloğunun altında gerçek stdout paneli | §3 Genel ilke | ◐ | Panelin ne olduğu kuralda kalır |
| E2 | `.out` elle yazılmaz/düzeltilmez; yalnızca `generate` (izole Docker, sabit imaj digest'i); insan incelemesi → `promote` → `manifest.tsv` hash | §3 "İnsan inceleme akışı" | ✔ | |
| E3 | API sözleşmesiyle sabit olmayan çıktılar (HashMap/HashSet sırası, paralel, thread, zaman, rastgelelik, ağ/süreç/ortam) çalıştırmada aynı çıksa da panele alınmaz | §3 Genel ilke + hash-order + "Diğer" | ✔ | **Kritik:** "aynı çıksa da alınmaz" gerekçesi script yorumundaki 9-varyant pilot gözleminden (➕ kaynak: `scripts/example_outputs.py`) |
| E4 | Dosya örnekleri yalnızca kendi dosyalarını, göreli adla, çalışma dizininde; her çalıştırma temiz/boş/izole (sandbox `/tmp`, sınıflar salt okunur); panel İLK çalıştırmayı gösterir; önceden var olan dosya varsayılmaz | §3 "Dosya örnekleri" | ✔ | |
| E5 | Engelli: mutlak/`~`/`..` yol; `toAbsolutePath()`; `createTemp*`; sıralanmamış dizin listesi; dosya zamanı/sahibi/izin; Javadoc "optional specific exception" `java.nio.file` istisnaları | §3 (altı madde) | ✔ | Her madde için neden script yorumundan ➕; `FileNotFoundException` karşıt örneği korundu |
| E6 | Satır sonu Linux `\n`; `newLine()`/`Files.write(path, lines)` yalnızca not düşer | §3 son madde | ✔ | |
| E7 | Companion: zincirleme, tip tek dosyada tam tanımlı değilse `MULTI_FILE`; JDK dışı import ve bayraklar uygulanır; hash `companions` sütunu | §3 "Companion kuralı" | ✔ | |
| E8 | `ExampleOutputManifestTest` değişince kırar; çıkış: yeniden üret + incele ya da `.out`+manifest satırını sil | §3 Companion kuralı sonu | ✔ | İlk taslakta çıkış yolu eksikti, eklendi |
| E9 | Panel eklemek iki dilin `updated_at`'ini ilerletir (`V1139`) | §3 "Panel eklemek..." + §1 Kural 1 | ✔ | |
| E10 | Dalga akışı (Faz 178): `generate --topic [--dry-run]` → `review.tsv` approve/reject → `promote --review` (tek hata varsa hiçbir dosya yazılmaz); `--dry-run` gösterilir | §3 "İnsan inceleme akışı" | ✔ | |
| E11 | Staging `.example-outputs/` (git-ignored), `target/` DEĞİL; `mvn clean` silmesin; `StagingLocationTest` | §3 "Staging neden" | ✔ | |
| E12 | Aynı anda: istisna mesajı kuralı (2026-11-03, hafızadan) | §3 "İstisna mesajı kuralı" | ◐ | CLAUDE.md'de ayrı yok; script `RISK_NOTES`'tan. "Neden" cümlesi çıkarım olarak işaretli |

### 8.4 Internal API ve fail-closed (CLAUDE.md `:215` Faz 87 maddesi, `:771`-`:919` GÜNCELLEME 144-148) → rationale §4

| # | Kaynaktaki iddia | Hedef | İşaret | Not |
|---|---|---|---|---|
| I1 | `X-Api-Key`; anahtar `quiz.ingest.api-key`/`QUIZ_INGEST_API_KEY`; yapılandırılmamışsa REDDEDİLİR (fail-closed) | §4 Kimlik doğrulama + Neden fail-closed | ✔ | HTTP kodları (503/401) ve sabit zamanlı karşılaştırma koddan ➕ |
| I2 | Ingestion hep `PENDING_REVIEW`; `status` DTO'da yok ("sunucu ezer" DTO tasarımına dayanır) | §4 "Ingestion sunucuyu ezer" | ✔ | |
| I3 | `source` izin listesi (MANUAL/CLAUDE/N8N; Faz 147'den OPENAI) | §4 | ✔ | |
| I4 | n8n PostgreSQL'e/prod'a bağlanmaz; yalnızca API; salt-okunur uç noktalar (`topics/{slug}`, `content`, `existing`, `for-translation`) | §4 "n8n sınırı" | ◐ | Yol adları kuralda (CLAUDE.md) kalacak; burada kategori. Kaynak yolları satır-satır tekrarlanmadı |
| I5 | API anahtarı workflow'a yazılmaz (`{{$env...}}`); `retryOnFail:false`, `onError:continueRegularOutput` (duplicate) | §4 "n8n sınırı" | ✔ | |
| I6 | auto-publish `QUIZ_AUTO_PUBLISH_ENABLED` varsayılan kapalı, 503; aynı `X-Api-Key` | §4 "İkinci anahtar" | ✔ | `application.yml` yorumundan ➕ |
| I7 | (kaynakta yok) `/api/internal/**` CSRF muaf, `permitAll`, tek kapı interceptor | §4 "Spring Security ile ilişki" | ➕ | `SecurityConfig` yorumundan; interceptor Javadoc'unun "Spring Security yok" cümlesi bayat (⚠ kod yorumu, bu aşamada değiştirilmedi) |

### 8.5 Promotion ve `EXPORT_SOURCE_DB_*` (CLAUDE.md `:751`) → rationale §5

| # | Kaynaktaki iddia | Hedef | İşaret | Not |
|---|---|---|---|---|
| P1 | Yalnızca açık dev id listesi; asla "tüm PUBLISHED" | §5 "Diğer koruma kararları" | ✔ | |
| P2 | Salt-okunur `psql`; prod'a bağlanabilecek kod yolu yok; env adları `DB_URL/USERNAME/PASSWORD`'den kasıtlı farklı (`EXPORT_SOURCE_DB_*`) → "yapısal" | §5 `EXPORT_SOURCE_DB_*` | ◐ | **Kapsam netleştirmesi:** "yapısal" = yanlışlıkla kimlik bilgisi devralma ve yazma yolunun yokluğu; `EXPORT_SOURCE_DB_HOST`'un bilerek prod'a verilmesini engellemez (script kodundan çıkarım, işaretli) |
| P3 | Tekrar-promote önleme süreç sorumluluğu; `promoted_at`/unique bilerek yok | §5 | ✔ | |
| P4 | Statü kontrolü: PUBLISHED değilse TÜM batch iptal | §5 | ✔ | |
| P5 | Üretim/inceleme hiç migration olarak yazılmaz; yalnızca promotion, doğrudan `PUBLISHED` tek INSERT | §5 "Neden üretim migration olarak yazılmaz" | ✔ | **Neden** (tek Flyway lokasyonu, seed prod'da da çalışırdı, UPDATE yerine INSERT duplicate) phase-log Faz 143'ten ➕ |
| P6 | `question-promotion/` klasörü, başlıkta dev id listesi, topic slug subquery, `reviewed_by/at` aynen kopya, otomatik sürüm numarası | §5 "Taşınabilirlik" | ✔ | |

### 8.6 Google ile giriş (CLAUDE.md `:342`) → rationale §6

| # | Kaynaktaki iddia | Hedef | İşaret | Not |
|---|---|---|---|---|
| G1 | Tanıma `sub` ile, e-postayla değil; `getName()` yerel e-posta; yetki yalnızca `app_user.role` | §6 | ✔ | "neden `sub`" cümlesi genel OIDC bilgisi olarak işaretli (kaynakta yalnızca iddia var) |
| G2 | E-postası eşleşen mevcut hesap ASLA otomatik bağlanmaz (kayıtta e-posta doğrulanmıyor) → şifre istenir | §6 "Neden ... OTOMATİK bağlanmaz" | ✔ | "hesap ele geçirme" açıklaması phase-log Faz 185'ten ➕ (kaynak metinde de var) |
| G3 | Yeni Google hesabı Koşullar kutusu olmadan açılmaz; bağlı olmayan kimlik giriş SAYILMAZ, session'da bekler (`PendingGoogleSignIn`, 10 dk) | §6 "Diğer politika" | ✔ | |
| G4 | ADMIN bağlanamaz/giremez (`allowsGoogleSignIn`, tek yer); erken red | §6 ADMIN bölümü | ✔ | Üç uygulama noktası ve "şifreye bakılmadan" ayrıntısı ➕ phase-log; istisnalar (unlink yok, şifresiz hesap ADMIN yapılırsa giriş yolu kalmaz) korunmuş |
| G5 | `SameSite=Lax` KALMALI (Strict Google dönüşünü kırar); `Secure` | §6 "Teknik kararlar" | ✔ | |
| G6 | İstemci yalnızca iki env değişkeni verilince; yalnızca client-id verilirse uygulama açılmaz | §6 "Teknik kararlar" | ✔ | **Doğrulandı (kod):** `GoogleSignInConfig` client-id boşsa bean hiç kurulmaz; client-id var + secret boş ise `Assert.hasText` ile uygulama başlamaz. phase-log/Javadoc'taki "boş client-id uygulamayı açtırmazdı" ise Boot'un kendi `spring.security.oauth2.client.*` yolu hakkındadır, ayrı bir iddiadır. İkisi çelişmiyor. PKCE ayrıntısı Javadoc'tan ➕ |
| G7 | E-posta normalizasyonu tek kural (`normalizeEmail`) | §6 | ✔ | |
| G8 | Tarihli durum satırları (2026-10-24/25, deployment id'leri, "KAPALI/açık" güncellemeleri) | — | ↺→phase-log | Zaten phase-log Faz 185 satırında tam var (kontrol edildi: 6012f866, `google_admin_not_allowed`, genel mesaj, 309/309). Rationale'a bilerek taşınmadı |

### 8.7 Quiz havuzu ve yayınlama (CLAUDE.md `:215`, `:281`, `:703`, `:731`, quiz-shell `:1040`) → rationale §7

| # | Kaynaktaki iddia | Hedef | İşaret | Not |
|---|---|---|---|---|
| Q1 | Havuz: `Question` topic+language'e bağlı, Quiz'e zorunlu değil; `QuizQuestion` ilişki entity'si | §7 Neden genel havuz | ✔ | |
| Q2 | `status='PUBLISHED'` sorguya sabit, override edilemez; sabit quiz üyeliği statüden bağımsız; PUBLISHED yapmak quiz'e eklemez | §7 | ✔ | |
| Q3 | `ON DELETE RESTRICT`; kaldırmak için `REJECTED` | §7 | ✔ | |
| Q4 | `QuestionScorer`: küme birebir; `MULTIPLE_CHOICE` kısmi KABUL ETMEZ | §7 Puanlama | ✔ | |
| Q5 | `Quiz.passThreshold` `BigDecimal`/`NUMERIC(3,2)`; `ddl-auto: validate` çakışması; NUMERIC kolonlarda dikkat | §7 | ✔ | `AiUsageLog` örneği koddan ➕ |
| Q6 | Global "tek doğru şık" kısıtı kaldırıldı; `idx_question_pool`; tip-farkındalı doğrulama serviste | §7 Ingestion doğrulaması | ✔ | `DROP INDEX` vs `DROP CONSTRAINT` ayrıntısı phase-log ➕ |
| Q7 | Faz 88: `quiz.js` sözleşmesi, `renderResults`, radio→checkbox | §7 "Tarayıcı sözleşmesi" | ◐ | İlk taslakta HİÇ yoktu, eklendi; CLAUDE.md'deki doğrulama anlatısı (6/6 Passed, test sayıları) bilerek taşınmadı (phase-log Faz 88'de var) |
| Q8 | publish/reject yalnızca `PENDING_REVIEW`'dan, aksi 409; `reviewedBy/At`; formlar CSRF'li | §7 Yayınlama | ✔ | CLAUDE.md Faz 87 maddesindeki "review arayüzü YOK" bayat (⚠ Aşama 4) |
| Q9 | Quiz-shell: `grep -rl "INSERT INTO quiz"` önce | §7 son paragraf | ✔ | Neden/hata `known-constraints` "Faz 157" ➕ |
| Q10 | `CODE_OUTPUT` `codeSnippet` zorunlu/diğerlerinde yasak; `questionDisplayText()` | §7 | ✔ | |
| Q11 | AI Judge `auto-publish` | §4 (I6) | ✔ | |

## 9. Otomatik kontrol (yalnızca ek güvence; bölüm 8'in yerine geçmez)

Her ilgili CLAUDE.md maddesinin backtick'li tanımlayıcıları `docs/architecture-rationale.md`'de aranmıştır. Eksik çıkanların TAMAMI elle sınıflandı:

- **Rationale'a eklendi (script bulgusu → düzeltme):** `DATE '2026-11-03'` örneği; `hljs.highlightAll()` (CODE_OUTPUT, ayrı JS gerekmedi); eski `source=AI` tarihçesi; `GoogleOidcUserService`/`GoogleSignInController.render`/`isGoogleSignInBlockedForEmail` adları; Google Console açma tarifi (**izin ekranı yayın durumu yalnızca CLAUDE.md'deydi**, phase-log'da yok).
- **CLAUDE.md'de KALMALI (işletim/komut/yol bilgisi, gerekçe değil; Aşama 4 gereksinimi):** `examples/{slug}/{Ad}.out`, `scripts/example-outputs/manifest.tsv`, `generate --topic SLUG [--dry-run]`, `scripts/export-approved-questions.sh 101 102 103`, rota yolları (`/{lang}/practice`, `/{lang}/topics/{topicSlug}/quiz/{quizSlug}/submit`, `POST /api/internal/questions/ingest`, `GET /api/internal/topics/{slug}[/content]`, `.../questions/existing`, `.../for-translation`), `/{lang:en|tr}/admin/**` + `hasRole("ADMIN")`.
- **Phase-log'da zaten tam, rationale'a bilerek taşınmadı (tarihli/olay):** deployment/commit kimlikleri (`4f623e3`, `6012f866`, `7c5e12d`), test sayıları, `curl`/`201`/`6/6 Passed` doğrulama anlatısı, sınıf yeniden adlandırma tarihçesi (`QuizOption`, `question.sort_order`, `V287`, `V468`, `git-fundamentals/V467`).
- **Bu aşamada ele alınmadı, Aşama 3 eşleşme tablosunda işlenecek:** Faz 146 "H2 başlıkları kavramsal kapsamdır, literal eşleşme değildir" üretim ilkesi; Faz 147-148 üretim/çeviri workflow ayrıntıları (CJK koruması, `comparableText()`, `Validate Translation`, `pinData`); Faz 141 `ROLE_` authority ve `/admin/**` kuralı (Question Review).

## 10. Açık / belirsiz kalan gerekçeler (karar veya bilgi gerekir)

1. **Flyway `${...}` kuralı artık teknik olarak zorunlu değil.** `application.yml` `placeholder-replacement: false` (`ae192be`, 2026-09-02); migration'larda 32 dosya literal `${` içeriyor, uygulama ve 725 test sorunsuz. CLAUDE.md hâlâ "yazma, yoksa uygulama başlamaz" diyor. Seçenekler: (a) kural CLAUDE.md'de "önlem" notuyla kısa kalsın ("ayar kapalı; ayar kaldırılırsa geçerli"), (b) tamamen kaldırılsın. Önerim (a). Karar Aşama 4'e kadar bekliyor.
2. **Güncelleme migration'larında açık tarih gerekçesi** hiçbir dokümanda yok (§1, çıkarım olarak işaretli). Gerçek nedeni biliyorsan söyle.
3. **`V1137` başlık yorumu `datePublished`'ı anıyor,** uygulanmış migration olduğu için düzeltilemez; rationale bunu not ediyor.
4. **`QuizIngestApiKeyInterceptor` Javadoc'u bayat** ("proje henüz Spring Security kullanmıyor"); kod yorumu, bu aşamada dokunulmadı.
5. **CLAUDE.md Faz 87 maddesi bayat bir cümle içeriyor** ("review için admin arayüzü YOK"); Faz 141/142'den beri var. Aşama 4'te düzeltilecek.
6. **Google izin ekranı durumunun nedeni** kaynakta yazılı değil (çıkarım olarak işaretli).
7. **Rationale boyutu 33,9 KB:** CLAUDE.md'nin ikinci kopyası değil (kural metinleri değil, neden/geçmiş/sınır), ama beklenenden uzun. İstenirse §3 (Beklenen Çıktı, ~9 KB) kısaltılır, çünkü ayrıntının büyük kısmı zaten `scripts/example_outputs.py` yorumlarında.

## 11. Stage 2 kapanış kararları (2026-11-03)

**Stage 4 düzeltme listesi (bayat/yanlış ifadeler):**
- `QuizIngestApiKeyInterceptor` Javadoc'u "proje henüz Spring Security kullanmıyor" der; Faz 138'den beri yanlış. Aynı aşamada kod yorumu da güncellenir.
- CLAUDE.md Faz 87 cümlesi "review için ayrı admin arayüzü YOK"; Faz 141/142'den beri güncel değil.
- Flyway kuralı: `${...}` yasağı bayat (`placeholder-replacement: false`, ae192be). Kısa kural: ayar kapalı, literal kullanım serbest, ayarı değiştirmeden önce mevcut migration'lar taranır; teknik neden `docs/architecture-rationale.md` §2.

**Stage 3 taşıma zorunlu kuralları (ayrı tablo, silmeden önce hedefi doğrulanacak):**
| Kural | Kaynak (CLAUDE.md) | Hedef | İşlem |
|---|---|---|---|
| H2 başlıkları kavramsal kapsamdır, birebir kelime eşleşmesi değil; Validate Output yalnızca yapısal | Faz 146 | `docs/phase-log.md` Faz 146 + `n8n/README.md` | doğrula, eksikse ekle |
| CJK koruma regex'i, `comparableText()`, Validate Translation, MANUAL ön-filtresi, `n8n execute` pinData'yı yok sayar | Faz 147-148 | `docs/known-constraints.md` Faz 146/148 | doğrula |
| Question Review: ADMIN-only `/{lang}/admin/**`, `ROLE_` authority, PENDING_REVIEW listesi, `correct` yalnızca ADMIN'e görünür, Publish/Reject 409 | Faz 141/142 | Mimari kural olarak CLAUDE.md'de KALIR (kısa) + phase-log | kısalt, silme |

**Google:** consent-screen yayın durumu ve açma adımları `docs/google-sign-in-operations.md`'ye taşındı; CLAUDE.md'de en fazla tek satır hatırlatma.

**Yalnızca çıkarıma dayanan gerekçeler (kaynakta doğrulanmadı):** güncelleme migration'ında açık tarih / yeni ders INSERT'inde CURRENT_DATE ayrımının nedeni; şablon/stil/SEO değişikliğinin `updated_at`'i neden ilerletmediği; EN yayında yayın gününün yazılma nedeni; `updated_at >= published_at` kısıtının amacı; Google consent-screen durumunun önemi; `sub` seçiminin genel OIDC gerekçesi; HashMap Javadoc ifadesi (genel bilgi); istisna-mesajı kuralının gerekçesi; `EXPORT_SOURCE_DB_*` korumasının sınırı (kasıtlı yanlış host'a karşı korumaz); HotSpot determinizm notu. Doğrulandı: `.out` elle değişiminin build'i kırması (ExampleOutputManifestTest Javadoc).
