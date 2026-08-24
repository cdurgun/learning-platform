"Spring MVC'de Test Yazmak", `@DataJpaTest`'i bir kez, geçerken, `@WebMvcTest`'in kardeşi bir slice-test annotation'ı olarak andı -- ve bir daha ona hiç dönmedi. Bu kategorinin kendi servis testleri (`QuizServiceTest`, `QuestionIngestServiceTest` ve geri kalanı), her repository'yi Mockito ile mock'lar, ki bu bir servisin kendi mantığını izole olarak test etmek için tam olarak doğrudur -- ama bu kapanış dersinin doldurduğu gerçek bir boşluk bırakır: bu projede hiçbir yerde, bir derived query metodunun, elle yazılmış bir `@Query`'nin, ya da bir `Specification`'ın adının ya da JPQL'inin iddia ettiği şeyi gerçekten yaptığını hiçbir şey doğrulamaz.

## Bir Repository'yi Mock'lamak Neden Yetmez

Mock'lanmış bir repository, sana tam olarak ne söylediysen onu döndürür -- fazlası değil.

{{MockedRepositoryLimitationExample.java}}

`when(repository.findBySlug("records")).thenReturn(...)`, mock'un davranışını doğrudan yapılandırır -- Spring Data JPA'dan `findBySlug`'ı gerçek bir sorguya ayrıştırmasını asla istemez, ve asla bir veritabanına dokunmaz. GERÇEK metot yanlış yazılmış olsaydı, ya da tamamen yanlış bir sütunda filtreleseydi, bu test yine de geçerdi, çünkü yalnızca mock'un kendi yapılandırılmış davranışını doğrular. Sorgunun kendisini doğrulamak, onu gerçekten çalıştıran bir şeye ihtiyaç duyar.

## @DataJpaTest: Persistence Katmanı İçin Bir Slice Test

`@DataJpaTest`, "Spring MVC'de Test Yazmak"ta anılan ama hiç açıklanmayan `@WebMvcTest`'in kardeşidir -- aynı "slice test" fikri, karşıt katmana uygulanmış.

{{DataJpaTestWithTestEntityManagerExample.java}}

`@WebMvcTest`'in yalnızca web katmanını yüklediği yerde, `@DataJpaTest` yalnızca PERSISTENCE katmanını yükler -- entity'ler, repository'ler, ve gerçek bir veritabanı bağlantısı, ama bu projenin hiçbir controller'ı ya da servisi değil. Her test metodu da kendi transaction'ı içinde çalışır, sonrasında otomatik olarak rollback edilir, bu yüzden bir testin verisi bir sonrakine asla sızmaz.

## @DataJpaTest Gerçekte Neyi Kurar

Test-başına-transaction davranışının ötesinde, `@DataJpaTest` bir avuç şeyi birlikte yapılandırır: özellikle `@Entity` sınıflarını ve Spring Data JPA repository'lerini tarar (`@Controller`'ları ya da `@Service`'leri değil), Hibernate'i gerçek bir veritabanı bağlantısına karşı yapılandırır, ve -- varsayılan olarak -- yapılandırılmış olan `DataSource`'u, sırada "Embedded Test Database vs. Gerçek PostgreSQL"in işlediği bir davranışla, embedded, bellek-içi bir taneyle değiştirir.

## TestEntityManager: Bir Repository Olmadan Veri Kurmak

Bir test için veritabanına veri koymak, testin doğrulamaya çalıştığı repository metodunun kendisini kullanmamalıdır -- o metottaki bir hata kendini gizleyebilir.

`TestEntityManager` -- "The Persistence Context and Locking"te işlenen `EntityManager`'dan farklı -- onun etrafında, veriyi doğrudan kurmak için kullanışlı metotları olan, test-odaklı bir sarmalayıcıdır. Yukarıdaki örnekte kullanılan `persistAndFlush(...)`, bir entity'yi kaydeder ve (orada da işlenen) anlık bir flush'ı zorlar, test gerçekte test ettiği repository metodunu çağırmadan önce satırın gerçekten var olduğunu garanti eder.

## Bir Derived Query Metodunu Test Etmek

Derived bir query metodu ("Query Methods and JPQL with @Query"te işlenen), iki bağımsız şekilde yanlış gidebilir -- yanlış satırları filtreleyerek, ya da onları yanlış sıralayarak -- ve iyi bir test ikisini de kontrol eder.

{{DerivedQueryMethodTestExample.java}}

İKİ farklı topic için, bilinçli olarak sırasız veri kaydetmek, sonra hem yalnızca doğru topic'in satırlarının geri geldiğini HEM de doğru sıralandıklarını doğrulamak, `findByTopicIdOrderBySortOrderAsc`'ın gerçek filtreleme ve gerçek sıralama yaptığını gerçekten kanıtlayan şeydir -- yalnızca "kaydedilen her neyse onu döndürür"ü değil, ki bu daha küçük, tek satırlı bir test yanlışlıkla, gerçekte hiçbir şey kanıtlamadan geçebilirdi.

