# LearnForgeX — Google'a Kayıt ve AdSense Yol Haritası

**İlk yazım:** 2026-10-05 · **Canlı site:** https://www.learnforgex.com

Bu doküman yaşayan bir plandır. Karar değiştikçe ya da bir adım tamamlandıkça
ilgili bölüm güncellenir ve en alttaki "Değişiklik Günlüğü"ne tarihli bir satır eklenir.

## 1. Amaç ve Gerçekçi Beklenti

**Hedef:** siteyi Google'da bulunur hâle getirmek, ardından Google AdSense ile
hosting (Railway) ve domain masrafını karşılamak.

**Sıra önemli:** AdSense bir trafik kaynağı değil, var olan trafiği paraya çeviren
bir araçtır. Yol şu sırayla ilerler: teknik SEO düzeltmeleri → Google'a kayıt →
indexlenme ve organik trafik → AdSense başvurusu → reklam yerleşimi.

**Beklentiyi doğru kurmak için (aşağıdakiler tahmindir, ölçüm değildir):**

- Yazılım eğitimi sitelerinde 1000 sayfa görüntüleme başına gelir (RPM) genelde
  düşüktür; Türkiye trafiğinde daha da düşük, ABD/Avrupa trafiğinde daha yüksektir.
  Kabaca 0,5–5 USD aralığı beklenebilir.
- Geliştirici kitlesinde reklam engelleyici kullanımı yüksektir; görüntülemelerin
  önemli bir kısmı reklam göstermez.
- Bu aralıkla, aylık 10–20 USD'lik bir masrafı çıkarmak için kabaca **ayda
  10.000–30.000 sayfa görüntüleme** gerekir. Gerçek rakam ancak GA4 + AdSense
  verisi geldikten sonra bilinir.
- Organik trafiğin oluşması haftalar değil aylar sürer. Yeni bir sitede ilk
  anlamlı trafik için 3–6 ay normaldir.
- AdSense ödemesi belirli bir eşiğe ulaşınca yapılır; öncesinde adres (PIN) ve
  vergi bilgisi doğrulaması istenir. Güncel eşik ve Türkiye'deki ödeme yöntemi
  başvuru sırasında AdSense yardım sayfasından teyit edilmeli.

## 2. Mevcut Durum (2026-10-05'te canlı siteye karşı doğrulandı)

### Zaten iyi olanlar

- `robots.txt` var ve `Sitemap:` satırı doğru.
- `/sitemap.xml` çalışıyor: 92 URL (46 EN + 46 TR), her birinde hreflang alternatifleri.
- Anasayfa ve topic sayfalarında canonical, hreflang (`en`/`tr`/`x-default`),
  Open Graph, Twitter card ve JSON-LD (`WebSite`, `LearningResource`) mevcut.
- HTTPS çalışıyor, `http → https` 301 ile yönleniyor.
- Login/register sayfaları `noindex`.
- İçerik hacmi güçlü ve özgün: 168 topic × 2 dil, yaklaşık 274 bin İngilizce +
  240 bin Türkçe kelime. AdSense'in "yeterli ve özgün içerik" şartı için bu büyük
  bir avantaj.
- `topic_translation` tablosunda `seo_title` / `seo_description` kolonları zaten
  var; sayfa başına başlık/açıklama optimizasyonu için altyapı hazır.

### Sorunlar (öncelik sırasıyla)

1. **KRİTİK — tüm topic sayfalarının `<title>` etiketi bozuk.** Canlıda EN ve TR
   sayfalarda `<title>translation.seoTitle | LearnForgeX</title>` çıkıyor. Sebep
   `templates/topic.html:6`: iç ifade `${...}` dışında kaldığı için Thymeleaf onu
   düz metin sayıyor. `og:title` ve JSON-LD doğru, yalnızca `<title>` bozuk. Google
   arama sonucunda başlık olarak öncelikle `<title>`'ı kullanır; bu hâliyle her ders
   aynı anlamsız başlıkla görünür.
2. **KRİTİK (stratejik) — içeriğin yaklaşık %73'ü Google'a kapalı.** Faz 160
   gereği yalnızca `java` kursu anonim erişime açık. Sitemap'te 46 topic var,
   kalan ~122 topic anonim istekte login'e 302 yapıyor. Googlebot bu sayfaları
   göremez: indexlenmez, trafik getirmez, reklam geliri üretmez. Bkz. Aşama 2.
