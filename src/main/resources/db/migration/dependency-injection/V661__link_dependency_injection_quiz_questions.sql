-- Promotion-style migration linking EN dependency-injection quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dependency-injection')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which statement correctly describes the relationship between Dependency Injection (DI) and Inversion of Control (IoC)?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which statement correctly describes the relationship between Dependency Injection (DI) and Inversion of Control (IoC)?$$,
           NULL, NULL,
           $$IoC is the more general idea of handing control outward; DI is the most common concrete way of implementing IoC.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dependency-injection'
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
    ($$IoC is the more general idea of handing control outward; DI is the most common concrete way of implementing IoC.$$, TRUE, 0),
    ($$DI and IoC are two completely unrelated concepts that happen to be discussed together.$$, FALSE, 1),
    ($$IoC is a Spring-specific mechanism; DI is the general design principle.$$, FALSE, 2),
    ($$DI is the more general idea; IoC is one specific technique for implementing it.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dependency-injection'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: MULTIPLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dependency-injection')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, which of the following are concrete costs of tight coupling (a class creating its dependency directly with `new`)? (Select all that apply)$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, which of the following are concrete costs of tight coupling (a class creating its dependency directly with `new`)? (Select all that apply)$$,
           NULL, NULL,
           $$Tight coupling leads to untestability (forced to test against the real implementation) and difficulty changing (switching implementations means editing the class's source).$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dependency-injection'
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
    ($$Improved performance, since no interface indirection is involved.$$, FALSE, 0),
    ($$Automatic thread-safety, since the dependency is created once.$$, FALSE, 1),
    ($$Untestability -- you're forced to test against the real implementation, with no way to avoid it.$$, TRUE, 2),
    ($$Difficulty changing -- switching to a different implementation means opening up and editing the class's source.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dependency-injection'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dependency-injection')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code runs?$$
      AND code_snippet = $$class OrderService {
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
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = 'dependency-injection'
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
    ($$It throws a NullPointerException at runtime, on the placeOrder(...) call, since setSender(...) was never called.$$, TRUE, 0),
    ($$It fails to compile, since sender is never initialized.$$, FALSE, 1),
    ($$It throws the exception immediately when new OrderService() runs.$$, FALSE, 2),
    ($$It runs fine and prints "Order placed: Book" with a null sender.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dependency-injection'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dependency-injection')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, why is it hard to test a class that uses field injection (like a hand-simulated `@Autowired` field) without a framework?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, why is it hard to test a class that uses field injection (like a hand-simulated `@Autowired` field) without a framework?$$,
           NULL, NULL,
           $$A plain new OrderService(fakeSender) call can't set the dependency at all, since there's no constructor that accepts it -- reflection is required.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dependency-injection'
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
    ($$Field injection makes the field final, so it can never be changed for testing.$$, FALSE, 0),
    ($$Field injection requires a real database connection to test.$$, FALSE, 1),
    ($$A plain new OrderService(fakeSender) call can't set the dependency at all, since there's no constructor that accepts it -- reflection is required.$$, TRUE, 2),
    ($$Field-injected classes can never be instantiated at all outside a container.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dependency-injection'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dependency-injection')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are reasons this lesson gives for recommending constructor injection as the default? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are reasons this lesson gives for recommending constructor injection as the default? (Select all that apply)$$,
           NULL, NULL,
           $$A missing/null dependency can be caught immediately at construction with Objects.requireNonNull(...), and a growing parameter list is an early sign of too many responsibilities.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dependency-injection'
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
    ($$A missing/null dependency can be caught immediately, at object construction, with something like Objects.requireNonNull(...).$$, TRUE, 0),
    ($$A constructor parameter list that creeps up to five or six is an early, visible sign the class has taken on too many responsibilities.$$, TRUE, 1),
    ($$It requires the least code to write, with no constructor or setter needed at all.$$, FALSE, 2),
    ($$It's the only injection style Spring supports for classes with more than one dependency.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dependency-injection'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dependency-injection')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson's Common Mistakes, what is a mistaken assumption about Dependency Injection?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson's Common Mistakes, what is a mistaken assumption about Dependency Injection?$$,
           NULL, NULL,
           $$Assuming DI is a Spring-specific concept is a mistake -- DI is a design idea that works with no framework at all, as the composition-root example shows.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dependency-injection'
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
    ($$Assuming DI requires at least three dependencies to be worthwhile.$$, FALSE, 0),
    ($$Assuming DI eliminates the need for any testing at all.$$, FALSE, 1),
    ($$Assuming DI is a Spring-specific concept -- DI is a design idea that works with no framework at all, as the composition-root example shows.$$, TRUE, 2),
    ($$Assuming DI can only be applied to interfaces, never to concrete classes.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dependency-injection'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dependency-injection')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$class FakeNotificationSender implements NotificationSender {
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
}$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = 'dependency-injection'
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
    ($$1$$, TRUE, 0),
    ($$0$$, FALSE, 1),
    ($$Compile error -- FakeNotificationSender can't implement NotificationSender without a real email connection.$$, FALSE, 2),
    ($$It throws a NullPointerException, since fake is not a real sender.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dependency-injection'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
