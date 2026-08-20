# Yapay Zeka Nedir?

Bu, yeni "AI" (Yapay Zeka) kursunun ilk dersi ve "AI Fundamentals" kategorisinin
ilk konusu. Bu platformda Java, Spring ya da React'i zaten öğrenmiş olabilirsin --
güçlü bir teknik geçmişle bu kursa giriyorsun, ama konunun kendisi burada
tamamen yeni, bu yüzden sıfırdan başlıyoruz -- tıpkı "React Fundamentals"ın
React için yaptığı gibi. Bu derste hiç kod yok. Amaç henüz bir şey yazmak değil
-- "yapay zeka"nın gerçekte ne anlama geldiğine dair doğru bir zihinsel harita
kurmak; bundan sonraki üç ders (Machine Learning, Deep Learning, Generative AI)
bu haritanın her bir parçasına ayrı ayrı yakınlaşacak, ilerideki kategoriler
(Large Language Models, Tools & MCP, AI Agents) ise bunun üzerine gerçek,
çalıştırılabilir sistemler kuracak.

## Yapay Zeka Nedir?

Yapay zeka (AI), normalde insan zekâsı gerektiren görevleri yerine getiren
sistemler kuran bir bilgisayar bilimi alanıdır -- bir görüntüyü tanımak, bir
cümleyi çevirmek, bir oyun oynamak, bir ürün önermek, bir soruyu yanıtlamak.
Bu tanım bilinçli olarak geniş, çünkü "AI" tek bir teknik değil. 1970'te
yazılmış basit bir `if` tabanlı satranç-hamlesi seçicisinden, düz İngilizce bir
açıklamadan çalışan kod yazabilen modern bir sisteme kadar her şeyi kapsayan
bir şemsiye terim.

Bir yazılım geliştiricisi için daha kullanışlı bir bakış açısı şöyle: **AI,
davranışı bir programcı tarafından satır satır açıkça yazılmak yerine, veriden
ya da örneklerden öğrenilen yazılımdır.** Geleneksel bir programın davranışı,
tam olarak `if`/`for`/`switch` ifadelerinin söylediği şeydir. Bir AI
sisteminin davranışı ise bir eğitim (training) sürecinden ortaya çıkar --
hemen bundan sonraki "Machine Learning" dersinde bu sürece gireceğiz. Bu tek
cümleyi aklında tut; bu kursun tamamını birbirine bağlayan iplik bu.

## Neden Var?

Bazı problemler, ne kadar çok `if` ifadesi yazmaya istekli olursan ol, açık
kurallarla çözülmesi gerçekten zor problemlerdir. "Bu fotoğraf bir kedi mi?"
sorusunu düşün. Elle kurallar yazmayı deneyebilirsin -- "sivri kulakları,
bıyıkları ve belli bir kürk dokusu varsa" -- ama gerçek fotoğraflar dağınıktır:
farklı açılar, ışıklandırma, ırklar, kısmi kapanmalar, bulanık arka planlar.
Hiç kimse gerçek dünya fotoğraflarında güvenilir çalışan, kurala dayalı, elle
kodlanmış bir kedi dedektörü başarıyla yazamadı. Ya da "bu cümleyi Türkçe'den
İngilizce'ye çevir"i düşün -- insan dili, sabit bir kural tablosunun asla
yakalayamayacağı belirsizlik, deyim ve bağlamla dolu.

AI, tam da bu tür problemler için, kalıbı elle betimlemeye çalışmak yerine
sisteme **çok sayıda örnek** göstermenin ve kalıbı kendisinin bulmasına izin
vermenin çok daha etkili olduğu ortaya çıktığı için var. Kurallar söylenmek
yerine örneklerden öğrenmek fikri -- AI'ın onlarca yıllık geleneksel,
kural-tabanlı yazılım mühendisliğinin zorlandığı problemlerde (görme, dil,
oyun oynama) başarılı olmasının tek nedeni budur.

## Tarihçe

"Düşünen makine" fikri eski, ama adlandırılmış bir disiplin olarak AI alanı
genellikle 1956'da Dartmouth College'da yapılan bir yaz çalıştayına
tarihlenir -- "artificial intelligence" terimi orada ortaya atıldı. Birkaç yıl
önce, 1950'de, Alan Turing "makine düşünebilir mi?" sorusunu felsefeye
takılmadan pratik bir şekilde sormanın yolu olarak ünlü "Turing Testi"ni
önermişti.

