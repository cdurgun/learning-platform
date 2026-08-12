# Bir React Projesi Oluşturmak

"React Nedir?" dersinde React'in ne olduğunu gördük. Bu derste, bilgisayarda
gerçek bir React projesi nasıl oluşturulur, buna bakacağız. Henüz React kodu
yazmıyoruz -- yalnızca projeyi kurup çalıştırmayı öğreniyoruz. Kod yazmaya
"JSX" dersinde başlayacağız.

## Node.js ve npm Nedir?

React projeleri, tarayıcıda değil, önce bilgisayarında çalışır (geliştirme
sırasında). Bunun için **Node.js**'e ihtiyacın var -- JavaScript'i
tarayıcı dışında çalıştırmanı sağlayan bir program.

Node.js ile birlikte **npm** (Node Package Manager) de gelir. npm, başka
insanların yazdığı hazır kod paketlerini ("kütüphane") projene eklemeni
sağlar -- React'in kendisi de böyle bir pakettir.

```bash
node --version
npm --version
```

Bu iki komut, bilgisayarında Node.js ve npm'in kurulu olup olmadığını,
kurulu ise hangi sürümde olduğunu gösterir.

## Vite ile Yeni Bir Proje Oluşturmak

Yeni bir React projesi oluşturmanın en kolay yolu **Vite** kullanmaktır.
Vite, projeyi senin için hazırlayan ve geliştirme sırasında hızlı çalışan
bir araçtır.

```bash
npm create vite@latest my-first-app -- --template react
cd my-first-app
npm install
```

- Birinci satır, `my-first-app` adında yeni bir React projesi oluşturur.
- İkinci satır, o klasöre girer.
- Üçüncü satır, projenin ihtiyaç duyduğu tüm paketleri indirir.

> 💡 Tip Eskiden bunun için "Create React App" (CRA) adlı bir araç
> kullanılırdı. CRA artık güncellenmiyor -- yeni bir proje kuracaksan Vite
> kullanmak daha doğru bir tercih.

## Proje Yapısı

`npm create vite` komutu bittiğinde, karşına şöyle bir klasör yapısı çıkar:

```text
my-first-app/
├── node_modules/     (indirilen tüm paketler burada -- elle dokunmazsın)
├── public/           (değişmeden kopyalanacak dosyalar, örn. favicon)
├── src/
│   ├── App.jsx       (uygulamanın ana component'i)
│   └── main.jsx       (uygulamanın başladığı ilk dosya)
├── index.html         (tarayıcının açtığı tek HTML dosyası)
└── package.json       (projenin adı, bağımlılıkları, komutları)
```

En çok vakit geçireceğin yer `src/` klasörü olacak -- kendi component'lerini
buraya yazacaksın.

## package.json Nedir?

`package.json`, bir React projesinin "kimlik kartı" gibidir. Projenin adını,
hangi paketlere ihtiyaç duyduğunu ve hangi komutları çalıştırabileceğini
listeler:

```json
{
  "name": "my-first-app",
  "scripts": {
    "dev": "vite",
    "build": "vite build"
  },
  "dependencies": {
    "react": "^19.0.0",
    "react-dom": "^19.0.0"
  }
}
```

`dependencies` altındaki `react` ve `react-dom`, projenin React'i
kullanabilmesi için indirdiği iki temel pakettir. `scripts` altındaki
`dev` ve `build`, aşağıda göreceğimiz komutların kısayollarıdır.

## Uygulamayı Çalıştırmak: npm run dev

Proje kurulduktan sonra, geliştirme sunucusunu başlatmak için:

```bash
npm run dev
```

Bu komut, terminalde bir adres gösterir (genelde
`http://localhost:5173`). Bu adresi tarayıcıda açtığında React
uygulamanı görürsün. `src/App.jsx` dosyasında bir değişiklik yaptığında,
tarayıcı **otomatik olarak** güncellenir -- sayfayı elle yenilemene
gerek kalmaz.

## Development vs Production

`npm run dev` ile çalıştırdığın sürüme **development** (geliştirme) sürümü
denir -- hızlı yeniden yükleme gibi geliştirmeyi kolaylaştıran özellikler
içerir, ama gerçek kullanıcılara sunmak için uygun değildir (daha büyük ve
daha yavaştır).

Uygulamayı gerçek kullanıcılara sunmaya hazır olduğunda:

```bash
npm run build
```

Bu komut, `dist/` adında bir klasör oluşturur -- küçültülmüş, hızlı çalışan,
**production** (yayın) için hazır dosyalar içerir. "Production" ve
"Deployment" konusuna kursun sonlarında, gerçek bir örnekle tekrar
döneceğiz.

## Özet ve Terimler Sözlüğü

Bir React projesi kurmak için Node.js/npm gerekir, proje oluşturmak için
Vite kullanılır, `npm run dev` ile geliştirme sırasında çalıştırılır,
`npm run build` ile yayına hazır hâle getirilir.

**Terimler Sözlüğü**

**Node.js** — JavaScript'i tarayıcı dışında çalıştırmayı sağlayan program.

**npm (Node Package Manager)** — Hazır kod paketlerini projene eklemeni
sağlayan araç.

**Vite** — Yeni bir React projesi oluşturmak ve geliştirme sırasında hızlı
çalıştırmak için kullanılan araç.

**`package.json`** — Bir projenin adını, bağımlılıklarını ve
komutlarını listeleyen dosya.

**Development (Geliştirme)** — Kodu yazarken kullandığın, hızlı ama
optimize edilmemiş çalışma modu.

**Production (Yayın)** — Gerçek kullanıcılara sunulan, küçültülmüş ve
optimize edilmiş sürüm.
