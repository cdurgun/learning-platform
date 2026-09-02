-- Promotion-style migration linking EN interface quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'interface')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code is compiled?$$
      AND code_snippet = $$interface Greeter {
    void greet();
}

class QuietGreeter implements Greeter {
    protected void greet() { System.out.println("hi"); }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$interface Greeter {
    void greet();
}

class QuietGreeter implements Greeter {
    protected void greet() { System.out.println("hi"); }
}$$, $$java$$,
           $$An interface method is implicitly public, so an overriding implementation can never narrow the access modifier -- it must be at least as accessible as the interface method. protected is narrower than public, so this fails to compile.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'interface'
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
    ($$It fails to compile -- an overriding method can never be less accessible than the interface method it implements.$$, TRUE, 0),
    ($$It compiles and prints "hi".$$, FALSE, 1),
    ($$It compiles but throws IllegalAccessException at runtime.$$, FALSE, 2),
    ($$It compiles because protected is a stricter, more valid choice for an interface method.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'interface'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'interface')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$interface Constants {
    int MAX = 10;
}

class Widget implements Constants {
    void show() { System.out.println(MAX); }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(Constants.MAX);
        new Widget().show();
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$interface Constants {
    int MAX = 10;
}

class Widget implements Constants {
    void show() { System.out.println(MAX); }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(Constants.MAX);
        new Widget().show();
    }
}$$, $$java$$,
           $$Interface fields are implicitly public static final -- reachable directly as Constants.MAX with no instance needed, and every implementer sees the exact same shared value, not a per-instance copy.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'interface'
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
    ($$10
0$$, FALSE, 0),
    ($$Compile error -- Widget must redeclare MAX.$$, FALSE, 1),
    ($$10
10$$, TRUE, 2),
    ($$Compile error -- MAX is not accessible as Constants.MAX.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'interface'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'interface')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$How many interfaces can a single class implement at once?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$How many interfaces can a single class implement at once?$$,
           NULL, NULL,
           $$A class can extends only one class, but it can implements any number of interfaces at once -- just separate them with commas.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'interface'
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
    ($$As many as it likes, separated by commas -- unlike extends, which is limited to one class.$$, TRUE, 0),
    ($$Exactly one, the same limit as extends.$$, FALSE, 1),
    ($$At most two.$$, FALSE, 2),
    ($$Only if every interface involved is a functional interface.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'interface'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'interface')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$interface Vehicle {
    default void honk() { System.out.println("Beep"); }
}

class Car implements Vehicle {}

class SportsCar implements Vehicle {
    public void honk() { System.out.println("Vroom-beep"); }
}

public class Demo {
    public static void main(String[] args) {
        Vehicle v1 = new Car();
        Vehicle v2 = new SportsCar();
        v1.honk();
        v2.honk();
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$interface Vehicle {
    default void honk() { System.out.println("Beep"); }
}

class Car implements Vehicle {}

class SportsCar implements Vehicle {
    public void honk() { System.out.println("Vroom-beep"); }
}

public class Demo {
    public static void main(String[] args) {
        Vehicle v1 = new Car();
        Vehicle v2 = new SportsCar();
        v1.honk();
        v2.honk();
    }
}$$, $$java$$,
           $$Car never provides its own honk(), so it automatically inherits the default implementation. SportsCar overrides it with its own @Override -- a default method resolves polymorphically, just like a regular instance method.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'interface'
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
    ($$Compile error -- Car must implement honk() itself.$$, FALSE, 0),
    ($$Vroom-beep
Vroom-beep$$, FALSE, 1),
    ($$Beep
Vroom-beep$$, TRUE, 2),
    ($$Beep
Beep$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'interface'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'interface')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which statement correctly describes an interface's static method?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which statement correctly describes an interface's static method?$$,
           NULL, NULL,
           $$Unlike a default method, a static method belongs to no implementer at all -- it's called directly through the interface name and can never be overridden.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'interface'
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
    ($$It belongs to no implementer, is called directly through the interface name, and can never be overridden.$$, TRUE, 0),
    ($$It's inherited by every implementing class and can be overridden just like a default method.$$, FALSE, 1),
    ($$It can only be called through an instance of an implementing class.$$, FALSE, 2),
    ($$It's implicitly abstract and must be implemented by every implementing class.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'interface'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'interface')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$interface Flyer {
    default String move() { return "flying"; }
}

interface Swimmer {
    default String move() { return "swimming"; }
}

class Duck implements Flyer, Swimmer {
    public String move() {
        return Flyer.super.move() + "+" + Swimmer.super.move();
    }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(new Duck().move());
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$interface Flyer {
    default String move() { return "flying"; }
}

interface Swimmer {
    default String move() { return "swimming"; }
}

class Duck implements Flyer, Swimmer {
    public String move() {
        return Flyer.super.move() + "+" + Swimmer.super.move();
    }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(new Duck().move());
    }
}$$, $$java$$,
           $$Duck inherits a conflicting move() default from both Flyer and Swimmer, so Java forces an explicit override. InterfaceName.super.methodName() lets Duck pick -- and here combine -- both parents' behavior.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'interface'
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
    ($$flying$$, FALSE, 0),
    ($$swimming$$, FALSE, 1),
    ($$flying+swimming$$, TRUE, 2),
    ($$Compile error -- Duck must not override move() itself.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'interface'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'interface')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about functional interfaces? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about functional interfaces? (Select all that apply)$$,
           NULL, NULL,
           $$A functional interface has exactly one abstract method -- default and static methods don't count toward that number. A lambda expression can be used directly as an instance of a functional interface.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'interface'
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
    ($$A functional interface has exactly one abstract method -- default and static methods don't count toward that number.$$, TRUE, 0),
    ($$A lambda expression can be used directly as an instance of a functional interface.$$, TRUE, 1),
    ($$Adding a second abstract method to a functional interface still lets existing lambda-based code compile unchanged.$$, FALSE, 2),
    ($$The @FunctionalInterface annotation is required for an interface to be usable as a lambda target.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'interface'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
