---
name: deploy-check
description: LearnForgeX canlı sitesini bir push'tan sonra kontrol eder — Railway deployment'ının bitmesini bekler, ardından sayfaları, yönlendirmeleri, sitemap'i, yapılandırılmış veriyi, sıkıştırma/önbellek başlıklarını ve erişim kuralını doğrular. "Push ettim", "canlıyı kontrol et", "deploy oldu mu" denildiğinde ya da kendin push ettikten sonra kullan.
---

# deploy-check

Canlı siteyi kontrol eder; yalnızca okur, hiçbir şeyi değiştirmez.

## Çalıştırma

```bash
python3 .claude/skills/deploy-check/check_deploy.py --wait     # push'tan hemen sonra
python3 .claude/skills/deploy-check/check_deploy.py            # deployment zaten bittiyse
python3 .claude/skills/deploy-check/check_deploy.py --base http://localhost:8099 --no-github
```

`--wait`, `origin/main`'in son commit'i için Railway deployment'ı SUCCESS olana kadar bekler
(varsayılan en fazla 15 dakika). Push'tan sonra arka planda çalıştır; normalde 2–4 dakika sürer,
Wait for CI açık olduğu için CI süresi (~1,5 dk) kadar uzar.

Çıkış kodu: tüm kontroller geçerse 0, bir kontrol başarısızsa 1, deployment tamamlanmazsa 2
(Railway deploy'u atladıysa -- `SKIPPED` -- da 2; script sebebi yazar).

## Deployment nasıl işliyor

- Site Railway'de; `main`'e her push otomatik deployment başlatır. **Wait for CI açık
  (2026-10-20):** deployment, GitHub Actions `tests` workflow'u bitene kadar bekler, CI başarısızsa
  Railway onu atlar (`SKIPPED`) ve eski sürüm yayında kalır.
- **Durumun kaynağı Railway'in kendisi:** script repo kökünden `railway deployment list --json
  --service learning-platform --environment production` okur. Bir kayıt ancak `meta.commitHash`
  push edilen commit ve `meta.repo` bu repo ise sayılır (Postgres servisinin commit'siz SUCCESS
  kayıtları asla eşleşmez); aynı commit'in birden fazla kaydı varsa en yenisi geçerlidir. Canlı
  sürüm yalnızca servisin EN YENİ deployment'ı SUCCESS ve tek SUCCESS kaydıysa kesin sayılır --
  daha yeni bir başarısız/atlanmış/süren deployment ya da geçişte iki SUCCESS varsa "doğrulanamadı".
  Listede olmayan durumlar (`COMPLETED`, `SLEEPING`, yeni bir ad) başarı sayılmaz. Railway CLI
  çalışmazsa, oturum düşmüşse ya da çıktı okunamazsa script başarı varsaymaz.
- GitHub'ın deployment kaydı yalnızca tanılama bilgisi: Railway onu her zaman güncellemiyor
  (2026-10-20, `e8b3d1b`: Railway SUCCESS iken kayıt `in_progress`'te kaldı). Uyuşmazlık
  `[BİLGİ]` olarak yazılır, karar Railway'e göre verilir.
- Uygulama açılırken bekleyen Flyway migration'larını production veritabanına uygular. Yeni
  migration içeren bir push'ta açılış birkaç saniye uzar; migration hata verirse deployment
  başarısız olur ve eski sürüm yayında kalır.

## Deployment başlamazsa ya da başarısız olursa

- **Kayıt hiç oluşmadıysa** Railway push'u görmemiştir. 2026-10-05'te sebep, Railway'in eski
  branch adını izlemesiydi. İlk bakılacak yer: Railway panelinde servis → Settings → Source →
  bağlı branch `main` mi, otomatik deploy açık mı. Gerekirse panelden elle deploy başlatılır.
- **Durum `failure` ise** build/deploy loguna bak: derleme hatası ya da açılışta Flyway hatası.
  Loglar Railway CLI ile okunabilir (`railway logs --build` / `--deployment`, aşağıya bak); CLI
  çalışmıyorsa kullanıcıdan logu iste.
- **Geri alma:** Railway panelinden önceki deployment'a dönülür. Uygulanmış migration'lar geri
  alınmaz; şemayı değiştiren bir push'u geri almadan önce bunu hesaba kat.

Railway'e yalnızca okuma için erişimin var: makinede kurulu, kullanıcının hesabıyla oturum açmış
ve bu projeye bağlı bir `railway` CLI (2026-10-19'da doğrulandı). Yalnızca şu komutları kullan:
`railway status`, `railway deployment list --json`, `railway logs` (`--deployment`, `--build`,
`--lines N`). Değiştiren hiçbir komutu (`up`, `redeploy`, `down`, `link`, `variables --set` ...)
çalıştırma. Deployment'ı elle başlatmak ve geri almak kullanıcının işidir; ne yapılması
gerektiğini söyle.

## Migration'ın production'da uygulandığını doğrulamak

Sayfadaki tarihler gibi dolaylı izler migration'ın çalıştığını göstermez; doğrudan kanıt deploy
logundaki Flyway satırlarıdır. Production veritabanına bağlanma ve migration çalıştırma.

1. `railway deployment list --json`: en üstteki deployment'ın `meta.commitHash`'i push edilen
   commit olmalı ve `status` `SUCCESS` olmalı. Değilse dur.
2. `railway logs --deployment --lines 400 <DEPLOYMENT_ID>` çıktısında `DbMigrate` satırlarını ara.
   Beklenen: `Current version of schema "public": <önceki>`, ardından `Migrating schema "public" to
   version "<N> - <açıklama>"` ve `Successfully applied <k> migration(s) ... now at version v<N>`;
   sonra `Started LearningPlatformApplication`. `<N>` push edilen en yüksek migration olmalı.
3. Raporla: deployment id, commit, durum ve bu satırlar (zaman damgasıyla).

Bu satırlar bulunamazsa, log okunamazsa ya da deployment başka bir commit'e aitse migration'ın
uygulandığını varsayma: "doğrulanamadı" olarak raporla ve kullanıcıdan Railway panelindeki logu
ya da `flyway_schema_history`'yi kontrol etmesini iste. Log, etkilenen satır sayısını göstermez;
satır sayısı için migration testine ve canlı sayfalara dayan.

## Kontroller

Temel sayfalar ve 404, ders sayfası (başlık, tek `<h1>`, canonical, yapılandırılmış veri), erişim
kuralı (Java dışı ders girişsiz açılır ama quiz soruları görünmez; Quiz Area girişe `https` ile
yönlenir), sitemap (adet, kurs sayfaları, rastgele adreslerin açılması), sıkıştırma, hash'li ve
uzun önbellekli statik dosyalar, PDF'in indexlemeye kapalı olması, yanıt süresi, kayıt formundaki
onay kutusu.

"Yazar ve güncellenme tarihi" bölümü (4 kontrol): ders sayfasındaki yazar bağlantısı ve "Last
updated" tarihi, yapılandırılmış verideki `author` ve `dateModified`, sitemap'te `<lastmod>`'un
yalnızca ders adreslerinde bulunması, ve bu üç yerin aynı tarihi göstermesi. Tarihin kendisinin
doğru olup olmadığını ölçmez (o, veritabanındaki `updated_at`'tir); yalnızca tutarlılığa bakar.
`datePublished` bilinçli olarak yayınlanmaz ve aranmaz. Yazar adı script'te sabittir (`AUTHOR`).

"Beklenen Çıktı" bölümü (Faz 178): repodaki her `examples/{slug}/*.out` için o dersin EN ve TR
sayfasında panel sayısı, sırası ve `<samp>` metninin `.out` ile birebir aynılığı (yalnızca tek son
satır sonu düşer), etiketin dili ("Expected Output" / "Beklenen Çıktı"), panelin bir kod bloğunun
hemen ardında ve `<code>` dışında durması; ayrıca `.out`'u olmayan bir derste panel bulunmaması.
Liste repodan okunduğu için yeni bir dalga promote edildiğinde script değişmez. Canlıya bakarken
dosyalar yerel HEAD'den okunur ve **son Railway deployment'ı tam olarak HEAD olmalı ve `success`
olmalı**; değilse (push edilmemiş commit, süren ya da başarısız deployment, okunamayan kayıt) bölüm
çalıştırılmaz ve HATA sayılır -- önce push/deploy'u bitir, ya da `--wait` kullan. `--no-github`
ile yerel bir sunucuda çalışma ağacındaki dosyalar kullanılır.

`learnforgex.com` (www'siz) Cloudflare'daki "Apex to WWW" kuralıyla `www`'ye 301 yönleniyor
(2026-10-08'de doğrulandı; yol ve sorgu parametreleri korunuyor). Yönlendirme uygulamada değil
Cloudflare'da olduğu için bozulursa bakılacak yer Cloudflare'daki Redirect Rules. Script,
yönlendirme kaybolursa bunu hata değil bilgi notu olarak yazar.

## Raporlama

Kullanıcıya hangi commit'in yayında olduğunu, kaç kontrolün geçtiğini ve başarısız olanları söyle.
Bir kontrol başarısızsa önce deployment'ın gerçekten bitip bitmediğine bak: bitmediyse sonuç
önceki sürüme aittir. Siteye yeni bir özellik eklendiğinde bu script'e ona ait bir kontrol ekle.
