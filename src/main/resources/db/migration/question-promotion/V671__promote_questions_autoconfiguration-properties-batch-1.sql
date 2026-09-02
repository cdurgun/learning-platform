-- Promotion batch
-- Topic: autoconfiguration-properties (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V631-V655 (functional interfaces & streams) and
-- V615-V627 (OOP), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/autoconfiguration-properties.md and
-- content/tr/autoconfiguration-properties.md.
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

-- Pair 1 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why can't component scanning alone register a bean like `DataSource` or `EntityManagerFactory`?$$,
           NULL, NULL,
           $$These are classes from third-party libraries that the application doesn't own the source of, so @Component can't be added to them -- auto-configuration exists to handle exactly this case.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'autoconfiguration-properties'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$These are classes from third-party libraries that the application doesn't own the source of, so @Component can't be added to them.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$DataSource and EntityManagerFactory are abstract classes that can never be instantiated under any circumstance.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Component scanning only works for classes with exactly one constructor parameter.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$These beans require a database connection to even be scanned.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Component scanning tek başına neden `DataSource` ya da `EntityManagerFactory` gibi bir bean'i kaydedemez?$$,
           NULL, NULL,
           $$Bunlar, uygulamanın kaynak koduna sahip olmadığı üçüncü parti kütüphane sınıflarıdır, bu yüzden onlara @Component eklenemez -- auto-configuration tam olarak bu durumu ele almak için vardır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'autoconfiguration-properties'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu bean'ler taranabilmek için bir veritabanı bağlantısı gerektirir.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Bunlar, uygulamanın kaynak koduna sahip olmadığı üçüncü parti kütüphane sınıflarıdır, bu yüzden onlara @Component eklenemez.$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$DataSource ve EntityManagerFactory, hiçbir koşulda örneklenemeyen abstract sınıflardır.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Component scanning yalnızca tam olarak bir constructor parametresi olan sınıflarla çalışır.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`@SpringBootApplication` is actually a combination of which three annotations?$$,
           NULL, NULL,
           $$@SpringBootApplication combines @SpringBootConfiguration, @EnableAutoConfiguration, and @ComponentScan.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'autoconfiguration-properties'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@Component, @Service, and @Repository.$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$@Conditional, @ConditionalOnClass, and @ConditionalOnMissingBean.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$@SpringBootConfiguration, @EnableAutoConfiguration, and @ComponentScan.$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$@Configuration, @Bean, and @Autowired.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`@SpringBootApplication`, aslında hangi üç annotation'ın birleşimidir?$$,
           NULL, NULL,
           $$@SpringBootApplication, @SpringBootConfiguration, @EnableAutoConfiguration ve @ComponentScan'i birleştirir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'autoconfiguration-properties'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@Configuration, @Bean ve @Autowired.$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$@Component, @Service ve @Repository.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$@Conditional, @ConditionalOnClass ve @ConditionalOnMissingBean.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$@SpringBootConfiguration, @EnableAutoConfiguration ve @ComponentScan.$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens with these two bean definitions? (Assume `ObjectMapper` really is on the classpath, via `spring-boot-starter-web`.)$$,
           $$@Configuration
class MyAutoConfiguration {
    @Bean
    @ConditionalOnClass(name = "com.fasterxml.jackson.databind.ObjectMapper")
    JacksonHelper jacksonHelper() { return new JacksonHelper(); }

    @Bean
    @ConditionalOnClass(name = "com.made.up.NonExistentLibrary")
    FakeHelper fakeHelper() { return new FakeHelper(); }
}$$, $$java$$,
           $$@ConditionalOnClass registers a bean only if the given class is on the classpath. ObjectMapper really is present, so jacksonHelper is registered; NonExistentLibrary isn't, so fakeHelper is silently skipped, with no exception.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'autoconfiguration-properties'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$jacksonHelper is registered as a bean; fakeHelper is silently skipped, with no exception thrown.$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Both beans are registered normally.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$The application fails to start with a ClassNotFoundException for FakeHelper.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Neither bean is registered, since @ConditionalOnClass requires @ConditionalOnMissingBean too.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu iki bean tanımında ne olur? (`ObjectMapper`'ın `spring-boot-starter-web` üzerinden gerçekten classpath'te olduğunu varsayın.)$$,
           $$@Configuration
class BenimAutoConfigurationim {
    @Bean
    @ConditionalOnClass(name = "com.fasterxml.jackson.databind.ObjectMapper")
    JacksonYardimcisi jacksonYardimcisi() { return new JacksonYardimcisi(); }

    @Bean
    @ConditionalOnClass(name = "com.uydurma.OlmayanKutuphane")
    SahteYardimci sahteYardimci() { return new SahteYardimci(); }
}$$, $$java$$,
           $$@ConditionalOnClass, yalnızca verilen sınıf classpath'teyse bir bean'i kaydeder. ObjectMapper gerçekten mevcuttur, bu yüzden jacksonYardimcisi kaydedilir; OlmayanKutuphane mevcut değildir, bu yüzden sahteYardimci hiçbir istisna fırlatılmadan sessizce atlanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'autoconfiguration-properties'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbir bean kaydedilmez, çünkü @ConditionalOnClass ayrıca @ConditionalOnMissingBean de gerektirir.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$jacksonYardimcisi bir bean olarak kaydedilir; sahteYardimci, hiçbir istisna fırlatılmadan sessizce atlanır.$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$İki bean de normal şekilde kaydedilir.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Uygulama, SahteYardimci için bir ClassNotFoundException ile başlayamaz.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$When both of these configurations are present, which `ObjectMapper` bean does the container end up using?$$,
           $$class ObjectMapperAutoConfig {
    @Bean
    @ConditionalOnMissingBean
    ObjectMapper objectMapper() { return new ObjectMapper(); }
}

@Configuration
class MyAppConfig {
    @Bean
    ObjectMapper objectMapper() { return new ObjectMapper().findAndRegisterModules(); }
}$$, $$java$$,
           $$Auto-configuration classes are always processed after the application's own @Configuration classes, so by the time ObjectMapperAutoConfig's @ConditionalOnMissingBean is considered, MyAppConfig's ObjectMapper bean already exists -- the auto-configuration default is skipped.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'autoconfiguration-properties'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The application fails to start with NoUniqueBeanDefinitionException, since two ObjectMapper beans are defined.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Both beans are merged into one combined ObjectMapper.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$The application's own ObjectMapper bean from MyAppConfig -- the auto-configuration default is skipped, since a bean of that type already exists.$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$The auto-configuration's default ObjectMapper -- @ConditionalOnMissingBean always wins over the user's own bean.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu iki config aynı anda mevcutken, container hangi `ObjectMapper` bean'ini kullanır?$$,
           $$class ObjectMapperOtoYapilandirmasi {
    @Bean
    @ConditionalOnMissingBean
    ObjectMapper objectMapper() { return new ObjectMapper(); }
}

@Configuration
class BenimUygulamaConfigim {
    @Bean
    ObjectMapper objectMapper() { return new ObjectMapper().findAndRegisterModules(); }
}$$, $$java$$,
           $$Auto-configuration sınıfları her zaman uygulamanın kendi @Configuration sınıflarından SONRA işlenir, bu yüzden ObjectMapperOtoYapilandirmasi'nin @ConditionalOnMissingBean'i değerlendirildiğinde BenimUygulamaConfigim'in ObjectMapper bean'i zaten mevcuttur -- auto-configuration varsayılanı atlanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'autoconfiguration-properties'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Auto-configuration'ın varsayılan ObjectMapper'ı -- @ConditionalOnMissingBean her zaman kullanıcının kendi bean'ine karşı kazanır.$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Uygulama, iki ObjectMapper bean'i tanımlandığı için NoUniqueBeanDefinitionException ile başlayamaz.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$İki bean tek bir birleşik ObjectMapper'da birleştirilir.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$BenimUygulamaConfigim'in kendi ObjectMapper bean'i -- auto-configuration'ın varsayılanı atlanır, çünkü o türden bir bean zaten var.$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about `@Value` and `@ConfigurationProperties`? (Select all that apply)$$,
           NULL, NULL,
           $$@Value injects a single property with no grouping; @ConfigurationProperties binds an entire family of properties sharing the same prefix into one typed object.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'autoconfiguration-properties'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@Value injects a single property, with no grouping at all.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$@ConfigurationProperties binds an entire family of properties sharing the same prefix into one typed object.$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$@Value can bind an entire group of related properties into one object, just like @ConfigurationProperties.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$@ConfigurationProperties can only be used for numeric property values, never strings.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`@Value` ve `@ConfigurationProperties` hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$@Value, hiçbir gruplama olmadan tek bir property'yi enjekte eder; @ConfigurationProperties, aynı prefix'i paylaşan tüm bir property ailesini tek, tipli bir nesneye bağlar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'autoconfiguration-properties'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@ConfigurationProperties yalnızca sayısal property değerleri için kullanılabilir, string'ler için asla kullanılamaz.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$@Value, hiçbir gruplama olmadan tek bir property'yi enjekte eder.$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$@ConfigurationProperties, aynı prefix'i paylaşan tüm bir property ailesini tek, tipli bir nesneye bağlar.$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$@Value, tıpkı @ConfigurationProperties gibi, ilgili property'lerin tüm bir grubunu tek bir nesneye bağlayabilir.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$From highest to lowest priority, what is the correct order of the main Spring Boot property sources?$$,
           NULL, NULL,
           $$From highest to lowest: command-line arguments, environment variables, application-{profile}.yml, and at the bottom, the base application.yml.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'autoconfiguration-properties'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Environment variables > command-line arguments > application.yml > application-{profile}.yml.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$All property sources have exactly equal priority; the last one loaded always wins.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Command-line arguments > environment variables > application-{profile}.yml > application.yml.$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$application.yml > application-{profile}.yml > environment variables > command-line arguments.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$En yüksekten en düşüğe, Spring Boot'un ana property kaynaklarının doğru öncelik sırası nedir?$$,
           NULL, NULL,
           $$En yüksekten en düşüğe: komut satırı argümanları, ortam değişkenleri, application-{profile}.yml, ve en altta temel application.yml.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'autoconfiguration-properties'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$application.yml > application-{profile}.yml > ortam değişkenleri > komut satırı argümanları.$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Ortam değişkenleri > komut satırı argümanları > application.yml > application-{profile}.yml.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Tüm property kaynaklarının önceliği tam olarak eşittir; en son yüklenen her zaman kazanır.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Komut satırı argümanları > ortam değişkenleri > application-{profile}.yml > application.yml.$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print? (The "dev" profile is activated before the context refreshes.)$$,
           $$interface Greeter { String greet(); }

@Component
@Profile("dev")
class DevGreeter implements Greeter {
    public String greet() { return "dev mode"; }
}

@Component
@Profile("prod")
class ProdGreeter implements Greeter {
    public String greet() { return "prod mode"; }
}

public class Demo {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext();
        context.getEnvironment().setActiveProfiles("dev");
        context.register(AppConfig.class);
        context.refresh();
        System.out.println(context.getBean(Greeter.class).greet());
    }
}$$, $$java$$,
           $$@Profile lets two different implementations sit side by side, with only the one matching the active profile actually registered. With "dev" active, ProdGreeter is never registered at all.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'autoconfiguration-properties'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$dev mode$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$prod mode$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$The application fails to start with NoUniqueBeanDefinitionException, since both Greeters exist.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Compile error -- @Profile can't be combined with @Component.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır? ("dev" profili, context refresh olmadan önce aktive edilir.)$$,
           $$interface Selamlayici { String selamla(); }

@Component
@Profile("dev")
class GelistirmeSelamlayicisi implements Selamlayici {
    public String selamla() { return "gelistirme modu"; }
}

@Component
@Profile("prod")
class UretimSelamlayicisi implements Selamlayici {
    public String selamla() { return "uretim modu"; }
}

public class Ornek {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext();
        context.getEnvironment().setActiveProfiles("dev");
        context.register(AppConfig.class);
        context.refresh();
        System.out.println(context.getBean(Selamlayici.class).selamla());
    }
}$$, $$java$$,
           $$@Profile, iki farklı implementasyonun yan yana durmasına izin verir, yalnızca aktif profile uyan gerçekten kaydedilir. "dev" aktifken, UretimSelamlayicisi hiç kaydedilmez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'autoconfiguration-properties'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme hatası -- @Profile, @Component ile birlikte kullanılamaz.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$gelistirme modu$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$uretim modu$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Uygulama, her iki Selamlayici de var olduğu için NoUniqueBeanDefinitionException ile başlayamaz.$$, FALSE, 3 FROM new_question_tr7;
