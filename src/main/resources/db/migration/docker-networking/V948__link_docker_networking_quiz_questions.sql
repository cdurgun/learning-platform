-- Promotion-style migration linking EN docker-networking quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/6 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-networking')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Can two containers on Docker's default bridge network reach each other by container name, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Can two containers on Docker's default bridge network reach each other by container name, according to this lesson?$$,
           NULL, NULL,
           $$The lesson is explicit with a warning: containers on Docker's default bridge network CANNOT reach each other by container name -- only by IP address, which changes every time a container restarts. This is a genuine, documented Docker limitation; the fix is a user-defined network.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-networking'
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
    ($$No -- they can only reach each other by IP address on the default bridge network, and that IP changes on every restart$$, TRUE, 0),
    ($$Yes -- name-based resolution works automatically on every network Docker creates, including the default bridge$$, FALSE, 1),
    ($$Yes, but only if `EXPOSE` is set in both containers' Dockerfiles$$, FALSE, 2),
    ($$No -- containers on the default bridge network cannot communicate with each other at all, by any means$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-networking'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-networking')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does `-p <host-port>:<container-port>` actually solve, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does `-p <host-port>:<container-port>` actually solve, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `-p` is specifically a host-to-container bridge -- it maps a port on the host machine to a port inside a container's own isolated network namespace; it has nothing to do with how two containers reach each other, which is a completely separate concern.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-networking'
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
    ($$It automatically creates a user-defined network for every container it's applied to$$, FALSE, 0),
    ($$It bridges the host machine to a container's port -- it has nothing to do with how two containers reach each other$$, TRUE, 1),
    ($$It's exactly how two containers on the same network resolve each other by name$$, FALSE, 2),
    ($$It permanently disables a container's access to the outside internet$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-networking'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-networking')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does creating a user-defined network with `docker network create` provide that the default bridge network doesn't, according to this lesson?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does creating a user-defined network with `docker network create` provide that the default bridge network doesn't, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states a user-defined bridge network comes with automatic DNS-based name resolution between the containers attached to it -- Docker runs an embedded DNS server specifically so one container can reach another using the other container's `--name` as a hostname.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-networking'
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
    ($$Automatic encryption of all traffic between every container attached to it$$, FALSE, 0),
    ($$The ability to run containers without needing Docker itself installed on the host machine$$, FALSE, 1),
    ($$Automatic DNS-based name resolution between attached containers -- one container can reach another using its `--name` as a hostname$$, TRUE, 2),
    ($$Automatically faster network throughput compared to any container on the default bridge network$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-networking'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-networking')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this JDBC URL, running inside an `app` container that is attached to the same user-defined network as a `db` container, what does `learning-platform-db` resolve to?$$
      AND code_snippet = $$docker run --name learning-platform-app \
  --network learning-platform-net \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://learning-platform-db:5432/postgres \
  -d learning-platform:0.1.0$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this JDBC URL, running inside an `app` container that is attached to the same user-defined network as a `db` container, what does `learning-platform-db` resolve to?$$,
           $$docker run --name learning-platform-app \
  --network learning-platform-net \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://learning-platform-db:5432/postgres \
  -d learning-platform:0.1.0$$, $$bash$$,
           $$The lesson explains that `learning-platform-db` in this JDBC URL isn't a real internet DNS hostname -- it resolves only inside `learning-platform-net`, to whatever container is currently running with that `--name` on that same user-defined network, thanks to Docker's embedded DNS server.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-networking'
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
    ($$The host machine's own loopback interface, exactly the same as `localhost` would inside this container$$, FALSE, 0),
    ($$A real, public internet hostname that any machine outside Docker could also resolve$$, FALSE, 1),
    ($$Nothing -- this URL will always fail to resolve unless `-p` is also used to publish a port$$, FALSE, 2),
    ($$Whatever container is currently running with the `--name` `learning-platform-db` on the same `learning-platform-net` network$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-networking'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-networking')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Inside a container, what does `localhost` (or `127.0.0.1`) refer to, according to this lesson?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Inside a container, what does `localhost` (or `127.0.0.1`) refer to, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states every container gets its own, isolated network namespace, so `localhost` inside a container refers to that container's own loopback interface -- not the host machine's, and not any other container's; this is exactly why reaching another container requires using its `--name`, not `localhost`.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-networking'
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
    ($$That container's own loopback interface -- never the host machine's, and never another container's$$, TRUE, 0),
    ($$The host machine's loopback interface, exactly the same as it would on a non-containerized process$$, FALSE, 1),
    ($$Whichever other container was most recently started on the same network$$, FALSE, 2),
    ($$A dynamically chosen container, selected by Docker's embedded DNS server at random$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-networking'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-networking')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about Docker networking, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Docker networking, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (`docker network inspect <name>` shows exactly which containers are currently attached to a given network, the fastest way to confirm two containers are on the same one; `host.docker.internal` reaches a service on the host machine, a fundamentally different situation from two containers reaching each other by name); the lesson explicitly frames `-p` and `--network` as solving different problems, not as interchangeable, and it names the user-defined network -- not the default bridge -- as what every real multi-container setup, including Docker Compose, actually uses.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-networking'
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
    ($$Every real multi-container setup, including Docker Compose, is described in this lesson as relying on Docker's default bridge network$$, FALSE, 0),
    ($$`docker network inspect <name>` shows exactly which containers are currently attached to a given network$$, TRUE, 1),
    ($$`host.docker.internal` (reaching the host machine) and a container's `--name` on a user-defined network (reaching another container) solve two different problems$$, TRUE, 2),
    ($$`-p` and `--network` solve the exact same problem and can always be used interchangeably$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-networking'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
