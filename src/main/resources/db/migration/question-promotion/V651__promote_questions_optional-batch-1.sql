-- Promotion batch
-- Topic: optional (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V615-V627 (OOP) and V599-V611 (collections),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/optional.md and content/tr/optional.md.
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

-- Pair 1 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code runs?$$,
           $$import java.util.Optional;

public class Demo {
    public static void main(String[] args) {
        String value = null;
        Optional<String> opt = Optional.ofNullable(value);
        System.out.println(opt.isPresent());
        Optional<String> opt2 = Optional.of(value);
    }
}$$, $$java$$,
           $$Optional.ofNullable(value) safely wraps a possibly-null value, producing an empty Optional if it is null -- so isPresent() prints false. Optional.of(value) asserts the value is never null -- given null, it throws NullPointerException immediately.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'optional'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It prints false, then throws NullPointerException at Optional.of(value).$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It prints false, then true.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It throws NullPointerException immediately at ofNullable.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It prints true, then throws NullPointerException.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$import java.util.Optional;

public class Ornek {
    public static void main(String[] args) {
        String deger = null;
        Optional<String> opt = Optional.ofNullable(deger);
        System.out.println(opt.isEmpty());
        Optional<String> opt2 = Optional.of(deger);
    }
}$$, $$java$$,
           $$Optional.ofNullable(deger), null olabilecek bir değeri güvenle sarmalar, null ise boş bir Optional üretir -- bu yüzden isEmpty() true yazdırır. Optional.of(deger) ise değerin asla null olmayacağını varsayar -- null verildiğinde hemen NullPointerException fırlatır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'optional'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$false yazdırır, sonra NullPointerException fırlatır.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$true yazdırır, sonra Optional.of(deger)'de NullPointerException fırlatır.$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$true, sonra false yazdırır.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$ofNullable'da hemen NullPointerException fırlatır.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.Optional;

public class Demo {
    static String compute() {
        System.out.println("computing");
        return "default";
    }
    public static void main(String[] args) {
        Optional<String> present = Optional.of("value");
        System.out.println(present.orElseGet(Demo::compute));
    }
}$$, $$java$$,
           $$orElseGet()'s Supplier is only invoked if the Optional turns out to be empty. Since present already has a value, compute() never runs.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'optional'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$computing
default$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$default$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$value$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$computing
value$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.Optional;

public class Ornek {
    static String hesapla() {
        System.out.println("hesaplaniyor");
        return "varsayilan";
    }
    public static void main(String[] args) {
        Optional<String> dolu = Optional.of("deger");
        System.out.println(dolu.orElseGet(Ornek::hesapla));
    }
}$$, $$java$$,
           $$orElseGet()'in Supplier'ı yalnızca Optional boş çıkarsa çağrılır. dolu zaten bir değere sahip olduğu için hesapla() hiç çalışmaz.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'optional'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$hesaplaniyor
deger$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$hesaplaniyor
varsayilan$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$varsayilan$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$deger$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$When `orElseThrow(Supplier<X>)` is called on an Optional that already has a value present, what happens to the supplied Supplier?$$,
           NULL, NULL,
           $$If the Optional is present, the Supplier is never called -- the same lazy-evaluation logic as orElseGet().$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'optional'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It is never invoked -- the same lazy-evaluation logic as orElseGet().$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It is always invoked, but its result is discarded.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It throws the exception immediately regardless of whether a value is present.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It is invoked exactly once per Optional instance, regardless of when orElseThrow() is called.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Zaten bir değere sahip bir Optional üzerinde `orElseThrow(Supplier<X>)` çağrıldığında, verilen Supplier'a ne olur?$$,
           NULL, NULL,
           $$Optional bir değere sahipse, Supplier hiç çağrılmaz -- tıpkı orElseGet()'in lazy-evaluation mantığı gibi.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'optional'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$orElseThrow()'un ne zaman çağrıldığından bağımsız olarak, her Optional instance'ı için tam olarak bir kez çağrılır.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Hiç çağrılmaz -- tıpkı orElseGet()'in lazy-evaluation mantığı gibi.$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Her zaman çağrılır, ama sonucu göz ardı edilir.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Değer olsun ya da olmasın istisnayı hemen fırlatır.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.Optional;

public class Demo {
    static Optional<Integer> parse(String s) {
        try {
            return Optional.of(Integer.parseInt(s));
        } catch (NumberFormatException e) {
            return Optional.empty();
        }
    }
    public static void main(String[] args) {
        Optional<String> input = Optional.of("42");
        Optional<Integer> result = input.flatMap(Demo::parse);
        System.out.println(result.get());
    }
}$$, $$java$$,
           $$flatMap() merges the inner Optional returned by parse() directly into the outer one, instead of producing an awkward Optional<Optional<Integer>>.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'optional'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Compile error -- flatMap requires a Function returning a plain value, not an Optional.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It throws NoSuchElementException.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$42$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Optional[42]$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.Optional;

public class Ornek {
    static Optional<Integer> ayristir(String s) {
        try {
            return Optional.of(Integer.parseInt(s));
        } catch (NumberFormatException e) {
            return Optional.empty();
        }
    }
    public static void main(String[] args) {
        Optional<String> girdi = Optional.of("17");
        Optional<Integer> sonuc = girdi.flatMap(Ornek::ayristir);
        System.out.println(sonuc.get());
    }
}$$, $$java$$,
           $$flatMap(), ayristir()'in döndürdüğü iç Optional'ı, garip bir Optional<Optional<Integer>> üretmek yerine doğrudan dış Optional'a birleştirir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'optional'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Optional[17]$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Derleme hatası -- flatMap, Optional değil düz bir değer döndüren bir Function gerektirir.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$NoSuchElementException fırlatır.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$17$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about `ifPresent()` and `ifPresentOrElse()`? (Select all that apply)$$,
           NULL, NULL,
           $$ifPresent(Consumer) runs a side effect only if a value is present, with no explicit null check needed. ifPresentOrElse(Consumer, Runnable) adds a branch for the empty case, something ifPresent() alone can't express.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'optional'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ifPresent(Consumer) runs a side effect only if a value is present, with no explicit null check needed.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$ifPresentOrElse(Consumer, Runnable) adds a branch for the empty case, something ifPresent() alone can't express.$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$ifPresent() runs its Consumer even when the Optional is empty, passing null.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$ifPresentOrElse() requires both branches to return the same type.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`ifPresent()` ve `ifPresentOrElse()` hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$ifPresent(Consumer), açık bir null kontrolüne gerek kalmadan, yalnızca bir değer varsa bir yan etki çalıştırır. ifPresentOrElse(Consumer, Runnable), ifPresent()'in tek başına ifade edemediği, boş durum için bir dal ekler.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'optional'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ifPresentOrElse(), her iki dalın da aynı türü döndürmesini gerektirir.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$ifPresent(Consumer), açık bir null kontrolüne gerek kalmadan, yalnızca bir değer varsa bir yan etki çalıştırır.$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$ifPresentOrElse(Consumer, Runnable), ifPresent()'in tek başına ifade edemediği, boş durum için bir dal ekler.$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$ifPresent(), Optional boş olsa bile Consumer'ını null geçirerek çalıştırır.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.Optional;

public class Demo {
    public static void main(String[] args) {
        Optional<Integer> num = Optional.of(4);
        Optional<Integer> filtered = num.filter(n -> n > 10);
        System.out.println(filtered.isPresent());
    }
}$$, $$java$$,
           $$filter(Predicate) keeps the value only if it satisfies the condition -- otherwise it turns a present Optional into an empty one. 4 is not greater than 10, so filtered becomes empty.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'optional'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It throws NoSuchElementException.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Compile error.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$false$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$true$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.Optional;

public class Ornek {
    public static void main(String[] args) {
        Optional<Integer> sayi = Optional.of(20);
        Optional<Integer> filtrelenmis = sayi.filter(n -> n > 10);
        System.out.println(filtrelenmis.isPresent());
    }
}$$, $$java$$,
           $$filter(Predicate), değeri yalnızca koşulu sağlıyorsa tutar -- aksi halde dolu bir Optional'ı boşa çevirir. 20, 10'dan büyük olduğu için filtrelenmis dolu kalır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'optional'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$false$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$NoSuchElementException fırlatır.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Derleme hatası.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$true$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson's Best Practices, where should `Optional` be used?$$,
           NULL, NULL,
           $$Optional's design intent is purely to communicate "this method might not return a value" -- using it as a field type, a method parameter, or a collection element type is widely discouraged.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'optional'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only as a method return type -- using it as a field type, a method parameter, or a collection element type is widely discouraged.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$As a field type in every class that might have a missing value.$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$As the element type of a List whenever elements might be absent.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Only as a method parameter, never as a return type.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin Best Practices bölümüne göre, `Optional` nerede kullanılmalıdır?$$,
           NULL, NULL,
           $$Optional'ın tasarım amacı yalnızca "bu metot bir değer döndürmeyebilir" mesajını iletmektir -- bir alan türü, metot parametresi ya da koleksiyon eleman türü olarak kullanmak yaygın olarak önerilmez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'optional'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca bir metot parametresi olarak, asla dönüş türü olarak değil.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Yalnızca bir metot dönüş türü olarak -- bir alan türü, metot parametresi ya da koleksiyon eleman türü olarak kullanmak yaygın olarak önerilmez.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Eksik bir değere sahip olabilecek her sınıfta bir alan türü olarak.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Elemanlar eksik olabildiğinde bir List'in eleman türü olarak.$$, FALSE, 3 FROM new_question_tr7;
