# useRef

useEffect dersinde, component'in ekran çıktısı dışında bir şey yapmasını
gördük. Bu ders, benzer bir ihtiyaca -- ekranı tetiklemeden bir değeri
"hatırlamak" ya da bir DOM elementine doğrudan erişmek -- çözüm sunan bir
başka hook'u, `useRef`'i anlatıyor.

## DOM Referansları (DOM References)

`useRef`'in en yaygın kullanımlarından biri, bir DOM elementine doğrudan
erişmek:

{{DomReferenceExample.jsx}}

`ref={inputRef}` yazarak React'e "bu elementin gerçek DOM node'unu
`inputRef.current`'a koy" diyoruz. `inputRef.current`, artık gerçek bir
DOM elementi -- `focus()` gibi tarayıcının kendi metotlarını doğrudan
çağırabiliriz.

## Render'lar Arası Kalıcı Değerler

`useRef`'in ikinci kullanımı: bir değeri render'lar arasında
"hatırlamak", ama bu değer değiştiğinde ekranı YENİDEN RENDER
ETMEDEN:

{{PersistentValueExample.jsx}}

`renderCount.current` her render'da artıyor ve değeri render'lar arasında
korunuyor -- ama bu artış kendi başına bir re-render TETİKLEMİYOR.
Değeri yalnızca bir SONRAKİ render olduğunda (başka bir sebeple, burada
`count` state'i değiştiği için) güncel haliyle görüyoruz.

## useRef vs useState

`useRef` ile `useState` arasındaki temel fark şu: `useState`'i
değiştirmek bir re-render TETİKLER, `useRef`'i değiştirmek TETİKLEMEZ:

{{UseRefVsUseStateExample.jsx}}

"State'i Artır" butonuna basınca ekran güncellenir, çünkü `setStateValue`
bir re-render tetikler. "Ref'i Artır" butonuna basınca değer gerçekten
değişir (console'da görebilirsin), ama ekranda hiçbir şey değişmez --
çünkü ref değişikliği React'e "yeniden render et" demez. Ekranda
GÖRÜNMESİ gereken bir değer state olmalı; ekranda görünmesi gerekmeyen,
yalnızca "hatırlanması" gereken bir değer ref olabilir.

## useRef ve useEffect'i Birlikte Kullanmak

`useRef` ve `useEffect` sık sık birlikte kullanılır -- örneğin, "bir
önceki render'daki değer neydi" sorusuna cevap vermek için:

{{PreviousValueWithRefExample.jsx}}

Her render'dan sonra çalışan `useEffect`, mevcut `count` değerini
`previousCountRef`'e kaydediyor. Bir sonraki render'da, bu ref hâlâ BİR
ÖNCEKİ render'daki değeri taşıyor -- çünkü ref güncellemesi kendi başına
yeni bir render tetiklemiyor, güncelleme ancak `count` state'i
değiştiğinde gerçekleşen render'ın İÇİNDE oluyor.

## Özet ve Terimler Sözlüğü

`useRef`, iki temel iş için kullanılır: bir DOM elementine doğrudan
erişmek, ya da bir değeri render'lar arasında ekranı tetiklemeden
hatırlamak. `useState`'in aksine, bir ref'i değiştirmek re-render
tetiklemez -- bu yüzden ekranda görünmesi gereken veriler için `useState`,
görünmesi gerekmeyen "arka plan" değerleri için `useRef` kullanılır.

**Terimler Sözlüğü**

**`useRef`** — Bir DOM elementine erişmeni ya da bir değeri render'lar
arasında, ekranı tetiklemeden saklamanı sağlayan hook.

**`.current`** — `useRef`'in döndürdüğü nesnenin, o an tutulan değeri
taşıyan alanı.

**DOM Referansı** — Bir JSX elementinin gerçek tarayıcı DOM node'una
doğrudan erişim; `ref` attribute'u ile kurulur.
