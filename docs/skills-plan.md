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
- [x] Mevcut tüm içerikte çalıştırıldı (2026-10-05).
- [x] "Kesin" bulguların tamamı düzeltildi: 15 → 0 (ayrıntı aşağıda).
- [ ] 414 "doğrulanmalı" bulgu için karar (kullanıcı kararı bekleniyor)
- [ ] Yazım sırasında, tek konu modunda (`--slug`) gerçek bir işte denendi ve gözden geçirildi

**Güncel durum (2026-10-05, 336 içerik dosyası, 1068 migration): 0 kesin, 414
doğrulanmalı, 44 bilgi.**

- *atif* — 0 kesin, 66 doğrulanmalı. Örneklenenlerin çoğu başlığın kısaltılarak anılması
  ("Alanları Okumak" ↔ "Alanları (Fields) Okumak"), bir kısmı başlık olmayan sıradan
  alıntı. Tek tek gözden geçirilmedi.
- *seo* — 344 doğrulanmalı: 250 açıklama 160 karakteri, 65 başlık 60 karakteri aşıyor; 29
  açıklama "bu proje" diyor. Eksik ya da tekrar eden alan yok. Arama verisi gelene kadar
  bekliyor (bkz. `docs/google-seo-adsense-plan.md`, Aşama 4).
