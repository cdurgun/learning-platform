-- Promotion batch
-- Topic: pagination-sorting-and-projections (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V715-V730 (Advanced Spring) and V679-V714
-- (Spring MVC), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/pagination-sorting-and-projections.md and
-- content/tr/pagination-sorting-and-projections.md.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different code/variable names, different question
-- framing) rather than a translation. Every question whose answer depends on
-- shown code is typed CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a
-- code_snippet attached) -- fragments/quiz.html only renders code_snippet for
-- CODE_OUTPUT questions, per the bug found and fixed in try-catch-finally/V573.
--
-- Each question's 4 options are written with the correct answer at a VARIED
-- position (not always first), applied directly during authoring via a
-- deterministic per-question rotation -- per the bug found and fixed in
-- question-promotion/V598 (Exceptions/Generics batches were 100% "always A").
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly -- same documentation convention as prior manual
-- batches. topic_id resolved by Topic.slug; question_option rows reference
-- the newly generated id via a WITH ... RETURNING id CTE.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these 14 questions at all.

-- Pair 1 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$A repository method's return type is changed from List<Topic> to Page<Topic>. What actually happens underneath?$$,
           NULL, NULL,
           $$Spring Data JPA generates a query with a real LIMIT/OFFSET, plus a second query counting the total matching rows.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'pagination-sorting-and-projections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring Data JPA generates a query with LIMIT/OFFSET, plus a separate query counting the total matching rows$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Nothing changes underneath -- Page is just a wrapper class around the exact same single query$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Spring Data JPA fetches every row and then discards the ones outside the requested page in Java$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$The method now requires a Pageable parameter to be added manually before it will compile$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir repository metodunun dönüş tipi List<Topic>'ten Page<Topic>'e değiştiriliyor. Altta gerçekte ne olur?$$,
           NULL, NULL,
           $$Spring Data JPA, gerçek bir LIMIT/OFFSET'e sahip bir sorgu artı toplam eşleşen satır sayısını sayan ayrı bir sorgu üretir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'pagination-sorting-and-projections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Metot artık derlenmeden önce elle eklenmesi gereken bir Pageable parametresi gerektirir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Spring Data JPA, gerçek bir LIMIT/OFFSET'e sahip bir sorgu artı toplam eşleşen satır sayısını sayan ayrı bir sorgu üretir$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Altta hiçbir şey değişmez -- Page yalnızca tam olarak aynı tek sorgu etrafında bir sarmalayıcı sınıftır$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Spring Data JPA her satırı getirir ve sonra istenen sayfa dışındakileri Java'da atar$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Where does a repository's findAll(Sort sort) method actually come from?$$,
           NULL, NULL,
           $$It's inherited directly from PagingAndSortingRepository -- no new method needs to be written in the interface at all.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'pagination-sorting-and-projections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It comes from JpaSpecificationExecutor, not the base repository hierarchy$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It's inherited directly from PagingAndSortingRepository, needing no declaration in the interface$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It must be declared explicitly in every repository interface that needs sorting$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It's generated fresh, from scratch, for each repository based on its entity's fields$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir repository'nin findAll(Sort sort) metodu gerçekte nereden gelir?$$,
           NULL, NULL,
           $$Doğrudan PagingAndSortingRepository'den miras alınır -- interface'te hiç deklare edilmesine gerek yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'pagination-sorting-and-projections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her repository için, entity'sinin alanlarına göre sıfırdan, yeniden üretilir$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Temel repository hiyerarşisinden değil, JpaSpecificationExecutor'dan gelir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Doğrudan PagingAndSortingRepository'den miras alınır, interface'te deklarasyon gerektirmez$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Sıralamaya ihtiyaç duyan her repository interface'inde açıkça deklare edilmelidir$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this Pageable construction, does the repository method it's passed to need a separate Sort parameter as well?$$,
           $$Pageable pageable = PageRequest.of(1, 5, Sort.by("slug"));
Page<Topic> result = repository.findByDifficulty("ADVANCED", pageable);$$, $$java$$,
           $$No -- a Pageable already carries its own embedded Sort; PageRequest.of(page, size, sort) already bundles ordering into it.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'pagination-sorting-and-projections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It depends on whether the method is a derived query or written with @Query$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Yes, but only when the entity has more than one sortable field$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Yes -- Pageable and Sort are always two separate arguments that must both be supplied$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$No -- a Pageable already carries its own embedded Sort, so a separate Sort parameter isn't needed$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu Pageable oluşturmasına göre, kendisine geçirildiği repository metodunun ayrıca bir Sort parametresine de ihtiyacı var mı?$$,
           $$Pageable pageable = PageRequest.of(1, 5, Sort.by("slug"));
