# Spring MVC Views ve Thymeleaf

Spring MVC Fundamentals dersinde `Model`'in controller'dan view'a nasıl veri
taşıdığını gördük, ama view'ın kendisine -- o `Model`'i gerçekten HTML'e çeviren
şablon dosyasına -- hiç girmedik. Validation & Exception Handling dersi de tamamen
`@RestController` tarafında geçti: JSON gövdeler, `ResponseEntity`, `ProblemDetail`.
Bu ders, madalyonun öbür yüzüne, bu projenin asıl kullandığı tarafa dönüyor --
`@Controller`'ın döndürdüğü o mantıksal view adının, projenin kendi
`templates/topic.html` ve `templates/fragments/layout.html` dosyalarında gerçek
HTML'e nasıl çevrildiğine. Bu çeviriyi yapan teknoloji, `spring-boot-starter-thymeleaf`
ile projeye giren **Thymeleaf**.

## Spring MVC'de View Katmanı Nedir?

"ViewResolver: Mantıksal View Adından HTML'e" bölümünde (Spring MVC Fundamentals)
`ViewResolver`'ın `"topic"` gibi bir view adını `templates/topic.html` dosyasına
çevirdiğini görmüştük. View katmanı, tam olarak o dosyanın içeriğidir -- `Model`'e
konan verinin nasıl HTML'e döküleceğini tanımlayan şablon:

```java
// DispatcherServlet'in görüş açısından bir "View", tek bir metotla özetlenebilir:
interface MinimalView {
    void render(java.util.Map<String, Object> model,
                jakarta.servlet.http.HttpServletResponse response) throws java.io.IOException;
}
```

Gerçek Spring MVC'de bu arayüzün adı da tam olarak `org.springframework.web.servlet.View`;
Thymeleaf entegrasyonu, bu arayüzü implemente eden bir `ThymeleafView` sağlar --
`render` metodu, `Model`'i Thymeleaf'in kendi `Context`'ine kopyalayıp şablonu işler.

## Neden Var?

