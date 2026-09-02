-- Promotion-style migration linking EN polymorphism quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'polymorphism')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which statement correctly distinguishes compile-time polymorphism from runtime polymorphism?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which statement correctly distinguishes compile-time polymorphism from runtime polymorphism?$$,
           NULL, NULL,
           $$Compile-time polymorphism (overloading) is resolved by the compiler from the argument types at the call site; runtime polymorphism (overriding) is resolved by the JVM based on the object's actual type.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'polymorphism'
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
    ($$Compile-time polymorphism (overloading) is resolved by argument types at compile time; runtime polymorphism (overriding) is resolved by the object's actual type at runtime.$$, TRUE, 0),
    ($$Compile-time polymorphism is resolved by the object's actual type; runtime polymorphism is resolved by argument types.$$, FALSE, 1),
    ($$Both are resolved entirely at runtime, just through different mechanisms.$$, FALSE, 2),
    ($$Both are resolved entirely at compile time, just through different mechanisms.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'polymorphism'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'polymorphism')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$class Calc {
    int add(int a, int b) { return a + b; }
    double add(double a, double b) { return a + b; }
}

public class Demo {
    public static void main(String[] args) {
        Calc c = new Calc();
        System.out.println(c.add(2, 3));
        System.out.println(c.add(2.0, 3.0));
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Calc {
    int add(int a, int b) { return a + b; }
    double add(double a, double b) { return a + b; }
}

public class Demo {
    public static void main(String[] args) {
        Calc c = new Calc();
        System.out.println(c.add(2, 3));
        System.out.println(c.add(2.0, 3.0));
    }
}$$, $$java$$,
           $$The compiler picks the overload by looking at the number and type of arguments given at the call site -- add(2, 3) matches the int overload, add(2.0, 3.0) matches the double overload.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'polymorphism'
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
    ($$5
5$$, FALSE, 0),
    ($$Compile error -- add is ambiguous.$$, FALSE, 1),
    ($$5
5.0$$, TRUE, 2),
    ($$5.0
5.0$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'polymorphism'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'polymorphism')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$class Utils {
    static String process(long x) { return "long"; }
    static String process(Integer x) { return "Integer"; }
    static String process(int... x) { return "varargs"; }
}

public class Demo {
    public static void main(String[] args) {
        short s = 5;
        System.out.println(Utils.process(s));
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Utils {
    static String process(long x) { return "long"; }
    static String process(Integer x) { return "Integer"; }
    static String process(int... x) { return "varargs"; }
}

public class Demo {
    public static void main(String[] args) {
        short s = 5;
        System.out.println(Utils.process(s));
    }
}$$, $$java$$,
           $$The compiler tries an exact match first (none exists for short), then widening -- short widens directly to long, so process(long) applies. Integer requires autoboxing (a later phase, and short doesn't box to Integer anyway), and varargs is only tried as a last resort, so widening wins.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'polymorphism'
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
    ($$long$$, TRUE, 0),
    ($$Integer$$, FALSE, 1),
    ($$varargs$$, FALSE, 2),
    ($$Compile error -- the call is ambiguous.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'polymorphism'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'polymorphism')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$class Animal {
    Animal reproduce() { return new Animal(); }
}

class Dog extends Animal {
    @Override
    Dog reproduce() { return new Dog(); }
}

public class Demo {
    public static void main(String[] args) {
        Dog d = new Dog();
        Dog puppy = d.reproduce();
        System.out.println(puppy.getClass().getSimpleName());
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Animal {
    Animal reproduce() { return new Animal(); }
}

class Dog extends Animal {
    @Override
    Dog reproduce() { return new Dog(); }
}

public class Demo {
    public static void main(String[] args) {
        Dog d = new Dog();
        Dog puppy = d.reproduce();
        System.out.println(puppy.getClass().getSimpleName());
    }
}$$, $$java$$,
           $$An overriding method is allowed to return a subtype of what the superclass method returns -- Dog's reproduce() returns Dog instead of Animal, a legal covariant return type, so puppy can be assigned directly with no cast.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'polymorphism'
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
    ($$Compile error -- reproduce()'s return type must exactly match Animal.$$, FALSE, 0),
    ($$Compile error -- puppy must be declared as Animal, not Dog.$$, FALSE, 1),
    ($$Dog$$, TRUE, 2),
    ($$Animal$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'polymorphism'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'polymorphism')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about the relationship between inheritance and polymorphism? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about the relationship between inheritance and polymorphism? (Select all that apply)$$,
           NULL, NULL,
           $$Inheritance is a structural relationship; polymorphism is a runtime behavior -- inheritance makes polymorphism possible but doesn't guarantee it. If a subclass never overrides an inherited method, calling that method produces no real polymorphism.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'polymorphism'
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
    ($$Inheritance is a structural relationship; polymorphism is a runtime behavior -- inheritance makes polymorphism possible but doesn't guarantee it.$$, TRUE, 0),
    ($$If a subclass never overrides any inherited method, calling that method on the subclass produces no real polymorphism.$$, TRUE, 1),
    ($$Polymorphism can only occur when a class hierarchy built with extends is involved.$$, FALSE, 2),
    ($$Every subclass automatically exhibits polymorphic behavior for every method it inherits.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'polymorphism'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'polymorphism')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$interface Formatter {
    String format(String s);
}

class Document {
    private Formatter formatter;
    Document(Formatter formatter) { this.formatter = formatter; }
    void setFormatter(Formatter formatter) { this.formatter = formatter; }
    String render(String s) { return formatter.format(s); }
}

public class Demo {
    public static void main(String[] args) {
        Document doc = new Document(s -> s.toUpperCase());
        System.out.println(doc.render("hello"));
        doc.setFormatter(s -> "[" + s + "]");
        System.out.println(doc.render("hello"));
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$interface Formatter {
    String format(String s);
}

class Document {
    private Formatter formatter;
    Document(Formatter formatter) { this.formatter = formatter; }
    void setFormatter(Formatter formatter) { this.formatter = formatter; }
    String render(String s) { return formatter.format(s); }
}

public class Demo {
    public static void main(String[] args) {
        Document doc = new Document(s -> s.toUpperCase());
        System.out.println(doc.render("hello"));
        doc.setFormatter(s -> "[" + s + "]");
        System.out.println(doc.render("hello"));
    }
}$$, $$java$$,
           $$Document holds a Formatter reference rather than extending one (composition) -- setFormatter(...) swaps the behavior at runtime, something inheritance could never do since an object's class can't change after construction.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'polymorphism'
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
    ($$[hello]
[hello]$$, FALSE, 0),
    ($$Compile error -- Document can't change its formatter after construction.$$, FALSE, 1),
    ($$HELLO
[hello]$$, TRUE, 2),
    ($$HELLO
HELLO$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'polymorphism'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'polymorphism')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, what does a growing chain of `if (obj instanceof TypeA) {...} else if (obj instanceof TypeB) {...}` usually indicate?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what does a growing chain of `if (obj instanceof TypeA) {...} else if (obj instanceof TypeB) {...}` usually indicate?$$,
           NULL, NULL,
           $$If you see a chain of instanceof checks growing with every new type, that's usually a sign polymorphism isn't being used -- in a well-designed system, calling code never asks "what type is this?", it just calls the polymorphic method directly.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'polymorphism'
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
    ($$A sign that polymorphism isn't being used -- a well-designed system would let calling code invoke a polymorphic method directly instead of checking types.$$, TRUE, 0),
    ($$A necessary and idiomatic pattern that should be used whenever multiple related types exist.$$, FALSE, 1),
    ($$That the types involved don't share a common interface and never could.$$, FALSE, 2),
    ($$That the code is already using polymorphism correctly.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'polymorphism'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
