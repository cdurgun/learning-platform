-- Promotion-style migration linking EN abstract-class quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'abstract-class')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code is compiled?$$
      AND code_snippet = $$abstract class Shape {
    double area() { return 0.0; }
}

public class Demo {
    public static void main(String[] args) {
        Shape s = new Shape();
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$abstract class Shape {
    double area() { return 0.0; }
}

public class Demo {
    public static void main(String[] args) {
        Shape s = new Shape();
    }
}$$, $$java$$,
           $$What decides whether a class can be instantiated directly is not whether it has an abstract method, but whether the class itself is marked abstract. Shape has zero abstract methods, yet new Shape() still fails to compile.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'abstract-class'
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
    ($$It fails to compile -- Shape is abstract, so it can never be instantiated directly, regardless of whether it has abstract methods.$$, TRUE, 0),
    ($$It compiles and runs fine, since Shape has no abstract methods.$$, FALSE, 1),
    ($$It compiles but throws InstantiationException at runtime.$$, FALSE, 2),
    ($$It compiles because area() has a full body.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'abstract-class'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'abstract-class')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$An abstract class `B` extends abstract class `A`. `B` does not implement one of `A`'s abstract methods. Under what condition does `B` still compile?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$An abstract class `B` extends abstract class `A`. `B` does not implement one of `A`'s abstract methods. Under what condition does `B` still compile?$$,
           NULL, NULL,
           $$Only a concrete class is forced to implement an abstract method it inherited; an intermediate abstract class is free to leave it unimplemented and defer it further down the hierarchy.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'abstract-class'
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
    ($$It never compiles unless B provides an empty default implementation.$$, FALSE, 0),
    ($$It compiles only if B renames the abstract method.$$, FALSE, 1),
    ($$As long as B itself is also declared abstract -- only a concrete subclass is required to implement every inherited abstract method.$$, TRUE, 2),
    ($$It always compiles, whether or not B is declared abstract.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'abstract-class'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'abstract-class')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$abstract class Animal {
    void sleep() { System.out.println("sleeping quietly"); }
    abstract void makeSound();
}

class Cat extends Animal {
    void makeSound() { System.out.println("Meow"); }
    @Override
    void sleep() { System.out.println("napping"); }
}

public class Demo {
    public static void main(String[] args) {
        Animal a = new Cat();
        a.sleep();
        a.makeSound();
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$abstract class Animal {
    void sleep() { System.out.println("sleeping quietly"); }
    abstract void makeSound();
}

class Cat extends Animal {
    void makeSound() { System.out.println("Meow"); }
    @Override
    void sleep() { System.out.println("napping"); }
}

public class Demo {
    public static void main(String[] args) {
        Animal a = new Cat();
        a.sleep();
        a.makeSound();
    }
}$$, $$java$$,
           $$sleep() is a concrete method with a full body, but a subclass is still free to override it -- Cat does, and dynamic dispatch means the overridden version runs even through an Animal reference.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'abstract-class'
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
    ($$napping
Meow$$, TRUE, 0),
    ($$sleeping quietly
Meow$$, FALSE, 1),
    ($$Compile error -- a concrete inherited method can't be overridden without being abstract.$$, FALSE, 2),
    ($$napping
sleeping quietly$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'abstract-class'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'abstract-class')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$abstract class Account {
    Account(String owner) {
        System.out.println("Account created for " + owner);
    }
}

class SavingsAccount extends Account {
    SavingsAccount(String owner) {
        super(owner);
        System.out.println("SavingsAccount ready");
    }
}

public class Demo {
    public static void main(String[] args) {
        new SavingsAccount("Alice");
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$abstract class Account {
    Account(String owner) {
        System.out.println("Account created for " + owner);
    }
}

class SavingsAccount extends Account {
    SavingsAccount(String owner) {
        super(owner);
        System.out.println("SavingsAccount ready");
    }
}

public class Demo {
    public static void main(String[] args) {
        new SavingsAccount("Alice");
    }
}$$, $$java$$,
           $$An abstract class can have a constructor, even though it can never be called directly with new -- it only runs through a super(...) call. The parent's constructor always finishes before the subclass's own extra work runs.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'abstract-class'
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
    ($$Compile error -- an abstract class can't have a constructor.$$, FALSE, 0),
    ($$Account created for Alice$$, FALSE, 1),
    ($$Account created for Alice
SavingsAccount ready$$, TRUE, 2),
    ($$SavingsAccount ready
Account created for Alice$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'abstract-class'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'abstract-class')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following modifier combinations on a method are illegal, and why? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following modifier combinations on a method are illegal, and why? (Select all that apply)$$,
           NULL, NULL,
           $$private abstract is illegal because a private method is already invisible to subclasses, so it can't be overridden. final abstract is illegal because a final method can never be overridden, directly contradicting what abstract requires.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'abstract-class'
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
    ($$private abstract -- a private method is already invisible to subclasses, so it can never be overridden.$$, TRUE, 0),
    ($$final abstract -- a final method can never be overridden, which directly contradicts what abstract requires.$$, TRUE, 1),
    ($$protected abstract -- protected methods can never be inherited by subclasses.$$, FALSE, 2),
    ($$public abstract -- public methods can never be declared abstract.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'abstract-class'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'abstract-class')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$interface Auditable {
    String auditLog();
}

abstract class Document implements Auditable {
    abstract String content();
}

class Report extends Document {
    String content() { return "report content"; }
    public String auditLog() { return "audited: " + content(); }
}

public class Demo {
    public static void main(String[] args) {
        Document d = new Report();
        System.out.println(d.auditLog());
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$interface Auditable {
    String auditLog();
}

abstract class Document implements Auditable {
    abstract String content();
}

class Report extends Document {
    String content() { return "report content"; }
    public String auditLog() { return "audited: " + content(); }
}

public class Demo {
    public static void main(String[] args) {
        Document d = new Report();
        System.out.println(d.auditLog());
    }
}$$, $$java$$,
           $$Document implements Auditable but never writes auditLog() -- just like it defers its own content(), it defers auditLog() to a subclass. Report implements both, so the call resolves normally.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'abstract-class'
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
    ($$Compile error -- Report must separately declare implements Auditable.$$, FALSE, 0),
    ($$null$$, FALSE, 1),
    ($$audited: report content$$, TRUE, 2),
    ($$Compile error -- Document must implement auditLog() itself.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'abstract-class'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'abstract-class')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In the Template Method pattern, why is the skeleton method (like `run()`) typically marked `final`?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$In the Template Method pattern, why is the skeleton method (like `run()`) typically marked `final`?$$,
           NULL, NULL,
           $$Marking the skeleton method final guarantees subclasses can only fill in the content of the individual steps, never reorder or change the fixed sequence the parent class defines.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'abstract-class'
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
    ($$To guarantee that subclasses can only fill in the content of the steps, never change their fixed order.$$, TRUE, 0),
    ($$To prevent the method from being inherited at all.$$, FALSE, 1),
    ($$Because abstract methods are required to be called from a final method.$$, FALSE, 2),
    ($$To allow the method to be called without creating an instance.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'abstract-class'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
