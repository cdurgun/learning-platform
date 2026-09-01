-- Promotion batch
-- Topic: reflection (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V537 (file-writing), V541 (records), these 14
-- questions were NOT produced by the n8n generation pipeline, NOT judged by
-- the AI Judge, and NOT ingested via /api/internal/questions/ingest -- per
-- explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/reflection.md and content/tr/reflection.md.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same Reflection concept,
-- but independently authored (different classes/fields/methods, different
-- question framing) rather than a translation. The 7 concepts: Class object
-- identity (all lookup methods return the same instance), the
-- getFields()/getDeclaredFields() axis, getMethods() including Object's
-- inherited methods, why Class.newInstance() is deprecated,
-- InvocationTargetException wrapping, setAccessible()/IllegalAccessException,
-- and the @Retention(RUNTIME) requirement for reading annotations.
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly -- same documentation convention as prior manual
-- batches. topic_id resolved by Topic.slug; question_option rows reference
-- the newly generated id via a WITH ... RETURNING id CTE.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these 14 questions at all.

-- Pair 1 / EN (CODE_OUTPUT, INTERMEDIATE) -- Class object identity
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What will this code print?$$,
           $$Class<?> a = "hello".getClass();
Class<?> b = String.class;
System.out.println(a == b);$$, $$java$$,
           $$The JVM keeps only one Class instance per class, per classloader -- obj.getClass() and Type.class always return the exact same object, so a == b is true even without calling equals().$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'reflection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$true$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$false$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It throws an exception.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$The result is unpredictable across runs.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (CODE_OUTPUT, INTERMEDIATE) -- same concept, Integer instead of String
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Class<?> a = Integer.valueOf(5).getClass();
Class<?> b = Integer.class;
System.out.println(a == b);$$, $$java$$,
           $$JVM, her sınıf/classloader çifti için yalnızca bir tane Class örneği tutar -- obj.getClass() ve Tip.class her zaman aynı nesneyi döner, bu yüzden equals() çağırmadan bile a == b true olur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'reflection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$true$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$false$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir istisna fırlatır.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Sonuç her çalıştırmada farklı olabilir.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (MULTIPLE_CHOICE, INTERMEDIATE) -- getFields()/getDeclaredFields() axis
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about getFields() and getDeclaredFields() are true?$$, NULL, NULL,
           $$getFields() returns only public fields (including inherited ones); getDeclaredFields() returns only fields declared in that class itself, regardless of access modifier, but never inherited ones. The two methods behave as opposites along the public/inherited axes.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'reflection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$getFields() returns only public fields, including those inherited from superclasses.$$, TRUE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$getDeclaredFields() returns only fields declared in that class itself, regardless of access modifier.$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$getDeclaredFields() includes fields inherited from a superclass.$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$getFields() includes private fields defined in the class itself.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (MULTIPLE_CHOICE, INTERMEDIATE) -- same 4 facts, reordered/rephrased independently
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$getFields() ve getDeclaredFields() hakkında aşağıdaki ifadelerden hangileri doğrudur?$$, NULL, NULL,
           $$getDeclaredFields(), erişim belirleyicisi ne olursa olsun yalnızca o sınıfın kendi alanlarını döner; getFields() ise üst sınıflardan miras alınanlar dahil yalnızca public alanları döner. İki metot da miras/erişim eksenlerinde birbirinin tersi davranır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'reflection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$getDeclaredFields(), erişim belirleyicisi ne olursa olsun, yalnızca o sınıfın kendi içinde tanımlanan alanları döner.$$, TRUE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$getFields(), üst sınıflardan miras alınanlar dahil, yalnızca public alanları döner.$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$getFields(), sınıfın kendi private alanlarını da içerir.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$getDeclaredFields(), üst sınıftan miras alınan alanları da içerir.$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE) -- getMethods() includes Object's inherited methods
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does getMethods() on a simple, method-less custom class still return a non-empty array?$$, NULL, NULL,
           $$getMethods() returns a class's public methods, including those inherited from Object such as toString(), equals(), and hashCode() -- which is why the list turns out bigger than expected even for a simple class.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'reflection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because getMethods() includes public methods inherited from Object, such as toString(), equals(), and hashCode().$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Because every class automatically gets synthetic accessor methods generated by the compiler.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Because getMethods() always throws unless at least one method is found.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Because Java requires every class to declare at least one public method.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE) -- same fact, reverse "empty class" framing
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Hiçbir metot tanımlamayan boş bir sınıf üzerinde getMethods() çağırdığınızda neden boş olmayan bir dizi dönmesi beklenir?$$, NULL, NULL,
           $$getMethods(), Object sınıfından miras alınan toString(), equals(), hashCode() gibi public metotları da içerir -- bu yüzden basit bir sınıf için bile liste beklenenden büyük çıkar.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'reflection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü getMethods(), Object sınıfından miras alınan toString(), equals(), hashCode() gibi public metotları da içerir.$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü derleyici her sınıf için otomatik olarak sentetik accessor metotları üretir.$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü getMethods(), hiç metot bulunamazsa hata fırlatır.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü Java her sınıfın en az bir public metot tanımlamasını zorunlu kılar.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, ADVANCED) -- why Class.newInstance() is deprecated
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Why is the parameterless Class.newInstance() deprecated in favor of getDeclaredConstructor(...).newInstance()?$$, NULL, NULL,
           $$Class.newInstance() throws the constructor's checked exceptions directly, unwrapped, bypassing the compiler's checked-exception checking, and it enforces access control on private/protected constructors less consistently than Constructor.newInstance().$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'reflection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It throws the constructor's checked exceptions directly, unwrapped, bypassing the compiler's checked-exception checking, and it enforces access control less consistently.$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It is slower than Constructor.newInstance() by a significant margin.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It cannot create objects of classes with a package-private constructor.$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$It was removed entirely in Java 9 and no longer compiles.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, ADVANCED) -- same two reasons, "gerekçeleri arasında" framing
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Class.newInstance() metodunun Java 9'dan beri deprecated olmasının gerekçeleri arasında aşağıdakilerden hangisi yer alır?$$, NULL, NULL,
           $$Class.newInstance(), constructor'ın checked exception'larını sarmalamadan doğrudan fırlatır (derleyicinin checked-exception kontrolünü atlar) ve private/protected constructor'lar için erişim kontrolünü Constructor.newInstance() kadar tutarlı uygulamaz.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'reflection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Constructor'ın checked exception'larını sarmalamadan doğrudan fırlatır ve private/protected constructor'lar için erişim kontrolünü Constructor.newInstance() kadar tutarlı uygulamaz.$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Constructor.newInstance()'a göre önemli ölçüde daha yavaştır.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Package-private constructor'a sahip sınıflar için nesne oluşturamaz.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Java 9'da tamamen kaldırılmıştır, artık derlenmez.$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, ADVANCED) -- InvocationTargetException wrapping
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What will this code print?$$,
           $$class Calculator {
    public int divide(int a, int b) {
        return a / b;
    }
}

