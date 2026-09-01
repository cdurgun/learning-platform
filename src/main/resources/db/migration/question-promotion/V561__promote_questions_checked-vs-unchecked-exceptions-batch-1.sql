-- Promotion batch
-- Topic: checked-vs-unchecked-exceptions (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V541 (records), V545 (reflection), V549 (date-time),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/checked-vs-unchecked-exceptions.md and content/tr/checked-vs-unchecked-exceptions.md.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different code/variable names, different question
-- framing) rather than a translation.
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
           $$Which correctly defines a checked exception?$$,
           NULL, NULL,
           $$A checked exception is any class under Exception that is NOT RuntimeException (like IOException, SQLException); if a method can throw one, it must declare it with throws.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'checked-vs-unchecked-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Any subclass of RuntimeException.$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Any class under Exception that is NOT RuntimeException.$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Any subclass of Error.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Any exception without a message constructor.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Unchecked exception aşağıdakilerden hangisidir?$$,
           NULL, NULL,
           $$Unchecked exception, RuntimeException'ın (ve Error'ın) kendisi ve tüm alt sınıflarıdır -- bunlar için ne throws bildirmek ne de catch etmek zorunludur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'checked-vs-unchecked-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Exception'ın altında olup RuntimeException DIŞINDA kalan her sınıf.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$RuntimeException (ve Error) ile bunların tüm alt sınıfları.$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca IOException ve SQLException.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$throws ile bildirilmesi zorunlu olan her sınıf.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$A method calls another method that declares `throws IOException`. What must the calling method do?$$,
           NULL, NULL,
           $$Every piece of code that calls a method declaring a checked exception must either catch it or declare it with throws in its own signature too -- there is no third option, the compiler doesn't allow it.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'checked-vs-unchecked-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Nothing -- IOException is unchecked so no action is required.$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Either catch IOException or declare throws IOException itself -- there is no third option.$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Only declare throws IOException; catching is never allowed.$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Only catch it; declaring throws is never allowed.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kodu derleyip çalıştırmayla ilgili ne söylenebilir?$$,
           $$public class Ornek {
    static int bol(int a, int b) {
        return a / b;
    }
    public static void main(String[] args) {
        System.out.println(bol(10, 0));
    }
}$$, $$java$$,
           $$ArithmeticException unchecked bir exception'dır, bu yüzden hiçbir throws bildirimi ya da catch bloğu olmadan derlenir; ama çalışırken yakalanmamış bir ArithmeticException ile sonlanır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'checked-vs-unchecked-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenmez, çünkü throws ArithmeticException bildirilmedi.$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Derlenir, ama çalışırken yakalanmamış bir ArithmeticException ile sonlanır.$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Derlenir ve "0" yazdırır.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Derlenir ve sessizce hiçbir şey yazdırmaz.$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.io.IOException;

public class Demo {
    static void load() {
        try {
            throw new IOException("disk error");
        } catch (IOException e) {
            throw new RuntimeException("load failed", e);
        }
    }
    public static void main(String[] args) {
        try {
            load();
        } catch (RuntimeException e) {
            System.out.println(e.getMessage() + " / cause: " + e.getCause().getMessage());
        }
    }
}$$, $$java$$,
           $$The IOException is caught and wrapped using RuntimeException's cause constructor -- the original exception's message is preserved and accessible via getCause().getMessage(), even though it's no longer forced on the caller.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'checked-vs-unchecked-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$load failed / cause: disk error$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$disk error / cause: load failed$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Compile error -- load() must declare throws IOException$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$load failed / cause: null$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir checked exception'ı unchecked bir exception'a sararken `cause` parametresini geçmemenin sonucu nedir?$$,
           NULL, NULL,
           $$Bir checked exception'ı sarmalarken orijinal exception'ı cause olarak geçmezsen, asıl hatanın stack trace'i kaybolur ve hata ayıklamak çok zorlaşır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'checked-vs-unchecked-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Program derlenmez.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Orijinal hatanın mesajı ve stack trace'i kaybolur, hata ayıklamak zorlaşır.$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$RuntimeException otomatik olarak checked exception'a dönüşür.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Hiçbir etkisi olmaz, cause yalnızca kozmetiktir.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.io.FileNotFoundException;
import java.io.IOException;

interface Source {
    String read() throws IOException;
}

class StrictSource implements Source {
    public String read() throws FileNotFoundException {
        return "data";
    }
}

public class Demo {
    public static void main(String[] args) throws IOException {
        Source s = new StrictSource();
        System.out.println(s.read());
    }
}$$, $$java$$,
           $$When overriding a method, you may declare a narrower subtype of the checked exceptions the interface declared -- FileNotFoundException is a subtype of IOException, so this is legal narrowing and the code compiles and runs normally.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'checked-vs-unchecked-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Compiles, prints "data".$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Fails to compile because StrictSource.read() doesn't declare throws IOException.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Fails to compile because FileNotFoundException is unrelated to IOException.$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Compiles but throws FileNotFoundException at runtime.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod hakkında ne söylenebilir?$$,
           $$import java.io.FileNotFoundException;
