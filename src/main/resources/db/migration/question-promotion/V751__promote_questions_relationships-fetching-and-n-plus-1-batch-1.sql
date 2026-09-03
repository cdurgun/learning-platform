-- Promotion batch
-- Topic: relationships-fetching-and-n-plus-1 (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V715-V730 (Advanced Spring) and V679-V714
-- (Spring MVC), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/relationships-fetching-and-n-plus-1.md and
-- content/tr/relationships-fetching-and-n-plus-1.md.
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
           $$Does @OneToMany(mappedBy = "category") add its own foreign-key column to the database?$$,
           NULL, NULL,
           $$No -- it's the mirror image of an existing @ManyToOne; the foreign key still lives only on the owning (@ManyToOne) side's table.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- it's the mirror image of an existing @ManyToOne, adding no column of its own$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Yes -- it adds a foreign-key column on the "one" side's own table$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Yes -- it creates an entirely separate join table automatically$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It depends on whether cascade is also specified$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$@OneToMany(mappedBy = "category"), veritabanına kendi foreign-key kolonunu ekler mi?$$,
           NULL, NULL,
           $$Hayır -- var olan bir @ManyToOne'un ayna görüntüsüdür; foreign key hâlâ yalnızca sahip (@ManyToOne) tarafının tablosunda yaşar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$cascade'in de belirtilip belirtilmediğine bağlıdır$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Hayır -- var olan bir @ManyToOne'un ayna görüntüsüdür, kendi kolonunu eklemez$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Evet -- "bir" tarafının kendi tablosuna bir foreign-key kolonu ekler$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Evet -- otomatik olarak tamamen ayrı bir join table oluşturur$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$When should an explicit join entity (like this project's real QuizQuestion) be preferred over a plain @ManyToMany with @JoinTable?$$,
           NULL, NULL,
           $$A plain @ManyToMany join table has no room for data ABOUT the relationship itself -- an explicit join entity is needed the moment the relationship needs to carry more than just the link.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only when performance profiling shows @ManyToMany is measurably slower$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$The moment the relationship itself needs to carry its own data, like a position column$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Never -- @ManyToMany with @JoinTable is always the superior choice in every scenario$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Only when the two related entities have the exact same number of fields$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Açık bir join entity'si (bu projenin gerçek QuizQuestion'ı gibi), @JoinTable ile sade bir @ManyToMany'ye ne zaman tercih edilmelidir?$$,
           NULL, NULL,
           $$Sade bir @ManyToMany join table'ında ilişkinin KENDİSİ hakkında veriye yer yoktur -- ilişkinin yalnızca bağlantıdan fazlasını taşıması gerektiği anda açık bir join entity'si gerekir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca iki ilişkili entity tam olarak aynı sayıda alana sahip olduğunda$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca performans profillemesi @ManyToMany'nin ölçülebilir şekilde daha yavaş olduğunu gösterdiğinde$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$İlişkinin kendisinin, bir position kolonu gibi, kendi verisini taşıması gerektiği anda$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Asla -- @JoinTable ile @ManyToMany her senaryoda her zaman üstün seçimdir$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly distinguish cascade from orphanRemoval? (Select all that apply)$$,
           NULL, NULL,
           $$cascade propagates an explicit save/delete on the parent to its children; orphanRemoval deletes a child specifically because it was removed from its parent's collection, with no explicit delete on the child at all.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$cascade and orphanRemoval are simply two different names for the exact same mechanism$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$orphanRemoval requires CascadeType.REMOVE to also be set before it has any effect at all$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$cascade propagates an explicit save/delete operation performed on the parent to its children$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$orphanRemoval deletes a child specifically because it was removed from its parent's collection, with no explicit delete on the child$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri cascade ile orphanRemoval'ı doğru şekilde ayırt eder? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$cascade, parent üzerinde gerçekleştirilen açık bir save/delete işlemini çocuklarına yayar; orphanRemoval, bir çocuğu, çocuk üzerinde hiçbir açık delete olmadan, yalnızca parent'ın koleksiyonundan çıkarıldığı için siler.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$cascade, parent üzerinde gerçekleştirilen açık bir save/delete işlemini çocuklarına yayar$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$cascade ve orphanRemoval, tamamen aynı mekanizmanın yalnızca iki farklı adıdır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$orphanRemoval, herhangi bir etkisi olmadan önce CascadeType.REMOVE'un da ayarlanmasını gerektirir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$orphanRemoval, bir çocuğu, çocuk üzerinde hiçbir açık delete olmadan, yalnızca parent'ın koleksiyonundan çıkarıldığı için siler$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$How many total queries does this code run against a database with 7 Category rows?$$,
           $$for (Category c : categoryRepository.findAll()) {
    System.out.println(c.getName() + ": " + c.getTopics().size());
    // getTopics() is a lazy @OneToMany
}$$, $$java$$,
           $$1 query to fetch the categories, plus 1 more query per category when the lazy getTopics() is accessed inside the loop -- 1+7=8 total.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$7 -- one query per category, with no separate query for the categories themselves$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$8 -- 1 query for the categories, plus 1 more per category when getTopics() is accessed in the loop$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$14 -- 2 queries per category, one for the name and one for the topics$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$1 -- a single query fetches everything needed, including every category's topics$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$7 satırlık Kategori tablosuna karşı bu kod toplam kaç sorgu çalıştırır?$$,
           $$for (Kategori k : kategoriRepository.findAll()) {
    System.out.println(k.getAd() + ": " + k.getKonular().size());
    // getKonular() lazy bir @OneToMany
}$$, $$java$$,
           $$Kategorileri getirmek için 1 sorgu, artı döngü içinde lazy getKonular() erişildiğinde kategori başına 1 sorgu daha -- toplam 1+7=8.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$8 -- kategoriler için 1 sorgu, artı döngüde getKonular() erişildiğinde kategori başına 1 sorgu daha$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$1 -- tek bir sorgu, her kategorinin konuları dahil ihtiyaç duyulan her şeyi getirir$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$7 -- kategorilerin kendisi için ayrı bir sorgu olmadan, kategori başına bir sorgu$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$14 -- kategori başına 2 sorgu, biri ad için biri konular için$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$How does adding @EntityGraph(attributePaths = "topics") to findAll() change the query count for the same 7-category loop from before?$$,
           $$@EntityGraph(attributePaths = "topics")
