"Sınırlı Tür Parametreleri", `T` gibi bir tür parametresinin ne ile doldurulabileceğini kısıtladı. Wildcard'lar ilgili ama farklı bir sorunu çözer: bir KULLANIM NOKTASINDA — bir metot parametresi, bir alan, bir değişken — generic bir türü, hangi tür argümanıyla inşa edildiğine tam olarak bağlanmadan kabul etmek istediğinde ne yapılacağı. Bu, Java generics'inin en yaygın yanlış anlaşılan bölümlerinden biri, bu yüzden bu ders yavaş ilerliyor.

## Wildcard Nedir?

`?` olarak yazılan bir wildcard, generic bir türün belirli bir kullanımında BİLİNMEYEN bir tür argümanının yerini tutar — `List<?>`, "bir tür `List`, hangisi olduğunu söylemiyorum" demektir. Bir tür parametresinden (`T`) farklı olarak, bir wildcard hiçbir zaman bir isim almaz ve yeni generic sınıflar ya da metotlar bildirmek için asla kullanılmaz — yalnızca generic bir tür KULLANILIRKEN, bir parametre türü gibi bir yerde görünür.

## Neden Var?

Java generics DEĞİŞMEZDİR (invariant): `Integer` bir `Number` OLSA bile, `List<Integer>`, bir `List<Number>` DEĞİLDİR — ikisi tamamen ilgisiz iki tür olarak ele alınır.

{{WildcardMotivationExample.java}}

`sumNumbers(List<Number> numbers)`, yalnızca TAM OLARAK `List<Number>` olan bir parametreyi kabul eder — eleman türü ne kadar yakından ilişkili olursa olsun, bir `List<Integer>` doğrudan reddedilir. Başka bir araç olmadan, bir sayı listesini toplamak için bile her olası eleman türü için ayrı bir overload gerekirdi. Wildcard'lar, bir metodun tek, esnek bir parametre türü aracılığıyla ilişkili tür argümanlarının bütün bir AİLESİNİ kabul etmesine izin vermek için var. ("Koleksiyonlarla Generics", aynı değişmezlik kuralına, özellikle `List` ve `Map` gibi koleksiyonlar açısından tekrar bakacak.)

## Sınırsız Wildcard: `<?>`

`List<?>`, herhangi bir eleman türünden bir `List`i kabul eder — bir metodun elemanların ne olduğunu gerçekten umursamadığı ve yalnızca ne olursa olsun çalışan işlemlere ihtiyaç duyduğu durumlarda doğru araçtır.

{{UnboundedWildcardExample.java}}

`printSize(...)`, bir `List<String>`, bir `List<Integer>` ya da başka herhangi bir şey üzerinde çalışır — eleman türünü asla bilmesi gerekmez, çünkü yalnızca `size()`'ı çağırır ve elemanları `Object` olarak okur.

## Üst Sınırlı Wildcard: `<? extends T>`

`List<? extends Number>`, `Number`'dan YA DA onun alt türlerinden birinden bir `List`i kabul eder — `List<Integer>`, `List<Double>`, `List<Number>`'ın kendisi, hepsi uygundur.

{{UpperBoundedWildcardProducerExample.java}}

`sum(...)`, listeden yalnızca OKUR — her eleman, tam türü ne olursa olsun, en azından bir `Number` olmayı garanti eder, bu yüzden `n.doubleValue()`'yu çağırmak her zaman güvenlidir. GÜVENLİ OLMAYAN şey ona bir şey eklemektir: derleyicinin listenin gerçek eleman türünü bilmesinin bir yolu yoktur (özellikle bir `List<Double>` olabilir), bu yüzden bir `Integer` bile olsa herhangi bir şey eklemene izin vermez.

## Alt Sınırlı Wildcard: `<? super T>`

`List<? super Integer>`, `Integer`'dan YA DA onun SÜPER türlerinden birinden bir `List`i kabul eder — `List<Integer>`, `List<Number>`, `List<Object>`, hepsi uygundur.

{{LowerBoundedWildcardConsumerExample.java}}

`addOneToFive(...)`, listeye yalnızca YAZAR — liste gerçekte `Integer`'ın hangi süper türünü tutuyor olursa olsun, bir `Integer` eklemek her zaman güvenlidir. GÜVENLİ OLMAYAN şey belirli bir türü geri okumaktır: derleyici yalnızca listenin `Integer`'ın BİR süper türünü tuttuğunu garanti eder, bu `Object` kadar geniş olabilir, bu yüzden bir okuma yalnızca `Object` olarak ele alınabilir.

## Üçünü Karşılaştırmak: get ve add Gerçekte Neye İzin Verir

Yan yana konulduğunda, üç formun ardındaki desen somutlaşır.

{{WildcardGetPutRestrictionsExample.java}}

`<? extends Number>`, güvenli bir şekilde `get` etmene izin verir ama asla `add` etmene izin vermez (herhangi bir türe uyan `null` hariç). `<? super Integer>`, güvenli bir şekilde bir `Integer` `add` etmene izin verir ama yalnızca `Object` olarak geri `get` etmene izin verir. Düz `<?>`, ne `Object`'in ötesinde anlamlı bir `get`e ne de herhangi bir `add`e izin verir. Bu "get vs. put" davranışı, bir sonraki bölümdeki kuralın işlemesinin tüm nedenidir.

## PECS: Producer Extends, Consumer Super

PECS, hangi wildcard formuna başvurulacağını seçmek için akılda kalıcı bir kuraldır: parametrelenmiş bir tür yalnızca senin için değer ÜRETİYORSA (yalnızca ondan okuyorsan), `extends` kullan; yalnızca senden değer TÜKETİYORSA (yalnızca ona yazıyorsan), `super` kullan. Bu, tam olarak önceki iki örneğin zaten gösterdiği şey — `sum(...)` yalnızca okur (`extends`), `addOneToFive(...)` yalnızca yazar (`super`).

