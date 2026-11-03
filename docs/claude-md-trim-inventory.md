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

## 12. Aşama 3 — "GÜNCELLEME" paragrafları kaynak→hedef tablosu (HAZIRLIK; hiçbir şey taşınmadı/silinmedi)

**Sayım.** İstenen "20" yerine gerçekte `GÜNCELLEME (Faz …)` işaretçisi **21** (Faz Geçmişi bölümü, satır 525-1042) + **1** (Bilinen Kısıtlar, Faz 140, satır ~1140: Aşama 5'in konusu) = 22. 96/104/109/114 aynı bitişik bloktadır (533-576, boş satır yok), 87 ise "Şu an proje durumu (Faz 82 itibarıyla)" paragrafının içindedir (520-532). Bu işaretçilerin toplamı ≈ 36,9 KB; bölümün tamamı 38,8 KB. İşaretçisiz ama aynı bölümde: Faz 76 notu, KALICI KURAL, "Yeni bir konuya başlamadan önce" (kalır) ve "Şu an proje durumu" giriş cümlesi (Faz 82; bayat, silinecek).

**Yöntem.** Her paragraf için (a) backtick'li terimler ve V-numaraları otomatik olarak `docs/*.md` korpusunda arandı (satır sonu tireleme kaynaklı eşleşmemeler elle ayıklandı: gerçek eksik yok), (b) ilgili `phase-log.md` satırında anahtar kural ayrıca elle arandı (141 `hasRole`, 143 `EXPORT_SOURCE_DB`, 144 `OPENAI/CLAUDE`, 145 `retryOnFail`, 154 `docker-practical-project`, 139 `PracticeService`, 138 `webmvc-test`: hepsi VAR), (c) güncellik kodla karşılaştırıldı (ör. `QuestionSource` enum'u, `QuestionIngestRequest`). Phase-log her faz için 1,1-8,1 KB'lık TAM satır tutuyor; yani "durum/ayrıntı" bilgisi zaten orada.

Etiketler: **SİL** = phase-log'da karşılığı doğrulandı, kalıcı kural yok → Aşama 3'te silinebilir; **KISALT** = kalıcı kural CLAUDE.md'de kısa kalır, geri kalan silinir; **DOĞRULA** = silmeden önce ek kontrol gerekir.

