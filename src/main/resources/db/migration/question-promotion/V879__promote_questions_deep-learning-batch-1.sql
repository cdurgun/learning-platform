-- Promotion batch
-- Topic: deep-learning (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project (React/Java/
-- Spring/Postgres/Git categories), these 14 questions were hand-authored
-- and independently self-reviewed directly inside a Claude Code session,
-- grounded strictly in content/en/deep-learning.md and content/tr/deep-learning.md --
-- NOT produced by the n8n generation pipeline, NOT judged by the AI Judge,
-- and NOT ingested via /api/internal/questions/ingest.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different framing/options), not a translation.
-- Every question whose answer depends on shown code is typed CODE_OUTPUT
-- (never SINGLE_CHOICE/MULTIPLE_CHOICE with a code_snippet attached) --
-- fragments/quiz.html only renders code_snippet for CODE_OUTPUT questions,
-- per the bug found and fixed in try-catch-finally/V573.
--
-- Each question's 4 options are written with the correct answer at a
-- deterministic, varied position, computed via
-- (pair_num + version + lang_shift) % 4 -- per the bug found and fixed at
-- question-promotion/V598 (always-A bias) and refined again in the Spring
-- Data JPA batch (parity-locked EN/TR offsets).
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly -- same documentation convention as every prior
-- manual batch. topic_id resolved by Topic.slug; question_option rows
-- reference the newly generated id via a WITH ... RETURNING id CTE.
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
           $$What does the word "deep" refer to in "Deep Learning"?$$,
           NULL, NULL,
           $$"Deep" refers to the neural network architecture having many stacked hidden layers; it has nothing to do with the philosophical depth of output, training duration, or how much math knowledge a user needs.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'deep-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The neural networks used have many stacked hidden layers$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$The models produce deeply philosophical output$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$The training process takes an extremely long time$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$The models require deep knowledge of mathematics to use$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$'Deep Learning' ifadesindeki 'deep' (derin) kelimesi neyi ifade eder?$$,
           NULL, NULL,
           $$'Derin', sinir ağı mimarisinin birçok üst üste yığılmış gizli katmana sahip olmasını ifade eder; çıktının felsefi derinliğiyle, eğitim süresiyle ya da kullanıcının matematik bilgisiyle bir ilgisi yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'deep-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Eğitim sürecinin son derece uzun sürmesini$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Modelleri kullanmak için derin matematik bilgisi gerektirmesini$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Kullanılan sinir ağlarının birçok üst üste yığılmış gizli katmana sahip olmasını$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Modellerin felsefi açıdan derin çıktılar üretmesini$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A node receives inputs x1=2 and x2=1, with weights w1=3 and w2=-1 (bias=0), and uses a ReLU activation function (ReLU(x) = max(0, x)). What is the node's output?$$,
           $$weighted_sum = (x1 * w1) + (x2 * w2) + bias
             = (2 * 3) + (1 * -1) + 0
             = 6 - 1
             = 5
output = ReLU(weighted_sum)$$, $$text$$,
           $$The weighted sum is (2*3)+(1*-1)+0 = 5; ReLU(5) = max(0, 5) = 5, since 5 is already positive it passes through unchanged -- the other options misapply ReLU or the arithmetic.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'deep-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$6, since ReLU rounds up to the nearest input value$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$5, since ReLU passes through positive weighted sums unchanged$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$0, because ReLU always outputs 0 for positive inputs$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$-1, since the negative weight w2 dominates$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir node, x1=2 ve x2=1 girdilerini, w1=3 ve w2=-1 ağırlıklarını (bias=0) alıyor ve ReLU aktivasyon fonksiyonunu (ReLU(x) = max(0, x)) kullanıyor. Node'un çıktısı nedir?$$,
           $$agirlikli_toplam = (x1 * w1) + (x2 * w2) + bias
                  = (2 * 3) + (1 * -1) + 0
                  = 6 - 1
                  = 5
