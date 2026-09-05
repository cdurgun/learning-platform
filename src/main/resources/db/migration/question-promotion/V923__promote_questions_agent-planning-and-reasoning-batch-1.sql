-- Promotion batch
-- Topic: agent-planning-and-reasoning (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these 14
-- questions were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/agent-planning-and-reasoning.md
-- and content/tr/agent-planning-and-reasoning.md -- NOT produced by n8n, NOT judged by any
-- external AI API, and NOT ingested via /api/internal/questions/ingest.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different framing/options/examples), not a
-- translation. Every question whose answer depends on shown code is typed
-- CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a code_snippet
-- attached) -- fragments/quiz.html only renders code_snippet for
-- CODE_OUTPUT questions, per the bug found and fixed in
-- try-catch-finally/V573.
--
-- Each question's 4 options are written with the correct answer at a
-- deterministic, varied position, computed via
-- (pair_num + version + lang_shift) % 4 -- per the bug found and fixed at
-- question-promotion/V598 (always-A bias) and refined again in the Spring
-- Data JPA batch (parity-locked EN/TR offsets).
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly. topic_id resolved by Topic.slug; question_option
-- rows reference the newly generated id via a WITH ... RETURNING id CTE.
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
           $$What does the ReAct pattern do at each step, according to this lesson?$$,
           NULL, NULL,
           $$ReAct interleaves a visible reasoning step with each action -- before choosing a tool call, the model first produces a short piece of text explaining its reasoning, and only then emits the action; the next observation is fed back in, and the cycle repeats.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'agent-planning-and-reasoning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It interleaves a visible reasoning step with each action -- the model explains its reasoning in text before emitting the action itself$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It produces a complete, multi-step plan before taking any action at all$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It critiques a completed output after the fact, before treating it as final$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It skips reasoning entirely and jumps straight to the final answer every time$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, ReAct kalıbı her adımda ne yapar?$$,
           NULL, NULL,
           $$ReAct, her eylemle görünür bir akıl yürütme adımını iç içe geçirir -- bir tool call seçmeden önce model önce akıl yürütmesini açıklayan kısa bir metin üretir, ve ancak ondan sonra eylemin kendisini üretir; bir sonraki gözlem geri beslenir, ve döngü tekrarlanır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'agent-planning-and-reasoning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tamamlanmış bir çıktıyı, nihai kabul etmeden önce sonradan eleştirir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Akıl yürütmeyi tamamen atlar ve her seferinde doğrudan nihai cevaba geçer$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Her eylemle görünür bir akıl yürütme adımını iç içe geçirir -- model, eylemin kendisini üretmeden önce metin içinde akıl yürütmesini açıklar$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Herhangi bir eylem almadan önce tam, çok adımlı bir plan üretir$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does plan-and-execute do differently from ReAct, according to this lesson?$$,
           NULL, NULL,
           $$Plan-and-execute splits the loop into two distinct phases instead of interleaving them: first, given the goal, the model produces a multi-step plan up front, before taking any action; then an execution step works through that plan one step at a time.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'agent-planning-and-reasoning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It never revises a plan under any circumstances, even if a step's result invalidates it$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It produces a full multi-step plan up front, before taking any action, then executes that plan step by step$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It interleaves a visible reasoning step with every single action, exactly the way ReAct does$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It critiques the agent's own output after it's already been produced$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, plan-and-execute ReAct'ten farklı olarak ne yapar?$$,
           NULL, NULL,
           $$Plan-and-execute, loop'u iç içe geçirmek yerine iki ayrı aşamaya böler: önce, hedef verildiğinde, model herhangi bir eylem almadan önce çok adımlı bir plan üretir; sonra bir yürütme adımı bu planı adım adım işler.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'agent-planning-and-reasoning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tıpkı ReAct'in yaptığı gibi, her tek eylemle görünür bir akıl yürütme adımını iç içe geçirir$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Agent'ın kendi çıktısını, zaten üretildikten sonra eleştirir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir adımın sonucu planı geçersiz kılsa bile hiçbir koşulda planı asla revize etmez$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Herhangi bir eylem almadan önce tam, çok adımlı bir plan üretir, sonra bu planı adım adım yürütür$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does the reflection pattern add to an agent's loop, according to this lesson?$$,
           NULL, NULL,
           $$Reflection adds a distinct step after an action (or a whole attempt) completes: the model is asked to critique its own output before treating it as final, and if the critique finds a problem, to revise and try again rather than stopping.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'agent-planning-and-reasoning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A step that interleaves reasoning text with each individual action as it happens$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$A step that guarantees the model's final answer is completely free of factual errors$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$A distinct self-critique step after an action completes, revising the output if the critique finds a problem, rather than immediately treating it as final$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$A step that produces the entire multi-step plan before any action is taken$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, reflection kalıbı bir agent'ın loop'una ne ekler?$$,
           NULL, NULL,
           $$Reflection, bir eylem (ya da tüm bir deneme) tamamlandıktan sonra ayrı bir adım ekler: model, çıktısını nihai kabul etmeden önce eleştirmesi istenir, ve eleştiri bir sorun bulursa, durmak yerine revize edip tekrar denemesi istenir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'agent-planning-and-reasoning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir eylem tamamlandıktan sonra ayrı bir öz-eleştiri adımı, eleştiri bir sorun bulursa çıktıyı hemen nihai kabul etmek yerine revize eder$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Herhangi bir eylem alınmadan önce tüm çok adımlı planı üreten bir adım$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Her bir bireysel eylemle, o gerçekleşirken akıl yürütme metnini iç içe geçiren bir adım$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Modelin nihai cevabının gerçek hatalardan tamamen arınmış olmasını garanti eden bir adım$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A goal decomposes cleanly into a known set of sub-tasks, and it matters that a human can review the full intended sequence before anything runs. According to "Choosing Among These Patterns," which pattern best suits this goal, and why?$$,
           NULL, NULL,
           $$The lesson states plan-and-execute suits goals that decompose cleanly into a known set of sub-tasks, especially when showing the plan before running it adds value (for instance, for a human review step) -- ReAct instead suits goals where the right next step genuinely depends on what the previous step returned and can't be known up front.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'agent-planning-and-reasoning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ReAct -- it suits goals that decompose cleanly into a known set of sub-tasks ahead of time$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Reflection -- it is the pattern specifically designed for producing a full plan before execution begins$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$None of these patterns can be used when a human needs to review a plan before it runs$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Plan-and-execute -- it suits goals that decompose cleanly into known sub-tasks, especially when showing the plan before execution adds value$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir hedef, bilinen bir alt-görev kümesine düzgün şekilde ayrışıyor, ve herhangi bir şey çalışmadan önce bir insanın tüm amaçlanan sırayı gözden geçirebilmesi önemli. 'Choosing Among These Patterns'a göre, bu hedef için hangi kalıp en uygun ve neden?$$,
           NULL, NULL,
           $$Ders, plan-and-execute'un, özellikle planı çalıştırmadan önce göstermenin değer kattığı durumlarda (örneğin bir insan gözden geçirme adımı için), bilinen bir alt-görev kümesine düzgün şekilde ayrışan hedeflere uygun olduğunu belirtir -- ReAct ise, doğru bir sonraki adımın gerçekten önceki adımın ne döndürdüğüne bağlı olduğu ve önceden bilinemediği hedeflere uygundur.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'agent-planning-and-reasoning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir insanın çalışmadan önce bir planı gözden geçirmesi gerektiğinde bu kalıplardan hiçbiri kullanılamaz$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Plan-and-execute -- özellikle çalıştırmadan önce planı göstermenin değer kattığı durumlarda, bilinen alt-görevlere düzgün şekilde ayrışan hedeflere uygundur$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$ReAct -- önceden bilinen bir alt-görev kümesine düzgün şekilde ayrışan hedeflere uygundur$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Reflection -- yürütme başlamadan önce tam bir plan üretmek için özellikle tasarlanmış kalıptır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to "Termination: Knowing When to Stop," which of the following is one of the three conditions that typically ends an agent's loop?$$,
           NULL, NULL,
           $$The lesson names three conditions: the model itself decides the goal has been satisfied (normal case), an external limit (such as a maximum number of steps) is reached before that, or an unrecoverable error occurs that no further looping can fix.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'agent-planning-and-reasoning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$An external limit, such as a maximum number of steps, is reached before the model concludes the goal is satisfied$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The agent's tool list is programmatically reduced to zero tools mid-run$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The human operator manually restarts the entire application from scratch$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$The model's context window is deliberately cleared after every single step$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$'Termination: Knowing When to Stop'a göre, aşağıdakilerden hangisi bir agent'ın loop'unu genellikle sonlandıran üç koşuldan biridir?$$,
           NULL, NULL,
           $$Ders üç koşul adlandırır: modelin kendisinin hedefin karşılandığına karar vermesi (normal durum), bundan önce harici bir sınıra (örneğin maksimum adım sayısı) ulaşılması, ya da daha fazla döngünün düzeltemeyeceği kurtarılamaz bir hatanın oluşması.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'agent-planning-and-reasoning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İnsan operatörün tüm uygulamayı elle sıfırdan yeniden başlatması$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Modelin context window'unun her tek adımdan sonra bilerek temizlenmesi$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Model, hedefin karşılandığı sonucuna varmadan önce, maksimum adım sayısı gibi harici bir sınıra ulaşılması$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Agent'ın araç listesinin çalışma sırasında programatik olarak sıfır araca indirilmesi$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Reflection is aimed at the same failure mode "Hallucination: Confident, Fluent, Wrong" described. According to this lesson, does adding a reflection step eliminate that risk entirely?$$,
           NULL, NULL,
           $$The lesson explicitly says reflection doesn't eliminate that risk -- the same model doing the checking has the same limitations as the model that produced the answer, though a dedicated critique step still catches some classes of mistake that would otherwise go straight through unchecked.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'agent-planning-and-reasoning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- reflection has no effect on hallucination risk at all, in any case$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$No -- the same model doing the checking has the same limitations as the model that produced the answer, though it still catches some mistakes$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Yes -- reflection guarantees a completely hallucination-free final answer in every case$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Yes, but only for CODE_OUTPUT-style tasks, and never for text-based answers$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Reflection, 'Hallucination: Confident, Fluent, Wrong'un tarif ettiği aynı başarısızlık moduna yöneliktir. Bu derse göre, bir reflection adımı eklemek bu riski tamamen ortadan kaldırır mı?$$,
           NULL, NULL,
           $$Ders açıkça reflection'ın bu riski ortadan kaldırmadığını belirtir -- kontrolü yapan aynı model, cevabı üreten modelle aynı kısıtlara sahiptir, ancak yine de özel bir eleştiri adımı, aksi takdirde kontrolsüz geçecek bazı hata sınıflarını yakalar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'agent-planning-and-reasoning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet -- reflection her durumda tamamen hallucination'dan arınmış bir nihai cevabı garanti eder$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Evet, ama yalnızca CODE_OUTPUT tarzı görevler için, metin tabanlı cevaplar için asla değil$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Hayır -- reflection, hiçbir durumda hallucination riski üzerinde hiçbir etkiye sahip değildir$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Hayır -- kontrolü yapan aynı model, cevabı üreten modelle aynı kısıtlara sahiptir, ama yine de bazı hataları yakalar$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about agent planning and reasoning patterns, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (these patterns aren't mutually exclusive and most real agents combine pieces of more than one, with reflection in particular usually being an addition rather than an alternative; and a decision function with no termination condition beyond the model's own judgment would loop forever, which is why a step-limit guardrail matters as a backstop); ReAct is explicitly described as replanning at every single step, which the lesson calls potentially less efficient than committing to a broader plan up front (not more efficient), and reflection is not framed as a replacement for ReAct or plan-and-execute.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'agent-planning-and-reasoning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ReAct's step-by-step replanning at every step is described in this lesson as strictly more efficient than committing to a broader plan up front$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Reflection is meant to fully replace ReAct or plan-and-execute rather than being added on top of either$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$ReAct, plan-and-execute, and reflection are not mutually exclusive -- most real agents combine pieces of more than one, with reflection usually being an addition$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$A decision function with no termination condition beyond the model's own judgment would otherwise loop forever, which is why a step-limit guardrail matters as a backstop$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, agent planlama ve akıl yürütme kalıpları hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (bu kalıpların birbirini dışlamadığı ve çoğu gerçek agent'ın birden fazlasının parçalarını birleştirdiği, özellikle reflection'ın genellikle bir alternatif değil bir ek olduğu; ve modelin kendi yargısı dışında hiçbir sonlanma koşulu olmayan bir karar fonksiyonunun aksi takdirde sonsuza kadar döneceği, bu yüzden bir step-limit güvencesinin bir yedek olarak önemli olduğu); ReAct, her tek adımda yeniden planlama yapıyor olarak açıkça tarif edilir, ders bunu daha geniş bir planı önceden taahhüt etmekten daha az verimli OLABİLECEĞİ şeklinde niteler (daha verimli değil), ve reflection, ReAct ya da plan-and-execute'un yerini almak için değil, ikisine de eklenebilen bir şey olarak çerçevelenir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'agent-planning-and-reasoning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ReAct, plan-and-execute ve reflection birbirini dışlamaz -- çoğu gerçek agent birden fazlasının parçalarını birleştirir, reflection genellikle bir ek olur$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Modelin kendi yargısı dışında hiçbir sonlanma koşulu olmayan bir karar fonksiyonu aksi takdirde sonsuza kadar döner, bu yüzden bir step-limit güvencesi bir yedek olarak önemlidir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$ReAct'in her adımda yeniden planlama yapması, bu derste daha geniş bir planı önceden taahhüt etmekten kesinlikle daha verimli olarak tarif edilir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Reflection, ReAct ya da plan-and-execute'un yerini tamamen almak için tasarlanmıştır, ikisine eklenmek için değil$$, FALSE, 3 FROM new_question_tr7;
