-- Promotion-style migration linking TR sharing-state quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sharing-state')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$query state'i AramaKutusu'nun içinde yaşıyorsa, SonucListesi (bir sibling component) ona doğrudan erişebilir mi?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$query state'i AramaKutusu'nun içinde yaşıyorsa, SonucListesi (bir sibling component) ona doğrudan erişebilir mi?$$,
           NULL, NULL,
           $$SonucListesi'nin AramaKutusu'nun state'ine erişmesinin bir yolu yoktur -- her component'in kendi state'i onun içine hapsolmuştur; sibling component'ler birbirinin state'ini doğrudan göremez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sharing-state'
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
    ($$Yalnızca SonucListesi, JSX'te AramaKutusu'ndan önce render edilirse$$, FALSE, 0),
    ($$Hayır -- her component'in kendi state'i onun içine hapsolmuştur; sibling'ler birbirinin state'ini doğrudan göremez$$, TRUE, 1),
    ($$Evet -- bir React uygulamasındaki tüm state, her component arasında otomatik olarak paylaşılır$$, FALSE, 2),
    ($$Evet, ama yalnızca iki component de aynı dosyada tanımlanmışsa$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sharing-state'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sharing-state')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$"Lifting state up" (state'i yukarı taşıma) nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$"Lifting state up" (state'i yukarı taşıma) nedir?$$,
           NULL, NULL,
           $$Çözüm, state'i her iki component'in de ortak atası olan bir yere taşımaktır -- bu kalıba lifting state up denir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sharing-state'
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
    ($$State'i tamamen silip sabit-kodlanmış değerlerle değiştirmek$$, FALSE, 0),
    ($$Aynı state'i, ona ihtiyaç duyan her component'e bağımsız olarak kopyalamak$$, FALSE, 1),
    ($$Birden fazla component tarafından paylaşılan state'i onların ortak atasına taşımak$$, TRUE, 2),
    ($$Bir component'in state'ini global, tarayıcı seviyesinde bir değişkene taşımak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sharing-state'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sharing-state')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$State yukarı taşındıktan sonra, AramaKutusu prop olarak neyi alır, SonucListesi neyi alır?$$
      AND code_snippet = $$function AramaSayfasi() {
    const [sorgu, sorguAyarla] = useState("");
    return (
        <div>
            <AramaKutusu sorgu={sorgu} sorguDegisti={sorguAyarla} />
            <SonucListesi sorgu={sorgu} />
        </div>
    );
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$State yukarı taşındıktan sonra, AramaKutusu prop olarak neyi alır, SonucListesi neyi alır?$$,
           $$function AramaSayfasi() {
    const [sorgu, sorguAyarla] = useState("");
    return (
        <div>
            <AramaKutusu sorgu={sorgu} sorguDegisti={sorguAyarla} />
            <SonucListesi sorgu={sorgu} />
        </div>
    );
}$$, $$jsx$$,
           $$AramaKutusu, sorgu ve sorguDegisti'yi (sorguAyarla) alır; SonucListesi yalnızca sorgu'yu alır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sharing-state'
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
    ($$Her iki component de sorguDegisti dahil tam olarak aynı prop kümesini alır$$, FALSE, 0),
    ($$AramaKutusu hiçbir şey almaz; yalnızca SonucListesi sorgu'yu alır$$, FALSE, 1),
    ($$SonucListesi sorguDegisti'yi alır, AramaKutusu ise yalnızca sorgu'yu alır$$, FALSE, 2),
    ($$AramaKutusu, sorgu ve sorguDegisti'yi alır; SonucListesi yalnızca sorgu'yu alır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sharing-state'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sharing-state')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, lifting state up yalnızca bir listeyi filtrelemekle mi sınırlıdır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, lifting state up yalnızca bir listeyi filtrelemekle mi sınırlıdır?$$,
           NULL, NULL,
           $$Lifting state up, bir listeyi filtrelemekle sınırlı değildir -- aynı zamanda, bir slider ve bir metin gösterimi aynı rating değerini paylaşması gibi, AYNI değeri İKİ FARKLI şekilde gösteren component'lere de uygulanır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sharing-state'
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
    ($$Hayır -- aynı zamanda, bir slider ve bir metin gösterimi gibi, aynı değeri iki farklı şekilde gösteren component'lere de uygulanır$$, TRUE, 0),
    ($$Evet -- yalnızca arama/filtreleme senaryoları için kullanılabilir$$, FALSE, 1),
    ($$Evet, ve ayrıca iki component'in görsel olarak özdeş olmasını gerektirir$$, FALSE, 2),
    ($$Hayır -- yalnızca en az üç sibling component söz konusu olduğunda geçerlidir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sharing-state'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sharing-state')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$"Props drilling" nedir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Props drilling" nedir?$$,
           NULL, NULL,
           $$Props drilling, bir prop'u, onu kendisi kullanmayan ara katman component'ler aracılığıyla geçirmeye zorlanmaktır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sharing-state'
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
    ($$Aynı prop adını, kazara, iki ilgisiz component'te kullanmak$$, FALSE, 0),
    ($$Bir prop'u, onu kendisi kullanmayan ara katman component'ler aracılığıyla geçirmeye zorlanmak$$, TRUE, 1),
    ($$Bir component'in state'inden, hiç kod yazmadan otomatik olarak prop üretmek$$, FALSE, 2),
    ($$Gerekli bir prop eksik olduğunda React'in fırlattığı bir hata$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sharing-state'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sharing-state')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$SonucPaneli, sorgu prop'unu gerçekten kendisi mi kullanıyor, yoksa yalnızca aktarıyor mu?$$
      AND code_snippet = $$function SonucPaneli({ sorgu }) {
    return <SonucListesi sorgu={sorgu} />;
}
// SonucPaneli'nin kendi JSX'i sorgu'yu hicbir zaman dogrudan okumaz$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$SonucPaneli, sorgu prop'unu gerçekten kendisi mi kullanıyor, yoksa yalnızca aktarıyor mu?$$,
           $$function SonucPaneli({ sorgu }) {
    return <SonucListesi sorgu={sorgu} />;
}
// SonucPaneli'nin kendi JSX'i sorgu'yu hicbir zaman dogrudan okumaz$$, $$jsx$$,
           $$SonucPaneli, sorgu'yu KENDİSİ hiç kullanmaz -- onu yalnızca SonucListesi'ne aktarmak için kabul eder; bu, props drilling sorunudur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sharing-state'
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
    ($$SonucPaneli, sorgu'yu tamamen yok sayar ve sessizce atılır$$, FALSE, 0),
    ($$SonucPaneli, sorgu'yu daha aşağıya geçirmeden önce state'e dönüştürür$$, FALSE, 1),
    ($$SonucPaneli, sorgu'yu kendisi kullanmadan, yalnızca SonucListesi'ne aktarmak için kabul eder$$, TRUE, 2),
    ($$SonucPaneli, kendi render edilen içeriğini filtrelemek için sorgu'yu doğrudan kullanır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sharing-state'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sharing-state')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, ağaç derinleştikçe props drilling'in nasıl büyüdüğünü aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, ağaç derinleştikçe props drilling'in nasıl büyüdüğünü aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Level1, Level2, Level3'ün hiçbiri user'ı kullanmaz -- yalnızca aktarırlar; yalnızca en altta olan Level4 gerçekten kullanır. Her yeni seviye ya da her yeni paylaşılan değer, bu zinciri daha da uzatır, kodu yazması sıkıcı ve değiştirmesi kırılgan hale getirir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sharing-state'
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
    ($$Derin bir zincirdeki ara seviyeler, bir prop'u kendileri hiç kullanmadan aktarabilir$$, TRUE, 0),
    ($$Her yeni seviye ya da her yeni paylaşılan değer, aktarma zincirini daha da uzatır$$, TRUE, 1),
    ($$Component ağacı derinleştikçe bu sorun büyümez, küçülür$$, FALSE, 2),
    ($$Zincirdeki yalnızca ilk component'in değeri gerçekten kullanmasına izin verilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sharing-state'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
