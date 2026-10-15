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

> **Güncelleme (2026-10-05 akşamı, deploy sonrası):** aşağıdaki "Sorunlar" listesindeki
> 1–5 ve 7–9. maddeler ile zorunlu sayfaların eksikliği giderildi ve canlıda doğrulandı.
> Açık kalanlar: 6 (www'siz host yönlendirmesi), 10 (`<lastmod>`), çerez onayı, `ads.txt`,
> Search Console ve Analytics. Liste, başlangıç durumunun kaydı olarak aşağıda duruyor.
>
> **Güncelleme (2026-10-08):** Search Console kaydı tamamlandı (Domain property doğrulandı,
> sitemap "Success", 357 sayfa bulundu; bkz. Aşama 1). Sitemap artık 357 URL listeliyor
> (aşağıdaki 92, başlangıç değeridir). 6. madde de kapandı: www'siz adres Cloudflare'da 301
> ile www'ye yönleniyor ve alan adı Cloudflare DNS'ine taşındı (bkz. Aşama 0 ve Aşama 1).
> Açık kalanlar: 10 (`<lastmod>`), çerez onayı, `ads.txt`, Analytics (GA4).
>
> **Güncelleme (2026-10-08, ikinci):** üç teknik iş daha tamamlandı ve canlıda doğrulandı:
> ders sayfalarında kod renklendirme düzeltildi (bkz. Aşama 0), Cloudflare'ın kendiliğinden
> eklediği RUM ölçüm script'i kapatıldı ve çerez onayı altyapısının Aşama 1'i eklendi
> (ikisi için bkz. Aşama 3). Çerez onayı bilinçli olarak kapalı; GA4, Tag Manager ve AdSense
> hâlâ yok.
>
> **Güncelleme (2026-10-11):** 10. madde (`<lastmod>`) ile ders sayfasındaki yazar ve
> güncellenme tarihi uygulandı ve canlıda doğrulandı (`372b214`; bkz. Aşama 0 ve Aşama 3
> "Diğer"). "Sorunlar" listesinde açık madde kalmadı.

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
  düzeltildi ve canlıda doğrulandı. Diğer şablonların başlıkları kontrol edildi,
  aynı hata yok.
- [x] **Proxy başlıklarını tanıt** — `application-prod.yml`'e
  `server.forward-headers-strategy: framework` eklendi. Yerelde
  `X-Forwarded-Proto: https` ile login yönlendirmesinin `https://` döndüğü doğrulandı.
- [x] **Sıkıştırmayı aç** — `application.yml`. Yerelde anasayfa 280 KB → 32 KB.
- [x] **Statik dosyalara önbellek süresi ver** — `/css`, `/js`, `/img` bir yıl
  önbellekleniyor, linkler içerik hash'i taşıyor (`/css/custom-<hash>.css`), dosya
  değişince adres de değişiyor (`WebConfig`). `robots.txt` gibi kök dosyalar
  bilinçli olarak kapsam dışı.
- [x] **www'siz host'u www'ye 301 yap** — Cloudflare Redirect Rules'ta "Apex to WWW"
  kuralı aktif (2026-10-08): `learnforgex.com` → `https://www.learnforgex.com`, 301, yol
  ve sorgu parametreleri korunuyor. Kalıp `http*://learnforgex.com/*`, hedef
  `https://www.learnforgex.com/${2}` (`${1}` şema jokeridir; ilk kurulumda `${1}`
  kullanıldığı için tüm `https` istekleri `/s` adresine gidip 404 veriyordu). HTTP ve
  HTTPS için, kök adres, derin linkler ve `/sitemap.xml` ile canlıda `curl` ile doğrulandı.
  Uygulama kodunda değişiklik yok; kök adresin `/en`'e 302'si (`HomeController`) aynı.
- [x] **Tek `<h1>` bırak** — markdown'dan gelen başlık, görünümü değişmeden başlık
  olmayan bir öğeye çevriliyor (`MarkdownService.demoteH1`); sayfanın tek `<h1>`'i
  şablondaki ders başlığı.
- [x] **Anasayfa description'ını yeniden yaz** — yeni `home.metaDescription` mesajı
  (EN/TR), kursları adıyla sayıyor.
- [x] **Özel 404 sayfası ekle** — `templates/error/404.html`, iki dilli, `noindex`.
- [x] **PDF'lerin indexlenmesini engelle** — her dersin "PDF İndir" bağlantısı, ders
  sayfasının birebir kopyası olan bir PDF döndürüyor ve yanıtta indexlemeyi engelleyen
  bir başlık yoktu (336 kopya sayfa riski; ayrıca bot her taramada sunucuya PDF
  ürettirir). PDF yanıtına `X-Robots-Tag: noindex` eklendi (`TopicController.pdf`,
  2026-10-05, `3a77abc`). Canlıda; `deploy-check` her çalıştırmada bu başlığı doğruluyor.
- [x] **Kod renklendirmeyi (Highlight.js) düzelt** (2026-10-08, `aa574da`; canlıda).
  Ders, quiz ve soru inceleme sayfaları script'i jsDelivr'de var olmayan bir paket yolundan
  (`highlight.js@11.9.0/lib/highlight.min.js`, 404) yüklüyordu; `hljs` tanımsız kaldığı için
  sitedeki hiçbir kod bloğu renklenmiyordu (ilk commit'ten beri). Script artık tarayıcı
  derlemesini içeren `@highlightjs/cdn-assets@11.9.0` paketinden yükleniyor; aynı paketten
  Dockerfile dil dosyası da eklendi (varsayılan derlemede yok). Stil dosyasının adresi ve
  `hljs.highlightAll()` çağrıları değişmedi. Çalışma dizinindeki Highlight.js ve Cookie
  Consent değişiklikleri birlikteyken `mvn test` 151/151 başarılı oldu; production'da
  Highlight.js Java ve Dockerfile blokları headless Chrome ile doğrulandı (Java dersinde
  19/19, Docker dersinde 9/9 Dockerfile bloğu renkli, sayfa hatası yok).
- [x] **Sitemap'te ders adreslerine `<lastmod>`** (2026-10-11, `372b214`; canlıda). Değer, o çevirinin `topic_translation.updated_at` alanıdır
  (`YYYY-MM-DD`; kolonlar için bkz. Aşama 3 "Diğer"). Yalnızca 335 ders adresinde vardır;
  anasayfa, kurs ve statik sayfalara (24 adres) güvenilir bir tarih kaynağı olmadığı için
  bilinçli olarak eklenmedi. Toplam adres sayısı 359'da kaldı; `<lastmod>` satırları
  çıkarıldığında yeni sitemap canlıdakiyle bayt bayt aynı (adresler, sıra ve hreflang
  bağlantıları değişmedi). 335 değerin tamamı onaylanan tarih listesiyle eşleşti. Aynı
  karşılaştırmalar deployment sonrası canlı sitemap'e karşı tekrarlandı: 359 adres, 335 ders
  adresinin `<lastmod>` değeri listeyle aynı, diğer 24 adreste `<lastmod>` yok.

## 4. Aşama 1 — Google'a Kayıt (Search Console)

"Google'a kaydetmek" pratikte Google Search Console'da site sahipliğini doğrulamak
ve sitemap göndermektir. Ücretsizdir.

- [x] https://search.google.com/search-console adresinde **Domain property** olarak
  `learnforgex.com` eklendi ve sahiplik doğrulandı. Domain property; http/https ve
  www/www'siz tüm varyantları tek seferde kapsar.
- [x] **Sitemap gönderildi:** `https://www.learnforgex.com/sitemap.xml`. **Durum
  (Search Console, 2026-10-08):** "Success", son okuma 7 Ekim 2026, 357 sayfa bulundu,
  0 video. İlk gönderimde (2026-10-06) "Couldn't fetch" görünmüştü; uç nokta incelendi,
  sorun bulunmadı ve sitemap değiştirilmedi. Durum kendiliğinden düzeldi: yeni mülkte
  henüz işlenmemiş gönderimin geçici durumuydu. Dosya tarayıcıda düz metin gibi GÖRÜNÜR
  (hreflang için kullanılan `xhtml:link` öğeleri yüzünden); bu bir görüntüleme etkisidir,
  XML geçerlidir (`SitemapXmlTest` yanıtı XML olarak ayrıştırıp doğruluyor).
- [x] **Anasayfalar:** `/tr` Google dizininde. `/en` için "Canlı URL'yi test et" başarılı
  oldu ve "Dizine eklenmesini iste" gönderildi.
- [ ] **`/en`'in dizine eklenmesi bekleniyor** (istek gönderildi; yapılacak bir iş yok,
  Sayfalar raporunda izlenecek).
- [ ] **URL Denetimi** ile en önemli 5–10 topic sayfası için, gerektiğinde, tek tek
  "Dizine eklenmesini iste". Search Console tarafında sıradaki tek iş bu.
- [x] **Kök alan adındaki DNS kaydı:** alan adı Namecheap BasicDNS'ten Cloudflare DNS'ine
  taşındı (2026-10-08'de doğrulandı); nameserver'lar `derek.ns.cloudflare.com` ve
  `janet.ns.cloudflare.com`. Namecheap'teyken kökte NS/SOA/TXT kayıtlarıyla birlikte duran
  standart dışı CNAME sorunu böylece kapandı: kök alan adı artık dışarıya CNAME değil, A
  kaydı olarak yanıt veriyor (Google Public DNS ve 1.1.1.1 ile doğrulandı). www'siz adresin
  www'ye yönlendirilmesi de Cloudflare'da (bkz. Aşama 0).

> **Eski tarama kayıtları hakkında:** site bir süre Railway'de kapalıydı. Search Console'da
> o döneme ait 404 / "bilinmeyen URL" sonuçları (ör. `/en` için eski bir 404 kaydı) bu
> yüzden görünüyor. Bunlar geçmiş taramaların kaydıdır, canlı sitedeki güncel bir hata
> değildir; yeniden tarandıkça kendiliğinden güncellenir.
- [ ] 1–2 hafta sonra **Sayfalar (Pages)** raporunu kontrol et: indexlenen sayfa
  sayısı, "Tarandı – şu anda dizine eklenmedi" ve "Yönlendirmeli sayfa" uyarıları.
- [ ] **Geliştirmeler** altında yapılandırılmış veri (JSON-LD) hatalarına bak.
- [ ] **Bing Webmaster Tools**'a kayıt ol; Search Console'dan içe aktarma seçeneği
  var, birkaç dakikalık iş.
- [ ] **Google Analytics 4** mülkü oluştur ve ölçüm kodunu `fragments/layout.html`'e
  ekle. Çerez onayı gelene kadar (Aşama 3) kod yalnızca onay sonrası çalışacak
  şekilde bağlanmalı. GA4 eklendiğinde analitik çerezlerinin listesi ve Gizlilik
  Politikası'nın "Analitik" bölümü aynı işte güncellenir (Gizlilik Politikası Aşama 2'den
  buraya taşındı).

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

**Karar (2026-10-05): (a) seçildi, uygulandı ve canlıda.** Ders
sayfaları ve PDF'ler tüm kurslarda herkese açık; Java dışı kursların quiz'leri,
Quiz Area'sı ve Practice'i giriş istemeye devam ediyor. Anonim ziyaretçi bu
derslerin sonunda sorular yerine "quiz için giriş yap" çağrısı görüyor. Sitemap
artık yayındaki tüm kursları listeliyor.

- [x] Deploy sonrası doğrulandı (2026-10-05): `/en/topics/what-is-docker` anonim
  istekte 200 dönüyor, `/sitemap.xml`'deki URL sayısı 92'den 343'e çıktı, ders
  sayfalarının `<title>`'ı gerçek başlığı gösteriyor.

## 6. Aşama 3 — AdSense'e Hazırlık

AdSense başvurusunda site elle ve otomatik olarak incelenir. Aşağıdakiler ret
sebeplerinin en yaygın olanlarını kapatır.

### Zorunlu sayfalar

Hepsi projenin `/{lang:en|tr}/...` desenine uymalı, footer'dan linklenmeli ve
sitemap'e eklenmeli.

- [x] **Gizlilik Politikası** (`/{lang}/privacy`) — sitenin BUGÜNKÜ durumunu anlatıyor
  (hesap verisi, zorunlu oturum çerezi, barındırma, jsDelivr CDN). Aşama 2'den (2026-10-14)
  beri AdSense açıklamaları EN/TR politikalarda yer alıyor; metin, GA4'ün eklenmediğini ve
  AdSense reklam kodunun henüz sitede olmadığını açıkça söylüyor. CMP / onay mesajı, rızayı
  geri alma yolu ve üçüncü taraf sağlayıcı listesi hâlâ açık (aşağıdaki maddeler).
- [x] **Gizlilik Politikası, Aşama 1: teknik/içerik güncellemesi** (2026-10-08, EN/TR).
  Metin sitenin gerçekten kullandığı hizmetlerle eşitlendi: siteyi kimin işlettiği
  (Cemalettin Durgun), Cloudflare (tüm trafik, olası güvenlik çerezleri), Railway ve
  Gmail adlarıyla; uygulama ve veritabanının Railway'in ABD'deki altyapısında çalıştığı
  (`railway status`: iki servis de `sfo`; Railway'in Türkiye bölgesi yok); her veri
  kategorisinin kullanım amacı; `JSESSIONID`; e-posta yazışmaları; şikâyet hakkı. Bilinçli
  olarak YOK: ayrı bir hukuki dayanak bölümü ("sözleşmenin ifası", "meşru menfaat", "açık
  rıza" gibi nitelendirmeler), "veri sorumlusu" terimi, posta adresi. Bu, politikanın
  tamamlandığı anlamına gelmez; aşağıdaki iki madde açık.
- [x] **Gizlilik Politikası, Aşama 2: AdSense açıklamaları** (2026-10-14, EN/TR). Google'ın
  "Required content" sayfasındaki üç açıklama (üçüncü taraf satıcıların ve Google'ın reklam
  çerezleri, kişiselleştirilmiş reklamı Ads Settings ve aboutads.info üzerinden kapatma),
  reklam kodunu içeren sayfada Google'a giden veri, Google'ın kendi belgesinden örnek çerezler
  (`IDE`, `id`, `DSID`, `_gads`; tam liste değil, kaynak linkli), ayrı "Analitik" bölümü.
  Mevcut durum metinde açıkça yazılı: "bu güncelleme itibarıyla" reklam kodu yok, reklam ve
  analitik çerezi yok. Reklam çerezlerinin görünür reklam olmasa da kodu içeren sayfada
  oluşabileceği yazıldı (AdSense Help "How AdSense uses cookies"). Kişiselleştirme kapalıyken
  ne olduğu Google'ın kendi ifadesine göre yazıldı (partner-sites: bağlamsal reklam sürer;
  çerez silmek tek başına kişiselleştirmeyi kapatmaz). AEA/BK/İsviçre için onay şartı mevcut
  bir özellik olarak DEĞİL, "reklam kodu onay mesajından önce eklenmeyecek" taahhüdü olarak
  yazıldı. "Satılmaz" yalnızca hesap bilgileriyle sınırlı; hesap bilgilerinin Google'a
  gönderilmediğine dair güvence ve rızayı geri alma yolu bilinçli olarak YOK. Çerez cümlesi
  temkinli: uygulama "oturum gerektiğinde" `JSESSIONID` kullanır ("tek çerez" iddiası yok).
  Bu, kodda (çerez API'si yok, CSRF oturumda) ve canlıda (14 Ekim 2026, `curl`: yalnızca
  login/kayıt sayfası ve login POST'unda `JSESSIONID`, diğer sayfalarda çerez yok) doğrulandı.
  Kaynaklar: support.google.com/adsense/answer/1348695, /10502938, /7549925, /13554116;
  google.com/about/company/user-consent-policy; policies.google.com/technologies/cookies;
  policies.google.com/technologies/partner-sites.
- [ ] **Rızayı geri alma yolu.** Google'ın onay mesajının sağladığı gerçek geri alma mekanizması
  hesap açılınca doğrulanıp politikaya eklenmeli (AB kullanıcı rızası politikası açık geri
  alma talimatı istiyor). Uydurulmuş bir bağlantı adı yazılmamalı.
- [ ] **Üçüncü taraf reklam sağlayıcıları.** Politika yalnızca Google'ı adıyla anıyor; liste tam
  değil. Hesaptaki etkin sağlayıcılar görülünce ad ve bağlantılarıyla tamamlanmalı ya da
  üçüncü taraf reklam sunumu hakkında karar verilmeli.
- [ ] **Reklam kodu eklendiği gün politika güncellemesi (zorunlu).** Politikadaki "bu güncelleme
  itibarıyla reklam kodu eklenmemiştir / reklam ve analitik çerezi yok" cümleleri o gün
  yanlış olur. Aynı push'ta bu cümleler, "Onayın gerektiği yerler" paragrafı (gerçek onay
  mesajı ve geri alma yolu) ve tarih güncellenmeli; sitede gerçekten oluşan çerezler
  tarayıcıda gözlenip politikadaki örneklerle karşılaştırılmalı.
- [ ] **Kullanım Koşulları'nda reklamdan söz etmek gerekir mi?** Şu an Koşullar ne reklama ne
  Gizlilik Politikası'na atıf yapıyor; gerekip gerekmediğine karar verilmeli.
- [ ] **AdSense sözleşmesinin güncel (Türkiye) sürümündeki gizlilik maddesi** başvuru sırasında
  okunup politikayla karşılaştırılmalı (bu çalışmada bulunan sürüm 2018/ABD idi, kullanılmadı).
- [x] **Hakkında** (`/{lang}/about`) — gerçek metin yazıldı (2026-10-08, EN/TR): platformu
  kimin oluşturduğu (Cemalettin Durgun), yedi kursun kurs sayfalarına linkli listesi,
  erişim kuralı, yaklaşım ve İletişim sayfasına link. `StaticPage.ABOUT` artık
  `indexable=true`: sayfa `noindex` taşımıyor ve sitemap'te (357 → 359 URL). Metin ders
  sayısını "160'tan fazla" olarak veriyor; ders sayısı bu ifadeyi geçersiz kılacak kadar
  değişirse ya da yeni bir kurs eklenirse sayfa güncellenmeli.
- [x] **İletişim** (`/{lang}/contact`) — learnforgex@gmail.com.
- [x] **Kullanım Koşulları** (`/{lang}/terms`).
- [x] Footer bu dört sayfaya link veriyor (tüm sayfalarda).
- [ ] Gizlilik ve Koşullar metinleri taslaktır, hukuki incelemeden geçmedi; yayına
  almadan önce bir kez okunmalı.

Metinler `src/main/resources/pages/{lang}/{slug}.md` dosyalarında; değiştirmek için
yalnızca o dosyayı düzenlemek yeterli.

### Kayıt formu

- [x] **Kayıt formuna açık onay satırı** (2026-10-06, `179f9e3`; canlıda): formda
  zorunlu bir onay kutusu var: "Kullanım Koşulları'nı kabul ediyorum, Gizlilik
  Politikası'nı okudum", iki metne de yeni sekmede açılan linklerle. Kutu işaretlenmeden
  hesap oluşturulmuyor (sunucu tarafında doğrulanıyor). Kabul anı ayrı bir kolonda
  tutulmuyor: bu tarihten sonra açılan her hesap için `created_at` aynı zamanda kabul
  anıdır. Bu tarihten önce açılmış hesaplar onay vermedi.
- [ ] Onay metninin ve kapsamının KVKK/GDPR açısından yeterliliği için hukuki görüş al
  (ör. Gizlilik Politikası için "okudum" beyanı yeterli mi, ayrı açık rıza gerekir mi).

### Çerez onayı

- [x] **Çerez onayı, Aşama 1: altyapı** (2026-10-08, `2efebfa`; canlıda, KAPALI). Ortak
  footer parçasında küçük, sabit konumlu bir banner (Kabul Et / Reddet / Ayarlar; "Zorunlu"
  her zaman açık, "Analitik" başlangıçta kapalı), footer'da "Çerez ayarları" linki ve yeni
  `static/js/consent.js`. Tercih sunucuya gönderilmez, tarayıcının `localStorage`'ında
  `lfx-consent` anahtarıyla tutulur (sürüm, seçim, tarih). Metinler Türkçe ve İngilizce.
  **Özellik bilinçli olarak kapalı:** `app.analytics.consent-enabled` varsayılan olarak
  `false` ve hiçbir yapılandırma dosyasında açılmıyor; bu durumda banner, footer linki ve
  `consent.js` sayfalara hiç dahil edilmiyor. Canlıda doğrulandı: `consent.js` yüklenmiyor,
  banner görünmüyor, `lfx-consent` kaydı oluşmuyor. GA4, Tag Manager ve AdSense henüz yok;
  `consent.js` içinde analitik için yalnızca boş bir genişleme noktası var. Bu altyapı
  ileride GA4 ve AdSense gibi isteğe bağlı teknolojiler için kullanılacak (aşağıdaki iki
  madde açık).
- [ ] AB, Birleşik Krallık ve İsviçre'den gelen ziyaretçilere kişiselleştirilmiş
  reklam gösterebilmek için Google, kendi sertifikalandırdığı bir CMP kullanılmasını
  şart koşuyor. En az zahmetli yol AdSense panelindeki "Gizlilik ve mesajlaşma"
  bölümünden Google'ın kendi onay mesajını etkinleştirmek. Güncel kapsam başvuru
  sırasında teyit edilmeli.
  **Önkoşul (AdSense kodundan ÖNCE):** sertifikalı CMP / "Privacy & messaging" onay mesajı
  etkinleştirilip AEA, BK ve İsviçre için çalıştığı doğrulanmadan AdSense kodu (doğrulama
  kodu dahil) siteye eklenmemeli. Gizlilik Politikası bunu ziyaretçiye taahhüt ediyor.
  Bu madde kapanmadan AdSense hazırlığı tamamlanmış sayılmaz. Şu an CMP yok; projedeki kendi
  onay altyapısı kapalı (`app.analytics.consent-enabled=false`) ve sertifikalı bir CMP değil.
- [ ] GA4 kodu Consent Mode ile bağlanmalı (onay verilmeden analitik çerezi
  yazılmamalı).

### Cloudflare RUM

- [x] **Cloudflare RUM (Real User Measurements) kapatıldı** (2026-10-08). Cloudflare,
  ücretsiz planda RUM'u kendiliğinden açıyor: uygulama kodunda olmadığı hâlde HTML
  sayfalarına `static.cloudflareinsights.com/beacon.min.js` script'ini ekliyor, tarayıcı da
  her sayfa yüklemesinde `/cdn-cgi/rum` adresine sayfa adresi ve performans ölçümleri
  gönderiyordu (çerez yazmadan). Kapatmak için Cloudflare'da Configuration Rules altında
  "Disable RUM" adlı, "All incoming requests" kapsamlı aktif bir kural oluşturuldu.
  Observatory'deki "Don't enable RUM" seçimi tek başına script'i kaldırmamıştı. Canlıda
  headless Chrome ile doğrulandı (8 Ekim 2026; `/en`, `/tr`, `/en/topics/enum`,
  `/en/privacy`): `beacon.min.js` yüklenmiyor, `/cdn-cgi/rum` isteği yapılmıyor, HTML'de
  `cloudflareinsights`, `beacon.min.js` ve `data-cf-beacon` bulunmuyor; önceki testte var
  olan beacon tamamen kalktı. Bu, çerez onayından bağımsız bir Cloudflare yapılandırmasıdır;
  çerez onayı açılıp kapansa da RUM kapalı kalır. Gizlilik Politikası mevcut durumla uyumlu:
  tarayıcı tarafında Cloudflare'ın ölçüm script'i çalışmıyor. Script yeniden görünürse
  bakılacak yer bu kural.

### Cloudflare e-posta gizleme

- [x] **Email Address Obfuscation incelendi, değişiklik yapılmadı** (2026-10-14, salt-okunur).
  Cloudflare, canlıda Gizlilik, İletişim ve Koşullar sayfalarındaki e-posta adresini HTML'de
  gizliyor ve sayfaya sitenin kendi alan adından `email-decode.min.js` script'ini ekliyor.
  Script adresi tarayıcıda `mailto:` bağlantısına geri çeviriyor. Mevcut Gizlilik Politikası'yla
  çelişmediği gözlemlendi: incelenen sürümünde çerez, ek ağ isteği ya da tarayıcı depolaması
  kullanılmıyor. **Bilinen erişilebilirlik sınırlaması:** JavaScript kapalıyken adres
  "[email protected]" olarak görünüyor ve bağlantı Cloudflare'ın bir 404 sayfasına gidiyor.
  Şu an ne Cloudflare ayarında ne de politikada değişiklik planlanıyor. İletişim bağlantıları
  ya da Cloudflare yapılandırması değişirse yeniden değerlendirilmeli. Ayarın yeri: Cloudflare
  Security → Settings → Email Address Obfuscation (panelden okunmadı, davranıştan çıkarıldı).

### Diğer

- [ ] **`ads.txt`**: AdSense hesabı açıldıktan sonra verilen yayıncı kimliğiyle
  `static/ads.txt` olarak eklenir (`google.com, pub-XXXXXXXXXXXXXXXX, DIRECT, f08c47fec0942fa0`).
- [x] **Her ders sayfasında yazar ve güncellenme tarihi** (2026-10-11, `372b214`; canlıda).
  - **Veri:** `core/V1137` ile `topic_translation` tablosuna `published_at` ve `updated_at`
    eklendi (`DATE NOT NULL`, varsayılan `CURRENT_DATE`, kısıt `updated_at >= published_at`);
    `TopicTranslation` entity'sinde `publishedAt` / `updatedAt` (`LocalDate`). Mevcut 336
    çevirinin (168 EN + 168 TR) tarihleri git geçmişinden (`d51d527`) bir kez çıkarılıp
    migration'a sabit değer olarak yazıldı; çalışan uygulama git'e bakmaz.
    `published_at` 2026-08-08..2026-08-31, `updated_at` 2026-08-09..2026-10-06 aralığında;
    141 kayıtta `updated_at > published_at`, 49 derste EN ve TR güncellenme tarihi farklı.
  - **`updated_at` nasıl hesaplandı:** ders dosyasının ve dersin gömdüğü örnek kod
    dosyalarının son commit tarihlerinden geç olanı. SEO açıklaması (`V1135`, `V1136`),
    şablon ve stil değişiklikleri sayılmadı. `96d8121` (2026-08-18) ve `179f9e3`
    (2026-10-06) toplu commit'leri gerçek ders metni değişikliği içerdiği için dahil edildi.
  - **SINIRLAMA — `published_at` gerçek yayın tarihi değildir.** Ders dosyasının git
    geçmişinde tespit edilen İLK COMMIT tarihidir. Dersin sitede gerçekten yayına girdiği
    günü garanti etmez; birkaç gün erken olabilir (bazı EN çeviriler commit edildikten
    sonra yayına alındı). Bu yüzden HİÇBİR YERDE yayınlanmaz: sayfada gösterilmez,
    JSON-LD'ye `datePublished` olarak yazılmaz, sitemap'te kullanılmaz. Kolon ve entity
    alanı yalnızca iç kayıt olarak durur (ileride gerçek yayın tarihleri elde edilirse
    kullanılabilir). Not: `V1137` dosyasının ilk yorum satırı hâlâ `datePublished`'dan
    söz eder; uygulanmış bir migration değiştirilmediği için düzeltilmedi.
  - **Sayfa:** zorluk rozeti ve süre satırının altında tek satır — TR "Yazan: Cemalettin
    Durgun · Son güncelleme: 6 Ekim 2026", EN "By Cemalettin Durgun · Last updated:
    October 6, 2026". Ad `/{lang}/about` sayfasına bağlanır; tarih
    `<time datetime="YYYY-MM-DD">` içindedir. Etiketler ve tarih biçimi mesaj
    dosyalarından gelir.
  - **JSON-LD:** `LearningResource` bloğuna `author` (`Person`, ad + Hakkında adresi) ve
    `dateModified` eklendi; `provider` (LearnForgeX) ve diğer alanlar değişmedi.
    `datePublished` bilinçli olarak eklenmedi (yukarıdaki sınırlama). Bu alanlar bir
    Google zengin sonucu üretmez, yalnızca veriyi tamamlar.
  - **Doğrulama:** V1137, V1136'ya kadar kurulmuş tek kullanımlık PostgreSQL'de denendi
    (336/336 tarih eşleşti, diğer kolonlar değişmedi, kısıt ve varsayılanlar doğru).
    `mvn test` 159/159 (151 mevcut + 5 `TopicBylineTest` + 3 `SitemapXmlTest`).
    `content-check` 0 HATA. `deploy-check` yerel derlemeye karşı 0 hata.
  - **Bakım kuralı:** tarihler otomatik değildir; içerik anlamlı biçimde değiştiğinde
    `updated_at` bir migration'la ilerletilir (bkz. `CLAUDE.md`, "Mimari").
  - [x] **Mobil görünüm doğrulandı** (2026-10-11, yerel derleme; gerçek Chrome, Playwright ile
    mobil cihaz öykünmesi). `/tr/topics/enum` ve `/en/topics/enum` 390 ve 320 piksel
    genişlikte: yazar adı, ayırıcı ve tarih eksiksiz görünüyor; satır iki satıra bölünüyor;
    yatay taşma, kesilme, üst üste binme ve yatay kaydırma yok (sayfanın kaydırılabilir
    genişliği görüntü alanına eşit). 1280 pikselde tek satır. Önceki kesik ekran görüntüsü
    görüntü alma yönteminden kaynaklanmıştı. Kozmetik not (düzeltilmedi): dar ekranda satır
    etiketin ortasından kırılabiliyor ("Son" / "güncelleme: ..."); etiketi bölünmez yapmak
    320 pikselde uzun tarihlerde taşma riski taşıdığı için bilinçli olarak yapılmadı.
  - [x] **Canlı doğrulama** (2026-10-11, `372b214`): Railway deployment'ı başarılı; production
    log'unda Flyway şemayı 1136'dan aldı ve "Successfully applied 1 migration ... now at
    version v1137" yazdı. `deploy-check` 33/33 (mevcut 29 + yeni 4). `enum` ve
    `wrapper-classes` derslerinin EN ve TR sayfalarında yazar satırı, `<time>` değeri ve
    JSON-LD `author` / `dateModified` onaylanan tarihlerle aynı; sayfalarda `datePublished`
    yok. Canlı sitemap: 359 adres, 335/335 ders adresinde doğru `<lastmod>`, diğer 24 adreste
    yok; `<lastmod>` satırları dışında deployment öncesi sitemap ile bayt bayt aynı.
  - [x] **Kontrol script'leri** (2026-10-11): `deploy-check`'e "Yazar ve güncellenme tarihi"
    bölümü eklendi (4 kontrol: yazar satırı, JSON-LD `author` + `dateModified`, `<lastmod>`'un
    yalnızca ders adreslerinde olması, sayfa ile sitemap tarihinin aynı olması). `content-check`'e
    `tarih` kontrolü eklendi: push edilmemiş değişiklik setinde içerik değişmiş ama `updated_at`
    migration'ı yoksa, ya da bir çeviri `updated_at` yazılmadan yayına alınıyorsa uyarır.
    İkisi de yalnızca raporlar; tarih hesaplamaz, git commit tarihlerini okumaz.
  - [x] **PDF tarihi** (2026-10-12, `6bbdd15`; canlıda).
    PDF'in kapak bloğu artık ders çevirisinin `updated_at` değerini gösterir; etiket ve biçim
    ders sayfasıyla aynı mesaj anahtarlarından gelir (TR "Son güncelleme: 6 Ekim 2026",
    EN "Last updated: October 6, 2026"). Eskiden PDF'in üretildiği gün yazıyordu
    ("Oluşturulma tarihi"), bu dersin tarihi sanılabiliyordu; o satır kaldırıldı, üretim
    tarihi PDF'te artık hiçbir yerde yok. Yazar adı PDF'te yer almaz. İndirme adresi, dosya
    adı, başlıklar (`X-Robots-Tag: noindex`) ve her istekte yeniden üretim değişmedi.
    `TopicPdfDateTest` gerçek PDF çıktısının metnini çıkarıp tarihi veritabanındaki
    `updated_at` ile karşılaştırır; `mvn test` 163/163. Canlı doğrulama (2026-10-12):
    deployment başarılı, migration yok (şema 1137'de kaldı), `deploy-check` 33/33. Canlıdan
    indirilen `wrapper-classes` PDF'lerinde TR "Son güncelleme: 6 Ekim 2026", EN "Last
    updated: August 18, 2026" (ikisi de o çevirinin `updated_at` değeri); üretim tarihi ve
    yazar adı yok; dosya adları ve başlıklar aynı. Sitemap değişmedi (359 adres, 335
    `<lastmod>`).
- [x] Site gezinmesi boş/yarım sayfa içermesin: yayında olmayan çevirilere menüden
  link verilmediği doğrulanmalı. **Denetim tamamlandı (2026-10-14, salt-okunur), sorun
  bulunmadı.** Yan menü, anasayfa/kurs kartları ve prev/next `NavigationService`
  üzerinden yalnızca `published = true` çevirileri gösteriyor. Canlı tarama: 351 sayfa
  (2 anasayfa, 14 kurs, 335 ders), 703 benzersiz iç hedef (ders içi linkler dahil);
  702'si yönlendirmesiz 200, tek istisna beklenen `/cdn-cgi/l/email-protection`
  (Cloudflare e-posta gizleme). Menüdeki ders kümesi sitemap ve yerel dev DB ile
  birebir aynı (EN 167, TR 168); yayında olmayan tek çeviri `claude-code-cli-commands`
  EN'e hiçbir yerden link, hreflang ya da dil butonu yok. Linkler sayfa diliyle
  tutarlı, canonical/hreflang 351 sayfada doğru. Kodda değişiklik yapılmadı.

## 7. Aşama 4 — Trafik Büyütme

İçerik zaten var; iş onu bulunur kılmak.

- [x] **Başlıkları kısalt** (2026-10-05). Eksik `seo_title`/`seo_description` yoktu;
  sorun uzunluktu. ` | LearnForgeX` eki artık yalnızca başlık 60 karaktere sığıyorsa
  ekleniyor, ve 70 karakteri aşan 64 başlık 60'ın altına indirildi (`seo/V1065`).
  61–70 karakter arasında 65 başlık kaldı; ek almıyorlar, arama sonucunda sonları
  hafifçe kesilebilir.
- [ ] **Açıklamaları kısalt:** 335 `seo_description`'ın 250'si 160 karakteri aşıyor
  (ortalama ~220, en uzunu 491); 29'u arama sonucunda anlamsız kalan "bu projenin
  kendi şeması" gibi ifadeler içeriyor. Search Console'da birkaç haftalık veri
  biriktikten sonra, gösterim alan sayfalardan başlayarak yeniden yazılacak.
  - [x] **İlk tur: en sorunlu 30 dersin EN ve TR açıklaması yeniden yazıldı** (2026-10-08,
    `V1135`; 60 kayıt). Ölçüt 160 karaktere kesmek değil, okunabilirlikti: 300 karakteri
    aşan, Markdown ters tırnağı ya da sözdizimi listesi içeren, ya da iç atıf taşıyan
    açıklamalar seçildi. Yeni metinler 136–178 karakter; aranan soru ilk cümlede. İki
    içerik hatası da düzeldi: Thymeleaf dersindeki "dollar-brace variable access" (migration
    kısıtı yüzünden yazılmış dolaylı ifade) ve React + Spring Boot deployment dersindeki,
    ders metninde hiç geçmeyen "Docker". Atılabilir bir PostgreSQL container'ında tüm
    migration'lar sıfırdan çalıştırılarak tam bu 60 kaydın değiştiği doğrulandı.
  - [x] **İkinci tur: 24 dersin EN ve TR açıklaması yeniden yazıldı** (2026-10-09, `V1136`;
    48 kayıt). Üç grup: "bu projenin kendi…" ifadesi taşıyan 14 ders (3 Docker, 11
    PostgreSQL), Markdown ters tırnağı içeren 8 Java dersi ve dersi anlatmayacak kadar kısa
    olan `enum` ile `records`. PostgreSQL açıklamalarının çoğu uzadı: kalıp ifade çıkınca
    yerine "PostgreSQL" adı ve dersin gerçekten işlediği konular geldi. Yeni metinler
    122–182 karakter. Atılabilir bir PostgreSQL container'ında tam bu 48 kaydın değiştiği,
    başka hiçbir kaydın ve alanın değişmediği doğrulandı.
  - [ ] Bilinçli olarak değiştirilmeyenler: `component-scanning` ve
    `validation-exception-handling` (uzun ama içerdikleri annotation adları aranan terimler)
    ile `what-is-an-ai-agent` (sorunsuz). Hâlâ açık: 251–300 karakter arasında olup başka
    kusuru olmayan ~36 kayıt; Search Console verisi biriktikçe gösterim alanlardan başlanacak.
- [ ] **İç linkleme:** dersler birbirine zaten isimle atıf yapıyor; bu atıfları
  gerçek linke çevirmek hem kullanıcıya hem Google'a yardımcı olur. Topic sonuna
  "önceki / sonraki ders" linkleri.
- [x] **Kurs açılış sayfaları** (2026-10-06): `/{lang}/courses/{slug}`, yedi kurs × iki
  dil. Kursa özel başlık ve açıklama, kategorilere göre ders kartları, canonical, hreflang
  ve `Course` yapılandırılmış verisi; sitemap'te (343 → 357 URL). Anasayfa ve yan menüdeki
  kurs adları bu sayfalara link veriyor. Kategori için ayrı sayfa yok; kategoriler kurs
  sayfasında `#kategori-slug` ile hedeflenebilen bölümler.
- [x] **`BreadcrumbList` yapılandırılmış verisi** (2026-10-06): ders sayfalarında görünür
  breadcrumb "Ana Sayfa › Kurs › Kategori › Ders" oldu ve aynı yol yapılandırılmış veri
  olarak da veriliyor.
- [x] **Kurs ve kategori adları dile göre** (2026-10-06): Türkçe sayfalarda Türkçe adlar
  (ör. "Kontrol Akışı", "Yapay Zeka"); slug'lar ve adresler değişmedi.
- [ ] **Search Console → Performans** raporunu ayda bir incele: gösterimi yüksek
  ama tıklaması düşük sorguların başlık/açıklamasını iyileştir.
- [ ] **Türkçe tarafı önceliklendir:** Türkçe teknik içerikte rekabet çok daha az;
  ilk trafik büyük olasılıkla buradan gelir.
- [ ] **Dış sinyal:** GitHub profili/README, LinkedIn, ilgili Türkçe geliştirici
  toplulukları, uygun yerlerde kendi dersine link veren yanıtlar. Spam değil,
  gerçekten soruyu çözen paylaşımlar.
- [x] **Core Web Vitals:** Aşama 0'daki sıkıştırma ve önbellek düzeltmelerinden
  sonra PageSpeed Insights ile anasayfa ve bir topic sayfası ölçülmeli. Anasayfanın
  286 KB HTML'i büyük ölçüde sidebar'daki tüm topic listesinden geliyor.
  **Reklam öncesi başlangıç ölçümü (2026-10-15, salt-okunur, kodda değişiklik yok).**
  Ölçülen URL'ler: `https://www.learnforgex.com/` (302 ile `/en`'e gider) ve temsilî ders
  `https://www.learnforgex.com/en/topics/string`.
  - **Gerçek kullanıcı verisi (CrUX) yok:** PSI dört ölçümde de "Veri Yok" gösterdi.
    Aşağıdakilerin hepsi laboratuvar (Lighthouse) verisidir. INP laboratuvarda ölçülemez;
    yerine TBT raporlandı. Değerler tek ya da az sayıda koşumdan geliyor, ağ ve sunucu
    durumuna göre oynar; kesin bir performans garantisi değildir.
  - **PSI (pagespeed.web.dev, Google altyapısı, her biri tek koşum).** PSI API'sinin
    anahtarsız günlük kotası doluydu (429), sonuçlar web arayüzünden okundu.
    - Anasayfa mobil: Performans 98; FCP 1,8 sn, LCP 2,0 sn, TBT 0 ms, CLS 0, Speed Index 2,0 sn.
    - Anasayfa masaüstü: Performans 100; FCP 0,5 sn, LCP 0,5 sn, TBT 0 ms, CLS 0, SI 1,0 sn.
    - Ders mobil: Performans 98; FCP 1,8 sn, LCP 2,0 sn, TBT 0 ms, CLS 0, SI 2,4 sn.
    - Ders masaüstü: Performans 100; FCP 0,5 sn, LCP 0,6 sn, TBT 0 ms, CLS 0, SI 0,9 sn.
  - **Yerel Lighthouse 13.5.0** (geliştirici makinesi, headless Chrome, 3 koşumun medyanı;
    PSI'dan daha kötümser, aynı makinede tekrar karşılaştırma için):
    - Anasayfa mobil: Performans 94/94/95; FCP 2,27 sn, LCP 2,42 sn, TBT 0, CLS 0, SI 3,09 sn.
    - Anasayfa masaüstü: 98/96/97; FCP 0,89 sn, LCP 0,89 sn, TBT 0, CLS 0, SI 1,27 sn.
    - Ders mobil: 94/94/94; FCP 2,11 sn, LCP 2,72 sn, TBT 0, CLS 0, SI 2,72 sn.
    - Ders masaüstü: 98/99/98; FCP 0,75 sn, LCP 0,89 sn, TBT 0, CLS 0, SI 1,16 sn.
  - **HTML boyutu ve yan menü:** `/en` ham 285 KB, Brotli ile 29,5 KB; ders sayfası ham
    150 KB, Brotli ile 21,4 KB. Yan menü ham HTML'in anasayfada %26'sı, ders sayfasında
    %50'si (~75 KB), ama sıkıştırılmış hâli sayfa başına ~6 KB. Ölçülen aktarım etkisi
    küçük; şu an öncelik değil.
  - **Sunucu yanıt süresi (TTFB, `curl`, sayfa başına 5 istek):** yan menüyü oluşturan
    sayfalar (`/en`, `/en/about`, ders) 0,84–1,08 sn; menüsüz dinamik sayfalar (`/en/login`,
    `/sitemap.xml`) 0,36–0,43 sn; statik CSS ~0,2 sn. HTML Cloudflare'de önbelleklenmiyor
    (`cf-cache-status: DYNAMIC`). Lighthouse da mobilde sunucu yanıtını 730–940 ms ölçtü.
    **Hipotez (doğrulanmadı):** ~0,5 sn'lik fark yalnızca `NavigationService.buildNavigation`
    kullanan sayfalarda görülüyor; servisin kendi yorumu topic başına ayrı sorgu (N+1)
    yaptığını belirtiyor. Bu bir korelasyon; nedeni kesinleştirmek için yerelde sorgu
    sayısı/süre profili gerekir. Doğrulanırsa olası çözüm: tek sorgu (fetch-join/projection)
    ve/veya menünün dil başına uygulama içinde önbelleklenmesi.
  - **Render-blocking CSS:** Lighthouse mobilde ~840–850 ms tahmini tasarruf gösteriyor;
    başlıca kaynak `cdn.jsdelivr.net`'ten gelen Bootstrap CSS (34 KB, ayrı origin
    bağlantısı). Olası iyileştirmeler: `preconnect`, ya da Bootstrap'i kendi origin'den
    sunmak; düşük öncelikli olarak kullanılmayan Bootstrap CSS (~30 KB) ve küçültülmemiş
    `custom.css` (~3 KB). Hiçbiri uygulanmadı.
  - **`/` → `/en` yönlendirmesi:** Lighthouse mobilde ~930 ms ekliyor, ama bu bilinçli
    mevcut davranış (Faz 69, negotiator her zaman İngilizce'ye yönlendirir) ve
    değiştirilmeyecek. Karşılaştırmada `/en` doğrudan ölçülmeli; `/` sonuçları
    yönlendirmeyi de içerdiği için ayrı tutulmalı.
  - **Reklam sonrası karşılaştırma (aynı URL'ler, aynı cihaz tipleri, aynı araç):**
    PSI mobil/masaüstü Performans, LCP, CLS, TBT, FCP ve Speed Index; yerel Lighthouse
    medyanları; TTFB. Reklamla en çok izlenecekler: CLS (şu an 0; reklam alanına
    yükseklik ayrılmazsa bozulur), TBT (reklam script'leri ana iş parçacığını meşgul eder;
    gerçek INP yalnızca CrUX verisi oluşunca görülebilir) ve LCP. Bkz. Aşama 6, "Reklam
    eklendikten sonra hızı yeniden ölç".

## 8. Aşama 5 — AdSense Başvurusu ve Reklam Yerleşimi

**Ne zaman başvurulmalı:** Aşama 0–3 tamamlanmış, sayfaların çoğu indexlenmiş ve
düzenli (az da olsa) organik trafik gelmeye başlamışken. Resmi bir asgari trafik
şartı yok, ama boş trafikli bir siteyle erken başvuru ret riskini artırır.

- [ ] https://adsense.google.com üzerinden başvur, siteyi ekle.
- [ ] Verilen doğrulama kodunu `<head>`'e ekle (`fragments/layout.html` ya da ortak
  head parçası). Önce Aşama 3'teki onay mesajı önkoşulu kapanmış olmalı. Kodla aynı
  push'ta Gizlilik Politikası güncellenmeli (bkz. Aşama 3, "Reklam kodu eklendiği gün
  politika güncellemesi").
- [ ] `ads.txt`'yi yayınla.
- [ ] İnceleme birkaç günden birkaç haftaya kadar sürebilir. Ret gelirse sebep
  genelde "değeri düşük içerik" ya da "site gezinmesi" olur; e-postadaki sebebi
  giderip yeniden başvurulur.

**Hesap tarafı (başvuruyla birlikte, AdSense panelinde):**

- [ ] Hesap sahibinin yaş şartını karşıladığını ve ödeme alacak kişinin/adresin doğru
  girildiğini doğrula.
- [ ] Vergi bilgisi formunu doldur.
- [ ] Ödeme yöntemini ekle (Türkiye için güncel seçenekler panelde görülür).
- [ ] Kazanç doğrulama eşiğine ulaşınca posta ile gelen adres (PIN) doğrulamasını tamamla;
  PIN girilmeden ödeme yapılmaz.

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

**İzleme ve işletme:**

- [ ] **Uptime izleme kur:** site çökerse ya da bir deployment başlamazsa haber veren
  bir şey yok. Ücretsiz bir uptime servisiyle anasayfa ve bir ders sayfası izlenmeli;
  uzun kesintiler hem indexlemeyi hem AdSense incelemesini etkiler.
- [x] **Deployment sonrası kontrol: `deploy-check` skill'i** (2026-10-06,
  `.claude/skills/deploy-check/`). Railway deployment'ının bitmesini bekler, sonra canlıda
  29 kontrol çalıştırır (sayfalar, yönlendirmeler, sitemap, yapılandırılmış veri,
  sıkıştırma, önbellek, PDF başlığı, erişim kuralı, kayıt formu). İlk gerçek kullanım
  `c8e386b` push'unda: 29/29. Deployment başlamazsa ilk bakılacak yer Railway servis
  ayarlarındaki bağlı branch (2026-10-05'te eski branch adı yüzünden 24 dakika başlamadı).
  Geri alma: Railway panelinden önceki deployment'a dönmek (uygulanmış migration'lar geri
  alınmaz).
- [ ] **Reklam eklendikten sonra hızı yeniden ölç:** reklam kodu sayfayı yavaşlatır;
  PageSpeed Insights ile reklam öncesi ve sonrası karşılaştırılmalı.

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

1. Aşama 0 — teknik düzeltmeler, kod renklendirme ve ders adreslerindeki `<lastmod>` dahil
   (yapıldı ve canlıda; açık madde yok).
2. Aşama 2 — login duvarı kararı (yapıldı ve canlıda).
3. Aşama 1 — Search Console doğrulaması ve sitemap gönderimi (yapıldı); açık kalanlar:
   indexlenmenin izlenmesi, Bing Webmaster Tools, GA4. **← sıradaki adım**
4. Aşama 3 — yasal sayfalar, Hakkında, footer, kayıt onayı, Cloudflare RUM'un kapatılması
   ve çerez onayı altyapısı (yapıldı; çerez onayı kapalı duruyor), Gizlilik Politikası
   Aşama 2 (yapıldı). Açık: çerez onayının GA4 ile birlikte açılması, sertifikalı CMP /
   onay mesajı (AdSense kodundan önce; önkoşul), rızayı geri alma yolu, üçüncü taraf
   sağlayıcı listesi, reklam kodu eklendiği gün politika güncellemesi, Koşullar'da reklam
   atfı kararı, hukuki inceleme.
5. Aşama 4 — başlıklar, kurs sayfaları ve breadcrumb (yapıldı); açıklamalar ve iç
   linkleme açık; trafiği izle.
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
- **2026-10-05** — SEO başlık/açıklama denetimi: eksik alan yok. Başlıklar kısaltıldı
  (şablon eki + 64 başlık, `seo/V1065`); açıklamaların kısaltılması arama verisi
  gelene kadar ertelendi.
- **2026-10-05** — İlk deploy canlıya çıktı (`9003b9b`) ve canlı sitede doğrulandı: ders
  başlıkları, Java dışı derslerin girişsiz açılması, sitemap (343 URL), `https` ile
  dönen giriş yönlendirmesi, sıkıştırma (anasayfa 287 KB → 32 KB), hash'li ve bir yıl
  önbelleklenen statik dosyalar, tek `<h1>`, dört yeni sayfa, HTML 404 sayfası, yeni
  anasayfa description'ı. Deployment 24 dakika gecikti: Railway hâlâ eski branch adını
  izliyordu, `main` olarak düzeltildi. Sıradaki adım Search Console kaydı.
- **2026-10-05** — Plan canlı siteye karşı yeniden gözden geçirildi; eksik bulunan yedi
  madde eklendi: PDF'lerin indexlenmesi (kodda düzeltildi, deploy bekliyor), kayıt
  formunda açık onay, uptime izleme, deployment sonrası kontrol listesi, `BreadcrumbList`,
  AdSense'in hesap tarafındaki adımlar, reklam sonrası hız ölçümü.
- **2026-10-05** — Kayıt formuna zorunlu onay kutusu eklendi (Koşullar + Gizlilik
  Politikası). Kodda tamam, deploy bekliyor.
- **2026-10-06** — Kurs açılış sayfaları, `BreadcrumbList`, kurs/kategori adlarının
  Türkçe/İngilizce gösterimi ve kayıt formundaki onay kutusu tek commit'te eklendi.
- **2026-10-06** — Search Console'daki "Couldn't fetch" durumu incelendi; uç noktada sorun
  yok, sitemap değiştirilmedi (XML olarak ayrıştıran testler eklendi). Kök alan adında
  standart dışı bir CNAME kaydı bulundu ve açık madde olarak eklendi.
- **2026-10-08** — Doküman gerçek durumla eşitlendi (yalnızca doküman; kod ve sitemap
  değişmedi). Search Console: Domain property doğrulandı, sitemap "Success" (son
  okuma 7 Ekim, 357 sayfa), `/tr` dizinde, `/en` için dizine ekleme isteği gönderildi.
  "Deploy bekliyor" notları kaldırıldı (PDF `noindex`, kayıt onayı canlıda);
  `deploy-check` maddesi tamamlandı olarak işaretlendi. Sitenin kapalı olduğu döneme ait
  eski tarama kayıtlarının güncel bir hata olmadığı not edildi.
- **2026-10-08** — www'siz adres yönlendirmesi ve DNS maddeleri kapandı. Alan adı
  Cloudflare DNS'ine taşındı; Cloudflare'daki "Apex to WWW" kuralı `learnforgex.com`'u
  301 ile www'ye yönlendiriyor. Kuralın ilk hâli hedefte `${1}` kullandığı için `https`
  istekleri `/s` adresine gidip 404 veriyordu; `${2}` ile düzeltildi ve canlıda doğrulandı.
  Uygulama kodu değişmedi.
- **2026-10-08** — Hakkında sayfasının gerçek metni yazıldı (EN/TR) ve sayfa indexlemeye
  açıldı; sitemap 357 → 359 URL.
- **2026-10-08** — Gizlilik Politikası'nın Aşama 1 teknik/içerik güncellemesi yapıldı
  (EN/TR): Cloudflare, Railway (ABD) ve Gmail eklendi, veri kategorilerinin kullanım
  amaçları yazıldı. GA4/AdSense öncesi güncelleme (Aşama 2) ve hukuki inceleme açık.
- **2026-10-08** — Kod renklendirme düzeltildi (`aa574da`): Highlight.js artık
  `@highlightjs/cdn-assets@11.9.0` paketinden yükleniyor, Dockerfile dili eklendi; canlıda
  Java ve Dockerfile bloklarıyla doğrulandı.
- **2026-10-08** — Çerez onayı Aşama 1 eklendi (`2efebfa`): altyapı canlıda ama kapalı
  (`app.analytics.consent-enabled=false`); GA4, Tag Manager ve AdSense yok.
- **2026-10-08** — Cloudflare'ın kendiliğinden eklediği RUM beacon'ı, "Disable RUM" adlı
  Configuration Rule ile kapatıldı; canlıda dört sayfada script'in ve `/cdn-cgi/rum`
  isteğinin kalktığı doğrulandı. Çerez onayından bağımsız bir Cloudflare ayarı.
- **2026-10-08** — En sorunlu 30 dersin EN ve TR `seo_description` değeri yeniden yazıldı
  (`V1135`, 60 kayıt; 136–178 karakter). Kalan 27 ders ve ikinci tur adayları açık.
- **2026-10-09** — `seo_description` yeniden yazımının ikinci turu (`V1136`, 24 ders, 48
  kayıt; 122–182 karakter): "bu proje" ifadeleri, ters tırnaklar ve fazla kısa açıklamalar.
  `component-scanning` ve `validation-exception-handling` bilinçli olarak değiştirilmedi.
- **2026-10-11** — Ders sayfalarına yazar ve "Son güncelleme" satırı, JSON-LD'ye `author` /
  `dateModified`, sitemap'te 335 ders adresine `<lastmod>` eklendi
  (`V1137`: `topic_translation.published_at` / `updated_at`, 336 kayıt). `published_at`
  ilk git commit tarihidir, gerçek yayın tarihi değildir; bu yüzden hiçbir yerde
  yayınlanmaz (`datePublished` yok). Yerelde doğrulandı (`mvn test`
  159/159; mobil görünüm 390 ve 320 pikselde kontrol edildi).
- **2026-10-11** — Yukarıdaki değişiklik (`372b214`) canlıya çıktı ve doğrulandı: production'da
  `V1137` uygulandı, `deploy-check` 33/33, canlı sitemap'te 335/335 ders adresinin `<lastmod>`
  değeri onaylanan tarihlerle aynı.
- **2026-10-14** — Gizlilik Politikası'nın Aşama 2 güncellemesi yapıldı (EN/TR): AdSense'in
  zorunlu çerez ve kişiselleştirme açıklamaları, kapatma yolları, Google kaynaklı örnek çerezler,
  ayrı "Analitik" bölümü. Metin mevcut durumu açıkça söylüyor (reklam kodu, reklam ve analitik
  çerezi yok); AEA/BK/İsviçre onayı bir taahhüt olarak yazıldı, mevcut özellik olarak değil.
  `JSESSIONID` kullanımı kodda ve canlıda doğrulandı, politikada temkinli ifadeyle yazıldı.
  Açık kalanlar: sertifikalı CMP (AdSense kodundan önce önkoşul), rızayı geri alma yolu,
  sağlayıcı listesi, reklam kodu eklendiği gün politika güncellemesi, Koşullar kararı, hukuki
  inceleme. GA4 çerez listesi GA4 maddesine taşındı.
- **2026-10-14** — Cloudflare e-posta gizleme salt-okunur incelendi (bkz. Aşama 3, "Cloudflare
  e-posta gizleme"); politikayla çelişki görülmedi, değişiklik yapılmadı. JavaScript kapalıyken
  çalışmayan e-posta bağlantısı bilinen bir sınırlama olarak kaydedildi.
- **2026-10-12** — Ders PDF'i artık üretildiği günü değil, ders çevirisinin `updated_at`
  değerini gösteriyor ("Son güncelleme" / "Last updated"); üretim tarihi satırı kaldırıldı,
  yazar adı eklenmedi (`6bbdd15`). Canlıda doğrulandı: `deploy-check` 33/33, canlıdan
  indirilen TR ve EN PDF'lerde tarih o çevirinin `updated_at` değeriyle aynı.
- **2026-10-15** — Reklam öncesi Core Web Vitals başlangıç ölçümü kaydedildi (bkz. Aşama 4,
  "Core Web Vitals"): PSI mobil 98 / masaüstü 100 (anasayfa ve ders), CLS 0, TBT 0; gerçek
  kullanıcı verisi yok. Yan menülü sayfalardaki yüksek TTFB'nin N+1 ile ilişkisi doğrulanmamış
  bir hipotez olarak not edildi; kodda değişiklik yapılmadı.
