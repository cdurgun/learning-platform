# Scanner

Java Basics kategorisinin üçüncü konusu `Scanner` -- kullanıcıdan konsoldan girdi almanın, bir dosyayı okumanın ya da elinizdeki bir metni parçalara ayırmanın (tokenize etmenin) en yaygın yolu. Basit bir yardımcı sınıf gibi görünse de, `nextInt()`/`nextLine()` karışıklığı -- neredeyse her Java öğrencisinin bir kez düştüğü klasik bir tuzak -- gibi ince davranışlar barındırır.

## Scanner Nedir?

`Scanner`, `java.util` paketinde tanımlı, bir metin kaynağını (konsol girdisi, bir `File`, bir `String`, ya da herhangi bir `InputStream`/`Readable`) TOKEN'lara (jetonlara) ayırıp bu token'ları ilkel tiplere (`int`, `double`, `boolean` vb.) ya da `String`'e dönüştürerek okumanızı sağlayan bir sınıftır. Varsayılan olarak token'lar BOŞLUK karakterleriyle (space, tab, newline) ayrılır, ama bu davranış özel bir regex ile de değiştirilebilir.

## Neden Var?

Ham bir `InputStream`'den ya da `BufferedReader`'dan tek tek byte/karakter okuyup bunları elle `Integer.parseInt()` gibi metotlarla ayrıştırmak sıkıcı ve hataya açık bir iştir. `Scanner`, bu ayrıştırma işini tek bir metot çağrısına (`nextInt()`, `nextDouble()` vb.) indirger -- özellikle basit konsol uygulamalarında ("bir sayı gir", "adını gir" gibi) kullanıcı girdisini okumanın en pratik yoludur.

## Tarihçe

`Scanner`, Java 5 (2004) ile birlikte geldi -- generic'ler, enum'lar, varargs ve autoboxing gibi dilin en büyük özellik setinin bir parçası olarak. Ondan önce, konsoldan girdi okumak için genellikle `BufferedReader` + `InputStreamReader` sarmalayıp elle ayrıştırma yapmak gerekiyordu -- `Scanner` bunu çok daha rahat bir API'ye indirgedi. İçeride regex tabanlı bir eşleştirme motoru kullanır; bu esneklik (`useDelimiter()` ile herhangi bir regex ayırıcı tanımlayabilme) sağlar ama ham okumadan daha yavaştır (bkz. "Scanner vs BufferedReader" bölümü).

## Temel Kullanım: Token Okumak

`Scanner`, herhangi bir metin kaynağı (bir `String`, `System.in`, bir `File`) üzerinde aynı API ile çalışır. `next()` bir kelime, `nextInt()` bir tamsayı, `nextDouble()` bir ondalık sayı okur -- her metot, okuduğu token'ı beklenen tipe DÖNÜŞTÜRÜR. `hasNext()`/`hasNextInt()` gibi metotlar, bir token'ı TÜKETMEDEN önce kontrol etmenizi sağlar -- bilinmeyen sayıda token üzerinde güvenle döngü kurmanın yolu budur.

{{ScannerBasicsExample.java}}

## nextInt() + nextLine() Klasik Tuzağı

`nextInt()` (ya da `nextDouble()`, `next()` vb.), yalnızca sayının/kelimenin KENDİSİNİ tüketir -- ardından gelen satır sonu karakterini (`\n`) TÜKETMEZ, girdi akışında bırakır. Hemen ardından bir `nextLine()` çağrısı yaparsanız, bu çağrı o bırakılan `\n`'ye kadar okur -- yani BOŞ bir string döner, beklediğiniz bir sonraki satır DEĞİL.

{{ScannerNextIntNextLinePitfallExample.java}}

> ⚠️ Warning
> Bu, neredeyse her Java öğrencisinin en az bir kez düştüğü klasik bir tuzaktır: "yaş oku, sonra isim oku" gibi bir akışta `nextInt()`'ten hemen sonra gelen `nextLine()` beklenmedik şekilde boş bir string döner. Çözüm basittir: `nextInt()`'ten sonra, gerçek `nextLine()` çağrısından ÖNCE fazladan bir `nextLine()` çağrısı yaparak bırakılan satır sonunu "tüketin".

