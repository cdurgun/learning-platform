# useMemo & useCallback

Şimdiye kadar `useState`, `useEffect` ve `useRef`'i gördük. Bu ders, iki
performans hook'unu -- `useMemo` ve `useCallback` -- anlatıyor. Bu ikisi
diğerlerinden biraz farklı: kullanmayı bilmek kadar, NE ZAMAN
kullanmaman gerektiğini bilmek de önemli.

## Memoization Nedir?

**Memoization**, bir hesaplamanın sonucunu hafızada tutup, aynı girdilerle
tekrar istenirse hesaplamayı TEKRARLAMADAN o sonucu döndürme tekniğidir.
React'te component'ler sık sık yeniden render olur; her render'da aynı
pahalı hesaplamayı ya da aynı fonksiyonu yeniden oluşturmak, bazı
durumlarda gereksiz bir maliyet olabilir -- `useMemo` ve `useCallback` bu
maliyeti önlemek için var.

## useMemo ile Hesaplama Sonucunu Önbelleğe Almak

`useMemo`, bir hesaplamanın SONUCUNU önbelleğe alır:

{{UseMemoBasicExample.jsx}}

`useMemo(() => slowSquare(number), [number])`, `number` değişmediği
sürece `slowSquare`'i TEKRAR ÇALIŞTIRMAZ -- önceki sonucu döndürür. Temayı
değiştirmek component'i yeniden render eder, ama `number` aynı kaldığı
için yavaş hesaplama tekrar çalışmaz.

## useMemo ile Nesne Referansını Sabit Tutmak

`useMemo`, yalnızca "pahalı" hesaplamalar için değil, bir nesnenin/dizinin
REFERANSINI (kimliğini) render'lar arasında sabit tutmak için de
kullanılır:

{{ObjectMemoizationExample.jsx}}

`useMemo` olmadan, her render'da `{ theme: "dark", fontSize: 16 }` YENİ
bir nesne olarak oluşur -- içeriği aynı olsa bile, JavaScript'te iki ayrı
nesne `===` ile karşılaştırıldığında eşit sayılmaz. `useMemo`, dependency
array değişmediği sürece AYNI nesneyi döndürür.

## useCallback ile Fonksiyon Referansını Sabit Tutmak

`useCallback`, `useMemo`'ya çok benzer, ama bir DEĞER yerine bir
FONKSİYONU önbelleğe alır:

{{UseCallbackBasicExample.jsx}}

`useCallback` olmadan, her render'da `handleClick` YENİ bir fonksiyon
olarak oluşturulur. `useCallback`, dependency array (`[count]`)
değişmediği sürece AYNI fonksiyon referansını korur.

## Ne Zaman KULLANILMAMALI?

`useMemo` ve `useCallback`'in kendi maliyeti var -- dependency array'i
karşılaştırmak ve sonucu hafızada tutmak. Basit, hızlı işlemler için bu
maliyet, kazandırdığından daha pahalı olabilir:

{{WhenNotToUseMemoExample.jsx}}

`count * 2` gibi basit bir işlemi `useMemo` ile sarmalamanın hiçbir
faydası yok -- işlem zaten neredeyse anlık. `useMemo`/`useCallback`'i
yalnızca gerçekten pahalı bir hesaplama varsa, ya da bir değerin/
fonksiyonun referansının sabit kalması (örneğin başka bir hook'un
dependency array'inde kullanılacağı için) gerektiğinde kullan. Aksi
halde kodun daha karmaşık, ama daha hızlı OLMAYAN bir hâli ortaya çıkar --
buna "erken optimizasyon" (premature optimization) denir.

## Özet ve Terimler Sözlüğü

`useMemo`, bir hesaplamanın sonucunu ya da bir nesnenin referansını
önbelleğe alır; `useCallback` aynı şeyi bir fonksiyon için yapar. İkisi
de dependency array değişmediği sürece önceki sonucu/referansı döndürür.
Basit, hızlı işlemler için bu hook'lara gerek yok -- kendi maliyetleri,
çözdükleri sorundan daha büyük olabilir.

**Terimler Sözlüğü**

**Memoization** — Bir hesaplamanın sonucunu hafızada tutup, aynı
girdilerle tekrar istendiğinde hesaplamayı tekrarlamadan döndürme
tekniği.

**`useMemo`** — Bir hesaplamanın sonucunu ya da bir nesne/dizi
referansını memoize eden hook.

**`useCallback`** — Bir fonksiyon referansını memoize eden hook.

**Premature Optimization (Erken Optimizasyon)** — Gerçekten gerekmeden,
performans kazancı sağlamayan ama kodu karmaşıklaştıran bir optimizasyon
yapmak.
