"JPA, Hibernate ve Spring Data JPA", zihinsel-model seviyesinde kaldı -- tek bir minimal `@Entity`, tek bir repository interface'i, ikisini de doğru yapan şeye dair gerçek bir ayrıntı yoktu. Bu ders bunu dolduruyor: bir sınıfın düzgün eşlenmiş bir JPA entity'si olması için tam olarak neye ihtiyacı olduğu, ve `Repository` → `CrudRepository` → `JpaRepository` hiyerarşisinin her katmanının gerçekte ne kattığı.

## @Entity, @Table ve Primary Key'ler: @Id ve @GeneratedValue

Önceki dersin `@Entity`/`@Id`/`@GeneratedValue` üçlüsü başlangıç noktası -- bu projenin gerçek `Topic` entity'si, bu eşlemenin gerçekten tam bir versiyonunun neye benzediğini gösteriyor.

{{EntityMappingExample.java}}

`@Table(name = "topic")`, Hibernate'in sınıf adından bir tane çıkarmasına izin vermek yerine, tabloyu açıkça adlandırır -- adlar zaten eşleşecek olsa bile bunu yapmakta fayda var, çünkü eşlemeyi örtük değil, okunduğunda açık hâle getirir. `@GeneratedValue(strategy = GenerationType.IDENTITY)`, id üretimini PostgreSQL'in kendi auto-increment'ine devreder -- birkaç üretim stratejisinin en basiti, ve bu projenin her yerde kullandığı. `SEQUENCE` ve `AUTO`, daha ince kontrol gerektiren senaryolar için vardır, ama `IDENTITY` uygulamaların büyük çoğunluğunu kapsar. `category` alanına da dikkat et -- bu bir ilişki, `@ManyToOne` ile eşlenmiş. Şimdilik onu yalnızca başka bir eşlenmiş alan gibi ele al; `fetch = FetchType.LAZY`'nin gerçekte ne yaptığı, ve bunun gibi ilişkilerin gerçekte nasıl davrandığı, bu kategoride ilerideki "İlişkiler, Fetching ve N+1 Problemi"nin konusu.

## Alanları Eşlemek: @Column, Nullable ve Unique Kısıtları

Bir alanın eşlenmesi için hiçbir annotation'a ihtiyacı yoktur -- Hibernate, alan adından otomatik olarak bir sütun adı çıkarır. `@Column`, daha fazlasını söylemesi gereken durumlar içindir.

`slug` üzerindeki `@Column(nullable = false, unique = true)`, yalnızca Java'da bir yerde kontrol edilen değil, VERİTABANININ kendisi tarafından zorlanan gerçek bir `NOT NULL UNIQUE` kısıtı hâline gelir -- bu projenin kendi Flyway migration'larının o sütun için bildirdiğiyle birebir eşleşerek. `@Column(name = "estimated_minutes")`, yalnızca gerçek sütun adı alan adıyla (burada `estimatedMinutes`) eşleşmediğinde gereklidir -- `slug`'da olduğu gibi zaten eşleştiklerinde, `name`e gerek yoktur.

## @Enumerated ile Enum Alanları

Bir enum alanının açıkça verilmesi gereken bir kararı vardır, yoksa gerçekten tehlikeli bir varsayılan devreye girer.

{{EnumeratedFieldExample.java}}

`@Enumerated(EnumType.STRING)`, enum sabitinin ADINI ("INTERMEDIATE") sütunda saklar -- veritabanında doğrudan okunabilir, ve enum'un sabitlerini daha sonra yeniden sıralamak güvenlidir. Alternatif, `EnumType.ORDINAL` (`@Enumerated`'i basitçe atlayarak elde ettiğin şey), sabitin POZİSYONUNU düz bir tamsayı olarak saklar -- biri enum'un ortasına yeni bir sabit ekleyene kadar zararsızdır, o noktada var olan her satırın sakladığı sayı, gerçekte kaydedildiği sabitten SESSİZCE farklı bir sabiti işaret eder. Bu projenin kendi `Topic.difficulty` alanı `STRING` kullanıyor, ve bu kendi kodunda da varsayılan seçim olmalı.

## İyi Biçimlendirilmiş Bir Entity İçin Birkaç Kural Daha

