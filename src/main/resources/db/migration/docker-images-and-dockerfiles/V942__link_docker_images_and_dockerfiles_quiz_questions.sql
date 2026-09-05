-- Promotion-style migration linking EN docker-images-and-dockerfiles quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-images-and-dockerfiles')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is a Dockerfile, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is a Dockerfile, according to this lesson?$$,
           NULL, NULL,
           $$The lesson defines a Dockerfile as a plain-text file, conventionally named exactly "Dockerfile" with no extension, containing a sequence of instructions Docker executes in order to produce an image -- each instruction adds one new, cached layer on top of the previous one.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-images-and-dockerfiles'
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
    ($$A configuration file exclusively for setting a container's network settings after it starts$$, FALSE, 0),
    ($$A JSON file listing which Maven dependencies a Spring Boot application needs$$, FALSE, 1),
    ($$A plain-text file containing a sequence of instructions Docker executes in order to produce an image, each adding a new cached layer$$, TRUE, 2),
    ($$A compiled binary file that Docker runs directly as a container without any build step$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-images-and-dockerfiles'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-images-and-dockerfiles')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does this lesson choose `alpine:3.20` as the `FROM` base image for its minimal web server example?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why does this lesson choose `alpine:3.20` as the `FROM` base image for its minimal web server example?$$,
           NULL, NULL,
           $$The lesson states Alpine Linux is a common base specifically because it's a real, minimal Linux distribution, only a few megabytes, with a package manager (`apk`) for anything more it needs -- a deliberately small starting point instead of a general-purpose OS image with unused tools.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-images-and-dockerfiles'
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
    ($$It's the only base image Docker officially supports for the `FROM` instruction$$, FALSE, 0),
    ($$It comes with a full JDK and Maven already preinstalled, unlike any other base image$$, FALSE, 1),
    ($$It's required specifically because the example server is written in Java$$, FALSE, 2),
    ($$It's a real, minimal Linux distribution (only a few megabytes) with a package manager for anything else needed -- a deliberately small starting point$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-images-and-dockerfiles'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-images-and-dockerfiles')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does `WORKDIR /app` do, and what happens to later instructions like `COPY` if it's never set?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does `WORKDIR /app` do, and what happens to later instructions like `COPY` if it's never set?$$,
           NULL, NULL,
           $$The lesson states WORKDIR sets the directory every subsequent instruction runs relative to (creating it if needed); without it, later instructions like COPY and RUN operate relative to the image's filesystem root -- technically valid, but it mixes an application's files in with the base image's own system directories.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-images-and-dockerfiles'
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
    ($$It sets the directory later instructions run relative to; without it, COPY/RUN operate relative to the filesystem root, mixing app files with system directories$$, TRUE, 0),
    ($$It has no functional effect at all -- it exists purely as a comment for human readers of the Dockerfile$$, FALSE, 1),
    ($$It permanently deletes any files already present at the given path inside the base image$$, FALSE, 2),
    ($$It sets an environment variable that the running container's application code can read at runtime$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-images-and-dockerfiles'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-images-and-dockerfiles')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Where can a `COPY` instruction in a Dockerfile read files from, according to this lesson?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Where can a `COPY` instruction in a Dockerfile read files from, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states COPY brings a file or directory from the build context -- the folder `docker build` is run from -- into the image; it only ever reads from the build context on the host machine, and cannot reach outside it, which is exactly why `docker build` must be run from the folder containing everything the image needs.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-images-and-dockerfiles'
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
    ($$Directly from a remote Git repository URL, without needing any local files at all$$, FALSE, 0),
    ($$Only from the build context -- the folder `docker build` is run from -- and cannot reach outside it$$, TRUE, 1),
    ($$From anywhere on the host machine's filesystem, regardless of where `docker build` is run from$$, FALSE, 2),
    ($$Only from files already present inside the base image specified by `FROM`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-images-and-dockerfiles'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-images-and-dockerfiles')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given a Dockerfile that only sets `CMD ["echo", "Hello from CMD"]` (no ENTRYPOINT), what does running `docker run my-image echo "Overridden"` print?$$
      AND code_snippet = $$docker run my-image
# Output: Hello from CMD

docker run my-image echo "Overridden"
# Output: Overridden$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given a Dockerfile that only sets `CMD ["echo", "Hello from CMD"]` (no ENTRYPOINT), what does running `docker run my-image echo "Overridden"` print?$$,
           $$docker run my-image
# Output: Hello from CMD

docker run my-image echo "Overridden"
# Output: Overridden$$, $$bash$$,
           $$The lesson states that with only CMD, any command given to docker run REPLACES it entirely -- so supplying `echo "Overridden"` as extra arguments replaces the whole CMD, and the container prints "Overridden", exactly as shown.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-images-and-dockerfiles'
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
    ($$Hello from CMD
Overridden  (both lines print, one after the other)$$, FALSE, 0),
    ($$An error, since `docker run` cannot accept extra arguments when only CMD is set$$, FALSE, 1),
    ($$Overridden$$, TRUE, 2),
    ($$Hello from CMD$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-images-and-dockerfiles'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-images-and-dockerfiles')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given a Dockerfile with `ENTRYPOINT ["echo"]` and `CMD ["Hello from CMD"]`, what does running `docker run my-image "Overridden"` print?$$
      AND code_snippet = $$docker run my-image
# Output: Hello from CMD

docker run my-image "Overridden"
# Output: Overridden$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given a Dockerfile with `ENTRYPOINT ["echo"]` and `CMD ["Hello from CMD"]`, what does running `docker run my-image "Overridden"` print?$$,
           $$docker run my-image
# Output: Hello from CMD

docker run my-image "Overridden"
# Output: Overridden$$, $$bash$$,
           $$The lesson explains that with ENTRYPOINT set, it always runs -- CMD supplies its default arguments, which docker run can override without touching the entrypoint itself. So `"Overridden"` only replaces the default CMD argument, producing `echo "Overridden"`, which prints "Overridden" -- not a completely different command.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-images-and-dockerfiles'
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
    ($$Hello from CMD -- ENTRYPOINT arguments can never be overridden by docker run under any circumstances$$, FALSE, 0),
    ($$An error, since ENTRYPOINT and CMD cannot both be present in the same Dockerfile$$, FALSE, 1),
    ($$Overridden is printed twice, once for ENTRYPOINT and once for the overriding argument$$, FALSE, 2),
    ($$Overridden -- the entrypoint (`echo`) still always runs, only its default CMD argument is replaced$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-images-and-dockerfiles'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-images-and-dockerfiles')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about Dockerfile instructions and `docker build`, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Dockerfile instructions and `docker build`, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (RUN executes a command at build time and its filesystem changes become a permanent part of the resulting image; EXPOSE is documentation, not configuration -- it does not publish a port on its own, `-p` on docker run does); `docker build -t` tags the image with a repository name and tag, it doesn't need to run detached in the background (that's a `docker run` concept, not a build one), and the build context is the directory passed to `docker build`, not automatically the directory the Dockerfile itself happens to be saved in if they differ.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-images-and-dockerfiles'
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
    ($$`RUN` executes a command while the image is being built, and whatever it changes on disk becomes a permanent part of the resulting image$$, TRUE, 0),
    ($$`EXPOSE` is documentation, not configuration -- it does not actually publish a port to the host machine on its own$$, TRUE, 1),
    ($$`docker build -t <name>:<tag> .` must always be run with a `-d` flag to run the build process in the background$$, FALSE, 2),
    ($$The build context `docker build` uses is automatically the directory containing the Dockerfile, even if a different directory is explicitly passed as the build command's argument$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-images-and-dockerfiles'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
