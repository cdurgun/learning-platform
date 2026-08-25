-- Quiz Area: reusable, category-scoped random quiz definitions (e.g. "Basic Java",
-- "All Spring"). This is deliberately SEPARATE from the existing quiz/quiz_question_link
-- tables, which represent a fixed, curated, topic-embedded quiz and are not touched here.
--
-- A quiz_definition belongs to exactly one course (for the "Java Quiz"/"Spring Quiz"
-- nav grouping) and is scoped to zero or more categories via quiz_definition_category:
-- an empty scope means "the whole course" (e.g. "All Java"), so newly added categories
-- are automatically included without a migration change.
--
-- slug is GLOBALLY unique (not scoped per course) because the play/submit URLs
-- (/{lang}/quiz/{definitionSlug}) address a definition by slug alone.
CREATE TABLE quiz_definition (
    id             BIGSERIAL PRIMARY KEY,
    course_id      BIGINT NOT NULL REFERENCES course (id),
    slug           VARCHAR(255) NOT NULL UNIQUE,
    question_count INTEGER NOT NULL,
    active         BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order     INTEGER NOT NULL
);

CREATE TABLE quiz_definition_category (
    quiz_definition_id BIGINT NOT NULL REFERENCES quiz_definition (id) ON DELETE CASCADE,
    category_id        BIGINT NOT NULL REFERENCES category (id) ON DELETE CASCADE,
    PRIMARY KEY (quiz_definition_id, category_id)
);

CREATE INDEX idx_quiz_definition_course ON quiz_definition (course_id);