3. **Login yönlendirmesi `http://` ile dönüyor.** `/en/topics/what-is-docker` →
   `Location: http://www.learnforgex.com/en/login` → 301 → https. Uygulama Railway
   proxy'sinin arkasında olduğunu bilmiyor (`server.forward-headers-strategy`
   ayarlı değil).
4. **Yanıt sıkıştırması yok.** `content-encoding` başlığı gelmiyor; anasayfa
   286 KB, bir topic sayfası 124 KB sıkıştırılmadan gidiyor.
5. **Statik dosyalar önbelleğe alınmıyor.** `/css/custom.css` gibi dosyalar
   `cache-control: no-cache, no-store` ile dönüyor.
6. **`https://learnforgex.com` (www'siz) www'ye yönlenmiyor**, uygulamayı ayrı bir
   host olarak sunuyor. Canonical www'yi gösterdiği için ağır bir sorun değil ama
   tek host'a 301 daha temiz.
7. **Topic sayfasında iki `<h1>` var:** `topic.html:134`'teki başlık ve markdown'ın
   kendi H1'i.
8. **Anasayfa meta description'ı zayıf:** "Practical learning content in Turkish
   and English." — hangi konuların öğretildiğini söylemiyor.
9. **404 yanıtı ham JSON.** Özel bir hata sayfası yok.
10. **Sitemap'te `<lastmod>` yok** (bilinçli bir karardı, düşük öncelik).

### AdSense için tamamen eksik olanlar

- Gizlilik Politikası, Hakkında, İletişim, Kullanım Koşulları sayfaları (hepsi 404;
  footer yalnızca © satırından ibaret).
- Çerez onayı / onay yönetim platformu (CMP).
- `ads.txt` (404).
- Google Search Console doğrulaması ve Analytics (GA4).

## 3. Aşama 0 — Teknik SEO Düzeltmeleri (Google'a kayıttan önce)

Bunlar küçük, birbirinden bağımsız işler. İlk ikisi yapılmadan Search Console'a
sitemap göndermek, Google'ın bozuk başlıkları indexlemesi demek.

- [x] **`<title>` hatasını düzelt** (`templates/topic.html:6`) — 2026-10-05'te kodda
  düzeltildi, **deploy bekliyor**. Diğer şablonların başlıkları kontrol edildi,
  aynı hata yok.
- [x] **Proxy başlıklarını tanıt** — `application-prod.yml`'e
  `server.forward-headers-strategy: framework` eklendi. Yerelde
  `X-Forwarded-Proto: https` ile login yönlendirmesinin `https://` döndüğü doğrulandı.
- [x] **Sıkıştırmayı aç** — `application.yml`. Yerelde anasayfa 280 KB → 32 KB.
- [x] **Statik dosyalara önbellek süresi ver** — `/css`, `/js`, `/img` bir yıl
  önbellekleniyor, linkler içerik hash'i taşıyor (`/css/custom-<hash>.css`), dosya
  değişince adres de değişiyor (`WebConfig`). `robots.txt` gibi kök dosyalar
  bilinçli olarak kapsam dışı.
- [ ] **www'siz host'u www'ye 301 yap** (Railway/DNS seviyesinde ya da küçük bir
  filtreyle).
- [x] **Tek `<h1>` bırak** — markdown'dan gelen başlık, görünümü değişmeden başlık
  olmayan bir öğeye çevriliyor (`MarkdownService.demoteH1`); sayfanın tek `<h1>`'i
  şablondaki ders başlığı.
- [x] **Anasayfa description'ını yeniden yaz** — yeni `home.metaDescription` mesajı
  (EN/TR), kursları adıyla sayıyor.
- [x] **Özel 404 sayfası ekle** — `templates/error/404.html`, iki dilli, `noindex`.
- [ ] (Opsiyonel) Sitemap'e `<lastmod>` eklemek için `topic_translation`'a bir
  `updated_at` kolonu.

## 4. Aşama 1 — Google'a Kayıt (Search Console)

"Google'a kaydetmek" pratikte Google Search Console'da site sahipliğini doğrulamak
ve sitemap göndermektir. Ücretsizdir.

- [ ] https://search.google.com/search-console adresinde **Domain property** olarak
  `learnforgex.com` ekle. Doğrulama, domain sağlayıcısının DNS paneline bir TXT
  kaydı eklenerek yapılır. Domain property; http/https ve www/www'siz tüm
  varyantları tek seferde kapsar.
