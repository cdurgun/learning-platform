-- Promotion batch
-- Topic: java-bean-validation (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V679-V714 (Spring MVC) and V659-V678 (Spring
-- Core), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/java-bean-validation.md and
-- content/tr/java-bean-validation.md.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different code/variable names, different question
-- framing) rather than a translation. Every question whose answer depends on
-- shown code is typed CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a
-- code_snippet attached) -- fragments/quiz.html only renders code_snippet for
-- CODE_OUTPUT questions, per the bug found and fixed in try-catch-finally/V573.
--
-- Each question's 4 options are written with the correct answer at a VARIED
-- position (not always first), applied directly during authoring via a
-- deterministic per-question rotation -- per the bug found and fixed in
-- question-promotion/V598 (Exceptions/Generics batches were 100% "always A").
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly -- same documentation convention as prior manual
-- batches. topic_id resolved by Topic.slug; question_option rows reference
-- the newly generated id via a WITH ... RETURNING id CTE.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these 14 questions at all.

-- Pair 1 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Which statement correctly describes the difference between @Positive and @PositiveOrZero?$$,
           NULL, NULL,
           $$@Positive is strict and rejects zero; @PositiveOrZero accepts zero.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'java-bean-validation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$They are functionally identical$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$@Positive rejects zero (strict); @PositiveOrZero accepts zero$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$@PositiveOrZero is stricter than @Positive$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$@Positive only works on BigDecimal, @PositiveOrZero only on int$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$@Positive ile @PositiveOrZero arasındaki fark için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$@Positive katıdır ve sıfırı reddeder; @PositiveOrZero sıfırı kabul eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'java-bean-validation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@Positive yalnızca BigDecimal ile, @PositiveOrZero yalnızca int ile çalışır$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$İşlevsel olarak birebir aynıdırlar$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$@PositiveOrZero, @Positive'den daha katıdır$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$@Positive sıfırı reddeder (katı); @PositiveOrZero sıfırı kabul eder$$, TRUE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Does @Future accept the exact current moment ("now") as valid?$$,
           NULL, NULL,
           $$@Future is strict -- "now" itself fails it; @FutureOrPresent would be needed to allow it.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'java-bean-validation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes, because @Future only checks the date part, not the time$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It depends on which date/time type is used$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$No -- @Future is strict, "now" itself fails it; @FutureOrPresent would be needed for that$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Yes, "now" is always considered in the future by a few milliseconds$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$@Future, tam olarak şu anki anı ("şimdi") geçerli olarak kabul eder mi?$$,
           NULL, NULL,
           $$@Future katıdır -- "şimdi"nin kendisi bu kontrolü geçemez; buna izin vermek için @FutureOrPresent gerekir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'java-bean-validation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet, çünkü @Future yalnızca tarih kısmını kontrol eder, saati değil$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Hangi tarih/saat tipinin kullanıldığına bağlıdır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Hayır -- @Future katıdır, "şimdi"nin kendisi bu kontrolü geçemez; bunun için @FutureOrPresent gerekir$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Evet, "şimdi" her zaman birkaç milisaniye ileride sayılır$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A developer writes the following constraint on a BigDecimal field. What happens?$$,
           $$record Price(@DecimalMin(0.01) BigDecimal amount) {}$$, $$java$$,
           $$@DecimalMin's value must be a String, not a numeric literal -- this fails to compile.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'java-bean-validation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It compiles and works exactly like @DecimalMin("0.01")$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It fails to compile -- @DecimalMin's value must be a String, not a numeric literal$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It compiles but always rejects every value due to floating-point rounding$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It compiles and silently ignores the bound entirely$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir geliştirici bir BigDecimal alanına şu kısıtlamayı yazıyor. Ne olur?$$,
           $$record Fiyat(@DecimalMin(0.01) BigDecimal tutar) {}$$, $$java$$,
           $$@DecimalMin'in değeri bir String olmalıdır, sayısal bir literal değil -- bu derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'java-bean-validation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenmez -- @DecimalMin'in değeri sayısal bir literal değil, bir String olmalıdır$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Derlenir ve tam olarak @DecimalMin("0.01") gibi çalışır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Derlenir ama floating-point yuvarlaması yüzünden her değeri reddeder$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Derlenir ama sınırı tamamen sessizce yok sayar$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is the purpose of writing message = "{user.age.tooYoung}" instead of a literal string on a constraint?$$,
           NULL, NULL,
           $$It resolves the message from a messages.properties file for the active locale, instead of a single hardcoded string.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'java-bean-validation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It disables the constraint entirely, only logging the key$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It forces the constraint to run twice, once per locale$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It has no effect -- both forms behave identically$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$It resolves the message from a messages.properties file for the active locale, instead of a single hardcoded string$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir kısıtlamada düz bir string yerine message = "{user.age.tooYoung}" yazmanın amacı nedir?$$,
           NULL, NULL,
           $$Mesajı, tek bir sabit-kodlanmış string yerine, aktif locale için bir messages.properties dosyasından çözer.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'java-bean-validation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Kısıtlamayı tamamen devre dışı bırakır, yalnızca key'i loglar$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Kısıtlamanın her locale için iki kez çalışmasını zorunlu kılar$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Mesajı, tek bir sabit-kodlanmış string yerine, aktif locale için bir messages.properties dosyasından çözer$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Hiçbir etkisi yoktur -- iki biçim de aynı şekilde davranır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why is @ValidDateRange placed on the record itself (class/type level) rather than on checkIn or checkOut individually?$$,
           $$@Target(ElementType.TYPE)
