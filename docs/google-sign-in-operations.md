# Google ile giriş: işletim notları

Bu dosya **güvenlik/mimari kuralı değildir**; Google girişini açma/yeniden kurma sırasında izlenecek işletim adımlarıdır.
Kuralların gerekçesi: `docs/architecture-rationale.md` §6. Tarihli doğrulamalar ve deployment kimlikleri: `docs/phase-log.md` Faz 185.

## Etkinleştirme / yeniden kurulum

Kaynak: CLAUDE.md'deki 2026-10-24 "açmak için" tarifi (phase-log'da bulunmayan kısım: izin ekranı yayın durumu).

1. Google Console'da production OAuth istemcisi. Yetkili redirect URI **birebir**: `https://www.learnforgex.com/login/oauth2/code/google`
   (kodda `app.base-url` + `/login/oauth2/code/google`; uyuşmazlık Google tarafında reddedilir).
2. OAuth **izin ekranının yayın durumu kontrol edilir.** *(Nedeni kaynakta yazılı değil; çıkarım: yayınlanmamış/test modundaki bir ekran
   yalnızca tanımlı test kullanıcılarına izin verir. Doğrulanmadı.)*
3. `GOOGLE_CLIENT_ID` ve `GOOGLE_CLIENT_SECRET` Railway'e **birlikte** eklenir. Yalnızca client-id verilirse `GoogleSignInConfig` uygulamayı
   bilerek başlatmaz (`Assert.hasText`); ikisi de yoksa Google girişi tamamen kapalıdır (buton görünmez, şifreyle giriş çalışır).
4. Yeniden deploy.
5. Canlıda denenir: yeni hesap (Kullanım Koşulları kutusuyla), mevcut hesabı bağlama (şifre isteyen akış), ADMIN hesabının reddi.
   ADMIN reddinde login sayfasında `google_link_unavailable` mesajı çıkar ve deploy logunda `google_admin_not_allowed` görünür.

## Gözlem notları

- Prod session çerezi `Secure; HttpOnly; SameSite=Lax` olmalı. `Strict` Google dönüşünü kırar (bkz. rationale §6).
- Google girişi kapalıyken `/oauth2/authorization/google` 404 döner, `/en/login/google` login'e yönlenir.
