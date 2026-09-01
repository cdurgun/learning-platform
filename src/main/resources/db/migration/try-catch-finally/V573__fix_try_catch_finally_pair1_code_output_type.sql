-- Bug fix: try-catch-finally Pair 1 (EN + TR, promoted in question-promotion/V553,
-- linked in V555/V556) was authored with type = 'SINGLE_CHOICE' even though the
-- question is entirely about the shown code's compile behavior. fragments/quiz.html
-- ONLY renders code_snippet for CODE_OUTPUT questions (SINGLE_CHOICE/MULTIPLE_CHOICE
-- intentionally never show it, per that template's own comment) -- so on the live
-- /tr/topics/try-catch-finally quiz page, question 1 rendered with NO code block at
-- all, making "Which of the following will fail to compile?" unanswerable from what
-- was shown. Reported by the user from a live screenshot.
--
-- Fix: retype these two rows to CODE_OUTPUT, matching how every other
-- compile-behavior question in this batch (e.g. throw-and-throws' "unreachable code"
-- question) was already correctly typed. No other column changes -- question text,
-- code_snippet, code_language, explanation, and options are all correct as-is; the
-- CODE_OUTPUT UI renders as a single-answer radio list identical to SINGLE_CHOICE's,
-- so no option/answer-shape change is needed.
--
-- Naturally idempotent: the WHERE clause only matches rows still at
-- type = 'SINGLE_CHOICE', so re-running this after it's already applied is a no-op.

UPDATE question
SET type = 'CODE_OUTPUT'
WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
  AND type = 'SINGLE_CHOICE'
  AND code_snippet IS NOT NULL
  AND language = 'en'
  AND question = $$Which of the following will fail to compile?$$;

UPDATE question
SET type = 'CODE_OUTPUT'
WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
  AND type = 'SINGLE_CHOICE'
  AND code_snippet IS NOT NULL
  AND language = 'tr'
  AND question = $$Aşağıdaki kod parçası için ne söylenebilir?$$;