Page<Topic> result = repository.findByDifficulty("ADVANCED", pageable);$$, $$java$$,
           $$Hayır -- bir Pageable zaten kendi gömülü Sort'unu taşır; PageRequest.of(page, size, sort) sıralamayı zaten içine paketler.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'pagination-sorting-and-projections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet -- Pageable ve Sort her zaman ikisi de sağlanması gereken iki ayrı argümandır$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Metodun türetilmiş bir sorgu mu yoksa @Query ile mi yazıldığına bağlıdır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Evet, ama yalnızca entity'nin birden fazla sıralanabilir alanı varsa$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Hayır -- bir Pageable zaten kendi gömülü Sort'unu taşır, bu yüzden ayrı bir Sort parametresine gerek yoktur$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does declaring an interface projection like TopicSummary (with getSlug()/getDifficulty()) actually change about the generated SQL?$$,
           NULL, NULL,
           $$Spring Data JPA generates a SQL SELECT naming only those specific columns, not every column the full entity would require.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'pagination-sorting-and-projections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It generates a SQL SELECT naming only the columns the interface's getters correspond to$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It forces the query to run as a native query instead of JPQL$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It disables lazy loading entirely for every field of the underlying entity$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Nothing at the SQL level -- it only reduces how much Java code needs to be written$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$TopicSummary gibi (getSlug()/getDifficulty() ile) bir interface projeksiyonu deklare etmek, üretilen SQL hakkında gerçekte neyi değiştirir?$$,
           NULL, NULL,
           $$Spring Data JPA, yalnızca o özel kolonları adlandıran bir SQL SELECT üretir, tam entity'nin gerektireceği her kolonu değil.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'pagination-sorting-and-projections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca interface'in getter'larının karşılık geldiği kolonları adlandıran bir SQL SELECT üretir$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$SQL seviyesinde hiçbir şeyi değiştirmez -- yalnızca ne kadar Java kodu yazılması gerektiğini azaltır$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Sorgunun JPQL yerine bir native query olarak çalışmasını zorlar$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Altta yatan entity'nin her alanı için lazy loading'i tamamen devre dışı bırakır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does this projection need a constructor-expression (select new ...) rather than a simple interface projection?$$,
           $$record TopicTitleView(String slug, String title) {}

@Query("select new com.example.TopicTitleView(tt.topic.slug, tt.title) " +
       "from TopicTranslation tt where tt.language = :language")
List<TopicTitleView> findAllTitles(String language);$$, $$java$$,
           $$The fields span a relationship (tt.topic.slug comes from a different entity than tt.title) -- an interface projection only works for a straightforward subset of ONE entity's own getters.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'pagination-sorting-and-projections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because interface projections are entirely deprecated in modern Spring Data JPA$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Because the fields span a relationship -- slug comes from Topic, title from TopicTranslation -- which a plain interface projection can't express$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Because records can never be used as any kind of projection$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Because the query returns more than one row$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu projeksiyon neden sade bir interface projeksiyonu yerine bir constructor-expression'a (select new ...) ihtiyaç duyar?$$,
           $$record KonuBaslikView(String slug, String baslik) {}

@Query("select new com.example.KonuBaslikView(kc.konu.slug, kc.baslik) " +
       "from KonuCevirisi kc where kc.dil = :dil")
List<KonuBaslikView> tumBasliklariGetir(String dil);$$, $$java$$,
           $$Alanlar bir ilişkiye yayılıyor -- slug Konu'dan, baslik KonuCevirisi'nden geliyor -- bunu sade bir interface projeksiyonu ifade edemez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'pagination-sorting-and-projections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü sorgu birden fazla satır döndürür$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü alanlar bir ilişkiye yayılıyor -- slug Konu'dan, baslik KonuCevirisi'nden geliyor -- bunu sade bir interface projeksiyonu ifade edemez$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü interface projeksiyonları modern Spring Data JPA'da tamamen kullanımdan kaldırılmıştır$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü record'lar hiçbir tür projeksiyon olarak asla kullanılamaz$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the real benefit of a projection? (Select all that apply)$$,
           NULL, NULL,
           $$A projection narrows the generated SQL SELECT itself, fetching fewer columns -- not merely producing a smaller Java type.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'pagination-sorting-and-projections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It always requires switching the query to nativeQuery = true$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It narrows the SQL SELECT itself, fetching fewer columns from the database$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It avoids the overhead of managing a full entity for data that will only ever be read$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Its only real benefit is writing less Java code, with no effect on the generated SQL$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri bir projeksiyonun gerçek faydasını doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir projeksiyon, üretilen SQL SELECT'in kendisini daraltır, veritabanından daha az kolon getirir -- yalnızca daha küçük bir Java tipi üretmekten ibaret değildir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'pagination-sorting-and-projections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca okunacak veri için tam bir entity'yi yönetmenin ek yükünden kaçınır$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Tek gerçek faydası daha az Java kodu yazmaktır, üretilen SQL üzerinde hiçbir etkisi yoktur$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Sorguyu her zaman nativeQuery = true'ya geçirmeyi gerektirir$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Veritabanından daha az kolon getirerek SQL SELECT'in kendisini daraltır$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$A single method findByDifficulty(String difficulty, Pageable pageable) is called with a Pageable built via PageRequest.of(page, size, sort). How many distinct concerns does this ONE method call handle at once?$$,
           NULL, NULL,
           $$Three: filtering (difficulty), paging, and ordering -- all bundled into a single, unremarkable method signature.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'pagination-sorting-and-projections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Three -- filtering, paging, and ordering, all handled by this single method call$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Four -- filtering, paging, ordering, and projection, all in one call$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$One -- only filtering, since Pageable is unrelated to sorting$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Two -- filtering and paging only, sorting requires a separate call$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$PageRequest.of(page, size, sort) ile oluşturulan bir Pageable ile tek bir findByDifficulty(String difficulty, Pageable pageable) metodu çağrılıyor. Bu TEK metot çağrısı aynı anda kaç ayrı kaygıyı ele alıyor?$$,
           NULL, NULL,
           $$Üç: filtreleme (difficulty), sayfalama ve sıralama -- hepsi tek, sıradan bir metot imzasında paketlenmiş.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'pagination-sorting-and-projections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir -- yalnızca filtreleme, çünkü Pageable sıralamayla ilgisizdir$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$İki -- yalnızca filtreleme ve sayfalama, sıralama ayrı bir çağrı gerektirir$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Dört -- filtreleme, sayfalama, sıralama ve projeksiyon, hepsi tek çağrıda$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Üç -- filtreleme, sayfalama ve sıralama, hepsi bu tek metot çağrısı tarafından ele alınır$$, TRUE, 3 FROM new_question_tr7;
