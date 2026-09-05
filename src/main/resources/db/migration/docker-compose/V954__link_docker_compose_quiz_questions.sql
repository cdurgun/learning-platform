-- Promotion-style migration linking EN docker-compose quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/6 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-compose')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does Docker Compose fundamentally do, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does Docker Compose fundamentally do, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states Compose reads a YAML file describing a set of related containers (services) and brings all of them up, or tears all of them down, with one command each -- nothing about the underlying mechanism changes, it just derives network/volume/container creation from one file instead of requiring each command to be typed separately.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-compose'
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
    ($$It's a tool exclusively for building Dockerfiles, unrelated to running containers$$, FALSE, 0),
    ($$It automatically writes Java source code based on a project's dependencies$$, FALSE, 1),
    ($$It reads a YAML file describing a set of services and brings them all up (or down) with one command each, instead of typing each `docker` command by hand$$, TRUE, 2),
    ($$It replaces the Docker Engine entirely with a completely different container runtime$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-compose'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-compose')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A `docker-compose.yml`'s `db` service lists `db-data:/var/lib/postgresql/data` under its `volumes:` key, but `db-data` is never declared anywhere else in the file. What happens, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A `docker-compose.yml`'s `db` service lists `db-data:/var/lib/postgresql/data` under its `volumes:` key, but `db-data` is never declared anywhere else in the file. What happens, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states a named volume referenced in a service's `volumes:` list has to be declared once at the file's top level -- a service can't invent a volume name Compose hasn't been told about anywhere else in the file; this is explicitly named as a common mistake.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-compose'
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
    ($$Nothing -- Compose automatically infers and declares any volume name it sees referenced by a service$$, FALSE, 0),
    ($$Compose silently falls back to using a bind mount instead of a named volume in this situation$$, FALSE, 1),
    ($$This is fine as long as the service using it is named `db` specifically$$, FALSE, 2),
    ($$This is a problem -- a service can't reference a volume name that was never declared at the file's top-level `volumes:` section$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-compose'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-compose')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Does `depends_on: [db]` guarantee that PostgreSQL inside the `db` container is actually ready to accept connections before `app` starts, according to this lesson?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Does `depends_on: [db]` guarantee that PostgreSQL inside the `db` container is actually ready to accept connections before `app` starts, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explicitly warns that `depends_on` on its own only waits for the `db` container to START, not for PostgreSQL inside it to actually be ready to accept connections -- a slow-starting database can still cause `app` to fail its first connection attempt even with `depends_on` in place.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-compose'
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
    ($$No -- it only waits for the `db` container to start, not for PostgreSQL inside it to actually be ready to accept connections$$, TRUE, 0),
    ($$Yes -- `depends_on` always waits for the full application inside a dependency to be completely ready before starting the next service$$, FALSE, 1),
    ($$Yes, but only for services using the official `postgres` image specifically$$, FALSE, 2),
    ($$This lesson doesn't address readiness at all -- `depends_on` is described as having no effect on startup order whatsoever$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-compose'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-compose')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this `docker-compose.yml` excerpt, what hostname does the `app` service use to reach PostgreSQL, and why does it work without any `docker network create` command?$$
      AND code_snippet = $$services:
  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: secret
  app:
    build: .
    depends_on:
      - db
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/postgres$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this `docker-compose.yml` excerpt, what hostname does the `app` service use to reach PostgreSQL, and why does it work without any `docker network create` command?$$,
           $$services:
  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: secret
  app:
    build: .
    depends_on:
      - db
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/postgres$$, $$yaml$$,
           $$The lesson explains every service in one docker-compose.yml is automatically placed on the same, Compose-created network, and each service's name becomes its hostname for every other service in that file -- no manual `docker network create` or `--network` required, which is exactly why `db:5432` resolves here.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-compose'
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
    ($$It cannot work at all without an explicit `docker network create` command run before `docker compose up`$$, FALSE, 0),
    ($$`db` -- Compose automatically places every service in one file on the same network, where each service's name becomes its hostname$$, TRUE, 1),
    ($$`localhost` -- Compose always rewrites service hostnames to `localhost` internally before starting containers$$, FALSE, 2),
    ($$The service's actual container ID -- Compose has no concept of hostnames at all, only raw container IDs$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-compose'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-compose')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Does plain `docker compose down` (no flags) remove the named volumes declared in the Compose file, according to this lesson?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Does plain `docker compose down` (no flags) remove the named volumes declared in the Compose file, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `docker compose down` deliberately does NOT touch named volumes by default -- a volume is meant to outlive routine container lifecycle events, and down treats itself as an ordinary teardown, not a data-destroying one; `docker compose down -v` is the explicit opt-in to remove volumes too.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-compose'
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
    ($$Yes, but only for volumes attached to a service named `db` specifically$$, FALSE, 0),
    ($$This lesson doesn't specify volume behavior for `docker compose down` at all$$, FALSE, 1),
    ($$No -- plain `docker compose down` deliberately leaves named volumes intact by default; `-v` is the explicit opt-in to remove them too$$, TRUE, 2),
    ($$Yes -- `docker compose down` always removes every named volume declared in the file, with no way to prevent it$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-compose'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-compose')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about Docker Compose, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Docker Compose, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (`build: .` tells Compose to build the project's own Dockerfile instead of pulling a pre-built image, the same effect as running `docker build` by hand; Compose prefixes a volume's real name with the project's own name at creation time, visible as e.g. `learning-platform_db-data` in `docker volume ls`); the lesson doesn't say `ports:` in Compose is unrelated to `-p` on `docker run` (it's explicitly described as the same mechanism), and it doesn't recommend hardcoding a container's manually-chosen name into a Compose service (Compose's automatic networking uses service names from the same file, not names given to containers elsewhere).$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-compose'
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
    ($$Compose prefixes a declared volume's real name with the project's own name at creation time (e.g. `learning-platform_db-data`, not just `db-data`)$$, TRUE, 0),
    ($$A service's `ports:` setting in Compose is an entirely different mechanism from `-p` on `docker run`, with no real equivalence between them$$, FALSE, 1),
    ($$This lesson recommends hardcoding another container's manually-chosen `--name` into a Compose service's configuration, instead of using that other service's name from the same file$$, FALSE, 2),
    ($$`build: .` tells Compose to build the project's own Dockerfile instead of pulling a pre-built image, the same effect as running `docker build` by hand$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-compose'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
