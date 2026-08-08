CREATE TABLE course
(
    id   BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE category
(
    id        BIGSERIAL PRIMARY KEY,
    course_id BIGINT       NOT NULL REFERENCES course (id) ON DELETE CASCADE,
    name      VARCHAR(255) NOT NULL,
    slug      VARCHAR(255) NOT NULL,
    CONSTRAINT uq_category_course_slug UNIQUE (course_id, slug)
);

CREATE TABLE topic
(
    id                BIGSERIAL PRIMARY KEY,
    category_id       BIGINT       NOT NULL REFERENCES category (id) ON DELETE CASCADE,
    slug              VARCHAR(255) NOT NULL UNIQUE,
    difficulty        VARCHAR(20)  NOT NULL,
    estimated_minutes INTEGER,
    sort_order        INTEGER      NOT NULL DEFAULT 0
);

-- NOT: "published" burada YOK, kasıtlı olarak topic_translation seviyesinde —
-- bir dilin yayında, diğerinin taslak olabilmesi için.
CREATE TABLE topic_translation
(
    id              BIGSERIAL PRIMARY KEY,
    topic_id        BIGINT       NOT NULL REFERENCES topic (id) ON DELETE CASCADE,
    language        VARCHAR(5)   NOT NULL,
    title           VARCHAR(255) NOT NULL,
    summary         TEXT,
    seo_title       VARCHAR(255),
    seo_description VARCHAR(500),
    published       BOOLEAN      NOT NULL DEFAULT false,
    CONSTRAINT uq_topic_translation_topic_lang UNIQUE (topic_id, language)
);

-- Dosya yolu YOK: examples/{topic.slug}/{example_name}.java convention'ıyla bulunur.
CREATE TABLE code_example
(
    id            BIGSERIAL PRIMARY KEY,
    topic_id      BIGINT       NOT NULL REFERENCES topic (id) ON DELETE CASCADE,
    title         VARCHAR(255) NOT NULL,
    example_name  VARCHAR(255) NOT NULL,
    sort_order    INTEGER      NOT NULL DEFAULT 0,
    CONSTRAINT uq_code_example_topic_name UNIQUE (topic_id, example_name)
);

CREATE INDEX idx_category_course ON category (course_id);
CREATE INDEX idx_topic_category ON topic (category_id);
CREATE INDEX idx_topic_translation_topic ON topic_translation (topic_id);
CREATE INDEX idx_code_example_topic ON code_example (topic_id);
