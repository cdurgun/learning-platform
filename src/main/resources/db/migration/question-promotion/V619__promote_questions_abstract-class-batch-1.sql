-- Promotion batch
-- Topic: abstract-class (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V599-V611 (collections) and V574-V594 (generics),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/abstract-class.md and content/tr/abstract-class.md.
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

-- Pair 1 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$abstract class Shape {
    double area() { return 0.0; }
}

public class Demo {
    public static void main(String[] args) {
        Shape s = new Shape();
    }
}$$, $$java$$,
           $$What decides whether a class can be instantiated directly is not whether it has an abstract method, but whether the class itself is marked abstract. Shape has zero abstract methods, yet new Shape() still fails to compile.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'abstract-class'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It fails to compile -- Shape is abstract, so it can never be instantiated directly, regardless of whether it has abstract methods.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It compiles and runs fine, since Shape has no abstract methods.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It compiles but throws InstantiationException at runtime.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It compiles because area() has a full body.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$abstract class Sekil {
    double alan() { return 0.0; }
}

public class Ornek {
    public static void main(String[] args) {
        Sekil s = new Sekil();
    }
}$$, $$java$$,
           $$Bir sınıfın doğrudan örneklenip örneklenemeyeceğine karar veren şey, bir abstract metoda sahip olup olmadığı değil, sınıfın kendisinin abstract işaretlenip işaretlenmediğidir. Sekil'in hiç abstract metodu yok, ama new Sekil() yine de derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'abstract-class'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenir çünkü alan()'ın tam bir gövdesi var.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Derlenmez -- Sekil abstract'tır, bu yüzden abstract metodu olsun ya da olmasın asla doğrudan örneklenemez.$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Derlenir ve sorunsuz çalışır, çünkü Sekil'in hiç abstract metodu yok.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Derlenir ama çalışma zamanında InstantiationException fırlatır.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$An abstract class `B` extends abstract class `A`. `B` does not implement one of `A`'s abstract methods. Under what condition does `B` still compile?$$,
           NULL, NULL,
           $$Only a concrete class is forced to implement an abstract method it inherited; an intermediate abstract class is free to leave it unimplemented and defer it further down the hierarchy.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'abstract-class'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It never compiles unless B provides an empty default implementation.$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It compiles only if B renames the abstract method.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$As long as B itself is also declared abstract -- only a concrete subclass is required to implement every inherited abstract method.$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It always compiles, whether or not B is declared abstract.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Abstract bir sınıf olan `B`, abstract bir sınıf olan `A`'yı extends ediyor. `B`, `A`'nın abstract metotlarından birini implement etmiyor. `B` hangi koşulda yine de derlenir?$$,
           NULL, NULL,
           $$Yalnızca somut (concrete) bir sınıf, miras aldığı bir abstract metodu implement etmeye zorlanır; ara seviyedeki bir abstract sınıf onu implement etmeden bırakıp hiyerarşide daha aşağıya erteleyebilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'abstract-class'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$B abstract olsun ya da olmasın her zaman derlenir.$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$B boş bir varsayılan implementasyon sağlamadıkça asla derlenmez.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca B abstract metodun adını değiştirirse derlenir.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$B'nin kendisi de abstract olarak bildirildiği sürece -- yalnızca somut bir alt sınıf, miras aldığı tüm abstract metotları implement etmek zorundadır.$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$abstract class Animal {
    void sleep() { System.out.println("sleeping quietly"); }
    abstract void makeSound();
}

class Cat extends Animal {
    void makeSound() { System.out.println("Meow"); }
    @Override
    void sleep() { System.out.println("napping"); }
}

public class Demo {
    public static void main(String[] args) {
        Animal a = new Cat();
        a.sleep();
        a.makeSound();
    }
}$$, $$java$$,
           $$sleep() is a concrete method with a full body, but a subclass is still free to override it -- Cat does, and dynamic dispatch means the overridden version runs even through an Animal reference.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'abstract-class'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$napping
Meow$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$sleeping quietly
Meow$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Compile error -- a concrete inherited method can't be overridden without being abstract.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$napping
sleeping quietly$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$abstract class Hayvan {
    void uyu() { System.out.println("sessizce uyuyor"); }
    abstract void sesCikar();
}

class Kedi extends Hayvan {
    void sesCikar() { System.out.println("Miyav"); }
    @Override
    void uyu() { System.out.println("kestiriyor"); }
}

public class Ornek {
    public static void main(String[] args) {
        Hayvan h = new Kedi();
        h.uyu();
        h.sesCikar();
    }
}$$, $$java$$,
           $$uyu(), tam bir gövdeye sahip concrete bir metottur, ama bir alt sınıf yine de onu override edebilir -- Kedi bunu yapar, ve dynamic dispatch sayesinde bir Hayvan referansı üzerinden bile override edilen versiyon çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'abstract-class'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$kestiriyor
sessizce uyuyor$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$kestiriyor
Miyav$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$sessizce uyuyor
Miyav$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Derleme hatası -- miras alınan concrete bir metot abstract olmadan override edilemez.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$abstract class Account {
    Account(String owner) {
        System.out.println("Account created for " + owner);
    }
}

class SavingsAccount extends Account {
    SavingsAccount(String owner) {
        super(owner);
        System.out.println("SavingsAccount ready");
    }
}

public class Demo {
    public static void main(String[] args) {
        new SavingsAccount("Alice");
    }
}$$, $$java$$,
           $$An abstract class can have a constructor, even though it can never be called directly with new -- it only runs through a super(...) call. The parent's constructor always finishes before the subclass's own extra work runs.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'abstract-class'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Compile error -- an abstract class can't have a constructor.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Account created for Alice$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Account created for Alice
