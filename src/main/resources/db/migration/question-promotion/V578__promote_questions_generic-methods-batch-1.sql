-- Promotion batch
-- Topic: generic-methods (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V541 (records) through V569 (custom-exceptions),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/generic-methods.md and content/tr/generic-methods.md.
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
           $$Where does a generic method's type parameter appear in its declaration?$$,
           NULL, NULL,
           $$The type parameter appears once, in angle brackets, right before the return type -- static <T> T firstElement(...). It belongs to the method alone, independent of whether the enclosing class is generic.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generic-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$In angle brackets, right before the return type.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$In angle brackets, right after the method name.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It must match a type parameter already declared on the enclosing class.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$At the end of the parameter list, after the last parameter.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Generic bir metodun tür parametresi, metot bildiriminde nerede görünür?$$,
           NULL, NULL,
           $$Tür parametresi bir kez, açılı parantezler içinde, dönüş türünden hemen önce görünür -- static <T> T firstElement(...). Yalnızca metoda aittir, çevresindeki sınıfın generic olup olmamasından bağımsızdır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generic-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Açılı parantezler içinde, dönüş türünden hemen önce.$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Açılı parantezler içinde, metot adından hemen sonra.$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Çevreleyen sınıfta zaten bildirilmiş bir tür parametresiyle eşleşmelidir.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Parametre listesinin sonunda, son parametreden sonra.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Utils {
    static <T> T firstElement(List<T> list) {
        return list.get(0);
    }
}

public class Demo {
    public static void main(String[] args) {
        List<String> names = List.of("Zoe", "Amir");
        List<Integer> scores = List.of(90, 85);
        String first = Utils.firstElement(names);
        Integer topScore = Utils.firstElement(scores);
        System.out.println(first + " " + topScore);
    }
}$$, $$java$$,
           $$The compiler deduces T entirely from the argument passed at each call site -- Utils.firstElement(names) infers T as String, Utils.firstElement(scores) infers T as Integer, on the very same method.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generic-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Zoe 90$$, TRUE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Zoe Zoe$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Compile error -- firstElement's T is ambiguous across two calls.$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$90 Zoe$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Yardimci {
    static <T> T ilkEleman(List<T> liste) {
        return liste.get(0);
    }
}

public class Ornek {
    public static void main(String[] args) {
        List<String> isimler = List.of("Deniz", "Kaya");
        List<Integer> puanlar = List.of(75, 60);
        String ilkIsim = Yardimci.ilkEleman(isimler);
        Integer ilkPuan = Yardimci.ilkEleman(puanlar);
        System.out.println(ilkIsim + " " + ilkPuan);
    }
}$$, $$java$$,
           $$Derleyici, her çağrı noktasında geçirilen argümandan T'yi tamamen kendi başına çıkarır -- Yardimci.ilkEleman(isimler), T'yi String olarak çıkarırken, Yardimci.ilkEleman(puanlar), aynı metotta T'yi Integer olarak çıkarır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generic-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Deniz 75$$, TRUE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Deniz Deniz$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Derleme hatası -- ilkEleman'ın T'si iki çağrı arasında belirsizdir.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$75 Deniz$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is a "type witness" like `Utils.<String>firstElement(names)`?$$,
           NULL, NULL,
           $$A type witness is an explicit type argument supplied at a generic method's call site, overriding inference -- it's rarely needed in everyday code, only for the rare cases where the compiler can't infer the type on its own.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generic-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$An explicit type argument supplied at the call site, overriding inference -- rarely needed in everyday code.$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$A mandatory declaration required on every generic method call.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$A runtime check that verifies the inferred type matches the actual argument.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$A comment documenting what type a generic method is expected to receive.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`Yardimci.<String>ilkEleman(isimler)` gibi bir "tür tanığı" (type witness) nedir?$$,
           NULL, NULL,
           $$Tür tanığı, generic bir metodun çağrı noktasında sağlanan, çıkarımı geçersiz kılan açık bir tür argümanıdır -- günlük kodda nadiren gereklidir, yalnızca derleyicinin türü kendi başına çıkaramadığı nadir durumlar için vardır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generic-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çağrı noktasında sağlanan, çıkarımı geçersiz kılan açık bir tür argümanı -- günlük kodda nadiren gereklidir.$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Her generic metot çağrısında zorunlu olan bir bildirim.$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Çıkarılan türün gerçek argümanla eşleştiğini doğrulayan bir çalışma zamanı kontrolü.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Generic bir metodun hangi türü beklediğini belgeleyen bir yorum.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Utils {
    static <K, V> String describeEntry(K key, V value) {
        return key + " -> " + value;
    }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(Utils.describeEntry("age", 30));
        System.out.println(Utils.describeEntry(101, "order-created"));
    }
}$$, $$java$$,
           $$describeEntry(K key, V value) deduces K and V independently on every call -- describeEntry("age", 30) and describeEntry(101, "order-created") are both valid, unrelated uses of the same method, each with its own inferred type pair.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generic-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$age -> 30
