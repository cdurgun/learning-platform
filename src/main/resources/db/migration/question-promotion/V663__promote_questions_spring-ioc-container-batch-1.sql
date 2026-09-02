-- Promotion batch
-- Topic: spring-ioc-container (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V631-V655 (functional interfaces & streams) and
-- V615-V627 (OOP), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/spring-ioc-container.md and
-- content/tr/spring-ioc-container.md.
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
           $$What does this print? (Assume AppConfig has a @Bean method that returns `new Widget()`.)$$,
           $$class Widget {
    Widget() { System.out.println("Widget constructed"); }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println("before context");
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        System.out.println("after context");
    }
}$$, $$java$$,
           $$ApplicationContext creates singleton beans eagerly, the moment the context is built, instead of lazily -- so Widget's constructor runs during AnnotationConfigApplicationContext's own construction, before "after context" prints.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-ioc-container'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$before context / Widget constructed / after context$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$before context / after context / Widget constructed$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Widget constructed / before context / after context$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$before context / after context (Widget is never constructed, since getBean was never called)$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır? (AppConfig'in `new Bilesen()` döndüren bir @Bean metodu olduğunu varsayın.)$$,
           $$class Bilesen {
    Bilesen() { System.out.println("Bilesen olusturuldu"); }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println("context oncesi");
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        System.out.println("context sonrasi");
    }
}$$, $$java$$,
           $$ApplicationContext, singleton bean'leri lazy değil, context inşa edilir edilmez eager olarak oluşturur -- bu yüzden Bilesen'in constructor'ı, AnnotationConfigApplicationContext'in kendi inşası sırasında, "context sonrasi" yazdırılmadan önce çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-ioc-container'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$context oncesi / context sonrasi (Bilesen hiç oluşturulmaz, çünkü getBean hiç çağrılmadı)$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$context oncesi / Bilesen olusturuldu / context sonrasi$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$context oncesi / context sonrasi / Bilesen olusturuldu$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Bilesen olusturuldu / context oncesi / context sonrasi$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does it mean that `BeanFactory` is "lazy"?$$,
           NULL, NULL,
           $$Registering a bean definition does not create the object -- the object is only created when it's actually requested with getBean(...).$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-ioc-container'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$BeanFactory creates every bean twice, once lazily and once eagerly.$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$BeanFactory never actually creates any objects at all.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Registering a bean definition does not create the object -- the object is only created when it's actually requested with getBean(...).$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$BeanFactory delays reading bean definitions until the application shuts down.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`BeanFactory`'nin "lazy" olması ne anlama gelir?$$,
           NULL, NULL,
           $$Bir bean tanımı kaydetmek nesneyi oluşturmaz -- nesne yalnızca getBean(...) ile gerçekten istendiğinde oluşturulur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-ioc-container'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$BeanFactory, bean tanımlarını okumayı uygulama kapanana kadar erteler.$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$BeanFactory her bean'i iki kez oluşturur, biri lazy biri eager.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$BeanFactory hiçbir zaman gerçekten hiçbir nesne oluşturmaz.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir bean tanımı kaydetmek nesneyi oluşturmaz -- nesne yalnızca getBean(...) ile gerçekten istendiğinde oluşturulur.$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what is the correct order of a bean's lifecycle steps?$$,
           NULL, NULL,
           $$The order is: constructor runs, dependencies are set, BeanPostProcessor (before) runs, @PostConstruct runs, then BeanPostProcessor (after) runs and the bean is ready.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-ioc-container'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Constructor runs -> dependencies are set -> BeanPostProcessor (before) -> @PostConstruct -> BeanPostProcessor (after) -> ready for use.$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$@PostConstruct -> Constructor runs -> dependencies are set -> ready for use.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Constructor runs -> @PostConstruct -> dependencies are set -> ready for use.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$BeanPostProcessor (after) -> Constructor runs -> dependencies are set -> @PostConstruct.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir bean'in lifecycle adımlarının doğru sırası nedir?$$,
           NULL, NULL,
           $$Sıra şöyledir: constructor çalışır, bağımlılıklar ayarlanır, BeanPostProcessor (before) çalışır, @PostConstruct çalışır, sonra BeanPostProcessor (after) çalışır ve bean hazır olur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-ioc-container'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$BeanPostProcessor (after) -> Constructor çalışır -> bağımlılıklar ayarlanır -> @PostConstruct.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Constructor çalışır -> bağımlılıklar ayarlanır -> BeanPostProcessor (before) -> @PostConstruct -> BeanPostProcessor (after) -> kullanıma hazır.$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$@PostConstruct -> Constructor çalışır -> bağımlılıklar ayarlanır -> kullanıma hazır.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Constructor çalışır -> @PostConstruct -> bağımlılıklar ayarlanır -> kullanıma hazır.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Why does this lesson recommend `@PostConstruct`/`@PreDestroy` over implementing `InitializingBean`/`DisposableBean`?$$,
           NULL, NULL,
           $$The annotation-based approach gives the same guarantee without making the class dependent on Spring, since the annotations come from jakarta.annotation, not Spring itself -- a class implementing InitializingBean/DisposableBean won't even compile without the container on the classpath.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-ioc-container'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@PostConstruct/@PreDestroy run earlier in the lifecycle than the interface-based approach.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$InitializingBean/DisposableBean only work with prototype-scoped beans.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$The annotation-based approach gives the same guarantee without making the class dependent on Spring, since the annotations come from jakarta.annotation, not Spring itself.$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$InitializingBean/DisposableBean are deprecated and no longer compile.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu ders, `InitializingBean`/`DisposableBean` implement etmek yerine `@PostConstruct`/`@PreDestroy`'u neden önerir?$$,
           NULL, NULL,
           $$Annotation tabanlı yaklaşım, sınıfı Spring'e bağımlı hale getirmeden aynı garantiyi verir, çünkü bu annotation'lar Spring'in kendisinden değil jakarta.annotation'dan gelir -- InitializingBean/DisposableBean implement eden bir sınıf, container classpath'te olmadan derlenmez bile.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-ioc-container'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$InitializingBean/DisposableBean deprecated'dır ve artık derlenmez.$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$@PostConstruct/@PreDestroy, interface tabanlı yaklaşımdan lifecycle'da daha erken çalışır.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$InitializingBean/DisposableBean yalnızca prototype scope'lu bean'lerle çalışır.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Annotation tabanlı yaklaşım, sınıfı Spring'e bağımlı hale getirmeden aynı garantiyi verir, çünkü bu annotation'lar Spring'in kendisinden değil jakarta.annotation'dan gelir.$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print? (Assume `Counter` is registered as a plain @Bean with no @Scope, so it's the default scope.)$$,
           $$class Counter {
    private int value = 0;
    void increment() { value++; }
    int getValue() { return value; }
}

public class Demo {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        Counter first = context.getBean(Counter.class);
        Counter second = context.getBean(Counter.class);
        first.increment();
        System.out.println(first.getValue() == second.getValue());
    }
}$$, $$java$$,
           $$The default scope (with no @Scope specified) is singleton -- one instance per container. first and second point to the same object, so incrementing first also changes what second sees.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-ioc-container'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$true$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$false$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Compile error.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It throws an exception, since Counter has no explicit constructor.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır? (`Sayac`'ın hiç @Scope belirtilmeden düz bir @Bean olarak kaydedildiğini, yani varsayılan scope'ta olduğunu varsayın.)$$,
           $$class Sayac {
    private int deger = 0;
    void artir() { deger++; }
    int getDeger() { return deger; }
}

