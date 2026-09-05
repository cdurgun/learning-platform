-- Promotion-style migration linking EN what-is-docker quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 5 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/5 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-docker')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, what is Docker?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what is Docker?$$,
           NULL, NULL,
           $$The lesson defines Docker as a platform for packaging an application together with everything it needs to run (dependencies, runtime, configuration) into a portable container, then running that unit consistently on any machine that has Docker installed.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-docker'
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
    ($$A platform for packaging an application with everything it needs to run into a portable container, run consistently on any machine with Docker installed$$, TRUE, 0),
    ($$A full virtual machine hypervisor that emulates hardware for running any operating system$$, FALSE, 1),
    ($$A cloud hosting provider that runs applications on Docker's own remote servers$$, FALSE, 2),
    ($$A build tool that replaces Maven for compiling and packaging Java source code$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-docker'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-docker')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What specific, recurring problem does this lesson say Docker exists to solve?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What specific, recurring problem does this lesson say Docker exists to solve?$$,
           NULL, NULL,
           $$The lesson names "it works on my machine" as the specific problem -- before containers, deploying meant relying on the target machine already having the right JDK version, environment variables, and no conflicting dependencies, so mismatches between a developer's machine, test, and production could cause bugs that only reproduce in one place.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-docker'
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
    ($$The problem of relational databases not supporting enough concurrent connections$$, FALSE, 0),
    ($$The "it works on my machine" problem -- mismatches between a developer's machine, test, and production environments causing bugs that only reproduce in one place$$, TRUE, 1),
    ($$The problem of Java code running too slowly compared to other programming languages$$, FALSE, 2),
    ($$The problem of Maven Central being unreachable from certain corporate networks$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-docker'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-docker')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to "Containers vs. Virtual Machines," what is the fundamental architectural difference that explains why a container starts dramatically faster than a virtual machine?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to "Containers vs. Virtual Machines," what is the fundamental architectural difference that explains why a container starts dramatically faster than a virtual machine?$$,
           NULL, NULL,
           $$A container runs directly on the host machine's existing kernel (isolated by Linux namespaces/cgroups), with no second operating system underneath it, while a VM runs a complete guest OS on top of a hypervisor -- the practical consequence is that a container has no OS to boot, only the application process starting directly.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-docker'
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
    ($$A container is always run on more powerful hardware than a virtual machine$$, FALSE, 0),
    ($$A container skips loading application dependencies entirely, unlike a virtual machine$$, FALSE, 1),
    ($$A container shares the host machine's existing kernel directly, with no guest OS to boot; a VM runs a full guest OS on top of a hypervisor$$, TRUE, 2),
    ($$A container uses a faster programming language internally than a virtual machine does$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-docker'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-docker')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A team builds one Spring Boot image and starts three separate containers from it, all running at the same time. According to "Images vs. Containers," what happens to the original image?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A team builds one Spring Boot image and starts three separate containers from it, all running at the same time. According to "Images vs. Containers," what happens to the original image?$$,
           NULL, NULL,
           $$The lesson states starting a container from an image doesn't consume or modify that image -- the same image can be used to start any number of containers independently, and the image itself stays exactly as it was built; an image is a read-only, frozen template, and a container is a running instance created from it (like a class and its instances).$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-docker'
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
    ($$The image is deleted automatically once the third container starts from it$$, FALSE, 0),
    ($$The image is split into three separate copies, one dedicated to each container$$, FALSE, 1),
    ($$The image is locked and cannot be used to start any further containers until all three stop$$, FALSE, 2),
    ($$The image stays exactly as it was built -- it is not consumed or modified by starting containers from it, and can back any number of independent containers$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-docker'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (Pair 5 EN, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-docker')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about Docker's core mechanics, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Docker's core mechanics, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (the Docker Engine/dockerd is the daemon that actually does the work, with the CLI as a thin client talking to it; a registry stores images by name and tag, the same way Maven Central stores JAR artifacts by coordinate); the lesson does not claim `docker pull` always builds an image locally from scratch (that's the opposite of what a registry pull does), and it explicitly says Docker Hub is the default registry, not the only possible one.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-docker'
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
    ($$The Docker Engine (`dockerd`) is the background daemon that actually builds images and runs containers; the `docker` CLI is a thin client that talks to it$$, TRUE, 0),
    ($$An image registry stores images under a name and tag, the same way Maven Central stores JAR artifacts under a group, artifact, and version$$, TRUE, 1),
    ($$`docker pull` always builds a new image locally from scratch rather than fetching an already-built one from a registry$$, FALSE, 2),
    ($$Docker Hub is the only registry a Docker installation can ever pull images from -- private or self-hosted registries are not possible$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-docker'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
