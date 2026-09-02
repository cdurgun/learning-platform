-- Promotion batch
-- Topic: inheritance (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V599-V611 (collections) and V574-V594 (generics),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/inheritance.md and content/tr/inheritance.md.
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
           $$If a subclass constructor never explicitly calls `super(...)`, what does the compiler do?$$,
           NULL, NULL,
           $$If you never write super(...) in a subclass constructor, the compiler implicitly tries to call the superclass's no-argument constructor as the first statement.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inheritance'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It implicitly calls the superclass's no-argument constructor as the first statement.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It leaves the superclass completely uninitialized.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It calls the subclass's own no-argument constructor instead.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It causes a compile error in every case.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir alt sınıf constructor'ı hiçbir zaman açıkça `super(...)` çağırmazsa, derleyici ne yapar?$$,
           NULL, NULL,
           $$Bir alt sınıf constructor'ında hiç super(...) yazmazsan, derleyici ilk ifade olarak üst sınıfın parametresiz constructor'ını örtük olarak çağırmaya çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inheritance'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her durumda bir derleme hatasına neden olur.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$İlk ifade olarak üst sınıfın parametresiz constructor'ını örtük olarak çağırır.$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Üst sınıfı tamamen başlatılmamış bırakır.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Bunun yerine alt sınıfın kendi parametresiz constructor'ını çağırır.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Shape {
    double area() { return 0; }
}

class Circle extends Shape {
    double area() { return 3.14; }
}

public class Demo {
    public static void main(String[] args) {
        Shape s = new Circle();
        System.out.println(s.area());
    }
}$$, $$java$$,
           $$Which implementation of an overridden method runs is decided at runtime, based on the object's actual class -- s's static type is Shape, but its runtime type is Circle, so Circle's area() runs.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inheritance'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Compile error -- s is declared as Shape, not Circle.$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$0$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$3.14$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$0.0$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Sekil {
    double alan() { return 0; }
}

class Kare extends Sekil {
    double alan() { return 25.0; }
}

public class Ornek {
    public static void main(String[] args) {
        Sekil s = new Kare();
        System.out.println(s.alan());
    }
}$$, $$java$$,
           $$Override edilmiş bir metodun hangi implementasyonunun çalışacağı, çalışma zamanında nesnenin gerçek sınıfına göre belirlenir -- s'nin statik tipi Sekil'dir, ama runtime tipi Kare'dir, bu yüzden Kare'nin alan()'ı çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inheritance'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$0.0$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Derleme hatası -- s, Kare değil Sekil olarak bildirilmiştir.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$0$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$25.0$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Employee {
    String describe() { return "Employee"; }
}

class Manager extends Employee {
    String describe() { return super.describe() + " + Manager"; }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(new Manager().describe());
    }
}$$, $$java$$,
           $$super.method() explicitly calls the overridden method from the superclass -- Manager doesn't throw away Employee's original behavior, it builds on top of it by calling super.describe() first.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inheritance'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Employee + Manager$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Manager$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Employee$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Compile error -- super.describe() can't be called from an overriding method.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Calisan {
    String tanimla() { return "Calisan"; }
}

class Yonetici extends Calisan {
    String tanimla() { return super.tanimla() + " + Yonetici"; }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(new Yonetici().tanimla());
    }
}$$, $$java$$,
           $$super.metod(), üst sınıftaki override edilen metodu açıkça çağırır -- Yonetici, Calisan'ın orijinal davranışını atmaz, önce super.tanimla()'yı çağırarak onun üzerine inşa eder.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inheritance'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme hatası -- super.tanimla(), override eden bir metottan çağrılamaz.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Calisan + Yonetici$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Yonetici$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Calisan$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A superclass has a `private` field. Which statement correctly describes how a subclass relates to it?$$,
           NULL, NULL,
           $$A private field is technically inherited by a subclass (it's part of the subclass instance's memory layout), but the subclass can't reach it by name directly -- only through a public/protected accessor the superclass provides.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inheritance'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The subclass can access it directly, since inheritance includes every member regardless of access modifier.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$The field automatically becomes protected once it's inherited.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$The field is technically inherited, but the subclass can't access it directly by name -- only through a public/protected accessor.$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$The subclass doesn't inherit the field at all.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir üst sınıfın `private` bir alanı var. Bir alt sınıfın bununla ilişkisi için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$Bir private alan, teknik olarak bir alt sınıf tarafından miras alınır (alt sınıf instance'ının bellek düzeninin bir parçasıdır), ama alt sınıf ona doğrudan isimle erişemez -- yalnızca üst sınıfın sağladığı public/protected bir erişimci üzerinden.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inheritance'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Alt sınıf alanı hiç miras almaz.$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Alt sınıf ona doğrudan erişebilir, çünkü kalıtım erişim belirleyiciden bağımsız olarak tüm üyeleri kapsar.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Alan, miras alındığında otomatik olarak protected hâle gelir.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Alan teknik olarak miras alınır, ama alt sınıf ona doğrudan isimle erişemez -- yalnızca public/protected bir erişimci üzerinden.$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Animal {
    String label = "Animal";
}

