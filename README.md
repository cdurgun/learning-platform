# LearnForgeX

Türkçe ve İngilizce içerik sunan, Java odaklı bir öğrenim platformu. Canlı adres:
[learnforgex.com](https://learnforgex.com).

Kaynak kod: [github.com/cdurgun/learning-platform](https://github.com/cdurgun/learning-platform)

```bash
git clone https://github.com/cdurgun/learning-platform.git
```

## Mimari

- **Veritabanı (PostgreSQL):** sadece metadata — kurs/kategori/konu hiyerarşisi, çeviri
  başlıkları/özetleri, SEO alanları, yayın durumu, zorluk seviyesi, sıralama.
- **Markdown dosyaları (`src/main/resources/content/{lang}/{slug}.md`):** derslerin asıl
  içeriği. Tek doğruluk kaynağı budur.
- **Java örnekleri (`src/main/resources/examples/{topic-slug}/*.java`):** gerçek, derlenebilir
  `.java` dosyaları. Markdown içinde `{{DosyaAdi.java}}` yazılarak sayfaya gömülür.
- DB ile dosyalar arasındaki bağlantı **slug convention** ile kurulur, path DB'de saklanmaz:
  `content/{language}/{topic.slug}.md` ve `examples/{topic.slug}/{example_name}.java`.
- **Yayın durumu çeviri seviyesinde:** `Topic`'te `published` yok, `TopicTranslation`'da var —
  bir dilin yayında, diğerinin taslak olması normal bir senaryo (örn. TR hazır, EN'de çalışılıyor).
  Bir konu, istenen dilde henüz yayınlanmamışsa 404 değil, "bu içerik bu dilde henüz mevcut
  değil" şeklinde dostane bir sayfa gösterilir (diğer dile geçiş linkiyle birlikte).

## İçerik render hattı (Markdown → HTML)

`MarkdownService`, bir konunun ham Markdown'ını üç adımda işler:

1. **Preprocess:** `{{ExampleName.java}}` yer tutucularını, `examples/{topic-slug}/` altındaki
   ilgili dosyanın içeriğiyle, fenced code block olarak değiştirir.
2. **Parse + render:** CommonMark ile standart HTML üretir.
3. **Callout post-process:** `> 💡 Tip ...` ve `> ⚠️ Warning ...` kalıbıyla yazılmış
   blockquote'ları Bootstrap alert kutularına çevirir (regex tabanlı, tek paragraflık
   callout'ları destekler — bkz. `MarkdownService` içindeki sınırlama notu).

## Çok dillilik (i18n)

İki ayrı katman var, ikisi de aynı `?lang=tr|en` parametresine bağlı:

- **İçerik:** `TopicTranslation` (başlık/özet/SEO) + `content/{lang}/{slug}.md` (ders gövdesi).
- **Arayüz metinleri (chrome):** `messages.properties` / `messages_tr.properties` /
  `messages_en.properties` + Thymeleaf'in `#{...}` söz dizimi. Locale, `LangParamLocaleResolver`
  ile doğrudan `lang` parametresinden çözülür (cookie/session yok, stateless).

## Gereksinimler

- Java 21+
- Maven 3.9+
- Docker (yerel PostgreSQL için)

## Yerel geliştirme

```bash
docker compose up -d
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

Uygulama http://localhost:8080 adresinde açılır. Flyway, uygulama başlarken şemayı ve
demo (Enum, Record, Reflection, Interface, Abstract Class) verisini otomatik oluşturur/
günceller.

> **Not:** `docker-compose.yml`, host tarafında **5433** portunu kullanır (container'ın
> kendi içi hâlâ 5432). Bunun sebebi, birçok geliştirme makinesinde 5432'de zaten native bir
> PostgreSQL kurulu olması — iki Postgres aynı porta çakışınca hangisine bağlandığın belirsiz
> hâle geliyor. `application-dev.yml` / `application-test.yml` da buna göre 5433'e işaret eder.

## Profiller

| Profil | Amaç |
|---|---|
| `dev`  | Yerel geliştirme, Docker Compose PostgreSQL (host portu 5433) |
| `test` | Test çalıştırmaları |
| `prod` | Üretim, ortam değişkenleriyle yapılandırılır |

## Veritabanı migrasyonları (Flyway)

| Migration | İçerik |
|---|---|
| `V1` | Şema: `course`, `category`, `topic`, `topic_translation`, `code_example` |
| `V2` | Demo veri: Java / Java Basics / Enum konusu (TR yayında, EN taslak) |
| `V3` | Constructor & Fields bölümleri için örnek metadata'sı (Planet) |
| `V4` | Kalan bölümler için örnek metadata'sı (Methods, Interface, Abstract Method, EnumSet, EnumMap, Singleton, Strategy Pattern, Real World) |
| `V5` | `estimated_minutes` güncellemesi (içerik tamamlandığı için 15 → 35) |
| `V6` | İngilizce Enum çevirisini yayına alır (`published = true`) |
| `V7` | `category.sort_order` eklenir (Prev/Next Topic navigasyonu kategori sınırlarını doğru sırayla geçebilsin diye) |
| `V8` | Record konusunun iskeleti: `slug='records'`, TR yayında / EN taslak (yalnızca 1. bölüm) |
| `V9` | Record 2. bölüm ("İlk Record'unu Yazmak") için örnek metadata'sı (Point, PointUsage) |
| `V10` | Record 3-11. bölümler için örnek metadata'sı (Record vs Class, Bileşenler, Üretilen Üyeler, Immutability, Constructors, Özel Metotlar, Static Üyeler, Arayüz İmplementasyonu, Nested Records) |
| `V11` | `estimated_minutes` ara güncellemesi (Record, içerik yarıya ulaştığı için 5 → 20) |
| `V12` | Record 12-17. bölümler + 2 ek bölüm için örnek metadata'sı (Serialization & Reflection, Best Practices, Yaygın Hatalar, Gerçek Dünya Örnekleri, Mülakat Soruları, Özet, Record vs Lombok, Record Patterns) |
| `V13` | `estimated_minutes` son güncellemesi (Record içeriği tamamlandığı için 20 → 45) |
| `V14` | İngilizce Record çevirisini yayına alır (`published = true`) |
| `V15` | Reflection konusunun iskeleti: `slug='reflection'`, `ADVANCED`, java-basics kategorisi, TR yayında / EN taslak (yalnızca 1. bölüm) |
| `V16` | Reflection 3-10. bölümler için örnek metadata'sı (Class Nesnesi Elde Etmek, Sınıf Bilgisini İnceleme, Alan/Metot/Constructor Okuma, Dinamik Oluşturma/Çağırma, Private Erişim) |
| `V17` | `estimated_minutes` ara güncellemesi (Reflection, içerik yarıya ulaştığı için 5 → 20) |
| `V18` | Reflection 11-17. bölümler + 2 mini proje eki için örnek metadata'sı (Annotation'lar, Gerçek Dünya Kullanım Alanları, Performans, Güvenlik, Best Practices, Yaygın Hatalar, Özet, DI Container, Object Inspector) |
| `V19` | `estimated_minutes` son güncellemesi (Reflection içeriği tamamlandığı için 20 → 50) |
| `V20` | İngilizce Reflection çevirisini yayına alır (`published = true`) |
| `V21` | Interface konusunun iskeleti: `slug='interface'`, `INTERMEDIATE`, java-basics kategorisi, TR yayında / EN taslak (yalnızca iskelet) |
| `V22` | Interface 1-8. bölümler için örnek metadata'sı (İlk Interface, Soyut Metotlar, Constant Alanlar, Implement Etmek, Çoklu Implement, Interface Genişletme, Default/Static Metotlar) |
| `V23` | `estimated_minutes` ara güncellemesi (Interface, içerik yarıya ulaştığı için 5 → 20) |
| `V24` | Interface 9-20. bölümler + 2 mini proje eki için örnek metadata'sı (Private Metotlar, Diamond Problem, Functional Interface, Sealed Interface, Gerçek Dünya, Best Practices, Yaygın Hatalar, Özet, Plugin Registry, Event Bus) |
| `V25` | `estimated_minutes` son güncellemesi (Interface içeriği tamamlandığı için 20 → 50) |
| `V26` | İngilizce Interface çevirisini yayına alır (`published = true`) |
| `V27` | Abstract Class konusunun iskeleti: `slug='abstract-class'`, `INTERMEDIATE`, java-basics kategorisi, TR yayında / EN taslak (yalnızca iskelet) |
| `V28` | Abstract Class 1-8. bölümler için örnek metadata'sı (İlk Abstract Class, Abstract vs Concrete Class, Abstract Metotlar, Concrete Metotlar, Alanlar, Constructor'lar, Override/Polimorfizm, Modifier Kuralları) |
| `V29` | `estimated_minutes` ara güncellemesi (Abstract Class, içerik yarıya ulaştığı için 5 → 20) |
| `V30` | Abstract Class 9-19. bölümler + 2 mini proje eki için örnek metadata'sı (Interface Implement Etmesi, Template Method Pattern, Gerçek Dünya Örnekleri, Rapor Pipeline'ı, Ödeme İşleyici) |
| `V31` | `estimated_minutes` son güncellemesi (Abstract Class içeriği tamamlandığı için 20 → 50) |
| `V32` | İngilizce Abstract Class çevirisini yayına alır (`published = true`) |

## Proje yapısı

```
src/main/java/com/cdurgun/learning/
    domain/          Course, Category, Topic, TopicTranslation, CodeExample, Language, Difficulty
    domain/converter/ Language <-> DB (tr/en kodu) dönüştürücüsü
    repository/      Spring Data JPA repository'leri
    service/         ContentResolver, CodeExampleResolver, MarkdownService, NavigationService
    controller/      HomeController, TopicController
    config/          LangParamLocaleResolver, WebConfig
    web/nav/         Sidebar/anasayfa navigasyon DTO'ları (CourseNav)

src/main/resources/
    content/{tr,en}/{slug}.md     Ders içerikleri (tek doğruluk kaynağı)
    examples/{slug}/*.java        Gerçek, derlenebilir kod örnekleri
    db/migration/                 Flyway migration'ları
    templates/                    Thymeleaf şablonları (Bootstrap + highlight.js)
    messages*.properties          Arayüz metni çevirileri
```

## Yol haritası

- **Faz 1 — Foundation:** ✅ Proje iskeleti, Postgres/Flyway, Thymeleaf/Bootstrap layout,
  Markdown → HTML hattı, kod örneği gömme, highlight.js.
- **Faz 2 — Java Content (Enum):** ✅ Enum konusunun tamamı (~19 bölüm), TR ve EN, ilgili
  kod örnekleriyle birlikte; arayüz metinleri için tam i18n.
- **Faz 3 — Navigasyon:** ✅ Breadcrumb, prev/next topic navigasyonu, sidebar'da aktif konu
  vurgusu, `category.sort_order`, anasayfa kartlarında zorluk/süre rozeti.
- **Faz 4 — TOC:** ✅ Sağda "Bu sayfada" içindekiler sütunu (lg+ ekranlarda, sticky),
  CommonMark heading-anchor extension'ından türetiliyor.
- **Faz 5 — Java Content (Record):** ✅ Record konusunun tamamı (17 ana + 2 ek bölüm), TR
  ve EN, 21 kod örneğiyle birlikte — Record vs Class, Immutability, Constructors,
  Serialization & Reflection, Spring Boot DTO örnekleri, Record vs Lombok, Record Patterns
  (Java 21) dahil.
- **Faz 6 — Java Content (Reflection):** ✅ Reflection konusunun tamamı (17 ana + 2 mini
  proje eki), TR ve EN, 15 kod örneğiyle birlikte — Class nesnesi elde etme, alan/metot/
  constructor introspection'ı, dinamik oluşturma/çağırma, private erişim, annotation'lar,
  MethodHandle/VarHandle performans karşılaştırması, JPMS güvenlik kısıtlamaları, DI
  Container ve Object Inspector mini projeleri dahil.
- **Faz 7 — Java Content (Interface):** ✅ Interface konusunun tamamı (20 ana + 2 mini
  proje eki), TR ve EN, 17 kod örneğiyle birlikte — soyut metotlar, interface sabitleri,
  çoklu implement/genişletme, Java 8 default/static metotlar, Java 9 private metotlar,
  diamond problem, Interface vs Abstract Class, functional interface & lambda, Java 17
  sealed interface, Comparable/Runnable/koleksiyon hiyerarşisi gerçek dünya örnekleri,
  Plugin Registry ve Event Bus mini projeleri dahil.
- **Faz 8 — Java Content (Abstract Class):** ✅ Abstract Class konusunun tamamı (19 ana
  + 2 mini proje eki), TR ve EN, 15 kod örneğiyle birlikte — soyut/concrete metotlar,
  instance alanları, constructor'ın rolü, çok seviyeli abstract hiyerarşiler, override/
  polimorfizm, modifier kuralları, abstract class'ın interface implement etmesi, Abstract
  Class vs Interface karşılaştırması, Template Method Pattern, `AbstractList` gerçek
  dünya örneği, Rapor Pipeline'ı ve Ödeme İşleyici mini projeleri dahil.
- **Faz 9 (öneri):** Testcontainers ile test altyapısı, markdown→HTML cache (Caffeine),
  yeni konular (Generics, Streams...), CI'da örnek `.java` dosyalarının otomatik derleme
  kontrolü.
