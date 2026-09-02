-- Promotion-style migration linking EN spring-ioc-container quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-ioc-container')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print? (Assume AppConfig has a @Bean method that returns `new Widget()`.)$$
      AND code_snippet = $$class Widget {
    Widget() { System.out.println("Widget constructed"); }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println("before context");
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        System.out.println("after context");
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = 'spring-ioc-container'
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
    ($$before context / Widget constructed / after context$$, TRUE, 0),
    ($$before context / after context / Widget constructed$$, FALSE, 1),
    ($$Widget constructed / before context / after context$$, FALSE, 2),
    ($$before context / after context (Widget is never constructed, since getBean was never called)$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-ioc-container'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-ioc-container')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does it mean that `BeanFactory` is "lazy"?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does it mean that `BeanFactory` is "lazy"?$$,
           NULL, NULL,
           $$Registering a bean definition does not create the object -- the object is only created when it's actually requested with getBean(...).$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-ioc-container'
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
    ($$BeanFactory creates every bean twice, once lazily and once eagerly.$$, FALSE, 0),
    ($$BeanFactory never actually creates any objects at all.$$, FALSE, 1),
    ($$Registering a bean definition does not create the object -- the object is only created when it's actually requested with getBean(...).$$, TRUE, 2),
    ($$BeanFactory delays reading bean definitions until the application shuts down.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-ioc-container'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-ioc-container')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, what is the correct order of a bean's lifecycle steps?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what is the correct order of a bean's lifecycle steps?$$,
           NULL, NULL,
           $$The order is: constructor runs, dependencies are set, BeanPostProcessor (before) runs, @PostConstruct runs, then BeanPostProcessor (after) runs and the bean is ready.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-ioc-container'
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
    ($$Constructor runs -> dependencies are set -> BeanPostProcessor (before) -> @PostConstruct -> BeanPostProcessor (after) -> ready for use.$$, TRUE, 0),
    ($$@PostConstruct -> Constructor runs -> dependencies are set -> ready for use.$$, FALSE, 1),
    ($$Constructor runs -> @PostConstruct -> dependencies are set -> ready for use.$$, FALSE, 2),
    ($$BeanPostProcessor (after) -> Constructor runs -> dependencies are set -> @PostConstruct.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-ioc-container'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-ioc-container')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does this lesson recommend `@PostConstruct`/`@PreDestroy` over implementing `InitializingBean`/`DisposableBean`?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Why does this lesson recommend `@PostConstruct`/`@PreDestroy` over implementing `InitializingBean`/`DisposableBean`?$$,
           NULL, NULL,
           $$The annotation-based approach gives the same guarantee without making the class dependent on Spring, since the annotations come from jakarta.annotation, not Spring itself -- a class implementing InitializingBean/DisposableBean won't even compile without the container on the classpath.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-ioc-container'
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
    ($$@PostConstruct/@PreDestroy run earlier in the lifecycle than the interface-based approach.$$, FALSE, 0),
    ($$InitializingBean/DisposableBean only work with prototype-scoped beans.$$, FALSE, 1),
    ($$The annotation-based approach gives the same guarantee without making the class dependent on Spring, since the annotations come from jakarta.annotation, not Spring itself.$$, TRUE, 2),
    ($$InitializingBean/DisposableBean are deprecated and no longer compile.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-ioc-container'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-ioc-container')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print? (Assume `Counter` is registered as a plain @Bean with no @Scope, so it's the default scope.)$$
      AND code_snippet = $$class Counter {
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
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = 'spring-ioc-container'
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
    ($$true$$, TRUE, 0),
    ($$false$$, FALSE, 1),
    ($$Compile error.$$, FALSE, 2),
    ($$It throws an exception, since Counter has no explicit constructor.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-ioc-container'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-ioc-container')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does putting `@Lazy` on a singleton bean's definition change?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does putting `@Lazy` on a singleton bean's definition change?$$,
           NULL, NULL,
           $$The bean is only created the first time it's actually requested with getBean(...), instead of eagerly when the context refreshes.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-ioc-container'
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
    ($$The bean's @PreDestroy method is called immediately at startup.$$, FALSE, 0),
    ($$The bean is created twice -- once lazily, once eagerly.$$, FALSE, 1),
    ($$The bean is only created the first time it's actually requested with getBean(...), instead of eagerly when the context refreshes.$$, TRUE, 2),
    ($$The bean becomes prototype-scoped instead of singleton.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-ioc-container'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-ioc-container')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true, according to this lesson? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$A circular dependency between two constructor-injected beans results in BeanCurrentlyInCreationException, wrapped in a BeanCreationException. Defining two beans of the same type and calling getBean(Type.class) throws NoUniqueBeanDefinitionException, since the container never guesses.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-ioc-container'
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
    ($$A circular dependency between two constructor-injected beans results in a BeanCurrentlyInCreationException, wrapped in a BeanCreationException.$$, TRUE, 0),
    ($$Defining two beans of the same interface type and calling getBean(Type.class) throws NoUniqueBeanDefinitionException, since the container never guesses which one you want.$$, TRUE, 1),
    ($$The container automatically resolves a circular dependency by picking whichever bean was defined first.$$, FALSE, 2),
    ($$NoUniqueBeanDefinitionException only occurs with prototype-scoped beans.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-ioc-container'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
