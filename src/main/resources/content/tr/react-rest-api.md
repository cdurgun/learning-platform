# React + REST API

Fetching Data dersinde `fetch`'in GET/POST/PUT/DELETE'ini tek tek
gördük. Bu ders, bunları bir araya getirip GERÇEK bir uygulamada
kurslar listesi gibi bir kaynağı uçtan uca (listeleme, ekleme, silme)
yönetmeyi anlatıyor -- ayrıca React'in bir backend'le nasıl konuştuğunu
büyük resmiyle gösteriyor.

## React → HTTP → Backend → Veritabanı

Bir React uygulaması, verisini genellikle kendi başına saklamaz --
`fetch` ile bir **backend'e** (bu projenin kendisi gibi bir Spring Boot
uygulaması olabilir) HTTP isteği atar. Örneğin bir kurs listesi
istendiğinde: React `fetch("/courses")` çağırır → istek HTTP üzerinden
backend'e ulaşır → backend'in bir `@RestController`'ı (bu terimi Java
kursundaki REST API Tasarımı dersinden hatırlayabilirsin) isteği
karşılar → veriyi veritabanından (PostgreSQL) okur → JSON olarak geri
döner → React bu JSON'ı state'e yazıp ekranı günceller. Bu derste
gerçek bir Spring Boot backend'i kurmuyoruz -- onun yerine aynı REST
kurallarına (GET/POST/DELETE, JSON, HTTP durum kodları) uyan basit bir
sahte sunucu (**json-server**) kullanıyoruz; React tarafındaki kod,
gerçek bir Spring Boot API'sine bağlanırken de birebir aynı olurdu.

## API Katmanını Ayırmak: Bir api.js Modülü

Her component'in içine `fetch` çağrıları dağıtmak yerine, bunları TEK
bir yerde toplamak yaygın bir pratiktir:

{{ApiModuleExample.jsx}}

`getCourses()`, `createCourse()`, `deleteCourse()` gibi fonksiyonlar,
`fetch`'in ayrıntılarını (URL, `method`, `headers`) SAKLAR --
component'ler yalnızca bu fonksiyonları çağırır, `fetch`'in kendisiyle
hiç uğraşmaz. `BASE_URL`'i tek bir yerde tanımlamak, backend adresi
değiştiğinde (örneğin geliştirmeden production'a geçerken) tek bir
satırı değiştirmeyi yeterli kılar.

## Backend'den Kurs Listesini Çekmek

`useEffect` içinde `async`/`await` ile veri çekmek, `.then()` zincirine
göre daha okunaklı bir alternatif:

{{FetchCoursesExample.jsx}}

`useEffect`'in callback'i doğrudan `async` OLAMAZ (React bunu
desteklemiyor) -- bu yüzden içeride ayrı bir `async` fonksiyon
tanımlayıp hemen çağırıyoruz. `await`, `fetch`'in ve `response.json()`'ın
Promise'lerinin tamamlanmasını BEKLER; sonuç geldiğinde `setCourses` ile
state güncellenir.

## Yeni Bir Kurs Oluşturmak

Forms dersindeki controlled input + `onSubmit` deseni, bir POST isteğiyle
birleşiyor:

{{CreateCourseFormExample.jsx}}

Form gönderildiğinde, girilen değer POST isteğiyle backend'e gönderilir;
backend yeni kaydı oluşturup (genellikle kendi ürettiği bir `id` ile)
geri döner. `onCreated(newCourse)`, bu yeni kaydı ÜST component'e
bildirmek için kullanılan bir callback prop -- Props dersindeki "veriyi
yukarı iletmek" deseni.

## Bir Kursu Silmek

Bir kaydı sunucudan sildikten sonra, ekrandaki listeyi de güncellememiz
gerekir:

{{DeleteCourseExample.jsx}}

DELETE isteği başarılı olduktan SONRA, State dersindeki immutability
kuralına uyarak `filter()` ile silinen kaydı çıkarıp YENİ bir dizi
oluşturuyoruz -- diziyi doğrudan değiştirmiyoruz (`splice` gibi).

## Oluşturduktan Sonra Ekranı Güncellemek

Yeni bir kayıt oluşturduktan sonra, listeyi baştan tekrar çekmek yerine
(bir istek daha atmak yerine) genellikle yeni kaydı doğrudan mevcut
listeye eklemek tercih edilir:

{{RefreshAfterMutationExample.jsx}}

`setCourses([...courses, newCourse])`, State dersindeki spread deseniyle
eski listeyi kopyalayıp sonuna yeni kaydı ekliyor -- ekran, sunucuya
ikinci bir istek atmadan ANINDA güncelleniyor.

## Özet ve Terimler Sözlüğü

Bir React uygulaması, `fetch` ile bir backend'e (Spring Boot gibi) HTTP
istekleri atarak veri okur ve yazar; `fetch` çağrılarını ayrı bir
`api.js` modülünde toplamak yaygın bir pratiktir. Veri çekme genellikle
`useEffect` içinde `async`/`await` ile yapılır. Bir kayıt oluşturulduğunda
ya da silindiğinde, ekrandaki listeyi State dersindeki immutability
kurallarına (`filter()`, spread) uyarak güncellemek gerekir -- bazen
sunucuya ikinci bir istek atmak yerine, elimizdeki sonucu doğrudan
state'e yansıtmak yeterlidir.

**Terimler Sözlüğü**

**REST API** — Kaynakları (örneğin kurslar) HTTP metodlarıyla
(GET/POST/PUT/DELETE) yöneten bir backend arayüzü tasarım biçimi.

**api.js Modülü** — Bir uygulamadaki tüm `fetch` çağrılarını tek bir
yerde toplayan, component'lerin doğrudan kullandığı yardımcı fonksiyon
dosyası.

## Pratik Proje

Bu kategoride (Fetching Data, React + REST API) öğrendiğimiz kavramları
bir arada kullanan, gerçek ve çalıştırılabilir bir örnek proje var:
**[API & Data Fetching Demo](https://github.com/cdurgun/react-course-projects/tree/main/projects/api-data-fetching)**
-- json-server ile çalışan sahte bir REST API'ye bağlanan bir kurs
listesi uygulaması.

Proje; `useEffect` + `fetch` ile listeleme, `loading`/`error` state
yönetimi, controlled form ile yeni kayıt oluşturma (POST), bir kaydı
silme (DELETE), ve her mutasyondan sonra ekranı immutability kurallarına
uyarak güncellemeyi bir arada gösteriyor. Bilgisayarına indirip
çalıştırabilir, kodunu satır satır inceleyebilirsin:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/api-data-fetching
npm run server
```

Sahte API'yi (json-server) ayrı bir terminalde çalıştırdıktan sonra,
başka bir terminalde React uygulamasını başlat:

```bash
cd react-course-projects/projects/api-data-fetching
npm run dev
```

`react-course-projects` deposu **npm workspaces** kullanır -- `npm install`
yalnızca bir kez, depo kökünde çalıştırılır ve tüm proje klasörleri ortak
bağımlılıkları paylaşır (her klasörde ayrı bir `node_modules` oluşmaz). Kök
dizinde `npm install`'ı daha önce çalıştırdıysan, doğrudan
`cd react-course-projects/projects/api-data-fetching` yapıp yukarıdaki iki
komutu (`npm run server`, `npm run dev`) iki ayrı terminalde çalıştırman
yeterli.
