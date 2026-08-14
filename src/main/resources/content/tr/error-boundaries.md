# Error Boundaries

Bu derste, kursta İLK KEZ bir **class component** göreceğiz. React'te
error boundary'leri (hata sınırları) hook'larla yazmanın bir yolu yok --
yalnızca class component'ler kullanılarak yazılabiliyor. Şimdiye kadar
öğrendiğin her şey (hooks, state, props) fonksiyon component'lerle
ilgiliydi; bu, istisnai ve dar kapsamlı bir konu.

## Temel Bir Error Boundary Yazmak

Bir component render sırasında hata fırlattığında, React normalde TÜM
uygulamayı "unmount" eder (boş bir ekran gösterir). Error boundary, bunu
önler:

{{BasicErrorBoundaryExample.jsx}}

`static getDerivedStateFromError()`, bir child hata fırlattığında React
tarafından çağrılır -- döndürdüğü değer yeni state olur. `render()`
metodu, `hasError` durumuna göre ya normal `children`'ı ya da bir
fallback mesajı gösterir.

## componentDidCatch ile Hatayı Loglamak

`getDerivedStateFromError`, YALNIZCA fallback UI'ı göstermek için
kullanılır -- hatayı bir yere göndermek (loglamak) için ayrı bir metot
gerekir:

{{ComponentDidCatchExample.jsx}}

`componentDidCatch(error, errorInfo)`, hatanın kendisini VE
`errorInfo.componentStack`'i (hatanın hangi component'te olduğunu
gösteren bir "yığın izi") alır -- gerçek uygulamalarda burada genellikle
bir hata izleme servisine (Sentry gibi) bir istek atılır.

## Error Boundary Kullanmak

Bir error boundary'i, hata fırlatabilecek component'leri sarmalamak için
kullanırız:

{{UsingErrorBoundaryExample.jsx}}

`BuggyCounter`, `count === 3` olduğunda bilinçli olarak bir hata
fırlatıyor -- `ErrorBoundary` bunu yakalayıp normal render'ı fallback
UI'la değiştiriyor. `BuggyCounter`'ın kendisi hatayı yönetmek zorunda
DEĞİL, bu error boundary'nin işi.

## Error Boundary'lerin Kapsamı

Birden fazla, KÜÇÜK error boundary kullanmak, tek bir büyük boundary'den
genellikle daha iyidir:

{{ErrorBoundaryScopeExample.jsx}}

İki ayrı `ErrorBoundary`, iki ayrı bölümü sarmalıyor -- biri çökse bile,
diğeri bundan ETKİLENMİYOR. Tek bir büyük boundary kullansaydık,
herhangi bir hata TÜM sayfayı fallback mesajına çevirebilirdi.

## Error Boundary'lerin Yakalamadığı Hatalar

Error boundary'lerin bir sınırı var -- her tür hatayı yakalamazlar:

{{WhatErrorBoundariesDontCatchExample.jsx}}

Error boundary'ler yalnızca RENDER sırasındaki hataları yakalar --
event handler'lardaki (`onClick` gibi), asenkron kod içindeki
(`setTimeout`, fetch callback'leri), sunucu tarafı render'daki, ya da
boundary'nin KENDİSİNDE fırlatılan hataları YAKALAMAZLAR. Event
handler'lardaki hatalar için normal `try`/`catch` kullanılır.

## Özet ve Terimler Sözlüğü

Bir error boundary, `static getDerivedStateFromError` (fallback UI
göstermek için) ve isteğe bağlı `componentDidCatch` (hatayı loglamak
için) tanımlayan bir class component'tir -- React'te bunun hook
karşılığı yoktur. Bir error boundary, İÇİNDEKİ herhangi bir component'in
render sırasında fırlattığı hatayı yakalar ve normal render'ı bir
fallback UI'la değiştirir. Birden fazla küçük boundary kullanmak, bir
bölümdeki hatanın diğerlerini etkilemesini önler. Error boundary'ler
event handler'lardaki, asenkron koddaki, ya da kendi içindeki hataları
YAKALAMAZ.

**Terimler Sözlüğü**

**Error Boundary (Hata Sınırı)** — İçindeki component'lerin render
sırasında fırlattığı hataları yakalayıp bir fallback UI gösteren class
component.

**Fallback UI** — Bir hata (ya da yükleme durumu) sırasında, normal
içerik yerine gösterilen alternatif arayüz.
