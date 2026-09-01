-- Promotion batch
-- Topic: records (language: en x6, tr x6)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V537 (file-writing), these 12 questions were NOT
-- produced by the n8n generation pipeline, NOT judged by the AI Judge, and
-- NOT ingested via /api/internal/questions/ingest -- per explicit user
-- request, they were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/records.md and content/tr/records.md.
--
-- UNLIKE file-writing's batch, this one uses an explicit 50/50 EN/TR split
-- (6+6, per user request) organized as 6 CONCEPT PAIRS -- each EN question
-- has a TR counterpart testing the exact same Record concept, but the two
-- are independently authored (different record/variable names, different
-- question framing, and in one pair even opposite-polarity option
-- phrasing) rather than being a translation of one another. The 6 concepts
-- covered: compact constructor field-assignment rule, equals() exact-
-- runtime-class check, equals()'s Double.compare()/NaN special case,
-- toString() format, the record restrictions bundle (interfaces allowed /
-- additional constructors must delegate via this() / extra instance fields
-- forbidden / static members allowed), and accessor naming (component name,
-- not Java Bean getX()). Six other lesson-supported concepts from an
-- earlier draft (extend restriction / java.lang.Record, array-component
-- equals() pitfall, serialization calling the canonical constructor,
-- nested-record implicit static, record as a contextual keyword, and an
-- 8th slot) were intentionally dropped to make room for full EN/TR parity
-- at 12 total questions -- see the chat transcript for the full review log.
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly -- same documentation convention as question-
-- promotion/V537. topic_id is resolved by Topic.slug; question_option rows
-- reference the newly generated id of the INSERT immediately above them via
-- a WITH ... RETURNING id CTE -- same pattern as every prior promotion
-- migration in this project.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these 12 questions at all.

-- Pair 1 / EN (SINGLE_CHOICE, INTERMEDIATE) -- compact constructor field-assignment rule
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Inside a compact constructor, which of the following is true?$$, NULL, NULL,
           $$You can reassign a parameter inside a compact constructor (e.g. name = name.trim();) -- the compiler uses the updated value in its implicit field assignment. You cannot assign directly to the field itself (this.name = ...); the compiler rejects this because the implicit assignment will already happen for you.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'records'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$You can reassign a parameter (e.g. name = name.trim();), but you cannot assign directly to the field (this.name = ...).$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$You must repeat the full parameter list, just like in the explicit canonical constructor.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$You can assign directly to the field (this.name = ...) as usual.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Parameter reassignment inside a compact constructor is not allowed.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, INTERMEDIATE) -- same concept, independently framed as a "what happens if" question
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir compact constructor içinde this.isim = isim; şeklinde alana doğrudan atama yapmaya çalışırsanız ne olur?$$, NULL, NULL,
           $$Derleyici, alana yapılan bu doğrudan atamayı hata olarak reddeder -- çünkü örtük atama zaten blok sonunda derleyici tarafından otomatik olarak yapılacaktır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'records'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleyici bunu hata olarak reddeder, çünkü örtük atama zaten blok sonunda otomatik yapılacaktır.$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Kod normal şekilde derlenir ve çalışır.$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca bir uyarı (warning) verir, hata vermez.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca final olmayan bileşenler için bu atama yasaktır.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE) -- equals() exact-runtime-class check
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What will this code print?$$,
           $$record Point(int x, int y) {}
record Coordinate(int x, int y) {}
Point p = new Point(1, 2);
Coordinate c = new Coordinate(1, 2);
System.out.println(p.equals(c));$$, $$java$$,
           $$A record's generated equals() first checks whether both instances are of exactly the same class. Point and Coordinate are different record types, so p.equals(c) returns false even though their components are identical.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'records'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$true$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$false$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It throws a ClassCastException.$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It throws an exception because Point and Coordinate can't be compared.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE) -- same concept, different record names/fields and an extra distractor angle
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$record Boyut(int genislik, int yukseklik) {}
record Dikdortgen(int genislik, int yukseklik) {}
Boyut b = new Boyut(5, 10);
Dikdortgen d = new Dikdortgen(5, 10);
System.out.println(b.equals(d));$$, $$java$$,
           $$Bir record'un ürettiği equals() metodu, önce iki örneğin tam olarak aynı sınıftan olup olmadığını kontrol eder. Boyut ve Dikdortgen farklı record tipleri olduğu için, bileşenleri aynı olsa bile b.equals(d) false döner.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'records'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$true$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$false$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$ClassCastException fırlatır.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Derleme hatası verir.$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, ADVANCED) -- equals()'s Double.compare()/NaN special case
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What will this code print?$$,
           $$record Measurement(double reading) {}