- *baslik* — 4 doğrulanmalı (üçü bilinçli İngilizce ders adı, biri gerçek aday: "What Are
  Hooks?"), 7 bilgi (sayfa içi H1 ile DB başlığı farklı).
- *migration* — 32 bilgi: dolar-süslü-parantez içeren dosyalar; `placeholder-replacement:
  false` olduğu için hata vermiyor. Sürüm çakışması ya da boşluk yok.
- *embed* — 5 bilgi. Eksik ya da kullanılmayan örnek dosyası yok.
- *dosya*, *markdown* — bulgu yok.

**Çalıştırma geçmişi (kesin / doğrulanmalı / bilgi):**

1. İlk çalıştırma: 15 / 413 / 44. Kesinlerin 9'u ders içeriğinde, 6'sı Türkçe quiz
   sorularında.
2. 8 içerik atfı ve 6 quiz sorusu düzeltildi (`question-fixes/V1067`): 1 / 413 / 44.
   Kalan tek bulgu yanlış alarmdı.
3. Denetim, quiz sorularındaki çift tırnaklı atıfları da tarayacak şekilde genişletildi
   (önce yalnızca tek tırnak taranıyordu): 27 / 413 / 44. 26 yeni bulgunun hepsi gerçek;
   25'i `microservices` kategorisinde, Türkçe sorunun İngilizce bölüm adına atıf yapması.
4. 26 soru düzeltildi (`question-fixes/V1068`): 1 / 413 / 44.
5. Numaralı adım listesindeki eşleşmeyen atıflar "kesin" yerine "doğrulanmalı" sayılacak
   şekilde kural eklendi (Vercel panelindeki "Environment Variables" bölümü gibi araç
   arayüzü atıfları için): 0 / 414 / 44.

**Bu turlardan çıkan dersler:**

- Toplam 40 hatalı atıf düzeltildi; 32'si Türkçe quiz sorularındaydı ve hepsi aynı
  hataydı: soru, Türkçe derste olmayan (İngilizce) bir bölüm adına atıf yapıyordu. Bu
  kural `quiz-questions` skill'ine yazım kuralı olarak girmeli.
- Quiz metni veritabanında yaşadığı için, yeni bir migration dev veritabanına işlenmeden
  (uygulama bir kez başlatılmadan) denetim onu göremez. Testler çalıştırıldıktan sonra
  test veritabanına karşı denetlemek mümkün:
  `CONTENT_CHECK_PSQL="docker exec learning-platform-db psql -U learning -d learning_test"`.
- Bir kontrol hiç bulgu vermiyorsa, çalıştığından emin olmak için kasıtlı bozuk bir
  örnekle denenmeli (tablo, Tip/Warning ve eksik örnek kontrolleri böyle doğrulandı).
- Sezgisel kurallar ilk çalıştırmada çok yanlış alarm verdi (ilk ham sonuç: 286 atıf
  adayı). Kalibrasyon gerçek içeriğe bakarak yapıldı: İngilizce yazımda tırnağın içine
  alınan virgül/nokta, blockquote satır devamı, küçük harfli genel terimler.
- Bir yanlış alarmı sabit istisna listesiyle değil, ölçülebilir genel bir işaretle ayırmak
  tercih edildi (~1250 bölüm atfının yalnızca 3'ü numaralı adım içinde). Kural, düzeltme
  öncesi içerik üzerinde yeniden çalıştırılarak gerçek 8 hatayı hâlâ yakaladığı doğrulandı.

Denetim sırasında görülen iki kural farkı: (1) `CLAUDE.md`'deki "migration'da
dolar-süslü-parantez yazma" kuralı, `application.yml`'deki `placeholder-replacement: false`
ile bağlayıcılığını yitirmiş; (2) `code_example` tablosu çalışma anında hiç okunmuyor,
yalnızca metadata.

### 4.2 `quiz-questions` — bir konuya quiz sorusu yazıp yayına almak

En çok tekrarlanan iş, bu yüzden en yüksek kazanç burada.

- Kurallar tek yerde: konu uzunluğuna göre 4–7 soru, EN = TR sayıca eşit ve kavram
  çiftleri hâlinde (çeviri değil, bağımsız yazım), tip seçimi, doğru şık konumunun
  dengeli dağılımı, `CODE_OUTPUT` yalnızca dersin gerçekten gösterdiği bir çıktı varsa.
- Bir soru derse bölüm adıyla atıf yapıyorsa, o dildeki dersin gerçek H2 başlığını
  birebir kullanır (Türkçe soru Türkçe başlığı). `content-check`'in bulduğu 32 hatalı
  sorunun hepsi bu kuralın ihlaliydi.
- Sorular yazıldıktan sonra `content-check` tek konu modunda çalıştırılır.
- Başlamadan önce quiz shell'in zaten var olup olmadığı kontrol edilir
  (`grep -rl "INSERT INTO quiz"`); Faz 157'deki `duplicate key` hatasının sebebi buydu.
- Varsayılan yol: sorular Claude Code oturumunda yazılır. n8n/OpenAI hattı ayrı bir
  seçenek olarak kalır.

- [x] Skill yazıldı (`.claude/skills/quiz-questions/`: `SKILL.md` + `build_quiz.py`)
- [x] İlk gerçek işte denendi: `if-else` (2026-10-05)
- [x] İlk kullanım sonrası gözden geçirme: `switch` ve ardından 14 konu ile (2026-10-05)

**Toplu kullanım (2026-10-05):** `switch` (12 soru, `V1073`–`V1076`) ve quiz'i olmayan
kalan 14 konu (148 soru, `V1077`–`V1132`) aynı skill ile yazıldı. Böylece yayındaki
derslerden quiz'i olmayan yalnızca bilerek dışarıda bırakılan ikisi kaldı:
`claude-code-cli-commands` (İngilizcesi yayında değil) ve `docker-practical-project`.

Bu kullanımda skill'de yapılan düzeltmeler:

- Şık harfi kontrolü büyük/küçük harfe duyarlı yapıldı ("a `break` or a `return`" artık
  harf atfı sayılmıyor).
- "Soru bağlandığı bölüme dayanıyor mu" kontrolü operatörleri (`++`, `+=`) ve bölümün
  gömdüğü örnek dosyaları da hesaba katıyor.
- Exception fırlatan kod soruları için `expectedException` doğrulaması eklendi.
- Kod sarmalayıcısından `throws Exception` kaldırıldı: checked exception fırlatan kod
  artık tam bir sınıf olarak yazılmak zorunda, çünkü okuyucunun gördüğü parça da tek
  başına derlenebilmeli (kullanıcı `join()` içeren iki örnekte fark etti).
- Yazım kurallarına "kesinlik" bölümü eklendi: mutlak ifadeler için karşı örnek aramak,
  belirli bir aracı zorunlu mekanizma gibi sunmamak.

Bu kullanımın ortaya çıkardığı ders hataları (hepsi düzeltildi): `switch` dersi
`case Role.ADMIN`'in derleme hatası olduğunu söylüyordu (Java 21'de derleniyor);
`introduction-to-exceptions` her exception'ın mesaj taşıdığını ima ediyordu;
`jsx` Babel'i Vite'ın JSX dönüşüm mekanizması olarak sunuyordu. İlki, soruların dayandığı
iddiaları derleyerek doğrularken; diğer ikisi kullanıcının soru incelemesinde bulundu.

**Nasıl çalışıyor (planlanandan farklı çıktı):** şablon SQL dosyaları yerine tek bir
script var. Sorular SQL olarak değil, kısa bir JSON tanım dosyasına yazılıyor;
`build_quiz.py check | preview | generate` onu denetliyor, okunabilir biçimde gösteriyor
ve var olan konvansiyondaki dört migration'ı (promote, quiz shell, EN link, TR link)
üretiyor. Önceden her soru metni elle üç kez yazılıyordu; artık tek yerde.

**`check`'in zorunlu tuttuğu kurallar:**

- 4 şık; tip başına doğru sayısı; `code` yalnızca `CODE_OUTPUT`'ta.
- Soru, şık ve açıklamada şık harfine (A/B/C/D) atıf yasak. Arayüzde harf yok ve mevcut 77
  sorunun açıklaması bu yüzden okuyucu için anlamsız (dokunulmadı).
- Java kod çıktısı soruları JDK 21 ile gerçekten derlenip çalıştırılır: gerçek çıktı beyan
  edilenle aynı olmalı, doğru şık gerçek çıktıyı içermeli, yanlış bir şık gerçek çıktıyla
  aynı olmamalı. Java dışı dillerde doğrulamanın nasıl yapıldığı yazılmadan geçmez.
- Her çift dersin iki dildeki aynı bölümüne bağlanır (`section`); iki başlığın da var
  olduğu ve aynı sırada olduğu doğrulanır. Anlamca aynı kavramı ölçtükleri mekanik olarak
  doğrulanamaz; akışta ayrı bir gözle kontrol adımı var.
- Bölüm atıfları o dildeki dersin gerçek başlığıyla birebir.
- Havuzda zaten bulunan soru reddedilir; quiz shell bir migration'da varsa yenisi üretilmez.
- Doğru şıkların A–D dağılımı yumuşak hedeftir: script dengelemeye çalışır, dengesizlik
  yalnızca bilgi olarak raporlanır.

**İlk kullanım — `if-else`:** 6 kavram çifti, 12 soru (dil başına 3 tek seçimli, 1 çok
seçimli, 2 kod çıktısı); `V1069`–`V1072`. Dört kod parçası çalıştırılarak doğrulandı.
Temiz test veritabanında migration'lar uygulandı, sorular ve bağlantılar sayıldı,
`content-check` bu konu için 0 kesin bulgu verdi, testler 129/129.

**İlk kullanımdan notlar:**

- Soruların kullanıcıya gösterilmesi ve onayı migration'dan önce ayrı bir adım olarak
  işe yaradı; akışta kalmalı.
- İlk taslakta kod çıktıları elle izlenmişti; hepsi doğru çıktı ama kullanıcının isteğiyle
  çalıştırarak doğrulama zorunlu hâle getirildi. Bu, `CLAUDE.md`'deki "`.java` dosyaları
  varsayılan olarak derlenmez" notunun quiz kodu için bilinçli bir istisnası.
- Quiz'i eksik 16 konu daha var (`java`: `control-flow`'un kalan 5 dersi, `exceptions` 2,
  `threads`; `react` 6; `ai-development-tools` 2). `control-flow`'un kalanı skill'in ikinci
  kullanımı için doğal aday.

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