- [ ] **Sitemap gönder:** "Sitemaps" bölümüne `https://www.learnforgex.com/sitemap.xml`.
- [ ] **URL Denetimi** ile anasayfaları (`/en`, `/tr`) ve en önemli 5–10 topic
  sayfasını tek tek "Dizine eklenmesini iste".
- [ ] 1–2 hafta sonra **Sayfalar (Pages)** raporunu kontrol et: indexlenen sayfa
  sayısı, "Tarandı – şu anda dizine eklenmedi" ve "Yönlendirmeli sayfa" uyarıları.
- [ ] **Geliştirmeler** altında yapılandırılmış veri (JSON-LD) hatalarına bak.
- [ ] **Bing Webmaster Tools**'a kayıt ol; Search Console'dan içe aktarma seçeneği
  var, birkaç dakikalık iş.
- [ ] **Google Analytics 4** mülkü oluştur ve ölçüm kodunu `fragments/layout.html`'e
  ekle. Çerez onayı gelene kadar (Aşama 3) kod yalnızca onay sonrası çalışacak
  şekilde bağlanmalı.

## 5. Aşama 2 — Login Duvarı ve Indexlenebilirlik (KARAR VERİLDİ)

Şu anki kural (Faz 160): anonim kullanıcı yalnızca `java` kursunu görür. Bu,
gelir hedefiyle doğrudan çelişiyor: Spring Boot, React, AI, PostgreSQL, Git ve
Docker dersleri Google için yok hükmünde.

**Seçenekler:**

