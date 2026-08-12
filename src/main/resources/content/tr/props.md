# Props

Components dersinde `Button` component'ini üç kez kullanmıştık, ama üçü de
birbirinin aynısıydı. Peki her kullanımda farklı bir metin, farklı bir
renk göstermek istersek? Bunun cevabı **props**. Bu ders, bir component'e
dışarıdan veri göndermenin yolunu basit örneklerle anlatıyor.

## Props Nedir?

Props (properties), bir component'e dışarıdan veri göndermenin yoludur --
tıpkı bir HTML etiketine attribute vermek gibi (JSX dersindeki "Attribute'lar
ve className" bölümünü hatırla), ama burada değer, component fonksiyonuna
bir parametre olarak ulaşır.

## Parent'tan Child'a Veri Göndermek

Bir component'i kullanırken (yani onu "render" ederken), ona attribute
gibi değerler verebilirsin -- bunlar, o component'in props'u olur:

{{BasicPropsExample.jsx}}

Burada `App`, `Greeting`'i kullanan (yani "parent") component; `Greeting`
ise kullanılan (yani "child") component. `name="Ayşe"` yazarak, `Greeting`'e
`name` adında bir prop gönderiyoruz.

## Birden Fazla Prop Kullanmak

Bir component'e istediğin kadar prop gönderebilirsin:

{{MultiplePropsExample.jsx}}

Her prop, `props` nesnesinin ayrı bir alanı olarak component'e ulaşır --
`props.name`, `props.age`, `props.city` gibi.

## Destructuring ile Props Okumak

Her yerde `props.name` yazmak yerine, çoğu React kodunda destructuring
kullanılır:

{{PropsDestructuringExample.jsx}}

İki yazım da tamamen aynı işi yapar -- destructuring, yalnızca `props.`
tekrarını ortadan kaldırıp kodu biraz daha kısa yapar. Yaygın kullanılan
biçim bu -- ilerleyen derslerde de bunu kullanacağız.

## Varsayılan Değerler (Default Props)

Bir prop hiç gönderilmezse ne olur? Destructuring sırasında bir varsayılan
değer tanımlayabilirsin:

{{DefaultPropsExample.jsx}}

`name = "Misafir"`, normal JavaScript fonksiyon parametrelerindeki
varsayılan değerlerle tamamen aynı fikir -- `name` gönderilmezse, `Misafir`
kullanılır.

## Props vs Normal Fonksiyon Parametreleri

Props, aslında sıradan bir fonksiyon parametresinden fazlası değil --
React'in özel bir mekanizması yok burada. Fark yalnızca kullanım şeklinde:
normal bir fonksiyonu `Greeting({ name: "Ayşe" })` diye çağırırken, bir
component'i JSX içinde `<Greeting name="Ayşe" />` diye "çağırırsın". Ayrıca
önemli bir kural var: props'lar **salt okunurdur** (read-only) -- bir
component, kendisine gelen bir prop'u asla değiştirmemelidir. Veriyi
değiştirmek istiyorsan, bunun yolu "state" -- onu State & Events
kategorisinde göreceğiz.

## Özet ve Terimler Sözlüğü

Props, bir component'e dışarıdan veri göndermenin yoludur. Parent
component, child'a attribute gibi değer verir; child bunu `props` (ya da
destructuring ile doğrudan değişken olarak) okur. Bir prop gönderilmezse,
varsayılan bir değer tanımlanabilir. Props salt okunurdur.

**Terimler Sözlüğü**

**Props** — Bir component'e dışarıdan gönderilen, salt okunur veriler.

**Parent Component** — Başka bir component'i kullanan (render eden)
component.

**Child Component** — Bir parent component tarafından kullanılan
component.

**Destructuring** — Bir nesnenin alanlarını doğrudan değişken olarak
çıkarma söz dizimi (`{ name, age }` gibi).

**Default Prop (Varsayılan Değer)** — Bir prop gönderilmediğinde
kullanılacak, önceden tanımlanmış değer.
