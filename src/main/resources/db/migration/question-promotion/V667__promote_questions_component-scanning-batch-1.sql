-- Promotion batch
-- Topic: component-scanning (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V631-V655 (functional interfaces & streams) and
-- V615-V627 (OOP), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/component-scanning.md and
-- content/tr/component-scanning.md.
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
           $$What does this print? (`AppConfig` carries `@ComponentScan` and lives in the same package as `GreetingProvider`.)$$,
           $$@Service
class GreetingProvider {
    String greet() { return "hello"; }
}

@Configuration
@ComponentScan
class AppConfig { }

public class Demo {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        GreetingProvider provider = context.getBean(GreetingProvider.class);
        System.out.println(provider.greet());
    }
}$$, $$java$$,
           $$GreetingProvider has no @Bean method at all -- @ComponentScan on AppConfig scans AppConfig's own package (where GreetingProvider also lives) and automatically registers every @Component-derived class it finds, including @Service.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-scanning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$hello$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Compile error -- GreetingProvider needs an explicit @Bean method to be registered.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It throws NoSuchBeanDefinitionException, since @Service alone doesn't register a bean.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$null$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır? (`AppConfig`, `@ComponentScan` taşır ve `SelamlamaSaglayicisi` ile aynı pakette yer alır.)$$,
           $$@Service
class SelamlamaSaglayicisi {
    String selamla() { return "merhaba"; }
}

@Configuration
@ComponentScan
class AppConfig { }

