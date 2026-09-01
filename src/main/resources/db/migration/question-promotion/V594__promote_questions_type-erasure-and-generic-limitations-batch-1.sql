-- Promotion batch
-- Topic: type-erasure-and-generic-limitations (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V541 (records) through V569 (custom-exceptions),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/type-erasure-and-generic-limitations.md and content/tr/type-erasure-and-generic-limitations.md.
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

-- Pair 1 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$List<String> strings = new ArrayList<>();
List<Integer> integers = new ArrayList<>();
System.out.println(strings.getClass() == integers.getClass());$$, $$java$$,
           $$Since the type argument doesn't survive compilation (type erasure), two collections built with different type arguments are, at runtime, indistinguishable -- strings.getClass() and integers.getClass() return the exact same Class object.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'type-erasure-and-generic-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$true$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$false$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Compile error -- getClass() cannot be compared with ==.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$NullPointerException.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$List<String> metinler = new ArrayList<>();
List<Double> ondaliklar = new ArrayList<>();
System.out.println(metinler.getClass() == ondaliklar.getClass());$$, $$java$$,
           $$Tür argümanı derlemeyi atlatamadığı için (type erasure), farklı tür argümanlarıyla inşa edilmiş iki koleksiyon çalışma zamanında birbirinden ayırt edilemez -- metinler.getClass() ve ondaliklar.getClass() tam olarak aynı Class nesnesini döndürür.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'type-erasure-and-generic-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$true$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$false$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Derleme hatası -- getClass(), == ile karşılaştırılamaz.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$NullPointerException.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Code tries to write `if (obj instanceof List<String>) { ... }`. What happens?$$,
           NULL, NULL,
           $$instanceof List<String> doesn't even compile -- there's no such runtime information as "a List of String" to check against, because of type erasure. Only the raw instanceof List<?> is legal.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'type-erasure-and-generic-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It fails to compile -- instanceof List<String> is not legal; only instanceof List<?> is.$$, TRUE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It compiles and evaluates to true whenever obj is any kind of List.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It compiles and evaluates to true only when obj is specifically a List<String>.$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It compiles and throws ClassCastException at the instanceof check.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Kod, `if (nesne instanceof List<Integer>) { ... }` yazmaya çalışıyor. Ne olur?$$,
           NULL, NULL,
           $$instanceof List<Integer> aynı nedenle derlenmez bile -- type erasure yüzünden karşılaştırılacak "bir Integer List'i" gibi bir çalışma zamanı bilgisi yoktur. Yalnızca raw instanceof List<?> geçerlidir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'type-erasure-and-generic-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenmez -- instanceof List<Integer> geçerli değildir; yalnızca instanceof List<?> geçerlidir.$$, TRUE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Derlenir ve nesne herhangi bir List türü olduğunda true değerlendirilir.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Derlenir ve yalnızca nesne özellikle bir List<Integer> olduğunda true değerlendirilir.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Derlenir ve instanceof kontrolünde ClassCastException fırlatır.$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$static <T> T createDefault(Supplier<T> factory) {
    return factory.get();
}

public class Demo {
    public static void main(String[] args) {
        String value = createDefault(String::new);
        System.out.println("[" + value + "]");
    }
}$$, $$java$$,
           $$Because of erasure, the JVM has no real class to call new T() on at runtime. The standard workaround: since only the CALLER knows what T is at that point, have the caller supply a Supplier<T> -- here String::new -- instead of the method trying to construct T itself. String::new produces an empty string.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'type-erasure-and-generic-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[]$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Compile error -- generic methods cannot accept a Supplier<T> parameter.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$[null]$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$NullPointerException.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$static <T> T varsayilanUret(Supplier<T> uretici) {
    return uretici.get();
}

