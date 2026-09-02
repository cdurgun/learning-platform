-- Promotion batch
-- Topic: interface (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V599-V611 (collections) and V574-V594 (generics),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/interface.md and content/tr/interface.md.
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
           $$What happens when this code is compiled?$$,
           $$interface Greeter {
    void greet();
}

class QuietGreeter implements Greeter {
    protected void greet() { System.out.println("hi"); }
}$$, $$java$$,
           $$An interface method is implicitly public, so an overriding implementation can never narrow the access modifier -- it must be at least as accessible as the interface method. protected is narrower than public, so this fails to compile.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'interface'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It fails to compile -- an overriding method can never be less accessible than the interface method it implements.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It compiles and prints "hi".$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It compiles but throws IllegalAccessException at runtime.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It compiles because protected is a stricter, more valid choice for an interface method.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$interface Bildirici {
    void bildir();
}

class SessizBildirici implements Bildirici {
    private void bildir() { System.out.println("bildirim"); }
}$$, $$java$$,
           $$Bir interface metodu örtük olarak public'tir, bu yüzden bir override implementasyonu erişim belirleyicisini asla daraltamaz -- interface metodu kadar erişilebilir olmak zorundadır. private, public'ten çok daha dar olduğu için bu derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'interface'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenir çünkü private, bir interface metodu için daha katı, geçerli bir seçimdir.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Derlenmez -- bir override metodu, implement ettiği interface metodundan asla daha az erişilebilir olamaz.$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Derlenir ve "bildirim" yazdırır.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Derlenir ama çalışma zamanında IllegalAccessException fırlatır.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$interface Constants {
    int MAX = 10;
}

class Widget implements Constants {
    void show() { System.out.println(MAX); }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(Constants.MAX);
        new Widget().show();
    }
}$$, $$java$$,
           $$Interface fields are implicitly public static final -- reachable directly as Constants.MAX with no instance needed, and every implementer sees the exact same shared value, not a per-instance copy.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'interface'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$10
0$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Compile error -- Widget must redeclare MAX.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$10
10$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Compile error -- MAX is not accessible as Constants.MAX.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$interface Sabitler {
    int MAKS = 50;
}

class Aracim implements Sabitler {
    void goster() { System.out.println(MAKS); }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(Sabitler.MAKS);
        new Aracim().goster();
    }
}$$, $$java$$,
           $$Interface alanları örtük olarak public static final'dır -- bir instance'a gerek kalmadan doğrudan Sabitler.MAKS olarak erişilebilir, ve her implementasyon örnek başına bir kopya değil, tam olarak aynı paylaşılan değeri görür.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'interface'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme hatası -- MAKS, Sabitler.MAKS olarak erişilebilir değildir.$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$50
0$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Derleme hatası -- Aracim, MAKS'ı yeniden bildirmelidir.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$50
50$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$How many interfaces can a single class implement at once?$$,
           NULL, NULL,
           $$A class can extends only one class, but it can implements any number of interfaces at once -- just separate them with commas.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'interface'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$As many as it likes, separated by commas -- unlike extends, which is limited to one class.$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Exactly one, the same limit as extends.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$At most two.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Only if every interface involved is a functional interface.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir sınıf aynı anda kaç interface implement edebilir?$$,
           NULL, NULL,
           $$Bir sınıf yalnızca bir sınıfı extends edebilir, ama istediği kadar interface'i virgülle ayırarak aynı anda implements edebilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'interface'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca hepsi functional interface ise.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Virgülle ayırarak istediği kadar -- sınıfların yalnızca bir sınıfı extends edebilmesinin aksine.$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$extends ile aynı sınırla, yalnızca bir tane.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$En fazla iki.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$interface Vehicle {
    default void honk() { System.out.println("Beep"); }
}

class Car implements Vehicle {}

class SportsCar implements Vehicle {
    public void honk() { System.out.println("Vroom-beep"); }
}

public class Demo {
    public static void main(String[] args) {
        Vehicle v1 = new Car();
        Vehicle v2 = new SportsCar();
        v1.honk();
        v2.honk();
    }
}$$, $$java$$,
           $$Car never provides its own honk(), so it automatically inherits the default implementation. SportsCar overrides it with its own @Override -- a default method resolves polymorphically, just like a regular instance method.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'interface'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Compile error -- Car must implement honk() itself.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Vroom-beep
Vroom-beep$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Beep
Vroom-beep$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Beep
Beep$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$interface Arac {
    default void selVer() { System.out.println("Bip"); }
}

class Otomobil implements Arac {}

class SporArac implements Arac {
    public void selVer() { System.out.println("Vinn-bip"); }
}

