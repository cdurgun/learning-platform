---
name: content-check
description: LearnForgeX ders içeriğini denetler ve YALNIZCA raporlar — bölüm atıfları, {{Dosya.ext}} gömmeleri, Türkçe derste çevrilmemiş başlıklar, markdown render sorunları, migration dosyaları, SEO başlık/açıklama uzunlukları. Bir konu yazıldıktan/değiştirildikten sonra, commit'ten önce ya da "içeriği kontrol et" denildiğinde kullan.
---

# content-check

İçerik sorunlarını bulur ve raporlar. **Hiçbir dosyayı, migration'ı ya da DB satırını
değiştirmez.** Bulguları düzeltmek bu skill'in işi değildir: raporu kullanıcıya sun, neyin
düzeltileceğine kullanıcı karar verir.

## Çalıştırma

```bash
python3 .claude/skills/content-check/check_content.py                  # tüm içerik
python3 .claude/skills/content-check/check_content.py --slug enum      # tek konu (virgülle birden fazla)
python3 .claude/skills/content-check/check_content.py --only atif,seo  # yalnızca bazı kontroller
python3 .claude/skills/content-check/check_content.py --report /yol/rapor.md   # tüm bulgular dosyaya
```

Terminal çıktısı kontrol başına ilk 15 bulguyu gösterir; tamamı için `--all` ya da `--report`.
Raporu proje içine değil, geçici bir dizine yaz. Çıkış kodu, en az bir `HATA` varsa 1'dir.

Yeni yazılmış ya da değiştirilmiş bir konu için `--slug` ile çalıştır: tek konunun çıktısı
kısadır ve tamamı okunabilir. Tüm içerik taramasında önce özet tablosuna bak.

## Veritabanı

Bazı kontroller (SEO alanları, DB başlıkları, `code_example`, quiz soru metinleri) yerel dev
veritabanını salt-okunur okur; varsayılan bağlantı `learning-platform-db` container'ıdır.
Farklı bir bağlantı `CONTENT_CHECK_PSQL` ortam değişkeniyle verilir. Veritabanı yoksa bu
kontroller atlanır ve rapor bunu en üstte söyler; `--no-db` aynı şeyi bilerek yapar.

Yeni migration'lar dev veritabanına ancak uygulama bir kez başlatılınca işlenir. Script, DB
sürümü dosyalardaki son sürümden gerideyse bunu `migration` altında bildirir — o durumda
DB'ye dayanan bulgular eski veriyi yansıtır.

## Önem dereceleri

- **HATA** — kesin sorun: sayfada yanlış sonuç verir ya da açık bir proje kuralını çiğner.
- **OLASI** — sezgisel kontrol; yanlış alarm olabilir. Raporlarken gözle doğrula, doğrulamadan
  "sorun" diye sunma.
- **BİLGİ** — kural ihlali değil.

## Kontroller ve bilinen yanlış alarm kaynakları

- **dosya** — yayındaki çevirinin içerik dosyası var mı; DB'de karşılığı olmayan dosya; tek dilde
  kalan dosya.
