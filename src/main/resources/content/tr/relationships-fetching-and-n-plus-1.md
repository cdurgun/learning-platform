Bu kategoride şimdiye kadar işlenen her entity, en fazla dışarı doğru işaret eden tek bir `@ManyToOne`'a sahipti -- `Topic.category`, `Category.course`. "Transaction Management", bu tek ilişkiye lazy olarak, bir transaction dışında erişildiğinde ne olduğunu zaten işledi. Bu ders aynı anda üç yönde daha ileri gidiyor: bir ilişkinin alabileceği DİĞER şekiller, bir entity'yi kaydetmenin ya da silmenin başka birine nasıl yayılabileceği (cascade), ve şimdiye kadar hiç adlandırılmamış bir performans sorunu -- tamamen doğru bir ilişki mapping'i kümesinin bile sessizce tetikleyebileceği.

## "Transaction Management"in Zaten İşlediği, ve Bu Dersin Eklediği

`LazyInitializationException`, `join fetch`, ve `spring.jpa.open-in-view`, bu projenin gerçek `Topic`/`Category`/`Course` ilişkileri kullanılarak zaten tam olarak işlendi -- hiçbiri burada tekrarlanmıyor. Yeni olan: `@OneToMany` ve `@ManyToMany` (şimdiye kadar yalnızca `@ManyToOne` ortaya çıktı), cascade türleri ve `orphanRemoval`, ve N+1 problemi -- lazy loading'in (zaten işlenen) mümkün kıldığı ama kendi başına açıklamadığı, spesifik, somut bir performans tuzağı.

## @ManyToOne'un Diğer Tarafı: @OneToMany

Bu projenin gerçek `Topic` entity'si, `Category`'ye işaret eden bir `@ManyToOne`'a sahip -- ama `Category`'de şu anda hiçbir şey geriye işaret etmiyor. `@OneToMany`, o eksik diğer taraf.

{{OneToManyRelationshipExample.java}}

`mappedBy = "category"`, bu ilişkiyi gerçekte sahiplenen `TopicExample`'daki ALANA işaret eder -- `@OneToMany`, var olan bir `@ManyToOne`'un ayna görüntüsüdür, kendi sütunu olan ikinci, bağımsız bir mapping değil. Foreign key (`category_id`), bu projenin gerçek şemasında zaten olduğu gibi, yalnızca `topic` tablosunda yaşamaya devam eder; `@OneToMany` hiçbir yere kendi sütununu eklemez.

## @ManyToMany ve Join Table'lar

Bazı ilişkilerin doğal bir "sahip" tarafı hiç yoktur -- her iki tarafın tablosu da bir foreign key için doğru yer değildir, çünkü her iki taraf da diğerinin birçoğuyla ilişkilenebilir.

{{ManyToManyRelationshipExample.java}}

`@JoinTable`, ayrı bir tabloyu (`topic_tag`) açıkça tarif eder, ne `topic`'te ne `tag`'de yaşayan bir `topic_id` sütunu ve bir `tag_id` sütunuyla. Bu projenin kendi gerçek `QuizQuestion`'ı, aynı temel fikir için (`Quiz` ve `Question`, birbirinin birçoğuyla ilişkilenir) ilişkili ama farklı, genelde daha iyi bir yaklaşım gösteriyor -- düz bir `@ManyToMany` yerine, kendi `position` sütunu olan tam bir entity. Düz bir `@ManyToMany` join table'ının, ilişkinin KENDİSİ HAKKINDA veriye yer yoktur, yalnızca bağlantıya -- ilişkinin bundan fazlasını taşıması gerektiğinde, bu projenin zaten yaptığı gibi, açık bir join entity'sine başvur.

## Cascade Türleri ve orphanRemoval

Bir entity'yi kaydetmek ya da silmek, otomatik olarak ilişkili olduğu entity'lere dokunmaz -- `cascade` ve `orphanRemoval`, bunu bilinçli olarak yapan şeydir.

{{CascadeAndOrphanRemovalExample.java}}

