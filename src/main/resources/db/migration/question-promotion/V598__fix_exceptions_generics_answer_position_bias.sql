-- Bug fix: the manually-authored Exceptions (V553-V573) and Generics (V574-V597)
-- question batches were written with the correct answer consistently listed FIRST
-- in the options array during authoring, and that authoring order was carried
-- straight through into `sort_order` (0/1/2/3) unchanged. Verified in the dev DB:
-- ALL 70 SINGLE_CHOICE/CODE_OUTPUT Generics questions had their correct answer at
-- sort_order = 0 (option A), and all 14 MULTIPLE_CHOICE Generics questions had
-- their two correct answers at sort_order = 0/1 (A+B) -- never C or D. Exceptions
-- was similarly skewed toward 0/1 with no use of position 2/3 at all for most
-- questions. Reported by the user: "Soruların doğru cevaplarını hep A şıkkı olarak
-- koymuşsun, random olarak seçilmeli doğru cevap."
--
-- Fix: for every question under the `exceptions` and `generics` categories,
-- rotate that question's 4 options' sort_order by a per-question offset (0-3),
-- assigned deterministically by question id modulo 4 (cycling 0,1,2,3,0,1,... in
-- id order). This changes only the ON-SCREEN ORDER options render in -- which
-- option_text is marked is_correct, and every other column, is untouched. For a
-- single-correct question this spreads the correct answer's rendered position
-- roughly evenly across A/B/C/D; for a MULTIPLE_CHOICE question (2 correct,
-- originally at 0/1) it spreads the correct PAIR's positions across {0,1}/{1,2}/
-- {2,3}/{3,0} depending on the question's offset. No unique constraint exists on
-- (question_id, sort_order) (see question_option's schema), so a single UPDATE is
-- safe with no intermediate-conflict risk.
--
-- Scope is intentionally limited to `exceptions`/`generics` -- the two categories
-- authored in this session with this defect. Older CLAUDE-authored batches
-- (records, reflection, date-time, etc.) already show more natural position
-- variety and are NOT touched here, per this project's "don't touch unrelated
-- content" convention.

WITH ranked AS (
    SELECT q.id AS question_id,
           (ROW_NUMBER() OVER (ORDER BY q.id) - 1) % 4 AS offset
    FROM question q
             JOIN topic t ON t.id = q.topic_id
             JOIN category c ON c.id = t.category_id
    WHERE c.slug IN ('exceptions', 'generics')
)
UPDATE question_option o
SET sort_order = (o.sort_order + r.offset) % 4
FROM ranked r
WHERE o.question_id = r.question_id;
