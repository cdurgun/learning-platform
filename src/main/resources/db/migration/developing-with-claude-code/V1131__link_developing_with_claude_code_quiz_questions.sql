-- Links the EN developing-with-claude-code questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/7 (pair 1 EN, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'developing-with-claude-code')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What sets Claude Code apart from asking an AI chat window for code?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What sets Claude Code apart from asking an AI chat window for code?$$,
           NULL, NULL,
           $$A chat window hands back a snippet that you copy into your project yourself. Claude Code is a terminal tool that runs inside the project directory, so it can read your files, write changes to them and run commands. That ability to actually modify things is the reason permission and review matter so much.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'developing-with-claude-code'
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
        ($$It runs inside your project and can read files, write changes and run commands$$, TRUE, 0),
        ($$It returns longer code snippets for you to copy into your project$$, FALSE, 1),
        ($$It works from your description alone, without access to any files$$, FALSE, 2),
        ($$It explains existing code but is not able to change anything$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'developing-with-claude-code'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (pair 2 EN, quiz position 2, SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'developing-with-claude-code')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the role of a `CLAUDE.md` file at a project's root?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What is the role of a `CLAUDE.md` file at a project's root?$$,
           NULL, NULL,
           $$According to the documented behavior, Claude Code reads the file automatically and treats it as persistent, project-specific context: architectural decisions, rules that never change, known constraints and coding conventions. It is the equivalent of telling a new teammate to read this document first.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'developing-with-claude-code'
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
        ($$It records the history of every command Claude Code has run in the project$$, FALSE, 0),
        ($$It gives Claude Code persistent, project-specific context such as rules and conventions$$, TRUE, 1),
        ($$It lists the files and folders that Claude Code is not allowed to open$$, FALSE, 2),
        ($$It is the script that installs Claude Code and starts it in the project$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'developing-with-claude-code'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (pair 3 EN, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'developing-with-claude-code')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which task description gives Claude Code the best starting point?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which task description gives Claude Code the best starting point?$$,
           NULL, NULL,
           $$The best task hands over the existing architecture, the scope, the acceptance criteria and the constraints together, including what is out of scope. Claude Code is then asked to implement that, not to decide the schema or architecture by itself. A bare instruction forces it to guess, and the result usually grows beyond what anyone asked for.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'developing-with-claude-code'
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
        ($$A short one such as "Build a quiz system", leaving the details open$$, FALSE, 0),
        ($$One that names the files to change and says nothing about the goal$$, FALSE, 1),
        ($$One that gives the existing architecture, scope, acceptance criteria and constraints together$$, TRUE, 2),
        ($$One that asks for as many related features as possible at once$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'developing-with-claude-code'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (pair 4 EN, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'developing-with-claude-code')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In the session this lesson describes, Claude Code offered three choices after writing its plan. What does "manually approve edits" do?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$In the session this lesson describes, Claude Code offered three choices after writing its plan. What does "manually approve edits" do?$$,
           NULL, NULL,
           $$With "manually approve edits", every file change and every command has to be approved one at a time. Running all the steps back to back without asking again is auto mode, and correcting the plan before any code is written is the third choice, "tell Claude what to change".$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'developing-with-claude-code'
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
        ($$It runs every step of the approved plan without asking again$$, FALSE, 0),
        ($$It lets you correct the plan before any code has been written$$, FALSE, 1),
        ($$It discards the plan and repeats the analysis from the start$$, FALSE, 2),
        ($$It asks you to approve each file change or command one at a time$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'developing-with-claude-code'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (pair 5 EN, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'developing-with-claude-code')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$The plan placed its new migrations in the `enum/` folder as `V7` and `V8`, although those version numbers were already taken elsewhere in the project. How was this caught?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$The plan placed its new migrations in the `enum/` folder as `V7` and `V8`, although those version numbers were already taken elsewhere in the project. How was this caught?$$,
           NULL, NULL,
           $$The plan was read before it was approved, and the file names it claimed were checked against the real file system. That happened before a single line of code was written. Had the plan gone through as written, Flyway would most likely have failed at startup, but the mistake never got that far.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'developing-with-claude-code'
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
        ($$By checking the plan's file names against the real project before approving it$$, TRUE, 0),
        ($$By Flyway reporting a duplicate version when the application started$$, FALSE, 1),
        ($$By the automated tests failing after the code had been written$$, FALSE, 2),
        ($$By Claude Code correcting the numbers while it wrote the files$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'developing-with-claude-code'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (pair 6 EN, quiz position 6, SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'developing-with-claude-code')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which kind of step should never be left to automatic approval?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which kind of step should never be left to automatic approval?$$,
           NULL, NULL,
           $$The rough rule is about how hard the outcome is to undo. Applying a migration to production, deleting a file or a `git push --force` are expensive or impossible to reverse, so they should always be approved by a person. Low-risk steps you have run many times are exactly where auto mode saves time.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'developing-with-claude-code'
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
        ($$One that you have run many times before with a known outcome$$, FALSE, 0),
        ($$One whose outcome is hard or expensive to undo, such as a `git push --force`$$, TRUE, 1),
        ($$One that only reads files and changes nothing in the project$$, FALSE, 2),
        ($$One that edits a file you are able to review afterwards in a diff$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'developing-with-claude-code'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (pair 7 EN, quiz position 7, MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'developing-with-claude-code')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of these are mistakes the lesson warns against? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of these are mistakes the lesson warns against? (Select all that apply)$$,
           NULL, NULL,
           $$A feature that runs without errors can still be wrong, which is why a separate review is needed. An already-applied migration must never be edited in place, because that breaks Flyway's checksum verification; the fix goes into a new migration. Checking a plan against the real project and adding a new migration are the recommended practices, not mistakes.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'developing-with-claude-code'
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
        ($$Checking the file names in a plan against the real project state$$, FALSE, 0),
        ($$Adding the fix for a problem as a new migration$$, FALSE, 1),
        ($$Treating a feature as done because it ran without errors$$, TRUE, 2),
        ($$Editing an already-applied migration in place to fix a problem$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'developing-with-claude-code'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
