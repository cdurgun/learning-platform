-- Promotion batch
-- Topic: mapping-annotations-http-methods (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V659-V678 (Spring Core) and V631-V655
-- (Functional Interfaces & Streams), these 14 questions were NOT produced
-- by the n8n generation pipeline, NOT judged by the AI Judge, and NOT
-- ingested via /api/internal/questions/ingest -- per explicit user request,
-- they were hand-authored and independently self-reviewed directly inside a
-- Claude Code session, grounded strictly in content/en/mapping-annotations-http-methods.md and
-- content/tr/mapping-annotations-http-methods.md.
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
           $$What happens if @RequestMapping("/items") is written without specifying a method attribute?$$,
           NULL, NULL,
           $$Without a method attribute, @RequestMapping responds to every HTTP method (GET, POST, DELETE, etc.).$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mapping-annotations-http-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It responds to no HTTP method at all$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It responds only to GET, as a safety default$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It responds to every HTTP method (GET, POST, DELETE, etc.)$$, TRUE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It causes a startup error$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$@RequestMapping("/urunler") bir method attribute'u belirtilmeden yazılırsa ne olur?$$,
           NULL, NULL,
           $$method attribute'u olmadan, @RequestMapping her HTTP metoduna (GET, POST, DELETE vb.) yanıt verir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mapping-annotations-http-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Uygulama başlatılırken hata oluşur$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Hiçbir HTTP metoduna yanıt vermez$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Güvenlik varsayılanı olarak yalnızca GET'e yanıt verir$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Her HTTP metoduna (GET, POST, DELETE vb.) yanıt verir$$, TRUE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is @GetMapping("/users") in relation to @RequestMapping?$$,
           NULL, NULL,
           $$@GetMapping is a meta-annotation equivalent to @RequestMapping(path="/users", method=RequestMethod.GET).$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mapping-annotations-http-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A deprecated annotation kept only for backward compatibility$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$An annotation that can only be used at the class level$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$A completely independent annotation with its own separate mechanism$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$A meta-annotation that is equivalent to @RequestMapping(path="/users", method=RequestMethod.GET)$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$@GetMapping("/kullanicilar"), @RequestMapping ile ilişkili olarak nedir?$$,
           NULL, NULL,
           $$@GetMapping, @RequestMapping(path="/kullanicilar", method=RequestMethod.GET)'e eşdeğer bir meta-annotation'dır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mapping-annotations-http-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca geriye dönük uyumluluk için tutulan, kullanımdan kaldırılmış bir annotation$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca sınıf seviyesinde kullanılabilen bir annotation$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$@RequestMapping(path="/kullanicilar", method=RequestMethod.GET)'e eşdeğer bir meta-annotation$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Kendi ayrı mekanizmasına sahip, tamamen bağımsız bir annotation$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A GET /users/search?q=alice request is sent. Even though search is declared after {id}, which method handles it?$$,
           $$@RestController
@RequestMapping("/users")
public class UserController {
    @GetMapping("/{id}")
    public String getOne(@PathVariable Long id) { return "one:" + id; }

    @GetMapping("/search")
    public String search(@RequestParam String q) { return "search:" + q; }
}$$, $$java$$,
           $$Spring always treats a literal path segment as more specific than a variable segment, regardless of declaration order -- so /search matches search(), not getOne().$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mapping-annotations-http-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$getOne, because it was declared first$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Neither -- this causes an ambiguous mapping error at startup$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$search, because Spring always treats a literal path segment as more specific than a variable segment, regardless of declaration order$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It is nondeterministic -- either method could be called$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$GET /kitaplar/ara?q=deneme isteği gönderiliyor. ara metodu {id}'den sonra tanımlanmış olsa bile, isteği hangi metot karşılar?$$,
           $$@RestController
@RequestMapping("/kitaplar")
public class KitapController {
    @GetMapping("/{id}")
    public String tekKitap(@PathVariable Long id) { return "tek:" + id; }

    @GetMapping("/ara")
    public String ara(@RequestParam String q) { return "ara:" + q; }
}$$, $$java$$,
           $$Spring, tanımlanma sırasından bağımsız olarak literal path segmentini her zaman değişken segmentten daha spesifik kabul eder -- bu yüzden /ara, tekKitap değil ara ile eşleşir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mapping-annotations-http-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ara, çünkü Spring, tanımlanma sırasından bağımsız olarak literal path segmentini her zaman değişken segmentten daha spesifik kabul eder$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$tekKitap, çünkü önce tanımlanmıştır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Hiçbiri -- bu, başlangıçta belirsiz mapping hatasına yol açar$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Deterministik değildir -- iki metottan biri çağrılabilir$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Two methods both map POST /orders, one with consumes = "application/json" and the other with consumes = "application/xml". How does Spring decide which one handles an incoming request?$$,
           NULL, NULL,
           $$Spring inspects the request's Content-Type header and routes to the matching consumes value.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mapping-annotations-http-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It inspects the request's Content-Type header and routes to the matching consumes value$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It throws an exception because the same path is mapped twice$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It always picks the first one declared$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$It merges both into a single handler$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$İki metot da POST /siparisler'i eşliyor; biri consumes = "application/json", diğeri consumes = "application/xml". Spring, gelen bir isteği hangi metodun karşılayacağına nasıl karar verir?$$,
           NULL, NULL,
           $$Spring, isteğin Content-Type başlığını inceleyip eşleşen consumes değerine yönlendirir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mapping-annotations-http-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İkisini tek bir handler'da birleştirir$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Aynı path iki kez eşlendiği için bir istisna fırlatır$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$İsteğin Content-Type başlığını inceleyip eşleşen consumes değerine yönlendirir$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Her zaman önce tanımlanan metodu seçer$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true regarding HTTP method safety and idempotency? (Select all that apply)$$,
           NULL, NULL,
           $$GET must be safe and idempotent; POST is neither; DELETE is idempotent even though not safe. PUT is idempotent but not safe (it changes state), so the PUT-is-safe option is wrong.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mapping-annotations-http-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$GET must be both safe (no state change) and idempotent$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$POST is neither safe nor idempotent -- each call typically creates a new resource$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$PUT is safe, because it only updates existing data$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$DELETE is idempotent, even though it is not safe$$, TRUE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$HTTP metotlarının güvenlik (safe) ve idempotency özellikleriyle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$GET hem safe hem idempotent olmalı; POST ikisi de değil; DELETE safe olmasa bile idempotent'tir. PUT durum değiştirdiği için safe değildir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mapping-annotations-http-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$DELETE, safe olmasa bile idempotent'tir$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$GET, hem safe (durum değiştirmemeli) hem de idempotent olmak zorundadır$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$PUT, yalnızca mevcut veriyi güncellediği için safe'tir$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$POST ne safe'tir ne de idempotent'tir -- her çağrı genellikle yeni bir kaynak oluşturur$$, TRUE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$The current profile is {"name": "Alice", "city": "Berlin"}. A client sends PUT /profiles/1 with body {"city": "Paris"}. What is the resulting state of profile?$$,
           $$@PatchMapping("/profiles/{id}")
public void update(@PathVariable Long id, @RequestBody Map<String, Object> fields) {
    profile.putAll(fields); // only overwrites keys present in fields
}

@PutMapping("/profiles/{id}")
public void replace(@PathVariable Long id, @RequestBody Map<String, Object> fields) {
    profile.clear();
    profile.putAll(fields);
}$$, $$java$$,
           $$PUT replaces the entire resource -- replace() clears the profile first, so name is lost, leaving only {"city": "Paris"}.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mapping-annotations-http-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $${"name": "Alice", "city": "Berlin"} -- unchanged$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$A 409 Conflict is returned since name is missing$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $${"name": "Alice", "city": "Paris"}$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $${"city": "Paris"} -- name is lost because PUT replaces the entire resource$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Mevcut profil {"ad": "Ayşe", "sehir": "İzmir"}. Bir istemci PUT /profiller/1'e {"sehir": "Ankara"} gövdesiyle istek gönderiyor. profil'in sonuç durumu nedir?$$,
           $$@PatchMapping("/profiller/{id}")
public void guncelle(@PathVariable Long id, @RequestBody Map<String, Object> alanlar) {
    profil.putAll(alanlar); // yalnızca alanlar içindeki key'leri değiştirir
}

@PutMapping("/profiller/{id}")
public void degistir(@PathVariable Long id, @RequestBody Map<String, Object> alanlar) {
    profil.clear();
    profil.putAll(alanlar);
}$$, $$java$$,
           $$PUT, kaynağın tamamını değiştirir -- degistir(), önce profili temizler, bu yüzden ad kaybolur, yalnızca {"sehir": "Ankara"} kalır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mapping-annotations-http-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $${"ad": "Ayşe", "sehir": "İzmir"} -- değişmedi$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $${"sehir": "Ankara"} -- ad kayboldu, çünkü PUT kaynağın tamamını değiştirir$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$ad eksik olduğu için 409 Conflict döndürülür$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $${"ad": "Ayşe", "sehir": "Ankara"}$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$A path /books/{id} has mappings for GET and PUT only. A client sends DELETE /books/5. What does Spring return, and why?$$,
           NULL, NULL,
           $$405 Method Not Allowed -- the path exists but has no mapping for DELETE. 404 would be wrong since the path itself is found.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mapping-annotations-http-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$404 Not Found, because the path segment doesn't exist$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$405 Method Not Allowed, because the path exists but has no mapping for DELETE$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$200 OK, since DELETE silently falls back to GET$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$500 Internal Server Error, because no handler was matched$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$/kitaplar/{id} yolunda yalnızca GET ve PUT için mapping var. Bir istemci DELETE /kitaplar/5 gönderiyor. Spring ne döndürür ve neden?$$,
           NULL, NULL,
           $$405 Method Not Allowed -- path mevcut ama DELETE için bir mapping yok. Path bulunduğu için 404 yanlış olurdu.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mapping-annotations-http-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$500 Internal Server Error, çünkü hiçbir handler eşleşmedi$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$404 Not Found, çünkü path segmenti mevcut değil$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$200 OK, çünkü DELETE sessizce GET'e düşer$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$405 Method Not Allowed, çünkü path mevcut ama DELETE için bir mapping yok$$, TRUE, 3 FROM new_question_tr7;