Sonraki on yıllar düz bir ilerleme çizgisi değildi. AI, iyi belgelenmiş iki
"AI kışı" yaşadı (kabaca 1970'lerin ortası ve 1980'lerin sonu/1990'ların
başı) -- erken tekniklerin sınırlarına dayandığı, fonlamanın kuruduğu ve
heyecanın çöktüğü dönemler. İşleri değiştiren şey, **veri ve hesaplama gücünün
fikirlere yetişmesiydi.** 2012 civarında, "deep learning" (derin öğrenme --
"Deep Learning" dersinde düzgünce tanışacağız) adlı bir teknik, büyük
etiketlenmiş veri setleri ve güçlü GPU'lar erişilebilir hale geldiğinde
görüntü tanımada eski yaklaşımları çarpıcı biçimde geride bırakmaya başladı.
O an, modern AI çağını başlattı; bu çağ 2020'lerde büyük dil modelleriyle
(large language models) daha da hızlandı -- devasa miktarda metinle eğitilmiş,
insan gibi dil ve kod yazabilen, akıl yürütebilen ve üretebilen sistemler
(bu kursun bir sonraki kategorisi "Large Language Models"ın konusu).

## AI ile Geleneksel Yazılım

Bu kursta sürekli karşına çıkacak bir ayrımı açıkça belirtmekte fayda var,
çünkü bu, AI sistemleri ile bu platformdaki Java, Spring ve React kurslarında
inşa ettiğin her türlü yazılım arasındaki en büyük fark:

- **Geleneksel yazılım deterministiktir ve kural odaklıdır.** Mantığın
  tamamını sen yazarsın. Aynı girdi verildiğinde, doğru yazılmış bir
  `TopicController` (bu platformun kendi gerçek controller'ı, Spring MVC
  kategorisinde işlendi) her zaman aynı çıktıyı üretir, ve kaynak kodu
  okuyarak nedenini tam olarak bilebilirsin.
- **AI sistemleri, o spesifik görev için programlanmaz, eğitilir.** Bir
  geliştirici "görüntüde şu piksel kalıpları varsa, bu bir kedidir" diye
  yazmaz. Bunun yerine bir eğitim süreci ("Machine Learning" dersine bkz.)
  sistemin iç parametrelerini örneklere göre, kendiliğinden iyi çıktılar
  üretene kadar ayarlar. Sonuç, herhangi bir tek çıktı için tam gerekçesi
  "kaynak kod"dan doğrudan okunması çok daha zor olan bir sistemdir, çünkü
  işaret edebileceğin insan tarafından yazılmış bir kural yoktur.

Bu, AI sistemlerinin "öngörülemez bir sihir" olduğu anlamına gelmez -- kesin
matematiksel kurallar izlerler ve davranışları test edilebilir, ölçülebilir
ve iyileştirilebilir (bu kursun ilerideki "AI Evaluation" dersinde tekrar
döneceğimiz bir tema). Anlamı şu: onları inşa etme ve hakkında düşünme
*biçimi*, bir `for` döngüsü yazmaktan temelde farklıdır.

## Dar AI ve Genel AI

AI'ın sıklıkla iki kategoriye ayrıldığını duyarsın:

- **Dar AI** (Narrow AI, "zayıf AI" de denir), tek bir spesifik görevi iyi
  yapmak üzere inşa edilmiş bir sistemdir -- el yazısı rakamları tanımak, bir
  film önermek, bir cümleyi çevirmek, bir metin isteminden görüntü üretmek.
  Bugün var olan ve çalışan her AI sistemi, en yetenekli büyük dil modelleri
  dahil, bu teknik anlamda dar AI'dır: geniş bir görev yelpazesinde son
  derece yetenekli, ama yine de kendi eğitiminin sınırları içinde çalışan
  eğitilmiş bir sistem, insanın yaptığı gibi herhangi bir yeni alana
  özerk şekilde hakim olabilen genel amaçlı bir akıl yürütme ajanı değil.
- **Genel AI** (Artificial General Intelligence, "AGI" da denir), sadece
  özel olarak eğitildiği/tasarlandığı görevlerde değil, *herhangi bir*
  entelektüel görevde insan seviyesinde (veya üstünde) akıl yürütme
  yeteneğine sahip varsayımsal bir sistemi ifade eder. Bu kursun yazıldığı
  tarih itibarıyla genel AI var olmuyor -- bugün kullanabileceğin bir ürün
  değil, hâlâ bir araştırma hedefi ve aktif bir tartışma konusu.

