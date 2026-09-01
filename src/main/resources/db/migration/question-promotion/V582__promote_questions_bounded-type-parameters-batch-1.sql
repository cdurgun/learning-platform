-- Promotion batch
-- Topic: bounded-type-parameters (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V541 (records) through V569 (custom-exceptions),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/bounded-type-parameters.md and content/tr/bounded-type-parameters.md.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different code/variable names, different question
-- framing) rather than a translation. Every question whose answer depends on
-- shown code is typed CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a
-- code_snippet attached) -- fragments/quiz.html only renders code_snippet for
-- CODE_OUTPUT questions, per the bug found and fixed in try-catch-finally/V573.
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly -- same documentation convention as prior manual
-- batches. topic_id resolved by Topic.slug; question_option rows reference
-- the newly generated id via a WITH ... RETURNING id CTE.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these 14 questions at all.

-- Pair 1 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$class Utils {
    static <T> double describe(T value) {
        return value.doubleValue();
    }
}$$, $$java$$,
           $$An unbounded T could be absolutely anything, so the compiler can only assume it has the methods every Object has -- toString(), equals(), and nothing more specific. doubleValue() isn't guaranteed to exist, so this fails to compile.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'bounded-type-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It fails to compile -- doubleValue() isn't a method every Object is guaranteed to have.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It compiles because T is always assumed to be a Number.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It compiles and returns 0.0 for any non-numeric argument.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It compiles but throws NoSuchMethodException at runtime.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$class Yardimci {
    static <T> int uzunlukVer(T deger) {
        return deger.length();
    }
}$$, $$java$$,
           $$Sınırsız bir T kesinlikle her şey olabilir, bu yüzden derleyici yalnızca her Object'in sahip olduğu metotlara sahip olduğunu varsayabilir -- toString(), equals() ve daha spesifik hiçbir şey. length() her Object'te garanti edilmez, bu yüzden bu derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'bounded-type-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenmez -- length(), her Object'in garanti ettiği bir metot değildir.$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Derlenir çünkü T her zaman String olduğu varsayılır.$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Derlenir ve sayısal olmayan her argüman için 0 döner.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Derlenir ama çalışma zamanında NoSuchMethodException fırlatır.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Utils {
    static <T extends Number> double sum(List<T> numbers) {
        double total = 0;
        for (T n : numbers) total += n.doubleValue();
        return total;
    }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(Utils.sum(List.of(1, 2, 3)));
    }
}$$, $$java$$,
           $$T extends Number guarantees every possible T -- Integer, Double, Long, or any other Number subtype -- has doubleValue(). List.of(1, 2, 3) is a List<Integer>, which qualifies since Integer extends Number, so the call compiles and sums to 6.0.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'bounded-type-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$6.0$$, TRUE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Compile error -- sum only accepts List<Number>, not List<Integer>.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$6$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Compile error -- T extends Number requires an explicit type witness.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Yardimci {
    static <T extends Number> double ortalama(List<T> sayilar) {
        double toplam = 0;
        for (T n : sayilar) toplam += n.doubleValue();
        return toplam / sayilar.size();
    }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(Yardimci.ortalama(List.of(10, 20, 30)));
    }
}$$, $$java$$,
           $$T extends Number, olası her T'nin -- Integer, Double, Long ya da başka bir Number alt türü -- doubleValue()'ya sahip olduğunu garanti eder. List.of(10, 20, 30) bir List<Integer>'dır, Integer bir Number olduğu için kabul edilir ve sonuç 20.0 olur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'bounded-type-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$20.0$$, TRUE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Derleme hatası -- ortalama yalnızca List<Number> kabul eder, List<Integer> değil.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$20$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Derleme hatası -- T extends Number açık bir tür tanığı gerektirir.$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly declares a type parameter bounded by both `Number` and `Comparable<T>`?$$,
           NULL, NULL,
           $$Multiple bounds are joined with &. At most one bound may be a class, and if there is one, it must come first, followed by interfaces -- so <T extends Number & Comparable<T>> is correct.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'bounded-type-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$<T extends Number & Comparable<T>>$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$<T extends Comparable<T> & Number>$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$<T extends Number, Comparable<T>>$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$<T extends Number | Comparable<T>>$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Hem `Number` hem `Comparable<T>` ile sınırlanmış bir tür parametresini doğru bildiren hangisidir?$$,
           NULL, NULL,
           $$Birden fazla sınır & ile birleştirilir. En fazla bir sınır bir sınıf olabilir, ve varsa, ilk sırada gelmelidir, ardından interface'ler -- bu yüzden <T extends Number & Comparable<T>> doğrudur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'bounded-type-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$<T extends Number & Comparable<T>>$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$<T extends Comparable<T> & Number>$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$<T extends Number, Comparable<T>>$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$<T extends Number | Comparable<T>>$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$class NumericBox<T extends Number> {
    private T value;
    void set(T value) { this.value = value; }
}

public class Demo {
    public static void main(String[] args) {
        NumericBox<String> box = new NumericBox<>();
    }
}$$, $$java$$,
           $$NumericBox<T extends Number> means NumericBox<String> simply cannot be written -- it fails to compile, because String doesn't satisfy the bound (it isn't a Number).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'bounded-type-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It fails to compile -- String doesn't satisfy the bound T extends Number.$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It compiles because NumericBox never actually stores anything.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It compiles but throws ClassCastException when set(...) is called.$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$It compiles, treating String as a boxed numeric type.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$class SayisalKutu<T extends Number> {
    private T deger;
    void koy(T deger) { this.deger = deger; }
}