- **Eski ortam kuralları:** `CLAUDE.md`'deki "Maven Central engelli", "`mvn -o`/Lombok
  geçici çözümü", "ZIP teslimatı" ve "`cdn.jsdelivr.net` erişilemiyor" notları bu makinede
  geçersiz (2026-10-05'te tek tek doğrulandı); hepsi kısıtlı bir bulut/sandbox oturumu
  için yazılmış. "`javac` ile derleme yapılmıyor" teknik bir engel değil, maliyet
  tercihi. Öneri: silmek yerine "yalnızca kısıtlı sandbox oturumları için" başlığı altında
  toplamak. Ayrıca `CLAUDE.md`'de eksik olan gerçek bir kısıt var: Maven varsayılan olarak
  JDK 26 ile çalışıyor, `JAVA_HOME` JDK 21'e verilmeli. Karar `CLAUDE.md` sadeleştirme
  planıyla birlikte verilecek.
- ~~**`AGENTS.md`**~~ — **karar verildi (2026-10-05): silindi.** `CLAUDE.md`'nin 26 Ağustos
  2026 tarihli, "Claude" kelimesi topluca "Codex" ile değiştirilmiş, git'te izlenmeyen bir
  kopyasıydı.
- ~~**Soru üretiminin varsayılan yolu**~~ — **karar verildi (2026-10-05):** varsayılan
  Claude Code + `quiz-questions` skill'i, n8n/OpenAI hattı alternatif.
- **414 "doğrulanmalı" bulgu:** 66 atıf tek tek gözden geçirilsin mi; "What Are Hooks?"
  başlığı çevrilsin mi; SEO açıklamaları arama verisini beklesin mi?

## Değişiklik Günlüğü

- **2026-10-05** — Doküman oluşturuldu. Henüz hiçbir skill yazılmadı.
- **2026-10-05** — Kararlar: skill'ler tek tek, her biri gerçek işte denenerek yazılacak;
  ilk skill `content-check` ve yalnızca raporlar; `CLAUDE.md` sadeleştirmesi skill'ler
  gerçek işlerde denenene kadar plan aşamasında kalacak; soru üretiminde varsayılan yol
  Claude Code + `quiz-questions`, n8n/OpenAI alternatif. `content-check` yazıldı ve tüm
  içerikte çalıştırıldı; bulgular henüz düzeltilmedi.
- **2026-10-05** — `content-check` ile beş tur: 40 hatalı atıf düzeltildi (8 içerik, 32
  Türkçe quiz sorusu; `V1067`, `V1068`), denetim çift tırnaklı quiz atıflarını ve numaralı
  adım listelerini ayırt edecek şekilde geliştirildi. Kesin bulgu 15 → 0. `AGENTS.md`
  silindi. Sıradaki skill: `quiz-questions`.
- **2026-10-05** — `quiz-questions` yazıldı ve `if-else` ile denendi (12 soru,
  `V1069`–`V1072`). Kullanıcının isteğiyle dört kural eklendi: şık harfi yasağı, kod
  çıktısının gerçekten çalıştırılarak doğrulanması, EN/TR çiftinin aynı bölüme bağlanması,
  doğru şık dağılımının yumuşak hedef olması.
- **2026-10-05** — `quiz-questions` ile `switch` ve kalan 14 konu yazıldı (160 soru,
  `V1073`–`V1132`); skill dört yerde düzeltildi; üç derste soru yazımı sırasında bulunan
  yanlışlıklar giderildi. Sıradaki skill: `new-topic` (bir sonraki gerçek konuyla).
