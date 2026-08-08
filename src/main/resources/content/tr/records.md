# Record

Java'da **record**, sabit (immutable) veri taşımak için tasarlanmış, çoğu boilerplate'i
derleyicinin senin yerine yazdığı özel bir sınıf türüdür. Bir DTO, bir değer nesnesi
(value object) ya da bir API request/response modeli yazarken ihtiyaç duyduğun
constructor, accessor, `equals()`, `hashCode()` ve `toString()`'i elle yazmak yerine,
tek satırda tanımlarsın.

## Record Nedir?

Bir record, "bu sınıfın tek işi birkaç değeri bir arada taşımak" dediğin her yerde
kullanılır — bir koordinat (`x`, `y`), bir para tutarı (`amount`, `currency`), bir HTTP
yanıtı (`status`, `body`) gibi. Bu tür sınıfları normal `class` ile yazmak, aynı beş
metodu (constructor, getter'lar, `equals`, `hashCode`, `toString`) her seferinde elle ya
da IDE ile üretmek anlamına gelir — record, bunu derleyiciye devreder.

## Neden Eklendi?

Java'nın en sık eleştirilen yanlarından biri, basit bir veri taşıyıcı sınıf yazmanın bile
ne kadar çok tekrar eden kod gerektirdiğiydi. Aynı beş metot, her alan eklendiğinde ya da
değiştiğinde elle senkron tutulmak zorundaydı — biri `equals()`'ı güncellemeyi unutursa,
sessizce hatalı bir karşılaştırma mantığıyla baş başa kalırdın. Record, bu senkronizasyon
yükünü tamamen ortadan kaldırıyor: bileşenleri bir kere tanımlarsın, geri kalan her şey
onlardan türetilir.

## Tarihçe (Java 14 Preview → Java 16)

Record, JEP 359 ile Java 14'e önizleme (preview) özelliği olarak girdi, JEP 384 ile
Java 15'te ikinci bir önizleme turundan geçti, ve JEP 395 ile Java 16'da kalıcı, standart
bir dil özelliği hâline geldi. Yani bu projede kullandığımız Java 21, record'u sorunsuz ve
tam destekle kullanabiliyor — herhangi bir preview flag'i gerekmiyor.

---

*Kalan bölümler ilerleyen zamanda eklenecek: ilk record örneği, Record vs Class
karşılaştırması, bileşenler (components), üretilen üyeler, immutability, constructor
çeşitleri (canonical/compact), özel metotlar, static üyeler, arayüz implementasyonu,
nested record'lar, serialization, best practices, yaygın hatalar, gerçek dünya örnekleri
(Spring Boot DTO/request/response), mülakat soruları, özet/cheat sheet — artı iki ek
bölüm: Record vs Lombok ve Record Patterns (Java 21).*