public class Ornek {
    public static void main(String[] args) {
        SayisalKutu<Boolean> kutu = new SayisalKutu<>();
    }
}$$, $$java$$,
           $$SayisalKutu<T extends Number>, SayisalKutu<Boolean>'ın basitçe yazılamayacağı anlamına gelir -- derlenmez, çünkü Boolean sınırı karşılamaz (bir Number değildir).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'bounded-type-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenmez -- Boolean, T extends Number sınırını karşılamaz.$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Derlenir çünkü SayisalKutu aslında hiçbir şey saklamaz.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Derlenir ama koy(...) çağrıldığında ClassCastException fırlatır.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Derlenir, Boolean'ı kutulanmış sayısal bir tür olarak ele alır.$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Utils {
    static <T extends Comparable<T>> T max(List<T> items) {
        T best = items.get(0);
        for (T item : items) {
            if (item.compareTo(best) > 0) best = item;
        }
        return best;
    }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(Utils.max(List.of("banana", "apple", "cherry")));
    }
}$$, $$java$$,
           $$<T extends Comparable<T>> accepts any type that can compare itself to another of the same type -- String qualifies, with no relationship to Number required at all. "cherry" compares greatest among the three (lexicographic order).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'bounded-type-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$cherry$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Compile error -- max only accepts List<T extends Number>.$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$apple$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$banana$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Yardimci {
    static <T extends Comparable<T>> T minimum(List<T> ogeler) {
        T en = ogeler.get(0);
        for (T oge : ogeler) {
            if (oge.compareTo(en) < 0) en = oge;
        }
        return en;
    }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(Yardimci.minimum(List.of("muz", "armut", "elma")));
    }
}$$, $$java$$,
           $$<T extends Comparable<T>>, kendisini aynı türden bir başkasıyla karşılaştırabilen herhangi bir türü kabul eder -- String bu koşulu sağlar, Number ile hiçbir ilişki gerekmez. "armut" leksikografik sırada en küçüktür.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'bounded-type-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$armut$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Derleme hatası -- minimum yalnızca List<T extends Number> kabul eder.$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$elma$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$muz$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A type parameter is written as `<T extends Comparable<T> & Number>` (interface before class). Which of the following are true? (Select all that apply)$$,
           NULL, NULL,
           $$At most one bound may be a class, and if there is one, it must come first, followed by interfaces. Writing <T extends Comparable & Number> puts the interface before the class bound Number -- this doesn't compile.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'bounded-type-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$This fails to compile, since a class bound must always come before any interface bounds.$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Writing it as <T extends Number & Comparable<T>> instead would fix the problem.$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Interfaces and classes can appear in any order in a multiple-bound declaration.$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$The compiler silently drops whichever bound comes second.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir tür parametresi `<T extends Comparable<T> & Number>` (interface, sınıftan önce) şeklinde yazılıyor. Aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Sınırlardan en fazla biri bir sınıf olabilir, ve varsa, ilk sırada gelmelidir, ardından interface'ler. <T extends Comparable & Number> yazmak, interface'i sınıf sınırı olan Number'dan önce koyar -- bu derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'bounded-type-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu derlenmez, çünkü bir sınıf sınırı her zaman herhangi bir interface sınırından önce gelmelidir.$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bunun yerine <T extends Number & Comparable<T>> şeklinde yazmak sorunu çözer.$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Birden fazla sınır bildiriminde interface'ler ve sınıflar herhangi bir sırada görünebilir.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Derleyici, hangisi ikinci sırada geliyorsa o sınırı sessizce yok sayar.$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does `<T extends Comparable<T>>` on a class or method actually restrict?$$,
           NULL, NULL,
           $$Common Mistakes calls this out: the bound describes which types are allowed to be substituted in for the type parameter -- it does NOT restrict what the class or method itself can do, and it isn't a statement about the generic class's own behavior.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'bounded-type-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Which types are allowed to be substituted in for T -- not what the class or method itself can do.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$How many instances of the generic class can be created at once.$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Whether the generic class itself is allowed to implement Comparable.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$The order in which the class's own methods are compiled.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir sınıf ya da metot üzerindeki `<T extends Comparable<T>>` gerçekte neyi kısıtlar?$$,
           NULL, NULL,
           $$Yaygın Hatalar bunu açıkça belirtir: sınır, hangi türlerin tür parametresinin yerine geçebileceğini tanımlar -- sınıfın ya da metodun kendisinin ne yapabileceğini KISITLAMAZ, ve generic sınıfın kendi davranışıyla ilgili bir ifade değildir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'bounded-type-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$T'nin yerine hangi türlerin geçebileceğini -- sınıfın ya da metodun kendisinin ne yapabileceğini değil.$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Generic sınıftan aynı anda kaç instance oluşturulabileceğini.$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Generic sınıfın kendisinin Comparable implement etmesine izin verilip verilmediğini.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Sınıfın kendi metotlarının derlenme sırasını.$$, FALSE, 3 FROM new_question_tr7;
