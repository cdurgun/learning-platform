-- Promotion batch
-- Topic: lambda-expressions (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V615-V627 (OOP) and V599-V611 (collections),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/lambda-expressions.md and content/tr/lambda-expressions.md.
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
           $$Which of the following lambda expressions fails to compile?$$,
           NULL, NULL,
           $$For exactly one parameter, parentheses are optional, but for two or more parameters, parentheses become mandatory again -- a, b -> a + b doesn't compile, you have to write (a, b) -> a + b.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lambda-expressions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`a, b -> a + b`$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$`(a, b) -> a + b`$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$`x -> x * 2`$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$`() -> 42`$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki lambda ifadelerinden hangisi derlenmez?$$,
           NULL, NULL,
           $$Tam olarak bir parametre için parantezler isteğe bağlıdır, ama iki ya da daha fazla parametre için parantezler tekrar zorunlu hale gelir -- a, b -> a + b derlenmez, (a, b) -> a + b yazman gerekir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lambda-expressions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`() -> 42`$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$`a, b -> a + b`$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$`(a, b) -> a + b`$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$`x -> x * 2`$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$import java.util.function.Function;

public class Demo {
    public static void main(String[] args) {
        Function<String, String> greet = name -> {
            "Hi, " + name;
        };
        System.out.println(greet.apply("Ana"));
    }
}$$, $$java$$,
           $$The moment a lambda body is wrapped in { }, return becomes explicit and mandatory on every path that produces a value. Without it, "Hi, " + name; isn't even a valid statement on its own, so this fails to compile.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lambda-expressions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It compiles and prints "null".$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It compiles but throws a NullPointerException at runtime.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It fails to compile.$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It compiles and prints "Hi, Ana".$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$import java.util.function.Function;

public class Ornek {
    public static void main(String[] args) {
        Function<Integer, Integer> kare = x -> {
            x * x;
        };
        System.out.println(kare.apply(5));
    }
}$$, $$java$$,
           $$Bir lambda gövdesi { } içine alındığı anda, değer üreten her yolda return açık ve zorunlu hale gelir. Bu olmadan x * x; tek başına geçerli bir ifade bile değildir, bu yüzden bu derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lambda-expressions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenir ve 25 yazdırır.$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Derlenir ve 0 yazdırır.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Derlenir ama çalışma zamanında bir istisna fırlatır.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Derlenmez.$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.Comparator;
import java.util.function.BiFunction;

public class Demo {
    public static void main(String[] args) {
        Comparator<String> cmp = (a, b) -> a.length() - b.length();
        BiFunction<String, String, Integer> fn = (a, b) -> a.length() - b.length();
        System.out.println(cmp.compare("hi", "hello"));
        System.out.println(fn.apply("hi", "hello"));
    }
}$$, $$java$$,
           $$A lambda has no type of its own -- the compiler assigns it one from context. Since Comparator's compare and BiFunction's apply have the exact same shape (two Strings in, one result out), the exact same lambda expression fits both.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lambda-expressions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$-3
-3$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Compile error -- the same lambda can't implement two different interfaces.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$-3
Compile error.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$3
3$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.Comparator;
import java.util.function.BiFunction;

public class Ornek {
    public static void main(String[] args) {
        Comparator<String> karsilastir = (a, b) -> a.length() - b.length();
        BiFunction<String, String, Integer> islev = (a, b) -> a.length() - b.length();
        System.out.println(karsilastir.compare("ev", "araba"));
        System.out.println(islev.apply("ev", "araba"));
    }
}$$, $$java$$,
           $$Bir lambda'nın kendine ait bir türü yoktur -- derleyici ona bağlamdan bir tür atar. Comparator'ın compare'i ile BiFunction'ın apply'ı tam olarak aynı şekle sahip olduğu için (iki String girer, bir sonuç çıkar), aynı lambda ifadesi ikisine de uyar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lambda-expressions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$3
3$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$-3
-3$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Derleme hatası -- aynı lambda iki farklı interface'i implement edemez.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$-3
Derleme hatası.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$import java.util.function.Supplier;

public class Demo {
    public static void main(String[] args) {
        int count = 5;
        Supplier<Integer> supplier = () -> count * 2;
        count = 10;
        System.out.println(supplier.get());
    }
}$$, $$java$$,
           $$A lambda can only capture a local variable that is effectively final -- never reassigned after its first assignment. count is reassigned to 10 after the lambda captures it, so this fails to compile, even though the reassignment happens after the lambda is defined.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lambda-expressions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It compiles and prints 20.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It compiles but throws IllegalStateException at runtime.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It fails to compile.$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$It compiles and prints 10.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$import java.util.function.Supplier;

public class Ornek {
    public static void main(String[] args) {
        int adet = 3;
        Supplier<Integer> tedarikci = () -> adet * 10;
        adet = 7;
        System.out.println(tedarikci.get());
    }
}$$, $$java$$,
           $$Bir lambda yalnızca effectively final olan bir yerel değişkeni yakalayabilir -- ilk atamasından sonra asla yeniden atanmamış olması gerekir. adet, lambda onu yakaladıktan sonra 7'ye yeniden atanıyor, bu yüzden bu derlenmez, yeniden atama lambda tanımlandıktan sonra gerçekleşse bile.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lambda-expressions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenir ve 70 yazdırır.$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Derlenir ve 30 yazdırır.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Derlenir ama çalışma zamanında bir istisna fırlatır.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Derlenmez.$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about the difference between an anonymous inner class and a lambda? (Select all that apply)$$,
           NULL, NULL,
           $$Inside an anonymous inner class, this refers to the anonymous class's own instance. Inside a lambda, this refers to the enclosing object, as if the lambda's body had been pasted directly into the surrounding method.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lambda-expressions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Inside an anonymous inner class, `this` refers to the anonymous class's own instance.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Inside a lambda, `this` refers to the enclosing object, as if the lambda's body were pasted directly into the surrounding method.$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$A lambda produces a separate compiled class, the same way an anonymous inner class does.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Inside a lambda, `this` refers to the lambda's own instance, requiring `OuterClass.this` to reach the enclosing object.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Anonymous inner class ile lambda arasındaki fark hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Bir anonymous inner class'ın içinde this, o anonymous class'ın kendi instance'ına işaret eder. Bir lambda'nın içinde ise this, sanki lambda'nın gövdesi çevreleyen metoda doğrudan yapıştırılmış gibi, çevreleyen nesneye işaret eder.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lambda-expressions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir lambda'nın içinde `this`, lambda'nın kendi instance'ına işaret eder, çevreleyen nesneye ulaşmak için `OuterClass.this` gerekir.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir anonymous inner class'ın içinde `this`, o anonymous class'ın kendi instance'ına işaret eder.$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir lambda'nın içinde `this`, sanki lambda'nın gövdesi çevreleyen metoda doğrudan yapıştırılmış gibi, çevreleyen nesneye işaret eder.$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir lambda, tıpkı bir anonymous inner class gibi ayrı, derlenmiş bir sınıf üretir.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why can the exact same lambda expression `(a, b) -> a.length() - b.length()` be assigned to both `Comparator<String>` and `BiFunction<String, String, Integer>`?$$,
           NULL, NULL,
           $$Both interfaces' single abstract method has the exact same shape -- two Strings in, one Integer/int result out -- so the same lambda expression fits both target types.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lambda-expressions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because the compiler automatically converts between any two functional interfaces.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Because lambdas are dynamically typed at runtime, so the target interface doesn't matter.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Because both interfaces' single abstract method has the exact same shape -- two Strings in, one Integer/int result out.$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Because Comparator and BiFunction are actually the same interface under different names.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aynı `(a, b) -> a.length() - b.length()` lambda ifadesi neden hem `Comparator<String>`'a hem `BiFunction<String, String, Integer>`'a atanabilir?$$,
           NULL, NULL,
           $$Her iki interface'in de tek abstract metodu tam olarak aynı şekle sahiptir -- iki String girer, bir Integer/int sonuç çıkar -- bu yüzden aynı lambda ifadesi her iki hedef türe de uyar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lambda-expressions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü Comparator ve BiFunction aslında farklı isimler altında aynı interface'tir.$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Çünkü derleyici herhangi iki functional interface arasında otomatik dönüşüm yapar.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Çünkü lambda'lar çalışma zamanında dinamik olarak tiplendirilir, bu yüzden hedef interface önemli değildir.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Çünkü her iki interface'in de tek abstract metodu tam olarak aynı şekle sahiptir -- iki String girer, bir Integer/int sonuç çıkar.$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what was the primary way to "pass a piece of behavior as a parameter" before lambdas existed in Java?$$,
           NULL, NULL,
           $$Before lambdas, the only tool for passing a piece of behavior as a parameter was the anonymous inner class -- even a single line of logic needed several lines of boilerplate around it.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lambda-expressions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$An anonymous inner class, which required several lines of boilerplate even for a single line of logic.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A static utility method reference, exactly like today's method references.$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Reflection-based dynamic method invocation.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$There was no way to do this before Java 8 at all.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Java'da lambda'lar var olmadan önce "bir davranışı parametre olarak geçirmenin" birincil yolu neydi?$$,
           NULL, NULL,
           $$Lambda'lardan önce, bir davranışı parametre olarak geçirmenin tek aracı anonymous inner class'tı -- tek satırlık bir mantık için bile etrafında birkaç satır boilerplate gerekiyordu.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lambda-expressions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Java 8'den önce bunu yapmanın hiçbir yolu yoktu.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Tek satırlık bir mantık için bile birkaç satır boilerplate gerektiren bir anonymous inner class.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bugünkü method reference'larla aynı, statik bir yardımcı metot referansı.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Reflection tabanlı dinamik metot çağrısı.$$, FALSE, 3 FROM new_question_tr7;