List<Category> findAll();$$, $$java$$,
           $$findAll() now runs ONE query, with topics already joined in -- down from the 1+7=8 queries of the unfixed N+1 example.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It has no effect on query count -- @EntityGraph only changes which fields get selected, not how many queries run$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It runs exactly ONE query, with topics already joined in, instead of 1+7=8$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It runs 7 queries -- one batched query per category, grouped by @EntityGraph$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It requires switching findAll() to a native query before it has any effect$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$findAll()'a @EntityGraph(attributePaths = "konular") eklemek, öncekiyle aynı 7 kategorilik döngü için sorgu sayısını nasıl değiştirir?$$,
           $$@EntityGraph(attributePaths = "konular")
List<Kategori> findAll();$$, $$java$$,
           $$findAll() artık, konular zaten join edilmiş halde, TEK bir sorgu çalıştırır -- düzeltilmemiş N+1 örneğinin 1+7=8 sorgusundan aşağı.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Herhangi bir etkisi olmadan önce findAll()'un bir native query'e geçirilmesini gerektirir$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Konular zaten join edilmiş halde, 1+7=8 yerine tam olarak TEK bir sorgu çalıştırır$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Sorgu sayısı üzerinde hiçbir etkisi yoktur -- @EntityGraph yalnızca hangi alanların seçildiğini değiştirir, kaç sorgu çalıştığını değil$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Kategori başına bir toplu sorgu olmak üzere 7 sorgu çalıştırır, @EntityGraph tarafından gruplanmış$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$With 7 categories and @BatchSize(size = 20) on the lazy topics collection, how many total queries does the previous loop run?$$,
           NULL, NULL,
           $$1+1=2: one query for the categories, one batched query covering every category's topics together (via a single WHERE category_id IN (...)), since 7 fits within the batch size of 20.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$1 -- @BatchSize eliminates every extra query entirely, identical to @EntityGraph$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$1+7=8 -- @BatchSize has no actual effect on the query count$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$1+1=2 -- one query for the categories, one batched query covering all 7 categories' topics together$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$1+20=21 -- one query per configured batch size slot, regardless of actual category count$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$7 kategori ve lazy konular koleksiyonunda @BatchSize(size = 20) ile, önceki döngü toplam kaç sorgu çalıştırır?$$,
           NULL, NULL,
           $$1+1=2: kategoriler için bir sorgu, tüm 7 kategorinin konularını birlikte kapsayan bir toplu sorgu (tek bir WHERE category_id IN (...) ile), çünkü 7, 20'lik batch boyutuna sığar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$1+20=21 -- gerçek kategori sayısından bağımsız olarak, yapılandırılmış her batch boyutu yuvası için bir sorgu$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$1 -- @BatchSize, @EntityGraph ile aynı şekilde her ekstra sorguyu tamamen ortadan kaldırır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$1+1=2 -- kategoriler için bir sorgu, tüm 7 kategorinin konularını birlikte kapsayan bir toplu sorgu$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$1+7=8 -- @BatchSize'ın sorgu sayısı üzerinde gerçek bir etkisi yoktur$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly match an N+1 fix to the situation it best suits? (Select all that apply)$$,
           NULL, NULL,
           $$@EntityGraph suits a single, specific query that always needs the relationship. Batch fetching suits a relationship touched by many different queries. A projection is the cheapest fix, suited to a query that never needed the relationship's data at all.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Batch fetching is the right choice specifically when only one query ever touches the relationship$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$cascade is one of the four fixes for N+1, alongside @EntityGraph, batch fetching, and projections$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$@EntityGraph suits a single, specific query that always needs the relationship$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$A projection is the cheapest fix, suited to a query that never needed the relationship's data to begin with$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri bir N+1 düzeltmesini en uygun olduğu duruma doğru şekilde eşleştirir? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$@EntityGraph, ilişkiye her zaman ihtiyaç duyan tek, spesifik bir sorguya uyar. Batch fetching, birçok farklı sorgunun dokunduğu bir ilişkiye uyar. Bir projeksiyon, ilişkinin verisine hiç ihtiyaç duyulmayan bir sorguya uyan, en ucuz düzeltmedir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@EntityGraph, ilişkiye her zaman ihtiyaç duyan tek, spesifik bir sorguya uyar$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir projeksiyon, ilişkinin verisine hiç ihtiyaç duyulmayan bir sorguya uyan, en ucuz düzeltmedir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Batch fetching, ilişkiye yalnızca tek bir sorgunun dokunduğu durumlarda doğru seçimdir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$cascade, @EntityGraph, batch fetching ve projeksiyonların yanında N+1 için dört düzeltmeden biridir$$, FALSE, 3 FROM new_question_tr7;