{{PecsCopyExample.java}}

`copy(...)`'nin AYNI ANDA HER İKİ role de ihtiyacı var: `src`'den okunur (bir üretici, dolayısıyla `extends`), ve `dest`'e yazılır (bir tüketici, dolayısıyla `super`). Tek başına hiçbir wildcard formu bu işi yapamazdı — `src`, `List<? super T>` olamazdı (ondan güvenilir biçimde bir `T` geri okuyamazsın), ve `dest`, `List<? extends T>` olamazdı (ona bir `T` ekleyemezsin).

> 💡 Tip
> Bir parametrenin AYNI belirli türün hem okunmasına hem yazılmasına ihtiyacı varsa, wildcard'lar yardımcı olamaz — o parametreye hiç wildcard değil, `List<T>` gibi düz, sınırsız bir tür parametresi gerekir. Wildcard'lar yalnızca bir parametrenin rolü, üretici ya da tüketici olarak, net olduğunda uygulanır.

## Best Practices

- PECS'i doğrudan uygula: bir parametre yalnızca üretiyorsa (ondan okuyorsan) `extends`, yalnızca tüketiyorsa (yalnızca ona yazıyorsan) `super`.
- Bir metodun eleman türüne hiç dokunmadığı durumlarda `<?>`'ye başvur — hangi sınırı kullanacağın konusundaki belirsizlikten dolayı varsayılan olarak ona başvurma.
- Bir dönüş türüne asla bir wildcard ekleme — `List<? extends Number>` döndüren bir metot, her çağıranı bilinmeyen bir türle uğraşmaya zorlar, PECS'in hiçbir faydası olmadan, çünkü bir dönüş türünde ne "okuma" ne "yazma" gerçekleşir.
- Bir parametrenin aynı türle hem okunmaya hem yazılmaya ihtiyacı olduğunda, ona zorla bir wildcard koyma — bunun yerine sıradan bir tür parametresi kullan.

## Yaygın Hatalar

- Bir `List<? extends T>`'ye `add(...)` yapmaya çalışıp derleyicinin bunu reddetmesine şaşırmak — bu, en yaygın wildcard hatası, ve PECS'in `extends` kuralının tam olarak tasarlandığı gibi çalışması.
- Bir `List<? super T>`'den belirli bir türü (`Object` değil) geri okumaya çalışmak — derleyici yalnızca `T`'nin bir süper türünü garanti eder, asla daha dar bir şeyi.
- Metot aslında yalnızca okurken (`? extends` olmalıyken) ya da yalnızca belirli bir türü yazarken (`? super` olmalıyken) `<?>`'ye başvurmak — bu, derleyicinin hataları yakalamak için kullanabileceği bilgiyi çöpe atar.
- Bir wildcard'ı (`?`, yalnızca generic bir tür KULLANILIRKEN görünür) bir tür parametresiyle (`T`, bir sınıf ya da metotta bildirilir) karıştırmak — bir wildcard asla bildirilmez ve asla bir isim almaz.

## Özet, Cheat Sheet ve Terimler Sözlüğü

**Özet**

- Bir wildcard (`?`), isimlendirilmiş bir tür parametresinden farklı olarak, generic bir türün bir kullanımında bilinmeyen bir tür argümanının yerini tutar.
- Generics değişmezdir, bu yüzden `List<Integer>` bir `List<Number>` değildir — wildcard'lar, bir parametrenin ilişkili tür argümanlarının bütün bir ailesini kabul etmesine izin vermek için var.
- `<?>` (sınırsız), herhangi bir eleman türünü kabul eder ama anlamlı bir okuma ya da yazmaya izin vermez.
- `<? extends T>` (üst sınırlı), `T` olarak güvenli okumaya izin verir ama yazmaya izin vermez (`null` hariç).
- `<? super T>` (alt sınırlı), güvenli `T` yazmaya izin verir ama yalnızca `Object` olarak okumaya izin verir.
- PECS: bir üretici için (okuyorsan) `extends`, bir tüketici için (yazıyorsan) `super` kullan.

**Cheat Sheet**

```java
// Sınırsız: eleman türünü umursama
void printSize(List<?> list) { ... }

// Üst sınırlı: üretici, yalnızca okur -- PECS: extends
double sum(List<? extends Number> numbers) {
    double total = 0;
    for (Number n : numbers) total += n.doubleValue();
    return total;
}

// Alt sınırlı: tüketici, yalnızca yazar -- PECS: super
void addOneToFive(List<? super Integer> list) {
    for (int i = 1; i <= 5; i++) list.add(i);
}

// Aynı anda iki rol -- PECS'in tam hâli
static <T> void copy(List<? extends T> src, List<? super T> dest) {
    for (T item : src) dest.add(item);
}
```

**Terimler Sözlüğü**

- **Wildcard**: `?`, generic bir türün bir kullanımında bilinmeyen bir tür argümanının yerini tutar.
- **Sınırsız wildcard**: `<?>`, herhangi bir tür argümanını kabul eder.
- **Üst sınırlı wildcard**: `<? extends T>`, `T`'yi ya da onun alt türlerinden birini kabul eder; okumak güvenli, yazmak güvenli değildir.
- **Alt sınırlı wildcard**: `<? super T>`, `T`'yi ya da onun süper türlerinden birini kabul eder; yazmak güvenli, `Object` dışında bir şey olarak okumak güvenli değildir.
- **PECS**: "Producer Extends, Consumer Super" -- bir parametrenin okunup okunmadığına ya da yazılıp yazılmadığına göre `extends` ile `super` arasında seçim yapma kuralı.
