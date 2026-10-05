# LearnForgeX — Claude Code Skill Planı

**İlk yazım:** 2026-10-05

Bu doküman yaşayan bir plandır. Bir skill yazıldıkça ya da bir karar verildikçe ilgili
madde işaretlenir ve en alttaki "Değişiklik Günlüğü"ne tarihli bir satır eklenir.
Skill'ler tek tek yazılır; her biri gerçek bir işte denendikten sonra bir sonrakine geçilir.

## 1. Amaç

Yeni kurs ve konuları, her seferinde aynı kuralları baştan hatırlamaya gerek kalmadan,
daha hızlı ve daha az hatayla üretmek.

Bir skill, belirli bir iş için paketlenmiş talimat + yardımcı dosyalardır
(`.claude/skills/{ad}/SKILL.md`). Yalnızca o iş yapılırken yüklenir; `/ad` yazarak ya da
kısa açıklamasına uyan bir istek geldiğinde kendiliğinden devreye girer. Repoya commit
edilir, yani her oturumda ve her makinede aynıdır.

## 2. Neden şimdi — incelemede görülenler

- **Projede hiç skill yok.** `.claude/` altında yalnızca `settings.local.json` var.
- **`CLAUDE.md` 1093 satır ve her oturumda tamamı yükleniyor.** İçeriğinin büyük kısmı
  değişmez kural değil; prosedür ("yeni konu şu migration'larla eklenir") ve tarihçe
  (Faz 87–160 anlatıları). Bunlar yalnızca ilgili iş yapılırken gerekli. Skill'e taşımak
  her oturumun başlangıç maliyetini düşürür.
- **`CLAUDE.md`'de bugün geçerli olmayan ortam iddiaları var:** "Maven Central engelli",
  "`javac` ile derleme yapılmıyor", "ZIP teslimatı", "bu sandbox'ta…". 2026-10-05
  oturumunda `mvn test` sorunsuz çalıştı, uygulama yerelde başlatıldı, değişiklikler
  doğrudan git'e commit edildi. Gerçek olan tek tuzak: Maven varsayılan olarak JDK 26
  ile çalışıyor ve Lombok kırılıyor; `JAVA_HOME` JDK 21'e verilmeli.