> 💡 Tip
> Bir AI sisteminin bir şeyi "düşündüğünü" ya da "anladığını" iddia eden bir
> başlık okuduğunda, bu neredeyse her zaman dar bir AI sisteminin kendi
> eğitildiği alanda etkileyici performans gösterdiğini anlatıyordur -- genel
> zekânın kanıtı değil. Bu ayrımı aklında tutmak, AI haberlerini çok daha
> doğru okuyan biri olmanı sağlar.

## Yapay Zeka Bugün Nerelerde Kullanılıyor?

AI zaten günlük kullandığın birçok yazılımın içinde, çoğu zaman görünmez
şekilde bulunuyor:

- **Öneriler:** bir yayın akışı platformunun bir sonra izlemeni önerdiği
  şey, bir online mağazanın satın almanı önerdiği ürün.
- **Arama ve sıralama:** bir arama motorunun sorgunla en alakalı sonuçları
  nasıl belirlediği.
- **Dil:** yazım denetleyicileri, makine çevirisi, ve -- giderek artan
  şekilde -- kod yazabilen, açıklayabilen ve yeniden düzenleyebilen AI
  asistanları.
- **Sahtekarlık ve anomali tespiti:** olağandışı bir kredi kartı işlemini
  ya da bir banka işlemindeki sahtekarlığı işaretlemek.
- **Bilgisayarlı görü:** yüz tanımayla bir telefonun kilidini açmak, bir
  otonom aracın kamera görüntüsünde engelleri tespit etmek.
- **Konuşma:** sesli asistanların konuşulan kelimeleri metne çevirmesi ve
  tam tersi.

Bu örneklerin çok farklı görev türlerine yayıldığına dikkat et -- metin,
görüntü, sayı, ses. Bu çeşitlilik mümkün, çünkü "AI" tek bir teknik değil;
birkaç ayrı alt-alanı kapsayan bir şemsiye -- tam olarak bir sonraki bölümün
haritalandırdığı şey.

## Alanın Haritası: AI, Machine Learning, Deep Learning ve Generative AI

Bu kategorideki bundan sonraki üç ders, sürekli kullanılan (ve bazen
karıştırılan) birer terimi kapsıyor: **Machine Learning**, **Deep Learning**
ve **Generative AI**. Her birine ayrı ayrı dalmadan önce, birbirleriyle nasıl
ilişkili olduklarını görmek yardımcı olur -- bunlar dört farklı, rakip
teknoloji değil. Birbirinin **içine yerleşmiş** kavramlar, her biri
kendinden öncekinin daha spesifik bir alt kümesi:

- **Artificial Intelligence (Yapay Zeka)** en geniş terim -- hangi teknikle
  olursa olsun, görünürde zekâ gerektiren görevleri yerine getiren her
  sistem.
- **Machine Learning (Makine Öğrenmesi)**, AI'ın bir alt kümesidir: özel
  olarak, davranışını elle yazılmış kurallar yerine veriden öğrenen
  sistemler (bir sonraki derste ayrıntılı işlenecek).
- **Deep Learning (Derin Öğrenme)**, Machine Learning'in bir alt kümesidir:
  özel olarak, öğrenme mekanizması olarak çok katmanlı "neural network"ler
  (sinir ağları) kullanan makine öğrenmesi (buradan iki ders sonra ayrıntılı
  işlenecek).
- **Generative AI (Üretken Yapay Zeka)**, (genellikle deep learning tabanlı)
  modellerin belirli bir *uygulamasıdır*: yalnızca sınıflandırmak ya da
  tahmin etmek için değil, yeni içerik -- metin, görüntü, ses, kod --
  *üretmek* için eğitilmiş modeller (bu kategorinin dördüncü ve son
  dersinde ayrıntılı işlenecek).

Büyükten küçüğe dört iç içe daire hayal et: AI, Machine Learning'i içerir; o
da Deep Learning'i içerir; o da bugünün Generative AI'ının çoğunun arkasındaki
tekniktir. Her generative AI sistemi bir deep learning sistemidir; her deep
learning sistemi generative değildir; her machine learning sistemi deep
learning değildir; her AI sistemi machine learning bile değildir (ilk
bölümdeki elle yazılmış satranç-hamlesi seçicisi bir AI'dır, ama machine
learning değildir -- içindeki hiçbir şey veriden öğrenilmedi).

## Best Practices

- "AI" kelimesini bir ürün tanıtımında ya da haber başlığında duyduğunda,
  kendine yukarıdaki dört daireden hangisini anlattığını sor -- bu haritaya
  sahip olduğunda muğlak "AI" pazarlama iddialarını değerlendirmek çok
  kolaylaşır.
