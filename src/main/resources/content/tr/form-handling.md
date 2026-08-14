# Form Handling

Controlled Components dersinde tek bir input'u state'e bağlamayı
gördük. Bu ders, gerçek bir formu -- gönderimi, birden fazla alanı,
doğrulamayı ve hata mesajlarını -- baştan sona ele alıyor.

## Formu Göndermek: onSubmit ile Değerleri Toplamak

Events dersinde gördüğümüz `onSubmit`, formlarda genellikle state'teki
değeri kullanmak için kullanılır:

{{FormSubmitExample.jsx}}

Input controlled olduğu için, form gönderildiğinde `name` state'i zaten
güncel -- ayrıca DOM'dan değeri okumaya gerek yok, doğrudan state'i
kullanıyoruz.

## Birden Fazla Alanı Yönetmek

Bir formda birden fazla input olduğunda, her biri için ayrı bir
`useState` açmak yerine, hepsini TEK bir state nesnesinde toplamak daha
yönetilebilir:

{{MultiFieldFormExample.jsx}}

`event.target.name`, değişen input'un `name` attribute'unu verir --
`[name]: value` (computed property name) ile, TEK bir `handleChange`
fonksiyonuyla hangi alanın değiştiğini anlayıp yalnızca o alanı
güncelleyebiliyoruz. Bu, State dersinde gördüğümüz immutability kuralına
uygun: `{ ...formData, [name]: value }`, eski nesneyi kopyalayıp yalnızca
bir alanı değiştiren YENİ bir nesne oluşturuyor.

## Basit Validation (Doğrulama)

Formu göndermeden önce, girilen değerlerin geçerli olup olmadığını
kontrol etmek isteriz -- buna **validation** denir:

{{RequiredFieldValidationExample.jsx}}

Gönderim anında (`handleSubmit` içinde) değeri kontrol ediyoruz; boşsa
`error` state'ine bir mesaj yazıp fonksiyondan erken çıkıyoruz (`return`),
formu asıl "göndermiyoruz".

## Hata Mesajları Göstermek

Bir hata bulunduğunda, kullanıcıya bunu göstermek gerekir -- Conditional
Rendering dersinde gördüğümüz `&&` deseni burada tam yerine oturuyor:

{{EmailFormatValidationExample.jsx}}

`error` state'i doluysa (boş string değilse), `{error && <p>...}` ifadesi
hata mesajını render eder; `error` boşsa hiçbir şey render edilmez. Bu
örnekte ayrıca basit bir e-posta biçimi kontrolü de var -- bir regex
(`emailPattern.test(email)`) ile.

## Gönderim Öncesi Tüm Formu Doğrulamak

Birden fazla alanlı bir formda, her alanın kendi hatasını göstermesi
gerekebilir:

{{FullFormValidationExample.jsx}}

`validate()` fonksiyonu, her alan için ayrı bir hata mesajı üretip
hepsini TEK bir nesnede (`newErrors`) topluyor. Bu nesnenin hiç anahtarı
yoksa (`Object.keys(newErrors).length === 0`), form geçerli demektir. Her
input'un altında yalnızca KENDİ hatası (`errors.name`, `errors.email`)
gösteriliyor -- bu da yine `&&` ile conditional rendering.

## Özet ve Terimler Sözlüğü

Bir form, `onSubmit` ile gönderilir; controlled input'lar sayesinde
gönderim anında değerler zaten state'te hazır bulunur. Birden fazla alan
tek bir state nesnesinde tutulup `event.target.name` ile hangi alanın
değiştiği anlaşılır. Validation, genellikle gönderim anında yapılır;
hatalar bir state'te (tek bir mesaj ya da alan başına bir nesne olarak)
tutulup `&&` ile conditional rendering'le gösterilir.

**Terimler Sözlüğü**

**Validation (Doğrulama)** — Girilen değerlerin beklenen kurallara uyup
uymadığını kontrol etme süreci.

**Computed Property Name** — `{ [name]: value }` gibi, bir nesnenin
anahtarını bir değişkenden dinamik olarak belirleme söz dizimi.

## Pratik Proje

Bu kategoride (Controlled Components, Form Handling) öğrendiğimiz
kavramları bir arada kullanan, gerçek ve çalıştırılabilir bir örnek
proje var: **[Forms Demo](https://github.com/cdurgun/react-course-projects/tree/forms-v1/projects/forms)** --
basit bir kayıt (sign up) formu.

Proje; `value`+`onChange` ile controlled input'ları, birden fazla alanı
tek bir state nesnesinde yönetmeyi, `onSubmit`+`preventDefault`'u, ve
gönderim öncesi tüm formu doğrulayıp her alanın kendi hatasını
göstermeyi bir arada gösteriyor. Bilgisayarına indirip çalıştırabilir,
kodunu satır satır inceleyebilirsin:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/forms
npm run dev
```

`react-course-projects` deposu **npm workspaces** kullanır -- `npm install`
yalnızca bir kez, depo kökünde çalıştırılır ve tüm proje klasörleri ortak
bağımlılıkları paylaşır (her klasörde ayrı bir `node_modules` oluşmaz). Kök
dizinde `npm install`'ı daha önce çalıştırdıysan, doğrudan
`cd react-course-projects/projects/forms` yapıp `npm run dev` demen
yeterli.