- **embed** — her `{{Ad.ext}}` için `examples/{slug}/Ad.ext` var mı (yoksa sayfada "Örnek
  bulunamadı" yazar); hiçbir dilde gömülmeyen örnek dosyası; TR/EN'in farklı örnek gömmesi.
  `code_example` tablosu çalışma anında okunmuyor, bu yüzden tabloyla uyumsuzluklar düşük
  önemdedir.
- **baslik** — Türkçe derste EN ile birebir aynı kalan ve İngilizce bir ifadeye benzeyen başlık.
  Kural: genel kabul görmüş teknik terimler İngilizce kalabilir, çevrilebilir ifadeler Türkçe
  yazılır. Ders adının kendisi bilinçli olarak İngilizce olabilir ("Tools and Function
  Calling") — bunlar yanlış alarmdır. Ayrıca H1 ile DB başlığı farkı (BİLGİ).
- **atif** — tırnak içindeki bölüm/ders atıfları o dildeki bir başlıkla **birebir** eşleşiyor mu.
  "Bölüme atıf gibi ama eşleşmiyor" bulgularının çoğu, başlığın kısaltılarak anılmasıdır
  ("Alanları Okumak" ↔ "Alanları (Fields) Okumak") ve gerçek ihlaldir; bir kısmı ise başlık
  olmayan sıradan bir alıntıdır. Numaralı adım listesindeki eşleşmeyen atıflar HATA değil OLASI
  sayılır: orada tırnaklı "X bölümü" çoğunlukla bir aracın arayüzündeki bölümdür. Yayındaki quiz
  sorularının metni de (tek ve çift tırnaklı atıflar) aynı şekilde taranır.
- **markdown** — tablo (render edilmez), Tip/Warning blockquote'unun çok paragraflı olması ya da
  kod bloğu içermesi (alert'e çevrilmez), kapanmamış kod bloğu.
- **migration** — sürüm numarası çakışması, hatalı dosya adı, dolar-süslü-parantez.
  `application.yml`'de `placeholder-replacement: false` olduğu sürece sonuncusu yalnızca BİLGİ'dir.
- **soru** — yayındaki quiz sorularında şık harfine (A/B/C/D) atıf. Açıklamanın "A ve B..." diye
  başlaması HATA'dır: arayüzde harf yoktur ve harfler gerçek doğru şıkların konumunu bile
  göstermeyebilir. Metnin içinde geçen tek harfler OLASI'dır; çoğu zaman soruda adı geçen bir
  şeydir ("Model A", tip parametresi `A`, `A LEFT JOIN B`).
- **seo** — boş ya da tekrar eden `seo_title`/`seo_description` (HATA); 60 / 160 karakteri aşan
  başlık / açıklama ve "bu proje" ifadesi (OLASI — bunlar arama sonucu için öneridir, eski
  içerik bu sınırlarla yazılmadı).

- **tarih** — henüz push edilmemiş değişiklik setine (`origin/main` ile çalışma dizini arası:
  commit'lenmiş, commit'lenmemiş ve yeni dosyalar) bakar; veritabanı gerekmez. Tarihleri
  HESAPLAMAZ ve DEĞİŞTİRMEZ, git commit tarihlerini okumaz — git'i yalnızca "hangi dosya değişti"
  sorusu için kullanır. Üç bulgu: (1) mevcut bir dersin `content/{dil}/{slug}.md` dosyası ya da
  `examples/{slug}/` altındaki bir dosya değişmiş ama aynı sette o slug için
  `topic_translation.updated_at`'i ilerleten bir migration yok (OLASI); (2) bir migration bir
  çeviriyi yayına alıyor (`SET published = true`) ama `updated_at` yazmıyor ve ders aynı sette
  eklenmemiş (OLASI); (3) bir migration, içeriği bu sette değişmemiş derslerin `updated_at`'ini
  değiştiriyor (BİLGİ, migration başına tek satır). Yanlış alarm kaynakları: yazım hatası ve
  mekanik düzeltmeler tarihi bilerek ilerletmez ama (1) yine uyarır — kural için bkz. `CLAUDE.md`,
  "Mimari". Sınırlar: yalnızca push'tan ÖNCE iş görür (push'tan sonra bulgular kaybolur); slug
  düzeyinde eşleştirir, yanlış DİLİN tarihinin ilerletilmesini yakalamaz; yerel `origin/main`
  güncel değilse değişiklik seti olduğundan büyük görünür. Yeni eklenen dersler atlanır
  (tarihleri `DEFAULT CURRENT_DATE` ile gelir).

## Raporlama

Kullanıcıya şunları özetle: kontrol başına kaç bulgu ve kaç dosya, hangileri kesin, hangileri
doğrulanması gereken, ve önceki çalıştırmaya göre yeni olanlar. Yeni yazılan bir konuda amaç
`HATA` sayısının sıfır olması ve `OLASI` bulguların tek tek gözden geçirilmesidir.
