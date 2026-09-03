-- Promotion batch
-- Topic: lists-and-keys (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V731-V766 (Spring Data JPA) and V715-V730
-- (Advanced Spring), these 14 questions were NOT produced by the n8n
-- generation pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/lists-and-keys.md and
-- content/tr/lists-and-keys.md.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different code/variable/component names, different
-- question framing) rather than a translation. Every question whose answer
-- depends on shown code is typed CODE_OUTPUT (never SINGLE_CHOICE/
-- MULTIPLE_CHOICE with a code_snippet attached) -- fragments/quiz.html only
-- renders code_snippet for CODE_OUTPUT questions, per the bug found and fixed
-- in try-catch-finally/V573.
--
-- Each question's 4 options are written with the correct answer at a VARIED
-- position (not always first), applied directly during authoring via a
-- deterministic per-question rotation incorporating the migration version --
-- per the bug found and fixed in question-promotion/V598 (always-A bias) and
-- refined again in the Spring Data JPA batch (parity-locked EN/TR offsets).
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
           $$What JavaScript function do you use to turn an array into JSX elements on screen?$$,
           NULL, NULL,
           $$map() -- it turns every element in an array into something else and returns a new array, here turning each item into a JSX element React can render.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$filter()$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$map()$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$reduce()$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$forEach()$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir diziyi ekranda JSX elementlerine dönüştürmek için hangi JavaScript fonksiyonunu kullanırsın?$$,
           NULL, NULL,
           $$map() -- dizideki her elemanı başka bir şeye dönüştürür ve yeni bir dizi döndürür, burada her öğeyi React'in render edebileceği bir JSX elementine çevirir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$forEach()$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$map()$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$filter()$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$reduce()$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What do you need to give each element when rendering a list with map()?$$,
           NULL, NULL,
           $$A key prop -- when rendering a list with map(), you need to give each element a key prop.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Nothing extra -- map() handles identity automatically with no prop needed$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$A key prop$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$A separate onClick handler, even if nothing is clickable$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$A unique CSS class name for every single item$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$map() ile bir liste render ederken her elemana ne vermen gerekir?$$,
           NULL, NULL,
           $$Bir key prop'u -- map() ile bir liste render ederken, her elemana bir key prop'u vermen gerekir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her tek öğe için benzersiz bir CSS class adı$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Ekstra hiçbir şey -- map() kimliği hiçbir prop'a gerek kalmadan otomatik olarak halleder$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir key prop'u$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Hiçbir şey tıklanabilir olmasa bile, ayrı bir onClick handler'ı$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What should key be, and what's the preferred source for it?$$,
           NULL, NULL,
           $$key is a string or number that uniquely identifies that item within the list; whenever possible, use a stable identifier like an id from your database, not the item's name or its index.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The item's display text is always the correct and only valid choice for key$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$A boolean indicating whether the item is currently visible$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$A string or number uniquely identifying the item, preferably a stable id, not the item's name or index$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Any random value -- key doesn't need to be unique as long as it's a string$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$key ne olmalıdır ve bunun için tercih edilen kaynak nedir?$$,
           NULL, NULL,
           $$key, o öğeyi liste içinde benzersiz şekilde tanımlayan bir string ya da sayıdır; mümkün olduğunda, öğenin adı ya da index'i değil, veritabanından gelen bir id gibi stabil bir tanımlayıcı kullanılmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Rastgele herhangi bir değer -- key bir string olduğu sürece benzersiz olması gerekmez$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Öğenin görüntülenen metni, key için her zaman doğru ve tek geçerli seçimdir$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Öğenin şu anda görünür olup olmadığını belirten bir boolean$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Öğeyi benzersiz şekilde tanımlayan bir string ya da sayı, tercihen stabil bir id, öğenin adı ya da index'i değil$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does key actually tell React?$$,
           NULL, NULL,
           $$key tells React which list item on the next render is the SAME as which item from the previous render.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$How to visually sort the list on screen$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Which CSS styles to apply to that specific item$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Whether the item should be included in the array at all$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Which list item on the next render is the same as which item from the previous render$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$key aslında React'e ne söyler?$$,
           NULL, NULL,
           $$key, bir sonraki render'daki hangi liste öğesinin, önceki render'daki hangi öğeyle AYNI olduğunu React'e söyler.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir sonraki render'daki hangi liste öğesinin, önceki render'daki hangi öğeyle aynı olduğunu$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Listenin ekranda görsel olarak nasıl sıralanacağını$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$O belirli öğeye hangi CSS stillerinin uygulanacağını$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Öğenin diziye dahil edilip edilmeyeceğini$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A task list uses the array index as key. The first item is removed from the list. What problem can this cause?$$,
           $${tasks.map((task, index) => (
    <TaskItem key={index} task={task} />
))}
// The first task is removed from the tasks array$$, $$jsx$$,
           $$Once an item is removed, every remaining item's index shifts -- React can no longer tell, just by looking at the index, whether it's the same item or a different one, which can cause the wrong item to end up being updated (e.g. wrong checkboxes).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No problem at all -- index-based keys always behave identically to stable id-based keys$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Every remaining item's index shifts, and React can end up updating the wrong item (like the wrong checkbox)$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The list stops rendering entirely, showing a blank screen$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$React throws a compile-time error, since index keys are invalid syntax$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir görev listesi, key olarak dizi index'ini kullanıyor. Listeden ilk öğe kaldırılıyor. Bu hangi soruna yol açabilir?$$,
           $${gorevler.map((gorev, index) => (
    <GorevOgesi key={index} gorev={gorev} />
))}
// gorevler dizisinden ilk gorev kaldiriliyor$$, $$jsx$$,
           $$Bir öğe kaldırıldığında, kalan her öğenin index'i kayar -- React, yalnızca index'e bakarak artık aynı öğe mi yoksa farklı bir öğe mi olduğunu ayırt edemez, bu da yanlış öğenin güncellenmesine yol açabilir (örneğin yanlış checkbox'lar).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$index key'leri geçersiz bir sözdizimi olduğu için React bir derleme zamanı hatası fırlatır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Kalan her öğenin index'i kayar, ve React yanlış öğeyi (örneğin yanlış checkbox'ı) güncelleyebilir$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Hiçbir sorun yoktur -- index tabanlı key'ler her zaman stabil id tabanlı key'lerle birebir aynı davranır$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Liste tamamen render edilmeyi bırakır, boş bir ekran gösterir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, is using the array index as key ever an acceptable choice?$$,
           NULL, NULL,
           $$If you truly have no stable identifier and the list is never reordered or changed, the index can be a last resort.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only for lists containing exactly one item$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Never -- it's always strictly forbidden under every circumstance$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$As a last resort, if there's truly no stable identifier and the list is never reordered or changed$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Yes, and it's actually the officially preferred choice over a stable id$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, dizi index'ini key olarak kullanmak hiç kabul edilebilir bir seçim midir?$$,
           NULL, NULL,
           $$Gerçekten stabil bir tanımlayıcın yoksa ve liste asla yeniden sıralanmıyor ya da değiştirilmiyorsa, index bir son çare olabilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet, ve aslında stabil bir id'ye karşı resmi olarak tercih edilen seçimdir$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Yalnızca tam olarak bir öğe içeren listeler için$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir son çare olarak, eğer gerçekten stabil bir tanımlayıcı yoksa ve liste asla yeniden sıralanmıyor ya da değiştirilmiyorsa$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Asla -- her koşulda kesinlikle yasaktır$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about key and React's reconciliation process, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$key lets React update only the part of the list that actually changed instead of rebuilding the whole list; as long as the list never changes, key doesn't seem to matter; the problems show up specifically when items are added, removed, or reordered.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$key-related problems specifically show up when items are added, removed, or the order changes$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$key is only relevant for lists rendered with a for loop, never with map()$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$key lets React update only the part of the list that actually changed, instead of rebuilding the whole list$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$As long as the list never changes, key doesn't seem to matter$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, key ve React'in reconciliation süreciyle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$key, React'in tüm listeyi yeniden inşa etmek yerine yalnızca gerçekten değişen kısmı güncellemesini sağlar; liste hiç değişmediği sürece key önemli görünmez; sorunlar özellikle öğeler eklendiğinde, kaldırıldığında ya da sıra değiştiğinde ortaya çıkar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$key, React'in tüm listeyi yeniden inşa etmek yerine yalnızca gerçekten değişen kısmı güncellemesini sağlar$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Liste hiç değişmediği sürece, key önemli görünmez$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$key ile ilgili sorunlar özellikle öğeler eklendiğinde, kaldırıldığında ya da sıra değiştiğinde ortaya çıkar$$, TRUE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$key yalnızca bir for döngüsüyle render edilen listeler için geçerlidir, map() ile asla geçerli değildir$$, FALSE, 3 FROM new_question_tr7;