public class Ornek {
    public static void main(String[] args) {
        Arac a1 = new Otomobil();
        Arac a2 = new SporArac();
        a1.selVer();
        a2.selVer();
    }
}$$, $$java$$,
           $$Otomobil kendi selVer()'ını hiç sağlamaz, bu yüzden default implementasyonu otomatik olarak miras alır. SporArac ise kendi @Override'ıyla değiştirir -- bir default metot, sıradan bir instance metodu gibi polimorfik olarak çözümlenir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'interface'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bip
Bip$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Derleme hatası -- Otomobil selVer()'ı kendisi implement etmelidir.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Vinn-bip
Vinn-bip$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Bip
Vinn-bip$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Which statement correctly describes an interface's static method?$$,
           NULL, NULL,
           $$Unlike a default method, a static method belongs to no implementer at all -- it's called directly through the interface name and can never be overridden.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'interface'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It belongs to no implementer, is called directly through the interface name, and can never be overridden.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It's inherited by every implementing class and can be overridden just like a default method.$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It can only be called through an instance of an implementing class.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It's implicitly abstract and must be implemented by every implementing class.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir interface'in static metodu için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$Bir default metodun aksine, bir static metot hiçbir implementasyona ait değildir -- doğrudan interface adı üzerinden çağrılır ve asla override edilemez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'interface'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Örtük olarak abstract'tır ve implement eden her sınıf tarafından implement edilmelidir.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Hiçbir implementasyona ait değildir, doğrudan interface adı üzerinden çağrılır ve asla override edilemez.$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Her implement eden sınıf tarafından miras alınır ve tıpkı bir default metot gibi override edilebilir.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca implement eden bir sınıfın instance'ı üzerinden çağrılabilir.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$interface Flyer {
    default String move() { return "flying"; }
}

interface Swimmer {
    default String move() { return "swimming"; }
}

class Duck implements Flyer, Swimmer {
    public String move() {
        return Flyer.super.move() + "+" + Swimmer.super.move();
    }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(new Duck().move());
    }
}$$, $$java$$,
           $$Duck inherits a conflicting move() default from both Flyer and Swimmer, so Java forces an explicit override. InterfaceName.super.methodName() lets Duck pick -- and here combine -- both parents' behavior.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'interface'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$flying$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$swimming$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$flying+swimming$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Compile error -- Duck must not override move() itself.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$interface Ucan {
    default String hareket() { return "ucuyor"; }
}

interface Yuzen {
    default String hareket() { return "yuzuyor"; }
}

class Ordek implements Ucan, Yuzen {
    public String hareket() {
        return Ucan.super.hareket() + "+" + Yuzen.super.hareket();
    }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(new Ordek().hareket());
    }
}$$, $$java$$,
           $$Ordek, hem Ucan'dan hem Yuzen'den çakışan bir hareket() default'u miras alır, bu yüzden Java açık bir override'ı zorunlu kılar. InterfaceAdi.super.metotAdi(), Ordek'in üst interface'lerden hangisini -- burada ikisini birden -- kullanacağını seçmesini sağlar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'interface'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme hatası -- Ordek hareket()'i kendisi override etmemelidir.$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$ucuyor$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$yuzuyor$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$ucuyor+yuzuyor$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about functional interfaces? (Select all that apply)$$,
           NULL, NULL,
           $$A functional interface has exactly one abstract method -- default and static methods don't count toward that number. A lambda expression can be used directly as an instance of a functional interface.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'interface'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A functional interface has exactly one abstract method -- default and static methods don't count toward that number.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A lambda expression can be used directly as an instance of a functional interface.$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Adding a second abstract method to a functional interface still lets existing lambda-based code compile unchanged.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$The @FunctionalInterface annotation is required for an interface to be usable as a lambda target.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Functional interface'ler hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Bir functional interface tam olarak bir abstract metoda sahiptir -- default ve static metotlar bu sayıya dahil değildir. Bir lambda ifadesi, bir functional interface'in instance'ı olarak doğrudan kullanılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'interface'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@FunctionalInterface annotation'ı, bir interface'in lambda hedefi olarak kullanılabilmesi için zorunludur.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir functional interface tam olarak bir abstract metoda sahiptir -- default ve static metotlar bu sayıya dahil değildir.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir lambda ifadesi, bir functional interface'in instance'ı olarak doğrudan kullanılabilir.$$, TRUE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir functional interface'e ikinci bir abstract metot eklemek, var olan lambda tabanlı kodun değişmeden derlenmeye devam etmesine izin verir.$$, FALSE, 3 FROM new_question_tr7;
