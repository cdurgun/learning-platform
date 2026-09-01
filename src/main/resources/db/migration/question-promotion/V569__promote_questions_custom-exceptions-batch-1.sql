-- Promotion batch
-- Topic: custom-exceptions (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V541 (records), V545 (reflection), V549 (date-time),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/custom-exceptions.md and content/tr/custom-exceptions.md.
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
           $$What makes a class a valid, usable custom exception type?$$,
           NULL, NULL,
           $$A custom exception is simply a class that extends Exception (making it checked) or RuntimeException (making it unchecked) -- nothing more is required to make it real and usable.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It must override toString().$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It must extend Exception (checked) or RuntimeException (unchecked) -- nothing more is required.$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It must be declared final.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It must implement the Throwable interface directly, bypassing Exception/RuntimeException.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir custom exception `RuntimeException`'ı genişletirse ne olur?$$,
           NULL, NULL,
           $$Custom exception RuntimeException'ı genişletirse unchecked olur -- throws bildirmek ya da catch etmek zorunlu değildir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Checked bir exception olur, throws bildirmek zorunludur.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Unchecked bir exception olur, throws bildirmek ya da catch etmek zorunlu değildir.$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Artık Throwable'ın metotlarını miras almaz.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Derleyici onu otomatik olarak Exception'a dönüştürür.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class InvalidOrderQuantityException extends RuntimeException {
    private final int quantity;
    InvalidOrderQuantityException(int quantity) {
        super("invalid quantity: " + quantity);
        this.quantity = quantity;
    }
    int getQuantity() { return quantity; }
}

public class Demo {
    static void placeOrder(int quantity) {
        if (quantity <= 0) {
            throw new InvalidOrderQuantityException(quantity);
        }
    }
    public static void main(String[] args) {
        try {
            placeOrder(-3);
        } catch (InvalidOrderQuantityException e) {
            System.out.println(e.getMessage() + " / qty=" + e.getQuantity());
        }
    }
}$$, $$java$$,
           $$The custom exception stores the rejected quantity in its own field and forwards a message to Exception's constructor -- the catch block reads both the inherited getMessage() and the custom getQuantity() directly.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$invalid quantity: -3 / qty=-3$$, TRUE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$invalid quantity: -3 / qty=0$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Compile error -- getQuantity() is not accessible.$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$null / qty=-3$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class YetersizBakiyeException extends Exception {
    YetersizBakiyeException(String mesaj) {
        super(mesaj);
    }
}

public class Ornek {
    static void cek(double bakiye, double miktar) throws YetersizBakiyeException {
        if (miktar > bakiye) {
            throw new YetersizBakiyeException("yetersiz bakiye: " + miktar);
        }
    }
    public static void main(String[] args) {
        try {
            cek(100.0, 150.0);
        } catch (YetersizBakiyeException e) {
            System.out.println("hata: " + e.getMessage());
        }
    }
}$$, $$java$$,
           $$YetersizBakiyeException, Exception'ı genişlettiği için checked'tir -- cek() throws bildirir, miktar bakiyeyi aştığı için exception fırlatılır ve mesajıyla birlikte yakalanıp yazdırılır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$hata: yetersiz bakiye: 150.0$$, TRUE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$hata: yetersiz bakiye: 100.0$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Derleme hatası -- cek() throws bildirmeli değil.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$hata: null$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$How many standard constructor shapes does `Throwable` offer, that a well-designed custom exception commonly mirrors?$$,
           NULL, NULL,
           $$Throwable itself offers four constructors: no-argument, message-only, message-with-cause, and cause-only. A well-designed custom exception commonly mirrors all four.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Two: no-argument and message-only.$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Three: message, cause, and message+cause.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Four: no-argument, message-only, message-with-cause, and cause-only.$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$One: message-only, since cause is set separately with initCause().$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Custom exception sınıf adlarının `Exception` sonekiyle bitmesi kuralı için ne söylenebilir?$$,
           NULL, NULL,
           $$Bu kural derleyici tarafından zorlanmaz, ama her Java kod tabanının beklediği güçlü bir okunabilirlik kuralıdır -- InsufficientFunds değil, InsufficientFundsException.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleyici tarafından zorunlu tutulur, aksi halde derleme hatası alınır.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Derleyici tarafından zorlanmaz, ama her Java kod tabanının beklediği güçlü bir okunabilirlik kuralıdır.$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca unchecked custom exception'lar için geçerlidir.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Exception'ı genişletenler için zorunlu, RuntimeException için isteğe bağlıdır.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class PaymentException extends RuntimeException {
    PaymentException(String message) { super(message); }
}
class CardDeclinedException extends PaymentException {
    CardDeclinedException(String message) { super(message); }
}
class PaymentGatewayTimeoutException extends PaymentException {
    PaymentGatewayTimeoutException(String message) { super(message); }
}