## Özel Ayırıcılar (Delimiters)

Varsayılan boşluk ayırıcısı `useDelimiter(regex)` ile HERHANGİ bir regex'e değiştirilebilir -- bu, `Scanner`'ı basit bir CSV ayrıştırıcısına ya da özel formatlı metinler için bir tokenizer'a dönüştürür.

{{ScannerDelimiterExample.java}}

> 💡 Tip
> `useDelimiter()`'a verdiğiniz regex, tek bir karakterle sınırlı değildir -- yukarıdaki örnekte `"[^0-9]+"` (rakam olmayan bir ya da daha fazla karakter) kullanılarak, karışık bir metinden yalnızca sayılar ayıklanıyor. Basit tek karakterlik ayırıcılardan çok daha zengin bir ayrıştırma gücü sağlar.

## Dosyadan Okuma

`Scanner`, doğrudan bir `File` nesnesi alan bir constructor'a sahiptir -- bu sayede dosya okumak, `String`/`System.in` okumakla AYNI API ile yapılır. `Scanner`, altta bir dosya tanıtıcısı (file handle) tuttuğu için, işiniz bittiğinde MUTLAKA kapatılmalıdır -- bunun en güvenli yolu try-with-resources'tır.

{{ScannerFileExample.java}}

> ⚠️ Warning
> `Scanner`'ın `File` alan constructor'ı `FileNotFoundException` (bir CHECKED exception) fırlatabilir -- bu, dosya yolunun yanlış olması gibi normal, beklenebilir bir durumu ele almanız GEREKTİĞİ anlamına gelir. Ayrıca `Scanner`'ı `close()` etmeyi unutmak, altındaki dosya kaynağının açık kalmasına yol açar -- try-with-resources bunu otomatik garanti eder.

## Scanner vs BufferedReader: Performans

`Scanner`, her token'ı okurken içeride REGEX EŞLEŞTİRMESİ yapar -- bu, tipli token ayrıştırma (`nextInt()`, `nextDouble()`) için rahat bir API sağlar ama ham hız açısından bir bedeli vardır. `BufferedReader.readLine()`, hiçbir ayrıştırma yapmadan yalnızca ham satırları okur -- yalnızca metnin kendisine ihtiyacınız varsa (sayı/kelime ayrıştırması gerekmiyorsa) çok daha hızlıdır.

{{ScannerVsBufferedReaderPerformanceExample.java}}

Gerçek ölçüm (ısıtılmış -- her iki yol da ölçümden önce 50 kez çalıştırıldı): 50.000 satırlık bir metni okurken `Scanner.nextLine()` tutarlı şekilde ~6 ms sürdü, `BufferedReader.readLine()` ise ~1 ms -- `Scanner`'ın regex tabanlı esnekliğinin gerçek bir hız maliyeti olduğunu doğruladı.

## İstisna Yönetimi

Beklenen tipte olmayan bir token için `nextInt()` (ya da benzerleri) çağırmak GERÇEK bir `InputMismatchException` fırlatır -- sessizce `0` ya da `null` DÖNMEZ. Kritik bir nokta: bu istisna fırlatıldığında, o "uyumsuz" token TÜKETİLMEZ -- girdi akışında kalır, bu yüzden `next()` ile düz bir string olarak okunarak kurtarma yapılabilir. Hiç token kalmadığında ise `NoSuchElementException` fırlatılır -- güvenli desen, her zaman önce `hasNext()`/`hasNextInt()` ile kontrol etmektir (tıpkı "Queues & Collections Utility" dersindeki `offer()`/`poll()` ile `add()`/`remove()` arasındaki farkta olduğu gibi).

{{ScannerExceptionHandlingExample.java}}

## Best Practices

