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

`--wait`, `origin/main`'in son commit'i için deployment "success" olana kadar bekler (varsayılan
en fazla 15 dakika). Push'tan sonra arka planda çalıştır; normalde 2–4 dakika sürer.

Çıkış kodu: tüm kontroller geçerse 0, bir kontrol başarısızsa 1, deployment tamamlanmazsa 2.

## Deployment nasıl işliyor

- Site Railway'de; `main`'e her push otomatik deployment başlatır. Railway durumu GitHub'ın
  deployment kayıtlarına yazar (`in_progress` → `success`); script bunu `gh` ile okur.
- Uygulama açılırken bekleyen Flyway migration'larını production veritabanına uygular. Yeni
  migration içeren bir push'ta açılış birkaç saniye uzar; migration hata verirse deployment
  başarısız olur ve eski sürüm yayında kalır.

## Deployment başlamazsa ya da başarısız olursa

- **Kayıt hiç oluşmadıysa** Railway push'u görmemiştir. 2026-10-05'te sebep, Railway'in eski
  branch adını izlemesiydi. İlk bakılacak yer: Railway panelinde servis → Settings → Source →
  bağlı branch `main` mi, otomatik deploy açık mı. Gerekirse panelden elle deploy başlatılır.
- **Durum `failure` ise** Railway panelindeki build/deploy loguna bak: derleme hatası ya da
  açılışta Flyway hatası. Bunları buradan göremezsin; kullanıcıdan logu iste.
- **Geri alma:** Railway panelinden önceki deployment'a dönülür. Uygulanmış migration'lar geri
  alınmaz; şemayı değiştiren bir push'u geri almadan önce bunu hesaba kat.

Railway paneline erişimin yok. Deployment'ı elle başlatmak, logları okumak ve geri almak
kullanıcının yapacağı işlerdir; ne yapılması gerektiğini söyle.

## Kontroller

Temel sayfalar ve 404, ders sayfası (başlık, tek `<h1>`, canonical, yapılandırılmış veri), erişim
kuralı (Java dışı ders girişsiz açılır ama quiz soruları görünmez; Quiz Area girişe `https` ile
yönlenir), sitemap (adet, kurs sayfaları, rastgele adreslerin açılması), sıkıştırma, hash'li ve
uzun önbellekli statik dosyalar, PDF'in indexlemeye kapalı olması, yanıt süresi, kayıt formundaki
onay kutusu.

Bilinen açık madde: `learnforgex.com` (www'siz) `www`'ye kalıcı yönlenmiyor; script bunu hata
değil bilgi notu olarak yazar.

## Raporlama

Kullanıcıya hangi commit'in yayında olduğunu, kaç kontrolün geçtiğini ve başarısız olanları söyle.
Bir kontrol başarısızsa önce deployment'ın gerçekten bitip bitmediğine bak: bitmediyse sonuç
önceki sürüme aittir. Siteye yeni bir özellik eklendiğinde bu script'e ona ait bir kontrol ekle.
