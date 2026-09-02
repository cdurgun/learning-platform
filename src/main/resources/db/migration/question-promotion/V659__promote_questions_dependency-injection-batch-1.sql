-- Promotion batch
-- Topic: dependency-injection (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V631-V655 (functional interfaces & streams) and
-- V615-V627 (OOP), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/dependency-injection.md and
-- content/tr/dependency-injection.md.
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
           $$Which statement correctly describes the relationship between Dependency Injection (DI) and Inversion of Control (IoC)?$$,
           NULL, NULL,
           $$IoC is the more general idea of handing control outward; DI is the most common concrete way of implementing IoC.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dependency-injection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$IoC is the more general idea of handing control outward; DI is the most common concrete way of implementing IoC.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$DI and IoC are two completely unrelated concepts that happen to be discussed together.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$IoC is a Spring-specific mechanism; DI is the general design principle.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$DI is the more general idea; IoC is one specific technique for implementing it.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Dependency Injection (DI) ile Inversion of Control (IoC) arasındaki ilişki için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$IoC, kontrolü dışarıya devretme fikrinin daha genel hâlidir; DI ise IoC'yi uygulamanın en yaygın somut yoludur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dependency-injection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$DI daha genel fikirdir; IoC ise onu uygulamanın bir tekniğidir.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$IoC, kontrolü dışarıya devretme fikrinin daha genel hâlidir; DI ise IoC'yi uygulamanın en yaygın somut yoludur.$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$DI ve IoC, yalnızca birlikte anılan, tamamen ilgisiz iki kavramdır.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$IoC Spring'e özgü bir mekanizmadır; DI ise genel tasarım ilkesidir.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (MULTIPLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, which of the following are concrete costs of tight coupling (a class creating its dependency directly with `new`)? (Select all that apply)$$,
           NULL, NULL,
           $$Tight coupling leads to untestability (forced to test against the real implementation) and difficulty changing (switching implementations means editing the class's source).$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dependency-injection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Improved performance, since no interface indirection is involved.$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Automatic thread-safety, since the dependency is created once.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Untestability -- you're forced to test against the real implementation, with no way to avoid it.$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Difficulty changing -- switching to a different implementation means opening up and editing the class's source.$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (MULTIPLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, sıkı bağlılığın (bir sınıfın bağımlılığını doğrudan `new` ile oluşturması) somut maliyetleri arasında aşağıdakilerden hangileri yer alır? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Sıkı bağlılık, test edilemezliğe (gerçek implementasyona karşı test etmeye zorlanırsın) ve değiştirme zorluğuna (farklı bir implementasyona geçmek kaynak kodu düzenlemeyi gerektirir) yol açar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dependency-injection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Değiştirme zorluğu -- farklı bir implementasyona geçmek, sınıfın kaynak kodunu açıp düzenlemeyi gerektirir.$$, TRUE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Interface dolaylaması olmadığı için gelişmiş performans.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Bağımlılık yalnızca bir kez oluşturulduğu için otomatik thread-safety.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Test edilemezlik -- gerçek implementasyona karşı test etmeye zorlanırsın, bundan kaçınmanın bir yolu yoktur.$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code runs?$$,
           $$class OrderService {
    private NotificationSender sender;
    void setSender(NotificationSender sender) { this.sender = sender; }
    void placeOrder(String item) {
        sender.send("Order placed: " + item);
    }
}

public class Demo {
    public static void main(String[] args) {
        OrderService service = new OrderService();
        service.placeOrder("Book");
    }
}$$, $$java$$,
           $$With setter injection, a missing dependency only surfaces at runtime, on the exact line where it's actually used. Since setSender(...) is never called, sender is null when placeOrder(...) tries to use it.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dependency-injection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It throws a NullPointerException at runtime, on the placeOrder(...) call, since setSender(...) was never called.$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It fails to compile, since sender is never initialized.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It throws the exception immediately when new OrderService() runs.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It runs fine and prints "Order placed: Book" with a null sender.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$class SiparisServisi {
    private BildirimGonderici gonderici;
    void setGonderici(BildirimGonderici gonderici) { this.gonderici = gonderici; }
    void siparisVer(String urun) {
        gonderici.gonder("Siparis verildi: " + urun);
    }
}

public class Ornek {
    public static void main(String[] args) {
        SiparisServisi servis = new SiparisServisi();
        servis.siparisVer("Kitap");
    }
}$$, $$java$$,
           $$Setter injection'da, eksik bir bağımlılık ancak çalışma zamanında, gerçekten kullanıldığı satırda ortaya çıkar. setGonderici(...) hiç çağrılmadığı için, siparisVer(...) onu kullanmaya çalıştığında gonderici null'dır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dependency-injection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sorunsuz çalışır ve null gonderici ile "Siparis verildi: Kitap" yazdırır.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$setGonderici(...) hiç çağrılmadığı için, çalışma zamanında siparisVer(...) çağrısında NullPointerException fırlatır.$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$gonderici hiç başlatılmadığı için derlenmez.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$new SiparisServisi() çalıştığında hemen istisna fırlatır.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, why is it hard to test a class that uses field injection (like a hand-simulated `@Autowired` field) without a framework?$$,
           NULL, NULL,
           $$A plain new OrderService(fakeSender) call can't set the dependency at all, since there's no constructor that accepts it -- reflection is required.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dependency-injection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Field injection makes the field final, so it can never be changed for testing.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Field injection requires a real database connection to test.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$A plain new OrderService(fakeSender) call can't set the dependency at all, since there's no constructor that accepts it -- reflection is required.$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Field-injected classes can never be instantiated at all outside a container.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, field injection kullanan bir sınıfı (elle simüle edilmiş bir `@Autowired` alanı gibi) bir framework olmadan test etmek neden zordur?$$,
           NULL, NULL,
           $$Düz bir new OrderService(fakeSender) çağrısı bağımlılığı hiç ayarlayamaz, çünkü onu kabul eden bir constructor yoktur -- reflection gerekir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dependency-injection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Field injection kullanan sınıflar container dışında hiçbir zaman örneklenemez.$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Field injection alanı final yapar, bu yüzden test için asla değiştirilemez.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Field injection test etmek için gerçek bir veritabanı bağlantısı gerektirir.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Düz bir new OrderService(fakeSender) çağrısı bağımlılığı hiç ayarlayamaz, çünkü onu kabul eden bir constructor yoktur -- reflection gerekir.$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are reasons this lesson gives for recommending constructor injection as the default? (Select all that apply)$$,
           NULL, NULL,
           $$A missing/null dependency can be caught immediately at construction with Objects.requireNonNull(...), and a growing parameter list is an early sign of too many responsibilities.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dependency-injection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A missing/null dependency can be caught immediately, at object construction, with something like Objects.requireNonNull(...).$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$A constructor parameter list that creeps up to five or six is an early, visible sign the class has taken on too many responsibilities.$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It requires the least code to write, with no constructor or setter needed at all.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It's the only injection style Spring supports for classes with more than one dependency.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu ders, constructor injection'ın varsayılan olarak önerilmesi için hangi gerekçeleri verir? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Eksik/null bir bağımlılık, Objects.requireNonNull(...) ile nesne inşa edilirken hemen yakalanabilir, ve büyüyen bir parametre listesi çok fazla sorumluluğun erken bir işaretidir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dependency-injection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Birden fazla bağımlılığı olan sınıflar için Spring'in desteklediği tek injection tarzıdır.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Eksik/null bir bağımlılık, nesne inşa edilirken, Objects.requireNonNull(...) gibi bir şeyle hemen yakalanabilir.$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Beş ya da altıya çıkan bir constructor parametre listesi, sınıfın çok fazla sorumluluk üstlendiğinin erken, görünür bir işaretidir.$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Hiç constructor ya da setter yazmaya gerek olmadığı için en az kod yazmayı gerektirir.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson's Common Mistakes, what is a mistaken assumption about Dependency Injection?$$,
           NULL, NULL,
           $$Assuming DI is a Spring-specific concept is a mistake -- DI is a design idea that works with no framework at all, as the composition-root example shows.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dependency-injection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Assuming DI requires at least three dependencies to be worthwhile.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Assuming DI eliminates the need for any testing at all.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Assuming DI is a Spring-specific concept -- DI is a design idea that works with no framework at all, as the composition-root example shows.$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Assuming DI can only be applied to interfaces, never to concrete classes.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin Yaygın Hatalar bölümüne göre, Dependency Injection hakkında yanlış bir varsayım nedir?$$,
           NULL, NULL,
           $$DI'nin Spring'e özgü bir kavram olduğunu varsaymak bir hatadır -- composition-root örneğinin gösterdiği gibi, DI hiçbir framework olmadan da çalışan bir tasarım fikridir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dependency-injection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$DI'nin yalnızca interface'lere uygulanabileceğini, somut sınıflara asla uygulanamayacağını varsaymak.$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$DI'nin değmeye değer olması için en az üç bağımlılık gerektirdiğini varsaymak.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$DI'nin her türlü testi gereksiz kıldığını varsaymak.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$DI'nin Spring'e özgü bir kavram olduğunu varsaymak -- composition-root örneğinin gösterdiği gibi, DI hiçbir framework olmadan da çalışan bir tasarım fikridir.$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class FakeNotificationSender implements NotificationSender {
    List<String> sentMessages = new ArrayList<>();
    public void send(String message) { sentMessages.add(message); }
}

public class Demo {
    public static void main(String[] args) {
        FakeNotificationSender fake = new FakeNotificationSender();
        OrderService service = new OrderService(fake, "MyStore");
        service.placeOrder("Book");
        System.out.println(fake.sentMessages.size());
    }
}$$, $$java$$,
           $$A fake NotificationSender that just records what it was asked to send lets the test verify OrderService's behavior with no real network call -- placeOrder(...) calls send(...) once, so sentMessages ends up with one entry.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dependency-injection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$1$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$0$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Compile error -- FakeNotificationSender can't implement NotificationSender without a real email connection.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$It throws a NullPointerException, since fake is not a real sender.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class SahteBildirimGonderici implements BildirimGonderici {
    List<String> gonderilenMesajlar = new ArrayList<>();
    public void gonder(String mesaj) { gonderilenMesajlar.add(mesaj); }
}

public class Ornek {
    public static void main(String[] args) {
        SahteBildirimGonderici sahte = new SahteBildirimGonderici();
        SiparisServisi servis = new SiparisServisi(sahte, "MagazaAdi");
        servis.siparisVer("Kitap");
        System.out.println(sahte.gonderilenMesajlar.size());
    }
}$$, $$java$$,
           $$Yalnızca ne göndermesi istendiğini kaydeden sahte bir BildirimGonderici, testin gerçek bir ağ çağrısı olmadan SiparisServisi'nin davranışını doğrulamasını sağlar -- siparisVer(...), gonder(...)'i bir kez çağırır, bu yüzden gonderilenMesajlar'da bir kayıt olur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dependency-injection'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$sahte gerçek bir gonderici olmadığı için NullPointerException fırlatır.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$1$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$0$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Derleme hatası -- SahteBildirimGonderici, gerçek bir e-posta bağlantısı olmadan BildirimGonderici implement edemez.$$, FALSE, 3 FROM new_question_tr7;