class Dog extends Animal {
    String label = "Dog";
}

public class Demo {
    public static void main(String[] args) {
        Animal animal = new Dog();
        Dog dog = new Dog();
        System.out.println(animal.label);
        System.out.println(dog.label);
    }
}$$, $$java$$,
           $$Unlike method overriding, field access is not polymorphic -- which field you get is decided by the compile-time static type of the variable, not the object's runtime type. animal is statically typed Animal, so it sees Animal's label; dog sees Dog's.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inheritance'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Animal
Dog$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Dog
Dog$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Animal
Animal$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Compile error -- Dog can't redeclare a field with the same name as Animal's.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Hayvan {
    String etiket = "Hayvan";
}

class Kopek extends Hayvan {
    String etiket = "Kopek";
}

public class Ornek {
    public static void main(String[] args) {
        Hayvan h = new Kopek();
        Kopek k = new Kopek();
        System.out.println(h.etiket);
        System.out.println(k.etiket);
    }
}$$, $$java$$,
           $$Method overriding'in aksine, alan erişimi polimorfik değildir -- hangi alanın döneceği, nesnenin runtime tipine değil değişkenin derleme-zamanı statik tipine göre belirlenir. h statik olarak Hayvan tipindedir, bu yüzden Hayvan'ın etiket'ini görür; k ise Kopek'inkini görür.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inheritance'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme hatası -- Kopek, Hayvan'la aynı isimde bir alanı yeniden bildiremez.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Hayvan
Kopek$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Kopek
Kopek$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Hayvan
Hayvan$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, BEGINNER)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about the `final` keyword in the context of inheritance? (Select all that apply)$$,
           NULL, NULL,
           $$A final class can never be extended. A final method can never be overridden, though a subclass can still inherit and use it normally.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inheritance'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A final method can never be inherited by a subclass at all.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$A final class can still be extended by classes within the same package.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$A final class can never be extended.$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$A final method can never be overridden, though a subclass can still inherit and use it normally.$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, BEGINNER)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Kalıtım bağlamında `final` anahtar kelimesi hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Final bir sınıf asla extend edilemez. Final bir metot asla override edilemez, ama bir alt sınıf onu normal şekilde miras alıp kullanabilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inheritance'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Final bir metot asla override edilemez, ama bir alt sınıf onu normal şekilde miras alıp kullanabilir.$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Final bir metot bir alt sınıf tarafından hiç miras alınamaz.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Final bir sınıf, aynı paket içindeki sınıflar tarafından yine de extend edilebilir.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Final bir sınıf asla extend edilemez.$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Animal {}
class Dog extends Animal { void bark() { System.out.println("Woof"); } }
class Cat extends Animal {}

public class Demo {
    public static void main(String[] args) {
        Animal a = new Cat();
        if (a instanceof Dog d) {
            d.bark();
        } else {
            System.out.println("not a dog");
        }
    }
}$$, $$java$$,
           $$a's runtime type is Cat, not Dog, so the pattern-matching instanceof check fails and the else branch runs -- no ClassCastException, since the cast is only attempted after the type check succeeds.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inheritance'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$not a dog$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Woof$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Compile error -- pattern-matching instanceof requires an explicit cast first.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$It throws ClassCastException.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Hayvan {}
class Kopek extends Hayvan { void havla() { System.out.println("Hav"); } }
class Kus extends Hayvan {}

public class Ornek {
    public static void main(String[] args) {
        Hayvan h = new Kus();
        if (h instanceof Kopek k) {
            k.havla();
        } else {
            System.out.println("kopek degil");
        }
    }
}$$, $$java$$,
           $$h'nin runtime tipi Kopek değil Kus'tur, bu yüzden pattern-matching instanceof kontrolü başarısız olur ve else dalı çalışır -- ClassCastException fırlamaz, çünkü cast yalnızca tip kontrolü başarılı olursa denenir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inheritance'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ClassCastException fırlatır.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$kopek degil$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Hav$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Derleme hatası -- pattern-matching instanceof önce açık bir cast gerektirir.$$, FALSE, 3 FROM new_question_tr7;
