-- Promotion batch
-- Topic: polymorphism (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V599-V611 (collections) and V574-V594 (generics),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/polymorphism.md and content/tr/polymorphism.md.
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
           $$Which statement correctly distinguishes compile-time polymorphism from runtime polymorphism?$$,
           NULL, NULL,
           $$Compile-time polymorphism (overloading) is resolved by the compiler from the argument types at the call site; runtime polymorphism (overriding) is resolved by the JVM based on the object's actual type.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'polymorphism'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Compile-time polymorphism (overloading) is resolved by argument types at compile time; runtime polymorphism (overriding) is resolved by the object's actual type at runtime.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Compile-time polymorphism is resolved by the object's actual type; runtime polymorphism is resolved by argument types.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Both are resolved entirely at runtime, just through different mechanisms.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Both are resolved entirely at compile time, just through different mechanisms.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Compile-time polymorphism ile runtime polymorphism arasındaki fark için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$Compile-time polymorphism (overloading), derleyici tarafından çağrı noktasındaki argüman tiplerinden çözümlenir; runtime polymorphism (overriding) ise JVM tarafından nesnenin gerçek tipine göre çözümlenir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'polymorphism'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İkisi de farklı mekanizmalarla olsa da tamamen derleme zamanında çözümlenir.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Compile-time polymorphism (overloading), derleme zamanında argüman tiplerinden çözümlenir; runtime polymorphism (overriding), çalışma zamanında nesnenin gerçek tipinden çözümlenir.$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Compile-time polymorphism nesnenin gerçek tipine göre çözümlenir; runtime polymorphism argüman tiplerine göre.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$İkisi de farklı mekanizmalarla olsa da tamamen çalışma zamanında çözümlenir.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Calc {
    int add(int a, int b) { return a + b; }
    double add(double a, double b) { return a + b; }
}

public class Demo {
    public static void main(String[] args) {
        Calc c = new Calc();
        System.out.println(c.add(2, 3));
        System.out.println(c.add(2.0, 3.0));
    }
}$$, $$java$$,
           $$The compiler picks the overload by looking at the number and type of arguments given at the call site -- add(2, 3) matches the int overload, add(2.0, 3.0) matches the double overload.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'polymorphism'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$5
5$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Compile error -- add is ambiguous.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$5
5.0$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$5.0
5.0$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Hesapla {
    int topla(int a, int b) { return a + b; }
    double topla(double a, double b) { return a + b; }
}

public class Ornek {
    public static void main(String[] args) {
        Hesapla h = new Hesapla();
        System.out.println(h.topla(4, 6));
        System.out.println(h.topla(4.5, 5.5));
    }
}$$, $$java$$,
           $$Derleyici, çağrı noktasında verilen argümanların sayısına ve tipine bakarak overload'ı seçer -- topla(4, 6), int overload'ı ile eşleşir, topla(4.5, 5.5) ise double overload'ı ile eşleşir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'polymorphism'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$10.0
10.0$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$10
10$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Derleme hatası -- topla belirsizdir.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$10
10.0$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Utils {
    static String process(long x) { return "long"; }
    static String process(Integer x) { return "Integer"; }
    static String process(int... x) { return "varargs"; }
}

public class Demo {
    public static void main(String[] args) {
        short s = 5;
        System.out.println(Utils.process(s));
    }
}$$, $$java$$,
           $$The compiler tries an exact match first (none exists for short), then widening -- short widens directly to long, so process(long) applies. Integer requires autoboxing (a later phase, and short doesn't box to Integer anyway), and varargs is only tried as a last resort, so widening wins.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'polymorphism'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$long$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Integer$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$varargs$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Compile error -- the call is ambiguous.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Yardimci {
    static String isle(long x) { return "long"; }
    static String isle(Integer x) { return "Integer"; }
    static String isle(int... x) { return "varargs"; }
}