Bir sınıfı gerçekten iyi biçimlendirilmiş bir JPA entity'si yapan şeyi tamamlayan bir avuç küçük kural var -- her biri kendi tam bölümüne ihtiyaç duymayacak kadar dar.

{{WellFormedEntityRulesExample.java}}

**Argümansız bir constructor gereklidir**, önceki dersin zaten belirttiği gibi -- Hibernate, entity instance'larını, hiçbir alan doldurulmadan önce, reflection ile inşa eder, bu yüzden hiçbir argümanla çağrılabilecek bir constructor'a ihtiyacı vardır; `protected` (`public` yerine), onu Hibernate'e açık tutarken uygulama kodunun onu doğrudan çağırmasını caydıran yaygın bir konvansiyondur. (Bu aynı zamanda, "Record"un işlediği gibi, bir `record`'un asla bir JPA entity'si OLAMAMASININ tam nedenidir -- ne argümansız bir constructor'ı ne de sonradan doldurulacak mutable alanları vardır.)

**`equals()`/`hashCode()`, entity'lere özgü bir dikkat gerektirir.** `equals()`'ı id'ye dayandırmak açıkça doğru görünür, ama iki yepyeni, kaydedilmemiş entity'nin ikisi de `id == null`'dır -- yalnızca id'ye göre karşılaştırmak, her yeni instance'ı diğer her yeni instance'a "eşit" yapardı, bu yüzden bu implementasyon iki entity'yi yalnızca ikisi de gerçek, eşleşen bir id'ye sahip olduğunda eşit sayar. `hashCode()`'un (id'yi hash'lemek yerine) SABİT bir değer döndürmesi daha ince bir nedenle önemlidir: bir entity'nin hashCode'u, bir `HashSet`/`HashMap`'e yerleştirildikten sonra asla değişmemelidir, ama id'si -- `null`'dan gerçek bir değere -- tam olarak kaydedildiği anda değişir, bu yüzden id'yi hash'lemek bu sözleşmeyi tam da önemli olduğu anda bozardı.

## Entity vs. DTO

Bir `@Entity` ve bir DTO farklı sorunları çözer, ve bunları karıştırmak bir REST API'si olan bir Spring Boot uygulamasında gerçek sorunlara yol açar.

{{EntityVsDtoExample.java}}

`Topic`'i doğrudan `TopicController`'dan döndürmek, API'nin genel JSON şeklini veritabanı eşlemesinin kendisine bağlardı -- bir sütunu yeniden adlandırmak, hiç kimse controller'a dokunmadan yanıtı değiştirir -- ve bir transaction dışında lazy bir alanı serialize etmeye çalışma riski taşır (tam olarak "Transaction Management"in işlediği `LazyInitializationException` senaryosu). "Record"da işlendiği gibi bir `record` olan `TopicResponse`, `Topic`'in kendisinin nasıl eşlendiğinden ya da getirildiğinden tamamen bağımsız, yalnızca bu tek yanıtın gerçekten ihtiyaç duyduğunu açığa çıkaran küçük, ayrı bir türdür.

## Repository Hiyerarşisi: Repository, CrudRepository ve JpaRepository

Bu projedeki her repository interface'i `JpaRepository`'yi genişletir -- ama `JpaRepository`'nin kendisi kısa bir zincirin son halkasıdır, ve her halkanın ne kattığını bilmek, o "bedava" metotların hepsinin gerçekte nereden geldiğini açıklar.

{{RepositoryHierarchyExample.java}}

`Repository`, köktür -- hiçbir metot katmayan bir marker interface'i; tek işi, Spring Data'nın "bu bir repository" olduğunu tanımasına ve onun için bir bean üretmesine izin vermektir. `CrudRepository`, her repository'nin ihtiyaç duyduğu temel işlemleri ekler -- `save`, `findById`, `findAll`, `count`, `existsById`, `deleteById` ve daha fazlası -- Spring Data JPA'nın kendi içinde bir kez yazılmış, burada bedavaya miras alınan. `JpaRepository`'nin de genişlettiği `PagingAndSortingRepository`, `findAll(Sort)` ve `findAll(Pageable)` ekler -- kendi sorgu kodun olmadan sıralı ve sayfalı okumalar; bunları gerçekten kullanmak, bu kategoride ilerideki "Sayfalama, Sıralama ve Projeksiyonlar"ın konusu. `JpaRepository`'nin kendisi, daha genel katmanların bilmediği JPA'ya özgü ekstralar ekler -- `flush()`, `saveAndFlush(...)`, `deleteAllInBatch()`.