@Constraint(validatedBy = DateRangeValidator.class)
@interface ValidDateRange { String message() default "Invalid date range"; }

class DateRangeValidator implements ConstraintValidator<ValidDateRange, BookingRequest> {
    public boolean isValid(BookingRequest b, ConstraintValidatorContext ctx) {
        return b.checkOut().isAfter(b.checkIn());
    }
}

@ValidDateRange
record BookingRequest(LocalDate checkIn, LocalDate checkOut) {}$$, $$java$$,
           $$The rule needs to see both fields at once -- no single-field annotation could express "checkOut must be after checkIn".$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'java-bean-validation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because Bean Validation doesn't allow annotations on record components at all$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Because the rule needs to see both fields at once -- no single-field annotation could express "checkOut must be after checkIn"$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Because class-level annotations run before field-level ones, which is required here$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It's an arbitrary style choice with no functional reason$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$@GecerliTarihAraligi, neden giris veya cikis'in kendisine değil de record'un tamamına (sınıf/tip seviyesine) konur?$$,
           $$@Target(ElementType.TYPE)
@Constraint(validatedBy = TarihAraligiValidator.class)
@interface GecerliTarihAraligi { String message() default "Gecersiz tarih araligi"; }

class TarihAraligiValidator implements ConstraintValidator<GecerliTarihAraligi, RezervasyonRequest> {
    public boolean isValid(RezervasyonRequest r, ConstraintValidatorContext ctx) {
        return r.cikis().isAfter(r.giris());
    }
}

@GecerliTarihAraligi
record RezervasyonRequest(LocalDate giris, LocalDate cikis) {}$$, $$java$$,
           $$Kural aynı anda iki alanı görmesi gerektiği için -- hiçbir tek-alan annotation'ı "cikis, giris'ten sonra olmalı" kuralını ifade edemez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'java-bean-validation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Kural aynı anda iki alanı görmesi gerektiği için -- hiçbir tek-alan annotation'ı "cikis, giris'ten sonra olmalı" kuralını ifade edemez$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Bean Validation, record bileşenlerinde annotation kullanımına hiç izin vermediği için$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Sınıf seviyesi annotation'lar alan seviyesindekilerden önce çalışır ve burada bu gereklidir$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Hiçbir işlevsel nedeni olmayan, keyfi bir stil tercihidir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$By convention, what should a custom ConstraintValidator's isValid(...) method return when the value being validated is null?$$,
           NULL, NULL,
           $$true -- it lets a separate @NotNull constraint be the one responsible for reporting a missing value.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'java-bean-validation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It should throw a NullPointerException to fail fast$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It doesn't matter, since Bean Validation never calls a validator with a null value$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$false, so no field is ever accidentally left unvalidated$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$true -- it lets a separate @NotNull constraint be the one responsible for reporting a missing value$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Kural olarak, özel bir ConstraintValidator'ın isValid(...) metodu, doğrulanan değer null olduğunda ne döndürmelidir?$$,
           NULL, NULL,
           $$true -- bu, eksik bir değeri raporlama sorumluluğunu ayrı bir @NotNull kısıtlamasına bırakır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'java-bean-validation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hızlı başarısız olmak için bir NullPointerException fırlatmalıdır$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bean Validation bir validator'ı asla null bir değerle çağırmadığı için önemli değildir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$true -- bu, eksik bir değeri raporlama sorumluluğunu ayrı bir @NotNull kısıtlamasına bırakır$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Hiçbir alanın yanlışlıkla doğrulanmadan kalmaması için false$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about validation groups? (Select all that apply)$$,
           NULL, NULL,
           $$A group-tagged constraint only runs for that group; an untagged constraint is silently skipped when validating against a specific group; the same DTO can enforce different constraints per group. Groups are NOT a general-purpose recommended mechanism for every DTO.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'java-bean-validation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A constraint tagged groups = OnUpdate.class only runs when validating against that specific group$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A constraint with no groups attribute at all is silently skipped when validating against a specific group$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Validation groups are the general-purpose, recommended way to validate every DTO in the application$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$The same DTO can enforce different constraints depending on which group it's validated against$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Validation group'ları ile ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Grup etiketli bir kısıtlama yalnızca o grup için çalışır; etiketlenmemiş bir kısıtlama belirli bir gruba karşı doğrulanırken atlanır; aynı DTO gruba göre farklı kısıtlamalar uygulayabilir. Group'lar her DTO için genel amaçlı önerilen bir mekanizma DEĞİLDİR.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'java-bean-validation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Aynı DTO, hangi gruba karşı doğrulandığına bağlı olarak farklı kısıtlamalar uygulayabilir$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$groups = OnUpdate.class ile etiketlenmiş bir kısıtlama yalnızca o belirli grup için doğrulama yapılırken çalışır$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Validation group'ları, uygulamadaki her DTO'yu doğrulamak için önerilen, genel amaçlı bir yoldur$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Hiç groups attribute'u olmayan bir kısıtlama, belirli bir gruba karşı doğrulama yapılırken sessizce atlanır$$, TRUE, 3 FROM new_question_tr7;
