-- Arama sonuçlarında kesilen ve okunması zor olan seo_description değerlerini yeniden yazar
-- (bkz. docs/google-seo-adsense-plan.md, Aşama 4): 300 karakteri aşan, Markdown ters tırnağı
-- ya da sözdizimi listesi içeren, ya da ziyaretçiye anlamsız iç atıflar taşıyan ilk 30 dersin
-- EN ve TR açıklamaları (60 kayıt). Yalnızca seo_description değişir; title, seo_title ve
-- içerik dosyalarına dokunulmaz. Slug + dil ile eşleştiği için ortamdan bağımsızdır ve tekrar
-- çalıştırılması aynı sonucu verir.
UPDATE topic_translation tt
SET seo_description = v.seo_description
FROM (VALUES
    ('sets', 'en', 'Learn how Java''s Set works and when to choose HashSet, LinkedHashSet or TreeSet, with the equals/hashCode contract, set operations and a measured lookup comparison.'),
    ('sets', 'tr', 'Java''da Set nasıl çalışır; HashSet, LinkedHashSet ve TreeSet''ten hangisi ne zaman seçilir? equals/hashCode sözleşmesi, küme işlemleri ve ölçülmüş bir arama karşılaştırması.'),
    ('primitive-parallel-streams', 'en', 'Avoid boxing overhead in Java with IntStream, LongStream and DoubleStream, and learn when parallel streams are actually faster and how shared state causes data races.'),
    ('primitive-parallel-streams', 'tr', 'Java''da IntStream, LongStream ve DoubleStream ile boxing maliyetinden kaçının; paralel stream ne zaman gerçekten hızlıdır ve paylaşılan durum veri yarışına nasıl yol açar?'),
    ('built-in-functional-interfaces', 'en', 'Java''s built-in functional interfaces explained: Predicate, Function, Consumer, Supplier, UnaryOperator and BinaryOperator, plus the four kinds of method reference.'),
    ('built-in-functional-interfaces', 'tr', 'Java''nın hazır functional interface''leri: Predicate, Function, Consumer, Supplier, UnaryOperator ve BinaryOperator ile dört method reference biçimi.'),
    ('lists', 'en', 'Java List explained: ArrayList vs LinkedList with a measured access-speed comparison, immutable lists, avoiding ConcurrentModificationException, and sorting with Comparator.'),
    ('lists', 'tr', 'Java''da List: ArrayList ve LinkedList''in ölçülmüş erişim hızı karşılaştırması, değiştirilemez listeler, ConcurrentModificationException''dan kaçınmak ve Comparator ile sıralama.'),
    ('maps', 'en', 'Learn Java''s Map interface and how HashMap, LinkedHashMap and TreeMap differ, with immutable maps and counting and grouping using computeIfAbsent and merge.'),
    ('maps', 'tr', 'Java''da Map arayüzü ve HashMap, LinkedHashMap ile TreeMap arasındaki farklar; değiştirilemez map''ler, computeIfAbsent ve merge ile sayma ve gruplama.'),
    ('queues-collections-utility', 'en', 'Queue and Deque in Java: why ArrayDeque is preferred for both queues and stacks, how the heap-based PriorityQueue works, and the Collections utility methods.'),
    ('queues-collections-utility', 'tr', 'Java''da Queue ve Deque: ArrayDeque neden hem kuyruk hem stack için tercih edilir, heap tabanlı PriorityQueue nasıl çalışır ve Collections sınıfının yardımcı metotları.'),
    ('terminal-operations', 'en', 'Learn the terminal operations that end a Java Stream pipeline: forEach, reduce, count, min and max, findFirst, anyMatch, allMatch, noneMatch and toList.'),
    ('terminal-operations', 'tr', 'Bir Java Stream pipeline''ını sonlandıran terminal operation''lar: forEach, reduce, count, min ve max, findFirst, anyMatch, allMatch, noneMatch ve toList.'),
    ('spring-boot-microservice-basics', 'en', 'See how a single Spring Boot microservice is put together: entry point, its own application.yml, REST controller, service layer, domain model, and an Actuator health check.'),
    ('spring-boot-microservice-basics', 'tr', 'Tek bir Spring Boot mikroservisi nasıl kurulur: giriş noktası, kendi application.yml dosyası, REST controller, service katmanı, domain modeli ve Actuator ile health check.'),
    ('stream-fundamentals', 'en', 'Start with the Java Stream API: what a stream is, how filter, map, flatMap, sorted and limit work, what lazy evaluation means, and why a stream can be used only once.'),
    ('stream-fundamentals', 'tr', 'Java Stream API''ye giriş: stream nedir; filter, map, flatMap, sorted ve limit nasıl çalışır, lazy değerlendirme ne demek ve bir stream neden yalnızca bir kez kullanılabilir?'),
    ('react-spring-boot-deployment', 'en', 'Deploy a React frontend to Vercel and a Spring Boot REST API to Render, including environment variables, production CORS settings, and the deploy order.'),
    ('react-spring-boot-deployment', 'tr', 'React arayüzünü Vercel''e, Spring Boot REST API''sini Render''a deploy edin: ortam değişkenleri, production CORS ayarları ve deploy sırası.'),
    ('optional', 'en', 'Learn Java''s Optional: creating one, the difference between orElse and orElseGet, throwing with orElseThrow, and transforming or filtering the value with map, flatMap and filter.'),
    ('optional', 'tr', 'Java''da Optional kullanımı: Optional oluşturmak, orElse ile orElseGet farkı, orElseThrow ile istisna fırlatmak ve map, flatMap, filter ile değeri dönüştürmek ya da süzmek.'),
    ('collectors', 'en', 'Collect Java Stream results with Collectors: toList and toSet, joining, groupingBy with downstream collectors, partitioningBy, and toMap with a merge function.'),
    ('collectors', 'tr', 'Java Stream sonuçlarını Collectors ile toplayın: toList ve toSet, joining, groupingBy ve downstream collector''lar, partitioningBy ve merge fonksiyonlu toMap.'),
    ('inter-service-communication', 'en', 'How two Spring Boot microservices call each other over REST with RestClient: base URL configuration, telling a 404 from a connection failure, and per-service DTOs.'),
    ('inter-service-communication', 'tr', 'İki Spring Boot mikroservisi RestClient ile REST üzerinden nasıl haberleşir: base URL yapılandırması, 404 ile bağlantı hatasını ayırt etmek ve servis bazında DTO''lar.'),
    ('lambda-expressions', 'en', 'Java lambda expression syntax explained: parameter forms, expression and block bodies, target typing, the effectively final rule, and lambdas vs anonymous inner classes.'),
    ('lambda-expressions', 'tr', 'Java''da lambda expression sözdizimi: parametre biçimleri, expression ve block body, target type çıkarımı, effectively final kuralı ve lambda ile anonymous inner class farkı.'),
    ('microservices-fundamentals', 'en', 'What microservices are, how they differ from a monolith, and when the move is worth it, with service boundaries, database per service, the CAP theorem and Conway''s Law.'),
    ('microservices-fundamentals', 'tr', 'Mikroservis mimarisi nedir, monolitten farkı ne ve geçiş ne zaman mantıklı? Servis sınırları, database per service, CAP teoremi ve Conway Yasası kavramsal olarak anlatılıyor.'),
    ('configuration-management', 'en', 'Centralize microservice configuration with Spring Cloud Config Server: config repository, client setup, profiles, runtime refresh, and keeping secrets out of plain text.'),
    ('configuration-management', 'tr', 'Spring Cloud Config Server ile merkezi mikroservis yapılandırması: config repository, client kurulumu, profiller, yeniden başlatmadan yenileme ve sırların düz metin tutulmaması.'),
    ('spring-mvc-views-thymeleaf', 'en', 'Render HTML views in Spring MVC with Thymeleaf: passing data with Model, Thymeleaf expressions, th:if and th:each, reusable fragments, and form binding.'),
    ('spring-mvc-views-thymeleaf', 'tr', 'Spring MVC''de Thymeleaf ile HTML view''ları oluşturun: Model ile veri aktarmak, Thymeleaf ifadeleri, th:if ve th:each, yeniden kullanılabilir fragment''lar ve form bağlama.'),
    ('component-testing', 'en', 'Test React components with Vitest and React Testing Library: setup in a Vite project, a first test with render and screen, queries by role and label, and conditional rendering.'),
    ('component-testing', 'tr', 'React component''lerini Vitest ve React Testing Library ile test edin: Vite projesine kurulum, render ve screen ile ilk test, role ve label''a göre sorgular ve koşullu render.'),
    ('service-discovery-eureka', 'en', 'Service discovery with Netflix Eureka and Spring Cloud: the registry server, registering clients, calling services by name instead of fixed URLs, and self-preservation mode.'),
    ('service-discovery-eureka', 'tr', 'Netflix Eureka ve Spring Cloud ile servis keşfi: kayıt sunucusunu kurmak, servisleri kaydetmek, sabit URL yerine servis adıyla çağrı yapmak ve self-preservation modu.'),
    ('wrapper-classes', 'en', 'Java wrapper classes and autoboxing explained: the Integer cache trap when comparing with ==, NullPointerException when unboxing null, and the performance cost in loops.'),
    ('wrapper-classes', 'tr', 'Java''da wrapper sınıfları ve autoboxing: == ile karşılaştırmada Integer önbelleği tuzağı, null unboxing''de NullPointerException ve döngülerdeki performans maliyeti.'),
    ('user-interaction-testing', 'en', 'Test user interactions in React with user-event: simulating clicks and typing, verifying form submission with mock functions, and testing asynchronous UI updates.'),
    ('user-interaction-testing', 'tr', 'React''te kullanıcı etkileşimlerini user-event ile test edin: tıklama ve yazma simülasyonu, sahte fonksiyonlarla form gönderimini doğrulama ve asenkron arayüz güncellemeleri.'),
    ('error-boundaries', 'en', 'Learn how React error boundaries catch rendering errors and show a fallback UI, the benefit of using several small boundaries, and which errors they do not catch.'),
    ('error-boundaries', 'tr', 'React''te error boundary''ler render hatalarını nasıl yakalar ve fallback UI gösterir? Birden fazla küçük boundary kullanmanın faydası ve yakalanmayan hata türleri.'),
    ('string', 'en', 'Why Java strings are immutable, what the string pool does, why you compare with equals rather than ==, and why StringBuilder is faster than + concatenation.'),
    ('string', 'tr', 'Java''da String neden immutable, string pool ne işe yarar, karşılaştırmada neden == yerine equals kullanılır ve StringBuilder neden + ile birleştirmeden daha hızlıdır?'),
    ('portals', 'en', 'Learn React portals: rendering a component into a different DOM node with createPortal, building modals, event bubbling through the React tree, and setting up a portal target.'),
    ('portals', 'tr', 'React portal''ları: createPortal ile bir component''i farklı bir DOM düğümüne render etmek, modal oluşturmak, event''lerin React ağacında bubble etmesi ve portal hedefi.'),
    ('lazy-loading-code-splitting', 'en', 'Load React components only when they are needed with React.lazy: route-based code splitting, named exports, and conditionally loading rarely used components.'),
    ('lazy-loading-code-splitting', 'tr', 'React.lazy ile component''leri yalnızca gerektiğinde yükleyin: route bazlı code splitting, named export''lar ve nadiren kullanılan component''lerin koşullu yüklenmesi.'),
    ('suspense', 'en', 'Learn React Suspense: loading states with fallback, nested boundaries, reading a Promise with the use hook in React 19, and why useEffect with fetch does not trigger it.'),
    ('suspense', 'tr', 'React Suspense''i öğrenin: fallback ile yükleme durumu, iç içe sınırlar, React 19''un use hook''uyla Promise okumak ve useEffect ile fetch''in onu neden tetiklemediği.'),
    ('date-time', 'en', 'Learn the modern Java date and time API: LocalDate, LocalDateTime, Instant and ZonedDateTime, Duration and Period, formatting, time zones, and migrating from Date and Calendar.'),
    ('date-time', 'tr', 'Java''nın modern tarih ve saat API''si: LocalDate, LocalDateTime, Instant ve ZonedDateTime, Duration ve Period, biçimlendirme, saat dilimleri, Date ve Calendar''dan geçiş.'),
    ('arrays', 'en', 'Java arrays explained: multi-dimensional and jagged arrays, sorting and searching with the Arrays class, the array covariance trap, how Arrays.asList behaves, and varargs.'),
    ('arrays', 'tr', 'Java''da diziler: çok boyutlu ve jagged diziler, Arrays sınıfıyla sıralama ve arama, array covariance''ın ArrayStoreException tuzağı, Arrays.asList''in davranışı ve varargs.'),
    ('react-rest-api', 'en', 'Connect a React app to a REST API such as a Spring Boot backend: fetch calls in one module, listing, creating and deleting a resource, and updating the UI after each change.'),
    ('react-rest-api', 'tr', 'React''i Spring Boot gibi bir backend''in REST API''sine bağlayın: tek modülde fetch çağrıları, kaynak listeleme, oluşturma, silme ve her değişiklikten sonra arayüzü güncelleme.'),
    ('sharing-state', 'en', 'How to share state between React components: lifting state up to a common ancestor, and the prop drilling problem of passing props through layers that do not use them.'),
    ('sharing-state', 'tr', 'React''te component''ler arası state paylaşımı: state''i ortak ataya taşımak (lifting state up) ve prop''ları kullanmayan ara katmanlardan geçirmekten doğan props drilling sorunu.')
) AS v(slug, language, seo_description)
JOIN topic t ON t.slug = v.slug
WHERE tt.topic_id = t.id
  AND tt.language = v.language;
