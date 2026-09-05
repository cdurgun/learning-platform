-- Promotion-style migration linking EN production-docker-for-java-applications quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/6 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'production-docker-for-java-applications')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does a Dockerfile `HEALTHCHECK` actually let Docker do, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does a Dockerfile `HEALTHCHECK` actually let Docker do, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states HEALTHCHECK tells Docker how to actually ask a running container "are you working?" -- periodically running a command inside the container and tracking whether it succeeds; `docker ps` then shows a container's health status (healthy/unhealthy/starting) instead of just whether the process hasn't crashed.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'production-docker-for-java-applications'
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
    ($$Automatically scale the number of running replicas of a container up or down$$, FALSE, 0),
    ($$Periodically run a command inside the container to check whether it's actually working, visible as a health status in `docker ps`$$, TRUE, 1),
    ($$Automatically restart the container every time its memory usage crosses a configured threshold$$, FALSE, 2),
    ($$Permanently prevent the container from ever being stopped once it starts$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'production-docker-for-java-applications'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'production-docker-for-java-applications')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does adding a `USER appuser` instruction (after `groupadd`/`useradd` and `COPY --chown`) actually change, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does adding a `USER appuser` instruction (after `groupadd`/`useradd` and `COPY --chown`) actually change, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `USER appuser` switches every instruction after it -- including the final ENTRYPOINT's java process -- to run as that unprivileged user instead of root; this is defense in depth, since a compromise of the running Java process no longer automatically hands over root inside the container.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'production-docker-for-java-applications'
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
    ($$It deletes the root user from the image entirely, making root permanently inaccessible even via `docker exec`$$, FALSE, 0),
    ($$It automatically encrypts all files the container writes to disk from that point forward$$, FALSE, 1),
    ($$It switches every instruction after it, including the final running Java process, to run as an unprivileged user instead of root$$, TRUE, 2),
    ($$It has no runtime effect at all -- it only changes what appears in `docker inspect` output$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'production-docker-for-java-applications'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'production-docker-for-java-applications')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to "Basic Image Security Considerations," what happens to a real secret (like a password) set with `ENV` in a Dockerfile, even if that value is later "changed"?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to "Basic Image Security Considerations," what happens to a real secret (like a password) set with `ENV` in a Dockerfile, even if that value is later "changed"?$$,
           NULL, NULL,
           $$The lesson explicitly states a secret set with ENV or hardcoded in a Dockerfile becomes part of the image's own layers, readable by anyone who can pull or inspect it, PERMANENTLY -- it cannot be "removed later"; secrets belong in environment variables supplied at `docker run`/`docker compose up` time instead.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'production-docker-for-java-applications'
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
    ($$It is automatically stripped out of the image the next time `docker build` runs$$, FALSE, 0),
    ($$It only becomes readable if the image is explicitly pushed to a public registry like Docker Hub$$, FALSE, 1),
    ($$It is safely encrypted at rest inside the image, unreadable without a separate decryption key$$, FALSE, 2),
    ($$It becomes a permanent part of the image's own layers, readable by anyone who can pull or inspect it -- it cannot be removed later$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'production-docker-for-java-applications'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'production-docker-for-java-applications')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this multi-stage Dockerfile's builder stage, if only a single Java file in `src/` changes (nothing in `pom.xml`) and the image is rebuilt, which layer(s) actually re-run?$$
      AND code_snippet = $$COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B package -DskipTests$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this multi-stage Dockerfile's builder stage, if only a single Java file in `src/` changes (nothing in `pom.xml`) and the image is rebuilt, which layer(s) actually re-run?$$,
           $$COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B package -DskipTests$$, $$dockerfile$$,
           $$The lesson explains Docker caches each layer and reuses it as long as nothing that layer depends on has changed -- since only a file inside src/ changed and pom.xml didn't, the `COPY pom.xml .` and `RUN mvn dependency:go-offline` layers are reused from cache, and only `COPY src ./src` and everything after it re-run.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'production-docker-for-java-applications'
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
    ($$Only `COPY src ./src` and `RUN mvn -B package -DskipTests` re-run -- the `pom.xml` copy and dependency download are reused from cache$$, TRUE, 0),
    ($$All four instructions re-run from scratch, including re-downloading every dependency `pom.xml` declares$$, FALSE, 1),
    ($$Nothing re-runs at all -- Docker considers the entire builder stage permanently cached once built the first time$$, FALSE, 2),
    ($$Only `RUN mvn -B dependency:go-offline` re-runs, since that's the layer responsible for compiling Java source files$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'production-docker-for-java-applications'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'production-docker-for-java-applications')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Does adding a `healthcheck:` to a Compose `db` service automatically make Compose wait for it before starting `app`, according to this lesson?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Does adding a `healthcheck:` to a Compose `db` service automatically make Compose wait for it before starting `app`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states a HEALTHCHECK/healthcheck alone only provides visibility (docker ps status) -- it's the long-form `depends_on: db: condition: service_healthy` that actually makes Compose wait for the healthcheck to succeed before starting the dependent service; adding a healthcheck but never referencing it with `condition: service_healthy` is explicitly named as a common mistake.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'production-docker-for-java-applications'
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
    ($$This lesson doesn't cover any relationship between `healthcheck:` and `depends_on` at all$$, FALSE, 0),
    ($$No -- a healthcheck alone only provides visibility; `depends_on: db: condition: service_healthy` is what actually makes `app` wait for it$$, TRUE, 1),
    ($$Yes -- any `healthcheck:` defined on a service is automatically waited on by every other service in the same file$$, FALSE, 2),
    ($$Yes, but only if the service is named `db` specifically -- any other name is ignored by Compose entirely$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'production-docker-for-java-applications'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'production-docker-for-java-applications')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about production Docker practices for Java applications, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about production Docker practices for Java applications, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson ("Basic Image Security Considerations" recommends pinning exact tags rather than `:latest`, applying just as much to production as it did in "Docker CLI Fundamentals"; the same section recommends keeping the base image and what's installed on top of it minimal, justifying every added package); the lesson doesn't claim reordering `COPY src ./src` before the dependency-download step improves caching (it's explicitly named as silently undoing the layer-caching benefit), and `pg_isready` is described as a real utility already installed inside the official `postgres` image, not something this lesson's authors wrote from scratch.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'production-docker-for-java-applications'
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
    ($$Reordering a multi-stage Dockerfile so `COPY src ./src` happens before the dependency-download step improves Docker's layer-caching behavior$$, FALSE, 0),
    ($$`pg_isready`, used in the Compose `healthcheck` example, is a custom script this lesson wrote specifically for checking PostgreSQL readiness$$, FALSE, 1),
    ($$Pinning exact image tags (never `:latest`), a practice already covered in "Docker CLI Fundamentals," is stated to apply just as much in production$$, TRUE, 2),
    ($$Keeping the base image and what's installed on top of it minimal -- justifying every added package -- is one of this lesson's basic image security considerations$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'production-docker-for-java-applications'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
