# Sharing State

Şimdiye kadar `useState`'i hep TEK bir component'in içinde kullandık.
Bu ders, birden fazla component'in AYNI state'e ihtiyaç duyduğu
durumları -- ve bunun beraberinde getirdiği "props drilling" sorununu
-- anlatıyor.

## İki Component, Aynı State'e İhtiyaç Duyduğunda

Bir arama kutusu (`SearchBox`) ve bir sonuç listesi (`ResultsList`)
düşün -- ikisi de AYNI arama metnine ihtiyaç duyar. `query` state'i
`SearchBox`'ın içinde tutulursa ne olur?

{{SeparateStateProblemExample.jsx}}

`ResultsList`'in, `SearchBox`'ın state'ine erişmesinin hiçbir yolu yok
-- her component'in kendi state'i kendi İÇİNE hapsolmuştur, kardeş
component'ler (sibling'ler) birbirinin state'ini DOĞRUDAN göremez.

## State'i Yukarı Taşımak: Lifting State Up

Çözüm, state'i iki component'in de ORTAK atası olan bir yere taşımak:

{{LiftingStateUpExample.jsx}}

`query` state'i artık ortak parent'ta yaşıyor; her iki child da bunu
props ile alıyor -- `SearchBox`, `query` ve `onQueryChange`'i, `ResultsList`
ise yalnızca `query`'i. Bu desene **state'i yukarı taşımak** (lifting
state up) denir -- React'te paylaşılan state'i yönetmenin en temel
yolu budur.

## Aynı Deseni Farklı Bir Senaryoda Görmek

Lifting state up, yalnızca liste filtrelemekle sınırlı değil -- aynı
değeri İKİ FARKLI şekilde gösteren component'ler için de geçerli:

{{SyncedSiblingsExample.jsx}}

Bir slider ve bir metin gösterimi, AYNI `rating` değerini paylaşıyor --
state ortak parent'ta olduğu için, biri değiştiğinde diğeri de anında
güncel kalıyor.

## Props Drilling: Ara Katmanlardan Geçirmek

Component ağacı derinleştikçe, bir prop'u ihtiyaç duyan component'e
ULAŞTIRMAK için, aralarındaki component'lerin de o prop'u almasını
gerektirebilir:

{{PropsDrillingExample.jsx}}

`ResultsPanel`, `query`'i KENDİSİ hiç kullanmıyor -- yalnızca
`ResultsList`'e iletmek için alıyor. Buna **props drilling** denir --
bir prop'un, kullanmayan ara katmanlardan zorunlu olarak geçirilmesi.

## Props Drilling Neden Sorun Yaratır?

Ağaç derinleştikçe bu sorun büyür:

{{WhyPropsDrillingHurtsExample.jsx}}

`Level1`, `Level2`, `Level3`'ün HİÇBİRİ `user`'ı kullanmıyor -- yalnızca
aktarıyorlar. Yalnızca en dipteki `Level4` gerçekten kullanıyor. Her
yeni seviye, ya da her yeni paylaşılan değer, bu zinciri daha da
uzatır -- yazması yorucu ve hataya açık hale gelir. Bir sonraki derste
(Context API), bunu çözen bir yöntem göreceğiz.

## Özet ve Terimler Sözlüğü

Birden fazla component aynı state'e ihtiyaç duyduğunda, state'i
ORTAK ataya taşımak (lifting state up) gerekir -- her child bu state'i
props ile alır. Ağaç derinleştikçe, bir prop'u kullanmayan ara
component'lerden geçirmek zorunda kalmak "props drilling" sorununu
doğurur -- bu, kodu yazması yorucu ve değiştirmesi kırılgan hale
getirir.

**Terimler Sözlüğü**

**Lifting State Up (State'i Yukarı Taşımak)** — Birden fazla
component'in paylaştığı bir state'i, bu component'lerin ORTAK atasına
taşımak.

**Props Drilling** — Bir prop'u, kullanmayan ara katman component'lerden
zorunlu olarak geçirmek.
