# Controlled Components

Events dersinde `onChange`'i, State dersinde `useState`'i ayrı ayrı
gördük. Bu ders, ikisini bir araya getiren ve React'te form yazmanın
temel deseni olan **controlled component**'i anlatıyor.

## Controlled Component Nedir?

Normalde bir `<input>`, kendi değerini kendi içinde (tarayıcının DOM'unda)
tutar -- React bunun farkında bile olmayabilir. Bir **controlled
component**'te ise input'un değeri React'in state'i tarafından
BELİRLENİR: input, kendi başına bir değer tutmaz, değerini her zaman
state'ten alır.

## value ile Input'u State'e Bağlamak

Bir input'u controlled yapmanın ilk adımı, `value` attribute'unu bir
state değişkenine bağlamak:

{{ControlledInputExample.jsx}}

`value={text}` yazdığımız için, input'ta görünen değer HER ZAMAN `text`
state'inin o anki değeri. Ama tek başına bu yeterli değil -- kullanıcı
yazı yazdığında da bir şey olması lazım, bunu bir sonraki bölümde
görüyoruz.

## onChange ile State'i Güncellemek

`value` tek başına input'u salt-okunur yapar -- kullanıcı hiçbir şey
yazamaz. State'i güncel tutmak için `onChange`'i de eklemen gerekir:

{{WhyControlledMattersExample.jsx}}

Her tuş vuruşunda `onChange` çalışır, `setText` state'i günceller, React
yeniden render eder, ve input'un `value`'su bu yeni state'i yansıtır. Bu
döngü (yaz → state güncelle → yeniden render et → input'ta göster) bir
controlled component'in kalbi. Değer state'te olduğu için, aynı anda
ekranın başka bir yerinde de (karakter sayısı, önizleme gibi) anında
kullanabiliyoruz.

## Checkbox ve Select ile Controlled Component'ler

Aynı desen, metin input'larıyla sınırlı değil -- checkbox'lar ve
select'ler de controlled yapılabilir:

{{ControlledCheckboxExample.jsx}}

Checkbox'larda `value` yerine `checked` kullanılır, ama mantık aynı:
işaretli olup olmadığını React'in state'i belirliyor.

{{ControlledSelectExample.jsx}}

`<select>` da tıpkı bir metin input'u gibi `value` ve `onChange` ile
kontrol edilir.

## Neden Controlled Component?

Değeri React'in state'inde tutmanın en somut faydalarından biri, o
değer üzerinde kolayca işlem yapabilmen -- örneğin programatik olarak
sıfırlamak:

{{ResettingControlledInputExample.jsx}}

Değer state'te olduğu için, input'u temizlemek yalnızca `setText("")`
kadar basit. Eğer değeri React'in dışında (tarayıcının kendi DOM'unda)
tutsaydık, aynı işi yapmak için bir DOM referansına (`useRef`) ya da
formun kendi `reset()` metoduna ihtiyacımız olurdu.

## Özet ve Terimler Sözlüğü

Bir controlled component, `value` (ya da checkbox'larda `checked`) ile
state'e bağlanan ve `onChange` ile bu state'i güncel tutan bir form
elemanıdır. Değer her zaman React'in state'inde yaşadığı için, o değeri
okumak, doğrulamak ya da sıfırlamak kolaylaşır -- input'un kendi başına
tuttuğu bir değere güvenmene gerek kalmaz.

**Terimler Sözlüğü**

**Controlled Component** — Değeri React'in state'i tarafından belirlenen
ve `onChange` ile güncellenen bir form elemanı.

**Uncontrolled Component** — Değerini kendi başına (tarayıcının DOM'unda)
tutan, React state'ine bağlı olmayan bir form elemanı.