public class Ornek {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        Sayac birinci = context.getBean(Sayac.class);
        Sayac ikinci = context.getBean(Sayac.class);
        birinci.artir();
        System.out.println(birinci.getDeger() == ikinci.getDeger());
    }
}$$, $$java$$,
           $$Varsayılan scope (hiç @Scope belirtilmezse) singleton'dır -- container başına bir instance. birinci ve ikinci aynı nesneyi işaret eder, bu yüzden birinci'yi artırmak ikinci'nin gördüğü değeri de değiştirir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-ioc-container'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sayac'ın açık bir constructor'ı olmadığı için istisna fırlatır.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$true$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$false$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Derleme hatası.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does putting `@Lazy` on a singleton bean's definition change?$$,
           NULL, NULL,
           $$The bean is only created the first time it's actually requested with getBean(...), instead of eagerly when the context refreshes.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-ioc-container'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The bean's @PreDestroy method is called immediately at startup.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$The bean is created twice -- once lazily, once eagerly.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$The bean is only created the first time it's actually requested with getBean(...), instead of eagerly when the context refreshes.$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$The bean becomes prototype-scoped instead of singleton.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir singleton bean tanımına `@Lazy` koymak neyi değiştirir?$$,
           NULL, NULL,
           $$Bean, context refresh olduğunda değil, yalnızca getBean(...) ile gerçekten ilk istendiğinde oluşturulur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-ioc-container'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bean, singleton yerine prototype scope'lu hale gelir.$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bean'in @PreDestroy metodu başlangıçta hemen çağrılır.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bean iki kez oluşturulur -- biri lazy biri eager.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Bean, context refresh olduğunda değil, yalnızca getBean(...) ile gerçekten ilk istendiğinde oluşturulur.$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$A circular dependency between two constructor-injected beans results in BeanCurrentlyInCreationException, wrapped in a BeanCreationException. Defining two beans of the same type and calling getBean(Type.class) throws NoUniqueBeanDefinitionException, since the container never guesses.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-ioc-container'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A circular dependency between two constructor-injected beans results in a BeanCurrentlyInCreationException, wrapped in a BeanCreationException.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Defining two beans of the same interface type and calling getBean(Type.class) throws NoUniqueBeanDefinitionException, since the container never guesses which one you want.$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$The container automatically resolves a circular dependency by picking whichever bean was defined first.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$NoUniqueBeanDefinitionException only occurs with prototype-scoped beans.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$İki constructor-injected bean arasındaki bir circular dependency, bir BeanCreationException içine sarılmış BeanCurrentlyInCreationException ile sonuçlanır. Aynı türden iki bean tanımlayıp getBean(Type.class) çağırmak, container hiçbir zaman tahmin etmediği için NoUniqueBeanDefinitionException fırlatır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-ioc-container'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$NoUniqueBeanDefinitionException yalnızca prototype scope'lu bean'lerde oluşur.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$İki constructor-injected bean arasındaki bir circular dependency, bir BeanCreationException içine sarılmış bir BeanCurrentlyInCreationException ile sonuçlanır.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Aynı interface türünden iki bean tanımlamak ve getBean(Type.class) çağırmak, container hiçbir zaman hangisini istediğini tahmin etmediği için NoUniqueBeanDefinitionException fırlatır.$$, TRUE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Container, bir circular dependency'yi hangi bean önce tanımlandıysa onu seçerek otomatik olarak çözer.$$, FALSE, 3 FROM new_question_tr7;
