-- Promotion batch
-- Topic: wildcards (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V541 (records) through V569 (custom-exceptions),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/wildcards.md and content/tr/wildcards.md.
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

-- Pair 1 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Which statement correctly describes a wildcard (`?`) in Java generics?$$,
           NULL, NULL,
           $$A wildcard stands for an unknown type argument at a specific use of a generic type. Unlike a type parameter (T), a wildcard never gets a name and is never used to declare new generic classes or methods -- it only appears where a generic type is being used.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'wildcards'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It stands for an unknown type argument at a use site, and is never given a name or used to declare a new generic class or method.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It is a named type parameter that can be declared on a generic class.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It always means the same thing as Object as a type argument.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It can only be used inside a method's return type, never in a parameter type.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Java generics'te bir wildcard (`?`) için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$Bir wildcard, generic bir türün belirli bir kullanımında bilinmeyen bir tür argümanının yerini tutar. Bir tür parametresinden (T) farklı olarak, bir wildcard hiçbir zaman bir isim almaz ve yeni generic sınıflar ya da metotlar bildirmek için asla kullanılmaz -- yalnızca generic bir tür kullanılırken görünür.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'wildcards'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Generic bir türün bir kullanım noktasında bilinmeyen bir tür argümanının yerini tutar; asla bir isim almaz ya da yeni bir generic sınıf/metot bildirmek için kullanılmaz.$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Generic bir sınıf üzerinde bildirilebilen isimlendirilmiş bir tür parametresidir.$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir tür argümanı olarak her zaman Object ile aynı anlama gelir.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca bir metodun dönüş türünde kullanılabilir, parametre türünde asla kullanılamaz.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$static double sumNumbers(List<Number> numbers) {
    double total = 0;
    for (Number n : numbers) total += n.doubleValue();
    return total;
}

public class Demo {
    public static void main(String[] args) {
        List<Integer> ints = List.of(1, 2, 3);
        System.out.println(sumNumbers(ints));
    }
}$$, $$java$$,
           $$Java generics are invariant: even though Integer IS-A Number, List<Integer> is NOT a List<Number> -- they're treated as two completely unrelated types. sumNumbers(List<Number> numbers) only accepts a parameter that is exactly List<Number>, so passing a List<Integer> is rejected outright.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'wildcards'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It fails to compile -- List<Integer> is not a List<Number>, even though Integer IS-A Number.$$, TRUE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It compiles and prints 6.0.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It compiles but throws ClassCastException at runtime.$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It compiles and prints 0.0, since the elements can't be widened.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$static double sayilariTopla(List<Number> sayilar) {
    double toplam = 0;
    for (Number n : sayilar) toplam += n.doubleValue();
    return toplam;
}

public class Ornek {
    public static void main(String[] args) {
        List<Double> ondaliklar = List.of(1.5, 2.5);
        System.out.println(sayilariTopla(ondaliklar));
    }
}$$, $$java$$,
           $$Java generics değişmezdir: Double bir Number OLSA bile, List<Double>, bir List<Number> DEĞİLDİR -- ikisi tamamen ilgisiz iki tür olarak ele alınır. sayilariTopla(List<Number> sayilar), yalnızca tam olarak List<Number> olan bir parametreyi kabul eder, bu yüzden bir List<Double> geçirmek doğrudan reddedilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'wildcards'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenmez -- List<Double>, Double bir Number OLSA bile bir List<Number> değildir.$$, TRUE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Derlenir ve 4.0 yazdırır.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Derlenir ama çalışma zamanında ClassCastException fırlatır.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Derlenir ve elemanlar genişletilemediği için 0.0 yazdırır.$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A method accepts a `List<?>` parameter and calls `.size()` on it, then tries `.add("new element")` on the same parameter. What happens?$$,
           NULL, NULL,
           $$Plain <?> allows neither a meaningful get beyond Object nor any add at all -- the compiler has no way to know the list's real element type, so the add(...) call is rejected, even though size() compiles fine.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'wildcards'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The add(...) call fails to compile, since the compiler has no way to know the list's real element type.$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Both calls compile -- List<?> behaves exactly like List<Object> for writing.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Both calls fail to compile, since size() also requires a known element type.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The add(...) call compiles but silently does nothing at runtime.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir metot bir `List<?>` parametresi kabul ediyor, üzerinde `.size()` çağırıyor, sonra aynı parametre üzerinde `.add("yeni eleman")` çağırmayı deniyor. Ne olur?$$,
           NULL, NULL,
           $$Düz <?>, ne Object'in ötesinde anlamlı bir get'e ne de herhangi bir add'e izin verir -- derleyicinin listenin gerçek eleman türünü bilmesinin bir yolu yoktur, bu yüzden add(...) çağrısı reddedilir, size() ise sorunsuz derlenir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'wildcards'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$add(...) çağrısı derlenmez, çünkü derleyicinin listenin gerçek eleman türünü bilmesinin bir yolu yoktur.$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Her iki çağrı da derlenir -- List<?>, yazma açısından List<Object> gibi davranır.$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Her iki çağrı da derlenmez, çünkü size() de bilinen bir eleman türü gerektirir.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$add(...) çağrısı derlenir ama çalışma zamanında sessizce hiçbir şey yapmaz.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$static double sum(List<? extends Number> numbers) {
    double total = 0;
    for (Number n : numbers) total += n.doubleValue();
    numbers.add(5);
    return total;
}$$, $$java$$,
           $$List<? extends Number> only ever lets you READ safely (every element is guaranteed to be at least a Number). What ISN'T safe is adding: the compiler has no way to know the list's real element type (it could specifically be a List<Double>), so numbers.add(5) is rejected.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'wildcards'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It fails to compile -- numbers.add(5) is not allowed on a List<? extends Number>.$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It compiles and returns the sum, having also appended 5 to the list.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It compiles only when the caller passes a List<Integer> specifically.$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$It compiles but add(5) throws ClassCastException at runtime.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$static double ortalamaHesapla(List<? extends Number> sayilar) {
    double toplam = 0;
    for (Number n : sayilar) toplam += n.doubleValue();
    sayilar.add(1);
    return toplam / sayilar.size();
}$$, $$java$$,
           $$List<? extends Number>, yalnızca GÜVENLİ bir şekilde okumana izin verir (her eleman en azından bir Number olmayı garanti eder). GÜVENLİ OLMAYAN şey eklemektir: derleyicinin listenin gerçek eleman türünü bilmesinin bir yolu yoktur (özellikle bir List<Double> olabilir), bu yüzden sayilar.add(1) reddedilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'wildcards'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenmez -- sayilar.add(1), bir List<? extends Number> üzerinde izin verilmez.$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Derlenir ve listeye 1'i de ekleyip ortalamayı döner.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca çağıran özellikle bir List<Integer> geçirirse derlenir.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Derlenir ama add(1) çalışma zamanında ClassCastException fırlatır.$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$static void addOneToFive(List<? super Integer> list) {
    for (int i = 1; i <= 5; i++) list.add(i);
    Integer first = list.get(0);
}$$, $$java$$,
           $$List<? super Integer> lets you WRITE an Integer safely, no matter which supertype of Integer the list actually holds. What ISN'T safe is reading a specific type back out: the compiler only guarantees the list holds SOME supertype of Integer, which could be as broad as Object, so list.get(0) can only be treated as Object -- assigning it directly to an Integer variable fails to compile.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'wildcards'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It fails to compile -- list.get(0) returns Object, which can't be assigned directly to an Integer variable.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It compiles and assigns 1 to first.$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It fails to compile at list.add(i) instead, since the list's real type is unknown.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It compiles but throws ClassCastException when get(0) is called.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$static void ikidenOnaEkle(List<? super Integer> liste) {
    for (int i = 2; i <= 10; i += 2) liste.add(i);
    Integer ilk = liste.get(0);
}$$, $$java$$,
           $$List<? super Integer>, liste gerçekte Integer'ın hangi süper türünü tutuyor olursa olsun bir Integer'ı GÜVENLİ bir şekilde yazmana izin verir. GÜVENLİ OLMAYAN şey belirli bir türü geri okumaktır: derleyici yalnızca listenin Integer'ın BİR süper türünü tuttuğunu garanti eder, bu Object kadar geniş olabilir, bu yüzden liste.get(0) yalnızca Object olarak ele alınabilir -- doğrudan bir Integer değişkenine atamak derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'wildcards'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenmez -- liste.get(0), Object döner, bu doğrudan bir Integer değişkenine atanamaz.$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Derlenir ve ilk'e 2 atar.$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Bunun yerine liste.add(i) satırında derlenmez, çünkü listenin gerçek türü bilinmez.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Derlenir ama get(0) çağrıldığında ClassCastException fırlatır.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A method only ever WRITES elements into a `List<T>` parameter and never reads from it. According to PECS, which wildcard form should it use?$$,
           NULL, NULL,
           $$PECS: "Producer Extends, Consumer Super." If a parameterized type only CONSUMES values from you (you only write into it), use super -- exactly the role addOneToFive(...) plays.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'wildcards'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$List<? super T> -- it's a consumer, so super applies.$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$List<? extends T> -- it's a producer, so extends applies.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$List<?> -- an unbounded wildcard, since the method never reads.$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$List<T> with no wildcard at all, since PECS never applies to write-only parameters.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir metot bir `List<T>` parametresine yalnızca eleman YAZAR, hiçbir zaman ondan okumaz. PECS'e göre hangi wildcard formunu kullanmalı?$$,
           NULL, NULL,
           $$PECS: "Producer Extends, Consumer Super." Parametrelenmiş bir tür yalnızca senden değer TÜKETİYORSA (yalnızca ona yazıyorsan), super kullan -- tam olarak addOneToFive(...)'ın oynadığı rol.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'wildcards'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$List<? super T> -- bir tüketicidir, bu yüzden super uygulanır.$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$List<? extends T> -- bir üreticidir, bu yüzden extends uygulanır.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$List<?> -- sınırsız bir wildcard, çünkü metot hiç okumaz.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Hiç wildcard olmadan List<T>, çünkü PECS yalnızca-yazan parametrelere hiç uygulanmaz.$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about wildcard usage, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$copy(List<? extends T> src, List<? super T> dest) needs both roles at once: src is a producer (extends), dest is a consumer (super). A wildcard should never appear on a return type -- it forces every caller to deal with an unknown type, with none of PECS's benefit.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'wildcards'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A method that both reads from one list and writes into another can use extends for the source and super for the destination.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A wildcard should never be added to a method's return type.$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$List<? super T> can be used to reliably read a specific T back out of the list.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$If a parameter needs both reading and writing of the same specific type, a wildcard is still the right tool.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre wildcard kullanımıyla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$copy(List<? extends T> src, List<? super T> dest), AYNI ANDA HER İKİ role de ihtiyaç duyar: src bir üreticidir (extends), dest bir tüketicidir (super). Bir wildcard bir dönüş türüne asla eklenmemelidir -- her çağıranı bilinmeyen bir türle uğraşmaya zorlar, PECS'in hiçbir faydası olmadan.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'wildcards'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir listeden okuyup başka bir listeye yazan bir metot, kaynak için extends, hedef için super kullanabilir.$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir wildcard bir metodun dönüş türüne asla eklenmemelidir.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$List<? super T>, listeden belirli bir T'yi güvenilir biçimde geri okumak için kullanılabilir.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir parametrenin aynı belirli türle hem okunması hem yazılması gerekiyorsa, wildcard yine de doğru araçtır.$$, FALSE, 3 FROM new_question_tr7;
