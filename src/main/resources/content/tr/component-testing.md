# Component Testing

Şimdiye kadar yazdığımız her component'i TARAYICIDA elle tıklayarak
kontrol ettik. Bu, birkaç component için yeterli olsa da, uygulama
büyüdükçe her değişiklikten sonra her ekranı elle kontrol etmek hem
yavaş hem de güvenilmez. Bu ders, component'lerin doğru çalıştığını
OTOMATİK olarak, kod ile doğrulamayı öğretiyor.

## Vitest ve React Testing Library Kurulumu

Bu kursta iki kütüphane kullanıyoruz:

- **Vitest** — testleri ÇALIŞTIRAN araç (`describe`, `it`, `expect`
  gibi fonksiyonları sağlar). Vite tabanlı projeler için tasarlandığı
  için ek bir yapılandırmaya neredeyse hiç ihtiyaç duymaz.
- **React Testing Library (RTL)** — component'leri sahte bir DOM'a
  (jsdom) YERLEŞTİRİP, o DOM'u gerçek bir kullanıcının göreceği
  şekilde SORGULAMAMIZI sağlayan kütüphane.

Bir Vite projesine eklemek için:

```bash
npm install -D vitest @testing-library/react @testing-library/jest-dom jsdom
```

`vite.config.js` içine bir `test` bloğu eklenir:

```js
export default defineConfig({
  plugins: [react()],
  test: {
    environment: "jsdom",
    setupFiles: ["./src/setupTests.js"],
    globals: true,
  },
});
```

`environment: "jsdom"` testlerin gerçek bir tarayıcı yerine, Node
içinde ÇALIŞAN sahte bir DOM'da koşmasını sağlar. `setupFiles`
içindeki dosyada tek bir satır yeterli:

```js
import "@testing-library/jest-dom/vitest";
```

Bu satır, birazdan göreceğimiz `toBeInTheDocument()` gibi ek
doğrulamaları (matcher) Vitest'in `expect`'ine EKLER.

## render() ve screen ile İlk Testimiz

Bir testin en temel iskeleti; component'i sahte DOM'a yerleştirmek
ve içinde beklediğimiz bir şeyin olduğunu doğrulamaktan oluşur:

{{RenderAndGetByTextExample.jsx}}

`describe`, ilgili testleri bir grup altında toplar; `it` (ya da
`test`), tek bir test senaryosunu tanımlar. `render(<Counter />)`,
component'i jsdom'a yerleştirir. `screen`, o anki DOM'u SORGULAMAK
için kullanılır -- `getByText`, verilen metni içeren bir eleman
bulamazsa test ANINDA başarısız olur.

## getByRole ve getByLabelText ile Sorgulama

`getByText` her zaman en doğru sorgu değildir -- RTL, gerçek
kullanıcıların (ve ekran okuyucuların) sayfayı nasıl ALGILADIĞINA
daha yakın sorgular sunar:

{{GetByRoleAndLabelExample.jsx}}

`getByRole("button", { name: /log in/i })`, bir `<button>` elemanını
ERİŞİLEBİLİRLİK rolünden ve görünen adından bulur -- RTL'in resmî
dokümantasyonu, mümkün olduğunda `getByRole`'ü ÖNCELİKLİ sorgu olarak
önerir. `getByLabelText("Name")`, `<label htmlFor="name">` ile
eşleşen input'u, id veya test-id eklemeye gerek kalmadan bulur.

## jest-dom Matcher'ları

Kurulumda eklediğimiz `@testing-library/jest-dom/vitest`, `expect`'e
DOM'a özel yeni doğrulamalar ekler:

{{JestDomMatchersExample.jsx}}

`toBeDisabled()` ve `toBeEnabled()`, bir elemanın `disabled`
özniteliğini kontrol eder; `toBeInTheDocument()` bir elemanın DOM'da
var olup olmadığını doğrular. Bunlar düz Vitest'te YOKTUR -- jest-dom
paketinin eklediği, DOM testleri için özel olarak tasarlanmış
matcher'lardır.

## Koşullu Render'ı Test Etmek

State & Events dersinde gördüğümüz koşullu render deseni, en sık test
edilen senaryolardan biridir -- her durumun DOĞRU metni gösterdiğini
ayrı ayrı doğrularız:

{{ConditionalRenderingTestExample.jsx}}

Üç ayrı `it` bloğu, `status` prop'unun üç farklı değeri için
component'i ayrı ayrı render edip doğru mesajın göründüğünü
kontrol ediyor. İlk testte ayrıca `queryByText` kullanılıyor:
`getByText`'in aksine, eleman bulunamazsa hata FIRLATMAZ, `null`
döner -- bu yüzden bir şeyin EKRANDA OLMADIĞINI doğrulamak için
`getByText` değil `queryByText` kullanılır.

## Özet ve Terimler Sözlüğü

Vitest testleri ÇALIŞTIRIR, React Testing Library component'leri
sahte bir DOM'a yerleştirip SORGULAMAMIZI sağlar. `render()` bir
component'i DOM'a yerleştirir; `screen` o DOM'u sorgulamak için
kullanılır. `getByRole`/`getByLabelText`/`getByText`, bir eleman
bulamazsa hata fırlatır; `queryBy*` varyantları bulamazsa `null`
döner ve bir şeyin EKRANDA OLMADIĞINI doğrulamak için kullanılır.
`@testing-library/jest-dom`, `toBeInTheDocument()` gibi DOM'a özel
matcher'lar ekler.

**Terimler Sözlüğü**

**Test Runner** — Testleri bulup çalıştıran, sonuçları raporlayan araç
(Vitest).

**jsdom** — Node içinde çalışan, gerçek bir tarayıcıyı SİMÜLE eden
sahte bir DOM ortamı.

**Matcher** — `expect(...)`'ten sonra zincirlenen, belirli bir koşulu
doğrulayan fonksiyon (`toBeInTheDocument()`, `toHaveValue()` gibi).
