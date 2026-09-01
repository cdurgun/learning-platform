-- Promotion batch
-- Topic: exception-hierarchy (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V541 (records), V545 (reflection), V549 (date-time),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/exception-hierarchy.md and content/tr/exception-hierarchy.md.
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
           $$What are the two direct subclasses of `Throwable`?$$,
           NULL, NULL,
           $$Throwable has exactly two direct subclasses: Error and Exception. Exception in turn has its own subclass, RuntimeException.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-hierarchy'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Exception and RuntimeException$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Error and Exception$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Error and RuntimeException$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$CheckedException and UncheckedException$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`NumberFormatException`'ın hiyerarşi zinciri aşağıdakilerden hangisidir?$$,
           NULL, NULL,
           $$NumberFormatException bir IllegalArgumentException'dır, o da bir RuntimeException'dır, o da bir Exception'dır, o da bir Throwable'dır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-hierarchy'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$NumberFormatException -> IllegalArgumentException -> RuntimeException -> Exception -> Throwable$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$NumberFormatException -> Exception -> RuntimeException -> Throwable$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$NumberFormatException -> Error -> Throwable$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$NumberFormatException -> Throwable (doğrudan)$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Which statement correctly describes the relationship between `RuntimeException` and `Exception`?$$,
           NULL, NULL,
           $$RuntimeException is a subclass of Exception itself, not a sibling of it -- confusing the two is explicitly called out as a common mistake in this lesson.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-hierarchy'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$They are sibling classes, both direct subclasses of Throwable.$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$RuntimeException is a subclass of Exception.$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Exception is a subclass of RuntimeException.$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$They are unrelated classes that happen to share a naming convention.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`StackOverflowError`'ın hiyerarşi zinciri hangi sınıftan geçer?$$,
           NULL, NULL,
           $$StackOverflowError'ın zinciri hiç Exception'a uğramadan doğrudan Error üzerinden Throwable'a çıkar -- iki dal yalnızca en tepede birleşir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-hierarchy'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Exception üzerinden Throwable'a çıkar.$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$RuntimeException üzerinden Exception'a çıkar.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Error üzerinden Throwable'a çıkar, hiç Exception'a uğramaz.$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Doğrudan Throwable'ı genişletir, ara sınıf yoktur.$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$public class Demo {
    static void check(int index) {
        int[] data = {1, 2, 3};
        try {
            System.out.println(data[index] / 0);
        } catch (RuntimeException e) {
            System.out.println("caught: " + e.getClass().getSimpleName());
        }
    }
    public static void main(String[] args) {
        check(1);
    }
}$$, $$java$$,
           $$index 1 is valid, so data[1] (2) is read successfully; dividing by the literal 0 then throws ArithmeticException, which IS-A RuntimeException, so it's caught by the single catch (RuntimeException e) block.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-hierarchy'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$caught: ArithmeticException$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$caught: ArrayIndexOutOfBoundsException$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Compile error: division by zero$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The program crashes because ArithmeticException isn't a RuntimeException$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$public class Ornek {
    static void kontrol(int[] veri, int index) {
        try {
            System.out.println(veri[index]);
        } catch (RuntimeException e) {
            System.out.println("yakalandi: " + e.getClass().getSimpleName());
        }
    }
    public static void main(String[] args) {
        kontrol(new int[]{5, 10}, 7);
    }
}$$, $$java$$,
           $$veri dizisinin uzunluğu 2, ama index 7 istendiği için ArrayIndexOutOfBoundsException fırlatılır -- bu sınıf RuntimeException'ın bir alt sınıfı olduğu için tek bir catch (RuntimeException e) bloğuyla yakalanır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-hierarchy'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$yakalandi: ArrayIndexOutOfBoundsException$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$yakalandi: ArithmeticException$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Derleme hatası.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Program çöker, hiçbir şey yazdırılmaz.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$public class Demo {
    static void report(Exception e) {
        if (e instanceof RuntimeException) {
            System.out.println("unchecked");
        } else {
            System.out.println("checked");
        }
    }
    public static void main(String[] args) {
        report(new NumberFormatException("bad"));
    }
}$$, $$java$$,
           $$instanceof checks at runtime whether an object is an instance of a given class or any of its ancestors. NumberFormatException IS-A RuntimeException, so the check is true and "unchecked" is printed.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-hierarchy'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$unchecked$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$checked$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Compile error, NumberFormatException isn't an Exception.$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Throws a ClassCastException at runtime.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$public class Ornek {
    static void bilgiVer(Throwable t) {
        if (t instanceof Exception) {
            System.out.println("exception");
        } else {
            System.out.println("exception degil");
        }
    }
    public static void main(String[] args) {
        bilgiVer(new StackOverflowError());
    }
}$$, $$java$$,
           $$StackOverflowError, Exception'ın değil Error'ın bir alt sınıfıdır -- bu yüzden instanceof Exception kontrolü false döner ve "exception degil" yazdırılır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-hierarchy'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$exception$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$exception degil$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Derleme hatası.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$NullPointerException fırlatılır.$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why can a broad `catch (Exception e)` block that does nothing meaningful be dangerous?$$,
           NULL, NULL,
           $$This lesson's Common Mistakes section explains that catch (Exception e) with nothing meaningful inside it silently swallows every checked AND unchecked exception, making debugging nearly impossible (though NOT Error, since Exception doesn't cover it).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-hierarchy'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It silently swallows every checked and unchecked exception, making debugging nearly impossible.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It also swallows every Error, since Exception includes Error.$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It prevents the program from compiling.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It automatically rethrows the exception after logging it.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`catch (Exception e)` ile `catch (Throwable t)` arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$catch (Throwable t) yazmak, Error'ı da kapsar ve neredeyse hiçbir zaman doğru bir seçim değildir -- catch (Exception e) ise Error'ı kapsamaz.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-hierarchy'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İkisi de tamamen aynı şeyi yakalar, fark yoktur.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$catch (Throwable t), Error alt sınıflarını da kapsar, catch (Exception e) ise kapsamaz.$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$catch (Exception e) yalnızca unchecked exception'ları yakalar.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$catch (Throwable t) yalnızca checked exception'ları yakalar.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Java's exception hierarchy are true? (Select all that apply)$$,
           NULL, NULL,
           $$Throwable defines getMessage(), getStackTrace(), printStackTrace(), and getCause(), shared by every subclass; a catch block can target any ancestor of the thrown class (polymorphic catching), not just its exact class.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-hierarchy'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Throwable defines getMessage(), getStackTrace(), and getCause(), shared by all its subclasses.$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$A catch block can target any ancestor of the thrown exception's class, not just its exact class.$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Error is a subclass of Exception.$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$RuntimeException and Exception are sibling classes under Throwable.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri Java'nın exception hiyerarşisi hakkında doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$StackOverflowError'ın zinciri hiç Exception'a uğramadan Error üzerinden Throwable'a çıkar; bir catch bloğu fırlatılan sınıfın tam kendisi yerine herhangi bir atasını da hedefleyebilir (polimorfik yakalama).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-hierarchy'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$StackOverflowError'ın zinciri hiç Exception'a uğramadan Error üzerinden Throwable'a çıkar.$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir catch bloğu, fırlatılan sınıfın tam kendisi yerine herhangi bir atasını da hedefleyebilir.$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$RuntimeException, Exception'ın kardeşi olan ayrı bir daldır.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Error, Exception'ın bir alt sınıfıdır.$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson's Best Practices, which of the following are recommended? (Select all that apply)$$,
           NULL, NULL,
           $$Best Practices recommend catching the most specific type you actually expect rather than defaulting to a broad type, and avoiding catching Error (or Throwable directly) since the JVM is usually already unrecoverable by then.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-hierarchy'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Catch the most specific exception type you actually expect, rather than defaulting to a broad type.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Avoid catching Error (or Throwable directly) since the JVM is usually already in an unrecoverable state.$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Always prefer catch (Throwable t) so nothing ever escapes unhandled.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Memorize the entire hierarchy instead of using tools like getSuperclass().$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre aşağıdakilerden hangileri yaygın bir hatadır? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$catch (Throwable t) yazmak Error'ı da kapsar ve neredeyse hiçbir zaman doğru değildir; RuntimeException'ın Exception'dan ayrı bir dal olduğunu düşünmek de hiyerarşiyi karıştıran bir hatadır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-hierarchy'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$catch (Throwable t) yazmak -- bu Error'ı da kapsar ve neredeyse hiçbir zaman doğru bir seçim değildir.$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$RuntimeException'ın Exception'dan AYRI bir dal olduğunu düşünmek.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$catch bloklarını en spesifik türden en genele doğru sıralamak.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$instanceof kullanarak nesnenin gerçek türünü çalışma zamanında kontrol etmek.$$, FALSE, 3 FROM new_question_tr7;
