-- Promotion-style migration linking EN connecting-to-postgresql quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/6 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'connecting-to-postgresql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does this lesson's `docker run` command map port 5433 on the host to port 5432 inside the container, instead of just using 5432 on both sides?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why does this lesson's `docker run` command map port 5433 on the host to port 5432 inside the container, instead of just using 5432 on both sides?$$,
           NULL, NULL,
           $$The lesson states 5432 is PostgreSQL's real, standard port inside the container, and 5433 is specifically this project's own choice on the host side, precisely so a locally installed PostgreSQL (which would normally already claim 5432 for itself) never conflicts with this container.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'connecting-to-postgresql'
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
    ($$So a locally installed PostgreSQL, which would normally already be using port 5432 on the host, never conflicts with this container$$, TRUE, 0),
    ($$Because PostgreSQL inside a container is technically incapable of using port 5432 at all$$, FALSE, 1),
    ($$Because port 5433 is the actual PostgreSQL standard, and 5432 is the non-standard one$$, FALSE, 2),
    ($$Because Docker itself requires every container's internal port to be renumbered when published$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'connecting-to-postgresql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'connecting-to-postgresql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is `psql`, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is `psql`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states psql is PostgreSQL's own command-line client -- the tool every PostgreSQL installation ships with, independent of any GUI tool or any Java code; connecting with it lands at a direct, interactive connection to the server itself, with no Spring Boot, Hibernate, or JDBC driver in between.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'connecting-to-postgresql'
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
    ($$A Spring Boot auto-configuration class responsible for creating the DataSource bean$$, FALSE, 0),
    ($$PostgreSQL's own command-line client, shipped with every installation, connecting directly with no Spring Boot/Hibernate/JDBC in between$$, TRUE, 1),
    ($$A Java library this project must add as a Maven dependency to connect to PostgreSQL$$, FALSE, 2),
    ($$A GUI-only database administration tool that requires a separate, paid license$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'connecting-to-postgresql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'connecting-to-postgresql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$After running `\c learning` in a psql session that was previously connected to the `postgres` database, how can you confirm the switch actually happened?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$After running `\c learning` in a psql session that was previously connected to the `postgres` database, how can you confirm the switch actually happened?$$,
           NULL, NULL,
           $$The lesson shows the prompt itself changes -- from `postgres=#` to `learning=#` -- confirming the current session is now connected to the `learning` database; `\c <database>` is what performs the switch.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'connecting-to-postgresql'
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
    ($$`\c` always prints the full list of every table in the new database automatically as confirmation$$, FALSE, 0),
    ($$The terminal's background color changes to indicate a successful database switch$$, FALSE, 1),
    ($$The prompt itself changes, from `postgres=#` to `learning=#`, confirming the session is now connected to `learning`$$, TRUE, 2),
    ($$There's no way to confirm it within the same session -- you must disconnect and reconnect entirely$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'connecting-to-postgresql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'connecting-to-postgresql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this psql session, what does the `learning=#` prompt (instead of `postgres=#`) confirm about the `\dt` output that follows it?$$
      AND code_snippet = $$postgres=# \c learning
You are now connected to database "learning" as user "postgres".

learning=# \dt
           List of relations
 Schema |   Name   | Type  |  Owner
--------+----------+-------+---------
 public | topic    | table | learning
 public | category | table | learning
 public | course   | table | learning$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this psql session, what does the `learning=#` prompt (instead of `postgres=#`) confirm about the `\dt` output that follows it?$$,
           $$postgres=# \c learning
You are now connected to database "learning" as user "postgres".

learning=# \dt
           List of relations
 Schema |   Name   | Type  |  Owner
--------+----------+-------+---------
 public | topic    | table | learning
 public | category | table | learning
 public | course   | table | learning$$, $$text$$,
           $$The lesson explains the changed prompt confirms the `\c learning` switch succeeded, so the `\dt` that follows lists tables in the `learning` database specifically -- this project's own real `topic`/`category`/`course` tables, created by its Flyway migrations, not tables from the default `postgres` database.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'connecting-to-postgresql'
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
    ($$The `\dt` output is unrelated to which database is currently connected -- it always lists every table on the whole server$$, FALSE, 0),
    ($$The prompt change means the connection has switched to using a different PostgreSQL server entirely, not just a different database$$, FALSE, 1),
    ($$The prompt change indicates an error occurred and `\dt` will fail to run$$, FALSE, 2),
    ($$The `\dt` output lists tables in the `learning` database specifically, not the default `postgres` database$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'connecting-to-postgresql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'connecting-to-postgresql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In the JDBC URL `jdbc:postgresql://localhost:5433/learning`, what does `learning` correspond to in `psql`'s own flags/commands?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$In the JDBC URL `jdbc:postgresql://localhost:5433/learning`, what does `learning` correspond to in `psql`'s own flags/commands?$$,
           NULL, NULL,
           $$The lesson breaks the JDBC URL down piece by piece: `learning` is the database name, identical in meaning to psql's `\c learning` (or `-d learning` on the command line) -- the host/port (`localhost:5433`) corresponds to psql's `-h`/`-p` flags.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'connecting-to-postgresql'
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
    ($$The database name -- identical in meaning to psql's `\c learning` or `-d learning`$$, TRUE, 0),
    ($$The username to connect as -- identical in meaning to psql's `-U` flag$$, FALSE, 1),
    ($$The name of the JDBC driver being used to connect$$, FALSE, 2),
    ($$The password used to authenticate the connection$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'connecting-to-postgresql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'connecting-to-postgresql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about connecting to PostgreSQL, as covered in this lesson's "Common Misconceptions," are correct? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about connecting to PostgreSQL, as covered in this lesson's "Common Misconceptions," are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (Spring Boot doesn't need special setup -- spring.datasource.url/username/password are the exact same three things psql's -h/-p/-U/-d need, just carried through a JDBC driver instead of a terminal; psql and a GUI database tool both ultimately connect using the same host/port/database/credentials and speak the same PostgreSQL wire protocol); the lesson explicitly says 5433 is NOT PostgreSQL's real port (5432 is), and connecting to the exact same host/port/database/credentials with psql directly is recommended precisely to isolate whether a connection problem is in PostgreSQL itself or in the Spring/JDBC layer.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'connecting-to-postgresql'
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
    ($$Trying to connect with `psql` directly is discouraged as a way to isolate whether a JDBC connection failure is a database problem or a Spring/JDBC-layer problem$$, FALSE, 0),
    ($$`spring.datasource.url`/`username`/`password` are the exact same three things psql's `-h`/`-p`/`-U`/`-d` need, just carried through a JDBC driver instead of a terminal$$, TRUE, 1),
    ($$`psql` and a GUI database tool both ultimately connect using the same host/port/database/credentials and speak the same PostgreSQL wire protocol$$, TRUE, 2),
    ($$Port 5433 is described in this lesson as PostgreSQL's actual, real standard port$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'connecting-to-postgresql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
