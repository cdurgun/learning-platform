-- Promotion-style migration linking TR controlling-agent-behavior quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlling-agent-behavior')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'Why Agents Need Guardrails'a göre, kısıtlanmamış bir agent loop'u neden tek bir tool call'dan daha risklidir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$'Why Agents Need Guardrails'a göre, kısıtlanmamış bir agent loop'u neden tek bir tool call'dan daha risklidir?$$,
           NULL, NULL,
           $$Ders, bir agent loop'unun bir insan yerine model tarafından seçilen, sırayla birçok eylem alabileceğini ve bu eylemlerin her birinin gerçek bir yan etkisi olan gerçek bir tool call olabileceğini belirtir -- yanlış bir karar ya da yanlış argümanı hedefleyen bir tool call, bir insanın göndermeye karar verdiği tek bir tool call'ın aksine, çalışmadan önce bir insan tarafından yakalanmaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlling-agent-behavior'
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
    ($$Çünkü tek bir tool call, çalıştırılması her zaman tam bir agent loop'undan daha yavaştır$$, FALSE, 0),
    ($$Çünkü guardrail'ler yalnızca bir agent gerçek, teyit edilmiş bir finansal zarara yol açtıktan sonra gereklidir$$, FALSE, 1),
    ($$Çünkü bir insan değil model, gerçek yan etkileri olan bir dizi gerçek eylem seçer, bu yüzden yanlış bir karar çalışmadan önce bir insan tarafından yakalanmaz$$, TRUE, 2),
    ($$Çünkü bir agent loop'u teknik olarak gerçek bir yan etkisi olan gerçek bir aracı hiçbir zaman çağıramaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlling-agent-behavior'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlling-agent-behavior')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir step limit (iteration limit) nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir step limit (iteration limit) nedir?$$,
           NULL, NULL,
           $$Bir step limit sert bir yedektir: loop'un çalışmasına izin verilen maksimum decide-act döngüsü sayısıdır, modelin kendi yargısına bırakılmak yerine kodda zorunlu kılınır -- ulaşıldığında, loop ne yapıyor olursa olsun koşulsuz olarak durur, kasıtlı olarak akıllı değil kaba bir mekanizmadır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlling-agent-behavior'
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
    ($$Modelin hedefin tam olarak bitmediğine inanırsa görmezden gelmeyi seçebileceği yumuşak bir öneri$$, FALSE, 0),
    ($$Bir MCP server'ın herhangi bir client'a sunmasına izin verilen araç sayısı üzerindeki bir sınır$$, FALSE, 1),
    ($$Tek bir tool sonucunun içerebileceği toplam token sayısı üzerindeki bir sınır$$, FALSE, 2),
    ($$Bir loop'un çalışmasına izin verilen, kodda zorunlu kılınan, sert bir maksimum decide-act döngüsü sayısı, ulaşıldığında loop'u koşulsuz olarak durdurur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlling-agent-behavior'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlling-agent-behavior')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'Human-in-the-Loop: Approval Before Risky Actions'a göre, bir agent'ın alabileceği her eylem insan onayından geçmesi gerekir mi?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$'Human-in-the-Loop: Approval Before Risky Actions'a göre, bir agent'ın alabileceği her eylem insan onayından geçmesi gerekir mi?$$,
           NULL, NULL,
           $$Ders açıktır: bu, her eylemin onay gerektirdiği anlamına gelmez, bu bir agent'a sahip olmanın amacını tamamen ortadan kaldırırdı -- bu, yanlış bir kararın yeterince pahalı olduğu (maliyetli, geri döndürülemez ya da doğrulanması zor) alt kümeyi bilinçli olarak işaretlemek anlamına gelir, öyle ki kısa bir onay duraklaması kaybedilen hıza değer.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlling-agent-behavior'
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
    ($$Hayır -- her eylem için onay gerektirmek bir agent'a sahip olmanın amacını ortadan kaldırırdı; yalnızca maliyetli, geri döndürülemez ya da doğrulanması zor eylemler onaydan geçirilmelidir$$, TRUE, 0),
    ($$Evet -- bir agent'ın aldığı her tek eylem, istisnasız olarak her zaman bir insan tarafından çalışmadan önce onaylanmalıdır$$, FALSE, 1),
    ($$Hayır -- human-in-the-loop, hiçbir koşulda hiçbir eylemin asla onay gerektirmemesi gerektiği anlamına gelir$$, FALSE, 2),
    ($$Evet, ama yalnızca özellikle get_capital_city ya da calculate_sum'ı çağırmayı içeren eylemler için$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlling-agent-behavior'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlling-agent-behavior')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir agent'a, gerçek görevi yalnızca kayıtları okumayı gerektirdiği halde, herhangi bir kaydı silebilen bir araç veriliyor. 'Scoping Tool Access: The Principle of Least Privilege'a göre, bu ne tür bir risk yaratır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir agent'a, gerçek görevi yalnızca kayıtları okumayı gerektirdiği halde, herhangi bir kaydı silebilen bir araç veriliyor. 'Scoping Tool Access: The Principle of Least Privilege'a göre, bu ne tür bir risk yaratır?$$,
           NULL, NULL,
           $$Ders, bunun agent'ın karar vermesinin ne kadar iyi olduğuyla hiçbir ilgisi olmayan bir risk yarattığını belirtir -- bu risk yalnızca kötüye kullanılabilecek bir yetenek mevcut olduğu için var olur; daha dar araç erişimi agent'ın akıl yürütmesini daha iyi yapmaz, ama kötü bir kararın yaratabileceği zararın alanını daraltır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlling-agent-behavior'
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
    ($$Loop'a observability/logging eklenir eklenmez tamamen ortadan kalkan bir risk$$, FALSE, 0),
    ($$Agent'ın karar vermesinin ne kadar iyi olduğuyla hiçbir ilgisi olmayan bir risk -- bu risk yalnızca gereksiz silme yeteneği kötüye kullanılabilir olduğu için var olur$$, TRUE, 1),
    ($$Gerçek bir risk yoktur, çünkü daha geniş araç erişimi vermek her zaman bir agent'ın altta yatan akıl yürütmesini daha güvenilir yapar$$, FALSE, 2),
    ($$Yalnızca agent'a her eylem için human-in-the-loop onayı da verilirse ortaya çıkan bir risk$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlling-agent-behavior'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlling-agent-behavior')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir agent yanlış bir nihai cevap üretiyor, ve hangi araçları hangi argümanlarla çağırdığına ya da hangi sonuçları geri aldığına dair hiçbir kayıt yok. 'Observability: Logging and Tracing an Agent's Decisions'a göre, bu ders bu durumu teşhis etmek hakkında ne söylüyor?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir agent yanlış bir nihai cevap üretiyor, ve hangi araçları hangi argümanlarla çağırdığına ya da hangi sonuçları geri aldığına dair hiçbir kayıt yok. 'Observability: Logging and Tracing an Agent's Decisions'a göre, bu ders bu durumu teşhis etmek hakkında ne söylüyor?$$,
           NULL, NULL,
           $$Ders, bu loglama olmadan, yanlış bir nihai cevabın hata ayıklanmasının neredeyse imkansız olduğunu belirtir -- modelin yanlış akıl yürütüp yürütmediğini, doğru aracı yanlış argümanlarla çağırıp çağırmadığını, ya da doğru bir sonuç alıp onu yanlış kullanıp kullanmadığını söylemenin bir yolu yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlling-agent-behavior'
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
    ($$Bu yalnızca aynı hedefi tamamen farklı bir araç kümesiyle yeniden çalıştırarak teşhis edilebilir$$, FALSE, 0),
    ($$Herhangi bir yanlış cevabın neden oluştuğunu açıklamak için tek başına bir step limit her zaman yeterlidir$$, FALSE, 1),
    ($$Hata ayıklaması neredeyse imkansızdır -- her adımın bir kaydı olmadan, gerçek hatanın nerede olduğunu söylemenin bir yolu yoktur$$, TRUE, 2),
    ($$Hata ayıklaması önemsizdir, çünkü yanlış bir nihai cevap tek başına kök nedeni her zaman açık kılar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlling-agent-behavior'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlling-agent-behavior')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir agent'a bir müşteri veritabanına yalnızca okuma erişimi (least privilege) veriliyor, 10'luk bir step limit'i var, ve her kararını loglıyor -- ama iade e-postası göndermek dahil, aldığı hiçbir eylem hiçbir zaman insan onayı gerektirmiyor. Bu derse göre, bu guardrail kombinasyonu özellikle iade e-postası göndermek için yeterli midir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir agent'a bir müşteri veritabanına yalnızca okuma erişimi (least privilege) veriliyor, 10'luk bir step limit'i var, ve her kararını loglıyor -- ama iade e-postası göndermek dahil, aldığı hiçbir eylem hiçbir zaman insan onayı gerektirmiyor. Bu derse göre, bu guardrail kombinasyonu özellikle iade e-postası göndermek için yeterli midir?$$,
           NULL, NULL,
           $$Ders, bunları farklı riskleri ele alan, ayrı ve birbirini tamamlayan mekanizmalar olarak ele alır -- least privilege, bir step limit ve loglama, iade e-postası göndermek gibi maliyetli, geri döndürülmesi zor bir eylem için human-in-the-loop onayının yerini tutmaz; 'Human-in-the-Loop', diğer guardrail'ler zaten mevcut olsa bile, maliyetli, geri döndürülemez ya da otomatik doğrulanması zor eylemlerin özellikle bir onay adımına ihtiyaç duyduğunu belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlling-agent-behavior'
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
    ($$Evet -- tek başına bir step limit, iade e-postası göndermek dahil herhangi bir eylemi onaysız çalıştırmak için her zaman yeterlidir$$, FALSE, 0),
    ($$Evet -- her kararı loglamak, maliyetli herhangi bir eylemin gerçek dünyada bir yan etkiye sahip olmasını otomatik olarak engeller$$, FALSE, 1),
    ($$Hayır -- ama yalnızca salt-okunur veritabanı erişimi zaten bir e-posta göndermeyi baştan imkansız kıldığı için$$, FALSE, 2),
    ($$Hayır -- least privilege, step limit ve loglama farklı riskleri ele alır; iade e-postası göndermek gibi maliyetli, geri döndürülmesi zor bir eylem hâlâ kendi human-in-the-loop onay adımına ihtiyaç duyar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlling-agent-behavior'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlling-agent-behavior')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, agent davranışını kontrol etmek hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, agent davranışını kontrol etmek hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (bir step limit bilinçli olarak kaba bir mekanizmadır -- agent'ın 'neredeyse bitmiş' olup olmadığı konusunda akıllı olmaya çalışmaz, sınıra ulaşıldığında loop'u koşulsuz olarak durdurur; ve least privilege ilkesi, bir agent'ın araçlarına, 'ne olur ne olmaz' diye daha geniş erişim değil, tam olarak görevinin ihtiyaç duyduğunu vermek anlamına gelir); loop'u durdurmak için yalnızca modelin kendi yargısına güvenmek, bu derste açıkça yaygın bir hata olarak adlandırılır (bir yedek olarak sert bir step limit gereklidir), ve observability özellikle loop'un yalnızca nihai cevabını değil, her adımını loglamak anlamına gelir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlling-agent-behavior'
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
    ($$Bir step limit bilinçli olarak kaba bir mekanizmadır -- agent'ın 'neredeyse bitmiş' olup olmadığını yargılamaya çalışmaz, sınıra ulaşıldığında loop'u koşulsuz olarak durdurur$$, TRUE, 0),
    ($$Least privilege ilkesi, bir agent'ın araçlarına 'ne olur ne olmaz diye' daha geniş erişim değil, tam olarak görevinin ihtiyaç duyduğunu vermek anlamına gelir$$, TRUE, 1),
    ($$Bu derste, loop'u durdurmak için sert bir step limit olmadan yalnızca modelin kendi yargısına güvenmek yeterli olarak önerilir$$, FALSE, 2),
    ($$Bu derste observability, yalnızca agent'ın nihai cevabını kaydetmek anlamına gelir, ona götüren bireysel adımları değil$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlling-agent-behavior'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