Method m = Calculator.class.getMethod("divide", int.class, int.class);
try {
    m.invoke(new Calculator(), 10, 0);
} catch (ArithmeticException e) {
    System.out.println("caught ArithmeticException");
} catch (java.lang.reflect.InvocationTargetException e) {
    System.out.println("caught InvocationTargetException");
}$$, $$java$$,
           $$Method.invoke() never lets the invoked method's own exception escape directly -- it always wraps it in an InvocationTargetException. The ArithmeticException thrown inside divide() does not match the first catch clause, so it falls to the InvocationTargetException catch.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'reflection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$caught ArithmeticException$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$caught InvocationTargetException$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The program crashes with an uncaught exception.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Both messages are printed.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, ADVANCED) -- same mechanic, Bolucu/bol instead of Calculator/divide
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Bolucu {
    public int bol(int a, int b) {
        return a / b;
    }
}

Method m = Bolucu.class.getMethod("bol", int.class, int.class);
try {
    m.invoke(new Bolucu(), 20, 0);
} catch (ArithmeticException e) {
    System.out.println("ArithmeticException yakalandi");
} catch (java.lang.reflect.InvocationTargetException e) {
    System.out.println("InvocationTargetException yakalandi");
}$$, $$java$$,
           $$Method.invoke(), çağrılan metodun kendi istisnasının doğrudan dışarı sızmasına asla izin vermez -- her zaman InvocationTargetException içine sarmalar. bol() içinde fırlatılan ArithmeticException ilk catch bloğuyla eşleşmez, bu yüzden InvocationTargetException catch bloğuna düşer.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'reflection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ArithmeticException yakalandi$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$InvocationTargetException yakalandi$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Program yakalanmamış bir istisnayla çöker.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Her iki mesaj da yazdırılır.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, ADVANCED) -- setAccessible()/IllegalAccessException
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What will this code print? (Assume no setAccessible(true) call is made.)$$,
           $$class Secret {
    private String code = "1234";
}

