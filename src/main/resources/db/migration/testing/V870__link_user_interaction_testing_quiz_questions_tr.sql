-- Promotion-style migration linking TR user-interaction-testing quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'user-interaction-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$RTL'nin resmi dokümanları artık fireEvent yerine user-event'i neden öneriyor?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$RTL'nin resmi dokümanları artık fireEvent yerine user-event'i neden öneriyor?$$,
           NULL, NULL,
           $$fireEvent, doğrudan tek bir DOM olayı gönderir; user-event, gerçek bir kullanıcının tıklarken/yazarken tetiklediği ARA adımları da (hover, focus, pointer olayları) simüle eder.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'user-interaction-testing'
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
    ($$Gerçek bir fark yoktur -- öneri tamamen stilistiktir$$, FALSE, 0),
    ($$user-event, yalnızca tek bir olayı değil, gerçek bir kullanıcının tetiklediği ara adımları da (hover, focus, pointer olayları) simüle eder$$, TRUE, 1),
    ($$fireEvent, React Testing Library'den tamamen kaldırıldı ve artık mevcut değil$$, FALSE, 2),
    ($$user-event, her durumda fireEvent'ten önemli ölçüde daha hızlı test çalıştırır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'user-interaction-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'user-interaction-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$userEvent.setup()'ın döndürdüğü nesnedeki click ve type gibi metotlarla her zaman ne yapmalısın?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$userEvent.setup()'ın döndürdüğü nesnedeki click ve type gibi metotlarla her zaman ne yapmalısın?$$,
           NULL, NULL,
           $$Bu nesnenin metotları HER ZAMAN asenkrondur ve await edilmelidir -- unutursan, test tıklama bitmeden bir sonraki satıra geçer ve eski (stale) bir DOM durumunu kontrol eder.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'user-interaction-testing'
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
    ($$Yalnızca bir beforeEach bloğunun içinde çağırmalısın, it() içinde asla değil$$, FALSE, 0),
    ($$Özel bir şey yapmana gerek yok -- sıradan senkron fonksiyon çağrıları gibi davranırlar$$, FALSE, 1),
    ($$Her zaman await etmelisin, çünkü her zaman asenkrondurlar$$, TRUE, 2),
    ($$Her seferinde bir try/catch bloğuna sarmalamalısın$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'user-interaction-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'user-interaction-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$user.type(input, "Ada") gerçekte neyi simüle eder?$$
      AND code_snippet = $$const user = userEvent.setup();
const input = screen.getByLabelText("Ad");
await user.type(input, "Ada");$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$user.type(input, "Ada") gerçekte neyi simüle eder?$$,
           $$const user = userEvent.setup();
const input = screen.getByLabelText("Ad");
await user.type(input, "Ada");$$, $$jsx$$,
           $$user.type, verilen metni KARAKTER KARAKTER yazar -- her tuş vuruşu, tıpkı gerçek bir klavyede yazmak gibi, kontrollü component'in onChange'ini tetikler.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'user-interaction-testing'
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
    ($$Input'un değerini tek bir işlemde, hepsini birden "Ada" olarak ayarlar$$, FALSE, 0),
    ($$Yalnızca üç karakter de yazıldıktan sonra, onChange'i bir kez tetikler$$, FALSE, 1),
    ($$Input'un önceden zaten "Ada" metnini içermesini gerektirir$$, FALSE, 2),
    ($$"Ada"yı karakter karakter yazar, her tuş vuruşunda onChange'i tetikler$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'user-interaction-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'user-interaction-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$vi.fn() ne için kullanılır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$vi.fn() ne için kullanılır?$$,
           NULL, NULL,
           $$vi.fn(), gerçek bir prop'un yerini alan SAHTE bir fonksiyon oluşturur -- component'ten hiçbir gerçek istek çıkmadan, bu fonksiyonun hangi argümanlarla ve kaç kez çağrıldığını doğrulayabiliriz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'user-interaction-testing'
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
    ($$Gerçek bir prop'un yerini alan sahte bir fonksiyon oluşturmak, nasıl ve kaç kez çağrıldığını doğrulamak için$$, TRUE, 0),
    ($$Bir test sunucusuna gerçek bir ağ isteği oluşturmak$$, FALSE, 1),
    ($$Bir component'i sahte DOM'a render etmek$$, FALSE, 2),
    ($$Kullanıcının ekranda belirli bir düğmeye tıklamasını simüle etmek$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'user-interaction-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'user-interaction-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$toHaveBeenCalledWith(...) ve toHaveBeenCalledTimes(...) neyi doğrular?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$toHaveBeenCalledWith(...) ve toHaveBeenCalledTimes(...) neyi doğrular?$$,
           NULL, NULL,
           $$Bunlar, vi.fn() ile oluşturulanlar gibi mock fonksiyonlara özgü matcher'lardır -- bir fonksiyonun hangi argümanlarla ve kaç kez çağrıldığını doğrularlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'user-interaction-testing'
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
    ($$Bir component'in render edilmesinin milisaniye cinsinden ne kadar sürdüğünü$$, FALSE, 0),
    ($$Bir mock fonksiyonun hangi argümanlarla çağrıldığını ve kaç kez çağrıldığını$$, TRUE, 1),
    ($$Bir elementin DOM'da şu anda görünür olup olmadığını$$, FALSE, 2),
    ($$Bir formun input'unun belirli bir placeholder metnine sahip olup olmadığını$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'user-interaction-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'user-interaction-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$KursListesi, mount olduğunda veri getirir ve sonunda bir kurs başlığı render eder, ama hemen değil. Hangi sorgu, onun görünmesini doğru şekilde bekler?$$
      AND code_snippet = $$render(<KursListesi />);
// Render'dan hemen sonra, veri henuz gelmedi
const baslik = await screen.findByText("React'e Giris");$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$KursListesi, mount olduğunda veri getirir ve sonunda bir kurs başlığı render eder, ama hemen değil. Hangi sorgu, onun görünmesini doğru şekilde bekler?$$,
           $$render(<KursListesi />);
// Render'dan hemen sonra, veri henuz gelmedi
const baslik = await screen.findByText("React'e Giris");$$, $$jsx$$,
           $$findByText ASENKRONDUR: element hemen orada değilse hata fırlatmaz, belirli bir süre (varsayılan 1000ms) yeniden dener ve element göründüğünde devam eder -- element sadece o anda DOM'u kontrol eden getByText'in aksine.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'user-interaction-testing'
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
    ($$queryByText, çünkü özellikle asenkron içeriği beklemek için tasarlanmıştır$$, FALSE, 0),
    ($$RTL'nin hiçbir sorgusu henüz orada olmayan içeriği bekleyemez$$, FALSE, 1),
    ($$findByText -- hemen başarısız olmak yerine belirli bir süre yeniden dener$$, TRUE, 2),
    ($$getByText, çünkü her durumda findByText ile birebir aynı şekilde davranır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'user-interaction-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'user-interaction-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, asenkron UI güncellemelerini test etmeyi aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, asenkron UI güncellemelerini test etmeyi aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bu, bir fetch sonucu gibi zamanla DOM'u değiştiren her şeyi test etmenin doğru yoludur; waitFor(...) findByText ile aynı amaç için kullanılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'user-interaction-testing'
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
    ($$findByText, bir fetch sonucu gibi zamanla DOM'u değiştiren her şeyi test etmenin doğru yoludur$$, TRUE, 0),
    ($$waitFor(...), findByText ile aynı amaç için kullanılabilir$$, TRUE, 1),
    ($$getByText ve queryByText, tıpkı findByText gibi, tamamen asenkrondur ve otomatik olarak yeniden dener$$, FALSE, 2),
    ($$Asenkron DOM güncellemeleri hiçbir zaman güvenilir şekilde test edilemez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'user-interaction-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
