"Transaction Management", `@Transactional`'ı -- propagation, isolation, rollback kuralları, ve kısaca, Hibernate'in dirty checking'inin, açık bir `save()` çağrısı olmadan bile, değişen bir alanı commit zamanında veritabanına yazdığını -- zaten tam olarak işledi. Bir soruyu açık bıraktı: bu NEDEN çalışıyor? Bu ders bunu cevaplıyor -- dirty checking'i (ve bir avuç başka şeyi) mümkün kılan şeyin kendisi, persistence context -- ve sonra iki transaction gerçekten aynı satır üzerinde çarpıştığında ne olduğunu işliyor.

## "Transaction Management"in Zaten İşlediği, ve Bu Dersin Eklediği

`@Transactional`'ın propagation'ı, isolation seviyeleri, rollback kuralları, ve arkasındaki proxy mekanizması zaten tam olarak işlendi -- hiçbiri burada tekrarlanmıyor. Dirty checking'in kendisi de orada zaten kavramsal olarak adlandırılıp gösterildi. Yeni olan: dirty checking'in gerçekte içinde çalıştığı persistence context, bir entity'nin onun içinde geçtiği tam yaşam döngüsü, ve -- gerçekten yeni bir alan -- iki ayrı transaction aynı satırı aynı anda değiştirdiğinde ne olduğu.

## Persistence Context: Yalnızca "Mevcut Transaction"dan Fazlası

Persistence context, bir transaction'ın yüklediği ya da kaydettiği her entity'yi izleyen (JPA'nın `EntityManager`'ı tarafından desteklenen) nesnedir -- "Transaction Management"in, managed bir entity'nin alan değişikliklerinin otomatik olarak geri yazıldığını söylerken gerçekte tarif ettiği şey buydu. Bu projenin kendi kodu `EntityManager`'a asla doğrudan dokunmaz -- her repository metodu (`save`, `findById`, `delete`) onu zaten sarmalıyor -- ama `repository.save(...)`'ın kendisi, bu dersin doğrudan işlediği tam olarak aynı işlemlerin üzerine inşa edilmiştir.

## Entity Durumları: Transient, Managed, Detached, Removed

Her entity instance'ı, herhangi bir anda, persistence context'e göre tam olarak dört durumdan birindedir.

{{EntityLifecycleExample.java}}

TRANSIENT, persistence context'in hiç haberdar olmadığı düz bir Java nesnesidir -- yalnızca `new TopicLifecycleExample(...)`. MANAGED, persistence context'in onu aktif olarak izlediği anlamına gelir -- `em.persist(...)` bu geçişi yapar, ve o andan itibaren, alan değişiklikleri otomatik olarak izlenir (bu, artık arkasındaki mekanizmaya bir isim verilmiş dirty checking'in KENDİSİDİR). DETACHED, persistence context'in onu artık izlemediği anlamına gelir -- ya transaction sona erdi, ya da `detach(...)` açıkça çağrıldı -- ve sonraki alan değişiklikleri artık otomatik olarak geri yazılmaz. REMOVED, `remove(...)`'un managed bir entity'yi bir sonraki flush'ta silinmek üzere planladığı anlamına gelir; detached bir entity'nin önce `merge(...)` ile yeniden bağlanması gerekir, çünkü `remove(...)` yalnızca managed entity'leri kabul eder.

## First-Level Cache: Aynı Sorgu Neden Aynı Nesneyi Döndürebilir

Tek bir persistence context içinde, aynı entity'yi iki kez istemek, veritabanına iki gidiş anlamına gelmek zorunda değildir.

{{FirstLevelCacheExample.java}}

Aynı transaction içindeki iki ayrı `repository.findById(5L)` çağrısı, iki ayrı nesne döndüren iki ayrı sorgu çalıştırmaz -- persistence context'in first-level cache'i, `5` entity'sinin zaten izlendiğini tanır ve TAM OLARAK AYNI instance'ı geri verir. Yalnızca ilk çağrı gerçekten veritabanını sorgular; ikincisi tamamen bellekten cevaplanır. Bu cache, tek bir persistence context'e (genel durumda, tek bir transaction'a) kapsam sınırlıdır -- transaction'lar arasında yayılmaz, ve bir "second-level cache"in olacağı türden paylaşılan, istekler-arası bir cache değildir.

