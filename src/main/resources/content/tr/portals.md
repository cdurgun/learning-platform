# Portals

Advanced React kategorisinin son konusu -- bir component'i, React
ağacındaki KONUMUNDAN farklı bir DOM düğümüne render etmenin yolu:
**Portal**'lar.

## Portal Nedir? createPortal ile Başlangıç

`react-dom`'un `createPortal` fonksiyonu, bir component'i DOM'da farklı
bir yere render etmemizi sağlar:

{{BasicPortalExample.jsx}}

`createPortal(child, container)`, `child`'ı normal React ağacındaki
YERİNE değil, DOM'daki `container` düğümüne render eder. Component
ağacında (React DevTools'ta) hâlâ olması gereken yerde görünür, ama
gerçek DOM'da tamamen farklı bir konumdadır.

## Modal'lar için Portal Kullanmak

Portal'ın en yaygın kullanım alanı modal'lar:

{{ModalWithPortalExample.jsx}}

Bir modal'ın CSS'i (`position: fixed`, yüksek `z-index`) sayfanın
geri kalanının ÜSTÜNDE görünmesini sağlamalı -- ama modal'ın gerçek DOM
konumu (örneğin `overflow: hidden` olan bir kartın içi) bunu bazen
engelleyebilir. Portal, modal'ı doğrudan `document.body`'ye render
ederek bu sorunu ORTADAN KALDIRIR.

## Event Bubbling: Portal'ların Şaşırtıcı Davranışı

Portal'ların en önemli (ve en şaşırtıcı) özelliği, event'lerin nasıl
davrandığı:

{{EventBubblingThroughPortalExample.jsx}}

`Popup`, DOM'da dıştaki `<div>`'in DIŞINDA (`document.body`'de) render
ediliyor. Ama içindeki butona tıklandığında, `onClick` yine de dıştaki
`<div>`'e kadar "bubble" ediyor -- React, event'leri GERÇEK DOM
ağacına göre değil, KENDİ component ağacına göre yayar. Bu, Portal'ları
kullanırken bilmen gereken en önemli davranış.

## Portal Hedefini Ayarlamak

`document.body` yerine, genellikle özel olarak ayrılmış bir hedef
kullanılır:

{{PortalTargetSetupExample.jsx}}

`index.html`'de `<div id="tooltip-root"></div>` gibi, uygulamanın
`#root`'una KARDEŞ (sibling) bir eleman eklemek yaygın bir pratiktir --
bu, portal içeriğinin kendi stillerini ve konumunu yönetmesini
kolaylaştırır.

## Özet ve Terimler Sözlüğü

`createPortal(child, container)`, bir component'i React ağacındaki
konumunda TUTARAK, gerçek DOM'da farklı bir düğüme render eder -- en
yaygın kullanımı modal'lar, tooltip'ler ve dropdown'lardır (üst
öğelerin `overflow: hidden` gibi CSS özelliklerinden kaçınmak için).
Event'ler, gerçek DOM konumuna değil, React'in component ağacına göre
bubble eder -- bu, Portal'ları normal component'ler gibi kullanmaya
devam edebilmemizi sağlar.

**Terimler Sözlüğü**

**Portal** — Bir component'i, React ağacındaki konumunu koruyarak,
DOM'da farklı bir düğüme render etme mekanizması.

**Event Bubbling (Olay Yayılımı)** — Bir event'in, tetiklendiği
elemandan başlayıp ağaçtaki üst elemanlara doğru yayılması.

## Pratik Proje

Bu kategoride (React Performance, Error Boundaries, Lazy Loading & Code
Splitting, Suspense, Portals) öğrendiğimiz kavramları bir arada
kullanan, gerçek ve çalıştırılabilir bir örnek proje var:
**[Advanced React Demo](https://github.com/cdurgun/react-course-projects/tree/main/projects/advanced-react)**
-- `React.memo` ile optimize edilmiş bir kurs listesi, bir Error
Boundary, `React.lazy` + `Suspense` ile code splitting yapılan bir
detay paneli, ve bir Portal modal'ı bir arada gösteren bir uygulama.

Bilgisayarına indirip çalıştırabilir, kodunu satır satır
inceleyebilirsin:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/advanced-react
npm run dev
```

`react-course-projects` deposu **npm workspaces** kullanır -- `npm install`
yalnızca bir kez, depo kökünde çalıştırılır ve tüm proje klasörleri ortak
bağımlılıkları paylaşır (her klasörde ayrı bir `node_modules` oluşmaz). Kök
dizinde `npm install`'ı daha önce çalıştırdıysan, doğrudan
`cd react-course-projects/projects/advanced-react` yapıp `npm run dev`
demen yeterli.