- Bir AI sistemini ne kadar etkileyici anlatıldığına göre değil, gerçekte ne
  yapmak üzere eğitildiğine ve değerlendirildiğine göre yargıla. Tek bir
  görevi son derece iyi yapan dar bir AI sistemi, yine de dar bir AI
  sistemidir.
- Bu alanı öğrenirken, tek tek teknik isimlerini ezberlemek yerine
  kavramlar arasındaki ilişkiyi (bu harita, ve bir sonraki dersteki
  "Training ve Inference" ayrımı) anlamaya öncelik ver -- isimler hızlı
  değişir, altta yatan ilişkiler değişmez.

## Yaygın Hatalar

- **"AI" ile "AGI"yi aynı şey sanmak.** Bugün üretimde kullanılan her AI
  sistemi, en yetenekli dil modelleri dahil, dar AI'dır (bkz. "Dar AI ve
  Genel AI"). "Gerçek anlama" ya da genel zekâ iddiaları şüpheyle
  okunmalıdır.
- **AI sistemlerinin sadece "kılık değiştirmiş if ifadeleri" olduğunu
  varsaymak.** Geleneksel kural-tabanlı otomasyon ile AI, problemleri
  temelde farklı şekillerde çözer (bkz. "AI ile Geleneksel Yazılım") --
  ikisini karıştırmak, bu sistemlerin nasıl davrandığı, nasıl başarısız
  olduğu ve nasıl iyileştiği konusunda yanlış beklentilere yol açar.
- **Deep learning'in tek machine learning türü, ya da machine learning'in
  tek AI türü olduğunu varsaymak.** Bu dersteki harita gösterdiği gibi, her
  biri kendinden öncekinin belirli bir alt kümesidir -- hiç deep learning
  (ve hiç neural network) içermeyen, faydalı, iyi yerleşmiş AI ve machine
  learning teknikleri de var.

## Özet, Cheat Sheet ve Terimler Sözlüğü

**Özet**

- AI, davranışı açıkça elle yazılmış kurallardan değil, veri ya da
  örneklerdeki kalıpları öğrenmekten gelen yazılımdır.
- AI var, çünkü bazı gerçek dünya problemleri (görme, dil), kuralları elle
  kodlamaktan çok, örneklerden öğrenerek çözmek çok daha kolaydır.
- Alan 1956'ya (Dartmouth) tarihlenir, iki "AI kışı" yaşadı, 2012 civarında
  deep learning ile modern çağına girdi, 2020'lerde büyük dil modelleriyle
  daha da hızlandı.
- Bugün üretimde kullanılan her AI sistemi **dar AI**'dır -- eğitildiği
  spesifik görevlerde son derece yetenekli, genel amaçlı bir akıl yürütme
  ajanı değil.
- AI, Machine Learning, Deep Learning ve Generative AI **iç içe geçmiş**
  kavramlardır, her biri kendinden öncekinin daha spesifik bir alt kümesi --
  dört ayrı teknoloji değil.

**Cheat Sheet**

- AI = normalde insan zekâsı gerektiren görevleri yerine getiren her sistem.
- ML = davranışını veriden öğrenen AI (bir sonraki ders).
- DL = çok katmanlı neural network kullanan ML (buradan iki ders sonra).
- GenAI = genellikle deep learning tabanlı, yeni içerik üretmek üzere
  eğitilmiş modeller (bu kategorinin dördüncü dersi).
- Dar AI = tek bir görevde/alanda yetenekli. AGI = varsayımsal, henüz yok.

**Terimler Sözlüğü**

- **Artificial Intelligence (AI, Yapay Zeka):** görünürde insan zekâsı
  gerektiren görevleri yerine getiren sistemler kuran geniş alan.
- **Dar AI (Narrow AI):** belirli bir görev ya da alan için inşa edilmiş ve
  eğitilmiş bir AI sistemi -- bugün pratikte var olan tek AI türü.
- **Artificial General Intelligence (AGI, Genel Yapay Zeka):** herhangi bir
  entelektüel görevde insan seviyesinde akıl yürütmeye sahip varsayımsal bir
  sistem; henüz ulaşılmadı.
- **Turing Testi:** bir makinenin davranışının bir insanınkinden ayırt
  edilemez olup olmadığını değerlendirmek için Alan Turing'in 1950'de
  yaptığı öneri.
- **AI kışı:** karşılanmayan beklentilerin ardından AI araştırmalarına
  fonlama ve heyecanın azaldığı tarihsel bir dönem.
