# Lists & Keys

Şimdiye kadarki örneklerde hep tek bir şeyi gösterdik -- tek bir sayaç,
tek bir kullanıcı. Ama gerçek uygulamalarda çoğu zaman bir LİSTE
gösterirsin: bir ürün listesi, bir yorum listesi, bir görev listesi. Bu
ders, React'te listeleri render etmeyi ve `key` prop'unun neden önemli
olduğunu anlatıyor.

## map() ile Liste Render Etmek

Bir diziyi ekrana JSX elementleri olarak dökmek için JavaScript'in
`map()` fonksiyonunu kullanırsın:

{{MapRenderListExample.jsx}}

`map()`, bir dizideki her elemanı BAŞKA bir şeye çevirip yeni bir dizi
döndürür -- burada her meyve string'ini bir `<li>` elementine çeviriyoruz.
Sonuç, JSX elementlerinden oluşan bir dizi; React bu diziyi doğrudan
render edebilir.

## key Prop'u Nedir?

`map()` ile bir liste render ederken, her elemana bir `key` prop'u
vermen gerekir:

{{KeyPropExample.jsx}}

`key`, o listedeki elemanı BENZERSİZ şekilde tanımlayan bir string ya da
sayı. Mümkünse elemanın ismi ya da index'i değil, veritabanından gelen
`id` gibi kalıcı bir kimlik kullanılmalı.

## key Neden Önemli?

`key`, React'e bir sonraki render'da hangi liste elemanının HANGİSİYLE
aynı olduğunu söyler:

{{WhyKeysMatterExample.jsx}}

Liste değişmeden kaldığı sürece `key` fark etmez gibi görünür. Ama bir
eleman eklenip/silindiğinde ya da sıralama değiştiğinde, React `key`'i
kullanarak hangi elemanın "aynı kaldığını", hangisinin yeni olduğunu
anlar -- bu sayede yalnızca gerçekten değişen kısmı günceller, listenin
tamamını yeniden oluşturmaz.

## Yaygın Hatalar

En yaygın hata, `key` olarak dizinin index'ini kullanmaktır:

{{CommonKeyMistakeExample.jsx}}

Liste hiç değişmiyorsa bu çalışıyor gibi görünür. Ama bir eleman
eklendiğinde/silindiğinde ya da sıralama değiştiğinde her elemanın
index'i kayar -- React, index'e bakarak "aynı eleman" sandığı şeyin
aslında farklı bir eleman olduğunu anlayamaz. Bu, özellikle input içeren
listelerde (bir görev listesindeki checkbox'lar gibi) yanlış elemanın
güncellenmesi gibi görsel hatalara yol açabilir. Mümkün olduğunca
`id` gibi kalıcı bir kimlik kullan; elinde gerçekten hiç kalıcı bir
kimlik yoksa ve liste asla yeniden sıralanmıyor/değişmiyorsa, index bir
son çare olabilir.

## Özet ve Terimler Sözlüğü

Bir diziyi ekrana dökmek için `map()` kullanılır; her elemana, React'in
listedeki değişiklikleri doğru takip edebilmesi için benzersiz bir `key`
verilir. `key` olarak mümkünse kalıcı bir `id` kullanılmalı, dizinin
index'i değil -- index kullanmak, liste değiştiğinde yanlış elemanların
güncellenmesine yol açabilir.

**Terimler Sözlüğü**

**`map()`** — Bir dizideki her elemanı başka bir şeye çevirip yeni bir
dizi döndüren JavaScript dizi metodu; React'te listeleri JSX elementlerine
çevirmek için kullanılır.

**`key`** — Bir listedeki her elemana verilen, React'in render'lar
arasında elemanları takip etmesini sağlayan benzersiz kimlik.

**Reconciliation (Uzlaştırma)** — React'in, bir önceki render ile yeni
render arasındaki farkı bulup yalnızca gerçekten değişen kısımları
güncellediği süreç; `key`, bu süreçte listelerin doğru eşleştirilmesini
sağlar.

## Pratik Proje

Bu kategoride (Events, State, Conditional Rendering, Lists & Keys)
öğrendiğimiz kavramları bir arada kullanan, gerçek ve çalıştırılabilir
bir örnek proje var: **[State & Events Demo](https://github.com/cdurgun/react-course-projects/tree/state-events-v1/projects/state-events)** --
basit bir görev listesi (task list) uygulaması.

Proje; event handler'ları (`onClick`/`onChange`/`onSubmit`), `useState`'i,
önceki state'e göre güncellemeyi, state immutability'yi, ternary/`&&` ile
conditional rendering'i ve `map()`+`key` ile liste render etmeyi bir
arada gösteriyor. Bilgisayarına indirip çalıştırabilir, kodunu satır
satır inceleyebilirsin:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/state-events
npm run dev
```

`react-course-projects` deposu **npm workspaces** kullanır -- `npm install`
yalnızca bir kez, depo kökünde çalıştırılır ve tüm proje klasörleri ortak
bağımlılıkları paylaşır (her klasörde ayrı bir `node_modules` oluşmaz). Kök
dizinde `npm install`'ı daha önce çalıştırdıysan, doğrudan
`cd react-course-projects/projects/state-events` yapıp `npm run dev`
demen yeterli.