public class Ornek {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        SelamlamaSaglayicisi saglayici = context.getBean(SelamlamaSaglayicisi.class);
        System.out.println(saglayici.selamla());
    }
}$$, $$java$$,
           $$SelamlamaSaglayicisi'nin hiç @Bean metodu yoktur -- AppConfig üzerindeki @ComponentScan, AppConfig'in kendi paketini (SelamlamaSaglayicisi'nin de yaşadığı yeri) tarar ve bulduğu her @Component türevi sınıfı, @Service dahil, otomatik olarak kaydeder.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-scanning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$null$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$merhaba$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Derleme hatası -- SelamlamaSaglayicisi'nin kaydedilmek için açık bir @Bean metoduna ihtiyacı var.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$NoSuchBeanDefinitionException fırlatır, çünkü @Service tek başına bir bean kaydetmez.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$As far as the container is concerned, what is the difference in scanning/registration between `@Service` and plain `@Component`?$$,
           NULL, NULL,
           $$There is no difference -- @Service, @Repository, and @Controller all carry @Component underneath and are scanned/registered identically; they only add meaning for the reader.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-scanning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@Component can only be used on interfaces, @Service only on classes.$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$@Service requires an explicit @ComponentScan, while @Component doesn't.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$There is no difference -- @Service, @Repository, and @Controller all carry @Component underneath and are scanned/registered identically.$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$@Service beans are created eagerly, while @Component beans are created lazily.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Container açısından, `@Service` ile düz `@Component` arasında tarama/kayıt bakımından ne fark vardır?$$,
           NULL, NULL,
           $$Hiçbir fark yoktur -- @Service, @Repository ve @Controller'ın hepsi altta @Component taşır ve birebir aynı şekilde taranıp kaydedilir; yalnızca okuyucu için anlam katarlar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-scanning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@Service bean'leri eager oluşturulurken @Component bean'leri lazy oluşturulur.$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$@Component yalnızca interface'lerde, @Service yalnızca sınıflarda kullanılabilir.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$@Service açık bir @ComponentScan gerektirirken @Component gerektirmez.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Hiçbir fark yoktur -- @Service, @Repository ve @Controller'ın hepsi altta @Component taşır ve birebir aynı şekilde taranıp kaydedilir.$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$If `@ComponentScan` is given no arguments at all, which packages does it scan?$$,
           NULL, NULL,
           $$With no arguments, @ComponentScan scans the @Configuration class's own package, and its subpackages.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-scanning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The @Configuration class's own package, and its subpackages.$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$The entire classpath, including all third-party libraries.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Only the exact package the @ComponentScan annotation's class is in, never subpackages.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$No packages at all -- arguments are always required.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`@ComponentScan`'e hiç argüman verilmezse, hangi paketleri tarar?$$,
           NULL, NULL,
           $$Hiç argüman verilmediğinde, @ComponentScan, @Configuration sınıfının kendi paketini ve alt paketlerini tarar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-scanning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbir paketi -- argüman her zaman zorunludur.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$@Configuration sınıfının kendi paketini ve onun alt paketlerini.$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Tüm classpath'i, üçüncü parti kütüphaneler dahil.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca @ComponentScan annotation'ının bulunduğu sınıfın tam paketini, alt paketleri asla.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens after context startup with this bean? (Assume `OrderService` is otherwise correctly scanned and registered.)$$,
           $$@Component
class OrderService {
    private NotificationSender sender;

    void setSender(NotificationSender sender) {
        this.sender = sender;
    }
}$$, $$java$$,
           $$@Autowired on the setter is required -- Spring has no way of knowing which setter is meant for injection, so an unmarked setter is never called automatically. sender stays null after context startup.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-scanning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The application fails to start with a NoSuchBeanDefinitionException.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Spring calls setSender(...) with a null argument explicitly.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$sender remains null -- Spring never calls an unmarked setter automatically.$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Spring calls setSender(...) automatically anyway, since there's only one setter.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Context başladıktan sonra bu bean'e ne olur? (`SiparisServisi`'nin bunun dışında doğru şekilde tarandığını ve kaydedildiğini varsayın.)$$,
           $$@Component
class SiparisServisi {
    private BildirimGonderici gonderici;

    void setGonderici(BildirimGonderici gonderici) {
        this.gonderici = gonderici;
    }
}$$, $$java$$,
           $$Setter üzerinde @Autowired zorunludur -- Spring hangi setter'ın injection için olduğunu bilemez, bu yüzden işaretlenmemiş bir setter asla otomatik çağrılmaz. Context başladıktan sonra gonderici null kalır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-scanning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring, tek bir setter olduğu için setGonderici(...)'yi yine de otomatik çağırır.$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Uygulama NoSuchBeanDefinitionException ile başlamayı başaramaz.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Spring, setGonderici(...)'yi açıkça null argümanla çağırır.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$gonderici null kalır -- Spring işaretlenmemiş bir setter'ı asla otomatik çağırmaz.$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does `@Qualifier("emailSender")` on a constructor parameter do, when two `NotificationSender` beans exist?$$,
           NULL, NULL,
           $$It tells Spring to pick, among the NotificationSender-typed candidates, the one whose bean name is exactly "emailSender".$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-scanning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It tells Spring to pick, among the NotificationSender-typed candidates, the one whose bean name is exactly "emailSender".$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It tells Spring to create a brand-new bean named "emailSender" on the spot.$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It disables dependency injection for that specific parameter.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It merges both NotificationSender beans into one combined instance.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$İki `BildirimGonderici` bean'i varken, bir constructor parametresi üzerindeki `@Qualifier("emailGonderici")` ne yapar?$$,
           NULL, NULL,
           $$Spring'e, BildirimGonderici tipindeki adaylar arasından bean adı tam olarak "emailGonderici" olanı seçmesini söyler.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-scanning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İki BildirimGonderici bean'ini tek bir birleşik instance'a birleştirir.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Spring'e, BildirimGonderici tipindeki adaylar arasından bean adı tam olarak "emailGonderici" olanı seçmesini söyler.$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Spring'e o anda "emailGonderici" adında yepyeni bir bean oluşturmasını söyler.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$O belirli parametre için dependency injection'ı devre dışı bırakır.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$interface NotificationSender { }

@Component @Primary
class EmailNotificationSender implements NotificationSender { }

@Component
class SmsNotificationSender implements NotificationSender { }

@Component
class EmailOnlyService {
    EmailOnlyService(NotificationSender sender) {
        System.out.println(sender.getClass().getSimpleName());
    }
}

@Component
class SmsOnlyService {
    SmsOnlyService(@Qualifier("smsNotificationSender") NotificationSender sender) {
        System.out.println(sender.getClass().getSimpleName());
    }
}$$, $$java$$,
           $$EmailOnlyService has no @Qualifier, so it gets the @Primary bean (EmailNotificationSender). SmsOnlyService explicitly requests "smsNotificationSender" via @Qualifier, so @Primary doesn't matter there -- an explicit @Qualifier always wins.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-scanning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The application fails to start with NoUniqueBeanDefinitionException for both services.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Both print "SmsNotificationSender".$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$EmailOnlyService prints "EmailNotificationSender"; SmsOnlyService prints "SmsNotificationSender".$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Both print "EmailNotificationSender", since @Primary always wins regardless of @Qualifier.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$interface BildirimGonderici { }

@Component @Primary
class EmailBildirimGonderici implements BildirimGonderici { }

@Component
class SmsBildirimGonderici implements BildirimGonderici { }

@Component
class SadeceEmailServisi {
    SadeceEmailServisi(BildirimGonderici gonderici) {
        System.out.println(gonderici.getClass().getSimpleName());
    }
}

@Component
class SadeceSmsServisi {
    SadeceSmsServisi(@Qualifier("smsBildirimGonderici") BildirimGonderici gonderici) {
        System.out.println(gonderici.getClass().getSimpleName());
    }
}$$, $$java$$,
           $$SadeceEmailServisi'nin hiç @Qualifier'ı yok, bu yüzden @Primary bean'ini (EmailBildirimGonderici) alır. SadeceSmsServisi ise @Qualifier ile açıkça "smsBildirimGonderici"yi ister, bu yüzden orada @Primary'nin bir önemi yoktur -- açık bir @Qualifier her zaman kazanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-scanning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İkisi de "EmailBildirimGonderici" yazdırır, çünkü @Primary her zaman @Qualifier'a karşı kazanır.$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Uygulama, her iki servis için de NoUniqueBeanDefinitionException ile başlayamaz.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$İkisi de "SmsBildirimGonderici" yazdırır.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$SadeceEmailServisi "EmailBildirimGonderici" yazdırır; SadeceSmsServisi "SmsBildirimGonderici" yazdırır.$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, which of the following are true about choosing between component scanning and Java Config? (Select all that apply)$$,
           NULL, NULL,
           $$Component scanning is ideal for your own classes; Java Config is necessary for third-party classes or classes with non-bean constructor parameters like an API key.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-scanning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Component scanning is ideal for classes you wrote yourself, since you have access to the source.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Java Config is necessary for third-party classes you don't have source access to, or classes whose constructor takes non-bean parameters like an API key.$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Java Config completely replaces component scanning in real applications -- they're never used together.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Component scanning can be used on any class at all, including third-party library classes.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, component scanning ile Java Config arasında seçim yapmakla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Component scanning kendi sınıfların için idealdir; Java Config, üçüncü parti sınıflar ya da bir API anahtarı gibi bean olmayan constructor parametreleri alan sınıflar için gereklidir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-scanning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Component scanning, üçüncü parti kütüphane sınıfları dahil, herhangi bir sınıfta kullanılabilir.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Component scanning, kendi yazdığın sınıflar için idealdir, çünkü kaynak koduna erişimin vardır.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Java Config, kaynak koduna erişimin olmadığı üçüncü parti sınıflar için ya da constructor'ı bir API anahtarı gibi bean olmayan parametreler alan sınıflar için gereklidir.$$, TRUE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Java Config, gerçek uygulamalarda component scanning'in yerini tamamen alır -- ikisi asla birlikte kullanılmaz.$$, FALSE, 3 FROM new_question_tr7;
