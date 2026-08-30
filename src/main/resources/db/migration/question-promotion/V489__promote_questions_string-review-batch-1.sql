-- Promotion batch
-- Development Question IDs: 318, 319, 320, 321, 322, 323, 324, 325, 326, 328, 329, 331, 335, 337, 340, 341, 347
-- Generated: 2026-08-30 (this migration file's authoring date)
-- All 17 questions were reviewed against content/en/string.md and
-- content/tr/string.md (checked for correctness, lesson support, clear
-- wording, explanation accuracy, and duplication) and PUBLISHED in
-- development via QuestionReviewService.publish (same business logic the
-- real ADMIN review UI calls -- not raw SQL). 7 sibling PENDING_REVIEW
-- questions from the same review batch (dev ids 327, 330, 332, 338, 343,
-- 344, 345) were REJECTED in the same pass and are intentionally NOT
-- included here.
--
-- These development IDs are DOCUMENTATION/PROVENANCE ONLY -- no development
-- id is used as a foreign key value anywhere below. topic_id is resolved by
-- Topic.slug (globally unique, stable across environments); question_option
-- rows reference the newly generated id of the INSERT immediately above them
-- via a WITH ... RETURNING id CTE, so this migration is correct regardless of
-- what this environment's own auto-generated ids turn out to be -- same
-- pattern as question-promotion/V431.
--
-- Duplicate-promotion safety (bkz. docs/known-constraints.md "Faz D"): this
-- project intentionally has no promoted_at column or unique constraint yet --
-- before writing a NEW promotion migration, grep existing
-- db/migration/question-promotion/*.sql header comments for these same
-- Development Question IDs to confirm they were not already promoted (done
-- for this migration -- no overlap with V431's ids 44/45/46/47/48/53/54/55/57/58).

-- Dev question id 318 (topic: string, language: en)
WITH new_question_318 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           $$What is the primary characteristic of a String in Java?$$, NULL, NULL,
           $$The primary characteristic of a String in Java is that it is immutable, meaning once created, its content cannot change. This is in contrast to mutable objects, which can be modified after creation.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.582016',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Strings are mutable and can be changed after creation.$$, FALSE, 0 FROM new_question_318
        UNION ALL SELECT id, $$Strings are immutable and cannot be changed after creation.$$, TRUE, 1 FROM new_question_318
        UNION ALL SELECT id, $$Strings are primitive types in Java.$$, FALSE, 2 FROM new_question_318
        UNION ALL SELECT id, $$Strings can only contain single-byte characters.$$, FALSE, 3 FROM new_question_318;

-- Dev question id 319 (topic: string, language: en)
WITH new_question_319 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           $$Which of the following methods can be used to inspect a String in Java?$$, NULL, NULL,
           $$Methods like length(), charAt(), substring(), indexOf(), and contains() are all used to inspect a String. They help retrieve information about the string's content and structure.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.626182',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$length()$$, TRUE, 0 FROM new_question_319
        UNION ALL SELECT id, $$charAt()$$, TRUE, 1 FROM new_question_319
        UNION ALL SELECT id, $$append()$$, FALSE, 2 FROM new_question_319
        UNION ALL SELECT id, $$substring()$$, TRUE, 3 FROM new_question_319;

-- Dev question id 320 (topic: string, language: en)
WITH new_question_320 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           $$What happens when you use the '==' operator to compare two String objects?$$, NULL, NULL,
           $$The '==' operator compares the memory address of the two String objects, not their content. This can lead to incorrect results if the two objects are different instances, even if they contain the same text.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.630077',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It compares the content of the Strings.$$, FALSE, 0 FROM new_question_320
        UNION ALL SELECT id, $$It compares the memory address of the Strings.$$, TRUE, 1 FROM new_question_320
        UNION ALL SELECT id, $$It always returns true for identical Strings.$$, FALSE, 2 FROM new_question_320
        UNION ALL SELECT id, $$It throws an exception if the Strings are different.$$, FALSE, 3 FROM new_question_320;

-- Dev question id 321 (topic: string, language: en)
WITH new_question_321 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           $$What will be the output of the following code?$$, $$String a = "hello"; String b = new String("hello"); System.out.println(a == b);$$, $$java$$,
           $$The output will be 'false' because '==' compares the memory addresses of the two String objects. 'a' refers to a string literal in the string pool, while 'b' is a new String object, so they are different.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.633335',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$true$$, FALSE, 0 FROM new_question_321
        UNION ALL SELECT id, $$false$$, TRUE, 1 FROM new_question_321
        UNION ALL SELECT id, $$hello$$, FALSE, 2 FROM new_question_321
        UNION ALL SELECT id, $$null$$, FALSE, 3 FROM new_question_321;

-- Dev question id 322 (topic: string, language: en)
WITH new_question_322 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           $$What are the benefits of using StringBuilder over String for concatenation?$$, NULL, NULL,
           $$StringBuilder is mutable and allows modifications without creating new objects, making it more efficient for concatenating multiple strings in a loop compared to using immutable Strings, which create new objects each time.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.636252',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$StringBuilder is mutable and modifies the same object.$$, TRUE, 0 FROM new_question_322
        UNION ALL SELECT id, $$StringBuilder is slower than using String.$$, FALSE, 1 FROM new_question_322
        UNION ALL SELECT id, $$Using StringBuilder avoids O(n²) performance issues.$$, TRUE, 2 FROM new_question_322
        UNION ALL SELECT id, $$StringBuilder can only be used with single-byte characters.$$, FALSE, 3 FROM new_question_322;

-- Dev question id 323 (topic: string, language: en)
WITH new_question_323 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           $$What will this code output?$$, $$String str = "   Hello World!   "; System.out.println(str.strip());$$, $$java$$,
           $$The output will be 'Hello World!' because the strip() method removes leading and trailing whitespace, and it is Unicode-aware, making it the preferred method over trim() for whitespace removal.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.638924',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$"Hello World!"$$, TRUE, 0 FROM new_question_323
        UNION ALL SELECT id, $$"   Hello World!   "$$, FALSE, 1 FROM new_question_323
        UNION ALL SELECT id, $$"Hello World!   "$$, FALSE, 2 FROM new_question_323
        UNION ALL SELECT id, $$"   Hello World!"$$, FALSE, 3 FROM new_question_323;

-- Dev question id 324 (topic: string, language: en)
WITH new_question_324 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           $$Which of the following are common mistakes when working with Strings in Java?$$, NULL, NULL,
           $$Common mistakes include using '==' for content comparison instead of equals(), forgetting to assign the return value of a String method, and using '+' for concatenation in loops, which leads to performance issues.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.641474',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Using '==' to compare String content.$$, TRUE, 0 FROM new_question_324
        UNION ALL SELECT id, $$Forgetting to assign a String method's return value.$$, TRUE, 1 FROM new_question_324
        UNION ALL SELECT id, $$Using StringBuilder for concatenation.$$, FALSE, 2 FROM new_question_324
        UNION ALL SELECT id, $$Assuming String.format() truncates numbers.$$, TRUE, 3 FROM new_question_324;

-- Dev question id 325 (topic: string, language: en)
WITH new_question_325 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           $$What is the purpose of the String.format() method?$$, NULL, NULL,
           $$String.format() provides a way to format strings using placeholders, allowing for controlled insertion of variables into strings, which is useful for creating formatted output.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.644102',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$To concatenate multiple Strings together.$$, FALSE, 0 FROM new_question_325
        UNION ALL SELECT id, $$To format strings with placeholders.$$, TRUE, 1 FROM new_question_325
        UNION ALL SELECT id, $$To compare two Strings for equality.$$, FALSE, 2 FROM new_question_325
        UNION ALL SELECT id, $$To convert a String to a byte array.$$, FALSE, 3 FROM new_question_325;

-- Dev question id 326 (topic: string, language: tr)
WITH new_question_326 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           $$Aşağıdakilerden hangileri String nesnelerinin temel özelliklerindendir?$$, NULL, NULL,
           $$Doğru cevaplar 'Immutable' ve 'String Pool'dur. String nesneleri immutable'dır ve aynı metne sahip string literalleri String Pool içinde paylaşılır. 'Mutable' seçeneği yanlıştır çünkü String nesneleri değiştirilemez.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.646557',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Immutable$$, TRUE, 0 FROM new_question_326
        UNION ALL SELECT id, $$Mutable$$, FALSE, 1 FROM new_question_326
        UNION ALL SELECT id, $$String Pool$$, TRUE, 2 FROM new_question_326
        UNION ALL SELECT id, $$Dinamik$$, FALSE, 3 FROM new_question_326;

-- Dev question id 328 (topic: string, language: tr)
WITH new_question_328 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           $$Aşağıdaki ifadelerden hangileri String.format() metodunun özellikleridir?$$, NULL, NULL,
           $$Doğru cevaplar '%s, %d, %.2f' ve 'printf tarzı biçimlendirme' ifadeleridir. Bu ifadeler String.format() metodunun işlevselliğini tanımlar. 'String birleştirme' yanlıştır çünkü bu metod birleştirme işlemi yapmaz.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.648863',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$%s, %d, %.2f$$, TRUE, 0 FROM new_question_328
        UNION ALL SELECT id, $$String birleştirme$$, FALSE, 1 FROM new_question_328
        UNION ALL SELECT id, $$Hata mesajı yazdırma$$, FALSE, 2 FROM new_question_328
        UNION ALL SELECT id, $$printf tarzı biçimlendirme$$, TRUE, 3 FROM new_question_328;

-- Dev question id 329 (topic: string, language: tr)
WITH new_question_329 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           $$String nesneleri arasında içerik karşılaştırması yapmak için hangi metot kullanılmalıdır?$$, NULL, NULL,
           $$Doğru cevap 'equals()' metodudur. equals() metodu içerik karşılaştırması yapar. '==' operatörü ise nesne kimliğini karşılaştırdığı için yanlış bir seçimdir.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.651658',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$==$$, FALSE, 0 FROM new_question_329
        UNION ALL SELECT id, $$equals()$$, TRUE, 1 FROM new_question_329
        UNION ALL SELECT id, $$compareTo()$$, FALSE, 2 FROM new_question_329
        UNION ALL SELECT id, $$equalsIgnoreCase()$$, FALSE, 3 FROM new_question_329;

-- Dev question id 331 (topic: string, language: tr)
WITH new_question_331 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           $$Java'da bir String nesnesi oluşturmanın en yaygın yolu nedir?$$, NULL, NULL,
           $$Doğru cevap 'literal yazmak'tır. String nesneleri genellikle bir literal ile oluşturulur. 'new String() kullanmak' yanlıştır çünkü bu, her zaman yeni bir nesne yaratır ve genellikle gereksizdir.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.653739',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$new String() kullanmak$$, FALSE, 0 FROM new_question_331
        UNION ALL SELECT id, $$literal yazmak$$, TRUE, 1 FROM new_question_331
        UNION ALL SELECT id, $$char[] kullanmak$$, FALSE, 2 FROM new_question_331
        UNION ALL SELECT id, $$StringBuilder kullanmak$$, FALSE, 3 FROM new_question_331;

-- Dev question id 335 (topic: string, language: en)
WITH new_question_335 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           $$Which of the following are best practices when working with strings in Java? (Select all that apply)$$, NULL, NULL,
           $$Using equals() for content comparison and StringBuilder for concatenation in loops are recommended practices to avoid common pitfalls.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.655686',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Use == for string content comparison$$, FALSE, 0 FROM new_question_335
        UNION ALL SELECT id, $$Use StringBuilder for concatenating strings in a loop$$, TRUE, 1 FROM new_question_335
        UNION ALL SELECT id, $$Always use equals() for string content comparison$$, TRUE, 2 FROM new_question_335
        UNION ALL SELECT id, $$Use String for building multi-line text$$, FALSE, 3 FROM new_question_335;

-- Dev question id 337 (topic: string, language: tr)
WITH new_question_337 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           $$Aşağıdakilerden hangileri String sınıfının immutability özelliğinden kaynaklanan avantajlardır?$$, NULL, NULL,
           $$Doğru seçenekler, immutability'nin sağladığı avantajlardır. Thread-safe olması, hashCode değerinin önbelleğe alınabilmesi ve string pool'un varlığı bu avantajlar arasındadır. Diğer seçenekler ise immutability ile doğrudan ilgili değildir.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.657794',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Thread-safe olması$$, TRUE, 0 FROM new_question_337
        UNION ALL SELECT id, $$Bellek tasarrufu sağlaması$$, TRUE, 1 FROM new_question_337
        UNION ALL SELECT id, $$Daha hızlı string birleştirme$$, FALSE, 2 FROM new_question_337
        UNION ALL SELECT id, $$Daha fazla bellek kullanması$$, FALSE, 3 FROM new_question_337;

-- Dev question id 340 (topic: string, language: tr)
WITH new_question_340 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           $$Aşağıdakilerden hangileri String sınıfının yaygın hataları arasında yer alır?$$, NULL, NULL,
           $$Doğru seçenekler, string karşılaştırmalarında ve metot dönüş değerlerinin atanmamasıyla ilgili yaygın hatalardır. Diğer seçenekler ise yaygın hatalar arasında sayılmaz.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.660218',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$== ile string içeriğini karşılaştırmak$$, TRUE, 0 FROM new_question_340
        UNION ALL SELECT id, $$Bir String metodunun dönüş değerini atamamak$$, TRUE, 1 FROM new_question_340
        UNION ALL SELECT id, $$StringBuilder kullanmak$$, FALSE, 2 FROM new_question_340
        UNION ALL SELECT id, $$String.format() kullanmak$$, FALSE, 3 FROM new_question_340;

-- Dev question id 341 (topic: string, language: tr)
WITH new_question_341 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'OPENAI',
           $$StringBuilder ile ilgili hangisi doğrudur?$$, NULL, NULL,
           $$StringBuilder, mutable bir karakter dizisi tutarak aynı nesneyi yerinde değiştirir. Bu, yeni bir nesne döndürmediği için performans açısından avantaj sağlar.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.662466',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Mutable bir karakter dizisi tutar$$, TRUE, 0 FROM new_question_341
        UNION ALL SELECT id, $$Her zaman yeni bir nesne döndürür$$, FALSE, 1 FROM new_question_341
        UNION ALL SELECT id, $$Sadece tek satırlı string'ler için kullanılır$$, FALSE, 2 FROM new_question_341
        UNION ALL SELECT id, $$Thread-safe değildir$$, FALSE, 3 FROM new_question_341;

-- Dev question id 347 (topic: string, language: tr)
WITH new_question_347 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'OPENAI',
           $$Aşağıdakilerden hangileri String birleştirme işlemleri için en iyi uygulamalardır?$$, NULL, NULL,
           $$Doğru cevaplar 'StringBuilder kullanmak' ve 'Kısa birleştirmeler için + kullanmak'. StringBuilder, döngülerde string birleştirme için daha verimlidir. 'String kullanmak' ve '+= operatörünü kullanmak' yanlıştır çünkü bu yöntemler performans sorunlarına yol açabilir.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.664725',
           now(), now()
    FROM topic WHERE slug = 'string'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$String kullanmak$$, FALSE, 0 FROM new_question_347
        UNION ALL SELECT id, $$StringBuilder kullanmak$$, TRUE, 1 FROM new_question_347
        UNION ALL SELECT id, $$+ operatörünü kullanmak$$, FALSE, 2 FROM new_question_347
        UNION ALL SELECT id, $$Kısa birleştirmeler için + kullanmak$$, TRUE, 3 FROM new_question_347;

