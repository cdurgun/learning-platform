# Context API

Sharing State dersinde, derin bir component ağacında props drilling'in
nasıl bir soruna dönüştüğünü gördük. Bu ders, React'in bu soruna yerleşik
çözümünü -- **Context API**'yi -- anlatıyor.

## createContext ile Bir Context Oluşturmak

Context, ağacın herhangi bir yerinden, props geçirmeden okunabilecek bir
değer taşıyan bir "kutu"dur:

{{CreateContextExample.jsx}}

`createContext("light")`, bir `ThemeContext` oluşturur -- parantez
içindeki değer, bir Provider bulunmadığında kullanılacak VARSAYILAN
değerdir. `<ThemeContext.Provider value="dark">`, içindeki tüm ağaç
için bu değeri `"dark"` olarak EZER (override eder). `useContext(ThemeContext)`,
en yakın Provider'ın değerini okur.

## Provider Yokken: Varsayılan Değer

Provider her zaman gerekli değil -- bir Provider yoksa, `useContext`
`createContext`'e verilen varsayılan değeri döner:

{{DefaultValueExample.jsx}}

Bu örnekte hiç `Provider` yok; `ThemedButton`, `createContext("light")`
ile verilen `"light"` değerini alıyor. Provider, yalnızca o varsayılanı
DEĞİŞTİRMEK istediğinde gerekiyor.

## Props Drilling'i Context ile Çözmek

Sharing State dersindeki derin ağaç örneğini, bu sefer Context ile
yeniden yazalım:

{{AvoidingPropsDrillingExample.jsx}}

`Level1`, `Level2`, `Level3`'ün HİÇBİRİ artık `user` prop'unu bilmiyor
bile -- yalnızca en dipteki `Level4`, `UserContext`'ten DOĞRUDAN
okuyor. Ara katmanlardan hiçbir şey geçirmemize gerek kalmadı.

## Context İçinde State Taşımak

Context yalnızca sabit bir değer taşımaz -- state'in kendisini VE onu
güncelleyen fonksiyonu birlikte taşıyabilir:

{{ContextWithStateExample.jsx}}

`value={{ items, addItem }}` ile Provider'a bir NESNE veriyoruz --
hem güncel `items` listesini hem de onu güncelleyen `addItem`
fonksiyonunu. Bu, gerçek uygulamalarda en sık görülen Context kullanım
biçimi.

## Context'i Bir Custom Hook'a Sarmalamak

Hooks dersindeki custom hook deseni, Context ile birlikte çok yaygın
kullanılan bir kalıp oluşturuyor:

{{CustomContextHookExample.jsx}}

`useTheme()`, `useContext(ThemeContext)`'i SARMALAYIP daha temiz bir
API sunuyor -- kullanan component, "context" kavramıyla hiç uğraşmadan
`useTheme()` çağırıyor, tıpkı yerleşik bir hook gibi. Provider dışında
kullanılırsa hata fırlatması, yanlış kullanımı erken yakalamamızı
sağlıyor.

## Özet ve Terimler Sözlüğü

`createContext()`, ağacın herhangi bir yerinden okunabilecek bir değer
oluşturur; `Provider`, bu değeri belirli bir alt ağaç için EZER;
`useContext()`, en yakın Provider'ın değerini okur. Provider yoksa,
`createContext`'e verilen varsayılan değer kullanılır. Context, sabit
bir değer taşıyabildiği gibi, state VE onu güncelleyen fonksiyonları
birlikte de taşıyabilir -- bu, `useContext`'i bir custom hook'a
sarmalamakla (`useTheme()` gibi) birleştiğinde, React'te "global"
sayılabilecek state'i yönetmenin en yaygın yoludur.

**Terimler Sözlüğü**

**Context** — Ağacın herhangi bir yerinden, props geçirmeden okunabilen
bir değer taşıyan React yapısı.

**Provider** — Bir Context'in değerini, kendi altındaki tüm ağaç için
belirleyen component.

## Pratik Proje

Bu kategoride (Sharing State, Context API) öğrendiğimiz kavramları bir
arada kullanan, gerçek ve çalıştırılabilir bir örnek proje var:
**[State Management Demo](https://github.com/cdurgun/react-course-projects/tree/state-management-v1/projects/state-management)**
-- arama ile filtrelenebilen, favorilere eklenebilen bir kurs listesi
uygulaması.

Proje; arama metnini ortak parent'ta tutup (lifting state up) hem arama
kutusuna hem sonuç listesine props ile aktarmayı, favori kursları bir
`FavoritesContext` ile (createContext + Provider + custom hook) HİÇBİR
props drilling olmadan ağacın farklı yerlerinden (kurs listesi VE
başlıktaki favori sayacı) okumayı bir arada gösteriyor. Bilgisayarına
indirip çalıştırabilir, kodunu satır satır inceleyebilirsin:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/state-management
npm run dev
```

`react-course-projects` deposu **npm workspaces** kullanır -- `npm install`
yalnızca bir kez, depo kökünde çalıştırılır ve tüm proje klasörleri ortak
bağımlılıkları paylaşır (her klasörde ayrı bir `node_modules` oluşmaz). Kök
dizinde `npm install`'ı daha önce çalıştırdıysan, doğrudan
`cd react-course-projects/projects/state-management` yapıp `npm run dev`
demen yeterli.
