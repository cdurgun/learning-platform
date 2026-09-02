-- Promotion-style migration linking EN spring-mvc-views-thymeleaf quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-views-thymeleaf')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What makes Thymeleaf's "natural templating" philosophy distinct from engines like JSP or Mustache?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What makes Thymeleaf's "natural templating" philosophy distinct from engines like JSP or Mustache?$$,
           NULL, NULL,
           $$A Thymeleaf template is valid HTML that can be opened directly in a browser, since its directives are ordinary HTML attributes.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-views-thymeleaf'
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
    ($$It only works with Spring Boot, not plain Spring MVC$$, FALSE, 0),
    ($$A Thymeleaf template is valid HTML that can be opened directly in a browser, since its directives are ordinary HTML attributes$$, TRUE, 1),
    ($$It compiles templates into Java bytecode ahead of time$$, FALSE, 2),
    ($$It doesn't support conditionals or loops$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-views-thymeleaf'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-views-thymeleaf')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given that Topic is a Java record (its accessor is a real method title(), not a getTitle() bean-style getter), what is the risk with this exact Thymeleaf expression?$$
      AND code_snippet = $$record Topic(String slug, String title) {}
// model.addAttribute("topic", new Topic("records", "Records"));

<!-- template -->
<h1 th:text="${topic.title}">placeholder</h1>$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given that Topic is a Java record (its accessor is a real method title(), not a getTitle() bean-style getter), what is the risk with this exact Thymeleaf expression?$$,
           $$record Topic(String slug, String title) {}
// model.addAttribute("topic", new Topic("records", "Records"));

<!-- template -->
<h1 th:text="${topic.title}">placeholder</h1>$$, $$html$$,
           $$${topic.title} (without parentheses) doesn't correctly resolve a record's real accessor method the way ${topic.title()} does -- it can silently fail or return null/an error.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-views-thymeleaf'
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
    ($$It throws a compile-time error, since Thymeleaf expressions are checked at build time$$, FALSE, 0),
    ($$It works identically to ${topic.getTitle()}, since Spring auto-generates a getter for every record$$, FALSE, 1),
    ($$It works perfectly -- Thymeleaf always adds parentheses automatically for records$$, FALSE, 2),
    ($$It can silently fail or return null/an error, since ${topic.title} (without parentheses) doesn't correctly resolve a record's real accessor method the way ${topic.title()} does$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-views-thymeleaf'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-views-thymeleaf')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Inside @{/topics/{slug}(slug=${slug}, lang=${lang})}, if {slug} is already a placeholder in the path, what happens to the slug=${slug} and lang=${lang} parts?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Inside @{/topics/{slug}(slug=${slug}, lang=${lang})}, if {slug} is already a placeholder in the path, what happens to the slug=${slug} and lang=${lang} parts?$$,
           NULL, NULL,
           $$slug=${slug} fills the existing {slug} path placeholder; lang=${lang} has no matching placeholder, so it becomes a query string parameter instead.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-views-thymeleaf'
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
    ($$Both automatically become query string parameters$$, FALSE, 0),
    ($$slug=${slug} fills the existing {slug} path placeholder; lang=${lang} has no matching placeholder, so it becomes a query string parameter instead$$, TRUE, 1),
    ($$Both are ignored since {slug} is already filled$$, FALSE, 2),
    ($$It causes a build-time error since a parameter can't share a name with a path placeholder$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-views-thymeleaf'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-views-thymeleaf')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the key safety difference between th:text and th:utext?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is the key safety difference between th:text and th:utext?$$,
           NULL, NULL,
           $$th:text always escapes HTML special characters (safe against XSS); th:utext writes output verbatim, unescaped.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-views-thymeleaf'
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
    ($$th:text only works with numeric values$$, FALSE, 0),
    ($$th:utext is deprecated and should never be used$$, FALSE, 1),
    ($$th:utext is faster to render, th:text is slower$$, FALSE, 2),
    ($$th:text always escapes HTML special characters (safe against XSS); th:utext writes output verbatim, unescaped$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-views-thymeleaf'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-views-thymeleaf')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the behavioral difference between th:if and CSS's display:none?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What is the behavioral difference between th:if and CSS's display:none?$$,
           NULL, NULL,
           $$th:if removes the tag from the HTML output entirely when the condition is false; display:none still sends the element to the browser, just hides it visually.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-views-thymeleaf'
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
    ($$There is no difference, they behave identically$$, FALSE, 0),
    ($$th:if removes the tag from the HTML output entirely when the condition is false; display:none still sends the element to the browser, just hides it visually$$, TRUE, 1),
    ($$display:none is evaluated on the server, th:if on the client$$, FALSE, 2),
    ($$th:if can only be used on <div> tags$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-views-thymeleaf'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-views-thymeleaf')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the key difference between th:insert and th:replace when pulling in a fragment?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What is the key difference between th:insert and th:replace when pulling in a fragment?$$,
           NULL, NULL,
           $$th:insert places the fragment inside the host tag (the host tag stays); th:replace swaps the host tag out entirely for the fragment's own root tag.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-views-thymeleaf'
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
    ($$th:insert places the fragment inside the host tag (the host tag stays); th:replace swaps the host tag out entirely for the fragment's own root tag$$, TRUE, 0),
    ($$th:replace is deprecated in favor of th:insert$$, FALSE, 1),
    ($$th:insert only works with external files, th:replace only with the same file$$, FALSE, 2),
    ($$They are functionally identical, differing only in naming convention$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-views-thymeleaf'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-views-thymeleaf')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$This expression is inside a selection filter .?[...], where activeSlug is a variable from the outer scope (not a field on Topic). What is the likely result when this actually runs?$$
      AND code_snippet = $$<li th:each="category : ${categories}"
    th:with="isActive=${category.topics().?[#this.slug() == activeSlug].size() > 0}">
    ...
</li>$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$This expression is inside a selection filter .?[...], where activeSlug is a variable from the outer scope (not a field on Topic). What is the likely result when this actually runs?$$,
           $$<li th:each="category : ${categories}"
    th:with="isActive=${category.topics().?[#this.slug() == activeSlug].size() > 0}">
    ...
</li>$$, $$html$$,
           $$Inside .?[...], #this rebinds the entire scope to the current element, so activeSlug is looked up as a field on Topic instead of the outer variable, throwing a SpelEvaluationException.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-views-thymeleaf'
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
    ($$It works correctly, filtering topics whose slug matches activeSlug$$, FALSE, 0),
    ($$It throws a SpelEvaluationException -- inside .?[...], #this rebinds the entire scope to the current element, so activeSlug is looked up as a field on Topic instead of the outer variable$$, TRUE, 1),
    ($$It always evaluates to false, silently, with no exception$$, FALSE, 2),
    ($$It causes an infinite loop$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-views-thymeleaf'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