`CascadeType.PERSIST`, bir `Category`'yi kaydetmenin, listesine yeni eklenen her `Topic`'i de aynı işlemde kaydetmesini sağlar. `CascadeType.REMOVE`, bir `Category`'yi silmenin, ona hâlâ bağlı her `Topic`'i de silmesini sağlar -- burada makul bir seçim, çünkü bu projenin gerçek şeması zaten `category_id`'yi `nullable = false` yapıyor, yani bir `Topic` gerçekten birisiz var olamaz. `CascadeType.ALL`, `PERSIST`/`MERGE`/`REMOVE`'un (ve iki daha az yaygın cascade türünün) birlikte kısaltmasıdır. `orphanRemoval = true`, tamamen farklı bir durumu kapsar: `Category`'yi hiç silmeden, bir `Topic`'i `topics` LİSTESİNDEN çıkarmak, o `Topic`'i veritabanından da siler, çünkü artık hiçbir şeye ait değildir; o olmadan, o `Topic` basitçe bağlantısız, sahipsiz bir satır hâline gelirdi.

> ⚠️ Warning
> "Çok" tarafının gerçekten kendi bağımsız yaşam döngüsü olduğu bir ilişkide `CascadeType.REMOVE`/`ALL` (`Category`'nin silmeyi `Topic`'in kendi `CodeExample`'larına yaydığını hayal et, bazı tasarımlarda bunlar tartışmalı olarak tek bir topic'ten daha uzun yaşayabilmeli) istenenden çok daha fazlasını silebilir. Buna bilinçli olarak, ilişkili entity'nin gerçekten ebeveyni olmadan var olup olamayacağına göre başvur -- her `@OneToMany`'de bir varsayılan olarak değil.

## N+1 Problemi, Gösterilmiş

Bu, yukarıdaki mapping mekaniğinin mümkün kıldığı, somut, kaçırması kolay performans tuzağı.

{{NPlusOneProblemExample.java}}

`printAllTopicCounts(...)`, tamamen sıradan görünüyor -- her `Category`'yi getir, üzerlerinde döngü kur, her birinin konularını oku. Ama `category.getTopics()` lazy'dir, ve döngü içinde ona erişmek, tam o anda, yalnızca o kategori için AYRI bir sorguyu tetikler. Bir sorgu kategorileri getirir; döngü içinde kategori başına bir sorgu DAHA çalışır -- 7 kategoriyle, bu tek bir getirme gibi okunan şey için toplam 8 sorgudur; 100'le, 101'dir. Buradaki hiçbir şey sıradan anlamda bir hata değildir -- her satır, tek başına doğrudur -- sorun tamamen doğru kodun sonunda veritabanına kaç gidiş-geliş yaptığıyla ilgilidir.

## @EntityGraph ile Düzeltmek

Bir düzeltme: ilişkiyi, kullanıldığı her yerde fetch türünü değiştirmeden, özellikle bu TEK sorgu için eagerly join etmek.

{{EntityGraphExample.java}}