- **`AGENTS.md`** (929 satır, git'te izlenmiyor) `CLAUDE.md`'nin yaklaşık 200 satırı
  farklı, eski bir kopyası.
- **Aynı işler çok kez tekrarlanıyor:**
  - *Quiz sorusu üretimi* — 141 `promote_questions_*` ve 298 `link_*_quiz_questions`
    migration'ı. Her seferinde aynı uzun kural seti yeniden kuruluyor: EN/TR kavram
    çiftleri, doğru şıkkın konum dağılımı, `CODE_OUTPUT` kuralı, quiz shell'in zaten var
    olup olmadığının kontrolü, `NOT EXISTS` + `ON CONFLICT` deseni.
  - *Yeni konu yazımı* — 168 konu; her biri `content/{tr,en}/{slug}.md`,
    `examples/{slug}/` ve 3–6 migration (`{slug}_topic` → `{slug}_sections` →
    `publish_{slug}_english`).
  - *Yeni kurs / kategori* — 7 kurs; her biri onaylanan bir roadmap, mevcut konuları
    tekrar öğretmeme kontrolü, `sort_order`, Quiz Area tanımı.
  - *Doğrulama* — çapraz referans taraması, `{{embed}}` ↔ `code_example` eşleşmesi,
    çevrilmemiş başlıklar, SEO uzunlukları, migration'da dolar-süslü-parantez.
    2026-10-05'te elle yapılan taramalar üç derste çevrilmemiş başlık, 242 uzun başlık
    ve 250 uzun açıklama buldu; bunlar yazım anında yakalanabilirdi.
  - *Faz kapanışı* — test, `docs/phase-log.md` satırı, gerekirse `CLAUDE.md`, commit.

## 3. İlkeler

- **Bir skill, bir iş.** Küçük ve odaklı; birbirini çağırabilir.
- **Kuralın tek kaynağı.** Bir kural skill'e taşındıysa `CLAUDE.md`'de tekrar edilmez;
  orada en fazla tek satırlık bir yönlendirme kalır.
- **Mekanik kontrol script'tir.** "Şunu kontrol et" diye düzyazı talimat yerine, skill
  klasöründe çalıştırılabilir bir script ve kısa bir "sorunlar" çıktısı.
- **Şablonlar gerçek dosyalardan.** SQL iskeletleri, yayında çalışan migration'lardan
  türetilir (ör. `docker-volumes/V508–V510`, `question-promotion/V903`, `tools-mcp/V905`).
- **Dil Türkçe**, `CLAUDE.md` ile tutarlı.
- **Her skill ilk gerçek işte denenir**, sonra bir kez gözden geçirilir.

## 4. Çekirdek skill'ler — yeni kurs ve konular için

### 4.1 `content-check` — içeriği doğrulamak

Diğer skill'lerin hepsi bunu çağırır; tek başına da çalıştırılabilir. Tek bir script,
yalnızca sorunları listeler:

- Tırnak içindeki bölüm atıfları gerçek bir H1/H2 ile birebir eşleşiyor mu (TR ve EN ayrı).
- Her `{{Dosya.ext}}` için dosya var mı, `code_example` satırı var mı, ve tersi.
- Türkçe derste çevrilmemiş İngilizce başlık (EN sürümle birebir aynı, cümle biçiminde).
- Markdown tablosu (render edilmiyor), çok paragraflı Tip/Warning blockquote'u.
- Migration'da dolar-süslü-parantez; tireli örnek dosya adı.
- `seo_title` 60, `seo_description` 160 karakteri aşıyor mu; "bu proje" ifadesi var mı.

- [x] Script ve skill yazıldı (`.claude/skills/content-check/`). Yalnızca raporlar;
  hiçbir dosyayı ya da DB satırını değiştirmez.
- [x] Mevcut tüm içerikte çalıştırıldı (2026-10-05): 15 HATA, 413 OLASI, 44 BİLGİ.
  Dökümü aşağıda "İlk çalıştırma sonuçları"nda.
- [ ] Bulgular için düzeltme stratejisi kararlaştırıldı (kullanıcı kararı bekleniyor)
- [ ] Gerçek bir yeni konuda denendi ve gözden geçirildi

**İlk çalıştırma sonuçları (2026-10-05, 336 içerik dosyası, 1066 migration):**

- *atif* — 15 HATA + 65 OLASI, 46 dosya. 9 HATA ders içeriğinde (başlıkla birebir
  eşleşmeyen atıf), 6 HATA yayındaki Türkçe quiz sorularında (İngilizce bölüm adına
  atıf). OLASI'ların çoğu başlığın kısaltılarak anılması ("Alanları Okumak" ↔
  "Alanları (Fields) Okumak"), bir kısmı başlık olmayan sıradan alıntı.
- *seo* — 344 OLASI: 250 açıklama 160 karakteri, 65 başlık 60 karakteri aşıyor; 29
  açıklama "bu proje" diyor. Eksik ya da tekrar eden alan yok.
