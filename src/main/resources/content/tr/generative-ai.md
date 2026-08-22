# Generative AI

"AI Fundamentals" kategorisi, iç içe geçmiş dört daireden oluşan bir haritayla
açılmıştı: AI, Machine Learning, Deep Learning ve Generative AI. İlk üç ders
dıştan içe doğru ilerledi -- AI'ın ne olduğu, arkasındaki Machine Learning
mekanizması, ve bugünün en yetenekli sistemlerini mümkün kılan Deep Learning
tekniği (neural network'ler). Bu ders, dördüncü ve en içteki daireyi kapsıyor:
Generative AI. Diğer üçünden farklı olarak, Generative AI ayrı bir *teknik*
değildir -- zaten bildiğiniz tekniklerin, farklı bir tür göreve yönelik bir
*uygulamasıdır*. Bu ayrımı anlamak, bu dersin tamamının anahtarıdır, ve bu
kursun geri kalanının (Large Language Models, Tools & MCP, AI Agents) üzerine
inşa edileceği zemini kurar.

## Generative AI Nedir?

Generative AI, tek bir label'ı sınıflandırmak ya da tahmin etmek yerine **yeni
içerik yaratmak** üzere eğitilmiş AI sistemlerini ifade eder: metin, görüntü,
ses, kod, video. Modern generative AI sistemlerinin büyük çoğunluğu deep
learning tabanlıdır -- ama bu, "generative AI = deep learning" demek değildir,
yalnızca bugün en yaygın kullanılan uygulamanın bu olduğu anlamına gelir.
Bunu önceki üç derste kullanılan örneklerle karşılaştırın: bir spam filtresi
iki label'dan birini tahmin eder ("spam" / "spam değil"); bir görüntü
sınıflandırıcı birçok kategoriden birini tahmin eder ("kedi," "köpek,"
"araba"). Generative AI yapısal olarak farklı bir şey yapar -- bir prompt
verildiğinde, kelime, piksel ya da ses örneğini birer birer üreterek daha
önce var olmayan tamamen yeni bir içerik parçası oluşturur.

"Yeni içerik" birçok farklı türe yayılabilir; kabaca şöyle dallanır:

```
Generative AI
├── Metin
│   └── LLM (bkz. "Large Language Models: Bir Önizleme")
├── Görüntü
├── Ses
├── Video
└── Kod
```

Bu kategorideki dördüncü ve son ders ("Large Language Models") yalnızca
en üstteki dala -- metne uygulanan generative AI'a -- odaklanıyor; diğer
dallar bu ders kapsamı dışında, ama aynı temel fikrin (yeni içerik üretmek
üzere eğitilmiş modeller) farklı veri türlerine uygulanmasıdır.

## Discriminative ve Generative: Temel Ayrım

"Machine Learning" ve "Deep Learning"te tartışılan modellerin çoğu -- spam
filtresi, kedi sınıflandırıcı -- **discriminative (ayırt edici)** model denen
şeydir: bir girdi verildiğinde, sabit bir olası çıktı kümesi arasından ayrım
yaparlar (bir label, bir kategori, bir sayı). Bir **generative (üretici)**
model ise, tam tersine, eğitim verisinin altındaki örüntüleri ve yapıyı,
aynı veriden gelmiş gibi görünebilecek yepyeni örnekler üretecek kadar iyi
öğrenir. Milyonlarca kedi fotoğrafıyla eğitilmiş bir discriminative model
size "evet, bu bir kedi" diyebilir. Aynı fotoğraflarla eğitilmiş bir
generative model, kedi fotoğraflarının neden o şekilde göründüğünü öğrenerek,
hiç var olmamış bir kedi resmi üretebilir.

> 💡 Tip
> İkisini ayırt etmek için basit bir kontrol: bir sistemin çıktısı bir label,
> bir kategori ya da bir sayıysa, neredeyse kesinlikle discriminative'dir.
> Çıktısı yeni bir cümle, görüntü, ses klibi ya da kod bloğuysa, generative'dir.
> Bu ayrımın, bu kursun bu aşamasında kullanılan başlangıç seviyesinde
> basitleştirilmiş bir zihinsel model olduğunu unutmayın -- gerçek dünyada
> bazı sistemler ikisinin sınırında durur, ama "discriminative vs.
> generative" kontrolü yeni başlayanlar için doğru sezgiyi kurmada hâlâ
> son derece kullanışlıdır.

## Generative Modeller Yeni İçeriği Nasıl Üretir?

Altındaki matematiğe girmeden ("Deep Learning"te belirtildiği gibi, bu kurs
bunu bilinçli olarak yapmıyor), genel fikrin doğru bir zihinsel modeline
sahip olmak yardımcı olur. Çoğu modern generative model -- özellikle metin
ve görüntü üreticileri -- kendinden önce gelen her şeye dayanarak "sırada ne
gelir"i birer küçük parça olarak tahmin etmeyi öğrenerek çalışır:

- Bir metin üreticisi, o ana kadarki kelimeler verildiğinde bir sonraki en
  olası kelimeyi (teknik olarak, *token* denen daha küçük bir birimi) tahmin
  eder, sonra o kelimeyi diziye ekler ve tekrarlar -- tam bir cümleyi ya da
  paragrafı birer token olarak inşa eder.
- Bir görüntü üreticisi yaygın olarak rastgele gürültüden başlayarak,
  adım adım, bir metin açıklamasıyla eşleşen tutarlı bir görüntüye doğru
  kademeli olarak iyileştirerek çalışır -- *diffusion model* denen bir
  teknik ailesi.

Her iki durumda da, model ("Deep Learning"teki eğitim döngüsü -- forward
pass, loss, backpropagation -- kullanılarak) mevcut devasa miktarda içerik
üzerinde eğitildi, neyin genelde neyi takip ettiğinin istatistiksel
örüntülerini öğrendi. Inference zamanındaki üretim, aynı öğrenilmiş
örüntünün, verilen bir şeyi sınıflandırmak yerine yeni bir şey üretmek için
ileri doğru çalıştırılmasıdır.

## Large Language Models: Bir Önizleme

Yukarıdaki metin üretme fikri -- o ana kadarki her şeye dayanarak sıradaki
token'ı birer birer tahmin etmek -- tam olarak **Large Language Model'lerin
(LLM'ler)** arkasındaki mekanizmadır, modern AI sohbet asistanları ve kod
yazma asistanları gibi araçların arkasındaki sistemler. LLM'ler, metne
uygulanmış generative AI'dır, "Deep Learning"in "Yaygın Neural Network
Türleri" bölümünde tanıtılan transformer mimarisi üzerine inşa edilmiştir,
ve kitaplardan, web sitelerinden ve kod depolarından toplanan devasa
miktarda metinle eğitilmiştir. "Sırada ki token'ı tahmin etmek" burada bilinçli olarak basitleştirilmiş bir
model olarak sunuluyor -- LLM'lerin gerçekte nasıl eğitildiği (pretraining),
bir modelin talimatları takip etmesini sağlayan ayrı bir aşama
(post-training / instruction tuning), "context"in inference sırasında
modelin davranışını nasıl şekillendirdiği, ve inference'ın kendisi, hepsi bu
kursun sıradaki kategorisi olan "Large Language Models"da tek tek ele
alınacak. Bu kategori bu sistemlerin gerçekte nasıl çalıştığına, bir
"prompt"un gerçekte ne yaptığına, ve belirli yeteneklerine/sınırlamalarına
tamamen ayrılmıştır -- bu ders yalnızca LLM'lerin, ayrı bir kavram değil,
generative AI'ın genel fikrinin belirli, son derece önemli bir örneği
olduğunu görmenizi gerektiriyor.

## Generative AI Ne Değildir?

Generative AI, "Yapay Zeka Nedir?" dersindeki haritanın en yeni ve en görünür
parçası olduğu için, otomatik olarak anlamına GELMEYEN birkaç şeyi açıkça
belirtmeye değer:

- **Generative AI, genel zekayla (AGI) aynı şey değildir.** İlk dersteki
  "Narrow AI ve General AI"ı hatırlayın -- bir generative model, çıktısı ne
  kadar akıcı görünse de, hâlâ belirli bir tür görev için (sıradaki token'ı
  ya da sıradaki iyileştirme adımını tahmin etmek) eğitilmiş bir narrow AI
  sistemidir, genel amaçlı bir akıl yürütücü değildir.
- **Akıcı çıktı üretmek, doğru çıktı üretmekle aynı şey değildir.** Bir dil
  modeli, dilbilgisi açısından mükemmel, kendinden emin görünen ama olgusal
  olarak yanlış bir cümle üretebilir -- genellikle "hallucination"
  (halüsinasyon) denen bir davranış. Akıcılık, üretim *mekanizmasının* bir
  özelliğidir (olası sıradaki token'ları tahmin etmek); doğruluk ise
  varsayılmaması, kontrol edilmesi gereken ayrı bir özelliktir.
- **Generative AI otomatik olarak "agentic" değildir.** Tek bir prompt'a
  yanıt olarak bir paragraf metin ya da bir görüntü üreten bir sistem, tek
  başına, dünyada otonom kararlar almıyor ya da çok adımlı eylemler
  gerçekleştirmiyor -- bu, generative modellerin *üzerine* inşa edilen ama
  ayrı, ek bir mekanizma ekleyen, bu kursun ilerleyen "AI Agents"
  kategorisinin konusudur.

## Generative AI'ın Günümüzdeki Yaygın Kullanımları

İlk dersteki "Yapay Zeka Bugün Nerelerde Kullanılıyor?"a bağlanarak,
generative AI özellikle şurada karşımıza çıkar:

- **Metin üretimi:** e-posta taslağı hazırlamak, belgeleri özetlemek, kod
  yazmak ve açıklamak, bir sohbette soruları yanıtlamak.
- **Görüntü üretimi:** bir metin açıklamasından illüstrasyon, ürün mockup'ı
  ya da sanat eseri üretmek.
- **Ses ve konuşma üretimi:** metinden gerçekçi konuşma sentezlemek, ya da
  müzik üretmek.
- **Kod üretimi:** metin üretiminin programlama dillerine uygulanmış belirli
  hali -- bir fonksiyonu otomatik tamamlamak, bir açıklamadan tüm bir dosya
  üretmek, ya da tanıdık olmayan bir kod parçasının ne yaptığını açıklamak.

## Best Practices

- Generative AI çıktısını değerlendirirken her zaman *akıcılığı*
  *doğruluktan* ayırın ("Generative AI Ne Değildir?"e bakın) -- kendinden
  emin, iyi yazılmış bir yanıt, doğru olduğunun kanıtı değildir.
- Etkileyici bir generative AI demosu gördüğünüzde, size gerçekte "Yapay
  Zeka Nedir?"teki dört daireden hangisini gösterdiğini sorun -- genel
  zeka değil, belirli, dar, eğitilmiş bir yetenek.
- Model türünü göreve göre eşleştirin: bir sınıflandırma ya da bir sayı
  gerektiğinde discriminative bir model, gerçekten yeni içerik üretilmesi
  gerektiğinde generative bir model kullanın -- basit bir sınıflandırma
  problemini çözmek için generative bir model kullanmak genellikle
  gereksiz bir ek yüktür.

## Yaygın Hatalar

- **Her AI sisteminin "generative AI" olduğunu varsaymak.**
  "Discriminative ve Generative: Temel Ayrım"ın gösterdiği gibi, büyük,
  yararlı AI kategorileri (spam filtreleri, dolandırıcılık dedektörleri,
  öneri sistemleri) generative değil discriminative'dir -- bu terimler
  genel olarak "AI"ın eş anlamlısı değildir.
- **Üretilen metne otomatik olarak olgusal diye güvenmek.** "Generative
  AI Ne Değildir?"de anlatıldığı gibi, akıcı bir cevap ile doğru bir cevap
  iki farklı şeydir -- bu kursun ilerleyen "AI Evaluation" materyali bunu
  gerçekte nasıl kontrol edeceğinize çok daha derinlemesine girecek.
- **"Generative AI" ile "AI agent"ı aynı şey saymak.** Tek bir prompt'a
  tek bir yanıt üreten bir chatbot generative AI'dır; bir hedefi
  gerçekleştirmek için planlayan, birden fazla eylem gerçekleştiren ve
  araç kullanan bir sistem generative AI üzerine inşa edilmiş bir
  agent'tır -- iki terim aynı yeteneği değil, farklı katmanları tarif
  eder ("Generative AI Ne Değildir?"e bakın).

## Özet, Cheat Sheet ve Terimler Sözlüğü

**Özet**

- Generative AI, "Yapay Zeka Nedir?"teki haritanın en içteki dairesidir --
  deep learning'den ayrı bir teknik değil, bir label tahmin etmek yerine
  yeni içerik üretmeye yönelik bir *uygulamasıdır*.
- **Discriminative** modeller sabit çıktılar (bir label, bir kategori)
  arasından seçim yapar; **generative** modeller tamamen yeni içerik
  üretir.
- Çoğu modern generative model, eğitim sırasında öğrenilen her şeye
  dayanarak "sırada ne gelir"i tahmin ederek çalışır -- metin için sıradaki
  token, görüntüler için sıradaki iyileştirme adımı.
- **Large Language Model'ler,** "Deep Learning"teki transformer mimarisi
  üzerine inşa edilmiş, metne uygulanmış generative AI'dır -- bu kursun
  sıradaki kategorisinin konusu.
- Akıcı çıktı otomatik olarak doğru çıktı demek değildir, ve generative AI
  otomatik olarak "agentic" değildir -- ikisi de akılda net tutulmaya
  değer, yaygın kafa karışıklığı noktalarıdır.

**Cheat Sheet**

- Discriminative = bir label/kategori seçer. Generative = yeni içerik
  yaratır.
- LLM = transformer mimarisi aracılığıyla metne uygulanmış generative AI.
- Diffusion model = generative görüntü modelleri için yaygın bir yaklaşım.
- Akıcılık ≠ doğruluk. Üretim ≠ agentic davranış.

**Terimler Sözlüğü**

- **Generative AI:** sınıflandırmak ya da sabit bir label tahmin etmek
  yerine yeni içerik (metin, görüntü, ses, kod) üretmek üzere eğitilmiş
  AI sistemleri.
- **Discriminative model:** bir label ya da kategori gibi sabit bir olası
  çıktı kümesi arasından seçim yapan bir model.
- **Token:** bir metin üretim modelinin birer birer tahmin ettiği küçük
  birim (genellikle bir kelimeye ya da kelime parçasına yakın).
- **Diffusion model:** rastgele gürültüyü kademeli olarak tutarlı bir
  görüntüye dönüştüren bir generative görüntü teknikleri ailesi.
- **Large Language Model (LLM):** transformer mimarisi üzerine inşa
  edilmiş, metin tahmin etmek ve üretmek üzere eğitilmiş bir generative
  AI sistemi.
- **Hallucination (halüsinasyon):** bir generative AI sisteminin akıcı,
  kendinden emin ama olgusal olarak yanlış çıktı ürettiği durum.