public class Demo {
    static void process(int attempt) {
        if (attempt == 1) throw new CardDeclinedException("card declined");
        throw new PaymentGatewayTimeoutException("gateway timeout");
    }
    public static void main(String[] args) {
        for (int i = 1; i <= 2; i++) {
            try {
                process(i);
            } catch (PaymentException e) {
                System.out.println(e.getClass().getSimpleName() + ": " + e.getMessage());
            }
        }
    }
}$$, $$java$$,
           $$Both CardDeclinedException and PaymentGatewayTimeoutException extend PaymentException, so a single catch (PaymentException e) block catches both -- getClass().getSimpleName() still resolves to each exception's actual runtime type.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$CardDeclinedException: card declined / PaymentGatewayTimeoutException: gateway timeout$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$PaymentException: card declined / PaymentException: gateway timeout$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Only the first exception is caught, the second crashes the program.$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Compile error -- catching a superclass of a thrown subclass is not allowed.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class OdemeException extends RuntimeException {
    OdemeException(String mesaj) { super(mesaj); }
}
class KartReddiException extends OdemeException {
    KartReddiException(String mesaj) { super(mesaj); }
}
class BaglantiZamanAsimiException extends OdemeException {
    BaglantiZamanAsimiException(String mesaj) { super(mesaj); }
}

public class Ornek {
    public static void main(String[] args) {
        try {
            throw new BaglantiZamanAsimiException("baglanti zaman asimi");
        } catch (KartReddiException e) {
            System.out.println("kart reddi: " + e.getMessage());
        } catch (OdemeException e) {
            System.out.println("odeme hatasi: " + e.getMessage());
        }
    }
}$$, $$java$$,
           $$BaglantiZamanAsimiException, KartReddiException'ın bir alt sınıfı değildir (ikisi de OdemeException'ın kardeş alt sınıflarıdır), bu yüzden ilk catch bloğuyla eşleşmez ve daha genel olan ikinci catch (OdemeException) bloğuna düşer.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$kart reddi: baglanti zaman asimi$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$odeme hatasi: baglanti zaman asimi$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$İkisi de yazdırılır.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Derlenmez, çünkü iki catch bloğu çakışır.$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A custom exception's constructor forgets to call `super(message)`. What is the observable consequence?$$,
           NULL, NULL,
           $$Common Mistakes explicitly calls out forgetting to call super(message) (or super(message, cause)), leaving getMessage() returning null for no reason.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The class fails to compile.$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$getMessage() returns null for no apparent reason.$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The exception can no longer be thrown.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$getStackTrace() throws a NullPointerException.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class GecersizVeriException extends RuntimeException {
    GecersizVeriException(String mesaj) {
        // super(mesaj) cagrisi unutuldu
    }
}

public class Ornek {
    public static void main(String[] args) {
        try {
            throw new GecersizVeriException("beklenmeyen deger");
        } catch (GecersizVeriException e) {
            System.out.println("mesaj: " + e.getMessage());
        }
    }
}$$, $$java$$,
           $$Constructor super(mesaj)'ı çağırmadığı için mesaj parametresi hiçbir yere kaydedilmez ve RuntimeException'ın no-arg constructor'ı otomatik olarak çalışır -- getMessage() bu yüzden null döner.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$mesaj: beklenmeyen deger$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$mesaj: null$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Derleme hatası.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$NullPointerException fırlatılır.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does extending `Throwable` directly (instead of `Exception` or `RuntimeException`) count as a common mistake?$$,
           NULL, NULL,
           $$Common Mistakes calls this out: extending Throwable directly bypasses the checked/unchecked distinction entirely and is almost never what you actually want.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Throwable cannot be extended at all.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It bypasses the checked/unchecked distinction entirely, and is almost never what you actually want.$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It makes the exception automatically checked.$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It prevents the exception from carrying a message.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, ne zaman custom bir exception türü OLUŞTURMAMAK daha doğrudur?$$,
           NULL, NULL,
           $$Hazır bir exception (IllegalArgumentException gibi) zaten tam olarak gerekeni söylerken custom bir exception'a başvurmak gereksizdir -- her hata yepyeni bir tür gerektirmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hazır bir exception (IllegalArgumentException gibi) zaten tam olarak gerekeni söylediğinde.$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir catch bloğunun yapılandırılmış veriye ihtiyacı olduğunda.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir hatayı uygulamanın kendi kelime dağarcığıyla tanımlamak gerektiğinde.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Birden fazla ilgili hatayı ortak bir base sınıfla gruplamak gerektiğinde.$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are Best Practices for designing custom exceptions, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Name every custom exception with an Exception suffix, and add fields for structured data a catch block might need, instead of encoding it only into the message string.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Name every custom exception type with an Exception suffix.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Add fields for structured data a catch block might need, instead of encoding it only into the message string.$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Build a deep hierarchy of custom exceptions "just in case" future subtypes might be useful.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Always extend Exception (checked), regardless of whether callers can recover.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Custom exception hiyerarşisi kurmakla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Ortak bir custom base sınıfı çağırana geniş ya da dar yakalama şansı verir; "ne olur ne olmaz" diye derin bir hiyerarşi kurmak yerine gerçek bir ihtiyaç ortaya çıktığında alt sınıf eklenmelidir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-exceptions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Ortak bir custom base sınıfı, çağırana geniş ya da dar yakalama arasında seçim şansı verir.$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$"Ne olur ne olmaz" diye derin bir hiyerarşi kurmak yerine, gerçek bir ihtiyaç ortaya çıktığında alt sınıf eklenmelidir.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Her custom exception mutlaka Throwable'ı doğrudan genişletmelidir.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir custom base sınıfı yalnızca checked exception'lar için kurulabilir.$$, FALSE, 3 FROM new_question_tr7;