## Custom Bir @Query'yi Test Etmek

Elle yazılmış bir `@Query`, derived bir metot adı kadar sözdizimsel olarak yanlış yazılması kolaydır -- yanlış yazılmış bir property yolu, eksik bir join.

{{CustomQueryTestExample.java}}

Bu, "Transaction Management"te işlenen bu projenin gerçek `TopicRepository.findBySlugWithCategoryAndCourse`'unu yansıtır -- `join fetch`'in JPQL'inde bir yazım hatası olsaydı, bu test hemen başarısız olurdu, ya hiçbir sonuç olmadan ya da ilişkiye hâlâ açık olan test transaction'ının dışında erişildiği anda gerçek bir `LazyInitializationException`'la.

## Embedded Test Database vs. Gerçek PostgreSQL

`@DataJpaTest`'in varsayılan davranışı -- yapılandırılmış `DataSource`'u embedded, bellek-içi bir veritabanıyla (genelde H2) değiştirmek -- bir riski başka bir riskle takas eder.

Embedded bir veritabanı hızlıdır ve kurulum gerektirmez, ama PostgreSQL değildir -- PostgreSQL'e özgü bir davranışa dayanan bir sorgu (bu projenin gerçek `QuestionRepository.findRandomPublishedPool`'u, "Query Methods and JPQL with @Query"te işlenen, her embedded veritabanına karşı aynı şekilde davranmayacak, hatta gerekli şekilde çalışmayacak bir native `RANDOM()` sorgusu kullanır) embedded ikame karşısında geçebilir ve yine de gerçek şeye karşı başarısız olabilir. Doğrudan gerçek PostgreSQL'e karşı test etmek, bu boşluğu tamamen atlatır, her testin çalıştığı her yerde gerçek bir PostgreSQL instance'ının mevcut olması gerekliliği pahasına.

> 💡 Tip
> Bu projenin kendi `application-test.yml`'i, test profilini zaten embedded bir ikame yerine gerçek, yerel olarak çalışan bir PostgreSQL instance'ına yönlendiriyor -- projenin erken bir döneminde yazılan kendi yorumu, sırada işlenen aracı, daha sağlam bir uzun-vadeli cevap olarak zaten adlandırıyor.

## Testcontainers: Gerçekçi Orta Yol

Bu projenin kendi `application-test.yml`'inde doğrudan alıntılanmaya değer gerçek bir yorum var: bugünkü testler, yerel olarak çalışan bir PostgreSQL sunucusundaki elle oluşturulmuş bir `learning_test` veritabanına yönleniyor -- işe yarıyor, ama bu elle kurulum adımını gerektiriyor, ve her test çalışması, gerçekten temiz, tek kullanımlık bir tane yerine aynı veritabanını paylaşıyor. Yorumun kendi sözleri: "Testcontainers ile her test çalıştırmasında izole, tek kullanımlık bir Postgres container'ı ayağa kaldırmak çok daha sağlam olur."

{{TestcontainersSketchExample.java}}

`@Container` ve bir `PostgreSQLContainer`, tam olarak bu test sınıfı için Docker'da gerçek, tek kullanımlık bir PostgreSQL instance'ı başlatır; `@DynamicPropertySource`, Spring'in `DataSource`'unu ona yönlendirir; `AutoConfigureTestDatabase.Replace.NONE`, `@DataJpaTest`'in bunu kendi embedded varsayılanıyla geçersiz kılmasını durdurur. Bu, kurulumun ŞEKLİNİN bir taslağıdır, tam işlenmiş bir örnek değil -- Testcontainers'ın kendisi, kendi yapılandırma ve yaşam döngüsü meseleleriyle, burada eklenmiş bir derin dalışı değil, kendi ayrı, özel dersini hak edecek kadar büyük bir konu.

## Yaygın Yanlış Anlamalar

**"Geçen, mock'lanmış bir repository testi sorgunun çalıştığını kanıtlar."** Mock'un yapılandırıldığı gibi davrandığını kanıtlar -- gerçek, üretilmiş sorgu hakkında hiçbir şey hiç çalıştırılmaz. **"`@DataJpaTest`, tam olarak gerçek bir isteğin göreceği gibi bütün uygulamayı yükler."** Yüklemez -- bilinçli olarak `@SpringBootTest`'ten daha dar bir slice testtir, yalnızca entity'leri ve repository'leri yükler, controller'ları ya da servisleri değil. **"Embedded bir test veritabanı, gerçek PostgreSQL'e karşı test etmek kadar iyidir."** Daha hızlıdır ve kurulum gerektirmez, ama PostgreSQL'e özgü bir sorgu (özellikle bir native sorgu), embedded bir ikame karşısında farklı davranabilir, ya da hiç çalışmayabilir.

## Best Practices

