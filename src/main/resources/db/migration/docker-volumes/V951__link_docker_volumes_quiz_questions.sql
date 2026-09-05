-- Promotion-style migration linking EN docker-volumes quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/6 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-volumes')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does removing a container with no volume configured permanently delete the data it wrote, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why does removing a container with no volume configured permanently delete the data it wrote, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states everything a running container writes lives in that container's own writable layer, sitting on top of the read-only image -- that layer is part of the container itself, so `docker rm` deletes it along with everything else about that specific container instance.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-volumes'
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
    ($$Because `docker rm` always deletes every image and volume on the entire host machine, not just one container$$, FALSE, 0),
    ($$Because containers are not actually allowed to write any data to disk in the first place$$, FALSE, 1),
    ($$Because the data is automatically uploaded to Docker Hub and only accessible there afterward$$, FALSE, 2),
    ($$Because everything the container writes lives in its own writable layer, which `docker rm` deletes along with the rest of the container$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-volumes'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-volumes')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Does a named volume created with `docker volume create` depend on any single container that will eventually use it, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Does a named volume created with `docker volume create` depend on any single container that will eventually use it, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states creating a named volume is a single command, independent of any container that will eventually use it -- because a volume exists independently, it survives exactly the event that destroys a container's own writable layer: `docker rm`.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-volumes'
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
    ($$No -- a named volume exists independently of any single container, and survives `docker rm` for exactly that reason$$, TRUE, 0),
    ($$Yes -- a named volume is permanently deleted the moment the container using it is removed$$, FALSE, 1),
    ($$Yes -- a named volume can only ever be attached to exactly the one container that originally created it$$, FALSE, 2),
    ($$No, but only for volumes used by the official `postgres` image specifically$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-volumes'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-volumes')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does the volume in `-v learning-platform-db-data:/var/lib/postgresql/data` specifically need to be mounted at `/var/lib/postgresql/data`, according to this lesson?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why does the volume in `-v learning-platform-db-data:/var/lib/postgresql/data` specifically need to be mounted at `/var/lib/postgresql/data`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `/var/lib/postgresql/data` isn't an arbitrary path -- it's exactly where the official `postgres` image stores its actual database files by default; mounting a volume at that specific path is what separates a container whose data disappears when removed from one whose data outlives it.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-volumes'
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
    ($$Because `/var/lib/postgresql/data` is required by `docker volume create`'s own internal implementation$$, FALSE, 0),
    ($$Because that's exactly where the official `postgres` image stores its actual database files by default -- mounting anywhere else wouldn't capture that data$$, TRUE, 1),
    ($$The path is arbitrary -- any path at all works identically for capturing PostgreSQL's data$$, FALSE, 2),
    ($$Because Docker itself hardcodes that exact path for every volume mount, regardless of image$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-volumes'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-volumes')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this sequence, if `learning-platform-db-data` is a properly mounted named volume, what does the final `SELECT` return?$$
      AND code_snippet = $$docker exec -it learning-platform-db psql -U postgres -c "INSERT INTO proof (note) VALUES ('still here');"

docker stop learning-platform-db
docker rm learning-platform-db

docker run --name learning-platform-db -v learning-platform-db-data:/var/lib/postgresql/data -d postgres:16

docker exec -it learning-platform-db psql -U postgres -c "SELECT * FROM proof;"$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this sequence, if `learning-platform-db-data` is a properly mounted named volume, what does the final `SELECT` return?$$,
           $$docker exec -it learning-platform-db psql -U postgres -c "INSERT INTO proof (note) VALUES ('still here');"

docker stop learning-platform-db
docker rm learning-platform-db

docker run --name learning-platform-db -v learning-platform-db-data:/var/lib/postgresql/data -d postgres:16

docker exec -it learning-platform-db psql -U postgres -c "SELECT * FROM proof;"$$, $$bash$$,
           $$The lesson describes this exact sequence as the real test of a volume working: because the data lived in the volume (not the removed container's writable layer), the new container mounted against the same volume picks up right where the previous one left off -- the row with "still here" is returned.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-volumes'
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
    ($$An error, since a new container can never be started with the same `--name` as a removed one$$, FALSE, 0),
    ($$An error, since `-v` cannot be combined with `--name` in the same `docker run` command$$, FALSE, 1),
    ($$The row containing "still here" -- the volume, not the container, was where the data actually lived the whole time$$, TRUE, 2),
    ($$An empty result -- `docker rm` also deletes any volume that was mounted into the removed container$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-volumes'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-volumes')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to "Named Volumes vs. Bind Mounts," when is a bind mount the right tool instead of a named volume?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to "Named Volumes vs. Bind Mounts," when is a bind mount the right tool instead of a named volume?$$,
           NULL, NULL,
           $$The lesson states a bind mount is for when a specific host path matters -- like mounting a project's own source code into a container during local development -- while a named volume is for data a container manages and Docker should own the lifecycle of, exactly PostgreSQL's own data files.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-volumes'
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
    ($$Whenever a database's data files need to persist across container restarts -- a bind mount is always preferred there$$, FALSE, 0),
    ($$Never -- this lesson recommends using only named volumes for every possible use case$$, FALSE, 1),
    ($$Only when the container is running the official `postgres` image specifically$$, FALSE, 2),
    ($$When a specific host path matters, such as mounting a project's own source code into a container during local development$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-volumes'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-volumes')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about Docker volumes, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Docker volumes, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (`docker volume rm` only succeeds if no container currently has that volume mounted, and it's the one command that genuinely, deliberately destroys persisted data; `docker stop`/`docker start` on the same container don't touch its writable layer, so data written there survives a stop/start cycle); the lesson does not claim `docker stop` deletes any data (it explicitly says stopping and restarting the same container leaves the data intact), and it explicitly recommends named volumes, not bind mounts, for a database's own data directory.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-volumes'
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
    ($$`docker volume rm` only succeeds if no container currently has that volume mounted, and it genuinely, permanently destroys the volume's data$$, TRUE, 0),
    ($$`docker stop` followed by `docker start` on the same container does not touch that container's writable layer -- data written there survives the cycle$$, TRUE, 1),
    ($$Running `docker stop` on a container immediately and permanently deletes any data written to its writable layer$$, FALSE, 2),
    ($$This lesson recommends a bind mount, not a named volume, specifically for a database's own data directory$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-volumes'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
