# Route Parameters & Navigation

React Router Basics dersinde sabit URL'lerle (`/courses`, `/about`)
çalıştık. Bu ders, URL'in İÇİNE değişken bir değer koymayı (`/courses/java`
gibi) ve bir link'e tıklamadan, kod içinden sayfa değiştirmeyi anlatıyor.

## Route Parametreleri: URL'den Veri Okumak

`/courses/java` ve `/courses/react` gibi URL'ler için ayrı ayrı `Route`
yazmak yerine, URL'in bir kısmını DEĞİŞKEN olarak tanımlayabiliriz:

{{RouteParamExample.jsx}}

`path="/courses/:courseSlug"` yazdığımızda, `:courseSlug` kısmı bir
**route parametresi** olur -- `/courses/java` URL'inde `courseSlug`
`"java"` değerini alır. Component içinde bu değeri `useParams()` hook'u
ile okuyoruz; dönen nesnenin anahtarı, Route'taki isimle (`courseSlug`)
aynı.

## İç İçe (Nested) Route'lar ve Outlet

Bazen bir sayfanın İÇİNDE, URL'e göre değişen ALT bir bölüm olur --
örneğin bir kurs sayfasının içinde, seçilen konuya göre değişen bir
içerik alanı:

{{NestedRouteExample.jsx}}

Bir `Route`'u başka bir `Route`'un İÇİNE yazarak (`:topicSlug`,
`:courseSlug` route'unun içinde) iç içe (nested) bir yapı kurarız. Üst
component'in (`CourseLayout`) içine koyduğumuz `<Outlet />`, eşleşen alt
route'un TAM OLARAK nereye render edileceğini belirtir -- `Outlet`
olmadan alt route hiçbir yerde görünmez.

## useNavigate ile Programatik Yönlendirme

`Link`, kullanıcının TIKLAMASINI gerektirir. Bazen bir işlemin
SONUCUNDA (bir butona tıklayınca, bir hesaplama bitince) kod içinden
sayfa değiştirmek isteriz:

{{UseNavigateExample.jsx}}

`useNavigate()` hook'u bize bir `navigate` fonksiyonu verir; bu
fonksiyonu bir event handler İÇİNDEN çağırarak URL'i değiştirebiliriz --
`Link`'in aksine, bu bir tıklamaya değil, kod içindeki bir KOŞULA
bağlıdır.

## Bir İşlemden Sonra Yönlendirmek

`useNavigate`'in en yaygın kullanımlarından biri, bir form gönderildikten
sonra kullanıcıyı başka bir sayfaya yönlendirmek:

{{NavigateAfterActionExample.jsx}}

Form Handling dersinde gördüğümüz `onSubmit` + `preventDefault` deseni
burada da aynı -- tek fark, form "gönderildikten" (bu örnekte gerçek bir
kayıt işlemi olmadığı için doğrudan) sonra `navigate("/courses")` ile
kullanıcıyı kurs listesine yönlendiriyoruz.

## Geri Gitmek: navigate(-1)

`navigate`'e bir URL yerine bir SAYI da verilebilir -- bu, tarayıcı
geçmişinde ileri/geri gitmek için kullanılır:

{{GoBackNavigateExample.jsx}}

`navigate(-1)`, tarayıcının "geri" butonuyla aynı işi yapar: history'de
bir adım geriye gider. Bu, kullanıcıyı belirli bir sayfaya (`/courses`
gibi) sabitlemek yerine, "neredeyse geldiyse oraya" dönmesini sağladığı
için genellikle "Back" butonlarında tercih edilir.

## Özet ve Terimler Sözlüğü

Bir URL'in bir kısmını `:isim` ile tanımlayarak route parametresi
oluşturabilir, değerini `useParams()` ile okuyabiliriz. Bir `Route`'u
başka bir `Route`'un içine yazıp üst component'e `<Outlet />` ekleyerek
iç içe (nested) route'lar kurabiliriz. `useNavigate()`, bir event
handler içinden ya da bir işlemin sonucunda, tıklamaya gerek kalmadan
sayfa değiştirmemizi sağlar; `navigate(-1)` ise tarayıcı geçmişinde
geriye gitmek için kullanılır.

**Terimler Sözlüğü**

**Route Parametresi** — Bir URL kalıbında `:isim` ile tanımlanan,
gerçek URL'de değişken bir değer alan kısım.

**Nested Route (İç İçe Route)** — Başka bir Route'un içine yazılan,
yalnızca üst Route eşleştiğinde ve `<Outlet />` konumunda render edilen
Route.

**Outlet** — Üst (parent) route component'inin içinde, eşleşen alt
(child) route'un render edileceği yeri belirten component.

**Programatik Navigasyon** — Bir link'e tıklamak yerine, kod içinden
(örneğin bir event handler'dan) `useNavigate()` ile sayfa değiştirmek.

## Pratik Proje

Bu kategoride (React Router Basics, Route Parameters & Navigation)
öğrendiğimiz kavramları bir arada kullanan, gerçek ve çalıştırılabilir
bir örnek proje var:
**[Routing Demo](https://github.com/cdurgun/react-course-projects/tree/main/projects/routing)**
-- öğrenme platformunun kendi kurs yapısına benzeyen küçük bir kurs
gezinme uygulaması (`/courses`, `/courses/java`, `/courses/java/enum`
gibi).

Proje; `BrowserRouter` + `Routes` + `Route` ile sayfa tanımlamayı,
`Link`/`NavLink` ile gezinmeyi, route parametreleriyle (`useParams`)
URL'den veri okumayı, `Outlet` ile iç içe route'ları ve `useNavigate`
ile programatik yönlendirmeyi bir arada gösteriyor. Bilgisayarına
indirip çalıştırabilir, kodunu satır satır inceleyebilirsin:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/routing
npm run dev
```

`react-course-projects` deposu **npm workspaces** kullanır -- `npm install`
yalnızca bir kez, depo kökünde çalıştırılır ve tüm proje klasörleri ortak
bağımlılıkları paylaşır (her klasörde ayrı bir `node_modules` oluşmaz). Kök
dizinde `npm install`'ı daha önce çalıştırdıysan, doğrudan
`cd react-course-projects/projects/routing` yapıp `npm run dev` demen
yeterli.
