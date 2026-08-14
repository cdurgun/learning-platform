# useEffect

What Are Hooks? dersinde hook kavramını gördük. Bu ders, en sık
kullanılan hook'lardan biriyle -- `useEffect` -- component'inin dışına
çıkıp bir şeyler yapmasını (bir side effect) sağlamayı anlatıyor.

## Side Effect (Yan Etki) Nedir?

Bir **side effect**, component'in kendi render çıktısı (yani döndürdüğü
JSX) DIŞINDA yaptığı bir şeydir: tarayıcının sekme başlığını değiştirmek,
bir zamanlayıcı (timer) kurmak, veri çekmek, `localStorage`'a yazmak
gibi. `useEffect`, bu tür işleri güvenli bir şekilde yapmanı sağlayan
hook.

## Temel useEffect Kullanımı

`useEffect`'e bir fonksiyon verirsin; React bu fonksiyonu render
bittikten SONRA çalıştırır:

{{BasicUseEffectExample.jsx}}

Burada her render'dan sonra sekme başlığını güncelliyoruz -- bu, JSX'in
kendisinin yapamayacağı bir iş, çünkü `document.title`, ekrana çizilen
component ağacının dışında, tarayıcının kendi bir özelliği.

## Dependency Array: Boş Dizi []

`useEffect`'in ikinci parametresi, isteğe bağlı bir **dependency array**
(bağımlılık dizisi). Boş bir dizi `[]` verirsen, effect yalnızca
component ilk kez ekrana geldiğinde (mount olduğunda) bir kez çalışır:

{{EmptyDependencyArrayExample.jsx}}

Sonraki render'larda (state her değiştiğinde) bu effect BİR DAHA
ÇALIŞMAZ -- yalnızca ilk render'dan sonra.

## Dependency Array: Belirli Değerler

Dependency array'e belirli değerler koyarsan, effect yalnızca O DEĞERLER
değiştiğinde çalışır:

{{DependencyArrayExample.jsx}}

`[count]` yazdığımız için effect yalnızca `count` değiştiğinde çalışır --
`name` değişse bile effect tetiklenmez. React, her render'da dependency
array'deki değerleri bir önceki render'la karşılaştırır; en az biri
değiştiyse effect'i çalıştırır.

## Cleanup Fonksiyonu

Bazı effect'ler (zamanlayıcı kurmak, bir event listener eklemek gibi)
"temizlenmesi" gereken bir şey bırakır. `useEffect`'in verdiği fonksiyon
bir CLEANUP fonksiyonu döndürebilir:

{{CleanupFunctionExample.jsx}}

React, cleanup fonksiyonunu component ekrandan kalktığında (unmount) ya
da effect yeniden çalışmadan HEMEN ÖNCE otomatik çağırır. Burada
`clearInterval` ile zamanlayıcıyı durdurmazsak, component ekrandan
kalktıktan sonra bile arka planda çalışmaya devam eder.

## Yaygın Hata: Infinite Loop

En yaygın `useEffect` hatası, dependency array'i unutup effect içinde
state güncellemektir:

{{InfiniteLoopMistakeExample.jsx}}

Dependency array'siz bir `useEffect`, HER render'dan sonra çalışır.
İçinde state güncellenirse, bu güncelleme yeni bir render tetikler, o
render yine effect'i çalıştırır -- SONSUZ DÖNGÜ. Çözüm, dependency
array'i doğru kurmak: yalnızca bir kez çalışması gerekiyorsa `[]`,
belirli bir değere bağlıysa o değeri diziye koymak.

## Özet ve Terimler Sözlüğü

`useEffect`, component'in render çıktısı dışında bir şey yapması
(side effect) gerektiğinde kullanılır. Dependency array, effect'in NE
ZAMAN çalışacağını belirler: `[]` yalnızca ilk render'da, `[deger]`
yalnızca o değer değiştiğinde, hiç dependency array olmaması ise HER
render'dan sonra. Cleanup fonksiyonu, effect'in bıraktığı şeyleri (timer,
event listener gibi) temizler. Dependency array'i unutup effect içinde
state güncellemek, en yaygın hata olan infinite loop'a yol açar.

**Terimler Sözlüğü**

**Side Effect (Yan Etki)** — Bir component'in render çıktısı dışında
yaptığı bir şey (DOM'u doğrudan değiştirmek, veri çekmek gibi).

**`useEffect`** — Component'e side effect çalıştırma yeteneği ekleyen
hook.

**Dependency Array (Bağımlılık Dizisi)** — `useEffect`'in ikinci
parametresi; effect'in hangi değerler değiştiğinde yeniden çalışacağını
belirler.

**Cleanup Fonksiyonu** — `useEffect`'in verdiği fonksiyondan
döndürülen, effect'in bıraktığı şeyleri temizleyen fonksiyon; component
unmount olduğunda ya da effect yeniden çalışmadan önce çağrılır.

**Mount / Unmount** — Bir component'in ekrana ilk kez gelmesi (mount)
ve ekrandan tamamen kaldırılması (unmount).