public class Ornek {
    public static void main(String[] args) {
        ArrayList<Integer> liste = varsayilanUret(ArrayList::new);
        System.out.println(liste.size());
    }
}$$, $$java$$,
           $$Erasure yüzünden JVM'in çalışma zamanında new T() yapacağı gerçek bir sınıfı yoktur. Standart geçici çözüm: yalnızca ÇAĞIRAN o noktada T'nin ne olduğunu bildiği için, çağıranın bir Supplier<T> sağlamasıdır -- burada ArrayList::new, metodun kendisi T inşa etmeye çalışmak yerine. ArrayList::new boş bir liste üretir, size() 0 döner.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'type-erasure-and-generic-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$0$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Derleme hatası -- generic metotlar bir Supplier<T> parametresi kabul edemez.$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Derlenmez -- ArrayList::new, ArrayList<Integer> için geçerli bir Supplier değildir.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$NullPointerException.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$class Box<T> {
    void makeArray() {
        T[] items = new T[10];
    }
}$$, $$java$$,
           $$Unlike a List, a Java array remembers its element type at runtime -- but erasure means there's no real T to give an array at runtime either, so new T[10] doesn't compile. The workaround inside a generic class is to build a plain Object[] and cast it to T[] (with an "unchecked" warning), not to write new T[10] directly.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'type-erasure-and-generic-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It fails to compile -- new T[10] cannot create a generic array directly.$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It compiles and creates an array of 10 null references.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It compiles but throws NegativeArraySizeException at runtime.$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$It compiles, since T[] is treated as Object[10] automatically.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$class Yigin<T> {
    void diziOlustur() {
        T[] elemanlar = new T[5];
    }
}$$, $$java$$,
           $$Bir List'ten farklı olarak, bir Java array'i eleman türünü çalışma zamanında hatırlar -- ama erasure, bir array'e çalışma zamanında verilecek gerçek bir T de olmadığı anlamına gelir, bu yüzden new T[5] derlenmez. Generic bir sınıfın içindeki geçici çözüm, düz bir Object[] inşa edip onu T[]'e cast etmektir (bir "unchecked" uyarısıyla), doğrudan new T[5] yazmak değil.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'type-erasure-and-generic-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenmez -- new T[5], doğrudan generic bir array oluşturamaz.$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Derlenir ve 5 tane null referanstan oluşan bir array oluşturur.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Derlenir ama çalışma zamanında NegativeArraySizeException fırlatır.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Derlenir, çünkü T[], otomatik olarak Object[5] olarak ele alınır.$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$class Container<T> {
    private T value;
    static T sharedDefault;
}$$, $$java$$,
           $$A static field belongs to the class itself, shared across every instance -- but a class's type parameter is only known PER INSTANCE (Container<String> and Container<Integer> can coexist), so there's no single, consistent T a static member could refer to. This fails to compile.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'type-erasure-and-generic-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It fails to compile -- a static field cannot refer to the class's own type parameter T.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It compiles, and sharedDefault is shared across all Container<T> instances regardless of T.$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It compiles, with sharedDefault defaulting to null for every T.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It compiles only if Container declares exactly one instance across the whole program.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$class Kap<T> {
    private T deger;
    static void degeriYazdir(T deger) {
        System.out.println(deger);
    }
}$$, $$java$$,
           $$static bir metot, her instance arasında paylaşılan SINIFIN kendisine aittir -- ama bir sınıfın tür parametresi yalnızca instance başına bilinir (Kap<String> ve Kap<Integer> bir arada var olabilir), bu yüzden statik bir üyenin başvurabileceği tek, tutarlı bir T yoktur. Bu derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'type-erasure-and-generic-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenmez -- static bir metot, sınıfın kendi tür parametresi T'ye başvuramaz.$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Derlenir, ve degeriYazdir, T'den bağımsız olarak tüm Kap<T> instance'ları arasında paylaşılır.$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Derlenir, deger her T için varsayılan olarak null olur.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Derlenir, yalnızca Kap tüm program boyunca tam olarak bir instance bildirirse.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code runs?$$,
           $$static void pollute(List list) {
    list.add("oops");
}

public class Demo {
    public static void main(String[] args) {
        List<Integer> numbers = new ArrayList<>();
        numbers.add(1);
        pollute(numbers);
        for (Integer n : numbers) {
            System.out.println(n);
        }
    }
}$$, $$java$$,
           $$pollute(...) takes a raw List, so the compiler applies none of the type checking generics normally provide -- inserting a String into what's really a List<Integer> compiles fine. The failure doesn't happen at the insertion, though; it happens later, at the read, when the compiler-inserted cast to Integer finally runs and throws ClassCastException.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'type-erasure-and-generic-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It prints 1, then throws ClassCastException on the second element.$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It fails to compile -- pollute(list) cannot accept a List<Integer> argument.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It prints 1 then "oops" with no error.$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It throws ClassCastException immediately inside pollute(...).$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$static void kirlet(List liste) {
    liste.add("hata");
}

public class Ornek {
    public static void main(String[] args) {
        List<Double> degerler = new ArrayList<>();
        degerler.add(3.5);
        kirlet(degerler);
        for (Double d : degerler) {
            System.out.println(d);
        }
    }
}$$, $$java$$,
           $$kirlet(...), raw bir List alır, bu yüzden derleyici generics'in normalde sağladığı tür kontrolünün hiçbirini uygulamaz -- gerçekte bir List<Double> olan bir şeye bir String eklemek sorunsuz derlenir. Ama hata eklemede gerçekleşmez; daha sonra, okumada, derleyicinin eklediği Double'a cast sonunda çalışıp ClassCastException fırlattığında gerçekleşir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'type-erasure-and-generic-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$3.5 yazdırır, sonra ikinci elemanda ClassCastException fırlatır.$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Derlenmez -- kirlet(liste), bir List<Double> argümanını kabul edemez.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Hiçbir hata olmadan 3.5 sonra "hata" yazdırır.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$kirlet(...) içinde hemen ClassCastException fırlatır.$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Why did Java's designers choose type erasure when generics were introduced in Java 5?$$,
           NULL, NULL,
           $$An enormous amount of existing Java code and already-compiled .class files used raw types like List. Erasure was the design choice that let generic code interoperate with all of that pre-existing, non-generic code and bytecode without breaking it.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'type-erasure-and-generic-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$To let new generic code interoperate with pre-existing, non-generic code and already-compiled bytecode.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Because storing type information at runtime was technically impossible for the JVM.$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$To make generic code run faster than equivalent non-generic code.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Because erasure was required to support primitive type parameters like <int>.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Java'nın tasarımcıları, generics Java 5'te tanıtıldığında neden type erasure'ı seçti?$$,
           NULL, NULL,
           $$Mevcut Java kodunun ve zaten derlenmiş .class dosyalarının muazzam bir kısmı List gibi raw type'lar kullanıyordu. Erasure, generic kodun bu önceden var olan, generic olmayan kod ve bytecode ile onu bozmadan birlikte çalışmasına izin veren tasarım kararıydı.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'type-erasure-and-generic-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yeni generic kodun, önceden var olan generic olmayan kod ve zaten derlenmiş bytecode ile birlikte çalışmasına izin vermek için.$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Çünkü tür bilgisini çalışma zamanında saklamak JVM için teknik olarak imkânsızdı.$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Generic kodu eşdeğer generic olmayan koddan daha hızlı çalıştırmak için.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Çünkü erasure, <int> gibi primitif tür parametrelerini desteklemek için gerekliydi.$$, FALSE, 3 FROM new_question_tr7;
