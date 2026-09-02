-- Promotion batch
-- Topic: transaction-management (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V631-V655 (functional interfaces & streams) and
-- V615-V627 (OOP), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/transaction-management.md and
-- content/tr/transaction-management.md.
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
           $$Which ACID property guarantees that a transaction's effects, once committed, survive even if the server crashes immediately afterward?$$,
           NULL, NULL,
           $$Durability: a committed transaction is permanent, even if the server crashes right afterward.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transaction-management'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Durability$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Atomicity$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Consistency$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Isolation$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Hangi ACID özelliği, bir transaction'ın etkilerinin, commit edildikten hemen sonra sunucu çökse bile kalıcı kalmasını garanti eder?$$,
           NULL, NULL,
           $$Durability (Dayanıklılık): commit edilmiş bir transaction, sunucu hemen ardından çökse bile kalıcıdır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transaction-management'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Isolation (Yalıtım)$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Durability (Dayanıklılık)$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Atomicity (Bölünmezlik)$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Consistency (Tutarlılık)$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this method is called and runs to completion?$$,
           $$class LedgerService {
    @Transactional
    void writeThenThrowChecked() throws IOException {
        ledger.add("entry-1");
        throw new IOException("simulated failure");
    }
}$$, $$java$$,
           $$Spring's default rollback rule treats unchecked exceptions as rollback triggers; checked exceptions (like IOException) do NOT trigger a rollback by default -- the transaction commits despite the exception.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transaction-management'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The application fails to start, since @Transactional methods can't declare checked exceptions.$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$The transaction stays open indefinitely, waiting for a manual commit.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$The transaction commits -- "entry-1" becomes permanent, even though IOException was thrown.$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$The transaction rolls back -- "entry-1" is never written, because any exception triggers a rollback by default.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu metot çağrıldığında ve sonuna kadar çalıştığında ne olur?$$,
           $$class DefterServisi {
    @Transactional
    void yazSonraCheckedFirlat() throws IOException {
        defter.ekle("kayit-1");
        throw new IOException("simule edilmis hata");
    }
}$$, $$java$$,
           $$Spring'in varsayılan rollback kuralı, unchecked exception'ları rollback tetikleyicisi sayar; checked exception'lar (IOException gibi) varsayılan olarak rollback TETİKLEMEZ -- transaction, istisnaya rağmen commit edilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transaction-management'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Transaction rollback edilir -- "kayit-1" hiç yazılmaz, çünkü varsayılan olarak her istisna rollback tetikler.$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Uygulama başlayamaz, çünkü @Transactional metotlar checked exception bildiremez.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Transaction, manuel bir commit bekleyerek süresiz açık kalır.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Transaction commit edilir -- IOException fırlatılmış olsa bile "kayit-1" defterde kalıcı hale gelir.$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does `@Transactional` silently have no effect when a method is called via `this` from inside the same class (self-invocation)?$$,
           NULL, NULL,
           $$A proxy can only intercept calls that come through the bean from outside; a call via this goes directly to the real object, bypassing the proxy entirely.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transaction-management'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A proxy can only intercept calls that come through the bean from outside; a call via this goes directly to the real object, bypassing the proxy entirely.$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Self-invocation always throws a compile error in Spring.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$@Transactional is disabled automatically whenever two methods are in the same class.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The proxy intercepts the call correctly, but silently ignores @Transactional specifically for self-calls.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aynı sınıf içinden `this` üzerinden çağrılan bir metotta (self-invocation) `@Transactional` neden sessizce hiçbir etki göstermez?$$,
           NULL, NULL,
           $$Bir proxy yalnızca dışarıdan bean üzerinden gelen çağrıları yakalayabilir; this üzerinden bir çağrı doğrudan gerçek nesneye gider, proxy'yi tamamen atlar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transaction-management'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Proxy çağrıyı doğru şekilde yakalar, ama özellikle self-call'lar için @Transactional'ı sessizce yok sayar.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir proxy yalnızca dışarıdan bean üzerinden gelen çağrıları yakalayabilir; this üzerinden bir çağrı doğrudan gerçek nesneye gider, proxy'yi tamamen atlar.$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Self-invocation, Spring'de her zaman bir derleme hatası fırlatır.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$İki metot aynı sınıfta olduğunda @Transactional otomatik olarak devre dışı kalır.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the difference between `PROPAGATION_REQUIRED` and `PROPAGATION_REQUIRES_NEW`? (Select all that apply)$$,
           NULL, NULL,
           $$REQUIRED joins an already-active transaction if one exists. REQUIRES_NEW suspends any active transaction and starts a completely independent new one that commits or rolls back entirely on its own.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transaction-management'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$REQUIRED always starts a brand-new transaction, ignoring any active one.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$If the outer transaction rolls back, work done in a REQUIRES_NEW inner transaction is always rolled back with it.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$REQUIRED joins an already-active transaction if one exists, rather than starting a second one.$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$REQUIRES_NEW suspends any active transaction and starts a completely independent new one that commits or rolls back entirely on its own.$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$`PROPAGATION_REQUIRED` ile `PROPAGATION_REQUIRES_NEW` arasındaki farkı doğru şekilde tanımlayan ifadeler hangileridir? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$REQUIRED, zaten aktif bir transaction varsa ona katılır. REQUIRES_NEW, aktif olan her transaction'ı askıya alır ve tamamen bağımsız, kendi başına commit ya da rollback olan yeni bir tane başlatır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transaction-management'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$REQUIRES_NEW, aktif olan her transaction'ı askıya alır ve tamamen bağımsız, kendi başına commit ya da rollback olan yeni bir tane başlatır.$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$REQUIRED, aktif olan bir transaction'ı yok sayarak her zaman yepyeni bir tane başlatır.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Dış transaction rollback olursa, bir REQUIRES_NEW iç transaction'ında yapılan iş her zaman onunla birlikte rollback olur.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$REQUIRED, zaten aktif bir transaction varsa ikinci birini başlatmak yerine ona katılır.$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does `@Transactional(readOnly = true)` actually guarantee?$$,
           NULL, NULL,
           $$Nothing enforced -- it's a hint to Spring/JPA for performance optimization, not an actual restriction that prevents writes.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transaction-management'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Nothing enforced -- it's a hint to Spring/JPA for performance optimization, not an actual restriction that prevents writes.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It guarantees the method can never write to the database, throwing an exception on any write attempt.$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It automatically makes the transaction run on a read replica database.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It disables the method's own @Transactional annotation entirely.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`@Transactional(readOnly = true)` gerçekte neyi garanti eder?$$,
           NULL, NULL,
           $$Hiçbir şeyi zorlamaz -- performans optimizasyonu için Spring/JPA'ya bir ipucudur, yazmaları engelleyen gerçek bir kısıtlama değildir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transaction-management'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Metodun kendi @Transactional annotation'ını tamamen devre dışı bırakır.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Hiçbir şeyi zorlamaz -- performans optimizasyonu için Spring/JPA'ya bir ipucudur, yazmaları engelleyen gerçek bir kısıtlama değildir.$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Metodun veritabanına asla yazamayacağını garanti eder, herhangi bir yazma girişiminde istisna fırlatır.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Transaction'ın otomatik olarak bir read replica veritabanında çalışmasını sağlar.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, why is the service layer, not the controller, the widely accepted place to put `@Transactional`?$$,
           NULL, NULL,
           $$A single service method usually makes several repository calls that should be one unit, and putting it on the controller would unnecessarily widen the transaction to cover unrelated work like rendering a view.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transaction-management'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The repository layer already handles all transaction boundaries, so the service layer's annotation is purely decorative.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Putting @Transactional on the controller makes the transaction faster, not slower.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$A single service method usually makes several repository calls that should be one unit, and putting it on the controller would unnecessarily widen the transaction to cover unrelated work like rendering a view.$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Controllers can never be marked @Transactional at all -- it's a compile error.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `@Transactional`'ı controller yerine service katmanına koymak neden yaygın olarak kabul gören kural?$$,
           NULL, NULL,
           $$Tek bir service metodu genellikle birden fazla repository çağrısı yapar ve bunların tek bir birim olması gerekir; controller'a koymak, transaction'ı bir view render etmek gibi ilgisiz işleri de kapsayacak şekilde gereksiz yere genişletir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transaction-management'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Controller'lar asla @Transactional işaretlenemez -- bu bir derleme hatasıdır.$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Repository katmanı zaten tüm transaction sınırlarını halleder, bu yüzden service katmanındaki annotation tamamen dekoratiftir.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$@Transactional'ı controller'a koymak transaction'ı daha yavaş değil daha hızlı yapar.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Tek bir service metodu genellikle birden fazla repository çağrısı yapar ve bunların tek bir birim olması gerekir; controller'a koymak, transaction'ı bir view render etmek gibi ilgisiz işleri de kapsayacak şekilde gereksiz yere genişletir.$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What happens when `createOrder(true)` is called?$$,
           $$class OrderCreatedEvent { }

@Component
class ShippingNotifier {
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    void onOrderCreated(OrderCreatedEvent event) {
        System.out.println("Shipping notification sent");
    }
}

class OrderService {
    @Transactional
    void createOrder(boolean simulateFailureAfterPublish) {
        eventPublisher.publishEvent(new OrderCreatedEvent());
        if (simulateFailureAfterPublish) {
            throw new RuntimeException("failure after publish");
        }
    }
}$$, $$java$$,
           $$createOrder(true) throws a RuntimeException, so the transaction rolls back. AFTER_COMMIT listeners only run if the transaction that published the event actually commits -- since it never commits here, the listener never runs, even though the event was published.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transaction-management'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$"Shipping notification sent" is never printed, because the transaction rolled back before committing.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$"Shipping notification sent" is printed, since the event was already published before the exception was thrown.$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$The application fails to start, since @TransactionalEventListener requires @EnableTransactionManagement explicitly.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$"Shipping notification sent" is printed twice, once for the event and once for the rollback.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$`siparisOlustur(true)` çağrıldığında ne olur?$$,
           $$class SiparisOlusturulduEvent { }

@Component
class KargoBildirici {
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    void siparisOlusturulduAninda(SiparisOlusturulduEvent event) {
        System.out.println("Kargo bildirimi gonderildi");
    }
}

class SiparisServisi {
    @Transactional
    void siparisOlustur(boolean yayindanSonraHataSimuleEt) {
        eventPublisher.publishEvent(new SiparisOlusturulduEvent());
        if (yayindanSonraHataSimuleEt) {
            throw new RuntimeException("yayindan sonra hata");
        }
    }
}$$, $$java$$,
           $$siparisOlustur(true), bir RuntimeException fırlatır, bu yüzden transaction rollback edilir. AFTER_COMMIT listener'ları yalnızca event'i yayınlayan transaction gerçekten commit olursa çalışır -- burada hiç commit olmadığı için, event yayınlanmış olsa bile listener hiç çalışmaz.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transaction-management'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$"Kargo bildirimi gonderildi" iki kez yazdırılır, biri event için biri rollback için.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$"Kargo bildirimi gonderildi" hiç yazdırılmaz, çünkü transaction commit olmadan rollback edildi.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$"Kargo bildirimi gonderildi" yazdırılır, çünkü istisna fırlatılmadan önce event zaten yayınlandı.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Uygulama başlayamaz, çünkü @TransactionalEventListener açıkça @EnableTransactionManagement gerektirir.$$, FALSE, 3 FROM new_question_tr7;
