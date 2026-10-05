-- Links the EN threads questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/7 (pair 1 EN, quiz position 1, CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'threads')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$public class Demo {
    public static void main(String[] args) throws InterruptedException {
        Thread worker = new Thread(() -> { });

        System.out.println(worker.getState());

        worker.start();
        worker.join();

        System.out.println(worker.getState());
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$public class Demo {
    public static void main(String[] args) throws InterruptedException {
        Thread worker = new Thread(() -> { });

        System.out.println(worker.getState());

        worker.start();
        worker.join();

        System.out.println(worker.getState());
    }
}$$, $$java$$,
           $$Before `start()` is called the thread object exists but has not begun, so its state is `NEW`. `join()` makes the main thread wait until `run()` has finished, and a thread whose `run()` has finished is `TERMINATED`. `RUNNABLE` would be seen only while the thread is still running or waiting for the CPU.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'threads'
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
        ($$`NEW`, then `TERMINATED`$$, TRUE, 0),
        ($$`NEW`, then `RUNNABLE`$$, FALSE, 1),
        ($$`RUNNABLE`, then `TERMINATED`$$, FALSE, 2),
        ($$`NEW`, then `WAITING`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'threads'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (pair 2 EN, quiz position 2, CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'threads')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$Thread worker = new Thread(() ->
        System.out.println(Thread.currentThread().getName()));

worker.run();$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$Thread worker = new Thread(() ->
        System.out.println(Thread.currentThread().getName()));

worker.run();$$, $$java$$,
           $$Calling `run()` directly does not start a new thread; it is an ordinary method call that executes on the calling thread, which here is `main`. Only `start()` launches a new thread, and the name printed would then be that thread's own name instead.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'threads'
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
        ($$`Thread-0`$$, FALSE, 0),
        ($$`main`$$, TRUE, 1),
        ($$`main`, then `Thread-0`$$, FALSE, 2),
        ($$Nothing, because a thread that was never started cannot run$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'threads'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (pair 3 EN, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'threads')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Two threads each run `counter++` 100,000 times on the same unprotected `int`. Why can the final value be less than 200,000?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Two threads each run `counter++` 100,000 times on the same unprotected `int`. Why can the final value be less than 200,000?$$,
           NULL, NULL,
           $$`counter++` looks like one operation but is three: read the value, increment it, write it back. When two threads interleave those steps, one thread writes a result based on a stale read and the other's increment is lost. Both threads really do share the same variable; that sharing is precisely what makes the lost updates possible.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'threads'
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
        ($$Each thread increments its own private copy of `counter`, and only one copy survives$$, FALSE, 0),
        ($$The second thread can start counting only after the first one has finished$$, FALSE, 1),
        ($$`counter++` is three separate steps, and interleaved steps overwrite each other's updates$$, TRUE, 2),
        ($$An `int` loses precision once two threads have written to it$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'threads'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (pair 4 EN, quiz position 4, MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'threads')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of these statements about `volatile` are true? (Select all that apply)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of these statements about `volatile` are true? (Select all that apply)$$,
           NULL, NULL,
           $$`volatile` solves a visibility problem: every read and write goes to main memory, so one thread's change cannot stay hidden from the others. It does not make anything atomic, so `counter++` on a `volatile int` is still the same three-step race. It involves no lock either, so it does not restrict how many threads access the variable.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'threads'
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
        ($$It guarantees that a value written by one thread becomes visible to the others$$, TRUE, 0),
        ($$It makes compound operations such as `counter++` atomic$$, FALSE, 1),
        ($$It lets only one thread at a time access the variable$$, FALSE, 2),
        ($$`counter++` on a `volatile int` is still a race condition$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'threads'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (pair 5 EN, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'threads')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why should `wait()` be called inside a `while` loop rather than a single `if`?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Why should `wait()` be called inside a `while` loop rather than a single `if`?$$,
           NULL, NULL,
           $$A thread can wake up without any `notify()` having been called, a so-called spurious wakeup, and even after a real notification the condition may no longer hold. A `while` loop re-checks the condition after every wakeup, whereas an `if` checks it only once and then carries on regardless.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'threads'
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
        ($$`wait()` releases the lock only when it is called from inside a loop$$, FALSE, 0),
        ($$A woken thread must re-check the condition, because it can wake without it being true$$, TRUE, 1),
        ($$`notify()` can wake only threads that are waiting inside a loop$$, FALSE, 2),
        ($$A `while` loop keeps the thread from ever entering the waiting state$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'threads'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (pair 6 EN, quiz position 6, SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'threads')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$When using `ReentrantLock`, why must `unlock()` be called inside a `finally` block?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$When using `ReentrantLock`, why must `unlock()` be called inside a `finally` block?$$,
           NULL, NULL,
           $$`synchronized` releases its lock automatically, but `ReentrantLock` does not. If the code between `lock()` and `unlock()` throws and `unlock()` is not in `finally`, the lock stays held forever and every thread waiting for it blocks. `finally` guarantees the release on both the normal and the exceptional path.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'threads'
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
        ($$Otherwise the compiler rejects the call to `unlock()`$$, FALSE, 0),
        ($$Because `finally` makes `unlock()` run before the locked code starts$$, FALSE, 1),
        ($$Otherwise an exception in the locked code would leave the lock held forever$$, TRUE, 2),
        ($$Because the lock is released automatically and `finally` only documents that$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'threads'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (pair 7 EN, quiz position 7, SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'threads')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Thread A holds `lockA` and waits for `lockB`, while thread B holds `lockB` and waits for `lockA`. What is the most common way to prevent this situation?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Thread A holds `lockA` and waits for `lockB`, while thread B holds `lockB` and waits for `lockA`. What is the most common way to prevent this situation?$$,
           NULL, NULL,
           $$The deadlock exists only because the two threads take the locks in opposite orders. If every thread always acquires them in the same order, one of them gets both and the other simply waits its turn. `volatile` concerns visibility and has no effect on locking, and a pause between the two acquisitions only changes the timing.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'threads'
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
        ($$Declare both lock objects as `volatile`$$, FALSE, 0),
        ($$Pause with `Thread.sleep()` between acquiring the two locks$$, FALSE, 1),
        ($$Mark one of the two threads as a daemon thread$$, FALSE, 2),
        ($$Make every thread acquire the locks in the same order$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'threads'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
