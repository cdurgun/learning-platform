# React Performance

Bu kategori, React'in "ileri seviye" konularına giriş yapıyor -- artık
temel kavramları (state, hooks, forms, routing, veri çekme, state
paylaşımı) bildiğin için, bunları NASIL DAHA VERİMLİ kullanacağına
odaklanabiliriz. İlk durak: gereksiz yeniden render'ları önlemek.

## Gereksiz Yeniden Render'lar

Bir parent component yeniden render olduğunda, React varsayılan olarak
TÜM child'larını da yeniden render eder -- child'ın props'u değişmemiş
olsa bile:

{{UnnecessaryRerenderExample.jsx}}

`count` her arttığında, `items` HİÇ DEĞİŞMEDİĞİ halde `ExpensiveList`
de yeniden render olur. Küçük component'lerde bu sorun olmaz, ama
büyük listelerde ya da karmaşık hesaplamalarda fark edilir bir yavaşlığa
yol açabilir.

## React.memo ile Gereksiz Render'ı Atlamak

`memo()`, bir component'i, props'u değişmediği sürece yeniden render
ETMEYECEK şekilde sarmalar:

{{ReactMemoExample.jsx}}

React, `memo` ile sarmalanmış bir component'i yeniden render etmeden
ÖNCE, yeni props'ları bir önceki render'daki props'larla KARŞILAŞTIRIR
(sığ/shallow karşılaştırma); aynılarsa render'ı atlar.

## memo + useCallback: Fonksiyon Prop'ları

`memo` tek başına yeterli değil -- fonksiyon prop'larıyla dikkatli
olmak gerekir:

{{ReactMemoWithCallbackExample.jsx}}

Hooks dersinde gördüğümüz `useCallback` OLMADAN, her render'da YENİ bir
fonksiyon oluşur -- fonksiyonlar da birer değer olduğu için, `memo` bunu
"props değişti" sayar ve yine de yeniden render eder. `useCallback`,
bağımlılıkları değişmediği sürece AYNI fonksiyon referansını korur.

## useMemo ile Pahalı Hesaplamaları Önbelleklemek

Hooks dersinde gördüğümüz `useMemo`'yu, şimdi doğrudan performans
bağlamında tekrar görelim:

{{UseMemoForExpensiveCalculationExample.jsx}}

`sortAlphabetically`, yalnızca `courses` DEĞİŞTİĞİNDE çalışır --
component'in başka bir nedenle (örneğin `count` değiştiği için) yeniden
render olması, bu pahalı işlemi TEKRAR TETİKLEMEZ.

## React DevTools Profiler ve `<Profiler>`

Bir component'in ne kadar sürede render edildiğini ÖLÇMEK için,
React'in kendi `<Profiler>` component'i kullanılabilir:

{{ProfilerComponentExample.jsx}}

`onRender` callback'i, sarmalanan ağaç her render olduğunda çağrılır ve
render süresini milisaniye cinsinden verir. Bu, React DevTools
tarayıcı eklentisindeki "Profiler" sekmesinin arkasındaki mekanizmayla
aynıdır -- gerçek uygulamalarda genellikle kalıcı kod olarak değil,
bir performans sorununu araştırırken GEÇİCİ olarak eklenir.

## Özet ve Terimler Sözlüğü

Bir parent yeniden render olduğunda, React varsayılan olarak tüm
child'larını da render eder; `memo()`, props değişmediği sürece bunu
atlamayı sağlar -- ama fonksiyon prop'ları için `useCallback` ile
birlikte kullanılması gerekir. `useMemo`, pahalı bir hesaplamanın
sonucunu, bağımlılıkları değişmediği sürece önbellekte tutar. Bir
component'in render süresini ölçmek için React'in `<Profiler>`
component'i ya da React DevTools kullanılabilir.

**Terimler Sözlüğü**

**Re-render (Yeniden Render)** — Bir component'in, state ya da props
değişikliği sonucunda tekrar render edilmesi.

**Memoization (Önbellekleme)** — Bir hesaplamanın ya da component
render'ının sonucunu saklayıp, girdiler değişmediği sürece tekrar
hesaplamak yerine bu saklanan sonucu kullanmak.
