-- Promotion batch
-- Topic: built-in-functional-interfaces (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V615-V627 (OOP) and V599-V611 (collections),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/built-in-functional-interfaces.md and content/tr/built-in-functional-interfaces.md.
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

-- Pair 1 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.function.Predicate;

public class Demo {
    public static void main(String[] args) {
        Predicate<String> isLong = s -> s.length() > 3;
        Predicate<String> startsWithA = s -> s.startsWith("A");
        Predicate<String> combined = isLong.and(startsWithA);
        System.out.println(combined.test("Anna"));
        System.out.println(combined.test("Al"));
    }
}$$, $$java$$,
           $$and() combines two predicates so both must be true. "Anna" has length 4 (>3) and starts with "A" -- true. "Al" has length 2, which fails the first check -- false.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'built-in-functional-interfaces'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$true
false$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$false
true$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$true
true$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$false
false$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.function.Predicate;

public class Ornek {
    public static void main(String[] args) {
        Predicate<String> uzunMu = s -> s.length() > 4;
        Predicate<String> mIleBasliyorMu = s -> s.startsWith("M");
        Predicate<String> birlesik = uzunMu.and(mIleBasliyorMu);
        System.out.println(birlesik.test("Merhaba"));
        System.out.println(birlesik.test("Masa"));
    }
}$$, $$java$$,
           $$and(), iki predicate'i birleştirir, ikisinin de true olması gerekir. "Merhaba"nın uzunluğu 7 (>4) ve "M" ile başlıyor -- true. "Masa"nın uzunluğu 4, ilk kontrolü geçemiyor -- false.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'built-in-functional-interfaces'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$false
false$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$true
false$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$false
true$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$true
true$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.function.Function;

public class Demo {
    public static void main(String[] args) {
        Function<Integer, Integer> addOne = x -> x + 1;
        Function<Integer, Integer> timesTwo = x -> x * 2;
        System.out.println(addOne.andThen(timesTwo).apply(3));
        System.out.println(addOne.compose(timesTwo).apply(3));
    }
}$$, $$java$$,
           $$f.andThen(g) runs f first, then feeds the result into g: (3+1)*2=8. f.compose(g) runs g first, then feeds the result into f: (3*2)+1=7.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'built-in-functional-interfaces'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$8
8$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$7
7$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$8
7$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$7
8$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.function.Function;

public class Ornek {
    public static void main(String[] args) {
        Function<Integer, Integer> birEkle = x -> x + 1;
        Function<Integer, Integer> ucKatla = x -> x * 3;
        System.out.println(birEkle.andThen(ucKatla).apply(2));
        System.out.println(birEkle.compose(ucKatla).apply(2));
    }
}$$, $$java$$,
           $$f.andThen(g), önce f'i çalıştırır, sonucunu g'ye verir: (2+1)*3=9. f.compose(g), önce g'yi çalıştırır, sonucunu f'e verir: (2*3)+1=7.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'built-in-functional-interfaces'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$7
9$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$9
9$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$7
7$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$9
7$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Which statement correctly distinguishes `Consumer<T>` from `Supplier<T>`?$$,
           NULL, NULL,
           $$Consumer's accept(T) takes a value and performs a side effect, returning nothing. Supplier's get() takes no input at all and produces a value.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'built-in-functional-interfaces'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Consumer's accept(T) takes a value and performs a side effect, returning nothing; Supplier's get() takes no input and produces a value.$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Consumer produces a value with no input; Supplier takes a value and performs a side effect.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Both take a value and return a transformed value.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Consumer and Supplier are interchangeable, differing only in name.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`Consumer<T>` ile `Supplier<T>` arasındaki fark için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$Consumer'ın accept(T)'si bir değer alır ve bir yan etki uygular, hiçbir şey döndürmez. Supplier'ın get()'i ise hiçbir girdi almadan bir değer üretir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'built-in-functional-interfaces'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Consumer ve Supplier, yalnızca isim olarak farklı, birbirinin yerine geçebilir arayüzlerdir.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Consumer'ın accept(T)'si bir değer alır ve bir yan etki uygular, hiçbir şey döndürmez; Supplier'ın get()'i hiçbir girdi almadan bir değer üretir.$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Consumer hiçbir girdi olmadan bir değer üretir; Supplier bir değer alıp yan etki uygular.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$İkisi de bir değer alıp dönüştürülmüş bir değer döner.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is the relationship between `UnaryOperator<T>` and `Function<T, T>`?$$,
           NULL, NULL,
           $$UnaryOperator<T> extends Function<T, T> -- it exists purely for readability, to express that input and output share the same type.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'built-in-functional-interfaces'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Function<T, T> extends UnaryOperator<T>.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$UnaryOperator<T> can only be used with primitive types, never with objects.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$UnaryOperator<T> extends Function<T, T> -- it exists purely for readability, to express that input and output share the same type.$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$UnaryOperator<T> is a completely unrelated interface with a different abstract method signature.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`UnaryOperator<T>` ile `Function<T, T>` arasındaki ilişki nedir?$$,
           NULL, NULL,
           $$UnaryOperator<T>, Function<T, T>'yi extends eder -- yalnızca okunabilirlik için vardır, girdi ve çıktının aynı tür olduğunu ifade eder.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'built-in-functional-interfaces'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$UnaryOperator<T>, farklı bir abstract metot imzasına sahip, tamamen ilgisiz bir interface'tir.$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Function<T, T>, UnaryOperator<T>'yi extends eder.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$UnaryOperator<T> yalnızca primitive türlerle kullanılabilir, nesnelerle asla kullanılamaz.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$UnaryOperator<T>, Function<T, T>'yi extends eder -- yalnızca okunabilirlik için vardır, girdi ve çıktının aynı tür olduğunu ifade eder.$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.function.BiFunction;
import java.util.function.Function;

public class Demo {
    public static void main(String[] args) {
        Function<String, Integer> parse = Integer::parseInt;
        BiFunction<String, String, Boolean> starts = String::startsWith;
        System.out.println(parse.apply("42"));
        System.out.println(starts.apply("hello", "he"));
    }
}$$, $$java$$,
           $$Integer::parseInt is a Class::staticMethod reference. String::startsWith is an unbound Class::instanceMethod reference -- the first BiFunction argument ("hello") becomes the receiver, the second ("he") becomes startsWith's parameter.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'built-in-functional-interfaces'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$42
true$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Compile error -- String::startsWith needs an existing String object to bind to.$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$42
false$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Compile error -- BiFunction can't accept a method reference.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.function.BiFunction;
import java.util.function.Function;

public class Ornek {
    public static void main(String[] args) {
        Function<String, Integer> ayristir = Integer::parseInt;
        BiFunction<String, String, Boolean> icerirMi = String::contains;
        System.out.println(ayristir.apply("99"));
        System.out.println(icerirMi.apply("merhaba", "hab"));
    }
}$$, $$java$$,
           $$Integer::parseInt bir Class::staticMethod referansıdır. String::contains ise unbound bir Class::instanceMethod referansıdır -- BiFunction'ın ilk argümanı ("merhaba") receiver olur, ikincisi ("hab") contains'in parametresi olur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'built-in-functional-interfaces'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme hatası -- BiFunction bir method reference kabul edemez.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$99
true$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Derleme hatası -- String::contains'in bağlanacağı var olan bir String nesnesine ihtiyacı var.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$99
false$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.function.Supplier;
import java.util.ArrayList;
import java.util.List;

public class Demo {
    public static void main(String[] args) {
        Supplier<List<String>> listMaker = ArrayList::new;
        List<String> list = listMaker.get();
        list.add("ok");
        System.out.println(list.size());
    }
}$$, $$java$$,
           $$Class::new points at a constructor -- ArrayList::new is used here as a Supplier<List<String>>, so calling get() creates a fresh, empty ArrayList each time.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'built-in-functional-interfaces'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Compile error -- ArrayList::new can't be assigned to Supplier.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It throws UnsupportedOperationException.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$1$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$0$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.function.Supplier;
import java.util.ArrayList;
import java.util.List;

public class Ornek {
    public static void main(String[] args) {
        Supplier<List<Integer>> listeUretici = ArrayList::new;
        List<Integer> liste = listeUretici.get();
        liste.add(5);
        liste.add(10);
        System.out.println(liste.size());
    }
}$$, $$java$$,
           $$Class::new bir constructor'ı işaret eder -- burada ArrayList::new bir Supplier<List<Integer>> olarak kullanılır, bu yüzden get() çağrısı her seferinde yeni, boş bir ArrayList oluşturur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'built-in-functional-interfaces'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$0$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Derleme hatası -- ArrayList::new bir Supplier'a atanamaz.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$UnsupportedOperationException fırlatır.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$2$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about bound vs. unbound method references? (Select all that apply)$$,
           NULL, NULL,
           $$A bound reference (object::instanceMethod) points to an instance method on a specific, already-existing object, which the reference captures. An unbound reference (Class::instanceMethod) uses the functional interface's first parameter as the method's receiver, and the rest as arguments.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'built-in-functional-interfaces'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A bound reference (object::instanceMethod) points to an instance method on a specific, already-existing object, which the reference captures.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$An unbound reference (Class::instanceMethod) uses the functional interface's first parameter as the method's receiver, and the rest as arguments.$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Bound and unbound method references always have identical target-interface signatures.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$An unbound reference requires an already-existing object to be captured, exactly like a bound reference.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bound ve unbound method reference'lar hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Bound bir referans (object::instanceMethod), belirli, zaten var olan bir nesne üzerindeki bir instance metodunu işaret eder ve o nesneyi yakalar. Unbound bir referans (Class::instanceMethod) ise functional interface'in ilk parametresini metodun receiver'ı, geri kalanını argümanları olarak kullanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'built-in-functional-interfaces'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Unbound bir referans, tıpkı bound bir referans gibi, zaten var olan bir nesnenin yakalanmasını gerektirir.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bound bir referans (object::instanceMethod), belirli, zaten var olan bir nesne üzerindeki bir instance metodunu işaret eder ve o nesneyi yakalar.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Unbound bir referans (Class::instanceMethod), functional interface'in ilk parametresini metodun receiver'ı, geri kalanını ise argümanları olarak kullanır.$$, TRUE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bound ve unbound method reference'lar her zaman aynı hedef-interface imzasına sahiptir.$$, FALSE, 3 FROM new_question_tr7;
