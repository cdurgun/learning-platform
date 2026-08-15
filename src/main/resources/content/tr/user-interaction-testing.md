# User Interaction Testing

Component Testing dersinde, bir component'in DOĞRU render olduğunu
test etmeyi öğrendik -- ama React uygulamalarının çoğu, kullanıcı bir
şeye TIKLAYANA, bir şey YAZANA ya da bir form GÖNDERENE kadar
"durağan"dır. Bu ders, kullanıcı ETKİLEŞİMLERİNİ test etmeyi anlatıyor.

## user-event ile Gerçekçi Etkileşim Simülasyonu

React Testing Library ile birlikte, kullanıcı etkileşimlerini simüle
etmek için `@testing-library/user-event` paketi kullanılır:

```bash
npm install -D @testing-library/user-event
```

RTL'in kendi `fireEvent` API'si de bir tıklama/yazma tetikleyebilir,
ama `fireEvent` tek bir DOM olayını (`click` gibi) doğrudan gönderir.
`user-event` ise gerçek bir kullanıcının tıklarken/yazarken tetiklediği
ARA adımları da (hover, focus, pointer olayları) simüle eder -- bu
yüzden RTL'in resmî dokümantasyonu artık `fireEvent` yerine
`user-event`'i ÖNERİYOR.

## Tıklamayı Test Etmek

State & Events dersindeki `Counter` component'ini, bu kez gerçek bir
tıklama simüle ederek test edelim:

{{UserEventClickExample.jsx}}

`userEvent.setup()`, bir "kullanıcı" nesnesi oluşturur. Bu nesnenin
metotları (`click`, `type` gibi) HER ZAMAN asenkrondur ve `await`
edilmelidir -- unutursak test, tıklama tamamlanmadan bir sonraki
satıra geçer ve yanlış (eski) bir DOM durumunu kontrol eder.

## Yazmayı Test Etmek

Forms dersindeki controlled input deseni, `user.type` ile test edilir:

{{UserEventTypingExample.jsx}}

`user.type(input, "Ada")`, verilen metni HARF HARF yazar -- her tuş
vuruşu, controlled component'teki `onChange`'i gerçek bir klavyeyle
yazmaya çok benzer şekilde tetikler. Testin sonunda hem ekrandaki
metni (`getByText`) hem input'un kendi değerini (`toHaveValue`)
kontrol ediyoruz.

## Form Gönderimini Test Etmek

Bir formu doldurup göndermek, `user.type` ve `user.click`'in birlikte
kullanıldığı en yaygın senaryodur:

{{FormSubmissionTestExample.jsx}}

`vi.fn()`, gerçek bir prop yerine geçen SAHTE bir fonksiyon
oluşturur -- component'in dışına hiçbir gerçek istek gitmeden, bu
fonksiyonun hangi ARGÜMANLARLA, KAÇ KEZ çağrıldığını doğrulayabiliriz.
`toHaveBeenCalledWith(...)` ve `toHaveBeenCalledTimes(...)`, bu sahte
fonksiyonlara özel matcher'lardır.

## Asenkron UI Güncellemelerini Test Etmek

Hooks dersindeki `useEffect` deseniyle, bir component zaman içinde
KENDİLİĞİNDEN güncellenebilir (bir fetch isteğinin tamamlanması gibi).
Bu tür güncellemeleri test etmek için `findBy*` sorguları kullanılır:

{{AsyncUiUpdateTestExample.jsx}}

`getByText` (ve `queryByText`), DOM'u SADECE O AN kontrol eder --
eleman henüz yoksa test başarısız olur. `findByText` ise ASENKRON'dur:
eleman hemen yoksa hata fırlatmaz, belirli bir süre boyunca (varsayılan
1000ms) tekrar tekrar dener ve eleman görününce test'e devam eder.
DOM'u zamanla değişen (fetch, timer, animasyon sonrası) her şeyi test
etmenin doğru yolu budur; aynı amaç için `waitFor(...)` de kullanılabilir.

## Özet ve Terimler Sözlüğü

`@testing-library/user-event`, `fireEvent`'ten daha GERÇEKÇİ bir
etkileşim simülasyonu sunar; `userEvent.setup()`'tan dönen nesnenin
`click`/`type` gibi metotları her zaman `await` edilmelidir. `vi.fn()`
ile oluşturulan sahte fonksiyonlar, bir callback prop'un doğru
argümanlarla çağrıldığını doğrulamak için kullanılır. Zamanla
değişen (asenkron) DOM güncellemeleri, `getByText` yerine
`findByText`/`waitFor` ile test edilir.

**Terimler Sözlüğü**

**user-event** — Kullanıcı etkileşimlerini (tıklama, yazma), gerçek
tarayıcı davranışına yakın şekilde simüle eden kütüphane.

**Mock Fonksiyon** — `vi.fn()` ile oluşturulan, gerçek bir
fonksiyonun yerine geçip çağrılma bilgisini (argümanlar, sayı) kaydeden
sahte fonksiyon.

**Asenkron Sorgu** — `findBy*` gibi, elemanın DOM'da görünmesini bir
süre BEKLEYEN sorgu türü.

## Pratik Proje

Bu kategoride (Component Testing, User Interaction Testing) öğrendiğimiz
kavramları bir arada kullanan, gerçek ve çalıştırılabilir bir örnek
proje var: **[Testing Demo](https://github.com/cdurgun/react-course-projects/tree/main/projects/testing)**
-- önceki kategorilerden tanıdık, arama yapılabilen bir kurs listesi
ve bir kayıt formu, ama bu kez odak uygulamanın kendisinden çok onu
doğrulayan gerçek Vitest testlerinde.

Proje; `SearchBar`, `CourseList` ve `EnrollForm` component'lerinin her
birini kendi `.test.jsx` dosyasında (`getByLabelText`+`userEvent.type`,
`getByText`/`queryByText` ile filtreleme, `vi.fn()`+`findByText` ile
form gönderimi) AYRI AYRI test etmeyi, ve bunların hepsini App
içinde lifting state up ile bağlayan bütünü tek bir integration
testiyle (`App.test.jsx`) doğrulamayı gösteriyor. Bilgisayarına
indirip çalıştırabilir, testleri satır satır inceleyebilirsin:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/testing
npm test
```

`react-course-projects` deposu **npm workspaces** kullanır -- `npm install`
yalnızca bir kez, depo kökünde çalıştırılır ve tüm proje klasörleri ortak
bağımlılıkları paylaşır (her klasörde ayrı bir `node_modules` oluşmaz). Kök
dizinde `npm install`'ı daha önce çalıştırdıysan, doğrudan
`cd react-course-projects/projects/testing` yapıp `npm test` demen yeterli.
