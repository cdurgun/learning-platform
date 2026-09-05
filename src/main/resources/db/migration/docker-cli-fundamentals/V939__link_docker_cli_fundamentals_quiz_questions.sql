-- Promotion-style migration linking EN docker-cli-fundamentals quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-cli-fundamentals')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Running `docker pull redis` with no tag specified implicitly pulls which version, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Running `docker pull redis` with no tag specified implicitly pulls which version, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states that omitting a tag entirely implicitly means `:latest`, which is worth naming explicitly instead of relying on -- this is exactly why "Best Practices" recommends always pulling and running a specific tag rather than the implicit latest.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-cli-fundamentals'
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
    ($$The oldest available version of the image, to guarantee maximum stability$$, FALSE, 0),
    ($$It fails outright with an error, since a tag is always mandatory for `docker pull`$$, FALSE, 1),
    ($$Whatever version is currently installed as a dependency of another local image$$, FALSE, 2),
    ($$`:latest` -- omitting a tag entirely implicitly means the `latest` tag$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-cli-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-cli-fundamentals')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Does `docker images` reach out to Docker Hub to check for newer versions, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Does `docker images` reach out to Docker Hub to check for newer versions, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explicitly states `docker images` is a purely local, offline listing -- it does not reach out to Docker Hub; it only lists images already pulled or built and sitting in local storage.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-cli-fundamentals'
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
    ($$No -- `docker images` is a purely local, offline listing of what's already stored locally$$, TRUE, 0),
    ($$Yes -- it always contacts Docker Hub first to compare local images against the latest available versions$$, FALSE, 1),
    ($$Yes, but only if the `-a` flag is passed to it$$, FALSE, 2),
    ($$It depends on whether the image was originally pulled or built locally$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-cli-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-cli-fundamentals')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does the `-d` flag do on `docker run`, according to this lesson?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does the `-d` flag do on `docker run`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `-d` ("detached") runs the container in the background and returns the prompt immediately -- without it, `docker run` instead attaches your terminal directly to the container's output, which blocks the terminal until the container stops.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-cli-fundamentals'
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
    ($$Disables all networking for the container being started$$, FALSE, 0),
    ($$Runs the container in the background ("detached") and returns the terminal prompt immediately$$, TRUE, 1),
    ($$Deletes the container automatically as soon as it stops running$$, FALSE, 2),
    ($$Downloads the image without ever starting a container from it$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-cli-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-cli-fundamentals')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this `docker ps` output (no flags), and a second container named `old-cache` that was stopped five minutes ago, would `old-cache` appear in this listing?$$
      AND code_snippet = $$CONTAINER ID   IMAGE         COMMAND                  STATUS         PORTS                    NAMES
7f8e9a0b1c2d   postgres:16   "docker-entrypoint.s…"   Up 2 minutes   0.0.0.0:5432->5432/tcp   learning-platform-db$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this `docker ps` output (no flags), and a second container named `old-cache` that was stopped five minutes ago, would `old-cache` appear in this listing?$$,
           $$CONTAINER ID   IMAGE         COMMAND                  STATUS         PORTS                    NAMES
7f8e9a0b1c2d   postgres:16   "docker-entrypoint.s…"   Up 2 minutes   0.0.0.0:5432->5432/tcp   learning-platform-db$$, $$text$$,
           $$No -- plain `docker ps` only shows running containers by default; a stopped container like `old-cache` would not appear unless `-a` is added (`docker ps -a`), which shows every container regardless of status.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-cli-fundamentals'
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
    ($$Yes, but only because its name starts with a letter earlier in the alphabet than "learning-platform-db"$$, FALSE, 0),
    ($$No -- stopped containers are permanently deleted and can never appear in any `docker ps` output again$$, FALSE, 1),
    ($$No -- plain `docker ps` only shows running containers by default; `old-cache` would need `docker ps -a` to appear$$, TRUE, 2),
    ($$Yes -- `docker ps` always shows every container that has ever existed, running or not$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-cli-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-cli-fundamentals')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the purpose of `docker logs -f`, according to this lesson?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What is the purpose of `docker logs -f`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `-f` follows the log stream continuously, the same way `tail -f` follows a growing file -- this is usually the very first thing to reach for when a container isn't behaving as expected, before anything more involved.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-cli-fundamentals'
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
    ($$It permanently deletes the container's log history after displaying it once$$, FALSE, 0),
    ($$It filters the log output to show only error-level messages$$, FALSE, 1),
    ($$It forces the container to restart and then shows the logs from the fresh start$$, FALSE, 2),
    ($$It follows the container's log stream continuously, the same way `tail -f` follows a growing file$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-cli-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-cli-fundamentals')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this command connecting to an already-running PostgreSQL container, what specifically do the `-i` and `-t` flags together achieve?$$
      AND code_snippet = $$docker exec -it learning-platform-db psql -U postgres$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this command connecting to an already-running PostgreSQL container, what specifically do the `-i` and `-t` flags together achieve?$$,
           $$docker exec -it learning-platform-db psql -U postgres$$, $$bash$$,
           $$The lesson states `-i` keeps standard input open and `-t` allocates a terminal -- together (`-it`) they make the session interactive instead of running one command and immediately exiting, which is why this command drops into an interactive `psql` prompt rather than running a single query and returning.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-cli-fundamentals'
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
    ($$Together they make the session interactive -- `-i` keeps stdin open, `-t` allocates a terminal, instead of running one command and immediately exiting$$, TRUE, 0),
    ($$`-i` installs the `psql` client and `-t` sets a timeout for the command$$, FALSE, 1),
    ($$They have no real effect here -- `psql` would behave identically without either flag$$, FALSE, 2),
    ($$`-it` tells Docker to create a brand-new container instead of using the already-running one$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-cli-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-cli-fundamentals')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about Docker CLI commands, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Docker CLI commands, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (`docker stop` sends a graceful shutdown signal first and only forces termination after a timeout; `docker rm` refuses to remove a still-running container, requiring `docker stop` first or `-f` to force it); `docker rm` explicitly does not touch the image a container was created from (it stays in `docker images` untouched), and `docker exec` only works against a container that's already running, not for starting a brand-new one (that's `docker run`'s job).$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-cli-fundamentals'
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
    ($$`docker exec` can be used to start a brand-new container from an image, the same way `docker run` does$$, FALSE, 0),
    ($$`docker stop` sends a graceful shutdown signal first, only forcing termination after a timeout$$, TRUE, 1),
    ($$`docker rm` refuses to remove a container that's still running, unless `-f` is used to force it$$, TRUE, 2),
    ($$`docker rm` on a container also deletes the image that container was created from$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-cli-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