101 -> order-created$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Compile error -- K and V must be the same type on every call.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$age -> 30
age -> 30$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Compile error -- describeEntry can only be called once per K/V pair.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Yardimci {
    static <A, B> String ciftiAcikla(A anahtar, B deger) {
        return anahtar + " -> " + deger;
    }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(Yardimci.ciftiAcikla("sehir", "Ankara"));
        System.out.println(Yardimci.ciftiAcikla(7, true));
    }
}$$, $$java$$,
           $$ciftiAcikla(A anahtar, B deger), her çağrıda A ve B'yi birbirinden bağımsız olarak çıkarır -- ciftiAcikla("sehir", "Ankara") ve ciftiAcikla(7, true), ikisi de aynı metodun geçerli, birbiriyle ilgisiz kullanımlarıdır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generic-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$sehir -> Ankara
7 -> true$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Derleme hatası -- A ve B her çağrıda aynı tür olmak zorundadır.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$sehir -> Ankara
sehir -> Ankara$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Derleme hatası -- ciftiAcikla her A/B çifti için yalnızca bir kez çağrılabilir.$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Container<T> {
    private T value;
    Container(T value) { this.value = value; }
    <U> String combineWith(U other) {
        return value + "+" + other;
    }
}

public class Demo {
    public static void main(String[] args) {
        Container<String> c = new Container<>("A");
        System.out.println(c.combineWith(42));
        System.out.println(c.combineWith(true));
    }
}$$, $$java$$,
           $$Container<T> fixes T as String once, for the whole instance. But combineWith's U is decided fresh on every call, completely independent of T -- the same Container<String> instance calls combineWith with an Integer, then a Boolean, and each call gets its own U.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generic-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A+42
A+true$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Compile error -- U must match T, which is String.$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$A+42
Compile error on the second call, U was already bound to Integer.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$42+A
true+A$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Kap<T> {
    private T deger;
    Kap(T deger) { this.deger = deger; }
    <U> String birlestir(U diger) {
        return deger + "+" + diger;
    }
}

public class Ornek {
    public static void main(String[] args) {
        Kap<String> k = new Kap<>("X");
        System.out.println(k.birlestir(5));
        System.out.println(k.birlestir(3.14));
    }
}$$, $$java$$,
           $$Kap<T>, T'yi bir kez, tüm instance için String olarak sabitler. Ama birlestir'in U'su her çağrıda yeni baştan belirlenir, T'den tamamen bağımsız olarak -- aynı Kap<String> instance'ı birlestir'i önce bir Integer, sonra bir Double ile çağırır, her çağrı kendi U'sunu alır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generic-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$X+5
X+3.14$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Derleme hatası -- U, String olan T ile eşleşmek zorundadır.$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$X+5
İkinci çağrıda derleme hatası, U zaten Integer'a bağlanmıştı.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$5+X
3.14+X$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$A method is written as `static T firstElement(List<T> list) { ... }`, without a `<T>` before the return type. What is the result?$$,
           NULL, NULL,
           $$Forgetting the <T> declaration before the return type -- writing static T firstElement(...) -- doesn't compile, since T would be an undeclared type with nothing introducing it.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generic-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It fails to compile -- T is undeclared, since the <T> before the return type was omitted.$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It compiles and behaves identically to static <T> T firstElement(List<T> list).$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It compiles, treating T as an alias for Object.$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It compiles but throws an exception on the first call.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir metot, dönüş türünden önce bir `<T>` olmadan `static T sonEleman(List<T> liste) { ... }` şeklinde yazılıyor. Sonuç ne olur?$$,
           NULL, NULL,
           $$Dönüş türünden önceki <T> bildirimini unutup static T sonEleman(...) yazmak derlenmez, çünkü T'yi tanıtan hiçbir şey olmadığı için bildirilmemiş bir tür olur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generic-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenmez -- dönüş türünden önceki <T> atlandığı için T bildirilmemiştir.$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Derlenir ve static <T> T sonEleman(List<T> liste) ile birebir aynı davranır.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Derlenir, T'yi Object'in bir takma adı olarak ele alır.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Derlenir ama ilk çağrıda bir exception fırlatır.$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are Best Practices recommended in this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Prefer a generic method over a generic class when the behavior belongs to a single operation, not a whole family of state; let type inference do its job and only reach for an explicit type witness when the compiler genuinely can't infer the type.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generic-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Prefer a generic method over a generic class when the behavior belongs to a single operation, not a whole family of state.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Let type inference do its job -- only use an explicit type witness when the compiler genuinely can't infer the type.$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Add a type witness to every generic method call to make the type parameter explicit.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Make an entire class generic whenever any one of its methods needs a type parameter.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre aşağıdakilerden hangileri önerilen Best Practices'tir? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Generic davranış bir sınıfın tutacağı bütün bir durum ailesine değil tek bir işleme aitse generic bir sınıf yerine generic bir metodu tercih et; tür çıkarımının işini yapmasına izin ver, derleyici gerçekten çıkaramadığında açık bir tür tanığına başvur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generic-methods'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Davranış bir durum ailesine değil tek bir işleme aitse, generic bir sınıf yerine generic bir metodu tercih et.$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Tür çıkarımının işini yapmasına izin ver -- derleyici gerçekten çıkaramadığında açık bir tür tanığı kullan.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Tür parametresini açık hale getirmek için her generic metot çağrısına bir tür tanığı ekle.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Metotlarından biri bir tür parametresine ihtiyaç duyduğunda tüm sınıfı generic yap.$$, FALSE, 3 FROM new_question_tr7;
