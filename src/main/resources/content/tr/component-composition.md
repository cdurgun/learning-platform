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

## Pratik Proje

Bu kategoride (Components, Props, Component Composition) öğrendiğimiz
kavramları bir arada kullanan, gerçek ve çalıştırılabilir bir örnek proje
var: **[Components & Props Demo](https://github.com/cdurgun/react-course-projects/tree/main/projects/components-props)**.

Proje; birden çok component'i, props'u (destructuring ve default değerlerle)
ve `children` ile composition'ı bir arada gösteriyor. Bilgisayarına indirip
çalıştırabilir, kodunu satır satır inceleyebilirsin:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/components-props
npm run dev
```

`react-course-projects` deposu **npm workspaces** kullanır -- `npm install`
yalnızca bir kez, depo kökünde çalıştırılır ve tüm proje klasörleri ortak
bağımlılıkları paylaşır (her klasörde ayrı bir `node_modules` oluşmaz). Kök
dizinde `npm install`'ı daha önce çalıştırdıysan, doğrudan
`cd react-course-projects/projects/components-props` yapıp `npm run dev`
demen yeterli.