Measurement m1 = new Measurement(Double.NaN);
Measurement m2 = new Measurement(Double.NaN);
System.out.println(m1.equals(m2));$$, $$java$$,
           $$A record's generated equals() compares double/float components using Double.compare()/Float.compare() semantics, not bare ==. Under Double.compare() semantics, NaN is equal to itself, so this prints true -- even though Double.NaN == Double.NaN with primitive == would be false.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'records'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$true$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$false$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It throws an exception.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The result is not guaranteed to be consistent across runs.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, ADVANCED) -- same concept, different record/variable names
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$record Deger(double d) {}
Deger a = new Deger(Double.NaN);
Deger b = new Deger(Double.NaN);
System.out.println(a.equals(b));$$, $$java$$,
           $$Bir record'un ürettiği equals() metodu, double/float bileşenlerini çıplak == yerine Double.compare()/Float.compare() semantiğiyle karşılaştırır. Double.compare() semantiğinde NaN kendisine eşittir, bu yüzden çıktı true olur -- oysa primitive == ile Double.NaN == Double.NaN false döner.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'records'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$true$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$false$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir istisna (exception) fırlatır.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Sonuç her çalıştırmada farklı olabilir.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, BEGINNER) -- toString() format
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$For record Range(int min, int max) {}, what does new Range(1, 10).toString() return?$$, NULL, NULL,
           $$A record's generated toString() lists the simple class name and all components in order, in the form RecordName[component1=value1, component2=value2].$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'records'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Range[min=1, max=10]$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Range(min=1, max=10)$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $${min=1, max=10}$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Range@<hashcode>$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, BEGINNER) -- same concept, different record example
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$record Point(int x, int y) {} için new Point(3, 4).toString() çağrısının çıktısı ne olur?$$, NULL, NULL,
           $$Bir record'un ürettiği toString() metodu, sınıfın basit adını ve tüm bileşenleri sırayla, RecordAdi[bileşen1=değer1, bileşen2=değer2] biçiminde listeler.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'records'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Point[x=3, y=4]$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Point(x=3, y=4)$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $${x=3, y=4}$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Point@<hashcode>$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE) -- restrictions bundle
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about records are true?$$, NULL, NULL,
           $$A record can implement any number of interfaces, and additional constructors must delegate to the canonical constructor via this(...). Static fields and methods are allowed. However, an extra instance field outside the component list is a compile error -- a record's state consists entirely of its component list.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'records'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A record can implement interfaces.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$A record can declare additional constructors, as long as they call the canonical constructor via this(...).$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$You can add an extra instance field to a record's body that is not part of the component list.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Static fields and methods are allowed in a record's body.$$, TRUE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE) -- same 4 facts, one tested via opposite-polarity phrasing
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Record'lar hakkında aşağıdaki ifadelerden hangileri doğrudur?$$, NULL, NULL,
           $$Bir record istediği kadar arayüz implement edebilir ve ek constructor'lar this(...) ile canonical constructor'ı çağırmak zorundadır. Bileşen listesinde yer almayan ekstra bir instance alanı eklenemez -- bir record'un durumu tamamen bileşen listesinden oluşur. Ancak static alan ve metotlar bu kısıtlamaya tabi değildir, tanımlanabilirler.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'records'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir record, istediği kadar arayüz (interface) implement edebilir.$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Canonical constructor dışında tanımlanan ek constructor'lar, ilk satırda mutlaka this(...) ile canonical constructor'ı çağırmalıdır.$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Bileşen listesinde yer almayan ekstra bir instance alanı record'un gövdesine eklenebilir.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Static alan ve metotlar bir record'un gövdesinde tanımlanamaz.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, BEGINNER) -- accessor naming
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly accesses the x component of a Point record instance p, where record Point(int x, int y) {}?$$, NULL, NULL,
           $$Record accessors use the component name directly rather than the Java Bean get prefix, so the correct call is p.x(). The field itself is private, so p.x does not compile from outside the record.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'records'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$p.getX()$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$p.x()$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$p.x$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It cannot be accessed from outside the record; x is only usable inside the record's own methods.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, BEGINNER) -- same concept, different record example
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$record Kullanici(String isim, int yas) {} tanımına göre, bir Kullanici örneğinin isim bileşenine erişmenin doğru yolu nedir?$$, NULL, NULL,
           $$Record accessor'ları, Java Bean get önekiyle değil, doğrudan bileşenin adıyla üretilir -- bu yüzden doğru çağrı kullanici.isim()'dir. Alanın kendisi private olduğu için kullanici.isim doğrudan derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'records'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$kullanici.getIsim()$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$kullanici.isim()$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$kullanici.isim$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Kullanici.isim(kullanici)$$, FALSE, 3 FROM new_question_tr6;