| # | İşaretçi / satır / bayt | İçerdiği kural veya bilgi | Güncellik | CLAUDE.md'de kalacak (güncel kural) | Mevcut kopya / hedef | Öneri | Belirsizlik |
|---|---|---|---|---|---|---|---|
| 1 | Faz 87, 525-532, ~0,6 KB (+ giriş cümlesi 520-524) | V259-V262 sandbox'ta var; migration'lar V1..V293 boşluksuz | Tarihsel; migration numarası kuralı (CLAUDE.md'de numara yazılmaz) ile çelişir | yok | phase-log Faz 87 satırı (7,7 KB) | SİL (giriş cümlesiyle birlikte) | yok |
| 2 | Faz 96, 533-538, ~0,5 KB | microservices 12/12; Pratik Proje kararı kullanıcıda bekliyor | Durum bayat olabilir | Pratik Proje kuralı zaten Mimari'de | phase-log Faz 96 satırı | DOĞRULA → SİL | `microservices-course-projects` repo'su phase-log'da geçiyor (Faz 40/62); "karar bekleniyor" ifadesinin hâlâ geçerli olup olmadığı KESİN DEĞİL |
| 3 | Faz 104, 539-545, ~0,5 KB | exceptions 7/7; kendi kategorisi (Faz 99 ayrımı); Pratik Proje eklenmedi | Durum | yok (çok-kategori kuralı Mimari'de) | phase-log Faz 104 | SİL | yok |
| 4 | Faz 109, 546-553, ~0,6 KB | generics 6/6; aynı desen | Durum | yok | phase-log Faz 109 | SİL | yok |
| 5 | Faz 114, 554-576, ~1,6 KB | advanced-spring 4/4. Kalıcı ilke: yeni topic önceki topic'lerin kapsadığını TEKRAR öğretmez, boşlukları doldurur, gerçek başlıkla doğrulanmış çapraz referans verir; `spring-batch` istisna (sıfırdan); `spring-boot-starter-batch` pom'da yok → elle yazılmış, derlenmemiş örnek | İlke geçerli; sayılar/durum bayat | **İlke (1 cümle)** — #5,6,7,8'de AYNI ilke tekrar ediyor; tek kısa kural olarak "İçerik Yazım Formatı"na | phase-log Faz 114 (`starter-batch` geçiyor); ilke başka yerde (CLAUDE.md dışı) YOK | KISALT (ilkeyi tek yere al, kalanı sil) | İlkenin tüm kurslar için mi yalnızca Spring/PG için mi geçerli olduğu kaynakta söylenmiyor → karar gerekir |
| 6 | Faz 123, 578-606, ~2,1 KB | spring-data-jpa 9/9; PLAN MODE onaylı 9 topic yol haritası; #5 ilkesinin tekrarı; Pratik Proje eklenmedi | Durum; ilke #5 ile aynı | (ilke #5'te) | phase-log Faz 123 | SİL | yok |
| 7 | Faz 133, 608-633, ~1,8 KB | postgresql-foundations 10/10; 14 topic'lik onaylı yol haritası; örnekler projenin gerçek şemasından | Durum; ilke #5 ile aynı | (ilke #5'te) | phase-log Faz 133 | SİL | yok |
| 8 | Faz 137, 635-663, ~2,0 KB | advanced-postgresql 4/4, postgresql kursu 14/14 tamam | Durum | yok | phase-log Faz 137 | SİL | yok |
| 9 | Faz 138, 665-679, ~1,1 KB | Auth eklendi (zaten Mimari'deki auth maddesinde); **Boot 4 gotcha:** `@AutoConfigureMockMvc` artık `spring-boot-starter-webmvc-test`'te (paket `org.springframework.boot.webmvc.test.autoconfigure`); "53 test" | Auth kısmı TEKRAR; gotcha geçerli (pom'da bağımlılık var); test sayısı bayat | **Gotcha (1-2 satır)** → Bilinen Kısıtlar (Aşama 5) | Auth: Mimari maddesi (kopya). Gotcha: phase-log Faz 138 satırında VAR, `known-constraints.md`'de YOK | KISALT (gotcha'yı taşı, kalanı sil) | Gotcha'nın CLAUDE.md'de mi `known-constraints.md`'de mi durması bir tercih |
| 10 | Faz 139, 681-701, ~1,5 KB | Quiz Area: ayrı kavram, sabit `Quiz`'e DOKUNMAZ; submit `PracticeService`'i paylaşır; sidebar'da kendi bölümü; java seed; "UI HENÜZ EKLENMEDİ" | Soru çekme/gönderme UI cümlesi ve spring-boot/react seed cümlesi BAYAT olabilir (Faz 160/161 Mimari maddesi Quiz Area'yı zaten anıyor) | **Ayrı-kavram + paylaşılan submit** (1-2 cümle; Mimari'deki Faz 87 maddesine bağlanır) | phase-log Faz 139 (`PracticeService` geçiyor) | KISALT | "UI HENÜZ EKLENMEDİ"nin şimdi doğru olmadığı mantıksal olarak çok olası ama kodla DOĞRULANMADI |
| 11 | Faz 141, 703-729, ~1,9 KB | **Question Review:** `/{lang:en|tr}/admin/**` → `hasRole("ADMIN")`; yeni yetki mekanizması yok (`Role.ADMIN`, `ROLE_`+ad authority Faz 138'den); ADMIN yükseltmesi ELLE (migration/rol UI yok); listeleme `PENDING_REVIEW`; DTO `correct`'i BİLİNÇLİ gizlemez (yalnızca ADMIN); PENDING sorular public havuza girmez (sabit PUBLISHED filtresi) | Kural güncel; "Publish/Reject disabled" cümlesi (Faz B) #12 ile aşıldı; test sayısı bayat | **Question Review kuralı — Mimari'de HİÇ yok, yalnızca burada ve Proje Yapısı'nda** → Aşama 4'te yeni kısa Mimari maddesi olarak YAZILMALI (taşıma önkoşulu) | phase-log Faz 141 (`hasRole` VAR) | KISALT (önce Mimari maddesi yazılır) | yok |
| 12 | Faz 142, 731-749, ~1,4 KB | Publish/Reject yalnızca `PENDING_REVIEW`'dan; aksi 409; `reviewedBy/At` dolar; ADMIN kuralına otomatik girer; CSRF muafiyetine BİLİNÇLİ eklenmedi (gerçek tarayıcı formu) | Güncel kural; test sayısı bayat | **409 + CSRF-muaf-değil** (#11'deki maddeye 1 cümle) | phase-log Faz 142; known-constraints Faz 142 (mvn doğrulaması) | KISALT (#11 ile birleşik) | yok |
| 13 | Faz 143, 751-769, ~1,5 KB | Promotion: yalnızca AÇIK id listesi, "tüm PUBLISHED" yok; script prod'a bağlanamaz (`EXPORT_SOURCE_DB_*` ≠ `DB_*`); yeni soru ÜRETİMİ migration olmaz, yalnızca PROMOTION migration (`question-promotion/`, `status='PUBLISHED'`); tekrar-promote önleme SÜREÇ sorumluluğu, `promoted_at` bilinçli yok | Güncel | **Kural biçiminde (3-4 madde)** — `EXPORT_SOURCE_DB`/export script'i CLAUDE.md'de Proje Yapısı dışında geçmiyor | Gerekçe: `architecture-rationale.md` §5 (kopya DEĞİL, gerekçe); phase-log 143 (`EXPORT_SOURCE_DB` VAR); known-constraints 143 | KISALT (Aşama 4 Mimari maddesi) | `promoted_at` yokluğu "bilinçli" diye geçiyor; sonradan değişip değişmediği kodla bu aşamada kontrol EDİLMEDİ |
| 14 | Faz 144, 771-787, ~1,3 KB | `QuestionSource` `MANUAL, CLAUDE, N8N`; `QuestionIngestRequest.source` VAR (allow-list), `status` DTO'da YOK; şema değişikliği yok | Güncel ve **Mimari'deki Faz 87 maddesini DÜZELTİR**: o madde hâlâ "`source = AI`" ve "iki alan DTO'da YOK" der — kodla çelişir | **Düzeltilmiş hâliyle** Mimari'deki ingestion cümlesi (Aşama 4) | phase-log 144; rationale §4 (`parseEnum` izin listesi) | KISALT + Aşama 4 düzeltme listesine EKLE | enum şu an MANUAL, CLAUDE, N8N, OPENAI (kodla doğrulandı) |
| 15 | Faz 145, 789-807, ~1,3 KB | n8n PostgreSQL'e/prod'a BAĞLANMAZ, yalnızca Ingestion API; `retryOnFail:false` + `onError:continueRegularOutput` (duplicate retry riski); API anahtarı workflow dosyasında değil, `$env`'de | Kural güncel; çalıştırma ayrıntıları tarihsel | **n8n sınırı + retry yok + anahtar $env** (2-3 madde) | `n8n/README.md` (`retryOnFail`/anahtar geçiyor); phase-log 145; known-constraints 145 | KISALT | `n8n/README.md`'nin tam olarak hangi maddeleri kapsadığı elle okunmadı (yalnızca 3 anahtar kelime eşleşti) |
| 16 | Faz 146, 809-842, ~2,6 KB | n8n doğrudan DB/dosya erişmez → 3 salt-okunur `/api/internal/**` uç noktası (`GenerationToolingService` hiç Question YAZMAZ); **H2 başlıkları kavramsal KAPSAMdır, kelime eşleşmesi değil; Validate Output yalnızca yapısal** (taşıma zorunlu kuralı); `n8n execute` pinData'yı yok sayar | Kurallar güncel; ANTHROPIC_API_KEY yok/stand-in cümleleri tarihsel | **H2 ilkesi + "n8n doğrudan DB'ye yok → internal endpoint"** | known-constraints Faz 146 (pinData TAM); phase-log 146; H2 ilkesi phase-log 146'da VAR mı: satırda "H2"/"content-fit" ayrıca elle doğrulanmalı | KISALT + DOĞRULA (H2 ilkesi) | H2 ilkesinin phase-log satırında birebir geçtiği bu aşamada yalnızca kısmen doğrulandı |
| 17 | Faz 147, 844-885, ~3,3 KB | OpenAI geçişi (`QuestionSource.OPENAI`); 3 bug (itemMatching, `question+codeSnippet` karşılaştırması…); prompt kuralları; CODE_OUTPUT kodu yalnızca `codeSnippet`'te; `questionDisplayText()` sunum katmanı; 5 PUBLISHED/2 REJECTED, 90/90 | Büyük ölçüde tarihsel; **kalıcı ilke:** CODE_OUTPUT kodu `codeSnippet`'te, `question` metninde değil | CODE_OUTPUT ilkesi 1 cümle (Mimari'de CODE_OUTPUT render cümlesi var) | phase-log 147 (6,4 KB); known-constraints 147 | SİL (ilke tek cümleyle Mimari'deki CODE_OUTPUT cümlesine) | yok |
| 18 | Faz 148, 887-918, ~2,4 KB | EN→TR çeviri: `correct`/şık/tip/zorluk/`codeSnippet`/topic modelden DEĞİL EN'den kopyalanır; `MANUAL` kaynaklılar atlanır; `comparableText()`; **CJK-koruma** (n8n encoding hatası, kök neden bulunamadı); `for-translation` uç noktası | Kurallar workflow dosyasında yaşıyor; CJK ayrıntısı known-constraints'te TAM | **1 madde:** çeviri yapısal alanları kopyalar, modelden almaz + CJK koruması | known-constraints Faz 148 (CJK, 1086-1105); phase-log 148 | KISALT (taşıma zorunlu kuralı: CJK korunur → known-constraints'te zaten VAR) | yok (CJK ayrıntısının known-constraints'te olduğu doğrulandı) |
| 19 | Faz 150, 920-959, ~2,7 KB | git-github 220 soru; kurulu desen: topic başına 10+10, MC'de tam 2 doğru, `auto-publish` uç noktası, portable promotion migration (`NOT EXISTS` + `ON CONFLICT DO NOTHING`), CODE_OUTPUT yalnızca gerçek komut çıktısı, doğrulama listesi; `mvn -o flyway:migrate target/classes` tuzağı | Desen kısmen aşıldı (Faz 157: soru sayısı 4–7 esnek); skill 4–7'yi içeriyor | **Hiçbiri** (kural `quiz-questions` skill'inde olmalı) | known-constraints Faz 149/150; phase-log 150. **`quiz-questions` skill'i `ON CONFLICT`, `NOT EXISTS`, `auto-publish`, `INSERT INTO quiz` ifadelerini İÇERMİYOR** | DOĞRULA → SİL | Bu kurallar silinirse YALNIZCA phase-log'da kalır; skill'e taşınıp taşınmayacağı (Aşama 6) kararı gerekir |
| 20 | Faz 154, 961-1016, ~4,2 KB | docker kursu (2 kategori, 9 topic); `docker-practical-project` BİLİNÇLİ gömülü (React ayrı-repo/tag kuralının istisnası); 4 hata düzeltmesi; sandbox'ta Docker Engine var, `learning-platform-db`/n8n container'larına dokunulmaz | Çoğu tarihsel; Docker Engine cümlesi Bilinen Kısıtlar'da ZATEN var (kopya); gömülü-proje istisnası kalıcı | **React Pratik Proje kuralına 1 cümlelik istisna notu** (docker gömülü) | phase-log 154 (`docker-practical-project` VAR); known-constraints 154 | KISALT | yok |
| 21 | Faz 155-159, 1018-1042, ~2,0 KB | ai/docker/postgresql quiz batch'leri; esnek 4–7 soru (skill'de VAR); **kalıcı kural:** yeni topic'e quiz eklemeden önce `grep -rl "INSERT INTO quiz"` ile shell var mı kontrol et | Desen güncel; kural known-constraints Faz 157'de VAR, skill'de YOK | Tek cümlelik işaretçi ("quiz eklemeden önce shell kontrolü") VEYA skill | known-constraints Faz 157 (1182-1200); phase-log 155-159 | KISALT → DOĞRULA | Kuralın CLAUDE.md'de mi skill'de mi duracağı karar gerektirir |

**Aşama 3'te CLAUDE.md'de KALACAK güncel kurallar (özet; Aşama 4 yazımı için kaynak):**
1. Question Review: `/{lang}/admin/**` ADMIN-only, `ROLE_` authority, rol yükseltme elle; Publish/Reject yalnızca `PENDING_REVIEW`'dan (aksi 409), CSRF'ye muaf DEĞİL; public havuz filtresi sabit `PUBLISHED` (#11-12). **Mimari'de şu an yok.**
2. Promotion: açık id listesi, prod'a bağlanamaz (`EXPORT_SOURCE_DB_*`), yalnızca promotion migration `PUBLISHED` (#13). **Mimari'de şu an yok.**
3. Ingestion: `status` DTO'da yok, `source` allow-list (düzeltilmiş) (#14).
4. n8n sınırı: DB/prod/dosya sistemi yok, yalnızca `/api/internal/**`; retry yok; anahtar `$env`; H2 başlıkları kavramsal kapsam (#15-16, #18).
5. İçerik ilkesi: yeni topic önceki topic'leri tekrar öğretmez (#5).
6. Quiz Area ayrı kavram, `PracticeService` submit paylaşımı (#10).
7. Boot 4 `webmvc-test` gotcha'sı (#9) ve Docker gömülü-proje istisnası (#20).

**Zaten başka dokümanda bulunanlar (kopya yaratılmayacak):** durum/sayı/migration anlatımı → phase-log (tüm 21); CJK, pinData, Faz 149/157 tuzakları → known-constraints; gerekçeler → architecture-rationale §4-§7.

**Doğrulamadan SİLİNMEMESİ gerekenler / bayat ifadeler:** (a) Mimari'deki Faz 87 maddesi `source = AI` ve "DTO'da iki alan YOK" (kodla çelişir, Aşama 4); (b) Faz 87 "ayrı admin arayüzü YOK" (Aşama 4); (c) #10 "UI HENÜZ EKLENMEDİ"; (d) #2 Pratik Proje "karar bekleniyor"; (e) tüm test sayıları (53, 69, 75, 80, 90, 92, 100…) bayat.

**Belirsiz konular (karar/ek doğrulama gerekir):** #2 (microservices Pratik Proje durumu), #5 (ilke kapsamı), #9 (gotcha'nın yeri), #13 (`promoted_at` güncel mi), #15 (`n8n/README.md` kapsamı), #16 (H2 ilkesinin phase-log'daki tam metni), #19/#21 (quiz kurallarının skill'e taşınması).

**Tahmini etki (1,98 B/token; tahmin, ölçüm değil):** 21 işaretçi ≈ 36,9 KB; kalacak kurallar ≈ 3-4 KB → net ≈ 33 KB ≈ 16-17k token tasarruf. Gerçek değer Aşama 8'de `/context` ile ölçülecek.

## 13. Aşama 3 doğrulama sonuçları (2026-11-03; yalnızca okuma — CLAUDE.md ve diğer dokümanlar DEĞİŞMEDİ)

Yöntem: gerçek kod/yapılandırma/migration/doküman okundu; canlı DB sorgulanmadı (şema kaynağı migration'lar). Kanıt bulunamayan yerde tahmin yürütülmedi.

### 13.1 Question Review (kod doğrulaması)
| İddia | Sonuç | Kanıt |
|---|---|---|
| `/{lang}/admin/**` yalnızca ADMIN | **Doğrulandı** — ama kural `/admin/**`'in TAMAMI içindir (AI Tutor admin uç noktaları dahil), yalnızca Question Review'a özgü değil | `config/SecurityConfig.java:94` `.requestMatchers("/{lang:en\|tr}/admin/**").hasRole("ADMIN")`, `anyRequest().permitAll()` (:111) öncesinde |
| Publish/Reject yalnızca `PENDING_REVIEW`'dan, aksi 409 | **Doğrulandı** (ek: eşzamanlı güncelleme de 409) | `service/QuestionReviewService.java:255-257` (durum kontrolü → CONFLICT), `:270-271` (eşzamanlı güncelleme → CONFLICT); `reviewedBy` oturumdan (`Authentication`, `QuestionReviewController.java:43,49`) |
| Listeleme yalnızca `PENDING_REVIEW` | **Doğrulandı** | `QuestionReviewService.java:88` `findByStatusOrderByCreatedAtAsc(PENDING_REVIEW)` |
| CSRF'ye muaf DEĞİL | **Doğrulandı** | muaf liste yalnızca `/api/internal/**`, `/{lang}/topics/*/quiz/*/submit`, `/{lang}/practice/submit`, `/{lang}/quiz/*/submit` (`SecurityConfig.java:126-130`); `admin/question-review.html` CSRF token içeriyor (3 eşleşme). AI Tutor `/admin/ai-tutor/**` de bilinçli olarak muaf DEĞİL (:148-149 yorumu) |
| Auto-publish aynı kuralı kullanır | **Yeni bulgu** — CLAUDE.md'de hiç yok | `QuestionReviewService.java:144-145` `transition()`'ı yeniden kullanır (PENDING_REVIEW-only/409 aynı); `QuestionAutoPublishController.java:29` `POST /api/internal/questions/{id}/auto-publish`; bayrak `quiz.auto-publish.enabled` varsayılan **false** (`application.yml:64-65`, kapalıyken 503), aynı `X-Api-Key` |
| Kod yorumu güncel mi | **BAYAT** | `SecurityConfig.java:88-91` "Question Review (Faz A, henüz UI/controller'ı yok…)" — controller ve UI var |

### 13.2 Promotion (kod doğrulaması)
- **Açık id listesi:** `argparse` `question_ids nargs="+"` zorunlu (`scripts/export_approved_questions.py:189-190`); "tüm PUBLISHED" sorgusu yok.
- **Tek PUBLISHED olmayan soru tüm partiyi iptal eder:** `:149-155` (`ExportError`, kısmi çıktı yok).
- **Dosya üzerine yazmaz:** `out_path.exists()` → hata (`main()`); migration numarası mevcut en yüksek + 1 (`:55-58`).
- **Üretilen SQL her zaman `'PUBLISHED'` ile tek INSERT** (`:123-124`), dosya `question-promotion/` altına.
- **Script hiçbir veritabanına YAZMAZ:** tek DB erişimi `subprocess.run(["psql","-h",SOURCE_DB_HOST,…,"-c",query])` ile SELECT (`:82-83`, `:63-69`); yazdığı tek şey yerel `.sql` dosyası.
- **Kritik ayrım — `EXPORT_SOURCE_DB_*` prod host'una ayarlanırsa:** script **bağlanır ve SELECT çalıştırır**; ana bilgisayar izin listesi, localhost kontrolü ya da salt-okunur transaction YOK (`:50-54` yalnızca ortam değişkeni okur, varsayılan `localhost:5433/learning`). Koruma yalnızca *kazara* kimlik bilgisi kullanımına karşıdır (`DB_URL`/`DB_USERNAME`/`DB_PASSWORD` okunmaz, `:46-49`). Script'in docstring'indeki "NEVER connects to production… by construction" (`:12-19`) yalnızca varsayılan yapılandırma için doğrudur. Prod'a YAZMAK ancak üretilen migration'ın normal deploy'da Flyway tarafından uygulanmasıyla olur — script'le değil.
- **Yeni Mimari maddesinde kullanılacak doğrulanmış ifade (öneri, henüz yazılmadı):** "Script veritabanına yazmaz; yalnızca `EXPORT_SOURCE_DB_*` ile verilen sunucuya `psql` ile SELECT atar (varsayılan: yerel dev). Host kısıtlaması yoktur; değişkenleri prod'a ayarlamak onu okur. Prod'a yazma yalnızca üretilen migration'ın deploy'da uygulanmasıyla olur." **"Prod'a bağlanamaz" ifadesi KULLANILMAYACAK.**
- **`promoted_at` yok (Faz 143 belirsizliği KAPANDI):** `promoted_at` yalnızca 7 promotion migration'ının yorumunda geçiyor ("intentionally has no promoted_at column", örn. `question-promotion/V489…:22`); hiçbir `ALTER TABLE/ADD COLUMN`, entity ya da Java kodunda yok. (Canlı DB sorgulanmadı.)
- **Bayat/aşırı iddia (Aşama 4 listesine):** script docstring'i `:12-19` (yukarıdaki ayrım); rationale §5 "Sınır" notu zaten doğru.

### 13.3 Ingestion (Faz 87 maddesi ile güncel kod)
| Konu | Güncel kod | CLAUDE.md Faz 87 maddesi |
|---|---|---|
| `QuestionSource` | `MANUAL, CLAUDE, N8N, OPENAI` (`domain/QuestionSource.java:25-30`) | "`source = AI`" ve `MANUAL/AI` — **BAYAT** |
| `source` istek alanı | **VAR** (`QuestionIngestRequest.java:27`), `parseEnum` ile izin listesi (`QuestionIngestService.java:70,181-188`); **boş/eksik `source` → 400 "source is required"** (`requireNonBlank`) | "iki alan DTO'da BİLİNÇLİ OLARAK YOK" — **BAYAT** (yalnızca `status` yok) |
| `status` DTO'da yok | **Doğrulandı**; sunucu `PENDING_REVIEW` atar (`QuestionIngestService.java:94`) | doğru (yalnızca `status` için) |
| Tip başına doğru şık | SINGLE_CHOICE/CODE_OUTPUT tam bir, MULTIPLE_CHOICE en az bir (`:132,138`) | doğru |
| X-Api-Key | yapılandırılmamış → 503, yanlış anahtar → 401, sabit-zamanlı karşılaştırma (`QuizIngestApiKeyInterceptor.java:~38-50,55`); yalnızca `/api/internal/**` (`WebConfig.java:71`); CSRF-muaf (`SecurityConfig.java:127`) | doğru |
| Bayat yorumlar | Interceptor Javadoc `:16` "Spring Security kullanmıyor"; `QuestionIngestRequest` Javadoc `source` izin listesini yalnızca MANUAL/CLAUDE/N8N diye anar (OPENAI eksik) | Aşama 4: ikisi de düzeltilmeli |
Yeni Mimari ingestion maddesi yalnızca bu tablonun "Güncel kod" sütununu içerecek.

### 13.4 Belirsiz konular — kanıt ve karar
| Konu | Bulunan kanıt | Sonuç |
|---|---|---|
| **Faz 96** microservices Pratik Proje | Yalnızca `inter-service-communication` dersinde `microservices-course-projects` bağlantısı var; `deployment` derslerinde (TR/EN) "Pratik Proje" yok. Faz 96 phase-log satırında "Pratik" geçmiyor (0 eşleşme) → "karar bekleniyor" bilgisi YALNIZCA CLAUDE.md'de. Sonradan çözüldüğüne dair kanıt bulunamadı. | **BELİRSİZ / ek karar.** Silinirse tek kayıt kaybolur. Seçenekler: (a) kullanıcıya sor, (b) silmeden önce bir satırlık not phase-log Faz 96'ya eklensin |
| **Faz 114** ilke kapsamı | Phase-log satırları 110-112, 114-121, 124, 137 "tekrar öğretmeme" ilkesini anlatıyor: advanced-spring, spring-data-jpa, postgresql. java/react/ai/git/docker için kanıt yok; `.claude/skills` ve known-constraints'te ilke yok. | Kanıtlanan kapsam: **spring-boot (advanced-spring, spring-data-jpa) ve postgresql kursları**. Tüm kurslara genelleştirmek çıkarım olur → **ek karar**. `starter-batch` "pom'da bağımlılık değil" notu phase-log'da VAR (pom'da gerçekten yok: 0 eşleşme) |
| **Faz 138** `webmvc-test` | `pom.xml:148` `spring-boot-starter-webmvc-test`; `NavbarMenuToggleTest.java:6` `org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc`; phase-log Faz 138 satırı notu içeriyor; known-constraints'te yok | Bilgi **doğrulandı**. `known-constraints.md` uygun yer (araç/bağımlılık tuzağı, Bilinen Kısıtlar niteliğinde); pom'dan çıkarılabilir olduğu için CLAUDE.md'de tutmaya gerek yok → **güvenli, hedef: known-constraints.md** (onayla) |
| **Faz 143** `promoted_at` | bkz. 13.2: yok | **KAPANDI** |
| **Faz 145** `n8n/README.md` | 120 satır tamamı okundu. Kapsıyor: n8n Postgres/prod'a bağlanmaz, `retryOnFail:false`+`onError`, env değişkenleri (`$env`, workflow'da `QUESTION_INGEST_BASE_URL`/`QUIZ_INGEST_API_KEY`/`OPENAI_MODEL`), H2 yalnızca yapısal, pinData, CJK koruması, yapısal alanların EN'den kopyalanması, MANUAL filtresi. Workflow JSON: `retryOnFail:false`/`onError` `question-generation-enum-test.json:75,189`. **README'nin üst paragrafı "never publishes/rejects questions" der, ama generation workflow'da `AI Judge …` düğümleri, `Post-Ingest Status Decision` ve "auto-publish" geçer; README'de AI Judge bölümü yok.** | Faz 145 kuralları README'de TAM → CLAUDE.md'den çıkarılabilir. **README bu konuda BAYAT** (Faz 151-152 sonrası); ayrıca yeni Mimari n8n maddesi "yalnızca ingestion" demeyecek: `/api/internal/**` HTTP uç noktaları (ingest, salt-okunur okumalar, bayrakla kapalı `auto-publish`) |
| **Faz 146** H2 ilkesi | phase-log Faz 146 satırı: "H2 başlıkları konunun kavramsal KAPSAMINI tanımlar… content-fit… LLM prompt'unun gerçek ders metnine topraklanmasıyla… H2 kelime-örtüşmesi kontrolü BİLİNÇLİ OLARAK YOK"; README node 4 ve 7 aynı | **Doğrulandı** — güvenle taşınabilir |
| **Faz 139** "UI HENÜZ EKLENMEDİ" | `templates/quiz-play.html` ve `quiz-index.html` var; Quiz Area route'ları `SecurityConfig.java:106` | **BAYAT doğrulandı** |

### 13.5 Quiz kuralları — mevcut kaynak ve planlanan hedef
| Kural | Mevcut kaynaklar | `quiz-questions` skill'i | Aşama 3'te | Planlanan hedef |
|---|---|---|---|---|
| Quiz eklemeden önce `grep -rl "INSERT INTO quiz"` ile shell kontrolü | known-constraints.md:1182-1200 (Faz 157); phase-log Faz 157; CLAUDE.md Faz 155-159 | YOK | **CLAUDE.md'de kısa hâliyle KALIR** | Aşama 6'da skill'e taşıma değerlendirilir; taşınana kadar silinmez |
| Portable link migration: topic/quiz slug'ından id çözümü, `NOT EXISTS` + `ON CONFLICT DO NOTHING` | gerçek örnek `git-fundamentals/V467`/`V468` (10× `NOT EXISTS`); known-constraints.md:1109-1128; CLAUDE.md Faz 150 | YOK | **KALIR (kısa)** | skill (Aşama 6) |
| `auto-publish`: `POST /api/internal/questions/{id}/auto-publish`, `QUIZ_AUTO_PUBLISH_ENABLED` varsayılan false, `X-Api-Key` | kod (13.1), `application.yml:59-65`, known-constraints.md:939,996 | YOK | **KALIR (kısa; Mimari ingestion maddesinin parçası)** | Mimari maddesi + known-constraints |
| Soru sayısı 4–7 esnek, EN=TR eşit | skill satır 18 | VAR | silinebilir (kopya) | skill |
| MC'de tam 2 doğru şık / topic başına 10+10 | yalnızca Faz 150 içeriği; kod kuralı değil (kod: MC ≥ 1), Faz 157 ile 4–7'ye aşıldı | YOK | çıkarım gerektirir; **kalıcı kural DEĞİL** | phase-log (silinebilir) |
Sonuç: **Faz 150 ve Faz 155-159 "SİL" değil "KISALT"**; yukarıdaki üç kuralın kısa hâli Aşama 6'ya kadar CLAUDE.md'de tutulur. Faz 150 için "DOĞRULA" tamamlandı (kural kod/migration'da var).

### 13.6 21 işaretçinin güncel durumu
**Güvenle taşınabilir (kanıt tamam, ek karar yok; Mimari maddeleri önce yazılmak koşuluyla):** #1 Faz 87 · #3 Faz 104 · #4 Faz 109 · #6 Faz 123 · #7 Faz 133 · #8 Faz 137 (hepsi durum anlatımı, phase-log'da karşılığı var) · #9 Faz 138 (gotcha → known-constraints.md; auth kısmı Mimari'de kopya) · #10 Faz 139 (ayrı-kavram/paylaşılan submit 1-2 cümle kalır; "UI eklenmedi" bayat) · #11-12 Faz 141/142 (kod doğrulandı; yeni Mimari Question Review maddesi önkoşul) · #13 Faz 143 (kod doğrulandı; yeni ifade 13.2) · #14 Faz 144 (13.3 ile Mimari düzeltmesi) · #15 Faz 145 ve #16 Faz 146 ve #18 Faz 148 (kurallar README/known-constraints'te tam; Mimari n8n maddesi 13.4 ifadesiyle) · #17 Faz 147 (CODE_OUTPUT cümlesi Mimari'ye) · #20 Faz 154 (Docker Engine Bilinen Kısıtlar'da kopya; gömülü-proje istisnası 1 cümle).
**Ek karar gerektirir:** #2 Faz 96 (karar durumu belirsiz) · #5 Faz 114 (ilke kapsamı) · #19 Faz 150 ve #21 Faz 155-159 (kısa kurallar Aşama 6'ya kadar CLAUDE.md'de kalır; skill'e taşıma kararı) · `n8n/README.md` bayatlığı (README'yi güncellemek ayrı bir iş, bu trim'in kapsamı dışı olabilir — karar).

### 13.7 Aşama 4 düzeltme listesine eklenenler (ek: §11)
(1) `SecurityConfig.java:88-91` bayat yorum; (2) `QuestionIngestRequest` Javadoc'unda OPENAI eksik; (3) `export_approved_questions.py` docstring'i "by construction" ifadesi; (4) `n8n/README.md` "never publishes/rejects" ifadesi; (5) CLAUDE.md Faz 87 maddesi `source = AI`/"iki alan yok"; (6) Faz 139 "UI eklenmedi". Kod yorumu/script/README değişiklikleri ancak kullanıcı onayıyla ve ayrı commit'te yapılacak.