- **(a) Tüm ders içeriğini anonim okumaya aç; login'i quiz, Practice, Quiz Area
  gibi etkileşimli özelliklere sakla. — ÖNERİLEN.** Indexlenebilir sayfa sayısı
  46'dan ~168'e (iki dille ~336 URL'ye) çıkar. Kayıt olmanın bir değeri kalmaya
  devam eder.
- **(b) Her kursta ilk N topic'i aç, kalanını kapalı tut.** Orta yol; trafik
  potansiyelinin bir kısmı feda edilir, policy daha karmaşık hâle gelir.
- **(c) Olduğu gibi bırak.** Yalnızca 46 Java topic'iyle büyümek. Masrafı
  çıkaracak trafiğe ulaşmak belirgin biçimde zorlaşır.

**Uygulama notu:** kuralın tek kaynağı `config/CourseAccessPolicy`; menü, sitemap
ve `SecurityConfig` hepsi ona soruyor. (a) seçilirse değişiklik dar kalır:
policy'de topic sayfası erişimi açılır, submit/practice uç noktaları korunmaya
devam eder, sitemap otomatik olarak tüm kursları listeler.

**Karar (2026-10-05): (a) seçildi ve kodda uygulandı, deploy bekliyor.** Ders
sayfaları ve PDF'ler tüm kurslarda herkese açık; Java dışı kursların quiz'leri,
Quiz Area'sı ve Practice'i giriş istemeye devam ediyor. Anonim ziyaretçi bu
derslerin sonunda sorular yerine "quiz için giriş yap" çağrısı görüyor. Sitemap
artık yayındaki tüm kursları listeliyor.

- [ ] Deploy sonrası doğrula: `/en/topics/what-is-docker` anonim istekte 200
  dönmeli, `/sitemap.xml`'deki URL sayısı 92'den ~330'a çıkmalı, bir topic
  sayfasının `<title>`'ı gerçek başlığı göstermeli.

## 6. Aşama 3 — AdSense'e Hazırlık

AdSense başvurusunda site elle ve otomatik olarak incelenir. Aşağıdakiler ret
sebeplerinin en yaygın olanlarını kapatır.

### Zorunlu sayfalar

Hepsi projenin `/{lang:en|tr}/...` desenine uymalı, footer'dan linklenmeli ve
sitemap'e eklenmeli.

- [x] **Gizlilik Politikası** (`/{lang}/privacy`) — sitenin BUGÜNKÜ durumunu anlatıyor
  (hesap verisi, zorunlu oturum çerezi, barındırma, jsDelivr CDN). Analitik ve
  reklam "ileride eklenebilir" diye geçiyor.
- [ ] **Gizlilik Politikası'nı GA4/AdSense açılmadan ÖNCE güncelle:** Google'ın
  çerez kullanımı, üçüncü taraf reklam sağlayıcıları ve kişiselleştirilmiş reklamı
  kapatma yolu açıkça yazılmalı (AdSense bunu şart koşuyor).
- [ ] **Hakkında** (`/{lang}/about`) — sayfa var ama içeriği "yapım aşamasında".
  Bu hâliyle `noindex` ve sitemap dışında. Gerçek metin yazılınca
  `StaticPage.ABOUT`'un `indexable` değeri `true` yapılmalı. **AdSense başvurusundan
  önce doldurulmalı.**
- [x] **İletişim** (`/{lang}/contact`) — learnforgex@gmail.com.
- [x] **Kullanım Koşulları** (`/{lang}/terms`).
- [x] Footer bu dört sayfaya link veriyor (tüm sayfalarda).
- [ ] Gizlilik ve Koşullar metinleri taslaktır, hukuki incelemeden geçmedi; yayına
  almadan önce bir kez okunmalı.

Metinler `src/main/resources/pages/{lang}/{slug}.md` dosyalarında; değiştirmek için
yalnızca o dosyayı düzenlemek yeterli.

### Çerez onayı

- [ ] AB, Birleşik Krallık ve İsviçre'den gelen ziyaretçilere kişiselleştirilmiş
  reklam gösterebilmek için Google, kendi sertifikalandırdığı bir CMP kullanılmasını
  şart koşuyor. En az zahmetli yol AdSense panelindeki "Gizlilik ve mesajlaşma"
  bölümünden Google'ın kendi onay mesajını etkinleştirmek. Güncel kapsam başvuru
  sırasında teyit edilmeli.
- [ ] GA4 kodu Consent Mode ile bağlanmalı (onay verilmeden analitik çerezi
  yazılmamalı).

### Diğer

- [ ] **`ads.txt`**: AdSense hesabı açıldıktan sonra verilen yayıncı kimliğiyle
  `static/ads.txt` olarak eklenir (`google.com, pub-XXXXXXXXXXXXXXXX, DIRECT, f08c47fec0942fa0`).
- [ ] Her topic sayfasında yazar ve (varsa) güncellenme tarihi görünür olsun.
- [ ] Site gezinmesi boş/yarım sayfa içermesin: yayında olmayan çevirilere menüden
  link verilmediği doğrulanmalı.

## 7. Aşama 4 — Trafik Büyütme

İçerik zaten var; iş onu bulunur kılmak.

- [ ] **Başlık ve açıklamaları doldur:** her topic için arama niyetine uygun
  `seo_title` (50–60 karakter) ve `seo_description` (150–160 karakter). Boş
  olanları bulmak için tek bir SQL sorgusu yeterli. Yeni bir migration ile
  güncellenir.
- [ ] **İç linkleme:** dersler birbirine zaten isimle atıf yapıyor; bu atıfları
  gerçek linke çevirmek hem kullanıcıya hem Google'a yardımcı olur. Topic sonuna
  "önceki / sonraki ders" linkleri.
- [ ] **Kurs ve kategori açılış sayfaları** (`/{lang}/courses/{slug}`): şu an
  indexlenebilir bir "Java kursu" sayfası yok; bunlar geniş sorgular için giriş
  noktası olur.
- [ ] **Search Console → Performans** raporunu ayda bir incele: gösterimi yüksek
  ama tıklaması düşük sorguların başlık/açıklamasını iyileştir.
- [ ] **Türkçe tarafı önceliklendir:** Türkçe teknik içerikte rekabet çok daha az;
  ilk trafik büyük olasılıkla buradan gelir.
- [ ] **Dış sinyal:** GitHub profili/README, LinkedIn, ilgili Türkçe geliştirici
  toplulukları, uygun yerlerde kendi dersine link veren yanıtlar. Spam değil,
  gerçekten soruyu çözen paylaşımlar.
- [ ] **Core Web Vitals:** Aşama 0'daki sıkıştırma ve önbellek düzeltmelerinden
  sonra PageSpeed Insights ile anasayfa ve bir topic sayfası ölçülmeli. Anasayfanın
  286 KB HTML'i büyük ölçüde sidebar'daki tüm topic listesinden geliyor.

## 8. Aşama 5 — AdSense Başvurusu ve Reklam Yerleşimi

**Ne zaman başvurulmalı:** Aşama 0–3 tamamlanmış, sayfaların çoğu indexlenmiş ve
düzenli (az da olsa) organik trafik gelmeye başlamışken. Resmi bir asgari trafik
şartı yok, ama boş trafikli bir siteyle erken başvuru ret riskini artırır.

- [ ] https://adsense.google.com üzerinden başvur, siteyi ekle.
- [ ] Verilen doğrulama kodunu `<head>`'e ekle (`fragments/layout.html` ya da ortak
  head parçası).
