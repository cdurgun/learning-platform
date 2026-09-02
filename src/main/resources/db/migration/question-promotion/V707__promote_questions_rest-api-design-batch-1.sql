-- Promotion batch
-- Topic: rest-api-design (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V659-V678 (Spring Core) and V631-V655
-- (Functional Interfaces & Streams), these 14 questions were NOT produced
-- by the n8n generation pipeline, NOT judged by the AI Judge, and NOT
-- ingested via /api/internal/questions/ingest -- per explicit user request,
-- they were hand-authored and independently self-reviewed directly inside a
-- Claude Code session, grounded strictly in content/en/rest-api-design.md and
-- content/tr/rest-api-design.md.
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

-- Pair 1 / EN (MULTIPLE_CHOICE, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What are the risks of returning a JPA entity directly from a @RestController? (Select all that apply)$$,
           NULL, NULL,
           $$An entity can expose fields no client should see (like a password hash), and a lazily-loaded field can throw LazyInitializationException during serialization.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'rest-api-design'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It can expose internal fields no client should see, like a password hash$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A lazily-loaded field can throw a LazyInitializationException if touched during serialization$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It is always significantly slower than using a DTO$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Jackson is fundamentally unable to serialize any JPA entity$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (MULTIPLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir JPA entity'sini doğrudan bir @RestController'dan döndürmenin riskleri nelerdir? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir entity, şifre hash'i gibi hiçbir istemcinin görmemesi gereken alanları açığa çıkarabilir, ve lazy-loaded bir alan serileştirme sırasında bir LazyInitializationException fırlatabilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'rest-api-design'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Serileştirme sırasında dokunulursa, lazy-loaded bir alan bir LazyInitializationException fırlatabilir$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Hiçbir istemcinin görmemesi gereken, şifre hash'i gibi dahili alanları açığa çıkarabilir$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$DTO kullanmaktan her zaman önemli ölçüde daha yavaştır$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Jackson, temelde herhangi bir JPA entity'sini serileştiremez$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$When a @RestController method's parameter is typed Pageable, how does Spring populate it?$$,
           NULL, NULL,
           $$It is automatically resolved from ?page=/?size=/?sort= query parameters, no manual parsing needed.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'rest-api-design'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It always defaults to page 0, size 20, with no way to override it$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It requires a custom HandlerMethodArgumentResolver to be written by the developer$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It must be manually built inside the method body$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It is automatically resolved from ?page=/?size=/?sort= query parameters$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir @RestController metodunun parametresi Pageable tipindeyse, Spring bunu nasıl doldurur?$$,
           NULL, NULL,
           $$?page=/?size=/?sort= query parametrelerinden otomatik olarak çözülür, elle ayrıştırmaya gerek kalmaz.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'rest-api-design'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her zaman sayfa 0, boyut 20'ye varsayılan olarak döner, üzerine yazma imkânı yoktur$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Geliştiricinin özel bir HandlerMethodArgumentResolver yazmasını gerektirir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$?page=/?size=/?sort= query parametrelerinden otomatik olarak çözülür$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Metot gövdesinin içinde elle oluşturulmalıdır$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which client-sent query string is the equivalent request-side representation of this Sort object?$$,
           $$Sort sort = Sort.by(Sort.Direction.ASC, "difficulty")
                 .and(Sort.by(Sort.Direction.DESC, "title"));$$, $$java$$,
           $$?sort=difficulty,asc&sort=title,desc is the server-side equivalent request that Spring resolves into exactly this kind of Sort object.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'rest-api-design'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$?sort=difficulty&sort=title$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$?sort=difficulty,asc&sort=title,desc$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$?sortAsc=difficulty&sortDesc=title$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$?orderBy=difficulty+title$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu Sort nesnesinin istek tarafındaki eşdeğer temsili hangi istemci-taraflı query string'dir?$$,
           $$Sort sort = Sort.by(Sort.Direction.ASC, "zorluk")
                 .and(Sort.by(Sort.Direction.DESC, "baslik"));$$, $$java$$,
           $$?sort=zorluk,asc&sort=baslik,desc, Spring'in tam olarak bu tür bir Sort nesnesine çözdüğü istek tarafı eşdeğerdir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'rest-api-design'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$?sort=zorluk,asc&sort=baslik,desc$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$?sort=zorluk&sort=baslik$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$?sortAsc=zorluk&sortDesc=baslik$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$?orderBy=zorluk+baslik$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$A request GET /topics is sent without a category parameter. What happens?$$,
           $$@GetMapping("/topics")
public List<Topic> list(@RequestParam(required = false) String category) {
    return allTopics.stream()
        .filter(t -> category.equals(t.getCategory()))
        .toList();
}$$, $$java$$,
           $$A NullPointerException is thrown, because category is null and .equals(...) is called on it directly -- every optional filter needs to explicitly express "no effect when not supplied".$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'rest-api-design'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A NullPointerException is thrown, because category is null and .equals(...) is called on it directly$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It returns 400 Bad Request, since category is technically required$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It returns all topics, since the filter has no effect when category is absent$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$It returns an empty list$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$kategori parametresi olmadan GET /konular isteği gönderiliyor. Ne olur?$$,
           $$@GetMapping("/konular")
public List<Konu> listele(@RequestParam(required = false) String kategori) {
    return tumKonular.stream()
        .filter(k -> kategori.equals(k.getKategori()))
        .toList();
}$$, $$java$$,
           $$Bir NullPointerException fırlatılır, çünkü kategori null'dır ve .equals(...) doğrudan onun üzerinde çağrılıyor -- her opsiyonel filtre "sağlanmadığında etkisi yok" durumunu açıkça ifade etmelidir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'rest-api-design'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Boş bir liste döndürür$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$kategori teknik olarak zorunlu olduğu için 400 Bad Request döner$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Bir NullPointerException fırlatılır, çünkü kategori null'dır ve .equals(...) doğrudan onun üzerinde çağrılıyor$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$kategori yokken filtrenin hiçbir etkisi olmadığı için tüm konuları döndürür$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does Spring Data itself advise against returning Page<T> directly from a controller method?$$,
           NULL, NULL,
           $$PageImpl's internal fields aren't a documented, stable contract, and its default JSON shape has changed across Spring Data versions.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'rest-api-design'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Page<T> cannot be serialized to JSON at all$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$PageImpl's internal fields aren't a documented, stable contract, and its default JSON shape has changed across Spring Data versions$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It is a security risk, always exposing internal database IDs$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It forces the response to use XML instead of JSON$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Spring Data'nın kendisi, bir controller metodundan doğrudan Page<T> döndürmeyi neden tavsiye etmiyor?$$,
           NULL, NULL,
           $$PageImpl'in dahili alanları belgelenmiş, stabil bir sözleşme değildir ve varsayılan JSON şekli Spring Data sürümleri arasında değişmiştir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'rest-api-design'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PageImpl'in dahili alanları belgelenmiş, stabil bir sözleşme değildir ve varsayılan JSON şekli Spring Data sürümleri arasında değişmiştir$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Page<T> hiçbir şekilde JSON'a serileştirilemez$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Her zaman dahili veritabanı ID'lerini açığa çıkararak bir güvenlik riski oluşturur$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Response'un JSON yerine XML kullanmasını zorunlu kılar$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about API versioning strategies covered in this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$URI versioning is impossible to miss but leaks into every client URL permanently; header versioning keeps the URL fixed but makes the version invisible without documentation.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'rest-api-design'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Mixing both strategies in the same API is the recommended best practice$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$There is a single, universally settled answer to which strategy is objectively best$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$URI versioning (/api/v1/...) is impossible to miss but leaks into every client URL permanently$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Header versioning (Api-Version: 2) keeps the URL fixed, but makes the version invisible without documentation$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste ele alınan API versiyonlama stratejileriyle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$URI versiyonlama fark edilmemesi imkânsızdır ama kalıcı olarak her istemci URL'sine sızar; header versiyonlama URL'yi sabit tutar ama versiyonu dokümantasyon olmadan görünmez kılar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'rest-api-design'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İki stratejiyi aynı API'de karıştırmak önerilen en iyi uygulamadır$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Header versiyonlama (Api-Version: 2) URL'yi sabit tutar, ama versiyonu dokümantasyon olmadan görünmez hale getirir$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Hangi stratejinin objektif olarak en iyi olduğuna dair evrensel olarak kabul edilmiş tek bir cevap vardır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$URI versiyonlama (/api/v1/...) fark edilmemesi imkânsızdır ama kalıcı olarak her istemci URL'sine sızar$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$A client's POST /orders request times out, so it retries with the exact same Idempotency-Key header. If the server already processed the original request, what does it do on the retry?$$,
           NULL, NULL,
           $$It returns the original result again, without creating a new resource -- the second call has exactly the same effect as the first.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'rest-api-design'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It creates a second, duplicate order$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$It rejects the retry with 409 Conflict$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$It returns the original result again, without creating a new resource$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$It ignores the Idempotency-Key header entirely on POST requests$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bir istemcinin POST /orders isteği zaman aşımına uğruyor, bu yüzden aynı Idempotency-Key header'ıyla tekrar deniyor. Sunucu orijinal isteği zaten işlediyse, tekrar denemede ne yapar?$$,
           NULL, NULL,
           $$Yeni bir kaynak oluşturmadan orijinal sonucu tekrar döndürür -- ikinci çağrının etkisi birincisiyle tamamen aynıdır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'rest-api-design'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yeni bir kaynak oluşturmadan orijinal sonucu tekrar döndürür$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$İkinci, yinelenen bir sipariş oluşturur$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Tekrar denemeyi 409 Conflict ile reddeder$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$POST isteklerinde Idempotency-Key header'ını tamamen yok sayar$$, FALSE, 3 FROM new_question_tr7;