public class Ornek {
    public static void main(String[] args) {
        int i = 7;
        System.out.println(Yardimci.isle(i));
    }
}$$, $$java$$,
           $$Derleyici önce tam eşleşmeyi dener (int için yok), sonra widening'i -- int, doğrudan long'a genişler, bu yüzden isle(long) uygulanabilir. Widening, autoboxing'den (isle(Integer)) önce denendiği için isle(long) kazanır; varargs ise yalnızca son çare olarak denenir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'polymorphism'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme hatası -- çağrı belirsizdir.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$long$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Integer$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$varargs$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Animal {
    Animal reproduce() { return new Animal(); }
}

class Dog extends Animal {
    @Override
    Dog reproduce() { return new Dog(); }
}

public class Demo {
    public static void main(String[] args) {
        Dog d = new Dog();
        Dog puppy = d.reproduce();
        System.out.println(puppy.getClass().getSimpleName());
    }
}$$, $$java$$,
           $$An overriding method is allowed to return a subtype of what the superclass method returns -- Dog's reproduce() returns Dog instead of Animal, a legal covariant return type, so puppy can be assigned directly with no cast.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'polymorphism'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Compile error -- reproduce()'s return type must exactly match Animal.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Compile error -- puppy must be declared as Animal, not Dog.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Dog$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Animal$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Hayvan {
    Hayvan uret() { return new Hayvan(); }
}

class Kedi extends Hayvan {
    @Override
    Kedi uret() { return new Kedi(); }
}

public class Ornek {
    public static void main(String[] args) {
        Kedi k = new Kedi();
        Kedi yavru = k.uret();
        System.out.println(yavru.getClass().getSimpleName());
    }
}$$, $$java$$,
           $$Override eden bir metot, üst sınıf metodunun döndürdüğünün bir alt türünü döndürebilir -- Kedi'nin uret()'i Hayvan yerine Kedi döner, geçerli bir covariant return type'tır, bu yüzden yavru hiçbir cast gerekmeden doğrudan atanabilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'polymorphism'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayvan$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Derleme hatası -- uret()'in dönüş tipi tam olarak Hayvan ile eşleşmelidir.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Derleme hatası -- yavru, Kedi değil Hayvan olarak bildirilmelidir.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Kedi$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about the relationship between inheritance and polymorphism? (Select all that apply)$$,
           NULL, NULL,
           $$Inheritance is a structural relationship; polymorphism is a runtime behavior -- inheritance makes polymorphism possible but doesn't guarantee it. If a subclass never overrides an inherited method, calling that method produces no real polymorphism.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'polymorphism'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Inheritance is a structural relationship; polymorphism is a runtime behavior -- inheritance makes polymorphism possible but doesn't guarantee it.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$If a subclass never overrides any inherited method, calling that method on the subclass produces no real polymorphism.$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Polymorphism can only occur when a class hierarchy built with extends is involved.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Every subclass automatically exhibits polymorphic behavior for every method it inherits.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Kalıtım ile polimorfizm arasındaki ilişki hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Kalıtım yapısal bir ilişkidir; polimorfizm ise çalışma zamanı davranışıdır -- kalıtım polimorfizmi mümkün kılar ama garanti etmez. Bir alt sınıf miras aldığı bir metodu hiç override etmiyorsa, o metodu çağırmak gerçek bir polimorfizm üretmez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'polymorphism'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her alt sınıf, miras aldığı her metot için otomatik olarak polimorfik davranış sergiler.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Kalıtım yapısal bir ilişkidir; polimorfizm ise çalışma zamanı davranışıdır -- kalıtım polimorfizmi mümkün kılar ama garanti etmez.$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir alt sınıf miras aldığı hiçbir metodu override etmiyorsa, o metodu alt sınıf üzerinden çağırmak gerçek bir polimorfizm üretmez.$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Polimorfizm yalnızca extends ile kurulan bir sınıf hiyerarşisi söz konusu olduğunda gerçekleşebilir.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$interface Formatter {
    String format(String s);
}