- **`nextInt()`/`nextDouble()`'dan sonra `nextLine()` çağıracaksanız, aradaki bırakılan satır sonunu tüketmek için fazladan bir `nextLine()` ekleyin** -- bu, en klasik `Scanner` hatasını önler.
- **Belirsiz sayıda token üzerinde döngü kurarken önce `hasNext()`/`hasNextInt()` ile kontrol edin**, doğrudan `next()`/`nextInt()` çağırıp `NoSuchElementException` riske atmayın.
- **Bir `Scanner`'ı işiniz bittiğinde her zaman kapatın (`close()`)** -- özellikle bir dosya ya da akış üzerinde çalışıyorsanız, try-with-resources kullanın.
- **Yalnızca ham metin satırlarına ihtiyacınız varsa (sayı/token ayrıştırması gerekmiyorsa) `BufferedReader` kullanın** -- `Scanner`'ın regex esnekliği, sadeliğine değecek bir kullanım durumu yoksa gereksiz bir performans bedelidir.

## Yaygın Hatalar

- **`nextInt()`'ten hemen sonra `nextLine()` çağırıp beklenmedik şekilde boş bir string almak.** `nextInt()`, ardından gelen satır sonunu tüketmez -- fazladan bir `nextLine()` ile temizlenmesi gerekir.
- **`next()`/`nextInt()`'i önce `hasNext()`/`hasNextInt()` ile kontrol etmeden çağırıp `NoSuchElementException` almak.** Girdinin bitip bitmediği her zaman önce kontrol edilmeli.
- **Bir `Scanner`'ı kapatmayı unutmak.** Özellikle dosya/akış tabanlı `Scanner`'larda bu, kaynak sızıntısına (resource leak) yol açar.
- **`InputMismatchException` sonrası "uyumsuz" token'ın tüketildiğini sanmak.** Aslında hâlâ girdi akışındadır -- `next()` ile okunarak kurtarılabilir, aksi halde bir sonraki çağrı da AYNI token üzerinde patlar.

## Özet, Cheat Sheet ve Terimler Sözlüğü

`Scanner`, bir metin kaynağını (konsol, dosya, string) token'lara ayırıp bunları ilkel tiplere/`String`'e dönüştürerek okumanızı sağlayan bir sınıftır. `nextInt()`'in ardından gelen satır sonunu tüketmemesi, en klasik `Scanner` tuzağıdır. `useDelimiter()` ile özel ayırıcılar tanımlanabilir; dosya okumak `String`/`System.in` okumakla aynı API'yi kullanır. `Scanner`, `BufferedReader`'a göre daha yavaştır (regex tabanlı ayrıştırma nedeniyle) ama çok daha rahat bir tipli-okuma API'si sunar.

Hızlı referans:

```java
Scanner scanner = new Scanner(System.in);        // konsoldan okuma
int age = scanner.nextInt();
scanner.nextLine();                                 // KLASİK TUZAK: bırakılan \n'yi tüket
String name = scanner.nextLine();

Scanner csv = new Scanner(text);                       // özel ayırıcı
csv.useDelimiter(",");

try (Scanner file = new Scanner(new File("data.txt"))) {  // dosyadan okuma
    while (file.hasNextLine()) {
        String line = file.nextLine();
    }
}

if (scanner.hasNextInt()) { ... }                            // güvenli kontrol
```

**Terimler Sözlüğü**

**Scanner** — Bir metin kaynağını token'lara ayırıp ilkel tiplere/`String`'e dönüştürerek okuyan `java.util` sınıfı.

**Token** — `Scanner`'ın bir ayırıcıya (varsayılan: boşluk) göre böldüğü, tek bir okunabilir birim (kelime, sayı vb.).

**Delimiter (Ayırıcı)** — Token'ları birbirinden ayıran, `useDelimiter()` ile özelleştirilebilen regex.

**InputMismatchException** — Beklenen tipe uymayan bir token için tipli bir `next...()` metodu çağrıldığında fırlatılan istisna.

**BufferedReader** — Ham metin satırlarını (ayrıştırma yapmadan) okuyan, `Scanner`'dan daha hızlı bir alternatif sınıf.