- [ ] `ads.txt`'yi yayınla.
- [ ] İnceleme birkaç günden birkaç haftaya kadar sürebilir. Ret gelirse sebep
  genelde "değeri düşük içerik" ya da "site gezinmesi" olur; e-postadaki sebebi
  giderip yeniden başvurulur.

**Yerleşim önerisi (onay sonrası):**

- Reklam olan sayfalar: topic sayfaları ve anasayfa.
- Reklam olmayan sayfalar: login, register, admin, quiz çözme ekranları ve PDF
  çıktısı.
- Topic sayfasında başlangıç için iki slot: içeriğin sonunda bir tane, sağdaki
  TOC'un altında bir tane. İçerik ortasına, özellikle kod bloklarının arasına
  reklam koymaktan kaçınılmalı.
- Slotlara sabit `min-height` verilmeli; aksi hâlde reklam yüklenince sayfa
  kayar (CLS) ve hem deneyim hem sıralama zarar görür.
- Auto Ads başlangıçta kapalı tutulup manuel slotlarla başlanması, yerleşimin
  kontrolde kalmasını sağlar.
- Girişli kullanıcılara reklam göstermemek kayıt olmaya bir teşvik olabilir
  (opsiyonel ürün kararı).

**Teknik not:** site `X-Frame-Options: DENY` gönderiyor; bu, sitenin başka
sayfalara gömülmesini engeller, sayfa içindeki reklam iframe'lerini etkilemez.
İleride bir Content-Security-Policy eklenirse Google reklam alan adlarına izin
verilmesi gerekir.

## 9. Aşama 6 — Ölçüm ve Alternatif Gelirler

**Aylık takip edilecekler:** indexlenen sayfa sayısı, organik tıklama ve gösterim
(Search Console); sayfa görüntüleme ve ülke dağılımı (GA4); RPM ve toplam gelir
(AdSense); aylık Railway faturası.

**AdSense tek başına yetmezse:**

- Geliştirici odaklı reklam ağları (ör. Carbon Ads, EthicalAds). Genelde asgari
  trafik şartı ararlar ama reklam engelleyicilere daha az takılırlar ve kitleye
  daha uygundur.
- Affiliate linkler: kitap, IDE, hosting, kurs platformları. İlgili derse doğal
  biçimde yerleştirilir, açıkça belirtilir.
- Sponsorluk ya da "destek ol" bağlantısı (GitHub Sponsors, Buy Me a Coffee).
- Maliyet tarafı: masrafı düşürmek de hedefe aynı ölçüde yaklaştırır; Railway
  kullanımı ve plan seviyesi ara ara gözden geçirilmeli.

## 10. Özet Sıra

1. Aşama 0 — teknik düzeltmeler (www yönlendirmesi dışında yapıldı).
2. Aşama 2 — login duvarı kararı (yapıldı); deploy et ve canlıda doğrula.
3. Aşama 1 — Search Console doğrulaması, sitemap gönderimi, GA4.
4. Aşama 3 — yasal sayfalar ve footer (yapıldı; Hakkında metni eksik), çerez onayı.
5. Aşama 4 — başlık/açıklama, iç linkleme, kurs sayfaları; trafiği izle.
6. Aşama 5 — AdSense başvurusu, onay sonrası reklam yerleşimi ve `ads.txt`.
7. Aşama 6 — ölçüm, gerekirse alternatif gelir.

## Değişiklik Günlüğü

- **2026-10-05** — Doküman oluşturuldu. Mevcut durum canlı siteye karşı `curl` ile
  ve repo incelenerek doğrulandı. Login duvarı kararı açık.
- **2026-10-05** — Login duvarı kararı verildi: (a). Ders içeriği tüm kurslarda
  anonim okumaya açıldı, topic `<title>` hatası düzeltildi (Faz 161). İkisi de
  kodda tamam ve testleri geçiyor; canlıya henüz çıkmadı.
- **2026-10-05** — Aşama 0'ın kalanı kodda tamamlandı (proxy başlıkları, sıkıştırma,
  statik önbellek, tek `<h1>`, anasayfa description'ı, 404 sayfası). Açık kalan tek
  madde www'siz host yönlendirmesi. Yerelde çalışan uygulamaya karşı doğrulandı;
  canlıya henüz çıkmadı.
- **2026-10-05** — Hakkında / İletişim / Gizlilik Politikası / Kullanım Koşulları
  sayfaları ve footer linkleri eklendi (EN/TR). Hakkında şimdilik "yapım aşamasında"
  ve `noindex`.
