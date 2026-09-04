-- Promotion batch
-- Topic: what-is-ai (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project (React/Java/
-- Spring/Postgres/Git categories), these 14 questions were hand-authored
-- and independently self-reviewed directly inside a Claude Code session,
-- grounded strictly in content/en/what-is-ai.md and content/tr/what-is-ai.md --
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
           $$What fundamentally distinguishes AI software from traditional, explicitly-programmed software?$$,
           NULL, NULL,
           $$AI systems learn patterns from data (training) rather than executing only rules a programmer explicitly wrote for every case; speed, hardware, and "no code" claims are unrelated to the actual distinction.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$AI systems learn patterns from data rather than following only explicitly written rules$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$AI software runs faster than traditional software in every case$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$AI software never requires any code to be written$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Traditional software can only run on specialized hardware$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Yapay zeka yazılımını, geleneksel, kuralları açıkça programlanmış yazılımdan temelde ayıran nedir?$$,
           NULL, NULL,
           $$Yapay zeka sistemleri, yalnızca açıkça yazılmış kuralları izlemek yerine verilerden (training) örüntüler öğrenir; hız, donanım ve "kod gerekmez" iddiaları gerçek ayrımla ilgisizdir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yapay zeka yazılımı hiçbir kod yazılmasını gerektirmez$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Geleneksel yazılım yalnızca özel donanımlarda çalışabilir$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Yapay zeka sistemleri, yalnızca açıkça yazılmış kuralları izlemek yerine verilerden örüntüler öğrenir$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Yapay zeka sistemleri her durumda geleneksel yazılımdan daha hızlı çalışır$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Nearly all AI systems in production today, including LLMs, fall into which category?$$,
           NULL, NULL,
           $$Narrow AI performs well at specific tasks; AGI (human-level general intelligence across any domain) does not exist in deployed systems today; passing the Turing Test in every conversation and general cross-domain reasoning are not what current systems achieve.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Systems with human-level reasoning across every domain$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Narrow AI -- systems designed to perform a specific task or set of tasks well$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Artificial General Intelligence (AGI)$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Systems that pass the Turing Test in every conversation$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Günümüzde üretimde çalışan neredeyse tüm yapay zeka sistemleri (LLM'ler dahil) hangi kategoriye girer?$$,
           NULL, NULL,
           $$Dar (Narrow) yapay zeka belirli görevlerde iyi performans gösterir; AGI (herhangi bir alanda insan düzeyinde genel zeka) bugün dağıtılmış sistemlerde mevcut değildir; her konuşmada Turing Testi'ni geçmek ya da her alanda akıl yürütmek günümüz sistemlerinin ulaştığı bir şey değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Genel Yapay Zeka (AGI)$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Her konuşmada Turing Testi'ni geçen sistemler$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Her alanda insan düzeyinde akıl yürütebilen sistemler$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Dar (Narrow) Yapay Zeka -- belirli bir görevi veya görev kümesini iyi yapmak için tasarlanmış sistemler$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A team says "our product uses AI" and separately "our product uses machine learning." Based on how these terms relate, which statement is most accurate?$$,
           NULL, NULL,
           $$Machine Learning is one approach within the broader field of AI (AI contains ML, which contains Deep Learning, which contains Generative AI) -- the two terms are not unrelated, not reversed, and not simply identical.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$AI is a subset of Machine Learning$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$The two terms always mean exactly the same technology with no distinction$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Machine Learning is a subset of AI -- one common approach to building AI, not a separate field$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$AI and ML are unrelated, competing approaches$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir ekip 'ürünümüz yapay zeka kullanıyor' ve ayrıca 'ürünümüz machine learning kullanıyor' diyor. Bu terimlerin ilişkisine göre hangi ifade en doğrudur?$$,
           NULL, NULL,
           $$Machine Learning, yapay zekanın daha geniş alanının içindeki bir yaklaşımdır (Yapay Zeka, ML'i içerir; ML, Deep Learning'i içerir; Deep Learning de Generative AI'ı içerir) -- iki terim ne ilgisizdir, ne tersine çevrilebilir, ne de birebir aynıdır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Machine Learning, yapay zekanın bir alt kümesidir -- yapay zeka inşa etmenin yaygın bir yoludur, ayrı bir alan değildir$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Yapay zeka ve Machine Learning birbiriyle ilgisiz, rakip yaklaşımlardır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Yapay zeka, Machine Learning'in bir alt kümesidir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Bu iki terim her zaman birbirinin birebir aynısı anlamına gelir, hiçbir ayrım yoktur$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What historically caused an "AI winter"?$$,
           NULL, NULL,
           $$AI winters were periods of declining funding/interest following unmet, inflated expectations; the other options are fabricated, or describe the opposite period -- the years after 2012 were an acceleration driven by deep learning, not a winter.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A season during which AI conferences are traditionally held$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$A government ban on all AI research$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$The period after 2012 when deep learning breakthroughs accelerated AI progress$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$A period when AI research funding and interest sharply declined after inflated expectations failed to materialize$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$'Yapay zeka kışı' (AI winter) tarihsel olarak neden yaşandı?$$,
           NULL, NULL,
           $$Yapay zeka kışları, şişirilmiş beklentiler gerçekleşmeyince araştırma finansmanı ve ilgisinin azaldığı dönemlerdi; diğer seçenekler uydurma ya da tam tersini anlatıyor -- 2012 sonrası dönem deep learning ile hızlanan bir ilerlemeydi, bir kış değil.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$2012 sonrası deep learning atılımlarının yapay zeka ilerlemesini hızlandırdığı dönem$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Şişirilmiş beklentiler gerçekleşmeyince yapay zeka araştırma finansmanı ve ilgisinin keskin biçimde azaldığı bir dönem$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Yapay zeka konferanslarının geleneksel olarak düzenlendiği bir mevsim$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Hükümetlerin tüm yapay zeka araştırmalarını yasakladığı bir dönem$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A spam filter that flags an email as spam based on patterns learned from millions of previously labeled emails, rather than a fixed list of banned words, is best described as:$$,
           NULL, NULL,
           $$Learning patterns from labeled data is AI; classification is a discriminative task (predicting a label for existing input), not a generative one, so producing a label for each email doesn't make it "generative AI," and learning from data clearly isn't "no AI at all."$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$An AI system, since it learned to recognize spam patterns from data rather than only following fixed rules$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$A rule-based system with no learning involved$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Not AI, because it doesn't generate any new content$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Generative AI, because it produces an output for each email$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Sabit bir yasaklı kelime listesi yerine, milyonlarca önceden etiketlenmiş e-postadan öğrenilen örüntülere dayanarak bir e-postayı spam olarak işaretleyen bir filtre en iyi nasıl tanımlanır?$$,
           NULL, NULL,
           $$Etiketlenmiş veriden örüntü öğrenmek yapay zekadır; sınıflandırma, var olan bir girdi için etiket tahmin eden discriminative bir görevdir, generative değildir -- bu yüzden her e-posta için bir çıktı üretmesi onu 'generative AI' yapmaz, veriden öğrenmesi de onu 'yapay zeka değil' yapmaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yapay zeka değildir, çünkü herhangi bir yeni içerik üretmez$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Generative AI'dır, çünkü her e-posta için bir çıktı üretir$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir yapay zeka sistemi, çünkü spam örüntülerini yalnızca sabit kurallar izlemek yerine verilerden öğrenmiştir$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Öğrenme içermeyen, kurala dayalı bir sistem$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given the nested relationship AI contains ML, ML contains Deep Learning, and Deep Learning contains Generative AI, which statement correctly places a spam classifier trained with a neural network but NOT trained to generate new content?$$,
           NULL, NULL,
           $$A neural-network-based classifier sits in the Deep Learning layer (which is inside ML, inside AI) but doesn't belong to Generative AI since it classifies rather than creates new content; the other options misplace the nesting relationship.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It is ML but not AI$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It is Deep Learning (and therefore ML and AI), but not Generative AI, since it classifies rather than creates new content$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It is Generative AI but not Deep Learning$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It is AI but not ML, since neural networks aren't a machine learning technique$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Yapay Zeka, ML'i; ML, Deep Learning'i; Deep Learning de Generative AI'ı içeren iç içe ilişki göz önüne alındığında, bir sinir ağıyla eğitilmiş ama yeni içerik üretmek için eğitilmemiş bir spam sınıflandırıcısını hangi ifade doğru şekilde konumlandırır?$$,
           NULL, NULL,
           $$Sinir ağı tabanlı bir sınıflandırıcı Deep Learning katmanına aittir (ki bu da ML'in, o da yapay zekanın içindedir) ama yeni içerik üretmek yerine sınıflandırma yaptığı için Generative AI'a ait değildir; diğer seçenekler iç içe ilişkiyi yanlış yerleştiriyor.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Generative AI'dır ama Deep Learning değildir$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Yapay zekadır ama ML değildir, çünkü sinir ağları bir machine learning tekniği değildir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$ML'dir ama yapay zeka değildir$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Deep Learning'dir (dolayısıyla ML ve yapay zekadır da), ama Generative AI değildir, çünkü yeni içerik üretmek yerine sınıflandırma yapar$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about AI, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are correct per the lesson (narrow AI dominance today, and the nested AI/ML/DL/GenAI relationship); the Turing Test is a thought experiment/informal benchmark, not a mathematical proof; AI as a field dates back to 1956 (the Dartmouth workshop), long before LLMs existed.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The Turing Test is a formal, universally accepted mathematical proof that a system is intelligent$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$AI has existed as a field only since the 2020s, starting with LLMs$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$All production AI today is narrow AI; AGI does not currently exist in deployed systems$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Machine Learning, Deep Learning, and Generative AI are nested inside the broader field of AI, not separate unrelated fields$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, yapay zeka hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derse göre doğrudur (günümüzde dar yapay zeka baskınlığı, ve AI/ML/DL/GenAI iç içe ilişkisi); Turing Testi resmi bir matematiksel ispat değil, bir düşünce deneyi/resmi olmayan bir kıstastır; yapay zeka bir alan olarak LLM'lerden çok önce, 1956'daki Dartmouth çalıştayına kadar uzanır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Günümüzde üretimdeki tüm yapay zeka dar (narrow) yapay zekadır; AGI şu an dağıtılmış sistemlerde mevcut değildir$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Machine Learning, Deep Learning ve Generative AI, yapay zekanın daha geniş alanı içine iç içe yerleşmiştir, ayrı ve ilgisiz alanlar değildir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Turing Testi, bir sistemin zeki olduğunu kanıtlayan resmi, evrensel kabul görmüş matematiksel bir ispattır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Yapay zeka bir alan olarak yalnızca 2020'lerden, LLM'lerle birlikte var olmaya başlamıştır$$, FALSE, 3 FROM new_question_tr7;