## Her Katman Gerçekte Sana Ne Verir

Sade bir dille: `interface CategoryRepository extends JpaRepository<Category, Long> {}`'ı -- boş bir gövdeyle -- bildirmek, hiçbirini senin yazmadığın, tamamen çalışan bir `save`, `findById`, `findAll`, `count`, `existsById`, `deleteById`, sıralı/sayfalı okumalar, ve JPA'ya özgü toplu işlemler zaten verir. Bu tam olarak önceki dersteki "Spring Data JPA çalışan bir implementasyon üretir" ifadesinin anlamıydı -- gerçek işi yapan bu üç miras alınan katmandır, her interface için özel olarak icat edilen bir şey değil.

## Bir Araya Getirmek: Bu Projenin Topic'i ve Category'si

Bu projenin gerçek `Topic` ve `Category` entity'leri, ve onların repository'leri, bu dersin her parçasını birbirine bağlıyor: `Topic`, `@Entity`/`@Table` ile `topic` tablosuna eşlenir, `id`'si `@GeneratedValue(strategy = IDENTITY)` ile veritabanı tarafından üretilir, `slug`'ı `@Column` ile `NOT NULL UNIQUE`'dir, `difficulty`'si `@Enumerated` ile `STRING`-eşlenmiş bir enum'dur, ve `TopicRepository extends JpaRepository<Topic, Long>`, sıfır elle yazılmış CRUD koduyla ona çalışan kalıcılık verir. `Category`, kendi tablosu için aynı deseni birebir izler. Ne entity'nin ne de repository'nin hiçbiri, bu dersin az önce işlediğinin ötesinde hiçbir şey gerektirmedi.

## Yaygın Yanlış Anlamalar

**"Bir entity'nin yalnızca getter/setter'a ihtiyacı vardır."** İyi biçimlendirilmiş bir entity'nin ayrıca argümansız bir constructor'a, ve (genelde) id-tabanlı `equals()`/`hashCode()`'a ihtiyacı vardır -- ikisini de atlamak, gecikmeli de olsa gerçek sorunlara yol açar. **"`@Column`, her alan için gereklidir."** Değildir -- Hibernate varsayılan olarak her alanı eşler; `@Column`, yalnızca varsayılanın ötesinde bir şey (farklı bir isim, bir kısıt) söylemek içindir. **"Bir repository interface'inin metotları bir şekilde interface başına, sıfırdan üretilir."** Üretilmez -- `save`/`findById`/`findAll` ve geri kalanı, Spring Data JPA'nın zaten bir kez implement ettiği küçük, sabit bir interface kümesinden (`CrudRepository`, `PagingAndSortingRepository`, `JpaRepository`) gelir; senin interface'in onları yalnızca miras alır.

## Sırada Ne Var

Bu ders, tek, bağımsız bir entity'yi eşlemeyi ve bedavaya gelen repository metotlarını kullanmayı işledi -- hiçbir yerde custom bir sorgu yazılmadı. Bu kategoride sıradaki "Query Metotları ve JPQL ile @Query", tam olarak bunu işliyor: bir metodun adından bir sorgu çıkarmak (`TopicRepository`'nin gerçek `findBySlug(...)`'ı gibi, önceki derste yalnızca geçerken adı anılan), ve türetilmiş bir isim yetmediğinde `@Query` ile doğrudan JPQL yazmak.

## Best Practices

- Her `@Enumerated` alanı için `EnumType.STRING` kullan -- `ORDINAL`'ın sessiz-bozulma riski, biraz daha küçük depolama alanını neredeyse hiçbir zaman haklı çıkarmaz.
- Her entity'ye argümansız bir constructor (kural olarak protected) ve sabit bir `hashCode()` ile id-tabanlı `equals()`/`hashCode()` ver -- ikisini de sonradan akla gelen bir şey değil, bir kontrol listesi olarak ele al.
- Bir REST API'sinden entity değil, DTO döndür -- yanıt şeklinin entity'nin kendi eşlemesiyle sürüklenmesine izin vermek yerine bilinçli olarak karar ver.
- Varsayılan seçim olarak (daha dar `CrudRepository` yerine) `JpaRepository`'ye başvur -- eklediği paging/sorting ve JPA'ya özgü ekstralar, nadiren vazgeçmek isteyeceğin şeylerdir.