SavingsAccount ready$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$SavingsAccount ready
Account created for Alice$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$abstract class Hesap {
    Hesap(String sahip) {
        System.out.println(sahip + " icin hesap acildi");
    }
}

class VadeliHesap extends Hesap {
    VadeliHesap(String sahip) {
        super(sahip);
        System.out.println("VadeliHesap hazir");
    }
}

public class Ornek {
    public static void main(String[] args) {
        new VadeliHesap("Ayse");
    }
}$$, $$java$$,
           $$Abstract bir sınıfın bir constructor'ı olabilir, hiçbir zaman doğrudan new ile çağrılamasa da -- yalnızca bir super(...) çağrısı aracılığıyla çalışır. Üst sınıfın constructor'ı, alt sınıfın kendi ek işini yapmadan önce her zaman tamamlanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'abstract-class'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$VadeliHesap hazir
Ayse icin hesap acildi$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Derleme hatası -- abstract bir sınıfın constructor'ı olamaz.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Ayse icin hesap acildi$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Ayse icin hesap acildi
VadeliHesap hazir$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following modifier combinations on a method are illegal, and why? (Select all that apply)$$,
           NULL, NULL,
           $$private abstract is illegal because a private method is already invisible to subclasses, so it can't be overridden. final abstract is illegal because a final method can never be overridden, directly contradicting what abstract requires.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'abstract-class'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$private abstract -- a private method is already invisible to subclasses, so it can never be overridden.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$final abstract -- a final method can never be overridden, which directly contradicts what abstract requires.$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$protected abstract -- protected methods can never be inherited by subclasses.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$public abstract -- public methods can never be declared abstract.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir metot üzerinde aşağıdaki modifier kombinasyonlarından hangileri yasaktır ve neden? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$private abstract yasaktır çünkü private bir metot zaten alt sınıflara görünmez, bu yüzden override edilemez. final abstract yasaktır çünkü final bir metot asla override edilemez, bu da abstract'ın gerektirdiğiyle doğrudan çelişir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'abstract-class'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$public abstract -- public metotlar asla abstract olarak bildirilemez.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$private abstract -- private bir metot zaten alt sınıflara görünmez, bu yüzden asla override edilemez.$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$final abstract -- final bir metot asla override edilemez, bu abstract'ın gerektirdiğiyle doğrudan çelişir.$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$protected abstract -- protected metotlar asla alt sınıflar tarafından miras alınamaz.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$interface Auditable {
    String auditLog();
}

abstract class Document implements Auditable {
    abstract String content();
}

class Report extends Document {
    String content() { return "report content"; }
    public String auditLog() { return "audited: " + content(); }
}

public class Demo {
    public static void main(String[] args) {
        Document d = new Report();
        System.out.println(d.auditLog());
    }
}$$, $$java$$,
           $$Document implements Auditable but never writes auditLog() -- just like it defers its own content(), it defers auditLog() to a subclass. Report implements both, so the call resolves normally.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'abstract-class'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Compile error -- Report must separately declare implements Auditable.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$null$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$audited: report content$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Compile error -- Document must implement auditLog() itself.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$interface Denetlenebilir {
    String denetimKaydi();
}

abstract class Belge implements Denetlenebilir {
    abstract String icerik();
}

class Rapor extends Belge {
    String icerik() { return "rapor icerigi"; }
    public String denetimKaydi() { return "denetlendi: " + icerik(); }
}

public class Ornek {
    public static void main(String[] args) {
        Belge b = new Rapor();
        System.out.println(b.denetimKaydi());
    }
}$$, $$java$$,
           $$Belge, Denetlenebilir'i implement eder ama denetimKaydi()'yi hiç yazmaz -- tıpkı kendi icerik()'ini ertelediği gibi, denetimKaydi()'yi de bir alt sınıfa erteler. Rapor ikisini de implement eder, bu yüzden çağrı normal şekilde çözümlenir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'abstract-class'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme hatası -- Belge denetimKaydi()'yi kendisi implement etmelidir.$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Derleme hatası -- Rapor ayrıca implements Denetlenebilir bildirmelidir.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$null$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$denetlendi: rapor icerigi$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$In the Template Method pattern, why is the skeleton method (like `run()`) typically marked `final`?$$,
           NULL, NULL,
           $$Marking the skeleton method final guarantees subclasses can only fill in the content of the individual steps, never reorder or change the fixed sequence the parent class defines.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'abstract-class'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$To guarantee that subclasses can only fill in the content of the steps, never change their fixed order.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$To prevent the method from being inherited at all.$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Because abstract methods are required to be called from a final method.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$To allow the method to be called without creating an instance.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Template Method deseninde, iskelet metodun (`run()` gibi) genellikle `final` işaretlenmesinin nedeni nedir?$$,
           NULL, NULL,
           $$İskelet metodu final işaretlemek, alt sınıfların yalnızca ayrı adımların içeriğini doldurabilmesini garanti eder -- üst sınıfın tanımladığı sabit sırayı asla yeniden düzenleyemez ya da değiştiremezler.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'abstract-class'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Metodun bir instance oluşturmadan çağrılabilmesine izin vermek için.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Alt sınıfların yalnızca adımların içeriğini doldurabilmesini, sabit sırayı asla değiştirememesini garanti etmek için.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Metodun hiç miras alınmasını önlemek için.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Çünkü abstract metotların final bir metottan çağrılması zorunludur.$$, FALSE, 3 FROM new_question_tr7;