## persist(), merge() ve detach()

`persist()`, bir entity'yi persistence context'in yönetimine getirmenin tek yolu değildir -- zaten bir id'si olan ama şu anda izlenmeyen, detached bir entity, tamamen farklı bir işleme ihtiyaç duyar.

{{PersistMergeDetachExample.java}}

`persist()`, veritabanında hiç var olmamış entity'ler içindir -- zaten var olan bir satırı temsil eden bir nesne üzerinde çağırmak, bir güncelleme yerine bir duplicate-key hatası riski taşır. `merge()`, detached bir entity için doğru işlemdir: nesnenin alan değerlerini managed bir entity'ye (gerekirse önce onu yükleyerek) kopyalar ve O managed entity'yi döndürür -- `merge(...)`'e verilen orijinal detached nesne detached ve izlenmeyen kalır; yalnızca döndürülen nesne gerçekten managed'dir.

## Flush: Değişikliklerin Veritabanına Gerçekte Ulaştığı An

Bir flush, izlenen değişikliklerin gerçek SQL olarak veritabanına gönderildiği belirli andır -- hem değişikliğin kendisinden hem de transaction'ın nihai commit'inden ayrı bir an.

{{FlushTimingExample.java}}

Hibernate, sonucu bekleyen değişikliklerden etkilenebilecek bir sorgu çalıştırmadan önce otomatik olarak flush eder -- `difficulty` üzerinde filtreleyen bir JPQL sorgusu, sorgunun kendi sonucunun onu yansıtması için, bekleyen bir `difficulty` değişikliğinin flush'ını önce, otomatik olarak tetikler, `flush()` hiç açıkça çağrılmamış olsa bile. Açık bir `em.flush()`, bunu bir sorgunun tetiklemesini ya da transaction'ın commit olmasını beklemeden, hemen şimdi zorlar -- kod, transaction'ın kendisini sonlandırmadan, devam etmeden önce bir değişikliğin gerçekten veritabanına ulaştığını bilmesi gerektiğinde yararlıdır.

## @Version ile Optimistic Locking

Dirty checking, bir satıra dokunan tek transaction'ın kendisi olduğunu varsayar. Gerçek uygulamalar her zaman bunu varsayamaz -- iki transaction aynı satırı yükleyip ikisi de değiştirmeye çalışabilir.

{{OptimisticLockingExample.java}}

`@Version`, Hibernate'in tamamen kendi başına yönettiği bir sütun ekler -- her `UPDATE` onu artırır, ve her `UPDATE`'in `WHERE` cümlesi, entity'nin yüklendiği değerle hâlâ eşleştiğini kontrol eder. OPTIMISTIC olarak adlandırılır çünkü çakışmaların nadir olduğunu varsayar -- bir entity okunup değiştirilirken hiçbir kilit tutulmaz; kontrol yalnızca yazma zamanında gerçekleşir, gerçekte hiçbir şey çakışmadığında neredeyse hiçbir maliyeti yoktur.

## İki Transaction Çarpıştığında Ne Olur

Bir çarpışma gerçekten olduğunda, ikinci yazmanın `WHERE ... AND version = ...` cümlesi hiçbir satırla eşleşmez -- satırın version'ı zaten ilerlemiştir.

`loadedByUserA` ve `loadedByUserB`, ikisi de aynı satırı `version = 3`'te yükler. Kullanıcı A önce kaydeder -- `UPDATE`'in `WHERE version = 3`'ü hâlâ eşleşir, bu yüzden başarılı olur, ve satır `version = 4` olur. Kullanıcı B sonra kaydeder, hâlâ version'ın `3` olduğuna inanarak -- `UPDATE`'in `WHERE version = 3`'ü artık hiçbir şeyle eşleşmez, ve Spring Data JPA bunu sessizce hiçbir şey yapmamak ya da Kullanıcı A'nın değişikliğinin üzerine yazmak yerine bir `OptimisticLockingFailureException` olarak ortaya çıkarır.

