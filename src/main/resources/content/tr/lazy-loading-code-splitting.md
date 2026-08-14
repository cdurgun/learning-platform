# Lazy Loading & Code Splitting

Şimdiye kadar yazdığımız tüm component'ler, uygulamanın İLK yüklenen
JavaScript paketine (bundle) dahildi. Uygulama büyüdükçe bu paket de
büyür -- kullanıcı, belki hiç ziyaret etmeyeceği sayfaların kodunu bile
indirmek zorunda kalır. Bu ders, bunu önlemenin yolunu anlatıyor.

## React.lazy ile Bir Component'i Sonradan Yüklemek

`lazy()`, bir component'in kodunu normal bir `import` yerine, ihtiyaç
duyulduğunda indirilen AYRI bir dosya haline getirir:

{{ReactLazyBasicExample.jsx}}

`lazy(() => import("./CourseDetails.jsx"))`, `CourseDetails`'in kodunu
uygulamanın ilk paketinden ÇIKARIR -- yalnızca `showDetails` `true`
olduğunda indirilir. `Suspense`, bu indirme sırasında bir `fallback`
göstermek için gereklidir (bir sonraki derste Suspense'e daha yakından
bakacağız).

## Route Bazlı Code Splitting

`lazy()`'nin en yaygın kullanımı, Routing dersindeki sayfaları ayrı
paketlere bölmek:

{{RouteBasedCodeSplittingExample.jsx}}

Her sayfa (`CoursesPage`, `AboutPage`) kendi ayrı dosyası -- kullanıcı
`/about`'a hiç gitmezse, o sayfanın kodu hiç indirilmez. Bu desene
**code splitting** (kod bölme) denir: uygulamanın tek bir dev
paket yerine, birden fazla küçük parçaya bölünmesi.

## Named Export'larla lazy Kullanmak

`lazy()`, `import()`'un bir DEFAULT export döndürmesini bekler --
named export'lu bir component için küçük bir uyarlama gerekir:

{{NamedExportLazyExample.jsx}}

`.then((module) => ({ default: module.CourseChart }))`, named export'u
(`CourseChart`) `lazy`'nin beklediği `{ default: ... }` şekline
DÖNÜŞTÜRÜYOR.

## Koşullu Lazy Loading

`lazy()`, yalnızca sayfalar için değil, nadiren kullanılan HERHANGİ bir
component için faydalı:

{{ConditionalLazyLoadExample.jsx}}

`EmojiPicker`'ın kodu, kullanıcı `showPicker`'ı İLK KEZ `true` yapana
kadar hiç indirilmez -- kullanıcıların çoğu belki hiç kullanmaz, o
zaman kodunu hiç indirmemiş oluruz.

## Özet ve Terimler Sözlüğü

`lazy()`, bir component'in kodunu ayrı bir dosyaya (chunk) bölüp,
yalnızca gerçekten gerektiğinde indirir -- bu, uygulamanın ilk yüklenen
JavaScript miktarını AZALTIR. En yaygın kullanımı, sayfaları (route'lar)
ya da nadiren kullanılan component'leri (modal'lar, emoji picker'lar
gibi) bölmek. `lazy()` her zaman bir `Suspense` ile birlikte kullanılır
-- kod indirilirken gösterilecek bir fallback gerekir.

**Terimler Sözlüğü**

**Code Splitting (Kod Bölme)** — Bir uygulamanın JavaScript'ini tek bir
büyük paket yerine, ihtiyaç duyuldukça indirilen küçük parçalara bölme
tekniği.

**Bundle (Paket)** — Bir uygulamanın, tarayıcıya gönderilmek üzere
birleştirilmiş JavaScript dosyası.

**Chunk (Parça)** — Code splitting sonucu oluşan, ayrı ayrı
indirilebilen küçük bir JavaScript dosyası.