View katmanı olmadan, her controller HTML'i Java string birleştirmeyle elle
üretmek zorunda kalırdı -- okunması zor, XSS'e açık (elle escape etmeyi
unutmak kolaydır) ve tasarımcı ile geliştiricinin aynı dosya üzerinde çalışmasını
imkansızlaştıran bir yaklaşım. Bir şablon motoru, HTML yapısını (tasarımcının
alanı) ile veriyi (controller'ın ürettiği) ayırır; Thymeleaf özellikle, bu ayrımı
**"natural templating"** dediği bir felsefeyle yapar -- bir sonraki bölüm,
Thymeleaf Nedir? "Natural Templating" Felsefesi, tam olarak bunun konusu.

## Tarihçe

Thymeleaf 1.0, 2011'de, o dönem Spring dünyasında yaygın olan JSP'ye bir
alternatif olarak çıktı -- JSP'nin `<%...%>` scriptlet'leri ve özel `.jsp` uzantısı
yerine, düz `.html` dosyaları üzerinde çalışan bir motor öneriyordu. Thymeleaf 2.0
(2013), Spring entegrasyonunu (`thymeleaf-spring`) olgunlaştırdı. Thymeleaf 3.0
(2016), performansı (özellikle büyük şablonlarda) önemli ölçüde artıran yeni bir
işleme motoruyla geldi ve bugün hâlâ kullanılan ana sürüm hattı bu. Spring Boot,
1.0'dan (2014) itibaren `spring-boot-starter-thymeleaf` ile Thymeleaf'i
otomatik yapılandırıyor -- bu projenin de kullandığı yol; JSP, Spring Boot'un
embedded servlet container modeliyle (Auto-Configuration dersinin konusu) iyi
uyuşmadığı için Spring Boot dünyasında büyük ölçüde terk edildi.

## Model, ModelMap ve ModelAndView: Veriyi View'a Taşımanın Üç Yolu

Spring MVC Fundamentals'ın "Model: Controller'dan View'a Veri Taşımak" bölümünde
`Model`'i gördük -- ama controller'dan view'a veri taşımanın tek yolu bu değil:

{{ModelVariantsExample.java}}

Üçü de sonunda aynı yere varıyor: view'ın okuyacağı, string anahtarlı bir veri
haritası. `Model`, `ModelMap`'i genişleten dar bir arayüz; `ModelMap` ise doğrudan
bir `java.util.Map` gibi de kullanılabilir. `ModelAndView`, ikisini (veri + view
adı) tek bir dönüş değerinde birleştirir -- bu projenin `TopicController.show`'u
gibi, view adının bir dizi koşula göre değiştiği (`"topic"` her zaman aynı olsa
da, `contentAvailable` bayrağına göre farklı bölümler render edilir) durumlarda
`Model` parametresi + `String` dönüş değeri ayrımı genelde daha okunaklı kalır;
`ModelAndView` daha çok view adının kendisi de dinamik olduğunda tercih edilir.

## Thymeleaf Nedir? "Natural Templating" Felsefesi

Thymeleaf'i diğer şablon motorlarından ayıran temel fikir, bir şablonun **hem**
geçerli HTML **hem de** işlenebilir bir şablon olmasıdır:

{{NaturalTemplatingExample.java}}

`th:text="${message}"` bir HTML attribute'u -- tarayıcı bunu tanımasa bile göz ardı
eder ve etiketin içindeki düz metni ("This is placeholder text...") gösterir.
Sunucu tarafında Thymeleaf işlediğindeyse, o metnin yerini `${message}`'in gerçek
değeri alır. Bu, JSP'nin `<% %>` scriptlet'lerinin ya da Mustache gibi
motorların `{{ }}` sözdiziminin **yapamadığı** bir şey -- onları içeren bir
dosya, tarayıcıda ya da bir tasarım aracında doğrudan açıldığında bozuk görünür.
Bu projenin `templates/topic.html`'i de bu yüzden bir tasarımcının (ya da senin)
Thymeleaf hiç çalıştırmadan tarayıcıda önizleyebileceği, geçerli bir HTML dosyası.

## Değişken İfadeleri: ${...} ile Model Verisine Erişmek

`${...}`, `Model`'e konan veriyi okumanın temel yolu:

{{VariableExpressionExample.java}}

`${topic.title()}` ifadesindeki `.title()` parantezine dikkat -- `Topic` bir
`record` olduğu için erişimci (accessor) `getTitle()` değil, doğrudan `title()`.
Bu, tesadüfen seçilmiş bir sözdizimi değil: bu projenin kendi
`fragments/layout.html`'i, `CourseNav`/`CategoryNav`/`TopicNavItem` record'larına
tam olarak aynı şekilde erişiyor (`course.name()`, `category.slug()`,
`topicItem.title()`) -- "Bu Projenin Kendi Layout'u: fragments/layout.html ve
Sidebar Accordion" bölümünde bunu gerçek dosyada göreceğiz. `${tags[0]}` gibi
indeks erişimi de listeler için doğrudan çalışır.

## Link İfadeleri: @{...} ile URL Oluşturmak

`@{...}`, bir URL üretir -- path variable'lar ve query parametreleri için ayrı bir
string birleştirme yapmana gerek kalmaz:

{{LinkExpressionExample.java}}

`@{/topics/{slug}(slug=${slug}, lang=${lang})}` ifadesindeki parantez içi, iki
farklı role ayrılıyor: `{slug}` adlı bir path placeholder path'te zaten varsa,
aynı isimli parametre (`slug=${slug}`) oraya yerleştirilir; kalan parametreler
(`lang=${lang}`) otomatik olarak `?lang=tr` gibi bir query string'e dönüşür. Bu
projenin `topic.html`'i SEO odaklı bir yeniden tasarımla dili URL path'inin
kendisine taşımadan önce linklerini TAM OLARAK böyle kuruyordu --
`th:href="@{/topics/{slug}(slug=${topic.slug}, lang=${otherLanguage.code})}"`.
Bugün aynı satır `th:href="@{/{lang}/topics/{slug}(lang=${otherLanguage.code},
slug=${topic.slug})}"` şeklinde -- hem `{lang}` hem `{slug}` artık birer path
placeholder, bu yüzden query string'e taşacak bir şey kalmıyor; her iki durumda
da bu, Path Variable'lar ve Request Parametreleri dersinde `@PathVariable`/
`@RequestParam` ile sunucu tarafında okuduğumuz aynı ayrımın view tarafındaki
karşılığı.

## Metin Görüntüleme: th:text vs th:utext

`th:text` her zaman çıktısını **escape eder** (HTML özel karakterlerini
kodlar); `th:utext` ("unescaped text") ise olduğu gibi yazar:

{{TextVsUtextExample.java}}

Escape etmek varsayılan **ve** güvenli davranış -- kullanıcıdan gelen bir metinde
`<script>` etiketi varsa, `th:text` onu zararsız düz metne çevirir. Bu projenin
`topic.html`'i `th:utext="${contentHtml}"` kullanıyor -- yani escape **etmiyor** --
ama bu bilinçli bir istisna: `contentHtml`, kullanıcı girdisi değil,
`MarkdownService`'in **sunucuda, repo'daki `.md` dosyalarından** ürettiği
güvenilir HTML (bkz. `topic.html`'deki ilgili yorum). Kullanıcıdan gelebilecek
herhangi bir metin (örneğin gelecekte bir yorum formu) her zaman `th:text` ile
render edilmeli.

## Koşullu Render: th:if ve th:unless

`th:if`, koşul `falsy` ise etiketi **çıktıdan tamamen çıkarır** -- `display:none`
gibi gizlemez, HTML'e hiç yazmaz; `th:unless` tam tersi koşulu kontrol eder:

{{ConditionalRenderExample.java}}

Bu projenin `topic.html`'i tam olarak bu ikiliyi kullanıyor:
`th:if="${!contentAvailable}"` ile "bu dilde henüz yok" uyarısını,
`th:if="${contentAvailable}"` ile asıl içerik bloğunu koşullu render ediyor --
ikisi aynı anda render edilmiyor çünkü koşullar birbirinin tam tersi. `null`
kontrolü de aynı mekanizmayla çalışır: `th:if="${previousTopic != null}"`, ilk
konuda "Önceki" linkinin hiç görünmemesini sağlıyor (navigasyon bölümünün
`th:if="${previousTopic != null}"` satırı).

## Döngüler: th:each ile Liste Render Etmek

`th:each`, bulunduğu etiketi koleksiyondaki her eleman için bir kez tekrarlar:

{{IterationExample.java}}

`topic, iterStat : ${topics}` sözdizimindeki `iterStat`, isteğe bağlı bir
**durum değişkeni** -- `count`, `index`, `size`, `first`, `last`, `even`, `odd`
gibi alanlar taşır. Bu projenin sidebar'ı (`fragments/layout.html`) durum
değişkenini hiç kullanmıyor (`th:each="topicItem : ${category.topics()}"`) çünkü
ihtiyacı yok; ama örneğin bir listedeki son elemana farklı bir stil vermek
istediğinde (bu dersin "Ek: Mini Proje — Basit Bir Blog Sayfası" bölümündeki gibi)
`iterStat.last` tam olarak bunun için var.

## Mesaj İfadeleri: #{...} ile i18n Entegrasyonu

`#{...}`, i18n dersinde gördüğümüz `messages*.properties` mekanizmasının
Thymeleaf'teki karşılığı -- bir anahtarı, mevcut locale'e göre çözümlenmiş bir
metne çevirir:

{{MessageExpressionExample.java}}

Gerçek bir Thymeleaf şablonunda bu tek satırdır: `th:text="#{topic.unavailable(${languageName})}"`.
Perde arkasında olan şey, tam olarak `TopicController.buildUnavailableMessage`
metodunun elle yaptığı şey -- bir `MessageSource`'tan, locale'e göre bir bundle
seçip `{0}` gibi parametre yer tutucularını doldurmak; farkı, Thymeleaf'in bunu
her `#{...}` gördüğünde otomatik yapması. Bu projenin `topic.html`'i
`#{nav.previous}`, `#{breadcrumb.home}`, `#{toc.onThisPage}` gibi UI metinleri
için bunu zaten kullanıyor -- `buildUnavailableMessage`'ın elle yazılmış olması,
"Türkçe'de dil adı cümlenin farklı bir yerinde geçiyor" gibi tek bir
`{0}` yer tutucusunun yetmediği, karmaşık cümle yapısı gerektiren **özel** bir
durum (bkz. `TopicController`'daki ilgili Javadoc).

## Fragment'ler: th:fragment, th:insert ve th:replace

Bir sayfanın her yerinde tekrar eden parçaları (navbar, footer, bir kart bileşeni)
`th:fragment` ile bir kez tanımlayıp, `th:insert`/`th:replace` ile istediğin
yere çağırırsın:

{{FragmentExample.java}}

Aradaki fark tek bir şey: `th:insert`, fragment'i **konak etiketin içine**
yerleştirir (konak etiket kalır); `th:replace`, konak etiketin **yerine geçer**
(fragment kendi kök etiketiyle onun yerini alır). Bu projenin `topic.html`'i
`<div th:replace="~{fragments/layout :: navbar}"></div>` gibi hep `th:replace`
kullanıyor -- çünkü o `<div>`'in kendisinin çıktıda kalmasına gerek yok, yalnızca
fragment'in konumunu işaretliyor. `~{fragments/layout :: navbar}` sözdizimindeki
`fragments/layout`, ayrı bir dosyayı; bu örnekteki `~{::badge(...)}`'teki `::`
ise "bu template'in kendisini" işaret ediyor.

## SpringEL Seçim İfadeleri: .?[...] ve #vars

`.?[...]`, bir koleksiyonu filtreler -- köşeli parantez içindeki koşul, her
eleman için `#this` o elemana bağlanmış olarak değerlendirilir:

{{SelectionExpressionExample.java}}

> ⚠️ Warning
> `#this`, seçim ifadesinin içinde **tüm değerlendirme kapsamını** o anki elemana
> çevirir -- bu yüzden köşeli parantez içinde dış bağlamdaki bir değişkene çıplak
> isimle (`activeSlug`) erişmeye çalışmak, o değişkeni değil elemanın kendi
> alanlarından birini aramaya çalışır ve başarısız olur. `#vars.activeSlug`,
> bu rebinding'i atlayıp doğrudan en dıştaki context değişkenlerine ulaşır. Bu
> projenin gerçek `fragments/layout.html` sidebar'ı, `categoryIsActive` hesabında
> tam olarak bu tuzağa düşmüştü -- `.?[#this.slug() == activeTopicSlug]` bir
> `SpelEvaluationException` fırlatıyordu, `.?[#this.slug() == #vars.activeTopicSlug]`
> ile düzeldi (bkz. proje notlarındaki "Bilinen Kısıtlar").

## Bu Projenin Kendi Layout'u: fragments/layout.html ve Sidebar Accordion

Bu dersteki her mekanizmayı, projenin kendi `templates/fragments/layout.html` ve
`templates/topic.html` dosyalarında görebilirsin. `layout.html`, üç fragment
tanımlıyor: `navbar`, `sidebar`, `footer` -- `topic.html` ve `index.html` bunları
`th:replace` ile içe alıyor ("Fragment'ler: th:fragment, th:insert ve
th:replace" bölümündeki mekanizmanın ta kendisi).

Sidebar'daki kategori accordion'u, bu dersin neredeyse tüm konularını tek bir
yerde birleştiriyor: `th:each="category : ${course.categories()}"` ile her
kategoriyi dolaşıyor ("Döngüler: th:each ile Liste Render Etmek"), `th:with`
ile `categoryId` ve `categoryIsActive` adında iki yerel değişken hesaplıyor
(`categoryIsActive`, tam olarak "SpringEL Seçim İfadeleri: .?[...] ve #vars"
bölümündeki `.?[...]` + `#vars` deseniyle),
`th:classappend="${categoryIsActive} ? 'show' : ''"` ile koşullu bir CSS sınıfı
ekliyor, ve `th:each="topicItem : ${category.topics()}"` ile o kategorinin
konularını listeliyor. Bootstrap'in kendi `data-bs-toggle="collapse"`
mekanizmasıyla birlikte çalışıyor -- Thymeleaf yalnızca doğru `id`/`aria-expanded`/
CSS sınıflarını hesaplıyor, açılıp kapanma animasyonunun kendisi tamamen
Bootstrap'in JavaScript'i.

## Form Binding (Kısa Bakış): th:object ve th:field

Bu proje henüz bir form içermiyor -- her sayfa salt okunur içerik. Ama Thymeleaf'in
Spring'e özel form dialect'i, `@ModelAttribute` ile gelecek herhangi bir formu
bağlamak için `th:object`/`th:field` sunar:

{{FormBindingExample.java}}

`th:object`, `*{...}` ifadelerinin (yıldızlı, `${...}`'ten farklı) hangi nesneye
göre çözüleceğini belirler; `th:field="*{author}"`, o nesnenin `author` alanını
hem `value` olarak okur hem de `id`/`name` attribute'larını alan adından türetir --
aynı `name`, formun `POST` edilmesiyle Spring'in `DataBinder`'ının geri yazacağı
alandır. Bu proje form eklediğinde (örneğin bir yorum formu), bu mekanizma
Request ve Response Handling dersindeki `@RequestBody`/`HttpMessageConverter`
ikilisine tam bir alternatif olur -- biri JSON gövdeyi bir nesneye bağlar, diğeri
form alanlarını.

## MVC (Sunucu Taraflı Render) vs REST: Ne Zaman Hangisi?

Spring MVC Fundamentals'ın "@Controller vs @RestController: Ne Zaman Hangisi?"
bölümünde bu ayrımı annotation seviyesinde görmüştük; şimdi view katmanını da
öğrendiğimize göre, sonuçlarını karşılaştırabiliriz. Sunucu taraflı render
(`@Controller` + Thymeleaf, bu projenin kullandığı yol), tarayıcıya doğrudan
görüntülenebilir HTML gönderir -- ilk sayfa yükü daha hızlı görünür (JavaScript'in
veri çekip DOM kurmasını beklemez), SEO doğal olarak çalışır (arama motoru zaten
HTML görür), ama her sayfa geçişi bir tam sayfa yüklemesi (ya da en azından bir
sunucu round-trip'i) gerektirir. REST (`@RestController` + JSON, bir
single-page-application'ın tükettiği API), istemciye yalnızca veri gönderir --
istemci tarafı (React, Vue...) bunu DOM'a çevirir; sayfa geçişleri daha akıcı
olabilir ama ilk yük daha ağırdır ve SEO için ekstra çaba (server-side rendering,
prerendering) gerekir. Bu proje bir öğrenim sitesi -- içerik büyük ölçüde statik,
SEO önemli, karmaşık istemci-taraflı etkileşim gerekmiyor -- bu yüzden sunucu
taraflı render, bilinçli bir tercih (Spring MVC Fundamentals'ın "Spring MVC vs
Spring WebFlux (Kısa Bakış)" bölümündeki blocking/non-blocking değerlendirmesine
benzer bir gerekçelendirme).

## Best Practices

- **`th:utext` yalnızca güvenilir, sunucuda üretilmiş içerik için kullan** --
  kullanıcıdan gelebilecek her metin `th:text` ile escape edilmeli (bkz. "Metin
  Görüntüleme: th:text vs th:utext"); bu projenin `contentHtml` istisnası
  bilinçli ve belgelenmiş, varsayılan değil.
- **Seçim/projection ifadelerinde (`.?[...]`, `.^[...]`, `.![...]`) dış
  değişkenlere her zaman `#vars.` ile eriş** -- `#this`'in kapsamı değiştirdiğini
  unutmak, bu projenin sidebar'ında gerçekten yaşanmış bir hataya yol açtı
  (bkz. "SpringEL Seçim İfadeleri: .?[...] ve #vars").
- **Fragment'leri `th:replace` ile kullan, konak etiketin çıktıda kalmasına
  gerek olmadıkça** -- gereksiz `<div>` sarmalayıcıları CSS'te (özellikle flex/grid
  düzenlerinde) beklenmedik boşluklara yol açabilir.
- **View'a yalnızca render için gereken veriyi koy, iş mantığını değil** --
  "Model, ModelMap ve ModelAndView: Veriyi View'a Taşımanın Üç Yolu"
  bölümündeki üç mekanizmanın hiçbiri, view'ın o veriyi nasıl kullanacağını
  sınırlamaz; disiplini geliştirici sağlamak zorunda -- Spring MVC
  Fundamentals'ın "Controller'ları ince tut, iş mantığını service katmanına
  bırak" gerekçesiyle aynı fikir, burada view katmanı için geçerli.

## Yaygın Hatalar

**1. `th:text` yerine `th:utext` kullanmayı alışkanlık hâline getirmek.**
"Neden çalışmıyor?" diye `th:utext`'e geçip unutmak, kullanıcı girdisi içeren bir
alanda XSS'e kapı açar -- `th:text`'in escape etmesi neredeyse her zaman **istenen**
davranıştır (bkz. "Metin Görüntüleme: th:text vs th:utext").

**2. `.?[...]` içinde dış değişkene çıplak isimle erişmeye çalışmak.** `#this`
kapsamı değiştirdiği için, beklediğin değişken yerine elemanın kendi bir alanı
aranır ve genelde bir `SpelEvaluationException` ile sonuçlanır (bkz. "SpringEL
Seçim İfadeleri: .?[...] ve #vars").

**3. `${...}` içinde bir record alanına `.title` (parantezsiz) ile erişmeye
çalışmak.** Bean-tarzı bir sınıfta `getTitle()` property olarak `title`'a
karşılık gelir, ama bir record'da erişimci gerçek bir metottur (`title()`) --
`${topic.title}` bazı durumlarda sessizce `null` dönebilir ya da hata verebilir;
güvenli olan her zaman `${topic.title()}` yazmak (bkz. "Değişken İfadeleri: ${...}
ile Model Verisine Erişmek").

**4. `th:insert` ile `th:replace`'i birbirine karıştırmak.** İkisi de fragment'i
getirir ama biri konak etiketi bırakır, diğeri onun yerine geçer -- yanlış
seçim, çıktıda beklenmedik fazladan bir sarmalayıcı etiket (`th:insert`) ya da
beklenen sarmalayıcının kaybolması (`th:replace`) şeklinde ortaya çıkar (bkz.
"Fragment'ler: th:fragment, th:insert ve th:replace").

**5. `@{...}` içindeki path placeholder ile parametre adının eşleşmediğini fark
etmemek.** `@{/topics/{slug}(id=${slug})}` gibi bir yazımda, parantez içindeki
parametre adı (`id`) path'teki placeholder'la (`{slug}`) eşleşmediği için
placeholder hiç doldurulmaz ve `id` parametresi query string'e düşer -- sonuç
`/topics/{slug}?id=...` gibi bozuk bir URL olur (bkz. "Link İfadeleri: @{...} ile
URL Oluşturmak").

**6. `#{...}` anahtarının her iki dilde de (tr/en `messages*.properties`)
tanımlı olduğunu varsaymak.** Eksik bir anahtar, sayfada sessizce `??key??`
gibi bir metin olarak belirir -- derleme zamanında yakalanmaz, yalnızca o
sayfayı o dilde ziyaret ettiğinde fark edilir (bkz. "Mesaj İfadeleri: #{...} ile
i18n Entegrasyonu").

## Özet, Cheat Sheet ve Terimler Sözlüğü

Thymeleaf, Spring MVC'nin varsayılan view teknolojisi -- "natural templating"
felsefesiyle, bir şablonun hem geçerli HTML hem de işlenebilir bir dosya olmasını
sağlıyor. Öne çıkan noktalar:

- `Model`/`ModelMap`/`ModelAndView`: controller'dan view'a veri taşımanın üç
  eşdeğer yolu
- `${...}`: değişken ifadesi, `Model`'deki veriyi okur (record'larda parantezli
  erişim: `topic.title()`)
- `@{...}`: link ifadesi, context path + path variable + query parametrelerini
  otomatik birleştirir
- `#{...}`: mesaj ifadesi, i18n bundle'ından (bu projede Spring'in
  `MessageSource`'u üzerinden) çözümlenmiş metin döner
- `th:text` / `th:utext`: sırasıyla escape'li ve escape'siz metin yazımı
- `th:if` / `th:unless`: etiketi tamamen render'dan çıkaran koşullu bloklar
- `th:each`: koleksiyonu dolaşıp etiketi her eleman için tekrarlar; `iterStat`
  ile index/count/first/last erişilebilir
- `th:fragment` / `th:insert` / `th:replace`: yeniden kullanılabilir parça
  tanımlama ve içe alma (`th:replace` konak etiketin yerine geçer)
- `.?[...]`: seçim (filtreleme) ifadesi; içinde `#this` her elemana bağlanır,
  dış değişkenlere `#vars.` ile erişilir
- `th:object` / `th:field`: form alanlarını bir Java nesnesine bağlar (bu
  projede henüz kullanılmıyor)

Hızlı referans:

```html
<!-- değişken + link + mesaj -->
<a th:href="@{/{lang}/topics/{slug}(lang=${language.code}, slug=${topic.slug()})}" th:text="${topic.title()}">Konu</a>
<span th:text="#{time.minutesShort}">dk</span>

<!-- koşul + döngü -->
<div th:if="${!items.isEmpty()}">
    <p th:each="item, stat : ${items}" th:text="${stat.count} + '. ' + ${item.name()}">satır</p>
</div>
<div th:unless="${!items.isEmpty()}">Boş.</div>

<!-- fragment tanımı ve çağrısı -->
<div th:fragment="card(title)" class="card" th:text="${title}">kart</div>
<div th:replace="~{::card(${topic.title()})}">yer tutucu</div>

<!-- güvenli vs güvenilir içerik -->
<p th:text="${userComment}">kullanıcıdan gelen -- escape'li</p>
<article th:utext="${serverRenderedMarkdown}">sunucuda üretilmiş -- escape'siz</article>
```

**Terimler Sözlüğü**

**Thymeleaf** — Spring Boot'un varsayılan olarak yapılandırdığı, "natural
templating" felsefesine sahip Java şablon motoru.

**Natural templating** — Bir şablonun, işlenmeden önce de tarayıcıda/tasarım
aracında geçerli ve anlamlı görünmesini sağlayan Thymeleaf tasarım ilkesi.

**Değişken ifadesi (`${...}`)** — Model/context'teki bir değeri okuyan Thymeleaf
ifadesi.

**Link ifadesi (`@{...}`)** — Context path, path variable ve query
parametrelerini birleştirerek bir URL üreten Thymeleaf ifadesi.

**Mesaj ifadesi (`#{...}`)** — Bir i18n anahtarını, mevcut locale'e göre
çözümlenmiş metne çeviren Thymeleaf ifadesi.

**`th:text` / `th:utext`** — Bir etiketin metnini sırasıyla escape'li ve
escape'siz yazan attribute'lar.

**Fragment** — `th:fragment` ile tanımlanan, `th:insert`/`th:replace` ile başka
bir yerde yeniden kullanılan şablon parçası.

**Seçim ifadesi (`.?[...]`)** — Bir koleksiyonu, içindeki `#this` o anki elemana
bağlı bir koşula göre filtreleyen ifade.

**`#vars`** — Seçim/projection gibi kapsam değiştiren ifadeler içinde, en
dıştaki context değişkenlerine doğrudan erişmeyi sağlayan Thymeleaf temel
nesnesi.

**`th:object` / `th:field`** — Bir form alanını, `@ModelAttribute` ile gelen
bir Java nesnesinin alanına bağlayan Thymeleaf form dialect'i attribute'ları.

## Ek: Mini Proje — Basit Bir Blog Sayfası

Bu dersteki mekanizmaların birlikte çalıştığı küçük bir sayfa kuruyoruz: bir
`th:fragment` (tek bir yazı kartı), `th:each` (yazı listesi) ve `th:if`/`th:unless`
(boş liste durumu) aynı şablonda:

{{BlogPageTemplateExample.java}}

{{BlogPageDemo.java}}

`postCard` fragment'i tek bir yazıyı biliyor -- başlık ve özet. `th:unless="${#lists.isEmpty(posts)}"`
bloğu, listede en az bir yazı varsa devreye girip `th:each` ile her yazı için
`postCard`'ı `th:insert` ediyor; liste boşsa `th:if="${#lists.isEmpty(posts)}"`
bloğu tek başına "No posts yet." metnini gösteriyor. `BlogPageDemo`, aynı
`render` metodunu önce dolu bir listeyle, sonra boş bir listeyle çağırarak iki
dalın da doğru çalıştığını gösteriyor.

## Ek: Mini Proje — i18n Destekli Ürün Kartı Şablonu

İkinci mini proje, `${...}`, `@{...}` ve `th:if`'i, "Mesaj İfadeleri: #{...} ile
i18n Entegrasyonu" bölümündeki yaklaşımla (mesajı önceden çözüp şablona hazır
bir string olarak beslemek) bir araya getiriyor:

{{ProductCardTemplateExample.java}}

{{ProductCardDemo.java}}

`ProductCardTemplateExample`, bir ürünü (`${product.name()}`), ürün sayfasına
giden bir linki (`@{/products/{slug}(slug=${product.slug()})}`) ve indirimliyse
görünen bir rozeti (`th:if="${product.discounted()}"`) render ediyor.
`ProductCardDemo`, "Sepete Ekle"/"Add to Cart" metnini dil koduna göre önceden
çözüp aynı şablonu iki dilde, hem indirimli hem normal fiyatlı bir ürün için
çalıştırıyor -- gerçek bir Thymeleaf kurulumunda bu son adım `#{addToCart}` ile
tek satıra iner, ama ayrık tutmak, şablonun kendisini mesaj çözümleme
altyapısından bağımsız test edilebilir kılıyor.
