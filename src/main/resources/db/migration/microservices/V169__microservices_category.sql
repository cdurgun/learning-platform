-- Yeni bir kategori: "Microservices" (spring-boot kursu, category.sort_order=3,
-- spring-core=1 ve spring-mvc=2'den sonra -- spring-mvc kategorisinin dokuz topic'i
-- Faz 18-26'da tamamlanmıştı).
--
-- Kullanıcı ChatGPT'nin hazırladığı 12 topic'lik bir mikroservis planı paylaştı; ayrı bir
-- Claude oturumunda değerlendirilip şu kararlara varıldı: (1) 12 topic'i baştan taahhüt
-- etmeden, küçük dalgalar (wave) hâlinde ilerlenecek -- bu kategori şimdilik yalnızca
-- ilk topic'iyle açılıyor, kalan 11 aday konu DB'ye seed edilmedi; (2) pratik proje,
-- React kursundaki "react-course-projects" deseninin aynısıyla, learning-platform'dan
-- tamamen ayrı, izole bir repoda ("microservices-course-projects") olacak, bu projenin
-- kendi mimarisine dokunulmayacak; (3) sandbox kısıtı erkenden doğrulandı -- bu oturumda
-- (önceki fazlardan farklı olarak) java 21/mvn 3.9.11 kurulu, ama Maven Central
-- (repo.maven.apache.org, repo1.maven.org) proxy tarafından 403 ile engelleniyor ve
-- ~/.m2 önbelleği yok -- yani gerçek bir Spring Boot bağımlılığı bu ortamda hiç
-- indirilemiyor, `mvn compile`/`spring-boot:run` çalışmıyor; kod, kursun zaten
-- doğrulanmış Spring Boot örneklerine dayanarak dikkatle yazılacak, gerçek derleme/
-- çalıştırma doğrulaması her topic bitince kullanıcıdan istenecek (Production
-- kategorisindeki, Faz 39, aynı ritim); (4) Kafka/Eureka/Docker Compose/Kubernetes gibi
-- altyapı ağırlıklı konularda test ritmi de aynı şekilde -- her topic bitince kullanıcıdan
-- somut doğrulama istenecek.
--
-- İlk topic "Microservices Nedir?": monolit vs mikroservis, monolitin sınırları, servis
-- sınırlarının (business capability / bounded context) nasıl belirlendiği, database per
-- service, dağıtık sistemlerin getirdiği yeni zorluklar (ağ güvenilmezliği, eventual
-- consistency), CAP teoremine kısa bakış, Conway Yasası, "modüler monolith" ara yolu,
-- monolith/mikroservis karar kriterleri. Kullanıcı kararıyla bilinçli olarak KOD YOK --
-- React Fundamentals'ın ilk konularındaki (Faz 28) "teori ağırlıklı, henüz kod yazmaya
-- başlamıyoruz" desenine bilinçli bir referansla, ama Java/Spring kursunun genel
-- yapısına uygun şekilde Best Practices/Yaygın Hatalar/Özet-Terimler Sözlüğü kapanışıyla.
-- Bu yüzden "## Ek: Mini Proje" YOK (pratik proje kategori sonunda, ayrı repoda gelecek)
-- ve bu migration'da code_example satırı YOK (0 embed, jsx/what-is-react ile aynı desen
-- -- bkz. react-fundamentals/V124, V125).
--
-- INTERMEDIATE zorlukta işaretlendi -- Spring Core/Spring MVC'nin başlangıç seviyesiyle
-- tutarlı (React'teki BEGINNER, o kursun kendi hedef kitlesine özgüydü).
--
-- Kullanıcı bu fazda yalnızca TR içeriğin yazılmasını istedi -- Faz 20 öncesi ritme
-- (TR tamamlanınca ayrı onayla EN'e geçmek) bilinçli bir dönüş, yeni ve daha yüksek
-- riskli bir kategori olduğu için. EN topic_translation satırı bu yüzden burada YOK,
-- TR onaylanıp EN yazıldığında ayrı bir migration'la eklenecek.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Microservices', 'microservices', 3
FROM course
WHERE slug = 'spring-boot';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'microservices-fundamentals', 'INTERMEDIATE', 20, 1
FROM category
WHERE slug = 'microservices';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Microservices Nedir?',
       'Monolitik mimarinin sınırları, mikroservis mimarisinin temel özellikleri, servis sınırlarını (bounded context) belirlemek, database per service, CAP teoremi ve Conway Yasası''na kısa bir bakış -- hiç kod yazmadan, kavramsal bir giriş.',
       'Microservices Nedir? Monolith vs Microservices | Kavramsal Giriş',
       'Microservices (mikroservis) mimarisi nedir, monolitik mimariden farkı ve monolitin hangi sınırları aştığında mikroservislere geçilir, servis sınırlarının (bounded context) nasıl belirlendiği, database per service prensibi, dağıtık sistemlerin getirdiği yeni zorluklar, CAP teoremi ve Conway Yasası -- hiç koda girmeden, kavramsal olarak anlatılıyor.',
       true
FROM topic
WHERE slug = 'microservices-fundamentals';
