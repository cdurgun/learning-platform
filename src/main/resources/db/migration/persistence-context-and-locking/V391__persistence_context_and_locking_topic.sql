-- `spring-data-jpa` kategorisine, onaylanan 9 topic'lik roadmap'in 7.'si
-- ekleniyor: "persistence-context-and-locking" -- relationships-fetching-
-- and-n-plus-1'in (sort_order=6) hemen ardına, sort_order=7. Kategori şu
-- an altı topic içeriyor, sort_order kaydırması gerekmiyor.
--
-- Kapsam (roadmap'in onaylanan tablosu -- kullanıcının roadmap onayı
-- sırasında "Transactions & persistence context" + "Locking/concurrency"
-- bültenlerini TEK bir topic'te birleştirme kararı): entity yaşam döngüsü
-- durumları (transient/managed/detached/removed), first-level cache,
-- flush zamanlaması, `persist`/`merge`/`detach`; optimistic locking
-- (`@Version`, `OptimisticLockingFailureException`) iki transaction'ın
-- aynı managed entity'ye dokunmasının doğal bir uzantısı olarak; ve
-- pessimistic locking (`@Lock`) kısaca.
--
-- "Transaction Management"in (Faz 82) `@Transactional`'ın TAMAMINI
-- (propagation/isolation/rollback/proxy/self-invocation) VE dirty
-- checking'i (SimpleJpaRepository'nin zaten @Transactional olduğu, bir
-- alan değişikliğinin save() çağrılmadan commit'te yazıldığı)
-- ZATEN kapsamlıca işlediği grep ile önceden doğrulandı -- bu topic
-- HİÇBİRİNİ TEKRAR ÖĞRETMEDİ, yalnızca dirty checking'in NEDEN
-- çalıştığını (persistence context'in kendisi) açıkladı, gerçek migration
-- başlığıyla doğrulanmış referanslarla. Bu, kullanıcının roadmap'teki
-- "cross-refs transaction-management for @Transactional itself... this
-- lesson only covers the JPA-specific entity-state/locking layer on top"
-- talimatına birebir uyuyor.
--
-- Bu projenin gerçek kodu `EntityManager`'a hiç doğrudan dokunmuyor
-- (yalnızca repository'ler üzerinden, grep ile önceden doğrulandı) -- bu
-- yüzden bu topic'in örnekleri, `repository.save(...)`'ın kendisinin
-- üzerine inşa edildiği `persist`/`merge`/`detach`/`flush` işlemlerini
-- DOĞRUDAN öğretiyor, bu projenin gerçek Topic entity'sine dayanan
-- basitleştirilmiş versiyonlarla.
--
-- 6 örnek: `EntityLifecycleExample` (dört durum), `FirstLevelCacheExample`
-- (identity map, `==` ile gösterilen), `PersistMergeDetachExample`
-- (detached bir entity için `merge` neden doğru işlem), `FlushTimingExample`
-- (auto-flush-before-query davranışı), `OptimisticLockingExample`
-- (`@Version` + çarpışma senaryosu), `PessimisticLockingExample`
-- (`@Lock(PESSIMISTIC_WRITE)`, optimistic'le kısa karşılaştırmalı).
--
-- ADVANCED zorlukta, serinin önceki iki ADVANCED topic'iyle (Faz 119/120)
-- aynı seviye. Format: "## Ek: Mini Proje" YOK (kullanıcının açık
-- talimatı: bu kategoriye şimdilik Pratik Proje eklenmeyecek),
-- estimated_minutes önceki iki ADVANCED topic'le aynı yükseklikte
-- tutuldu.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'persistence-context-and-locking', 'ADVANCED', 35, 7
FROM category
WHERE slug = 'spring-data-jpa';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'The Persistence Context and Locking',
       '"Transaction Management"in zaten kapsamlıca işlediği dirty checking''in NEDEN çalıştığı -- persistence context''in kendisi, entity yaşam döngüsü durumları (transient/managed/detached/removed), first-level cache, persist/merge/detach, flush zamanlaması -- ve iki transaction aynı satıra dokunduğunda ne olduğu: @Version ile optimistic locking, @Lock ile pessimistic locking. Spring Data JPA kategorisinin 7.''si.',
       'Spring Data JPA''da Persistence Context ve Locking',
       'Spring Data JPA''da persistence context, entity yaşam döngüsü, first-level cache, ve optimistic/pessimistic locking gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'persistence-context-and-locking';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'The Persistence Context and Locking',
       'Why dirty checking, already covered in full in "Transaction Management," actually works -- the persistence context itself, entity lifecycle states (transient/managed/detached/removed), the first-level cache, persist/merge/detach, flush timing -- and what happens when two transactions touch the same row: optimistic locking with @Version, pessimistic locking with @Lock. The 7th lesson in the Spring Data JPA category.',
       'The Persistence Context and Locking in Spring Data JPA',
       'The persistence context, entity lifecycle, first-level cache, and optimistic/pessimistic locking in Spring Data JPA, explained with real examples.',
       false
FROM topic
WHERE slug = 'persistence-context-and-locking';
