-- Promotion batch
-- Development Question IDs: 367, 368, 370, 372, 373, 375, 376
-- Generated: 2026-08-31 (this migration file's authoring date)
-- All 7 questions were among the 8 left PENDING_REVIEW by the AI Judge's
-- REJECT verdict in the same n8n generation run as question-promotion/
-- V520 (arrays-batch-1). They were reviewed by a human ADMIN reviewer
-- against content/en/arrays.md and content/tr/arrays.md (checked for
-- correctness, lesson support, clear wording, explanation accuracy, and
-- duplication -- several of the AI Judge's original REJECT reasons were
-- found on review to misdescribe which option was marked correct, i.e.
-- false-negative rejections) and PUBLISHED in development via
-- QuestionReviewService#publish (POST /{lang}/admin/questions/{id}/publish,
-- the same real ADMIN Publish button/business logic, never a raw SQL/bypass
-- publish). 1 sibling PENDING_REVIEW question from the same run (dev id 380
-- -- ambiguous option scope relative to its own question stem) was REJECTED
-- in the same pass via QuestionReviewService#reject and is intentionally
-- NOT included here.
--
-- These development IDs are DOCUMENTATION/PROVENANCE ONLY -- no development
-- id is used as a foreign key value anywhere below. topic_id is resolved by
-- Topic.slug (globally unique, stable across environments); question_option
-- rows reference the newly generated id of the INSERT immediately above them
-- via a WITH ... RETURNING id CTE, so this migration is correct regardless of
-- what this environment's own auto-generated ids turn out to be -- same
-- pattern as question-promotion/V431, V489, and V520.
--
-- Duplicate-promotion safety (bkz. docs/known-constraints.md "Faz D"): this
-- project intentionally has no promoted_at column or unique constraint yet --
-- before writing a NEW promotion migration, grep existing
-- db/migration/question-promotion/*.sql header comments for these same
-- Development Question IDs to confirm they were not already promoted (done
-- for this migration -- no overlap with V431's ids 44/45/46/47/48/53/54/55/
-- 57/58, V489's string-topic ids, or V520's arrays ids 369/371/374/377/
-- 378/379).

-- Dev question id 367 (topic: arrays, language: en)
WITH new_question_367 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           $$What is the primary characteristic that distinguishes an array from a collection like ArrayList?$$, NULL, NULL,
           $$An array has a fixed size that cannot change after creation, while collections like ArrayList can dynamically resize. This fundamental difference is key to understanding their usage.$$, $$gentest-review-admin@example.com$$, '2026-08-31 18:44:40.321481',
           now(), now()
    FROM topic WHERE slug = 'arrays'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Arrays can hold elements of different types.$$, FALSE, 0 FROM new_question_367
        UNION ALL SELECT id, $$Arrays have a fixed size that cannot change after creation.$$, TRUE, 1 FROM new_question_367
        UNION ALL SELECT id, $$Arrays can be resized dynamically during runtime.$$, FALSE, 2 FROM new_question_367
        UNION ALL SELECT id, $$Arrays are always more efficient than collections.$$, FALSE, 3 FROM new_question_367;

-- Dev question id 368 (topic: arrays, language: en)
WITH new_question_368 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           $$Which of the following statements about the Arrays utility class are true?$$, NULL, NULL,
           $$The Arrays utility class provides methods like sort(), equals(), and fill(). It does not compare references but contents with equals(). The statement about copyOfRange() is also correct as it creates a new array.$$, $$gentest-review-admin@example.com$$, '2026-08-31 18:44:40.340846',
           now(), now()
    FROM topic WHERE slug = 'arrays'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Arrays.equals() compares the contents of two arrays.$$, TRUE, 0 FROM new_question_368
        UNION ALL SELECT id, $$Arrays.sort() creates a new sorted array.$$, FALSE, 1 FROM new_question_368
        UNION ALL SELECT id, $$Arrays.fill() sets every element of an array to a specified value.$$, TRUE, 2 FROM new_question_368
        UNION ALL SELECT id, $$Arrays.copyOfRange() can create a new array from a specified range.$$, TRUE, 3 FROM new_question_368;

-- Dev question id 370 (topic: arrays, language: en, type: CODE_OUTPUT)
WITH new_question_370 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           $$What will be the output of the following code?$$,
           $$int[] numbers = new int[5];
System.out.println(Arrays.toString(numbers));$$, $$java$$,
           $$The output will show the contents of the numbers array, which has been initialized with default values of 0 for each element. Arrays.toString() correctly formats the output.$$, $$gentest-review-admin@example.com$$, '2026-08-31 18:44:40.36254',
           now(), now()
    FROM topic WHERE slug = 'arrays'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[0, 0, 0, 0, 0]$$, TRUE, 0 FROM new_question_370
        UNION ALL SELECT id, $$[I@7ea987ac$$, FALSE, 1 FROM new_question_370
        UNION ALL SELECT id, $$[0]$$, FALSE, 2 FROM new_question_370
        UNION ALL SELECT id, $$Array is empty$$, FALSE, 3 FROM new_question_370;

-- Dev question id 372 (topic: arrays, language: en)
WITH new_question_372 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           $$Which of the following are best practices when working with arrays?$$, NULL, NULL,
           $$Using Arrays.toString() or Arrays.deepToString() is a best practice for printing arrays, and using Arrays.equals() is essential for content comparison. The other options do not reflect best practices.$$, $$gentest-review-admin@example.com$$, '2026-08-31 18:44:40.380373',
           now(), now()
    FROM topic WHERE slug = 'arrays'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Always use Arrays.toString() to print an array's contents.$$, TRUE, 0 FROM new_question_372
        UNION ALL SELECT id, $$Use == to compare two arrays for equality.$$, FALSE, 1 FROM new_question_372
        UNION ALL SELECT id, $$Use Arrays.equals() to compare two arrays' contents.$$, TRUE, 2 FROM new_question_372
        UNION ALL SELECT id, $$Print an array directly with System.out.println().$$, FALSE, 3 FROM new_question_372;

-- Dev question id 373 (topic: arrays, language: en)
WITH new_question_373 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           $$What does it mean that Java arrays are covariant?$$, NULL, NULL,
           $$Covariance allows an array of a subtype (like Integer[]) to be assigned to a supertype array variable (like Number[]), but this can lead to runtime errors if not handled carefully.$$, $$gentest-review-admin@example.com$$, '2026-08-31 18:44:40.397579',
           now(), now()
    FROM topic WHERE slug = 'arrays'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Arrays can hold mixed data types.$$, FALSE, 0 FROM new_question_373
        UNION ALL SELECT id, $$An Integer[] can be assigned to a Number[] variable.$$, TRUE, 1 FROM new_question_373
        UNION ALL SELECT id, $$Arrays can be resized dynamically.$$, FALSE, 2 FROM new_question_373
        UNION ALL SELECT id, $$Covariant arrays are always safe to use.$$, FALSE, 3 FROM new_question_373;

-- Dev question id 375 (topic: arrays, language: tr)
WITH new_question_375 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           $$Aşağıdakilerden hangileri dizilerin temel özelliklerindendir?$$, NULL, NULL,
           $$Diziler, aynı tipten sabit sayıda elemanı tutan bir veri yapısıdır ve bellekte ardışık bir blokta yer alır. Bu özellikler, dizilerin O(1) index erişimi sağlamasına olanak tanır.$$, $$gentest-review-admin@example.com$$, '2026-08-31 18:44:40.412737',
           now(), now()
    FROM topic WHERE slug = 'arrays'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bellekte ardışık bir blokta tutulur$$, TRUE, 0 FROM new_question_375
        UNION ALL SELECT id, $$Dinamik boyutludur$$, FALSE, 1 FROM new_question_375
        UNION ALL SELECT id, $$O(1) index erişimi sağlar$$, TRUE, 2 FROM new_question_375
        UNION ALL SELECT id, $$Farklı tipte elemanlar içerebilir$$, FALSE, 3 FROM new_question_375;

-- Dev question id 376 (topic: arrays, language: tr)
WITH new_question_376 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           $$Aşağıdakilerden hangileri çok boyutlu dizilerin özelliklerindendir?$$, NULL, NULL,
           $$Çok boyutlu diziler, her satırın bağımsız bir dizi nesnesi olabileceği için farklı uzunluklara sahip olabilir. Bu özellik, jagged array olarak adlandırılır.$$, $$gentest-review-admin@example.com$$, '2026-08-31 18:44:40.428334',
           now(), now()
    FROM topic WHERE slug = 'arrays'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her satır aynı uzunlukta olmalıdır$$, FALSE, 0 FROM new_question_376
        UNION ALL SELECT id, $$Düzenli bir grid yapısı oluşturabilir$$, TRUE, 1 FROM new_question_376
        UNION ALL SELECT id, $$Her satır farklı uzunlukta olabilir$$, TRUE, 2 FROM new_question_376
        UNION ALL SELECT id, $$Diziler dizisi olarak tanımlanabilir$$, TRUE, 3 FROM new_question_376;
