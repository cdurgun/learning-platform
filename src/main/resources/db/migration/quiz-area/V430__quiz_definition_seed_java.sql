-- Quiz Area: initial content for the "Java Quiz" nav group (Faz -- Quiz Area Phase 5).
-- Scope decisions (confirmed with the user before writing this migration):
--   basic-java    = Java Basics + Control Flow (introductory material)
--   advanced-java = Exceptions, Generics, Collections, OOP, Concurrency,
--                   Functional Interfaces & Streams
--   all-java      = the ENTIRE course -- deliberately given NO rows in
--                   quiz_definition_category (empty scope = whole course
--                   convention, see QuizDefinition javadoc), so any category
--                   added to the java course later is automatically included
--                   here with no further migration needed.
--
-- Category subqueries are scoped by BOTH course.slug AND category.slug (not
-- category.slug alone) because category.slug is only unique per course
-- (uq_category_course_slug, core/V1), not globally -- even though these
-- particular slugs happen to be globally unique today, this stays correct if
-- another course ever reuses one of them.
--
-- question_count: 10 for the two category-scoped quizzes (matches the existing
-- Practice DEFAULT_COUNT convention, see PracticeService), 20 for all-java since
-- its eligible pool spans the whole course and is proportionally larger.
INSERT INTO quiz_definition (course_id, slug, question_count, active, sort_order)
VALUES
    ((SELECT id FROM course WHERE slug = 'java'), 'basic-java', 10, true, 1),
    ((SELECT id FROM course WHERE slug = 'java'), 'advanced-java', 10, true, 2),
    ((SELECT id FROM course WHERE slug = 'java'), 'all-java', 20, true, 3);

INSERT INTO quiz_definition_category (quiz_definition_id, category_id)
VALUES
    ((SELECT id FROM quiz_definition WHERE slug = 'basic-java'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'java' AND c.slug = 'java-basics')),
    ((SELECT id FROM quiz_definition WHERE slug = 'basic-java'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'java' AND c.slug = 'control-flow')),

    ((SELECT id FROM quiz_definition WHERE slug = 'advanced-java'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'java' AND c.slug = 'exceptions')),
    ((SELECT id FROM quiz_definition WHERE slug = 'advanced-java'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'java' AND c.slug = 'generics')),
    ((SELECT id FROM quiz_definition WHERE slug = 'advanced-java'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'java' AND c.slug = 'collections')),
    ((SELECT id FROM quiz_definition WHERE slug = 'advanced-java'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'java' AND c.slug = 'oop')),
    ((SELECT id FROM quiz_definition WHERE slug = 'advanced-java'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'java' AND c.slug = 'concurrency')),
    ((SELECT id FROM quiz_definition WHERE slug = 'advanced-java'),
     (SELECT c.id FROM category c JOIN course co ON co.id = c.course_id WHERE co.slug = 'java' AND c.slug = 'functional-interfaces-streams'));
    -- all-java intentionally gets NO rows here (whole-course convention).
