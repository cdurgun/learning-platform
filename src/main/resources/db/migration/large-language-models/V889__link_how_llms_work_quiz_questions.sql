-- Promotion-style migration linking EN how-llms-work quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'how-llms-work')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is a Large Language Model (LLM), mechanically?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is a Large Language Model (LLM), mechanically?$$,
           NULL, NULL,
           $$This matches the lesson's definition directly: a transformer-based neural network trained at massive scale to predict the next token; the other options describe unrelated, non-learning-based systems (hand-written rules, lookup databases, search engines).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'how-llms-work'
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
    ($$A transformer-based neural network trained at massive scale to predict the next token given preceding text$$, TRUE, 0),
    ($$A rule-based system with thousands of hand-written if/else statements for language$$, FALSE, 1),
    ($$A database that looks up pre-written answers to common questions$$, FALSE, 2),
    ($$A search engine that retrieves and ranks existing web pages$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'how-llms-work'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'how-llms-work')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Before LLMs, why did NLP systems typically require a separate model for each task (translation, sentiment analysis, summarization)?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Before LLMs, why did NLP systems typically require a separate model for each task (translation, sentiment analysis, summarization)?$$,
           NULL, NULL,
           $$This matches the lesson: under the narrow-AI approach, each task needed its own labeled dataset and training run; LLMs changed this via one pretrained general model that can handle many tasks -- the other options are false or fabricated.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'how-llms-work'
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
    ($$Because a single general model has always been technically impossible to build$$, FALSE, 0),
    ($$Because each task needed its own labeled dataset and training run under the narrow-AI approach$$, TRUE, 1),
    ($$Because computers were physically incapable of running more than one model type$$, FALSE, 2),
    ($$Because language itself changes completely between tasks$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'how-llms-work'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'how-llms-work')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$During pretraining, a model is shown a huge amount of text and, for each piece, asked to predict the next token; when wrong, its weights are adjusted. What does this process teach the model, according to the lesson?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$During pretraining, a model is shown a huge amount of text and, for each piece, asked to predict the next token; when wrong, its weights are adjusted. What does this process teach the model, according to the lesson?$$,
           NULL, NULL,
           $$The lesson explicitly lists grammar, facts (up to the knowledge cutoff), reasoning patterns, and even programming languages as side effects of getting better at next-token prediction; conversational ability specifically comes from a later phase (instruction tuning), not pretraining, so it isn't "only spelling/punctuation" and isn't "nothing useful."$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'how-llms-work'
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
    ($$Only how to have a back-and-forth conversation, since that's the explicit training goal$$, FALSE, 0),
    ($$Nothing useful, since pretraining is described as an unrelated preliminary step$$, FALSE, 1),
    ($$Grammar, facts about the world (up to its knowledge cutoff), common reasoning patterns, and even programming languages -- all as a side effect of getting better at next-token prediction$$, TRUE, 2),
    ($$Only spelling and punctuation rules, nothing else$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'how-llms-work'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'how-llms-work')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given the instruction "Summarize this email," a raw base model (no further training after pretraining) might continue with a list of other unrelated instructions instead of actually summarizing. Why does this happen, and what typically fixes it?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given the instruction "Summarize this email," a raw base model (no further training after pretraining) might continue with a list of other unrelated instructions instead of actually summarizing. Why does this happen, and what typically fixes it?$$,
           NULL, NULL,
           $$This matches the lesson's base-model vs. instruction-tuned distinction directly: a base model only continues text plausibly, and instruction tuning (an additional training phase) teaches reliable instruction-following; it isn't a "broken model" needing retraining from scratch, instruction-following isn't universal by default, and context window size is unrelated.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'how-llms-work'
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
    ($$The model is broken and needs to be retrained from scratch on different data$$, FALSE, 0),
    ($$This never actually happens to base models -- all models follow instructions equally well by default$$, FALSE, 1),
    ($$The fix is to give the model a bigger context window$$, FALSE, 2),
    ($$A base model only continues text plausibly; instruction tuning (an additional training phase) is what teaches a model to reliably follow instructions instead$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'how-llms-work'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'how-llms-work')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A user teaches an LLM a made-up word within a conversation, and the model correctly uses that word later in the same conversation -- without any retraining happening. What explains this behavior?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A user teaches an LLM a made-up word within a conversation, and the model correctly uses that word later in the same conversation -- without any retraining happening. What explains this behavior?$$,
           NULL, NULL,
           $$The lesson explicitly defines in-context learning as adapting behavior within a conversation with zero weight changes, via re-feeding the full conversation as input on every response; the other options describe mechanisms the lesson explicitly rules out (permanent weight updates, silent retraining, a persistent memory database).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'how-llms-work'
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
    ($$In-context learning: the model's weights don't change at all; instead, the entire conversation so far is re-fed as input on every response, and the frozen pretrained model recognizes the pattern$$, TRUE, 0),
    ($$The model's weights are permanently updated in real time during the conversation$$, FALSE, 1),
    ($$The company running the model silently retrains it after every message$$, FALSE, 2),
    ($$The model has a separate, persistent memory database it writes to during conversations$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'how-llms-work'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'how-llms-work')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, what is "context," and why does it matter?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what is "context," and why does it matter?$$,
           NULL, NULL,
           $$The lesson defines context broadly (instructions, background info, conversation history, and generated-so-far text) and states it is the ONLY channel shaping inference-time behavior, since no learning happens during inference; the other options narrow or misplace this definition.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'how-llms-work'
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
    ($$Context only matters for image-generation models, not text-based LLMs$$, FALSE, 0),
    ($$Context is all the text the model actually sees before producing its next token, and it's the only channel through which an LLM's behavior can be shaped at inference time$$, TRUE, 1),
    ($$Context is just the system prompt alone, nothing else the model sees$$, FALSE, 2),
    ($$Context is a separate database the model queries during pretraining only$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'how-llms-work'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'how-llms-work')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about how LLMs work, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about how LLMs work, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (knowledge cutoff as a direct consequence of pretraining data collection timing; scaling laws describing predictable performance improvement with size/data/compute); instruction tuning is a training-time phase completed before deployment, not something happening live during conversations (that's in-context learning instead), and base vs. instruction-tuned models are explicitly described as behaving differently.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'how-llms-work'
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
    ($$Instruction tuning happens continuously, in real time, during every user conversation$$, FALSE, 0),
    ($$A base model and an instruction-tuned model are always identical in behavior, since instruction tuning doesn't change anything observable$$, FALSE, 1),
    ($$A model's knowledge cutoff is a direct consequence of when its pretraining data was collected, not an arbitrary restriction$$, TRUE, 2),
    ($$Scaling laws describe the observed pattern that performance tends to improve as model size, data, and compute all increase together$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'how-llms-work'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
