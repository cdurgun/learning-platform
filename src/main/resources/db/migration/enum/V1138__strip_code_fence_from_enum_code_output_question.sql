-- The English enum CODE_OUTPUT question promoted by
-- question-promotion/V431 (Day.valueOf("FRIDAY")) stored its code TWICE: once
-- as a raw fenced Markdown block inside question, and once (correctly) in
-- code_snippet. The public quiz fragment prints question as plain text, so the
-- fence markers and the code appeared literally above the highlighted
-- code_snippet block. Its Turkish counterpart (same V431) already stores only
-- the sentence -- this aligns the English row with it.
--
-- Only question (and updated_at) change: code_snippet, code_language,
-- explanation and every question_option row stay exactly as they are.
--
-- Keyed portably (topic slug + language + type + snippet content), never on an
-- environment-specific id. Idempotent: once the fence is gone the
-- position(...) > 0 condition no longer matches, so a rerun updates nothing.
UPDATE question
SET question = 'What will be the output of the following code?',
    updated_at = now()
WHERE topic_id = (SELECT id FROM topic WHERE slug = 'enum')
  AND language = 'en'
  AND type = 'CODE_OUTPUT'
  AND code_snippet LIKE '%Day.valueOf("FRIDAY")%'
  AND question LIKE 'What will be the output of the following code?%'
  AND position('```' IN question) > 0;
