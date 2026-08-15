# JSX

Bir React projesini kurmayı Bir React Projesi Oluşturmak dersinde gördük.
Şimdi asıl React kodunun içine giriyoruz. React'te arayüz yazarken
kullandığın söz dizimine **JSX** denir -- bu ders, JSX'in ne olduğunu ve
temel kurallarını, olabildiğince basit örneklerle anlatıyor.

## JSX Nedir?

JSX, HTML'e çok benzeyen ama aslında JavaScript'in bir uzantısı olan bir
söz dizimidir. React component'lerinin çoğu, arayüzü tarif etmek için JSX
kullanır:

{{JsxHelloWorldExample.jsx}}

Bu kod HTML gibi görünüyor, ama aslında bir JavaScript değişkenine
(`element`) bir değer atanıyor. Tarayıcı JSX'i doğrudan anlamaz -- Vite
projede otomatik olarak çalışan bir derleyici (Babel), bu kodu tarayıcının
anlayacağı sade bir JavaScript fonksiyon çağrısına çevirir. Bunu elle
yapman gerekmez, arka planda otomatik olur.

## HTML vs JSX

JSX, HTML'e benziyor ama aynı şey değil. En önemli farklardan biri: JSX,
sonunda bir JavaScript değeridir -- yani onu bir değişkene atayabilir,
bir fonksiyondan döndürebilir, bir listeye koyabilirsin. Düz HTML bunu
yapamaz.

Bir diğer fark: JSX'te bazı isimler HTML'dekinden farklıdır (birazdan
"Attribute'lar ve className" bölümünde göreceğiz). Ama genel görünüm
büyük ölçüde HTML ile aynı -- `<div>`, `<h1>`, `<button>` gibi etiketleri
tanıdık geleceksin.

## JSX İçinde JavaScript: Süslü Parantezler `{ }`

JSX'in en güçlü yanı, içine gerçek JavaScript kodu gömebilmen. Bunu tek
süslü parantez `{ }` ile yaparsın:

{{JsxExpressionExample.jsx}}

Süslü parantez içine, bir **sonuç üreten** herhangi bir şey yazabilirsin:
bir değişken (`{name}`), bir işlem (`{a + b}`), ya da bir fonksiyon
çağrısı (`{shout(...)}`). Sonuç üretmeyen şeyler (örneğin bir `if`
bloğu) buraya yazılamaz -- bunun neden böyle olduğunu birazdan
"Conditional Rendering'e Kısa Bir Bakış" bölümünde göreceğiz.

## Attribute'lar ve className

HTML'deki attribute'ları (`src`, `alt`, `class` gibi) JSX'te de
kullanırsın, ama iki önemli fark var:

{{JsxAttributesExample.jsx}}

Birincisi: HTML'deki `class` yerine JSX'te `className` yazılır (`class`,
JavaScript'te zaten başka bir anlama sahip olduğu için). İkincisi:
attribute değerlerini de, tıpkı metin içinde olduğu gibi, süslü parantez
`{ }` ile bir JavaScript ifadesine bağlayabilirsin.

## JSX Kuralları

JSX'in uyman gereken birkaç basit kuralı var:

{{JsxRulesExample.jsx}}

En önemlisi: bir JSX bloğunun **tek bir kök (root) elementi** olmalı --
iki kardeş element'i yan yana döndüremezsin. Bir `<div>` ile sarmalayabilir
ya da fazladan bir HTML elementi eklemek istemiyorsan `<> </>` ("Fragment")
kullanabilirsin. Diğer kurallar: attribute isimleri camelCase yazılır
(`onClick`, `tabIndex`) ve kendi kendine kapanan etiketler (`<img>`,
`<input>`) JSX'te mutlaka `/` ile kapatılmalı (`<img />`).

## Conditional Rendering'e Kısa Bir Bakış

Süslü parantez `{ }` içine yalnızca "sonuç üreten" bir ifade
koyabildiğini gördük -- bu yüzden JSX içinde doğrudan `if` yazamazsın
(`if`, bir sonuç üretmez, sadece bir kod bloğunu çalıştırıp çalıştırmayacağına
karar verir). Bunun yerine, sonuç üreten bir ternary (`? :`) kullanılır:

{{JsxConditionalIntroExample.jsx}}

Burada yalnızca kısa bir örnek gördük -- koşula göre farklı arayüz
göstermeyi ("conditional rendering"), State & Events kategorisindeki
"Conditional Rendering" dersinde çok daha detaylı işleyeceğiz.

## Özet ve Terimler Sözlüğü

JSX, HTML'e benzeyen ama aslında JavaScript olan bir söz dizimidir. Süslü
parantez `{ }` ile içine JavaScript ifadeleri gömebilirsin. `class` yerine
`className` kullanılır, her JSX bloğunun tek bir kök elementi olmalıdır,
ve kendi kendine kapanan etiketler `/` ile kapatılmalıdır.

**Terimler Sözlüğü**

**JSX** — HTML'e benzeyen, ama aslında JavaScript'in bir uzantısı olan
söz dizimi.

**Expression (İfade)** — Bir sonuç üreten kod parçası (örn. `a + b`);
JSX'te `{ }` içine yalnızca bu tür kod yazılabilir.

**className** — JSX'te HTML'deki `class` attribute'unun karşılığı.

**Fragment (`<> </>`)** — Fazladan bir HTML elementi eklemeden birden
fazla element'i tek bir kökte toplamaya yarayan JSX aracı.

**Root Element (Kök Element)** — Bir JSX bloğundaki en dıştaki, tek
element -- her JSX bloğunun tam olarak bir tane olmalıdır.

## Pratik Proje

Bu kategoride (What Is React?, Creating a React Application, JSX)
öğrendiğimiz kavramları bir arada kullanan, gerçek ve çalıştırılabilir bir
örnek proje var: **[React Fundamentals Demo](https://github.com/cdurgun/react-course-projects/tree/main/projects/react-fundamentals)**.

Proje; JSX, süslü parantez `{ }` ile JavaScript ifadeleri, attribute'lar ve
ternary ile kısa bir conditional rendering önizlemesini bir arada
gösteriyor. Bilgisayarına indirip çalıştırabilir, kodunu satır satır
inceleyebilirsin:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/react-fundamentals
npm run dev
```

`react-course-projects` deposu **npm workspaces** kullanır -- `npm install`
yalnızca bir kez, depo kökünde çalıştırılır ve tüm proje klasörleri ortak
bağımlılıkları paylaşır (her klasörde ayrı bir `node_modules` oluşmaz). Kök
dizinde `npm install`'ı daha önce çalıştırdıysan, doğrudan
`cd react-course-projects/projects/react-fundamentals` yapıp `npm run dev`
demen yeterli.