- Bir derived query metodunun, custom bir `@Query`'nin, ya da bir `Specification`'ın gerçekten iddia ettiğini yaptığını doğrulamak için özellikle `@DataJpaTest`'e başvur -- bir repository'yi mock'lamak sana bunu söyleyemez.
- Bir testin verisini kurmak için, test edilen repository metodunun kendisi yerine `TestEntityManager` kullan, kendi kurulumunun arkasına gizlenen bir hatadan kaçınmak için.
- Bir sorgunun hem NEYİ içerdiğini HEM DE NEYİ hariç tuttuğunu (ya da sonuçları nasıl sıraladığını) test et -- birden fazla durum için veri kaydetmek, yalnızca "bir şey geri geldi"yi değil, filtreleme/sıralama mantığını gerçekten kanıtlayan şeydir.
- Bir sorgu, generic bir embedded veritabanının tekrarlayamayabileceği PostgreSQL'e özgü bir davranışa dayandığı anda, embedded bir ikame yerine Testcontainers'a başvur.

## Yaygın Hatalar

- Geçen, Mockito-mock'lanmış bir repository testini, yalnızca mock'un kendi yapılandırılmış davranışını kanıtlarken, bir sorgunun doğru olduğunun kanıtı olarak ele almak.
- Bir `@DataJpaTest`'in test verisini, test edilen repository metodunun tam kendisi üzerinden kurmak, kendi kurulumunun arkasına gizlenen bir hata riski taşımak.
- Derived bir query metodunu yalnızca tek bir kaydedilmiş satırla test etmek, birden fazla satır arasında filtrelemenin ya da sıralamanın gerçekten çalışıp çalışmadığı hakkında hiçbir şey kanıtlamamak.
- Embedded bir test veritabanının, özellikle PostgreSQL'e özgü SQL'e dayanan bir native sorgu için, her sorguda PostgreSQL'le birebir aynı davrandığını varsaymak.

## Özet, Cheat Sheet ve Terimler Sözlüğü

**Özet**

- Bir repository'yi mock'lamak bir servisin kendi mantığını doğrular, ama gerçek bir sorgunun gerçekten çalıştığı hakkında hiçbir şey kanıtlamaz -- `@DataJpaTest` bu boşluğu kapatır.
- `@DataJpaTest`, `@WebMvcTest`'in kardeşi slice testtir, yalnızca entity'leri, repository'leri, ve gerçek bir veritabanı bağlantısını yükler, her test kendi rollback edilen transaction'ında çalışır.
- `TestEntityManager`, test verisini doğrudan, bilinçli olarak test edilen repository metodundan bağımsız olarak kurar.
- İyi bir sorgu testi, birden fazla durum için veri kullanarak hem filtrelemeyi hem sıralamayı kontrol eder.
- `@DataJpaTest` varsayılan olarak embedded bir veritabanına düşer; PostgreSQL'e özgü bir davranışa dayanan bir sorgu gerçek PostgreSQL'e ihtiyaç duyar, test çalışması başına izole, tek kullanımlık bir instance elde etmenin gerçekçi yolu olarak Testcontainers'la.

**Cheat Sheet**

```java
// Temel bir @DataJpaTest
@DataJpaTest
class TopicRepositoryTest {

    @Autowired TestEntityManager entityManager;
    @Autowired TopicRepository repository;

    @Test
    void findBySlug_returnsThePersistedTopic() {
        entityManager.persistAndFlush(new Topic("records"));
        assertThat(repository.findBySlug("records")).isPresent();
    }
}

// Filtrelemeyi VE sıralamayı birlikte test etmek
entityManager.persist(new CodeExample(topicId, 2));
entityManager.persist(new CodeExample(topicId, 1));
entityManager.persist(new CodeExample(otherTopicId, 1));
List<CodeExample> result = repository.findByTopicIdOrderBySortOrderAsc(topicId);
assertThat(result).hasSize(2); // filtrelendi
assertThat(result.get(0).getSortOrder()).isEqualTo(1); // sıralandı

// Embedded varsayılan yerine Testcontainers ile gerçek PostgreSQL
@Testcontainers
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class RealDatabaseTest {
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");

    @DynamicPropertySource
    static void props(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
    }
}
```

**Terimler Sözlüğü**

- **@DataJpaTest**: yalnızca persistence katmanını (entity'ler, repository'ler, bir veritabanı bağlantısı) yükleyen, her testin kendi rollback edilen transaction'ında çalıştığı bir slice test.
- **TestEntityManager**: `EntityManager`'ın etrafında, veriyi doğrudan, test edilen repository'den bağımsız olarak kurmak ya da incelemek için kullanılan, test-odaklı bir sarmalayıcı.
- **Embedded test veritabanı**: `@DataJpaTest`'in varsayılan olarak yerine koyduğu, hızlı ama PostgreSQL'le birebir aynı olmayan bellek-içi bir veritabanı (genelde H2).
- **Testcontainers**: bir test çalışması süresince Docker'da gerçek, tek kullanımlık bir veritabanı (ya da başka bir servis) başlatan, hem embedded-veritabanı boşluğundan hem de elle yönetilen paylaşılan bir test veritabanından kaçınan bir kütüphane.
