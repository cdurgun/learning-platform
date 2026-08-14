# Fetching Data

Şimdiye kadarki tüm örneklerde veri, component'in İÇİNDE (bir dizi ya da
nesne olarak) tanımlıydı. Gerçek uygulamalarda ise veri genellikle bir
**sunucudan** gelir. Bu ders, React'te bir sunucudan veri çekmenin (ve
oraya veri göndermenin) temel yolunu -- `fetch` fonksiyonunu -- anlatıyor.

## fetch ile Veri Çekmek: GET

`fetch`, tarayıcının yerleşik bir fonksiyonudur -- bir URL'e HTTP isteği
atar ve bir **Promise** döner. Hooks dersinde gördüğümüz `useEffect`,
component ekrana geldiğinde bu isteği atmak için kullanılır:

{{BasicFetchGetExample.jsx}}

`useEffect`'in ikinci argümanı boş bir dizi (`[]`) olduğu için, bu istek
yalnızca component İLK RENDER edildiğinde bir kez atılır.
`fetch(url).then(...)`, önce yanıtı JSON'a çevirir, sonra gelen veriyi
`setCourses` ile state'e yazar -- state değişince React yeniden render
eder ve liste ekranda görünür.

## Loading Durumu Göstermek

İstek atıldıktan sonra yanıt gelene kadar bir süre geçer -- bu sürede
kullanıcıya boş bir ekran yerine bir şeyler olduğunu göstermek gerekir:

{{LoadingStateExample.jsx}}

`loading` state'i başlangıçta `true`; veri geldiğinde `false`'a
çekiyoruz. `loading` `true`iken component `<p>Loading...</p>` render
edip ERKEN ÇIKIYOR (`return`) -- geri kalan JSX hiç render edilmiyor.

## Hataları Yönetmek

Bir istek her zaman başarılı olmayabilir -- ağ kopabilir, sunucu hata
dönebilir. Bunu yönetmezsek, kullanıcı sessizce boş bir ekranla kalır:

{{ErrorHandlingExample.jsx}}

`response.ok`, HTTP durum kodunun 200-299 aralığında olup olmadığını
söyler -- `fetch`, 404 ya da 500 gibi durumlarda KENDİLİĞİNDEN
reddetmediği (reject) için bunu elle kontrol edip `throw` etmemiz
gerekir. `.catch()`, bu hatayı yakalayıp `error` state'ine yazar;
`.finally()` ise başarılı ya da başarısız fark etmeksizin `loading`'i
kapatır.

## Veri Göndermek: POST

Veri okumanın (GET) yanında, yeni bir kayıt oluşturmak için POST
isteği atılır:

{{PostRequestExample.jsx}}

POST isteğinde `fetch`'e ikinci bir argüman -- bir seçenekler nesnesi --
veririz: `method: "POST"`, `headers` ile sunucuya gönderdiğimiz verinin
JSON olduğunu bildiriyoruz, `body`'ye de göndereceğimiz veriyi
`JSON.stringify(...)` ile bir metne çevirip koyuyoruz.

## Güncellemek ve Silmek: PUT ve DELETE

Var olan bir kaydı güncellemek için PUT, silmek için DELETE kullanılır:

{{PutAndDeleteExample.jsx}}

PUT, POST'a benzer şekilde bir `body` gönderir -- ama URL'de HANGİ
kaydın güncelleneceğini belirtir (`/courses/${courseId}`). DELETE ise
genellikle hiç `body` göndermeden, yalnızca URL'deki id ile hangi
kaydın silineceğini belirtir.

## Özet ve Terimler Sözlüğü

`fetch`, bir URL'e HTTP isteği atıp bir Promise döner; `useEffect` ile
component ekrana geldiğinde çağrılır. GET veri okur, POST yeni kayıt
oluşturur, PUT var olan bir kaydı günceller, DELETE siler -- POST ve
PUT'ta `body`'ye JSON gönderilir. Bir istek her zaman `loading` ve
`error` state'leriyle birlikte yönetilmelidir -- kullanıcı, veri
gelene kadar bir bekleme mesajı, bir hata olduğunda da anlaşılır bir
mesaj görmelidir.

**Terimler Sözlüğü**

**fetch** — Tarayıcının, bir URL'e HTTP isteği atmak için kullanılan
yerleşik fonksiyonu; bir Promise döner.

**HTTP Metodu** — Bir isteğin AMACINI belirten kelime: GET (okuma),
POST (oluşturma), PUT (güncelleme), DELETE (silme).

**Promise** — Henüz tamamlanmamış, ileride bir sonuç (ya da hata)
üretecek bir işlemi temsil eden JavaScript nesnesi.
