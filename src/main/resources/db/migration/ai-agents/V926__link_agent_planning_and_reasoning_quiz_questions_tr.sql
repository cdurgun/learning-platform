-- Promotion-style migration linking TR agent-planning-and-reasoning quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'agent-planning-and-reasoning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, ReAct kalıbı her adımda ne yapar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, ReAct kalıbı her adımda ne yapar?$$,
           NULL, NULL,
           $$ReAct, her eylemle görünür bir akıl yürütme adımını iç içe geçirir -- bir tool call seçmeden önce model önce akıl yürütmesini açıklayan kısa bir metin üretir, ve ancak ondan sonra eylemin kendisini üretir; bir sonraki gözlem geri beslenir, ve döngü tekrarlanır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'agent-planning-and-reasoning'
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
    ($$Tamamlanmış bir çıktıyı, nihai kabul etmeden önce sonradan eleştirir$$, FALSE, 0),
    ($$Akıl yürütmeyi tamamen atlar ve her seferinde doğrudan nihai cevaba geçer$$, FALSE, 1),
    ($$Her eylemle görünür bir akıl yürütme adımını iç içe geçirir -- model, eylemin kendisini üretmeden önce metin içinde akıl yürütmesini açıklar$$, TRUE, 2),
    ($$Herhangi bir eylem almadan önce tam, çok adımlı bir plan üretir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'agent-planning-and-reasoning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'agent-planning-and-reasoning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, plan-and-execute ReAct'ten farklı olarak ne yapar?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, plan-and-execute ReAct'ten farklı olarak ne yapar?$$,
           NULL, NULL,
           $$Plan-and-execute, loop'u iç içe geçirmek yerine iki ayrı aşamaya böler: önce, hedef verildiğinde, model herhangi bir eylem almadan önce çok adımlı bir plan üretir; sonra bir yürütme adımı bu planı adım adım işler.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'agent-planning-and-reasoning'
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
    ($$Tıpkı ReAct'in yaptığı gibi, her tek eylemle görünür bir akıl yürütme adımını iç içe geçirir$$, FALSE, 0),
    ($$Agent'ın kendi çıktısını, zaten üretildikten sonra eleştirir$$, FALSE, 1),
    ($$Bir adımın sonucu planı geçersiz kılsa bile hiçbir koşulda planı asla revize etmez$$, FALSE, 2),
    ($$Herhangi bir eylem almadan önce tam, çok adımlı bir plan üretir, sonra bu planı adım adım yürütür$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'agent-planning-and-reasoning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'agent-planning-and-reasoning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, reflection kalıbı bir agent'ın loop'una ne ekler?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, reflection kalıbı bir agent'ın loop'una ne ekler?$$,
           NULL, NULL,
           $$Reflection, bir eylem (ya da tüm bir deneme) tamamlandıktan sonra ayrı bir adım ekler: model, çıktısını nihai kabul etmeden önce eleştirmesi istenir, ve eleştiri bir sorun bulursa, durmak yerine revize edip tekrar denemesi istenir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'agent-planning-and-reasoning'
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
    ($$Bir eylem tamamlandıktan sonra ayrı bir öz-eleştiri adımı, eleştiri bir sorun bulursa çıktıyı hemen nihai kabul etmek yerine revize eder$$, TRUE, 0),
    ($$Herhangi bir eylem alınmadan önce tüm çok adımlı planı üreten bir adım$$, FALSE, 1),
    ($$Her bir bireysel eylemle, o gerçekleşirken akıl yürütme metnini iç içe geçiren bir adım$$, FALSE, 2),
    ($$Modelin nihai cevabının gerçek hatalardan tamamen arınmış olmasını garanti eden bir adım$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'agent-planning-and-reasoning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'agent-planning-and-reasoning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir hedef, bilinen bir alt-görev kümesine düzgün şekilde ayrışıyor, ve herhangi bir şey çalışmadan önce bir insanın tüm amaçlanan sırayı gözden geçirebilmesi önemli. 'Choosing Among These Patterns'a göre, bu hedef için hangi kalıp en uygun ve neden?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir hedef, bilinen bir alt-görev kümesine düzgün şekilde ayrışıyor, ve herhangi bir şey çalışmadan önce bir insanın tüm amaçlanan sırayı gözden geçirebilmesi önemli. 'Choosing Among These Patterns'a göre, bu hedef için hangi kalıp en uygun ve neden?$$,
           NULL, NULL,
           $$Ders, plan-and-execute'un, özellikle planı çalıştırmadan önce göstermenin değer kattığı durumlarda (örneğin bir insan gözden geçirme adımı için), bilinen bir alt-görev kümesine düzgün şekilde ayrışan hedeflere uygun olduğunu belirtir -- ReAct ise, doğru bir sonraki adımın gerçekten önceki adımın ne döndürdüğüne bağlı olduğu ve önceden bilinemediği hedeflere uygundur.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'agent-planning-and-reasoning'
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
    ($$Bir insanın çalışmadan önce bir planı gözden geçirmesi gerektiğinde bu kalıplardan hiçbiri kullanılamaz$$, FALSE, 0),
    ($$Plan-and-execute -- özellikle çalıştırmadan önce planı göstermenin değer kattığı durumlarda, bilinen alt-görevlere düzgün şekilde ayrışan hedeflere uygundur$$, TRUE, 1),
    ($$ReAct -- önceden bilinen bir alt-görev kümesine düzgün şekilde ayrışan hedeflere uygundur$$, FALSE, 2),
    ($$Reflection -- yürütme başlamadan önce tam bir plan üretmek için özellikle tasarlanmış kalıptır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'agent-planning-and-reasoning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'agent-planning-and-reasoning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'Termination: Knowing When to Stop'a göre, aşağıdakilerden hangisi bir agent'ın loop'unu genellikle sonlandıran üç koşuldan biridir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$'Termination: Knowing When to Stop'a göre, aşağıdakilerden hangisi bir agent'ın loop'unu genellikle sonlandıran üç koşuldan biridir?$$,
           NULL, NULL,
           $$Ders üç koşul adlandırır: modelin kendisinin hedefin karşılandığına karar vermesi (normal durum), bundan önce harici bir sınıra (örneğin maksimum adım sayısı) ulaşılması, ya da daha fazla döngünün düzeltemeyeceği kurtarılamaz bir hatanın oluşması.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'agent-planning-and-reasoning'
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
    ($$İnsan operatörün tüm uygulamayı elle sıfırdan yeniden başlatması$$, FALSE, 0),
    ($$Modelin context window'unun her tek adımdan sonra bilerek temizlenmesi$$, FALSE, 1),
    ($$Model, hedefin karşılandığı sonucuna varmadan önce, maksimum adım sayısı gibi harici bir sınıra ulaşılması$$, TRUE, 2),
    ($$Agent'ın araç listesinin çalışma sırasında programatik olarak sıfır araca indirilmesi$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'agent-planning-and-reasoning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'agent-planning-and-reasoning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Reflection, 'Hallucination: Confident, Fluent, Wrong'un tarif ettiği aynı başarısızlık moduna yöneliktir. Bu derse göre, bir reflection adımı eklemek bu riski tamamen ortadan kaldırır mı?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Reflection, 'Hallucination: Confident, Fluent, Wrong'un tarif ettiği aynı başarısızlık moduna yöneliktir. Bu derse göre, bir reflection adımı eklemek bu riski tamamen ortadan kaldırır mı?$$,
           NULL, NULL,
           $$Ders açıkça reflection'ın bu riski ortadan kaldırmadığını belirtir -- kontrolü yapan aynı model, cevabı üreten modelle aynı kısıtlara sahiptir, ancak yine de özel bir eleştiri adımı, aksi takdirde kontrolsüz geçecek bazı hata sınıflarını yakalar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'agent-planning-and-reasoning'
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
    ($$Evet -- reflection her durumda tamamen hallucination'dan arınmış bir nihai cevabı garanti eder$$, FALSE, 0),
    ($$Evet, ama yalnızca CODE_OUTPUT tarzı görevler için, metin tabanlı cevaplar için asla değil$$, FALSE, 1),
    ($$Hayır -- reflection, hiçbir durumda hallucination riski üzerinde hiçbir etkiye sahip değildir$$, FALSE, 2),
    ($$Hayır -- kontrolü yapan aynı model, cevabı üreten modelle aynı kısıtlara sahiptir, ama yine de bazı hataları yakalar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'agent-planning-and-reasoning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'agent-planning-and-reasoning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, agent planlama ve akıl yürütme kalıpları hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, agent planlama ve akıl yürütme kalıpları hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (bu kalıpların birbirini dışlamadığı ve çoğu gerçek agent'ın birden fazlasının parçalarını birleştirdiği, özellikle reflection'ın genellikle bir alternatif değil bir ek olduğu; ve modelin kendi yargısı dışında hiçbir sonlanma koşulu olmayan bir karar fonksiyonunun aksi takdirde sonsuza kadar döneceği, bu yüzden bir step-limit güvencesinin bir yedek olarak önemli olduğu); ReAct, her tek adımda yeniden planlama yapıyor olarak açıkça tarif edilir, ders bunu daha geniş bir planı önceden taahhüt etmekten daha az verimli OLABİLECEĞİ şeklinde niteler (daha verimli değil), ve reflection, ReAct ya da plan-and-execute'un yerini almak için değil, ikisine de eklenebilen bir şey olarak çerçevelenir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'agent-planning-and-reasoning'
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
    ($$ReAct, plan-and-execute ve reflection birbirini dışlamaz -- çoğu gerçek agent birden fazlasının parçalarını birleştirir, reflection genellikle bir ek olur$$, TRUE, 0),
    ($$Modelin kendi yargısı dışında hiçbir sonlanma koşulu olmayan bir karar fonksiyonu aksi takdirde sonsuza kadar döner, bu yüzden bir step-limit güvencesi bir yedek olarak önemlidir$$, TRUE, 1),
    ($$ReAct'in her adımda yeniden planlama yapması, bu derste daha geniş bir planı önceden taahhüt etmekten kesinlikle daha verimli olarak tarif edilir$$, FALSE, 2),
    ($$Reflection, ReAct ya da plan-and-execute'un yerini tamamen almak için tasarlanmıştır, ikisine eklenmek için değil$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'agent-planning-and-reasoning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
