# Components

JSX dersinde React'in söz dizimini gördük. Şimdi JSX'i gerçekten neyin
içinde kullandığımıza bakıyoruz: **component**'ler. React'te her şey bir
component'ten oluşur -- bu ders, bir component'in ne olduğunu ve nasıl
yazılıp kullanıldığını basit örneklerle anlatıyor.

## Component Nedir?

Bir component, arayüzün küçük, bağımsız bir parçasıdır -- bir buton, bir
kart, bir sayfanın tamamı bile bir component olabilir. React Nedir?
dersinde bahsettiğimiz gibi, bir React uygulaması aslında birçok küçük
component'in bir araya gelmesiyle oluşur.

## Fonksiyon Olarak Component Yazmak

En basit hâliyle, bir component, JSX döndüren bir JavaScript fonksiyonudur:

{{FunctionComponentExample.jsx}}

Bu kadar. Yeni bir sözdizimi ya da özel bir anahtar kelime yok -- sadece
normal bir fonksiyon, geriye JSX döndürüyor.

## Component'i Kullanmak (Render Etmek)

Bir component'i kullanmak (buna "render etmek" denir), onu JSX içinde bir
etiket gibi yazmaktır:

{{UsingComponentExample.jsx}}

`<Welcome />`, tıpkı `<h1>` ya da `<div>` yazmak gibi -- tek fark, bunun
senin yazdığın bir component olması. Bir component, başka bir component'in
içinde de kullanılabilir; App'in Welcome'ı kullanması gibi.

## Component İsimlendirme Kuralı

React, component'i normal bir HTML etiketinden nasıl ayırt eder? Cevap
basit: isim büyük mü küçük mü diye bakarak.

{{ComponentNamingExample.jsx}}

Küçük harfle başlayan bir isim (`div`, `button`, `userCard`), React
tarafından normal bir HTML etiketi sanılır. Bu yüzden component isimleri
her zaman büyük harfle başlamalıdır (`Welcome`, `UserCard`). Bunu
unutmak, bu dersteki en yaygın hatalardan biri.

## Yeniden Kullanılabilir Component'ler

Bir component'in en büyük faydası: bir kez yaz, istediğin kadar kullan.

{{ReusableButtonExample.jsx}}

Aynı `Button` component'i üç kez kullanıldı -- her seferinde aynı HTML'i
yeniden yazmaya gerek kalmadı. Bir sonraki derste (Props), aynı component'i
her kullanımda FARKLI verilerle nasıl özelleştireceğimizi göreceğiz.

## Özet ve Terimler Sözlüğü

Bir component, JSX döndüren bir fonksiyondur. İsmi büyük harfle başlamak
zorundadır, JSX içinde bir etiket gibi kullanılır, ve bir kez yazılıp
istendiği kadar tekrar kullanılabilir.

**Terimler Sözlüğü**

**Component** — Arayüzün küçük, bağımsız bir parçasını tanımlayan,
JSX döndüren bir JavaScript fonksiyonu.

**Render Etmek** — Bir component'i JSX içinde kullanmak (`<Welcome />`
gibi).

**Function Component** — Bir fonksiyon olarak yazılan component (bugünkü
React'te en yaygın component türü).
