-- `spring-data-jpa` kategorisine, onaylanan 9 topic'lik roadmap'in 8.'si
-- ekleniyor: "jpa-auditing" -- persistence-context-and-locking'in
-- (sort_order=7) hemen ardına, sort_order=8. Kategori şu an yedi topic
-- içeriyor, sort_order kaydırması gerekmiyor.
--
-- Kapsam (roadmap'in onaylanan tablosu): `@CreatedDate`/`@LastModifiedDate`/
-- `@CreatedBy`/`@LastModifiedBy`, `@EntityListeners(AuditingEntityListener.
-- class)`, `@EnableJpaAuditing`, `AuditorAware<T>`. Roadmap'te onaylandığı
-- gibi, Faz 121'deki "Persistence Context ve Locking"e GÖMÜLMEDİ --
-- ayrı, kompakt bir topic olarak kaldı.
--
-- Bu dersin motivasyonu, önceki topic'lerin çoğunun aksine, UYDURMA bir
-- örnek DEĞİL -- bu projenin kendi GERÇEK `QuestionIngestService`'i
-- (src/main/java/com/cdurgun/learning/service/QuestionIngestService.java)
-- grep ile önceden bulunup okundu: `Question.builder()...createdAt(now).
-- updatedAt(now).build()` ile, `LocalDateTime.now()`'ı elle bir servis
-- metodunda çağırarak, tam olarak bu dersin çözdüğü tekrarlı deseni
-- gösteriyor. Bu gerçek kod, dersin motivasyon bölümünde ("The Problem")
-- doğrudan kullanıldı. Bu projenin gerçek `Question`'ının zaten bir
-- `reviewedBy`/`reviewedAt` çifti (elle, bir admin review action'ıyla
-- ayarlanan) olduğu da not edilip `@LastModifiedBy`'dan (otomatik, "son
-- kaydeden kim") AÇIKÇA AYRIŞTIRILDI -- ikisi karıştırılmaması gereken
-- farklı kavramlar.
--
-- "Transaction Management"teki (Faz 82) dirty checking'e, `@LastModifiedDate`'in
-- "anlamlı" değişiklikleri değil her kaydetmeyi işlediği paralelini
-- kurarken, gerçek migration başlığıyla doğrulanmış bir referansla
-- değinildi, TEKRAR AÇIKLANMADI.
--
-- 5 örnek: `ManualTimestampProblemExample` (gerçek `QuestionIngestService`
-- deseninin illustrasyonu), `AuditedEntityExample` (`@CreatedDate`/
-- `@LastModifiedDate` + `@EntityListeners`), `EnableJpaAuditingExample`
-- (`@EnableJpaAuditing`, iki parçanın da gerekli olduğu vurgusu),
-- `CreatedByLastModifiedByExample` (`@CreatedBy`/`@LastModifiedBy` +
-- `AuditorAware<String>` implementasyonu, Spring Security'ye yalnızca
-- isim olarak değinilerek -- bu kategori onu kapsamıyor),
-- `MappedSuperclassAuditingExample` (`@MappedSuperclass` ile audit
-- alanlarını paylaşmak, bu projenin gerçek `Question`/`QuestionOption`
-- senaryosuna bağlanarak).
--
-- INTERMEDIATE zorlukta (onaylanan roadmap'teki karar -- serinin önceki üç
-- ADVANCED topic'inden sonra, kompakt/standalone doğası nedeniyle geri
-- INTERMEDIATE'e dönüş). Format: "## Ek: Mini Proje" YOK (kullanıcının
-- açık talimatı: bu kategoriye şimdilik Pratik Proje eklenmeyecek),
-- estimated_minutes topic'in kompakt kapsamıyla tutarlı olarak serinin
-- diğer INTERMEDIATE topic'leriyle aynı seviyede tutuldu.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'jpa-auditing', 'INTERMEDIATE', 25, 8
FROM category
WHERE slug = 'spring-data-jpa';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Auditing in Spring Data JPA',
       'Bu projenin gerçek QuestionIngestService''inin elle yazdığı LocalDateTime.now() deseninden başlayarak, @CreatedDate/@LastModifiedDate, @EntityListeners(AuditingEntityListener.class) + @EnableJpaAuditing bağlantısı, @CreatedBy/@LastModifiedBy, AuditorAware<T>, ve @MappedSuperclass ile audit alanlarını paylaşmak. Spring Data JPA kategorisinin 8.''si.',
       'Spring Data JPA''da Auditing',
       'Spring Data JPA''da @CreatedDate/@LastModifiedDate, @CreatedBy/@LastModifiedBy, AuditorAware, ve @MappedSuperclass ile otomatik auditing gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'jpa-auditing';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Auditing in Spring Data JPA',
       'Starting from this project''s own real QuestionIngestService''s hand-written LocalDateTime.now() pattern, this lesson covers @CreatedDate/@LastModifiedDate, wiring @EntityListeners(AuditingEntityListener.class) + @EnableJpaAuditing together, @CreatedBy/@LastModifiedBy, AuditorAware<T>, and sharing audit fields with @MappedSuperclass. The 8th lesson in the Spring Data JPA category.',
       'Auditing in Spring Data JPA',
       'Automatic auditing in Spring Data JPA -- @CreatedDate/@LastModifiedDate, @CreatedBy/@LastModifiedBy, AuditorAware, and @MappedSuperclass, explained with real examples.',
       false
FROM topic
WHERE slug = 'jpa-auditing';
