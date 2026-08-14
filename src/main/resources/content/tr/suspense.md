# Suspense

Lazy Loading dersinde `Suspense`'i yalnızca `lazy()` ile birlikte
gördük. Bu ders, `Suspense`'in kendisine -- ne yaptığına, nasıl iç içe
kullanılabileceğine, ve neyi OTOMATİK OLARAK yapmadığına -- daha
yakından bakıyor.

## fallback Prop'u

`Suspense`, İÇİNDEKİ bir şey HENÜZ hazır değilken bir `fallback`
gösterir:

{{SuspenseFallbackExample.jsx}}

`fallback`, yalnızca bir metin değil, HERHANGİ bir JSX olabilir -- bir
spinner, bir iskelet (skeleton) ekran, ya da başka bir component.
İçindeki component (burada `CourseDetails`) hazır olduğunda, `fallback`
otomatik olarak gerçek içerikle DEĞİŞTİRİLİR.

## İç İçe Suspense Sınırları

Birden fazla `Suspense`, farklı seviyelerde iç içe kullanılabilir:

{{NestedSuspenseExample.jsx}}

Dıştaki `Suspense`, `CourseHeader` yüklenene kadar TÜM sayfa için bir
fallback gösterir. `CourseHeader` göründükten sonra, İÇTEKİ `Suspense`
yalnızca `CourseReviews`'un yerini kaplar -- sayfanın geri kalanı
tekrar "loading" durumuna DÖNMEZ. Bu, kullanıcıya daha akıcı bir
deneyim sunar: her şeyin birden kaybolup gelmesi yerine, yalnızca
gerçekten bekleyen kısım "loading" gösterir.

## use() Hook'u ile Suspense

React 19'daki `use()` hook'u, bir Promise'i doğrudan Suspense ile
entegre EDEBİLİR:

{{UsePromiseWithSuspenseExample.jsx}}

`use()`, diğer hook'ların aksine KOŞULLU olarak da çağrılabilir. Bir
Promise verildiğinde, henüz ÇÖZÜLMEDİYSE React'e "beklemem gerekiyor"
der -- bu, en yakın `Suspense`'in `fallback`'ini gösterir; Promise
çözülünce `use()` gerçek değeri döner ve component normal render
edilir.

## Suspense'in Otomatik Yapmadıkları

Önemli bir gotcha: her asenkron işlem, Suspense'i otomatik tetiklemez:

{{SuspenseLimitationsExample.jsx}}

API & Data Fetching dersindeki `useEffect` + `fetch` deseni, Suspense'i
OTOMATİK OLARAK tetiklemez -- Suspense yalnızca `use()` gibi, React'in
DOĞRUDAN tanıdığı bir Promise kaynağıyla çalışır. `useEffect` içinde
`fetch` kullanan bir component, kendi `loading` state'ini KENDİSİ
yönetmeye devam etmeli.

## Özet ve Terimler Sözlüğü

`Suspense`, içindeki bir şey henüz hazır değilken bir `fallback`
gösterir; içerik hazır olunca otomatik olarak değiştirilir. Birden
fazla `Suspense`, farklı granülaritede yükleme durumları göstermek için
iç içe kullanılabilir. React 19'daki `use()` hook'u, bir Promise'i
Suspense ile entegre eder. Ama `useEffect` + `fetch` gibi "klasik" veri
çekme desenleri Suspense'i OTOMATİK tetiklemez -- yalnızca `use()` gibi
React'in doğrudan desteklediği kaynaklar tetikler.

**Terimler Sözlüğü**

**Suspense** — İçindeki bir kaynak (lazy component, Promise) henüz
hazır değilken bir fallback UI gösteren React component'i.

**Suspense Boundary (Suspense Sınırı)** — Bir `<Suspense>` component'inin
kapsadığı, kendi fallback'ine sahip alan.