- *baslik* — 4 OLASI (üçü bilinçli İngilizce ders adı, biri gerçek aday: "What Are
  Hooks?"), 7 BİLGİ (H1 ile DB başlığı farklı).
- *migration* — 32 BİLGİ: dolar-süslü-parantez içeren dosyalar; `placeholder-replacement:
  false` olduğu için artık hata vermiyor. Sürüm çakışması ya da boşluk yok.
- *embed* — 5 BİLGİ. Eksik örnek dosyası, kullanılmayan örnek dosyası yok.
- *dosya*, *markdown* — bulgu yok.

Denetim sırasında görülen iki kural farkı: (1) `CLAUDE.md`'deki "migration'da
dolar-süslü-parantez yazma" kuralı, `application.yml`'deki `placeholder-replacement: false`
ile bağlayıcılığını yitirmiş; (2) `code_example` tablosu çalışma anında hiç okunmuyor,
yalnızca metadata.

### 4.2 `quiz-questions` — bir konuya quiz sorusu yazıp yayına almak

En çok tekrarlanan iş, bu yüzden en yüksek kazanç burada.

- Kurallar tek yerde: konu uzunluğuna göre 4–7 soru, EN = TR sayıca eşit ve kavram
  çiftleri hâlinde (çeviri değil, bağımsız yazım), tip seçimi, doğru şık konumunun
  dengeli dağılımı, `CODE_OUTPUT` yalnızca dersin gerçekten gösterdiği bir çıktı varsa.
- Başlamadan önce quiz shell'in zaten var olup olmadığı kontrol edilir
  (`grep -rl "INSERT INTO quiz"`); Faz 157'deki `duplicate key` hatasının sebebi buydu.
- Dosyalar: `SKILL.md`, `templates/promote.sql`, `templates/link.sql`,
  `scripts/check_questions.py` (4 şık, tip başına doğru sayısı, yakın-kopya, harf dağılımı).
- Varsayılan yol: sorular Claude Code oturumunda yazılır. n8n/OpenAI hattı ayrı bir
  seçenek olarak kalır (bkz. Açık Kararlar).

- [ ] Skill ve şablonlar yazıldı
- [ ] Bir sonraki gerçek quiz işinde denendi

### 4.3 `new-topic` — bir konuyu uçtan uca yazmak

- Girdi: kurs/kategori ve konu adı.
- Akış: `docs/phase-log.md` ve komşu konuların başlıkları taranır (zaten öğretileni
  tekrar etmemek için) → bölüm planı → Türkçe markdown → örnek dosyalar → İngilizce
  markdown → migration'lar → `content-check` → test.
- Dosyalar: `SKILL.md`; `references/content-format.md` (`CLAUDE.md`'deki "İçerik Yazım
  Formatı" ve "Örnek Yazım İlkeleri" buraya taşınır); `references/migrations.md`;
  `templates/` (topic, sections, publish-english, quiz-shell).
- SEO kuralı yazım anında uygulanır: başlık en çok 60, açıklama en çok 160 karakter.
- Türkçe başlık kuralı: genel kabul görmüş teknik terimler İngilizce kalabilir,
  çevrilebilir ifadeler Türkçe yazılır.

- [ ] Skill, referanslar ve şablonlar yazıldı
- [ ] Bir sonraki gerçek konuda denendi

### 4.4 `finish-phase` — işi kapatmak

- JDK 21 ile `mvn test`.
- `docs/phase-log.md`'ye satır; yalnızca kilometre taşıysa `CLAUDE.md`.
- Commit (mesaj biçimi sabit, ilgisiz izlenmeyen dosyalar hariç). Push yapmaz.

- [ ] Skill yazıldı

### 4.5 `new-course` — yeni kurs ya da kategori açmak

- Roadmap taslağı (konular, sıra, zorluk) → mevcut müfredatla çakışma taraması →
  onay → course/category migration'ı → Quiz Area tanımı.
- Yeni kursun erişim kuralına (`CourseAccessPolicy`) ve sitemap'e doğru girdiği kontrol edilir.
- Konuların kendisini `new-topic`'e devreder.

- [ ] Skill yazıldı
- [ ] Bir sonraki yeni kurs/kategoride denendi

## 5. Destekleyici skill önerileri

Çekirdekten bağımsız; ihtiyaç doğdukça eklenebilir.

- **`run-local`** — uygulamayı JDK 21 ile boş bir portta başlatıp `curl` ile doğrulamak ve
  kapatmak. 2026-10-05'te aynı kurulum üç kez elle yapıldı.
- **`deploy-check`** — her push sonrası canlı site duman testi: durum kodları, `<title>`,
  sitemap adedi, yönlendirmeler, sıkıştırma ve önbellek başlıkları.
- **`seo-audit`** — başlık/açıklama uzunluk ve tekrar raporu; Search Console verisi
  geldiğinde açıklamaların yeniden yazımı (`docs/google-seo-adsense-plan.md`, Aşama 4).
- **`tr-review`** — bir Türkçe dersi dil açısından gözden geçirip düzeltmek (çevrilmemiş
  ifadeler, ek uyumu). `content-check` yalnızca bulur, bu düzeltir.
- **`practice-project`** — React/microservices kategorilerinin ayrı repodaki Pratik
  Proje'sini kurmak, build etmek, tag'lemek.
- **`ai-tools-lesson`** — `ai-development-tools` dersleri için doğrulama protokolü: her
  iddia resmi dokümana ya da gerçek terminal çıktısına dayanır, yoksa Warning ile belirtilir.

## 6. `CLAUDE.md` sadeleştirmesi

Skill'lerle birlikte yapılırsa kazanç tamamlanır.

- Skill'e taşınan her bölüm `CLAUDE.md`'den çıkarılır.
- Faz 87–160 "GÜNCELLEME" anlatıları zaten `docs/phase-log.md`'de; `CLAUDE.md`'den silinir.
- Eski ortam iddiaları güncellenir ya da kaldırılır (bkz. Açık Kararlar).
- Hedef: yaklaşık 1100 satırdan 250 satır civarına; yalnızca değişmez mimari kurallar kalır.

- [ ] Kararlar verildi
- [ ] `CLAUDE.md` sadeleştirildi

## 7. Uygulama sırası

1. `content-check` — hemen fayda sağlar, diğerlerinin dayanağı.
2. `quiz-questions` — en sık yapılan iş.
3. `new-topic` ve `finish-phase` — bir sonraki gerçek konuyla birlikte.
4. `new-course`, `run-local`, `deploy-check`.
5. `CLAUDE.md` sadeleştirmesi.
6. Diğer destekleyici skill'ler, ihtiyaç doğdukça.

Yazım sırasında kurulu `skill-creator` ve `writing-for-agents` skill'lerinden yararlanılır.

## 8. Açık kararlar

- **Eski ortam kuralları:** `CLAUDE.md`'deki "Maven Central engelli", "derleme
  yapılmıyor", "ZIP teslimatı" ve "sandbox" notları kaldırılsın mı? Başka bir ortamda
  (ör. web tabanlı bir oturumda) hâlâ çalışılıyorsa kalmaları, o ortama özel olarak
  işaretlenmeleri gerekir.
- **`AGENTS.md`:** silinsin mi, yoksa `CLAUDE.md`'ye yönlendiren tek satırlık bir dosyaya
  mı çevrilsin?
- **Soru üretiminin varsayılan yolu:** Claude Code içinde elle yazım mı, n8n/OpenAI hattı
  mı? Öneri: ilki varsayılan, ikincisi isteğe bağlı.

## Değişiklik Günlüğü

- **2026-10-05** — Doküman oluşturuldu. Henüz hiçbir skill yazılmadı.
- **2026-10-05** — Kararlar: skill'ler tek tek, her biri gerçek işte denenerek yazılacak;
  ilk skill `content-check` ve yalnızca raporlar; `CLAUDE.md` sadeleştirmesi skill'ler
  gerçek işlerde denenene kadar plan aşamasında kalacak; soru üretiminde varsayılan yol
  Claude Code + `quiz-questions`, n8n/OpenAI alternatif. `content-check` yazıldı ve tüm
  içerikte çalıştırıldı; bulgular henüz düzeltilmedi.