Field f = Secret.class.getDeclaredField("code");
try {
    Object value = f.get(new Secret());
    System.out.println(value);
} catch (IllegalAccessException e) {
    System.out.println("access denied");
}$$, $$java$$,
           $$Without calling setAccessible(true) first, reading a private field via reflection throws IllegalAccessException -- forgetting this call is one of the most common reflection mistakes.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'reflection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$1234$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$access denied$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$The program crashes with an uncaught exception.$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$null$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, ADVANCED) -- same mechanic, Gizli/kod instead of Secret/code
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır? (setAccessible(true) çağrısı yapılmadığını varsayın.)$$,
           $$class Gizli {
    private String kod = "9876";
}

Field f = Gizli.class.getDeclaredField("kod");
try {
    Object deger = f.get(new Gizli());
    System.out.println(deger);
} catch (IllegalAccessException e) {
    System.out.println("erisim reddedildi");
}$$, $$java$$,
           $$Önce setAccessible(true) çağrılmadan, private bir alanı reflection ile okumak IllegalAccessException fırlatır -- bu çağrıyı unutmak en yaygın reflection hatalarından biridir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'reflection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$9876$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$erisim reddedildi$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Program yakalanmamış bir istisnayla çöker.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$null$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, INTERMEDIATE) -- @Retention(RUNTIME) requirement
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$You define a custom annotation but forget to add @Retention(RetentionPolicy.RUNTIME) (leaving the default). What happens when you call isAnnotationPresent() for it via reflection at runtime?$$, NULL, NULL,
           $$The code compiles and runs fine -- the annotation "looks like it's there" in the source -- but isAnnotationPresent() always returns false, because the annotation's retention doesn't survive to runtime by default.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'reflection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The code compiles and runs, but isAnnotationPresent() always returns false -- the annotation is invisible to reflection.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A compile error occurs, since every annotation must specify @Retention explicitly.$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$isAnnotationPresent() throws a RuntimeException because the annotation lacks retention metadata.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$isAnnotationPresent() returns true, since annotations are visible to reflection by default.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, INTERMEDIATE) -- reverse "debug the symptom" framing
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir annotation'ı reflection ile okumaya çalıştığınızda isAnnotationPresent() her zaman false dönüyor, ama kod hatasız derleniyor ve annotation kaynak kodda görünüyor. Bunun en olası nedeni nedir?$$, NULL, NULL,
           $$Annotation tanımında @Retention(RetentionPolicy.RUNTIME) eksik (ya da varsayılan CLASS düzeyinde bırakılmış) -- bu yüzden annotation derlenmiş sınıf dosyasında kalsa da JVM çalışırken reflection'a görünmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'reflection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Annotation tanımında @Retention(RetentionPolicy.RUNTIME) eksik (ya da varsayılan CLASS düzeyinde bırakılmış).$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$isAnnotationPresent() metodu yanlış çağrılmıştır, parametre sırası ters.$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Annotation'ın hedef (target) tipi yanlış tanımlanmıştır.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Reflection API'si yalnızca sınıf düzeyinde annotation okuyabilir, metot düzeyinde okuyamaz.$$, FALSE, 3 FROM new_question_tr7;
