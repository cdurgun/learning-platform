-- Promotion-style migration linking EN component-scanning quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-scanning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print? (`AppConfig` carries `@ComponentScan` and lives in the same package as `GreetingProvider`.)$$
      AND code_snippet = $$@Service
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
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = 'component-scanning'
      AND NOT EXISTS (SELECT 1 FROM existing_q1)
    RETURNING id
),
target_q1 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q1
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q1
),
option_ins_q1 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q1.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q1
             CROSS JOIN (VALUES
    ($$hello$$, TRUE, 0),
    ($$Compile error -- GreetingProvider needs an explicit @Bean method to be registered.$$, FALSE, 1),
    ($$It throws NoSuchBeanDefinitionException, since @Service alone doesn't register a bean.$$, FALSE, 2),
    ($$null$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-scanning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-scanning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$As far as the container is concerned, what is the difference in scanning/registration between `@Service` and plain `@Component`?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$As far as the container is concerned, what is the difference in scanning/registration between `@Service` and plain `@Component`?$$,
           NULL, NULL,
           $$There is no difference -- @Service, @Repository, and @Controller all carry @Component underneath and are scanned/registered identically; they only add meaning for the reader.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-scanning'
      AND NOT EXISTS (SELECT 1 FROM existing_q2)
    RETURNING id
),
target_q2 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q2
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q2
),
option_ins_q2 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q2.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q2
             CROSS JOIN (VALUES
    ($$@Component can only be used on interfaces, @Service only on classes.$$, FALSE, 0),
    ($$@Service requires an explicit @ComponentScan, while @Component doesn't.$$, FALSE, 1),
    ($$There is no difference -- @Service, @Repository, and @Controller all carry @Component underneath and are scanned/registered identically.$$, TRUE, 2),
    ($$@Service beans are created eagerly, while @Component beans are created lazily.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-scanning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-scanning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$If `@ComponentScan` is given no arguments at all, which packages does it scan?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$If `@ComponentScan` is given no arguments at all, which packages does it scan?$$,
           NULL, NULL,
           $$With no arguments, @ComponentScan scans the @Configuration class's own package, and its subpackages.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-scanning'
      AND NOT EXISTS (SELECT 1 FROM existing_q3)
    RETURNING id
),
target_q3 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q3
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q3
),
option_ins_q3 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q3.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q3
             CROSS JOIN (VALUES
    ($$The @Configuration class's own package, and its subpackages.$$, TRUE, 0),
    ($$The entire classpath, including all third-party libraries.$$, FALSE, 1),
    ($$Only the exact package the @ComponentScan annotation's class is in, never subpackages.$$, FALSE, 2),
    ($$No packages at all -- arguments are always required.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-scanning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-scanning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens after context startup with this bean? (Assume `OrderService` is otherwise correctly scanned and registered.)$$
      AND code_snippet = $$@Component
class OrderService {
    private NotificationSender sender;

    void setSender(NotificationSender sender) {
        this.sender = sender;
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = 'component-scanning'
      AND NOT EXISTS (SELECT 1 FROM existing_q4)
    RETURNING id
),
target_q4 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q4
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q4
),
option_ins_q4 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q4.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q4
             CROSS JOIN (VALUES
    ($$The application fails to start with a NoSuchBeanDefinitionException.$$, FALSE, 0),
    ($$Spring calls setSender(...) with a null argument explicitly.$$, FALSE, 1),
    ($$sender remains null -- Spring never calls an unmarked setter automatically.$$, TRUE, 2),
    ($$Spring calls setSender(...) automatically anyway, since there's only one setter.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-scanning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-scanning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does `@Qualifier("emailSender")` on a constructor parameter do, when two `NotificationSender` beans exist?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does `@Qualifier("emailSender")` on a constructor parameter do, when two `NotificationSender` beans exist?$$,
           NULL, NULL,
           $$It tells Spring to pick, among the NotificationSender-typed candidates, the one whose bean name is exactly "emailSender".$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-scanning'
      AND NOT EXISTS (SELECT 1 FROM existing_q5)
    RETURNING id
),
target_q5 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q5
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q5
),
option_ins_q5 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q5.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q5
             CROSS JOIN (VALUES
    ($$It tells Spring to pick, among the NotificationSender-typed candidates, the one whose bean name is exactly "emailSender".$$, TRUE, 0),
    ($$It tells Spring to create a brand-new bean named "emailSender" on the spot.$$, FALSE, 1),
    ($$It disables dependency injection for that specific parameter.$$, FALSE, 2),
    ($$It merges both NotificationSender beans into one combined instance.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-scanning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-scanning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$interface NotificationSender { }

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
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = 'component-scanning'
      AND NOT EXISTS (SELECT 1 FROM existing_q6)
    RETURNING id
),
target_q6 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q6
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q6
),
option_ins_q6 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q6.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q6
             CROSS JOIN (VALUES
    ($$The application fails to start with NoUniqueBeanDefinitionException for both services.$$, FALSE, 0),
    ($$Both print "SmsNotificationSender".$$, FALSE, 1),
    ($$EmailOnlyService prints "EmailNotificationSender"; SmsOnlyService prints "SmsNotificationSender".$$, TRUE, 2),
    ($$Both print "EmailNotificationSender", since @Primary always wins regardless of @Qualifier.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-scanning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-scanning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, which of the following are true about choosing between component scanning and Java Config? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, which of the following are true about choosing between component scanning and Java Config? (Select all that apply)$$,
           NULL, NULL,
           $$Component scanning is ideal for your own classes; Java Config is necessary for third-party classes or classes with non-bean constructor parameters like an API key.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-scanning'
      AND NOT EXISTS (SELECT 1 FROM existing_q7)
    RETURNING id
),
target_q7 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q7
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q7
),
option_ins_q7 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q7.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q7
             CROSS JOIN (VALUES
    ($$Component scanning is ideal for classes you wrote yourself, since you have access to the source.$$, TRUE, 0),
    ($$Java Config is necessary for third-party classes you don't have source access to, or classes whose constructor takes non-bean parameters like an API key.$$, TRUE, 1),
    ($$Java Config completely replaces component scanning in real applications -- they're never used together.$$, FALSE, 2),
    ($$Component scanning can be used on any class at all, including third-party library classes.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-scanning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