class Document {
    private Formatter formatter;
    Document(Formatter formatter) { this.formatter = formatter; }
    void setFormatter(Formatter formatter) { this.formatter = formatter; }
    String render(String s) { return formatter.format(s); }
}

public class Demo {
    public static void main(String[] args) {
        Document doc = new Document(s -> s.toUpperCase());
        System.out.println(doc.render("hello"));
        doc.setFormatter(s -> "[" + s + "]");
        System.out.println(doc.render("hello"));
    }
}$$, $$java$$,
           $$Document holds a Formatter reference rather than extending one (composition) -- setFormatter(...) swaps the behavior at runtime, something inheritance could never do since an object's class can't change after construction.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'polymorphism'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[hello]
[hello]$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Compile error -- Document can't change its formatter after construction.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$HELLO
[hello]$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$HELLO
HELLO$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$interface Bicimlendirici {
    String bicimlendir(String s);
}

class Belge {
    private Bicimlendirici bicimlendirici;
    Belge(Bicimlendirici b) { this.bicimlendirici = b; }
    void bicimlendiriciyiDegistir(Bicimlendirici b) { this.bicimlendirici = b; }
    String goster(String s) { return bicimlendirici.bicimlendir(s); }
}

public class Ornek {
    public static void main(String[] args) {
        Belge belge = new Belge(s -> s.toLowerCase());
        System.out.println(belge.goster("MERHABA"));
        belge.bicimlendiriciyiDegistir(s -> "<" + s + ">");
        System.out.println(belge.goster("MERHABA"));
    }
}$$, $$java$$,
           $$Belge, bir Bicimlendirici'yi extend etmek yerine referans olarak tutar (composition) -- bicimlendiriciyiDegistir(...), davranışı çalışma zamanında değiştirir, bu kalıtımın asla yapamayacağı bir şeydir çünkü bir nesnenin sınıfı oluşturulduktan sonra değişemez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'polymorphism'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$merhaba
merhaba$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$<MERHABA>
<MERHABA>$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Derleme hatası -- Belge, oluşturulduktan sonra bicimlendiricisini değiştiremez.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$merhaba
<MERHABA>$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what does a growing chain of `if (obj instanceof TypeA) {...} else if (obj instanceof TypeB) {...}` usually indicate?$$,
           NULL, NULL,
           $$If you see a chain of instanceof checks growing with every new type, that's usually a sign polymorphism isn't being used -- in a well-designed system, calling code never asks "what type is this?", it just calls the polymorphic method directly.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'polymorphism'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A sign that polymorphism isn't being used -- a well-designed system would let calling code invoke a polymorphic method directly instead of checking types.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A necessary and idiomatic pattern that should be used whenever multiple related types exist.$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$That the types involved don't share a common interface and never could.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$That the code is already using polymorphism correctly.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, giderek büyüyen bir `if (obj instanceof TipA) {...} else if (obj instanceof TipB) {...}` zinciri genellikle neyin işaretidir?$$,
           NULL, NULL,
           $$Her yeni tür eklendikçe büyüyen bir instanceof kontrol zinciri görüyorsan, bu genellikle polimorfizmin kullanılmadığının bir işaretidir -- iyi tasarlanmış bir sistemde çağıran kod hiçbir zaman "bu hangi tür?" diye sormaz, doğrudan polimorfik metodu çağırır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'polymorphism'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Kodun zaten polimorfizmi doğru kullandığının işareti.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Polimorfizmin kullanılmadığının bir işareti -- iyi tasarlanmış bir sistemde çağıran kod, tür kontrolü yapmak yerine doğrudan polimorfik bir metot çağırır.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Birden fazla ilgili tür var olduğunda her zaman kullanılması gereken, gerekli ve deyimsel bir desen.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$İlgili türlerin ortak bir interface'i paylaşmadığının ve asla paylaşamayacağının işareti.$$, FALSE, 3 FROM new_question_tr7;