`@EntityGraph(attributePaths = "topics")`, JPQL'deki `join fetch t.topics`'in ("Transaction Management"in bir `@ManyToOne` ilişkisi için zaten kullandığı aynı teknik, şimdi bir `@OneToMany`'ye uygulanmış) annotation eşdeğeridir -- `findAll()`, artık önceki bölümdeki 1+N sorgu yerine, `topics`'in zaten birleştirilmiş olduğu TEK bir sorgu çalıştırır.

## Batch Fetching ile Düzeltmek

Aynı sorun için farklı bir düzeltme, birçok farklı sorgunun aynı ilişkiye dokunduğu ve her birine `@EntityGraph` eklemenin tekrarlı olacağı durumlarda yararlı.

{{BatchFetchSizeExample.java}}

`@BatchSize(size = 20)`, ekstra sorguları ORTADAN KALDIRMAZ -- onları GRUPLAR. Kategori başına bir sorgu yerine, Hibernate, tek bir `WHERE category_id IN (?, ?, ...)` sorgusuyla, en fazla 20 kategorinin id'si için bir kerede konuları getirir. 7 kategori ve 20'lik bir batch boyutuyla, N+1 örneğindeki 1+7 sorgu, yalnızca 1+1 olur -- kategoriler için bir sorgu, ve her kategorinin konularını birlikte kapsayan tek bir batch sorgusu.

## İlişkiyi Hiç Getirmeyerek Düzeltmek: Projection'lar

Üçüncü bir seçenek, sorunu daha verimli çözmek yerine tamamen atlatır: çağıran hiç ihtiyaç duymadıysa, ilişkiyi hiç getirme. Bu kategoride daha önceki "Pagination, Sorting, and Projections", tam olarak bunu zaten işledi -- bir interface ya da record projection, yalnızca bir sorgunun gerçekten ihtiyaç duyduğu alanları seçer, ve bu asla lazy bir ilişkiyi içermiyorsa, hiçbir N+1 problemi oluşamaz, çünkü ilişkiye baştan hiç dokunulmaz.

## Düzeltmeler Arasında Seçim Yapmak

Şimdi dört araç, aynı temel sorunun örtüşen versiyonlarını çözüyor, her biri farklı bir duruma uyuyor. `join fetch` ("Transaction Management"te zaten işlendi), ilişkiye her zaman ihtiyaç duyan tek, spesifik bir sorguya uyar. `@EntityGraph`, aynı duruma daha az JPQL yazarak uyar, özellikle bir `join fetch` cümlesi eklenecek bir `@Query`'si olmayan derived bir query metodu için. Batch fetching, birçok farklı sorgunun dokunduğu bir ilişkiye uyar, her yere `@EntityGraph` eklemenin tekrarlı olacağı durumda. Bir projection, baştan ilişkinin verisine hiç ihtiyaç duymayan bir sorguya uyar -- uygulandığında en ucuz düzeltme.

## Yaygın Yanlış Anlamalar

**"N+1, bir şeyin bozuk olduğu anlamına gelir."** İlgili her tek sorgu tamamen doğrudur -- sorun tamamen gidiş-geliş SAYISIYLA ilgilidir, doğrulukla değil. **"`@OneToMany`'nin kendi foreign-key sütununa ihtiyacı vardır."** Yoktur -- foreign key tamamen sahip olan `@ManyToOne` tarafında yaşar; `mappedBy` ile `@OneToMany`, kendi sütununu eklemez. **"`cascade` ve `orphanRemoval` aynı şeyi yapar."** Yapmazlar -- `cascade`, ebeveyn üzerinde yapılan açık bir kaydetme/silme işlemini çocuklarına yayar; `orphanRemoval`, bir çocuğu, ebeveyninin koleksiyonundan çıkarıldığı için, çocuk üzerinde hiç açık bir silme olmadan siler.

## Sırada Ne Var

Bu dersteki her düzeltme, lazy loading ve N+1 problemini tek bir isteğin sınırlarının DIŞINDAN aştı. Bu kategoride sıradaki "Persistence Context ve Locking", bir seviye daha derine iniyor -- "managed," "detached," ve persistence context'in kendi first-level cache'inin bir entity'nin yaşam döngüsü için gerçekte ne anlama geldiğine, ve iki transaction aynı satıra aynı anda dokunduğunda ne olduğuna.

## Best Practices

- `cascade`/`orphanRemoval`'a yalnızca ilişkili entity gerçekten ebeveyninden bağımsız var olamadığında (ya da olmaması gerektiğinde) başvur -- her `@OneToMany`'de bir varsayılan olarak değil.
- İlişki kendi verisini taşıması gerektiği anda, düz bir `@ManyToMany` yerine açık bir join entity'sini (bu projenin gerçek `QuizQuestion`'ı gibi) tercih et.
- Her zaman bir ilişkiye ihtiyaç duyan tek bir sorgu için `@EntityGraph`'a, birçok sorgunun dokunduğu bir ilişki için batch fetching'e, ve ilişkinin verisine gerçekte hiç ihtiyaç duyulmadığında bir projection'a başvur.
- `findAll()` şeklinde bir sorgudan hemen sonra bir koleksiyon üzerinde bir döngüye dikkat et -- bir N+1 probleminin gizlendiği en yaygın tek yer.

## Yaygın Hatalar