import java.io.IOException;

interface Kaynak {
    String oku() throws FileNotFoundException;
}

class GenisKaynak implements Kaynak {
    public String oku() throws IOException {
        return "veri";
    }
}$$, $$java$$,
           $$Bir metodu override ederken üst sınıfın/interface'in bildirdiği checked exception'dan DAHA GENİŞ bir tip bildiremezsin -- burada interface FileNotFoundException bildirirken override eden metot daha geniş olan IOException'ı bildiriyor, bu yasak bir genişletmedir ve derleyici reddeder.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'checked-vs-unchecked-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenir ve "veri" yazdırır.$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Derlenmez, çünkü override eden metot daha GENİŞ bir checked exception bildiriyor.$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Derlenir ama çalışma zamanında hata verir.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Derlenmez çünkü interface metotları override edilemez.$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are good reasons, per this lesson's guideline, to use a checked exception rather than an unchecked one? (Select all that apply)$$,
           NULL, NULL,
           $$If the caller can reasonably recover from the condition, or the condition is an external, expected-but-uncontrollable failure (like a missing file), a checked exception makes sense.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'checked-vs-unchecked-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The caller can reasonably recover from the condition.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The condition is an external, expected-but-uncontrollable failure, like a missing file.$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The condition represents a programming error, like a null reference.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$You want to avoid ever declaring throws on your method.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri unchecked exception kullanmak için iyi bir gerekçedir? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Durum bir programlama hatasını temsil ediyorsa, ya da çağıranın durumdan gerçekte hiçbir şey yapamayacağı bir durum söz konusuysa, unchecked exception daha uygundur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'checked-vs-unchecked-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Durum bir programlama hatasını temsil ediyor, örneğin geçersiz bir argüman.$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Çağıranın durumdan gerçekte hiçbir şey yapamayacağı bir durum söz konusu.$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Çağıranın makul biçimde kurtarabileceği, dış kaynaklı bir durum (dosya bulunamaması gibi).$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$API'nin her sınırında zorunlu bir catch/throws zinciri istiyorsunuz.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson's History section, why was `java.io.UncheckedIOException` added in Java 8?$$,
           NULL, NULL,
           $$Over time, the community realized checked exceptions weren't the right tool for every situation -- Java's own standard library eventually added RuntimeException-based alternatives like UncheckedIOException.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'checked-vs-unchecked-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because checked exceptions were removed from the language in Java 8.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Because the community realized checked exceptions weren't the right tool for every situation, prompting an unchecked alternative.$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Because IOException was renamed.$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Because C++ required it for interoperability.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Checked exception'ları `catch (Exception e)` gibi aşırı geniş bir tiple yakalamanın sakıncası nedir?$$,
           NULL, NULL,
           $$Checked exception'ları hiç düşünmeden catch (Exception e) gibi aşırı geniş bir tipe yakalamak, hem checked hem unchecked her şeyi (isteyerek ya da istemeyerek) aynı bloğa toplar.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'checked-vs-unchecked-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Program derlenmez.$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Hem checked hem unchecked exception'ları, isteyerek ya da istemeyerek, aynı bloğa toplar.$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Yalnızca unchecked exception'ları yakalar, checked olanları kaçırır.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Error alt sınıflarını da otomatik olarak yakalar.$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following is identified as a common mistake in this lesson?$$,
           NULL, NULL,
           $$Common Mistakes explicitly calls out assuming checked exceptions are always "better" or "more professional" -- in practice, modern Java tends to favor unchecked exceptions.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'checked-vs-unchecked-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Assuming checked exceptions are always "better" or "more professional" than unchecked ones.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Using RuntimeException for a programming error.$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Passing the original exception as cause when wrapping.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Declaring throws for a checked exception a method can genuinely throw.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre aşağıdaki davranışlardan hangisi bir checked exception'ı sarmalarken (wrap) doğru kabul edilir?$$,
           NULL, NULL,
           $$Checked exception'ı unchecked bir exception'a sararken orijinal exception'ı her zaman cause olarak geçmek yaygın ve güvenli bir tekniktir; bunu unutmak yaygın bir hatadır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'checked-vs-unchecked-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Orijinal exception'ı cause parametresi olarak yeni exception'a geçirmek.$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Orijinal exception'ın mesajını yeni bir String'e kopyalayıp orijinali tamamen atmak.$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Sarmalama sırasında orijinal exception'ı asla cause olarak geçmemek, yalnızca mesajını kullanmak.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Checked exception'ı doğrudan Error'a sarmalamak.$$, FALSE, 3 FROM new_question_tr7;
