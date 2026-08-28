-- Promotion-style migration for the Git Fundamentals quiz (rewrite of the
-- original, non-portable V467).
--
-- Development Question IDs: 95, 96, 97, 98, 99, 100, 101, 102, 103, 104
-- Topic: git-fundamentals (language: en)
-- All 10 questions were PUBLISHED and ADMIN-reviewed in development, then
-- intended to be linked into the topic's existing English fixed quiz
-- ("Test Your Knowledge", quiz.slug = 'default'). These development ids are
-- DOCUMENTATION/PROVENANCE ONLY -- no development id is used as a foreign key
-- value anywhere below (bkz. question-promotion/V431's exact convention).
--
-- Why this rewrite exists: the FIRST version of V467 inserted
-- quiz_question_link rows referencing literal question_id values (95-104) --
-- valid only in the one development database where those specific
-- auto-generated ids already existed (created live via
-- POST /api/internal/questions/ingest, outside of any migration). That broke
-- Flyway startup on every other environment (learning_test, a fresh
-- container, production), where ids 95-104 don't exist in `question` at all.
--
-- Fix: each question is RE-INSERTED here with its full content via
-- WITH ... RETURNING id, the same mechanism question-promotion/V431 uses --
-- portable to any environment, no hardcoded foreign ids. topic_id is resolved
-- by Topic.slug and the quiz is resolved by (topic slug, language, quiz slug)
-- -- both globally unique/stable -- exactly like enum/V291's quiz linking.
--
-- Extra duplicate-safety (needed here because, unlike V431, this migration
-- was also run for real against the SAME development database that already
-- had this exact content from live ingestion): each block first checks
-- whether an equivalent question row (same topic_id + language + exact
-- question text) already exists, and only INSERTs a new row when it doesn't.
-- On a fresh test/prod database this check always misses, so a fresh row is
-- created -- identical behavior to a normal promotion migration. Re-running
-- this corrected file against the development database (after its stale
-- flyway_schema_history row for the old V467 content was cleared) finds the
-- existing rows 95-104 and the existing links, and safely does nothing
-- further -- no duplicate questions, no duplicate options, no duplicate
-- links. The quiz_question_link insert also carries ON CONFLICT DO NOTHING
-- as a second safety net (quiz_question_link already enforces
-- UNIQUE(quiz_id, question_id) and UNIQUE(quiz_id, position) from V290, so
-- this is defensive, not load-bearing).


-- Question 1/10 (dev id 95, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'en'
      AND question = $$What actually makes a folder a Git repository?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What actually makes a folder a Git repository?$$, NULL, NULL,
           $$A repository is a project folder Git is tracking, identified by a hidden .git folder created by git init. Hosting the folder on GitHub, having a README, or having existing commits are not what makes something a Git repository -- the .git folder is.$$, 'temp-publish-admin-1787918580@example.com', '2026-08-28 15:03:19.764912',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
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
    ($$It contains a hidden .git folder that Git created (e.g. via git init).$$, TRUE, 0),
    ($$It has already been pushed to GitHub.$$, FALSE, 1),
    ($$It contains at least one commit.$$, FALSE, 2),
    ($$It contains a README.md file.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 2/10 (dev id 96, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'en'
      AND question = $$You open UserService.java in your editor and add a new line, but you haven't run any git command yet. Which area does this change currently exist in?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$You open UserService.java in your editor and add a new line, but you haven't run any git command yet. Which area does this change currently exist in?$$, NULL, NULL,
           $$Changes made in your editor live in the working tree -- the actual files on disk -- until you explicitly move them into the staging area with git add. No git command has been run yet, so the staging area and repository are unaffected.$$, 'temp-publish-admin-1787918580@example.com', '2026-08-28 15:03:19.834643',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
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
    ($$The working tree only.$$, TRUE, 0),
    ($$The staging area only.$$, FALSE, 1),
    ($$The repository only.$$, FALSE, 2),
    ($$Both the staging area and the repository.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 3/10 (dev id 97, quiz position 3)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'en'
      AND question = $$Why does Git have a separate staging area instead of just committing every changed file directly?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why does Git have a separate staging area instead of just committing every changed file directly?$$, NULL, NULL,
           $$The staging area lets you modify several files but choose to commit only some of them, by staging just those. This lets you build focused, meaningful commits instead of one giant commit that mixes unrelated changes.$$, 'temp-publish-admin-1787918580@example.com', '2026-08-28 15:03:19.886611',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
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
    ($$It lets you choose exactly which changes go into the next commit.$$, TRUE, 0),
    ($$It automatically backs up your files in case you lose them.$$, FALSE, 1),
    ($$It is required for Git to detect which files have changed.$$, FALSE, 2),
    ($$It compresses files to save disk space before committing.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 4/10 (dev id 98, quiz position 4)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'en'
      AND question = $$You run git status in a brand-new repository and see the following output. Based on this output, what is true about UserService.java?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$You run git status in a brand-new repository and see the following output. Based on this output, what is true about UserService.java?$$, $$$ git status
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        UserService.java

nothing added to commit but untracked files present (use "git add" to track)$$, 'bash',
           $$"Untracked files" means Git sees the file in the working tree but it has never been staged or committed -- it isn't part of Git's history yet at all.$$, 'temp-publish-admin-1787918580@example.com', '2026-08-28 15:03:19.932600',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
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
    ($$It exists in the working tree but has not been staged or committed yet.$$, TRUE, 0),
    ($$It has been staged but not yet committed.$$, FALSE, 1),
    ($$It has already been committed to the repository.$$, FALSE, 2),
    ($$It does not exist in the working tree.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 5/10 (dev id 99, quiz position 5)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'en'
      AND question = $$What does running git add UserService.java actually do?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does running git add UserService.java actually do?$$, NULL, NULL,
           $$Staging is not the same as saving -- the file is already saved on disk the moment your editor wrote it. git add only tells Git that this change should be included in the next commit, by moving it from the working tree into the staging area.$$, 'temp-publish-admin-1787918580@example.com', '2026-08-28 15:03:19.980186',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
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
    ($$It moves the file's current changes from the working tree into the staging area.$$, TRUE, 0),
    ($$It saves the file to disk for the first time.$$, FALSE, 1),
    ($$It permanently records the file's history in the repository.$$, FALSE, 2),
    ($$It uploads the file to GitHub.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 6/10 (dev id 100, quiz position 6)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'en'
      AND question = $$You edited three files but only ran git add on one of them, then ran git commit -m "Fix login bug". What gets recorded in the new commit?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$You edited three files but only ran git add on one of them, then ran git commit -m "Fix login bug". What gets recorded in the new commit?$$, NULL, NULL,
           $$A commit takes everything currently in the staging area and permanently records it as a new snapshot. Since only one of the three edited files was staged, only that one file's changes are included -- this is also why forgetting to stage a file before committing is a common beginner mistake.$$, 'temp-publish-admin-1787918580@example.com', '2026-08-28 15:03:20.027393',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
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
    ($$Only the changes from the one file that was staged.$$, TRUE, 0),
    ($$The changes from all three edited files.$$, FALSE, 1),
    ($$Nothing, because git status must be run before git commit will record anything.$$, FALSE, 2),
    ($$All files in the working tree, regardless of whether they changed.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 7/10 (dev id 101, quiz position 7)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'en'
      AND question = $$You've edited a file but haven't run git add on it yet. Which command shows you exactly what changed, and what does it compare?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$You've edited a file but haven't run git add on it yet. Which command shows you exactly what changed, and what does it compare?$$, NULL, NULL,
           $$Plain git diff (no flag) shows unstaged changes: it compares the working tree to the staging area. git diff --staged is the different comparison (staging area vs. last commit), used only after staging.$$, 'temp-publish-admin-1787918580@example.com', '2026-08-28 15:03:20.067522',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
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
    ($$git diff -- it compares the working tree to the staging area.$$, TRUE, 0),
    ($$git diff --staged -- it compares the staging area to the last commit.$$, FALSE, 1),
    ($$git log -- it shows the commit history.$$, FALSE, 2),
    ($$git status -- it shows line-by-line changes.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 8/10 (dev id 102, quiz position 8)
WITH existing_q8 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'en'
      AND question = $$You just ran git add on a file and want one last check of exactly what will be committed before running git commit. Which command should you run, and why?$$
),
inserted_q8 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$You just ran git add on a file and want one last check of exactly what will be committed before running git commit. Which command should you run, and why?$$, NULL, NULL,
           $$git diff --staged compares the staging area to the last commit -- exactly what would be added to history if you committed right now. Reviewing it before every commit is called out as a best practice, since it's your last chance to catch something like a leftover debug line.$$, 'temp-publish-admin-1787918580@example.com', '2026-08-28 15:03:20.109602',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
      AND NOT EXISTS (SELECT 1 FROM existing_q8)
    RETURNING id
),
target_q8 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q8
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q8
),
option_ins_q8 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q8.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q8
             CROSS JOIN (VALUES
    ($$git diff --staged, because it compares the staging area to the last commit.$$, TRUE, 0),
    ($$git diff, because it always shows every change regardless of staging.$$, FALSE, 1),
    ($$git status, because it shows line-by-line differences.$$, FALSE, 2),
    ($$git log, because it previews the next commit before it's made.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q8.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q8.id, 8
FROM target_q8
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 9/10 (dev id 103, quiz position 9)
WITH existing_q9 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'en'
      AND question = $$What does git log primarily show you?$$
),
inserted_q9 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does git log primarily show you?$$, NULL, NULL,
           $$git log shows the commit history -- every snapshot ever recorded, newest first, each with its commit hash, author, date, and message.$$, 'temp-publish-admin-1787918580@example.com', '2026-08-28 15:03:20.152961',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
      AND NOT EXISTS (SELECT 1 FROM existing_q9)
    RETURNING id
),
target_q9 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q9
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q9
),
option_ins_q9 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q9.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q9
             CROSS JOIN (VALUES
    ($$The commit history: every recorded snapshot, newest first, with author, date, and message.$$, TRUE, 0),
    ($$Only the changes that are currently staged.$$, FALSE, 1),
    ($$The list of files currently tracked in the working tree.$$, FALSE, 2),
    ($$The differences between the working tree and the last commit.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q9.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q9.id, 9
FROM target_q9
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 10/10 (dev id 104, quiz position 10)
WITH existing_q10 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'en'
      AND question = $$Each commit shown by git log starts with a long hexadecimal string like 4f2a1c9e8b3d5a6f7e8d9c0b1a2f3e4d5c6b7a8f. What is this, and why does it matter?$$
),
inserted_q10 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Each commit shown by git log starts with a long hexadecimal string like 4f2a1c9e8b3d5a6f7e8d9c0b1a2f3e4d5c6b7a8f. What is this, and why does it matter?$$, NULL, NULL,
           $$This is the commit's unique hash (SHA) -- the identifier Git uses to refer to that exact snapshot everywhere, including when referencing specific commits later (undoing changes, cherry-picking, and more all work by hash).$$, 'temp-publish-admin-1787918580@example.com', '2026-08-28 15:03:20.193028',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
      AND NOT EXISTS (SELECT 1 FROM existing_q10)
    RETURNING id
),
target_q10 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q10
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q10
),
option_ins_q10 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q10.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q10
             CROSS JOIN (VALUES
    ($$The commit's unique hash (SHA), used to refer to that exact snapshot everywhere.$$, TRUE, 0),
    ($$A randomly generated display id with no other purpose.$$, FALSE, 1),
    ($$The author's unique developer ID.$$, FALSE, 2),
    ($$The commit timestamp encoded in hexadecimal.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q10.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q10.id, 10
FROM target_q10
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
