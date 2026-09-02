-- Promotion-style migration linking EN autoconfiguration-properties quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'autoconfiguration-properties')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why can't component scanning alone register a bean like `DataSource` or `EntityManagerFactory`?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why can't component scanning alone register a bean like `DataSource` or `EntityManagerFactory`?$$,
           NULL, NULL,
           $$These are classes from third-party libraries that the application doesn't own the source of, so @Component can't be added to them -- auto-configuration exists to handle exactly this case.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'autoconfiguration-properties'
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
    ($$These are classes from third-party libraries that the application doesn't own the source of, so @Component can't be added to them.$$, TRUE, 0),
    ($$DataSource and EntityManagerFactory are abstract classes that can never be instantiated under any circumstance.$$, FALSE, 1),
    ($$Component scanning only works for classes with exactly one constructor parameter.$$, FALSE, 2),
    ($$These beans require a database connection to even be scanned.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'autoconfiguration-properties'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'autoconfiguration-properties')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$`@SpringBootApplication` is actually a combination of which three annotations?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`@SpringBootApplication` is actually a combination of which three annotations?$$,
           NULL, NULL,
           $$@SpringBootApplication combines @SpringBootConfiguration, @EnableAutoConfiguration, and @ComponentScan.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'autoconfiguration-properties'
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
    ($$@Component, @Service, and @Repository.$$, FALSE, 0),
    ($$@Conditional, @ConditionalOnClass, and @ConditionalOnMissingBean.$$, FALSE, 1),
    ($$@SpringBootConfiguration, @EnableAutoConfiguration, and @ComponentScan.$$, TRUE, 2),
    ($$@Configuration, @Bean, and @Autowired.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'autoconfiguration-properties'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'autoconfiguration-properties')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens with these two bean definitions? (Assume `ObjectMapper` really is on the classpath, via `spring-boot-starter-web`.)$$
      AND code_snippet = $$@Configuration
class MyAutoConfiguration {
    @Bean
    @ConditionalOnClass(name = "com.fasterxml.jackson.databind.ObjectMapper")
    JacksonHelper jacksonHelper() { return new JacksonHelper(); }

    @Bean
    @ConditionalOnClass(name = "com.made.up.NonExistentLibrary")
    FakeHelper fakeHelper() { return new FakeHelper(); }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = 'autoconfiguration-properties'
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
    ($$jacksonHelper is registered as a bean; fakeHelper is silently skipped, with no exception thrown.$$, TRUE, 0),
    ($$Both beans are registered normally.$$, FALSE, 1),
    ($$The application fails to start with a ClassNotFoundException for FakeHelper.$$, FALSE, 2),
    ($$Neither bean is registered, since @ConditionalOnClass requires @ConditionalOnMissingBean too.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'autoconfiguration-properties'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'autoconfiguration-properties')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$When both of these configurations are present, which `ObjectMapper` bean does the container end up using?$$
      AND code_snippet = $$class ObjectMapperAutoConfig {
    @Bean
    @ConditionalOnMissingBean
    ObjectMapper objectMapper() { return new ObjectMapper(); }
}

@Configuration
class MyAppConfig {
    @Bean
    ObjectMapper objectMapper() { return new ObjectMapper().findAndRegisterModules(); }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = 'autoconfiguration-properties'
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
    ($$The application fails to start with NoUniqueBeanDefinitionException, since two ObjectMapper beans are defined.$$, FALSE, 0),
    ($$Both beans are merged into one combined ObjectMapper.$$, FALSE, 1),
    ($$The application's own ObjectMapper bean from MyAppConfig -- the auto-configuration default is skipped, since a bean of that type already exists.$$, TRUE, 2),
    ($$The auto-configuration's default ObjectMapper -- @ConditionalOnMissingBean always wins over the user's own bean.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'autoconfiguration-properties'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'autoconfiguration-properties')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about `@Value` and `@ConfigurationProperties`? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about `@Value` and `@ConfigurationProperties`? (Select all that apply)$$,
           NULL, NULL,
           $$@Value injects a single property with no grouping; @ConfigurationProperties binds an entire family of properties sharing the same prefix into one typed object.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'autoconfiguration-properties'
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
    ($$@Value injects a single property, with no grouping at all.$$, TRUE, 0),
    ($$@ConfigurationProperties binds an entire family of properties sharing the same prefix into one typed object.$$, TRUE, 1),
    ($$@Value can bind an entire group of related properties into one object, just like @ConfigurationProperties.$$, FALSE, 2),
    ($$@ConfigurationProperties can only be used for numeric property values, never strings.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'autoconfiguration-properties'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'autoconfiguration-properties')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$From highest to lowest priority, what is the correct order of the main Spring Boot property sources?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$From highest to lowest priority, what is the correct order of the main Spring Boot property sources?$$,
           NULL, NULL,
           $$From highest to lowest: command-line arguments, environment variables, application-{profile}.yml, and at the bottom, the base application.yml.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'autoconfiguration-properties'
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
    ($$Environment variables > command-line arguments > application.yml > application-{profile}.yml.$$, FALSE, 0),
    ($$All property sources have exactly equal priority; the last one loaded always wins.$$, FALSE, 1),
    ($$Command-line arguments > environment variables > application-{profile}.yml > application.yml.$$, TRUE, 2),
    ($$application.yml > application-{profile}.yml > environment variables > command-line arguments.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'autoconfiguration-properties'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'autoconfiguration-properties')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print? (The "dev" profile is activated before the context refreshes.)$$
      AND code_snippet = $$interface Greeter { String greet(); }

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
}$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = 'autoconfiguration-properties'
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
    ($$dev mode$$, TRUE, 0),
    ($$prod mode$$, FALSE, 1),
    ($$The application fails to start with NoUniqueBeanDefinitionException, since both Greeters exist.$$, FALSE, 2),
    ($$Compile error -- @Profile can't be combined with @Component.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'autoconfiguration-properties'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
