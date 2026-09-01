-- Promotion batch
-- Topic: try-catch-finally (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V541 (records), V545 (reflection), V549 (date-time),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/try-catch-finally.md and content/tr/try-catch-finally.md.
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

-- Pair 1 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following will fail to compile?$$,
           $$try {
    int[] arr = new int[2];
    System.out.println(arr[5]);
} catch (RuntimeException e) {
    System.out.println("runtime");
} catch (ArrayIndexOutOfBoundsException e) {
    System.out.println("array");
}$$, $$java$$,
           $$A catch block for a superclass (RuntimeException) placed before a catch block for one of its subclasses (ArrayIndexOutOfBoundsException) makes the second block unreachable -- the compiler rejects this as an error, exactly as covered in "Multiple catch Blocks: Matching in Order".$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It compiles and prints "runtime".$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It compiles and prints "array".$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It fails to compile because the second catch block is unreachable.$$, TRUE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It compiles but throws an uncaught exception at runtime.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki kod parçası için ne söylenebilir?$$,
           $$try {
    String s = null;
    s.length();
} catch (Exception e) {
    System.out.println("genel");
} catch (NullPointerException e) {
    System.out.println("null");
}$$, $$java$$,
           $$Bir süper sınıf (Exception) için catch bloğu, alt sınıfından (NullPointerException) biri için catch bloğundan ÖNCE geldiği için, ikinci catch bloğu erişilemez olur -- derleyici bunu hata olarak reddeder, "Birden Fazla catch Bloğu: Sırayla Eşleşme" bölümünde anlatıldığı gibi.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenir ve "genel" yazdırır.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Derlenir ve "null" yazdırır.$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$İkinci catch bloğu erişilemez olduğu için derlenmez.$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Derlenir ama çalışma zamanında hata fırlatır.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$public class Demo {
    static int test() {
        try {
            System.out.println("try");
            return 1;
        } finally {
            System.out.println("finally");
        }
    }
    public static void main(String[] args) {
        System.out.println("result: " + test());
    }
}$$, $$java$$,
           $$finally always runs, even when the try block already contains a return -- it runs between the return value being evaluated and control actually leaving the method, so "finally" prints before "result: 1".$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$try / finally / result: 1$$, TRUE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$try / result: 1 / finally$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$finally / try / result: 1$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$try / result: 1 (finally never runs)$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$public class Ornek {
    static String islem() {
        try {
            System.out.println("deneme");
            return "tamam";
        } finally {
            System.out.println("temizlik");
        }
    }
    public static void main(String[] args) {
        System.out.println("sonuc: " + islem());
    }
}$$, $$java$$,
           $$finally, try bloğu zaten bir return içerse bile her zaman çalışır -- return değeri değerlendirildikten sonra ama kontrol metottan gerçekten çıkmadan önce çalışır, bu yüzden "temizlik" "sonuc: tamam"dan önce yazdırılır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$deneme / temizlik / sonuc: tamam$$, TRUE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$deneme / sonuc: tamam / temizlik$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$temizlik / deneme / sonuc: tamam$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$deneme / sonuc: tamam (temizlik hiç çalışmaz)$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$public class Demo {
    static int risky() {
        try {
            throw new RuntimeException("boom");
        } finally {
            return 42;
        }
    }
    public static void main(String[] args) {
        System.out.println(risky());
    }
}$$, $$java$$,
           $$When finally itself contains a return, it silently overrides whatever the try/catch was about to produce -- including a genuinely uncaught exception already propagating. The RuntimeException is discarded entirely and 42 is returned.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$42, the exception is discarded.$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Throws RuntimeException: boom.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Compile error -- you can't return from finally.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Prints 42, then the exception is thrown afterward.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$public class Ornek {
    static int hesapla() {
        try {
            return 10;
        } finally {
            return 20;
        }
    }
    public static void main(String[] args) {
        System.out.println(hesapla());
    }
}$$, $$java$$,
           $$finally'nin kendisi bir return içerdiğinde, try bloğunun döndürmek üzere olduğu her şeyi sessizce ezer -- try'ın 10 döndürme girişimi tamamen atılır, yalnızca finally'nin 20'si döner.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$10$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$20$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Derleme hatası.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Önce 10 sonra 20 yazdırılır.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Which multi-catch block correctly handles both NumberFormatException and ArrayIndexOutOfBoundsException with identical code?$$,
           NULL, NULL,
           $$Multi-catch (Java 7+) lists several unrelated exception types separated by | inside a single catch block, sharing one parameter and one handling body.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$catch (NumberFormatException, ArrayIndexOutOfBoundsException e)$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$catch (NumberFormatException | ArrayIndexOutOfBoundsException e)$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$catch (NumberFormatException e | ArrayIndexOutOfBoundsException e)$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$catch NumberFormatException, ArrayIndexOutOfBoundsException (e)$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Multi-catch (`|`) kullanımı için doğru gerekçe hangisidir?$$,
           NULL, NULL,
           $$Multi-catch, iki ya da daha fazla farklı exception tipi gerçekten aynı handling koduna ihtiyaç duyduğunda ayrı, yinelenen catch bloklarının kod tekrarını önlemek için kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İki farklı exception tipi aynı handling koduna ihtiyaç duyduğunda kod tekrarını önlemek için.$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Bir catch bloğunun birden fazla kez çalışmasını sağlamak için.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$finally bloğunu atlamak için.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Checked exception'ları unchecked yapmak için.$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$In `catch (IOException e) { ... }`, what is `e`?$$,
           NULL, NULL,
           $$The catch parameter is a genuine, ordinary local variable, scoped only to that catch block -- any method Throwable defines can be called on it, most commonly getMessage().$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A static field of the enclosing class.$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$An ordinary local variable scoped to that catch block, on which any Throwable method can be called.$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$A keyword with no type.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$A reference that can only be used to print the exception's class name.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`catch (IOException hata) { ... }` bloğundaki `hata` parametresi için ne söylenebilir?$$,
           NULL, NULL,
           $$catch bloğundaki parametre, yalnızca o catch bloğuna scope'lanmış gerçek, sıradan bir yerel değişkendir -- üzerinde Throwable'ın tanımladığı herhangi bir metot çağrılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca o catch bloğuna scope'lu, Throwable'ın tanımladığı herhangi bir metodun çağrılabildiği sıradan bir yerel değişkendir.$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Statik bir alandır.$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca toString() çağrılabilir.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Metot dışından da erişilebilir bir global değişkendir.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about `finally` are true? (Select all that apply)$$,
           NULL, NULL,
           $$finally runs unconditionally: whether the try block succeeds, an exception is caught, or an exception propagates past every catch block uncaught -- in every one of those cases, finally still runs.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$finally runs even if the try block contains a return statement.$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$finally runs even if an exception propagates past every catch block uncaught.$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$finally is skipped if the matching catch block itself throws a new exception.$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$finally only runs if at least one catch block executed.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`finally` bloğuyla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$finally, try bloğu başarılı olsa da, bir exception yakalansa da, ya da bir exception hiç yakalanmadan geçip gitse de her durumda koşulsuz olarak çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$try bloğu başarıyla tamamlansa bile finally çalışır.$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir exception hiçbir catch bloğu tarafından yakalanmadan geçip gitse bile finally çalışır.$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$finally, yalnızca bir catch bloğu gerçekten çalıştıysa tetiklenir.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir try-with-resources kullanılıyorsa finally asla çalışmaz.$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are considered mistakes according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Ordering a superclass catch before a subclass catch is a genuine compile error, and wrapping an entire method body in one giant try "just in case" makes it hard to tell which line an exception actually protects.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Ordering a superclass catch block before a subclass catch block.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Wrapping an entire method body in one giant try block "just in case".$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Using multi-catch when two unrelated exception types need identical handling.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Ordering the most specific catch block first.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre aşağıdakilerden hangileri yaygın bir hatadır? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$finally içine return ya da throw koymak, try/catch'in üretmek üzere olduğu her şeyi sessizce ezer; finally'nin bir try bloğu return ettiğinde çalışmadığını varsaymak da yanlıştır, çünkü finally her durumda çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir finally bloğunun içine return ya da throw koymak.$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$finally'nin, try bloğu return ettiğinde çalışmadığını varsaymak.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Özdeş handling mantığı için multi-catch kullanmak.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$catch bloklarını en spesifikten en genele sıralamak.$$, FALSE, 3 FROM new_question_tr7;