- İlişkili entity'nin gerçekten bağımsız var olup olamayacağını kontrol etmeden `CascadeType.REMOVE`/`ALL` eklemek -- istenenden çok daha fazlasını silmek.
- İlişki gerçekte kendi verisine ihtiyaç duyarken, açık bir join entity'si yerine düz bir `@ManyToMany`'ye başvurmak.
- Ürettiği 1+N sorguyu fark etmeden, her iterasyonda lazy bir koleksiyona erişen bir döngü yazmak.
- Aynı ilişki başka bir yerde onsuz sorgulanmaya devam ederken, `@EntityGraph`'ı tek bir sorguda N+1'i düzeltmek için uygulayıp sorunu yalnızca kısmen çözülmüş bırakmak.

## Özet, Cheat Sheet ve Terimler Sözlüğü

**Özet**

- `@OneToMany` (`mappedBy` ile), var olan bir `@ManyToOne`'un ayna görüntüsüdür -- kendi sütununu eklemez; foreign key sahip olan tarafta kalır.
- `@ManyToMany`'nin kendi join table'ına (`@JoinTable`) ihtiyacı vardır; ilişki kendi verisini taşıması gerektiğinde açık bir join entity'si genelde daha iyi bir seçimdir.
- `cascade`, ebeveynden çocuklarına açık bir kaydetme/silmeyi yayar; `orphanRemoval`, bir çocuğu, ebeveyninin koleksiyonundan ayrıldığı için siler.
- N+1 problemi, bir listeyi getirmek için 1 sorgu, artı o liste üzerindeki bir döngüde lazy bir ilişkiye erişildiğinde öğe BAŞINA bir sorgu daha demektir.
- `@EntityGraph`, batch fetching, ve projection'lar, N+1 için üç farklı düzeltmedir, her biri farklı bir duruma uygun -- "Transaction Management"te zaten işlenen `join fetch`'in yanı sıra.

**Cheat Sheet**

```java
// @ManyToOne'un diğer tarafı
@OneToMany(mappedBy = "category", fetch = FetchType.LAZY)
private List<Topic> topics;

// Kendi join table'ıyla @ManyToMany
@ManyToMany
@JoinTable(name = "topic_tag",
        joinColumns = @JoinColumn(name = "topic_id"),
        inverseJoinColumns = @JoinColumn(name = "tag_id"))
private Set<Tag> tags;

// Cascade + orphanRemoval
@OneToMany(mappedBy = "category", cascade = CascadeType.ALL, orphanRemoval = true)
private List<Topic> topics;

// N+1: bir sorgu, sonra döngü iterasyonu başına bir sorgu daha
for (Category c : categoryRepository.findAll()) {
    c.getTopics().size(); // her seferinde ayrı bir sorguyu tetikler
}

// Düzeltme 1: @EntityGraph
@EntityGraph(attributePaths = "topics")
List<Category> findAll();

// Düzeltme 2: batch fetching
@BatchSize(size = 20)
private List<Topic> topics;

// Düzeltme 3: hiç getirme -- bir projection (bkz. "Pagination, Sorting, and Projections")
interface CategorySummary { String getName(); }
```

**Terimler Sözlüğü**

- **@OneToMany**: foreign key'i diğer (`@ManyToOne`) entity'de yaşayan bir ilişkinin, `mappedBy` ile bildirilen "çok" tarafının mapping'i.
- **@ManyToMany**: hiçbir tarafın tablosunun bir foreign key için doğal yer olmadığı, kendi join table'ına ihtiyaç duyan bir ilişki.
- **Cascade**: bir ebeveyn entity üzerinde yapılan açık bir işlemi (kaydetme, silme) ilişkili çocuklarına yaymak.
- **orphanRemoval**: bir çocuk entity'yi, `cascade`'den bağımsız olarak, ebeveyninin koleksiyonundan çıkarıldığı için silmek.
- **N+1 problemi**: bir listeyi getiren bir sorgu, artı her birindeki lazy bir ilişkiye bir döngüde erişildiğinde öğe başına bir ekstra sorgu.
- **@EntityGraph / batch fetching**: N+1 için iki farklı düzeltme -- bir sorgu için bir ilişkiyi eagerly join etmek, ile birçok öğe-başına sorguyu daha az, daha büyük sorguya gruplamak.
