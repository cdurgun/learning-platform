-- Promotion batch
-- Development Question IDs: 44, 45, 46, 47, 48, 53, 54, 55, 57, 58
-- Generated: 2026-08-26 15:07:10 UTC
-- All questions were PUBLISHED and ADMIN-reviewed in development.
--
-- These development IDs are DOCUMENTATION/PROVENANCE ONLY -- no development id
-- is used as a foreign key value anywhere below. topic_id is resolved by
-- Topic.slug (globally unique, stable across environments); question_option
-- rows reference the newly generated id of the INSERT immediately above them
-- via a WITH ... RETURNING id CTE, so this migration is correct regardless of
-- what this environment's own auto-generated ids turn out to be.
--
-- Duplicate-promotion safety (bkz. docs/known-constraints.md "Faz D"): this
-- project intentionally has no promoted_at column or unique constraint yet --
-- before writing a NEW promotion migration, grep existing
-- db/migration/question-promotion/*.sql header comments for these same
-- Development Question IDs to confirm they were not already promoted.

-- Dev question id 44 (topic: enum, language: en)
WITH new_question_44 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           'What will be the output of the following code?

```java
enum Day { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }

public class Test {
    public static void main(String[] args) {
        System.out.println(Day.valueOf("FRIDAY"));
    }
}
```', 'enum Day { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }

public class Test {
    public static void main(String[] args) {
        System.out.println(Day.valueOf("FRIDAY"));
    }
}', 'java',
           'The valueOf(String) method returns the constant that matches the given name, which in this case is FRIDAY.', 'gentest-publish-admin@example.com', '2026-08-26 16:14:30.819306',
           now(), now()
    FROM topic WHERE slug = 'enum'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, 'FRIDAY', TRUE, 0 FROM new_question_44
    UNION ALL SELECT id, 'MONDAY', FALSE, 1 FROM new_question_44
    UNION ALL SELECT id, 'SUNDAY', FALSE, 2 FROM new_question_44
    UNION ALL SELECT id, 'IllegalArgumentException', FALSE, 3 FROM new_question_44;

-- Dev question id 45 (topic: enum, language: en)
WITH new_question_45 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           'Which of the following statements about enums are true?', NULL, NULL,
           'Enums can implement interfaces and can have their own methods, making these statements true.', 'gentest-publish-admin@example.com', '2026-08-26 16:14:30.837046',
           now(), now()
    FROM topic WHERE slug = 'enum'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, 'Enums can implement multiple interfaces.', TRUE, 0 FROM new_question_45
    UNION ALL SELECT id, 'Enums can have their own methods.', TRUE, 1 FROM new_question_45
    UNION ALL SELECT id, 'Enums can extend other classes.', FALSE, 2 FROM new_question_45
    UNION ALL SELECT id, 'Enums cannot be serialized.', FALSE, 3 FROM new_question_45;

-- Dev question id 46 (topic: enum, language: en)
WITH new_question_46 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           'What will be the output of the following code?', 'enum Day { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }
System.out.println(Day.MONDAY.ordinal());', 'java',
           'The `ordinal()` method returns the position of the constant in the enum definition, starting from 0. Since `MONDAY` is the first constant defined, its ordinal value is 0.', 'gentest-publish-admin@example.com', '2026-08-26 16:14:30.854995',
           now(), now()
    FROM topic WHERE slug = 'enum'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, '0', TRUE, 0 FROM new_question_46
    UNION ALL SELECT id, '1', FALSE, 1 FROM new_question_46
    UNION ALL SELECT id, '6', FALSE, 2 FROM new_question_46
    UNION ALL SELECT id, 'MONDAY', FALSE, 3 FROM new_question_46;

-- Dev question id 47 (topic: enum, language: en)
WITH new_question_47 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           'Which of the following statements about enum constructors are true? (Select all that apply)', NULL, NULL,
           'Enum constructors can only be private or package-private, as they are called only within the enum itself. Additionally, each enum constant can pass parameters to its constructor, allowing for unique data for each constant.', 'gentest-publish-admin@example.com', '2026-08-26 16:14:30.872088',
           now(), now()
    FROM topic WHERE slug = 'enum'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, 'Enum constructors can be public.', FALSE, 0 FROM new_question_47
    UNION ALL SELECT id, 'Each enum constant can have its own constructor parameters.', TRUE, 1 FROM new_question_47
    UNION ALL SELECT id, 'Enum constructors can be protected.', FALSE, 2 FROM new_question_47
    UNION ALL SELECT id, 'Enum constructors can only be private or package-private.', TRUE, 3 FROM new_question_47;

-- Dev question id 48 (topic: enum, language: en)
WITH new_question_48 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           'What does the `name()` method return for an enum constant?', NULL, NULL,
           '`name()` returns the exact name of the enum constant as defined in the source code, regardless of any overridden `toString()` method. This makes it reliable for getting the original constant name.', 'gentest-publish-admin@example.com', '2026-08-26 16:14:30.888034',
           now(), now()
    FROM topic WHERE slug = 'enum'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, 'The name of the constant in lowercase.', FALSE, 0 FROM new_question_48
    UNION ALL SELECT id, 'The name of the constant as defined in the source code.', TRUE, 1 FROM new_question_48
    UNION ALL SELECT id, 'The display name of the constant.', FALSE, 2 FROM new_question_48
    UNION ALL SELECT id, 'The ordinal value of the constant.', FALSE, 3 FROM new_question_48;

-- Dev question id 53 (topic: enum, language: tr)
WITH new_question_53 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           'Aşağıdaki kodun çıktısı ne olacaktır?', 'enum Day { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }

public class Test {
    public static void main(String[] args) {
        System.out.println(Day.valueOf("FRIDAY"));
    }
}', 'java',
           'valueOf(String) metodu, verilen isimle eşleşen sabiti döndürür, bu durumda bu FRIDAY''dir.', 'cdurgun@gmail.com', '2026-08-26 17:43:21.642143',
           now(), now()
    FROM topic WHERE slug = 'enum'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, 'FRIDAY', TRUE, 0 FROM new_question_53
    UNION ALL SELECT id, 'MONDAY', FALSE, 1 FROM new_question_53
    UNION ALL SELECT id, 'SUNDAY', FALSE, 2 FROM new_question_53
    UNION ALL SELECT id, 'IllegalArgumentException', FALSE, 3 FROM new_question_53;

-- Dev question id 54 (topic: enum, language: tr)
WITH new_question_54 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           'Aşağıdaki ifadelerden hangileri enum''lar hakkında doğrudur?', NULL, NULL,
           'Enum''lar arayüzleri uygulayabilir ve kendi yöntemlerine sahip olabilir, bu da bu ifadeleri doğru kılar.', 'cdurgun@gmail.com', '2026-08-26 17:43:39.190128',
           now(), now()
    FROM topic WHERE slug = 'enum'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, 'Enum''lar birden fazla arayüzü uygulayabilir.', TRUE, 0 FROM new_question_54
    UNION ALL SELECT id, 'Enum''lar kendi yöntemlerine sahip olabilir.', TRUE, 1 FROM new_question_54
    UNION ALL SELECT id, 'Enum''lar diğer sınıfları genişletebilir.', FALSE, 2 FROM new_question_54
    UNION ALL SELECT id, 'Enum''lar serileştirilemez.', FALSE, 3 FROM new_question_54;

-- Dev question id 55 (topic: enum, language: tr)
WITH new_question_55 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           'Aşağıdaki enum yapıcılarıyla ilgili ifadelerden hangileri doğrudur? (Uygun olanları seçin)', NULL, NULL,
           'Enum yapıcıları yalnızca özel veya paket özel olabilir, çünkü yalnızca enum''un kendisi içinde çağrılırlar. Ayrıca, her enum sabiti yapıcısına parametre geçirebilir, bu da her sabit için benzersiz veriler sağlar.', 'cdurgun@gmail.com', '2026-08-26 17:43:50.701375',
           now(), now()
    FROM topic WHERE slug = 'enum'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, 'Enum yapıcıları public olabilir.', FALSE, 0 FROM new_question_55
    UNION ALL SELECT id, 'Her enum sabitinin kendi yapıcı parametreleri olabilir.', TRUE, 1 FROM new_question_55
    UNION ALL SELECT id, 'Enum yapıcıları protected olabilir.', FALSE, 2 FROM new_question_55
    UNION ALL SELECT id, 'Enum yapıcıları yalnızca özel veya paket özel olabilir.', TRUE, 3 FROM new_question_55;

-- Dev question id 57 (topic: enum, language: tr)
WITH new_question_57 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           'Aşağıdaki kodun çıktısı ne olacak?', 'enum Day { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }
System.out.println(Day.MONDAY.ordinal());', 'java',
           '`ordinal()` metodu, enum tanımındaki sabitin pozisyonunu 0''dan başlayarak döndürür. `MONDAY` tanımlanan ilk sabit olduğu için, ordinal değeri 0''dır.', 'cdurgun@gmail.com', '2026-08-26 17:44:28.194613',
           now(), now()
    FROM topic WHERE slug = 'enum'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, '0', TRUE, 0 FROM new_question_57
    UNION ALL SELECT id, '1', FALSE, 1 FROM new_question_57
    UNION ALL SELECT id, '6', FALSE, 2 FROM new_question_57
    UNION ALL SELECT id, 'MONDAY', FALSE, 3 FROM new_question_57;

-- Dev question id 58 (topic: enum, language: tr)
WITH new_question_58 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           'Bir enum sabiti için `name()` metodu ne döner?', NULL, NULL,
           '`name()`, enum sabitinin kaynak kodunda tanımlandığı hâliyle tam adını döner; herhangi bir override edilmiş `toString()` metodundan bağımsızdır. Bu da orijinal sabit adını almak için güvenilir bir yöntem olmasını sağlar.', 'cdurgun@gmail.com', '2026-08-26 17:44:14.993395',
           now(), now()
    FROM topic WHERE slug = 'enum'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, 'Sabitin adını küçük harfle.', FALSE, 0 FROM new_question_58
    UNION ALL SELECT id, 'Sabitin kaynak kodunda tanımlandığı hâliyle adını.', TRUE, 1 FROM new_question_58
    UNION ALL SELECT id, 'Sabitin görünen (display) adını.', FALSE, 2 FROM new_question_58
    UNION ALL SELECT id, 'Sabitin ordinal değerini.', FALSE, 3 FROM new_question_58;
