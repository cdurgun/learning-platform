-- Promotion-style migration linking TR tokens-and-context-windows quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tokens-and-context-windows')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir LLM bağlamında 'token' nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir LLM bağlamında 'token' nedir?$$,
           NULL, NULL,
           $$Bu, dersin kesin tanımıyla örtüşür; token'lar yalnızca ödeme için var olan bir kavram değildir, her zaman tam olarak bir karakter uzunluğunda değildir ve kimlik doğrulama bilgisi değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tokens-and-context-windows'
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
    ($$Her zaman tam olarak bir karakter uzunluğunda olan, ne daha fazla ne daha az, tek bir karakter$$, FALSE, 0),
    ($$Yeni bir konuşma başlatmak için gereken benzersiz bir şifre$$, FALSE, 1),
    ($$Bir LLM'nin okuduğu ve ürettiği gerçek metin birimi -- genellikle bir kelimeye yakın, ama her zaman değil$$, TRUE, 2),
    ($$Yalnızca görüntü üretim istekleri için alınan bir ödeme birimi$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tokens-and-context-windows'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tokens-and-context-windows')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$LLM'ler, yalnızca tam kelimelerden oluşan bir kelime dağarcığı yerine neden alt-kelime (sub-word) token'ları kullanır?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$LLM'ler, yalnızca tam kelimelerden oluşan bir kelime dağarcığı yerine neden alt-kelime (sub-word) token'ları kullanır?$$,
           NULL, NULL,
           $$Bu, dersin açık gerekçesine uyar: yalnızca tam kelimelerden oluşan bir kelime dağarcığı ya devasa büyüklükte olurdu ya da görülmemiş kelimelerde (yazım hataları, isimler, uydurma kelimeler) sürekli başarısız olurdu; alt-kelime token'ları mütevazı bir kelime dağarcığının herhangi bir metni temsil etmesini sağlar -- diğer seçenekler desteksizdir ya da dersle çelişir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tokens-and-context-windows'
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
    ($$Alt-kelime token'ları, doğruluğu artırmak amacıyla modelin bilerek daha yavaş çalışmasını sağlar$$, FALSE, 0),
    ($$Tam kelimeler sayı olarak temsil edilemez, yalnızca alt-kelime parçaları edilebilir$$, FALSE, 1),
    ($$Bu tamamen tarihsel bir tesadüftür, arkasında hiçbir pratik gerekçe yoktur$$, FALSE, 2),
    ($$Yalnızca tam kelimelerden oluşan bir kelime dağarcığı ya devasa büyüklükte olurdu ya da görülmemiş kelimelerde (yazım hataları, isimler, uydurma kelimeler) sürekli başarısız olurdu; alt-kelime token'ları mütevazı bir kelime dağarcığının herhangi bir metni temsil etmesini sağlar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tokens-and-context-windows'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tokens-and-context-windows')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir modelin context window'u 8.000 token. Talimatlar ve geçmiş dahil bir kullanıcının konuşması 8.500 token'a ulaşıyor. Ne olmak zorundadır?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir modelin context window'u 8.000 token. Talimatlar ve geçmiş dahil bir kullanıcının konuşması 8.500 token'a ulaşıyor. Ne olmak zorundadır?$$,
           NULL, NULL,
           $$Bu derse uyar: context window sert bir tavandır, bu yüzden bir şeylerden vazgeçilmelidir -- sisteme bağlı olarak eski içerik düşürülür, özetlenir ya da istek doğrudan reddedilir; bu 'yumuşak bir öneri' değildir, model kendi window'unu otomatik büyütmez ve en eski yerine en yeni içeriği sessizce yok saymaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tokens-and-context-windows'
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
    ($$Bir şeylerden vazgeçilmelidir: sınır sert bir tavan olduğu için eski içerik düşürülür, özetlenir veya istek doğrudan reddedilir$$, TRUE, 0),
    ($$Hiçbir şey -- context window'lar gerçek bir sınır değil, yumuşak bir öneridir$$, FALSE, 1),
    ($$Model, isteğe sığmak için kendi context window'unu otomatik olarak büyütür$$, FALSE, 2),
    ($$Model, en eski token'lar yerine sessizce en yeni 500 token'ı yok sayar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tokens-and-context-windows'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tokens-and-context-windows')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir kullanıcı çok uzun bir konuşmanın başında önemli bir şey söylüyor. Daha sonra, konuşma context window'u aştığında ve en eski mesajlar düşürüldüğünde, model artık o bilgiye atıfta bulunmuyor. Neden?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir kullanıcı çok uzun bir konuşmanın başında önemli bir şey söylüyor. Daha sonra, konuşma context window'u aştığında ve en eski mesajlar düşürüldüğünde, model artık o bilgiye atıfta bulunmuyor. Neden?$$,
           NULL, NULL,
           $$Bu derse birebir uyar: modelin kendi başına, o anki context'in ötesinde bir belleği yoktur, her yanıtta yalnızca o an mevcut olanı yeniden okur; düşürülen içerik, hiç söylenmemiş olmakla işlevsel olarak aynıdır -- bu normal, beklenen, yapısal bir davranıştır, nadir bir hata ya da bilinçli bir seçim değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tokens-and-context-windows'
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
    ($$Bu yalnızca nadir bir hata yüzünden olur, normal beklenen bir davranış değildir$$, FALSE, 0),
    ($$İçerik context window'dan düştüğünde, model ona hiç erişemez -- her yanıtta yalnızca o an context'te olanı yeniden okur, bunun ötesinde bir belleği yoktur$$, TRUE, 1),
    ($$Modelin konuşma hakkında daha derin bir belleği vardır ama onu kullanmamayı tercih eder$$, FALSE, 2),
    ($$Model, katılmadığı bilgileri bilerek yok sayar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tokens-and-context-windows'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tokens-and-context-windows')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Context window yeterince büyük olsa bile, 'ne olur ne olmaz' diye uzun, çoğunlukla ilgisiz bir belgeyi bir LLM'in context'ine eklemenin neden gerçek bir dezavantajı vardır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Context window yeterince büyük olsa bile, 'ne olur ne olmaz' diye uzun, çoğunlukla ilgisiz bir belgeyi bir LLM'in context'ine eklemenin neden gerçek bir dezavantajı vardır?$$,
           NULL, NULL,
           $$Bu derse uyar: token'lar hem girdi hem çıktı için faturalandırılır ve model her yanıtta tüm context'i yeniden okur, bu yüzden window'da yer olup olmadığından bağımsız olarak maliyet ve gecikme context boyutuyla ölçeklenir -- diğer seçenekler hiçbir maliyet olmadığını yanlış şekilde iddia eder.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tokens-and-context-windows'
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
    ($$Yanıtın kendisi kısa olduğu sürece ekstra token'lar ücretsizdir$$, FALSE, 0),
    ($$Büyük context window'lar, token sayısıyla ilişkili her türlü maliyeti ortadan kaldırır$$, FALSE, 1),
    ($$Model her yanıtta tüm context'i yeniden okuduğu için, eklenen her token, window'da yer olup olmadığından bağımsız olarak gerçek bir maliyete (faturalandırma) ve gecikmeye yol açar$$, TRUE, 2),
    ($$Context window'a sığdığı sürece hiçbir dezavantajı yoktur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tokens-and-context-windows'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tokens-and-context-windows')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir sistemin, kullanıcının çok uzun bir konuşmanın çok öncesinde söylenen bir şeye atıfta bulunmasına izin vermesi gerekiyor, ama tüm ham geçmişi sonsuza kadar context'te tutmayı göze alamıyor. Her şeyi tutmak veya her şeyi sıkıştırmak yerine, mevcut istek için gereken yalnızca belirli, ilgili bilgi parçalarını getiren strateji hangisidir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir sistemin, kullanıcının çok uzun bir konuşmanın çok öncesinde söylenen bir şeye atıfta bulunmasına izin vermesi gerekiyor, ama tüm ham geçmişi sonsuza kadar context'te tutmayı göze alamıyor. Her şeyi tutmak veya her şeyi sıkıştırmak yerine, mevcut istek için gereken yalnızca belirli, ilgili bilgi parçalarını getiren strateji hangisidir?$$,
           NULL, NULL,
           $$Retrieval, yalnızca ilgili parçaları talep üzerine getirir ve derse uyar; truncation yalnızca en eski içeriği düşürür, summarization her şeyi daha kısa bir özete sıkıştırır (tam ifadeyi kaybederek) ve tokenization, bir context yönetim stratejisi değil, ilgisiz bir metin bölme sürecidir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tokens-and-context-windows'
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
    ($$Truncation$$, FALSE, 0),
    ($$Summarization$$, FALSE, 1),
    ($$Tokenization$$, FALSE, 2),
    ($$Retrieval$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tokens-and-context-windows'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tokens-and-context-windows')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, token'lar ve context window'lar hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, token'lar ve context window'lar hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve C derste doğrudan belirtilir (tokenization'ın dile göre değişmesi; token sayısının kelime sayısından farklı olması); daha büyük bir window bile ilgisiz içerik için token maliyeti taşımaya devam eder, bu yüzden maliyet/gecikme ortadan kalkmaz, ve üç context yönetim stratejisinin açıkça farklı ödünleşimleri vardır, aynı değil.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tokens-and-context-windows'
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
    ($$Tokenization dile göre anlamlı şekilde değişebilir, bu yüzden aynı cümle farklı dillerde belirgin şekilde farklı sayıda token'a mal olabilir$$, TRUE, 0),
    ($$Token sayısı, kelime sayısıyla aynı değildir -- context kullanımını yalnızca kelime sayısına göre tahmin etmek yanıltıcı olabilir$$, TRUE, 1),
    ($$Daha büyük bir context window, ilgisiz içeriğin artık hiçbir maliyeti olmadığı için, hangi bilginin gerçekten dahil edildiğini düşünme ihtiyacını ortadan kaldırır$$, FALSE, 2),
    ($$Truncation, summarization ve retrieval, her durumda birbirinin yerine geçebilen, aynı ödünleşimlere sahip stratejilerdir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tokens-and-context-windows'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
