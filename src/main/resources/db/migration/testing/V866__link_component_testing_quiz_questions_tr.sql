-- Promotion-style migration linking TR component-testing quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, Vitest ile React Testing Library arasındaki iş bölümü nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Vitest ile React Testing Library arasındaki iş bölümü nedir?$$,
           NULL, NULL,
           $$Vitest, testleri ÇALIŞTIRAN araçtır (describe, it, expect); React Testing Library, bir component'i sahte bir DOM'a MOUNT etmeni ve o DOM'u SORGULAMANI sağlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-testing'
      AND NOT EXISTS (SELECT 1 FROM existing_q1)
    RETURNING id
),
target_q1 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q1
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q1
),
option_ins_q1 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q1.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q1
             CROSS JOIN (VALUES
    ($$Vitest yalnızca class component'lerle, React Testing Library yalnızca function component'lerle çalışır$$, FALSE, 0),
    ($$Vitest testleri çalıştırır; React Testing Library bir component'i sahte bir DOM'a mount edip sorgular$$, TRUE, 1),
    ($$İki rakip, birbirinin yerine geçebilen test runner'ıdır -- yalnızca biri kurulur$$, FALSE, 2),
    ($$React Testing Library testleri çalıştırır; Vitest component'leri DOM'a mount eder$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Vitest yapılandırmasındaki environment: "jsdom" ne yapar?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Vitest yapılandırmasındaki environment: "jsdom" ne yapar?$$,
           NULL, NULL,
           $$Testlerin, gerçek bir tarayıcı yerine Node içinde sahte bir DOM'a karşı çalışmasını sağlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-testing'
      AND NOT EXISTS (SELECT 1 FROM existing_q2)
    RETURNING id
),
target_q2 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q2
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q2
),
option_ins_q2 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q2.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q2
             CROSS JOIN (VALUES
    ($$DOM ile ilgili tüm assertion'ları tamamen devre dışı bırakır$$, FALSE, 0),
    ($$Her test dosyasını otomatik olarak bir .jsx dosyasına dönüştürür$$, FALSE, 1),
    ($$Testlerin, gerçek bir tarayıcı yerine Node içinde sahte bir DOM'a karşı çalışmasını sağlar$$, TRUE, 2),
    ($$Çalışan her test için gerçek bir Chrome tarayıcı penceresi açar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Sayac, ilk mount edildiğinde "Sayi: 0" metnini render ediyor. Bu test çalıştığında ne olur?$$
      AND code_snippet = $$it("baslangic sayisini gosterir", () => {
    render(<Sayac />);
    expect(screen.getByText("Sayi: 0")).toBeInTheDocument();
});$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Sayac, ilk mount edildiğinde "Sayi: 0" metnini render ediyor. Bu test çalıştığında ne olur?$$,
           $$it("baslangic sayisini gosterir", () => {
    render(<Sayac />);
    expect(screen.getByText("Sayi: 0")).toBeInTheDocument();
});$$, $$jsx$$,
           $$render(<Sayac />), component'i jsdom'a mount eder; screen.getByText o metni içeren elementi bulur, ve toBeInTheDocument() var olduğunu doğrular -- test geçer.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-testing'
      AND NOT EXISTS (SELECT 1 FROM existing_q3)
    RETURNING id
),
target_q3 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q3
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q3
),
option_ins_q3 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q3.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q3
             CROSS JOIN (VALUES
    ($$render() ikinci bir argüman gerektirdiği için test hemen başarısız olur$$, FALSE, 0),
    ($$Hiçbir şey olmaz -- getByText mount edilen DOM'u gerçekte hiç aramaz$$, FALSE, 1),
    ($$it() bir render çağrısı içeremediği için test bir sözdizimi hatası fırlatır$$, FALSE, 2),
    ($$Test geçer -- Sayac mount edilir, ve getByText eşleşen metni bulur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$RTL'nin resmi dokümanları, mümkün olduğunda TERCİH EDİLEN sorgu olarak hangisini önerir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$RTL'nin resmi dokümanları, mümkün olduğunda TERCİH EDİLEN sorgu olarak hangisini önerir?$$,
           NULL, NULL,
           $$RTL'nin resmi dokümanları, gerçek bir kullanıcının (ya da ekran okuyucunun) sayfayı algılama şekline daha yakın olduğu için, mümkün olduğunda getByRole'u tercih edilen sorgu olarak önerir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-testing'
      AND NOT EXISTS (SELECT 1 FROM existing_q4)
    RETURNING id
),
target_q4 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q4
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q4
),
option_ins_q4 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q4.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q4
             CROSS JOIN (VALUES
    ($$getByRole$$, TRUE, 0),
    ($$Hiçbir istisna olmadan, her durumda getByText$$, FALSE, 1),
    ($$Doğrudan bir document.querySelector çağrısı$$, FALSE, 2),
    ($$Önerilen bir tercih yoktur -- her sorgu eşit derecede uygun kabul edilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu JSX'e göre, screen.getByLabelText("Ad") neyi bulur?$$
      AND code_snippet = $$<label htmlFor="ad">Ad</label>
<input id="ad" type="text" />$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu JSX'e göre, screen.getByLabelText("Ad") neyi bulur?$$,
           $$<label htmlFor="ad">Ad</label>
<input id="ad" type="text" />$$, $$jsx$$,
           $$getByLabelText("Ad"), sorgu için özel olarak bir id ya da test-id eklemeye gerek kalmadan, <label htmlFor="ad">'a bağlı input'u bulur.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-testing'
      AND NOT EXISTS (SELECT 1 FROM existing_q5)
    RETURNING id
),
target_q5 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q5
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q5
),
option_ins_q5 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q5.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q5
             CROSS JOIN (VALUES
    ($$Hem label hem input'u birlikte, tek bir birleşik element olarak$$, FALSE, 0),
    ($$htmlFor/id aracılığıyla label'a bağlı olan <input> elementini$$, TRUE, 1),
    ($$Input değil, <label> elementinin kendisini$$, FALSE, 2),
    ($$Hiçbir şey -- getByLabelText'in çalışması için ayrı bir data-testid attribute'u gerekir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, jest-dom matcher'larını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, jest-dom matcher'larını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$toBeDisabled()/toBeEnabled(), bir elementin disabled attribute'unu kontrol eder; toBeInTheDocument(), bir elementin DOM'da var olup olmadığını doğrular; bunların hiçbiri sade Vitest'te yoktur -- jest-dom paketi tarafından eklenir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-testing'
      AND NOT EXISTS (SELECT 1 FROM existing_q6)
    RETURNING id
),
target_q6 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q6
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q6
),
option_ins_q6 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q6.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q6
             CROSS JOIN (VALUES
    ($$Bu matcher'ların hiçbiri sade Vitest'te yoktur -- özellikle jest-dom paketi tarafından eklenir$$, TRUE, 0),
    ($$toBeDisabled(), bir elementin disabled attribute'unu değil, metin içeriğini kontrol eder$$, FALSE, 1),
    ($$jest-dom matcher'ları, ekstra bir import gerekmeden varsayılan olarak Vitest'e dahildir$$, FALSE, 2),
    ($$toBeInTheDocument(), bir elementin DOM'da hiç var olup olmadığını doğrular$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, getByText ile queryByText arasındaki farkı aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, getByText ile queryByText arasındaki farkı aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$getByText, eşleşen elementi bulamazsa hata fırlatır; queryByText fırlatMAZ -- null döndürür, bu yüzden bir şeyin ekranda YOK olduğunu iddia etmek için queryBy* kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-testing'
      AND NOT EXISTS (SELECT 1 FROM existing_q7)
    RETURNING id
),
target_q7 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q7
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q7
),
option_ins_q7 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q7.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q7
             CROSS JOIN (VALUES
    ($$getByText, eşleşen elementi bulamazsa bir hata fırlatır$$, TRUE, 0),
    ($$queryByText, hata fırlatmak yerine null döndürür, bu yüzden bir şeyin yok olduğunu iddia etmek için kullanılır$$, TRUE, 1),
    ($$getByText ve queryByText, hiçbir gerçek fark olmadan her durumda birebir aynı şekilde davranır$$, FALSE, 2),
    ($$queryByText yalnızca ARIA role'e göre sorgulamak için kullanılabilir, metin içeriğine göre asla kullanılamaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