cikti = ReLU(agirlikli_toplam)$$, $$text$$,
           $$Ağırlıklı toplam (2*3)+(1*-1)+0 = 5'tir; ReLU(5) = max(0, 5) = 5, çünkü 5 zaten pozitiftir ve değiştirilmeden geçer -- diğer seçenekler ReLU'yu ya da aritmetiği yanlış uyguluyor.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'deep-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$0, çünkü ReLU pozitif girdiler için her zaman 0 döndürür$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$-1, çünkü negatif ağırlık w2 baskın gelir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$6, çünkü ReLU en yakın girdi değerine yukarı yuvarlar$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$5, çünkü ReLU pozitif ağırlıklı toplamları değiştirmeden geçirir$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$During training, a neural network makes a prediction, compares it to the correct answer, and then adjusts its weights slightly to reduce future error. Which two mechanisms, working together, make this weight adjustment possible?$$,
           NULL, NULL,
           $$A loss function measures the error, backpropagation computes how each weight contributed to that error, and gradient descent uses that information to adjust weights and reduce error -- this is the mechanism pair; the other pairs name unrelated concepts (tokenization/attention belong to LLMs, overfitting/underfitting are ML evaluation issues, not training mechanisms).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'deep-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tokenization and attention$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Overfitting and underfitting$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Backpropagation and gradient descent$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Forward pass and inference$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Eğitim sırasında bir sinir ağı bir tahmin yapar, bunu doğru cevapla karşılaştırır ve gelecekteki hatayı azaltmak için ağırlıklarını hafifçe ayarlar. Bu ağırlık ayarlamasını mümkün kılan, birlikte çalışan iki mekanizma hangileridir?$$,
           NULL, NULL,
           $$Bir loss function hatayı ölçer, backpropagation her ağırlığın bu hataya ne kadar katkıda bulunduğunu hesaplar ve gradient descent bu bilgiyi kullanarak ağırlıkları hatayı azaltacak şekilde ayarlar -- mekanizma çifti budur; diğer çiftler ilgisiz kavramları adlandırır (tokenization/attention LLM'lere aittir, overfitting/underfitting ise eğitim mekanizması değil ML değerlendirme konularıdır).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'deep-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Backpropagation ve gradient descent$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Forward pass ve inference$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Tokenization ve attention$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Overfitting ve underfitting$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which type of neural network is specifically well-suited to processing images, according to this lesson?$$,
           NULL, NULL,
           $$The lesson specifically names CNN (Convolutional Neural Network) for images; RNN is described for sequential data instead, Transformer is discussed as the basis for text/LLMs via attention (not specifically for images), and "all types handle images equally well" contradicts the lesson's explicit type distinctions.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'deep-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$RNN (Recurrent Neural Network)$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Transformer only$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$None -- all neural network types handle images equally well$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$CNN (Convolutional Neural Network)$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, hangi sinir ağı türü özellikle görüntüleri işlemek için uygundur?$$,
           NULL, NULL,
           $$Ders özellikle görüntüler için CNN'i (Convolutional Neural Network) adlandırır; RNN sıralı veri için tarif edilmiştir, Transformer ise attention aracılığıyla metin/LLM'lerin temeli olarak ele alınır (özellikle görüntüler için değil), ve 'tüm türler görüntüleri eşit iyi işler' ifadesi dersin açık tür ayrımlarıyla çelişir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'deep-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbiri -- tüm sinir ağı türleri görüntüleri eşit derecede iyi işler$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$CNN (Convolutional Neural Network)$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$RNN (Recurrent Neural Network)$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca Transformer$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$RNNs process sequences one step at a time, while Transformers can process an entire sequence in parallel using attention. What is the main practical consequence of this difference, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states Transformers are parallelizable (unlike step-by-step RNNs) and this is part of why they became the basis of virtually every modern LLM; RNN is described as superseded, not more accurate, and RNN's domain is sequential data, not images.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'deep-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Transformers are more parallelizable, which is part of why they became the basis of virtually every modern LLM$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$RNNs are always more accurate than Transformers regardless of task$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$There is no meaningful practical difference between the two architectures$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$RNNs are used exclusively for image processing$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$RNN'ler bir diziyi adım adım işlerken, Transformer'lar attention kullanarak tüm diziyi paralel olarak işleyebilir. Bu derse göre, bu farkın temel pratik sonucu nedir?$$,
           NULL, NULL,
           $$Ders, Transformer'ların paralelleştirilebilir olduğunu (adım adım işleyen RNN'lerin aksine) ve bunun neredeyse her modern LLM'nin temelini oluşturmalarının bir nedeni olduğunu belirtir; RNN daha doğru değil, aşılmış (superseded) olarak tarif edilir ve RNN'nin alanı görüntüler değil sıralı verilerdir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'deep-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İki mimari arasında pratik açıdan anlamlı bir fark yoktur$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$RNN'ler yalnızca görüntü işleme için kullanılır$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Transformer'lar daha paralelleştirilebilirdir, bu da neredeyse her modern LLM'nin temelini oluşturmalarının bir nedenidir$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$RNN'ler görevden bağımsız olarak her zaman Transformer'lardan daha doğrudur$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what mainly explains why deep learning's major breakthroughs happened around 2012 rather than decades earlier, even though neural networks were already known?$$,
           NULL, NULL,
           $$The lesson attributes the ~2012 turning point to sufficiently large datasets and sufficiently powerful GPU compute both reaching necessary scale around the same time; neural networks predate 2012, no such research ban existed, and ReLU computability wasn't a historical barrier.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'deep-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ReLU activation functions were mathematically impossible to compute before 2012$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Both sufficiently large datasets and sufficiently powerful GPU compute reached the scale needed at around the same time$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Neural networks were only invented in 2012$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Governments banned neural network research until 2012$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, sinir ağları zaten biliniyor olmasına rağmen, deep learning'in büyük atılımlarının onlarca yıl önce değil de neden yaklaşık 2012'de gerçekleştiğini asıl açıklayan nedir?$$,
           NULL, NULL,
           $$Ders, ~2012 dönüm noktasını hem yeterince büyük veri kümelerinin hem de yeterince güçlü GPU işlem gücünün aşağı yukarı aynı dönemde gereken ölçeğe ulaşmasına bağlar; sinir ağları 2012'den çok önce vardı, böyle bir araştırma yasağı hiç olmadı ve ReLU'nun hesaplanabilirliği tarihsel bir engel değildi.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'deep-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sinir ağları ancak 2012'de icat edildi$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Hükümetler 2012'ye kadar sinir ağı araştırmalarını yasakladı$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$ReLU aktivasyon fonksiyonları 2012'den önce matematiksel olarak hesaplanamıyordu$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Hem yeterince büyük veri kümeleri hem de yeterince güçlü GPU işlem gücü, aşağı yukarı aynı dönemde gereken ölçeğe ulaştı$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about deep learning and neural networks, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B match the lesson directly (node computation mechanics; Transformer/2017/attention as the basis of virtually every LLM); RNN is described as superseded, not as the current recommended state-of-the-art, and the progressive-abstraction idea (edge to concept across layers) is explicitly flagged in the lesson as intuitive, not a mathematically guaranteed property.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'deep-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$RNNs are the current state-of-the-art architecture recommended for all new sequential-data projects$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Deeper layers in a network are guaranteed, by mathematical proof, to always represent higher-level abstractions like "concept" versus "edge"$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$A node's output is computed from a weighted sum of its inputs plus a bias, passed through an activation function$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$The Transformer architecture, introduced in 2017 and based on attention, underlies virtually every modern LLM$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, deep learning ve sinir ağları hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derse doğrudan uyar (node hesaplama mekaniği; 2017'de tanıtılan, attention tabanlı Transformer'ın neredeyse her LLM'nin temeli olması); RNN, güncel önerilen state-of-the-art değil, aşılmış (superseded) olarak tarif edilir, ve katmanlar arası kademeli soyutlama fikri (kenardan kavrama) derste açıkça sezgisel olarak işaretlenmiştir, matematiksel olarak garanti edilmiş bir özellik değil.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'deep-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir node'un çıktısı, girdilerinin ağırlıklı toplamına bias eklenip bir aktivasyon fonksiyonundan geçirilmesiyle hesaplanır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$2017'de tanıtılan ve attention'a dayanan Transformer mimarisi, neredeyse her modern LLM'nin temelini oluşturur$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$RNN'ler, tüm yeni sıralı-veri projeleri için önerilen güncel state-of-the-art mimaridir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir ağdaki daha derin katmanların, 'kenar'a karşı 'kavram' gibi her zaman daha yüksek seviyeli soyutlamaları temsil ettiği matematiksel olarak kanıtlanmıştır$$, FALSE, 3 FROM new_question_tr7;
