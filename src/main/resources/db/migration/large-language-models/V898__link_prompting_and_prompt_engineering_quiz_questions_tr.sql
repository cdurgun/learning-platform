-- Promotion-style migration linking TR prompting-and-prompt-engineering quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'prompting-and-prompt-engineering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir 'prompt' tam olarak nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir 'prompt' tam olarak nedir?$$,
           NULL, NULL,
           $$Bu, dersin tanımıyla örtüşür -- bir prompt, context'in bir kişi ya da sistem tarafından doğrudan oluşturulan ve kontrol edilen kısmıdır; ayrı bir filtreleme programı değildir, pretraining sırasında sabitlenmez ve kullanıcının hiç görmediği gizli bir iç akıl yürütme değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'prompting-and-prompt-engineering'
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
    ($$Pretraining sırasında modele gömülen, sabit ve değiştirilemez bir dizge$$, FALSE, 0),
    ($$Modelin kullanıcının asla görmediği kendi iç akıl yürütmesi$$, FALSE, 1),
    ($$Bir kişinin veya sistemin bir yanıt üretmek için oluşturup LLM'e verdiği metin -- context'in doğrudan kontrol edilen kısmı$$, TRUE, 2),
    ($$LLM'nin yanında çalışıp çıktısını filtreleyen ayrı bir program$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'prompting-and-prompt-engineering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'prompting-and-prompt-engineering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Yapılandırılmış bir LLM konuşmasında, system prompt'un rolü user prompt'a kıyasla nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Yapılandırılmış bir LLM konuşmasında, system prompt'un rolü user prompt'a kıyasla nedir?$$,
           NULL, NULL,
           $$Bu, dersin rol tanımlarına doğrudan uyar -- system prompt, genellikle uygulama tarafından bir kez ayarlanan, tüm konuşma için genel davranışı belirler, user prompt ise belirli bir turdaki spesifik istektir; roller ne aynıdır ne tersine çevrilebilir ve ikisi de modelin okuduğu aynı context'in parçasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'prompting-and-prompt-engineering'
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
    ($$System prompt ve user prompt amaç bakımından aynıdır, yalnızca farklı etiketlerdir$$, FALSE, 0),
    ($$User prompt tüm konuşma için davranışı belirler, system prompt ise tur başına spesifik istektir$$, FALSE, 1),
    ($$Modelin context'ine yalnızca system prompt dahil edilir; user prompt ayrı işlenir$$, FALSE, 2),
    ($$System prompt, genellikle uygulama tarafından bir kez ayarlanan, tüm konuşma için modelin genel davranışını/persona'sını belirler; user prompt ise belirli bir turdaki spesifik istektir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'prompting-and-prompt-engineering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'prompting-and-prompt-engineering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir geliştirici, LLM'nin sözcüklerle tam olarak tarif edilmesi zor, çok özel bir JSON yapısında çıktı döndürmesini istiyor. Bu derse göre, hangi yaklaşım daha güvenilir olma eğilimindedir ve neden?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir geliştirici, LLM'nin sözcüklerle tam olarak tarif edilmesi zor, çok özel bir JSON yapısında çıktı döndürmesini istiyor. Bu derse göre, hangi yaklaşım daha güvenilir olma eğilimindedir ve neden?$$,
           NULL, NULL,
           $$Bu, dersin bir formatı göstermenin genellikle onu tarif etmekten daha güvenilir olduğuna dair açık ipucuna uyar -- diğer seçenekler bu rehberlikle çelişir ya da hangi yaklaşımın her zaman kazandığını aşırı genellemektedir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'prompting-and-prompt-engineering'
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
    ($$Tam olarak istenen JSON yapısının iki veya üç çözümlenmiş örneğini gösteren bir few-shot prompt, çünkü bir formatı göstermek genellikle onu tarif etmekten daha güvenilirdir$$, TRUE, 0),
    ($$Son derece uzun bir biçimlendirme talimatları paragrafı içeren bir zero-shot prompt$$, FALSE, 1),
    ($$Hiçbir yaklaşım yapılandırılmış çıktı için güvenilir şekilde çalışmaz -- bu temel bir kısıtlamadır$$, FALSE, 2),
    ($$Görevden bağımsız olarak zero-shot prompt her zaman few-shot'tan daha güvenilirdir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'prompting-and-prompt-engineering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'prompting-and-prompt-engineering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir prompt yalnızca 'Bunu özetle' diyor ve çalıştırmalar arasında tutarsız sonuçlar üretiyor. Bu dersin etkili prompt yazma rehberliğine göre, en olası çözüm nedir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir prompt yalnızca 'Bunu özetle' diyor ve çalıştırmalar arasında tutarsız sonuçlar üretiyor. Bu dersin etkili prompt yazma rehberliğine göre, en olası çözüm nedir?$$,
           NULL, NULL,
           $$Bu, dersin belirsiz bir prompt ile spesifik olanı karşılaştıran açık örneğine uyar -- çözüm spesifiklik (görev, çıktı formatı, odak) sağlamaktır, model değiştirmek, talimatları kaldırmak ya da aynı belirsiz ifadeyi tekrarlamak değil.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'prompting-and-prompt-engineering'
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
    ($$Aynı belirsiz talimatı aynı prompt içinde birden çok kez tekrarlamak$$, FALSE, 0),
    ($$Görev ve istenen çıktı hakkında spesifik olmak -- örneğin, 'Bunu, finansal rakamlara odaklanarak tam olarak üç madde işaretiyle özetle' gibi tam bir format ve odak belirtmek$$, TRUE, 1),
    ($$Tamamen farklı, daha büyük bir modele geçmek, çünkü prompt'un kendisinde bir sorun yoktur$$, FALSE, 2),
    ($$Tüm talimatları tamamen kaldırmak, çünkü talimatlar genellikle modeli karıştırır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'prompting-and-prompt-engineering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'prompting-and-prompt-engineering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, prompt engineering'e nasıl yaklaşılmalıdır ve en çok neye benzer?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, prompt engineering'e nasıl yaklaşılmalıdır ve en çok neye benzer?$$,
           NULL, NULL,
           $$Bu, dersin debugging veya yinelemeli (iterative) yazılım geliştirmeyle karşılaştırılan, açık 'yaz, test et, gözlemle, revize et, tekrarla' çerçevesine uyar -- tek seferlik bir görev değildir, tamamen rastgele bir deneme-yanılma değildir ve test etme sürecin kaçınılması gereken değil ayrılmaz bir parçasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'prompting-and-prompt-engineering'
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
    ($$İzlenecek yararlı bir kalıp olmayan, tamamen rastgele bir deneme-yanılma süreci olarak$$, FALSE, 0),
    ($$Test etme prompt'u yanlı hale getirebileceği için, herhangi bir testten önce yalnızca bir kez yapılması gereken bir görev olarak$$, FALSE, 1),
    ($$Debugging veya yinelemeli (iterative) yazılım geliştirmeye benzer, yinelemeli bir süreç olarak -- yaz, gerçekçi girdilere karşı test et, başarısızlıkları gözlemle ve revize et, sonra tekrarla$$, TRUE, 2),
    ($$Tek seferlik bir görev olarak -- prompt'u bir kez yaz, hiçbir revizyon olmadan sonsuza kadar mükemmel çalışmalıdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'prompting-and-prompt-engineering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'prompting-and-prompt-engineering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir geliştirici, çok adımlı bir matematik problemi için bir prompt'a 'bunu adım adım düşün, sonra nihai cevabını ver' ekliyor ve doğruluk artıyor. Bu tekniğin arkasındaki mekanizma nedir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir geliştirici, çok adımlı bir matematik problemi için bir prompt'a 'bunu adım adım düşün, sonra nihai cevabını ver' ekliyor ve doğruluk artıyor. Bu tekniğin arkasındaki mekanizma nedir?$$,
           NULL, NULL,
           $$Bu, dersin chain-of-thought prompting'i, in-context learning yoluyla modelin kendi adım adım akıl yürütmesini nihai cevabını dayandıracağı ek bağlam olarak geri beslemek şeklinde açıklamasına uyar -- harici bir araç çağrılmaz, yeniden eğitim gerçekleşmez ve teknik yanıtı kısaltarak çalışmaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'prompting-and-prompt-engineering'
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
    ($$Modele harici bir hesap makinesi aracına erişim sağlar$$, FALSE, 0),
    ($$Modeli matematikte daha iyi olacak şekilde kalıcı olarak yeniden eğitir$$, FALSE, 1),
    ($$Modelin yanıtını kısaltarak çalışır, bu da her zaman doğruluğu artırır$$, FALSE, 2),
    ($$Buna chain-of-thought prompting denir -- in-context learning yoluyla, modelin kendi akıl yürütmesinin daha fazlasını, nihai cevabını dayandıracağı ek bağlam olarak verir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'prompting-and-prompt-engineering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'prompting-and-prompt-engineering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, prompting hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, prompting hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve C derste doğrudan belirtilir (role/persona prompting'in tarzı/odağı değiştirip yeni bilgi vermemesi; açık kısıtlamaların örtük olanlardan daha güvenilir olması); uzunluğun tek başına kaliteyi belirlemediği (kesinlik/ilgi daha önemlidir ve ekstra token'lar para/zaman kaybettirir), ve karmaşık bir görevi açık adımlara bölmenin daha az değil, daha güvenilir sonuçlar için önerildiği belirtilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'prompting-and-prompt-engineering'
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
    ($$Role/persona prompting (örneğin, 'deneyimli bir güvenlik mühendisi olarak bu kodu incele') bir yanıtın tarzını ve odağını değiştirir, ama modele daha önce sahip olmadığı hiçbir yeni bilgi vermez$$, TRUE, 0),
    ($$Bir prompt içinde kısıtlamaları (uzunluk sınırları, kaçınılması gerekenler) açıkça belirtmek, bunları örtük bırakıp modelin çıkarım yapmasını ummaktan daha güvenilir olma eğilimindedir$$, TRUE, 1),
    ($$Daha uzun, daha ayrıntılı bir prompt, her zaman daha kısa ve kesin bir prompt'tan nesnel olarak daha iyidir$$, FALSE, 2),
    ($$Karmaşık bir görevi prompt içinde daha küçük, açık adımlara bölmek, her şeyi bir kerede istemekten daha az güvenilir sonuçlar üretme eğilimindedir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'prompting-and-prompt-engineering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
