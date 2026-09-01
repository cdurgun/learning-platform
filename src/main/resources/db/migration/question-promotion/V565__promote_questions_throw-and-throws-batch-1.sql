-- Promotion batch
-- Topic: throw-and-throws (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V541 (records), V545 (reflection), V549 (date-time),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/throw-and-throws.md and content/tr/throw-and-throws.md.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different code/variable names, different question
-- framing) rather than a translation.
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
           $$Which statement correctly distinguishes `throw` from `throws`?$$,
           NULL, NULL,
           $$throw is a statement that executes at a specific point in code and immediately hands a Throwable instance to the JVM at runtime; throws is a declaration on a method signature, purely compile-time bookkeeping.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'throw-and-throws'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$throw is a compile-time declaration; throws is a runtime statement.$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$throw is a runtime statement that hands a Throwable to the JVM; throws is a compile-time declaration on a method signature.$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Both are runtime statements with identical behavior.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$throws can only be used with unchecked exceptions.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`throws` bildirimi tek başına çalıştırıldığında ne olur?$$,
           NULL, NULL,
           $$throws, tek başına, hiçbir şey fırlatmaz ya da hiçbir kod çalıştırmaz -- yalnızca derleyiciye ve metodu okuyan herkese o metottan hangi checked exception'ların çıkabileceğini söyler.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'throw-and-throws'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Belirtilen exception türünü hemen fırlatır.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Hiçbir şey -- yalnızca derleyiciye hangi checked exception'ların metottan çıkabileceğini söyler, kod çalıştırmaz.$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Metodun içindeki tüm exception'ları otomatik olarak yakalar.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$throw ifadesiyle aynı çalışma zamanı davranışına sahiptir.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What happens when compiling this?$$,
           $$public class Demo {
    static void reject() {
        throw new IllegalStateException("not allowed");
        System.out.println("after");
    }
    public static void main(String[] args) {
        reject();
    }
}$$, $$java$$,
           $$Any code written directly after an unconditional throw is unreachable, and the compiler rejects it outright -- there is nothing to "return" from, and nowhere to place code after it in that same block.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'throw-and-throws'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Fails to compile -- the System.out.println line is unreachable.$$, TRUE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Prints "after" then throws.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Throws IllegalStateException silently, "after" is never printed.$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Compiles and runs, printing nothing.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$public class Ornek {
    static double indirimUygula(double fiyat, int yuzde) {
        if (yuzde < 0 || yuzde > 100) {
            throw new IllegalArgumentException("gecersiz yuzde: " + yuzde);
        }
        return fiyat - (fiyat * yuzde / 100);
    }
    public static void main(String[] args) {
        try {
            System.out.println(indirimUygula(200.0, 150));
        } catch (IllegalArgumentException e) {
            System.out.println("hata: " + e.getMessage());
        }
    }
}$$, $$java$$,
           $$applyDiscount fail-fast validasyon yapar: yuzde 150, geçerli aralığın (0-100) dışında olduğu için gerçek hesaplama yapılmadan IllegalArgumentException fırlatılır, mesajıyla birlikte yakalanıp yazdırılır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'throw-and-throws'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$hata: gecersiz yuzde: 150$$, TRUE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$-100.0$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Derleme hatası.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$hata: null$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$public class Demo {
    static int parseConfig(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            throw new IllegalStateException("configuration file is corrupt", e);
        }
    }
    public static void main(String[] args) {
        try {
            parseConfig("abc");
        } catch (IllegalStateException e) {
            System.out.println(e.getMessage() + " caused by " + e.getCause().getClass().getSimpleName());
        }
    }
}$$, $$java$$,
           $$parseConfig catches the low-level NumberFormatException and rethrows a more meaningful IllegalStateException, passing the original as cause -- so both the new message and the original exception's type remain accessible.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'throw-and-throws'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$configuration file is corrupt caused by NumberFormatException$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$abc caused by IllegalStateException$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Compile error -- parseConfig must declare throws$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$configuration file is corrupt caused by null$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kodun çalışma davranışı nedir?$$,
           $$public class Ornek {
    static void adim1() throws java.io.FileNotFoundException {
        adim2();
    }
    static void adim2() throws java.io.FileNotFoundException {
        throw new java.io.FileNotFoundException("dosya yok");
    }
    public static void main(String[] args) throws java.io.FileNotFoundException {
        adim1();
        System.out.println("bitti");
    }
}$$, $$java$$,
           $$adim1 ve adim2 yalnızca throws bildirir, hiçbiri catch etmez; main de yalnızca throws bildirdiği için exception hiçbir yerde yakalanmadan yayılır ve program bir stack trace ile sonlanır -- "bitti" hiç çalışmaz.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'throw-and-throws'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$"bitti" yazdırılır, sonra program biter.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Program, exception yakalanmadığı için bir stack trace ile sonlanır, "bitti" hiç yazdırılmaz.$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Derlenmez çünkü adim2() exception'ı catch etmiyor.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$adim1() exception'ı otomatik olarak yutar.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$True or false: declaring `throws SomeException` on a method reduces or catches that exception in some way.$$,
           NULL, NULL,
           $$Declaring throws SomeException does not catch or reduce the exception in any way -- it only shifts the compiler's obligation to whoever calls the method. If nothing up the call chain ever catches it, it still terminates the program when uncaught.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'throw-and-throws'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$True -- it automatically catches the exception if no caller does.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$False -- it only shifts the compiler's obligation to the caller; if nothing ever catches it, the program still terminates.$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$True -- it converts the exception to an unchecked one.$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$False -- throws has no effect on checked exceptions at all.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`throw` ve `throws` arasındaki farkla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$throw, bir metodun gövdesinin yaptığı bir şeydir, belirli bir satırda, çalışma zamanında çalışır; throws ise bir metodun imzasının bildirdiği bir şeydir ve tek bir metot, hiç throw çağırmadan bile ihtiyaç duyduğu kadar çok exception türünü virgülle ayırarak bildirebilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'throw-and-throws'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$throw, çalışma zamanında belirli bir satırda çalışan bir ifadedir.$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$throws, aynı metotta hiç throw çağrısı olmadan bile birden fazla exception türünü virgülle bildirebilir.$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$throws, metot çalıştığında JVM'e bir Throwable nesnesi teslim eder.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$throw, bir metot imzasında yer alan derleme-zamanı bir bildirimdir.$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are Best Practices recommended in this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Best Practices recommend validating arguments and throwing at the very top of a method (fail fast), and always passing the original exception as cause when rethrowing a different type.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'throw-and-throws'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Validate arguments and throw at the very top of a method -- fail fast.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$When rethrowing a different exception type, always pass the original as the cause.$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Add throws declarations defensively, "just in case," even if the method can't actually throw them.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Prefer a generic throw new RuntimeException("error") over a more descriptive exception type.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre aşağıdakilerden hangisi yaygın bir hatadır?$$,
           NULL, NULL,
           $$Ne olduğunu gerçekten anlatan bir tür ve mesaj yerine genel, düşük bilgili bir exception fırlatmak (throw new RuntimeException("error") gibi) bu derste açıkça bir yaygın hata olarak belirtilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'throw-and-throws'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$throw new RuntimeException("error") gibi genel, düşük bilgili bir exception fırlatmak.$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir metodun en başında argümanları doğrulayıp fırlatmak.$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Yeniden fırlatırken orijinal exception'ı cause olarak geçirmek.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca gerçekten üretilebilecek checked exception'lar için throws eklemek.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does the `throw` statement operate on?$$,
           NULL, NULL,
           $$throw takes a single Throwable instance -- usually one you construct on the spot with new -- and transfers control away from that point immediately.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'throw-and-throws'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A String message describing the failure.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$A single Throwable instance, usually constructed on the spot with new.$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$A class name only, without instantiation.$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$An integer error code.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`throw` ile `throws` arasındaki "kaç kez/kaç tür" farkı için hangisi doğrudur?$$,
           NULL, NULL,
           $$throw, ona ulaşan bir çalışma yolu başına yalnızca bir kez görünebilir; throws ise tek bir metotta ihtiyaç duyduğu kadar çok exception türünü (virgülle ayırarak) bildirebilir, hiç throw çağırmasa bile.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'throw-and-throws'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$throw, bir çalışma yoluna ulaşan yol başına yalnızca bir kez çalışır; throws birden fazla exception türünü listeleyebilir.$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$İkisi de yalnızca bir tür belirtebilir.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$throws, bir çalışma yolu başına yalnızca bir kez çalışabilir.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$throw, virgülle ayrılmış birden fazla tür alabilir.$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson's "Why Does It Exist?" section, what problem would remain even if `throw` existed but `throws` did not?$$,
           NULL, NULL,
           $$Without throws, a checked exception thrown deep inside a call chain would have no compiler-verified path back to whoever needs to handle it -- every method in between could silently forget about it.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'throw-and-throws'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$There would be no way to signal a failure at all.$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A checked exception thrown deep in a call chain would have no compiler-verified path back to a handler -- any method in between could silently forget it.$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$All exceptions would automatically become unchecked.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Methods would be unable to declare any exceptions at all.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`throw` olmadan, kodun "bir şey ters gitti" demesinin geleneksel yolu neydi?$$,
           NULL, NULL,
           $$throw olmasaydı, kodun "bir şey ters gitti" demesinin tek yolu sihirli bir dönüş değeri olurdu (-1 ya da null gibi) -- "Exception'lara Giriş"in açtığı tam olarak bu sorundu.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'throw-and-throws'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sihirli bir dönüş değeri kullanmak (örneğin -1 ya da null).$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Programı doğrudan sonlandırmak.$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir log dosyasına yazmak.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Statik bir hata bayrağı (flag) ayarlamak.$$, FALSE, 3 FROM new_question_tr7;