> 💡 Tip
> Bir `OptimisticLockingFailureException`, bastırılacak bir hata değildir -- sistemin, bir kullanıcının üzerinde çalıştığı verinin artık eski olduğunu doğru şekilde tespit etmesidir. Tipik tepki, aynı kaydetmeyi körü körüne yeniden denemek değil, kullanıcıya mevcut veriyi göstermek ve değişikliğini yeniden uygulamasını istemektir.

## @Lock ile Pessimistic Locking

Optimistic locking, bir çarpışmayı gerçekleştikten sonra tespit eder. Farklı bir strateji, çarpışmanın baştan mümkün olmasını önler.

{{PessimisticLockingExample.java}}

`@Lock(LockModeType.PESSIMISTIC_WRITE)`, okuma zamanında gerçek bir veritabanı-seviyesi kilit (PostgreSQL'in `SELECT ... FOR UPDATE`'i) ekler -- aynı satırda aynı kilidi almaya çalışan başka herhangi bir transaction, bu transaction commit olana ya da rollback olana kadar basitçe BEKLER. PESSIMISTIC olarak adlandırılır çünkü bir çarpışmanın, her diğer transaction'ı bekletmek pahasına, baştan önlenmeye yetecek kadar olası olduğunu varsayar -- buna, optimistic locking'in varsayılan bir yerine geçeni olarak değil, gerçekten yüksek-çekişmeli işlemler (paylaşılan bir sayaç, bir koltuk rezervasyonu) için başvur.

## Yaygın Yanlış Anlamalar

**"Dirty checking arkasında gerçek bir mekanizma olmadan kendiliğinden olur."** Persistence context'in tam olarak "managed" olmanın anlamını yaptığı şeydir -- belirli bir entity'nin alan değişikliklerini, managed kaldığı sürece tam olarak izlemek. **"First-level cache, genel bir uygulama-geneli cache ile aynıdır."** Değildir -- tek bir persistence context'e (yaygın durumda, tek bir transaction'a) kapsam sınırlıdır, istekler ya da transaction'lar arasında asla paylaşılmaz. **"Optimistic ve pessimistic locking, aynı fikrin iki ismidir."** Zıt stratejilerdir -- biri bir çarpışmayı gerçekleştikten sonra tespit edip kaybedeni reddeder; diğeri, herkesi beklemeye zorlayarak çarpışmayı baştan imkansız kılar.

## Sırada Ne Var

Bu kategoride şimdiye kadar işlenen her entity, düz bir Java alanıydı -- bir `String`, bir `Integer`, bir enum, bir ilişki. Bu kategoride sıradaki "Spring Data JPA'da Auditing", bu dersin entity-durumu mekaniğinin mümkün kıldığı, belirli, yaygın bir alan türünü işliyor: bir entity'nin NE ZAMAN oluşturulduğunu ya da son değiştirildiğini, ve KİM TARAFINDAN, bunu her servis metodunda elle yazmadan otomatik olarak kaydetmek.

## Best Practices

- Detached bir entity'yle çalışırken özellikle `merge()`'e başvur -- onun üzerinde `persist()` kullanmak, gerçekten istediğin güncelleme yerine bir duplicate-key hatası riski taşır.
- Birden fazla transaction tarafından eş zamanlı değiştirilme riski gerçekten olan herhangi bir entity'ye `@Version` ekle -- çarpışma olmadığında neredeyse hiçbir maliyeti yoktur, ve gerçek olanları yakalar.
- `OptimisticLockingFailureException`'ı, aynı kaydetmeyi sessizce yeniden deneyerek değil, değişikliği yapan kişiye mevcut veriyi yeniden göstererek ele al.
- Pessimistic locking'i gerçekten yüksek-çekişmeli işlemler için sakla -- maliyeti (diğer transaction'ları bekletmek), varsayılan olarak ödenmeye değmez.

