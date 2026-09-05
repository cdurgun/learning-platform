-- Promotion-style migration linking EN dockerizing-a-spring-boot-application quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/6 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dockerizing-a-spring-boot-application')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Does `mvn package` need to change in any way to work with Docker, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Does `mvn package` need to change in any way to work with Docker, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `mvn package` already produces a single, self-contained, runnable JAR before Docker enters the picture at all, and nothing about that changes here -- what a Dockerfile adds is a way to package that already-built JAR together with a matching Java runtime into one image.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dockerizing-a-spring-boot-application'
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
    ($$No, but only because this specific project doesn't use `spring-boot-starter-parent`$$, FALSE, 0),
    ($$No -- `mvn package` already produces the same self-contained JAR either way; Docker just packages that existing JAR with a matching Java runtime$$, TRUE, 1),
    ($$Yes -- Docker requires a completely different Maven plugin to produce a Docker-compatible JAR format$$, FALSE, 2),
    ($$Yes -- `mvn package` must be replaced with `docker package` once Docker is introduced$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dockerizing-a-spring-boot-application'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dockerizing-a-spring-boot-application')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does this lesson choose a JRE-only base image (`eclipse-temurin:21-jre`) rather than a full JDK image for the final Spring Boot container?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why does this lesson choose a JRE-only base image (`eclipse-temurin:21-jre`) rather than a full JDK image for the final Spring Boot container?$$,
           NULL, NULL,
           $$The lesson states the JAR is already fully built before the Dockerfile even runs, so the final image only ever needs to run it -- a JRE image is enough, and deliberately smaller than a JDK one, since a JDK's compiler and build tooling have no use once the JAR already exists.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dockerizing-a-spring-boot-application'
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
    ($$`eclipse-temurin` doesn't publish a JRE variant, so JDK is the only available choice$$, FALSE, 0),
    ($$A JRE image is required specifically because this project's `pom.xml` sets `<java.version>21</java.version>`$$, FALSE, 1),
    ($$The JAR is already fully built before the Dockerfile runs, so the final image only needs to run it -- a JRE is enough and deliberately smaller than a JDK image$$, TRUE, 2),
    ($$A JDK image is technically incompatible with running any already-compiled JAR file$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dockerizing-a-spring-boot-application'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dockerizing-a-spring-boot-application')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does a `.dockerignore` file do, according to this lesson?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does a `.dockerignore` file do, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states .dockerignore excludes paths from the build context the same way .gitignore excludes files from a commit -- without it, the build context includes everything in the project folder (.git's full history, IDE configuration), none of which the image actually needs, and a smaller context also makes every build meaningfully faster.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dockerizing-a-spring-boot-application'
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
    ($$It excludes specific Java classes from being compiled by Maven before the Docker build starts$$, FALSE, 0),
    ($$It lists which Docker Hub registries the build process is allowed to pull base images from$$, FALSE, 1),
    ($$It permanently deletes files from the host machine's filesystem after a successful `docker build`$$, FALSE, 2),
    ($$It excludes paths from the build context, the same way `.gitignore` excludes files from a commit -- making builds smaller and faster$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dockerizing-a-spring-boot-application'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dockerizing-a-spring-boot-application')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the key benefit of a multi-stage build, as described in this lesson?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What is the key benefit of a multi-stage build, as described in this lesson?$$,
           NULL, NULL,
           $$The lesson states a multi-stage build's first stage (named `builder`) runs `mvn package` inside the container itself, with no dependency on Maven or a JDK already being installed on the host; the final stage starts fresh from a small JRE base and copies out only the finished JAR, so Maven, the JDK, pom.xml, and the full src tree never become part of the final image.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dockerizing-a-spring-boot-application'
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
    ($$It builds the JAR inside Docker itself (no host Maven/JDK required) while keeping the final image small, since only the finished JAR is copied into the last stage$$, TRUE, 0),
    ($$It runs the application twice for redundancy, in case one running instance crashes unexpectedly$$, FALSE, 1),
    ($$It allows a single Dockerfile to target two completely unrelated applications at once$$, FALSE, 2),
    ($$It automatically encrypts the final image so its contents can't be inspected by anyone who pulls it$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dockerizing-a-spring-boot-application'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dockerizing-a-spring-boot-application')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A container is started with `docker run -m 512m learning-platform:0.1.0`, and its Dockerfile uses only `ENTRYPOINT ["java", "-jar", "app.jar"]` with no explicit `-XX:MaxRAMPercentage`. According to this lesson, roughly what percentage of the 512MB limit does the JVM use for its heap by default?$$
      AND code_snippet = $$docker run -m 512m learning-platform:0.1.0

# Dockerfile ENTRYPOINT (no explicit MaxRAMPercentage set):
# ENTRYPOINT ["java", "-jar", "app.jar"]$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A container is started with `docker run -m 512m learning-platform:0.1.0`, and its Dockerfile uses only `ENTRYPOINT ["java", "-jar", "app.jar"]` with no explicit `-XX:MaxRAMPercentage`. According to this lesson, roughly what percentage of the 512MB limit does the JVM use for its heap by default?$$,
           $$docker run -m 512m learning-platform:0.1.0

# Dockerfile ENTRYPOINT (no explicit MaxRAMPercentage set):
# ENTRYPOINT ["java", "-jar", "app.jar"]$$, $$bash$$,
           $$The lesson states that since Java 10, the JVM is container-aware and by default sizes its heap as a percentage of the container's memory limit via -XX:MaxRAMPercentage, which defaults to 25.0 -- so with no explicit override, roughly 25% of the 512MB limit is used for the heap, described in the lesson as "a fairly small heap for a real Spring Boot application."$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dockerizing-a-spring-boot-application'
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
    ($$0% -- without an explicit `-XX:MaxRAMPercentage`, the JVM fails to start inside any memory-limited container$$, FALSE, 0),
    ($$Roughly 25% -- `-XX:MaxRAMPercentage` defaults to 25.0, described in the lesson as a fairly small heap for a real application$$, TRUE, 1),
    ($$Roughly 100% -- the JVM always uses the entire container memory limit for its heap by default$$, FALSE, 2),
    ($$Roughly 75% -- 75.0 is the JVM's actual out-of-the-box default for `-XX:MaxRAMPercentage`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dockerizing-a-spring-boot-application'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dockerizing-a-spring-boot-application')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about dockerizing this Spring Boot application, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about dockerizing this Spring Boot application, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (a single-stage Dockerfile requires `mvn package` to already have been run on the host before `docker build`, since COPY needs the JAR to already exist; `COPY --from=builder` only works because the earlier stage was explicitly named via `AS builder`); the lesson doesn't recommend hardcoding a fixed -Xmx value (it explicitly warns against this, since it silently stops matching reality when the container's memory limit changes), and `host.docker.internal` is described as reaching a service on the host machine, not the recommended way for two containers that are meant to run together to reach each other (that's the subject of the next lesson, "Docker Networking").$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dockerizing-a-spring-boot-application'
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
    ($$Hardcoding a fixed `-Xmx` value is recommended over the JVM's default container-aware heap sizing in every case$$, FALSE, 0),
    ($$`host.docker.internal` is this lesson's recommended way for two containers that are meant to run together to reach each other$$, FALSE, 1),
    ($$A single-stage Dockerfile requires `mvn package` to already have been run on the host machine before `docker build`, so `COPY` can find the JAR$$, TRUE, 2),
    ($$`COPY --from=builder` only works because the earlier stage was explicitly given that name via `FROM ... AS builder`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dockerizing-a-spring-boot-application'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