## Yaygın Hatalar

- `@Enumerated(EnumType.STRING)`'i atlayıp varsayılan olarak `ORDINAL`'ı almak, sonra enum'u daha sonra yeniden sıralayıp var olan veriyi sessizce bozmak.
- `equals()`/`hashCode()`'u, lazy bir ilişki dahil, bir entity'nin TÜM alanlarına dayandırarak yazmak -- bu, istenmeyen veritabanı erişimini tetikleyebilir, ya da o anda ne yüklü olduğuna bağlı olarak tutarsız sonuçlar üretebilir.
- Bir `@RestController` metodundan düz bir `@Entity` döndürmek, API'nin yanıt şeklini veritabanı şemasına bağlamak ve bir `LazyInitializationException` riski taşımak.
- Bir repository interface'inin bir yerde elle yazılmış bir implementasyona ihtiyacı olduğunu varsaymak -- yoktur; miras alınan üç katman zaten başlangıçta bir tane sağlar.

## Özet, Cheat Sheet ve Terimler Sözlüğü

**Özet**

- `@Entity` + `@Table`, bir sınıfı bir tabloya eşler; `@Id` + `@GeneratedValue(strategy = IDENTITY)`, bu projenin standart primary-key eşlemesidir.
- `@Column(nullable = ..., unique = ...)`, gerçek veritabanı kısıtlarını zorlar; bir alanın varsayılan olarak eşlenmesi için hiçbir annotation'a ihtiyacı yoktur.
- `@Enumerated(EnumType.STRING)`, bir enum alanını eşlemenin güvenli yoludur -- `ORDINAL`, enum daha sonra yeniden sıralanırsa sessiz veri bozulması riski taşır.
- İyi biçimlendirilmiş bir entity'nin argümansız bir constructor'a ve (genelde) sabit bir `hashCode()` ile id-tabanlı `equals()`/`hashCode()`'a ihtiyacı vardır.
- Bir entity ve bir DTO farklı sorunları çözer -- bir REST API'sinden doğrudan entity değil, DTO döndür.
- `Repository` → `CrudRepository` → `PagingAndSortingRepository` → `JpaRepository`, gerçek bir kalıtım zinciridir -- her "bedava" repository metodu, bu zincirin belirli bir katmanına kadar iz sürülebilir.

**Cheat Sheet**

```java
@Entity
@Table(name = "topic")
public class Topic {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String slug;

    @Enumerated(EnumType.STRING)
    private Difficulty difficulty;

    protected Topic() {} // gerekli, argümansız

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Topic t)) return false;
        return id != null && id.equals(t.id);
    }

    @Override
    public int hashCode() { return Objects.hashCode(getClass()); }
}

// Repository → CrudRepository → PagingAndSortingRepository → JpaRepository
interface TopicRepository extends JpaRepository<Topic, Long> {
    // save/findById/findAll/count/existsById/deleteById -- CrudRepository'den
    // findAll(Sort)/findAll(Pageable)                    -- PagingAndSortingRepository'den
    // flush()/saveAndFlush()/deleteAllInBatch()            -- JpaRepository'den
}
```

**Terimler Sözlüğü**

- **@Table**: bir `@Entity`'nin sınıf adından çıkarılan bir isme güvenmek yerine, eşlendiği tabloyu açıkça adlandırır.
- **GenerationType.IDENTITY**: id üretimini veritabanının kendi auto-increment'ine devreden bir id-üretim stratejisi.
- **EnumType.STRING vs. ORDINAL**: eşlenmiş bir sütunda bir enum'un adını (yeniden sıralaması güvenli) mı yoksa sayısal pozisyonunu (yeniden sıralaması güvensiz) mü saklamak.
- **DTO (Data Transfer Object)**: genelde bir `record`, veriyi belirli bir sınır (bir API yanıtı gibi) için, nasıl kalıcı hale getirildiğinden bağımsız olarak şekillendirmek için tasarlanmış bir tür.
- **Repository / CrudRepository / PagingAndSortingRepository / JpaRepository**: her Spring Data JPA repository'sinin arkasındaki kalıtım zinciri, her katman belirli bir miras alınan metot kümesi katıyor.