## Yaygın Hatalar

- Detached bir entity üzerinde `merge()` yerine `persist()` çağırmak, istenen güncelleme yerine bir duplicate-key hatası riski taşımak.
- First-level cache'in, tek bir persistence context'e kapsam sınırlı bir şey yerine, genel, istekler-arası bir cache gibi davrandığını varsaymak.
- `OptimisticLockingFailureException`'ı yakalayıp aynı kaydetmeyi sessizce yeniden denemek -- bu yalnızca aynı eski-veri sorununu tekrarlar.
- `@Version`-tabanlı optimistic locking yeterli olacakken varsayılan olarak `@Lock(PESSIMISTIC_WRITE)`'a başvurmak, o satıra dokunan her transaction'ı bekletmek.

## Özet, Cheat Sheet ve Terimler Sözlüğü

**Özet**

- Persistence context, bir transaction'ın yüklediği ya da kaydettiği her entity'yi izler -- "Transaction Management"te zaten işlenen dirty checking'i baştan mümkün kılan şey budur.
- Bir entity, transient (izlenmeyen, yeni), managed (izlenen), detached (artık izlenmeyen), ya da removed (silinmek üzere planlanmış)dir -- asla aynı anda birden fazlası değil.
- First-level cache, tek bir persistence context içinde aynı entity'yi iki kez istemenin, ikinci bir sorgu olmadan tam olarak aynı nesneyi döndürebileceği anlamına gelir.
- `persist()`, veritabanında hiç var olmamış entity'ler içindir; `merge()`, zaten var olan detached entity'ler içindir.
- Bir flush, izlenen değişiklikleri SQL olarak veritabanına gönderir -- onları görmesi gereken bir sorgudan önce otomatik olarak, ya da `flush()` ile açıkça.
- `@Version` (optimistic locking), iki transaction arasındaki bir çarpışmayı gerçekleştikten sonra tespit eder; `@Lock(PESSIMISTIC_WRITE)`, çarpışmayı baştan imkansız kılar.

**Cheat Sheet**

```java
// Entity yaşam döngüsü
Topic topic = new Topic();        // transient
em.persist(topic);                // managed
em.detach(topic);                 // detached
Topic managed = em.merge(topic);  // yeniden managed
em.remove(managed);               // removed

// First-level cache: aynı id, aynı nesne, tek bir persistence context içinde
repository.findById(5L) == repository.findById(5L) // true

// Optimistic locking
@Version
private Integer version;
// UPDATE ... WHERE id = ? AND version = ?  (satır zaten ilerlediyse başarısız olur)

// Pessimistic locking
@Lock(LockModeType.PESSIMISTIC_WRITE)
@Query("select t from Topic t where t.id = :id")
Topic findByIdForUpdate(Long id);
```

**Terimler Sözlüğü**

- **Persistence context**: bir transaction'ın yüklediği ya da kaydettiği her entity'yi izleyen, dirty checking'i ve first-level cache'i mümkün kılan nesne.
- **Entity durumu**: transient, managed, detached, ya da removed -- bir entity'nin persistence context'le mevcut ilişkisi.
- **First-level cache**: persistence context'in kendi identity map'i, tek bir persistence context içinde aynı id için aynı nesne instance'ını döndürür.
- **Flush**: izlenen değişikliklerin SQL olarak veritabanına gönderildiği an, hem değişikliğin kendisinden hem de transaction'ın commit'inden ayrı.
- **Optimistic locking (@Version)**: iki transaction arasındaki bir çarpışmayı, her güncellemede kontrol edilen bir version sütunuyla, gerçekleştikten sonra tespit etmek.
- **Pessimistic locking (@Lock)**: bir çarpışmayı, sonradan bir çakışmayı tespit etmek yerine diğer transaction'ları bekleterek, gerçek bir veritabanı kilidi tutarak önlemek.
