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
