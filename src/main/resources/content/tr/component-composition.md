# Component Composition

Components ve Props derslerinde küçük component'ler yazıp onlara veri
gönderdik. Bu ders, o küçük parçaları nasıl BİRLEŞTİRİP daha büyük
arayüzler kurduğumuzu gösteriyor -- buna "composition" denir.

## children Prop'u Nedir?

`children`, her component'in otomatik olarak sahip olduğu özel bir prop.
Bir component'in açılış ve kapanış etiketi arasına ne yazarsan, o içerik
`children` olarak o component'e ulaşır:

{{ChildrenPropExample.jsx}}

`<Box><p>...</p></Box>` yazdığımızda, `<p>...</p>` kısmı `Box`'un
`children`'ı olur. Bu, Props dersinde gördüğümüz normal prop'lardan biraz
farklı çalışır -- `children`'ı bir attribute gibi değil, etiketin İÇİNE
yazarsın.

## İç İçe Component'ler (Nested Components)

Component'ler iç içe kullanılabilir -- bir component başka component'ler
içerebilir, onlar da kendi içlerinde başka component'ler içerebilir:

{{NestedComponentsExample.jsx}}

`UserProfile`, `Avatar` ve `UserName`'i içeriyor; `App` de `UserProfile`'ı
içeriyor. Küçük, tek işi olan component'lerden büyük bir arayüz kurmanın
yolu bu -- her component kendi işine odaklanır.

## Composition vs Inheritance (Kısa Bakış)

Nesne yönelimli programlamada "inheritance" (kalıtım), bir sınıfın başka
bir sınıftan özellik devralmasıdır. React'te component'ler arasında böyle
bir kalıtım YOKTUR:

{{CompositionVsInheritanceExample.jsx}}

React'te component'ler, kalıtımla değil, composition ile birleştirilir --
küçük component'leri, `children` ile büyük bir component'in içine koyarsın.
React ekibi, composition'ın neredeyse her senaryo için yeterli ve daha
basit olduğunu söylüyor -- bu yüzden React'te `extends` ile bir component'i
genişletmek gibi bir kalıp görmezsin.

## Özet ve Terimler Sözlüğü

`children`, bir component'in açılış/kapanış etiketleri arasına yazılan
içeriği taşıyan özel bir prop. Component'ler iç içe kullanılarak büyük
arayüzler kurulur. React'te component'leri birleştirmenin yolu composition'dır,
kalıtım (inheritance) değil.

**Terimler Sözlüğü**

**`children`** — Bir component'in açılış ve kapanış etiketleri arasına
yazılan içeriği taşıyan özel prop.

**Composition (Birleştirme)** — Küçük component'leri bir araya getirerek
daha büyük bir arayüz kurma yöntemi.

**Inheritance (Kalıtım)** — Bir sınıfın başka bir sınıftan özellik
devraldığı, React'in component'ler arasında KULLANMADIĞI bir yöntem.

## Ek: Mini Proje — Yeniden Kullanılabilir Bir Card Component'i

Bu dersteki üç fikri (`children`, iç içe component'ler, composition) tek
bir örnekte birleştiriyoruz:

{{CardBase.jsx}}

{{CardDemo.jsx}}

`CardBase.jsx`, üç küçük component tanımlıyor: `Card` (dış çerçeve),
`CardTitle` ve `CardText`. `CardDemo.jsx`, bunları composition ile
birleştirerek İKİ FARKLI kart oluşturuyor -- ikisi de aynı parçaları
kullanıyor, ama `children` olarak verdiğimiz içerik farklı olduğu için
sonuç da farklı. Bu, tek bir component'i defalarca yazmak yerine, küçük
parçaları yeniden birleştirerek çeşitlilik yaratmanın gerçek bir örneği.
