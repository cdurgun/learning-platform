-- Promotion batch
-- Topic: controlling-agent-behavior (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these 14
-- questions were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/controlling-agent-behavior.md
-- and content/tr/controlling-agent-behavior.md -- NOT produced by n8n, NOT judged by any
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
           $$According to "Why Agents Need Guardrails," why is an unconstrained agent loop riskier than a single tool call?$$,
           NULL, NULL,
           $$The lesson states an agent loop can take many actions in sequence, chosen by the model rather than a human, and each of those actions might be a real tool call with a real side effect -- a wrong decision or a tool call aimed at the wrong argument doesn't get caught by a human before it runs, unlike a single tool call a human decided to send.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlling-agent-behavior'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because the model, not a human, chooses a sequence of real actions with real side effects, so a wrong decision doesn't get caught by a human before it runs$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Because an agent loop is technically incapable of ever calling a real tool with a real side effect$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Because a single tool call is always slower to execute than a full agent loop$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Because guardrails are only needed once an agent has caused actual, confirmed financial damage$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$'Why Agents Need Guardrails'a göre, kısıtlanmamış bir agent loop'u neden tek bir tool call'dan daha risklidir?$$,
           NULL, NULL,
           $$Ders, bir agent loop'unun bir insan yerine model tarafından seçilen, sırayla birçok eylem alabileceğini ve bu eylemlerin her birinin gerçek bir yan etkisi olan gerçek bir tool call olabileceğini belirtir -- yanlış bir karar ya da yanlış argümanı hedefleyen bir tool call, bir insanın göndermeye karar verdiği tek bir tool call'ın aksine, çalışmadan önce bir insan tarafından yakalanmaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlling-agent-behavior'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü tek bir tool call, çalıştırılması her zaman tam bir agent loop'undan daha yavaştır$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü guardrail'ler yalnızca bir agent gerçek, teyit edilmiş bir finansal zarara yol açtıktan sonra gereklidir$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü bir insan değil model, gerçek yan etkileri olan bir dizi gerçek eylem seçer, bu yüzden yanlış bir karar çalışmadan önce bir insan tarafından yakalanmaz$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü bir agent loop'u teknik olarak gerçek bir yan etkisi olan gerçek bir aracı hiçbir zaman çağıramaz$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is a step limit (iteration limit), according to this lesson?$$,
           NULL, NULL,
           $$A step limit is a hard backstop: a maximum number of decide-act cycles the loop is allowed to run, enforced in code rather than left up to the model's own judgment -- once hit, the loop stops unconditionally, whatever it was doing, deliberately a blunt mechanism rather than a clever one.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlling-agent-behavior'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A limit on the total number of tokens a single tool result may contain$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$A hard, code-enforced maximum number of decide-act cycles a loop is allowed to run, stopping it unconditionally once hit$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$A soft suggestion the model can choose to ignore if it believes the goal isn't quite finished yet$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$A limit on how many tools an MCP server is allowed to expose to any one client$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir step limit (iteration limit) nedir?$$,
           NULL, NULL,
           $$Bir step limit sert bir yedektir: loop'un çalışmasına izin verilen maksimum decide-act döngüsü sayısıdır, modelin kendi yargısına bırakılmak yerine kodda zorunlu kılınır -- ulaşıldığında, loop ne yapıyor olursa olsun koşulsuz olarak durur, kasıtlı olarak akıllı değil kaba bir mekanizmadır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlling-agent-behavior'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Modelin hedefin tam olarak bitmediğine inanırsa görmezden gelmeyi seçebileceği yumuşak bir öneri$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir MCP server'ın herhangi bir client'a sunmasına izin verilen araç sayısı üzerindeki bir sınır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Tek bir tool sonucunun içerebileceği toplam token sayısı üzerindeki bir sınır$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir loop'un çalışmasına izin verilen, kodda zorunlu kılınan, sert bir maksimum decide-act döngüsü sayısı, ulaşıldığında loop'u koşulsuz olarak durdurur$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to "Human-in-the-Loop: Approval Before Risky Actions," does every action an agent might take need to go through human approval?$$,
           NULL, NULL,
           $$The lesson is explicit that this doesn't mean every action needs approval, which would defeat the point of having an agent at all -- it means deliberately marking the subset of actions where a wrong decision is expensive enough (costly, irreversible, or hard to verify) that a brief pause for approval is worth the lost speed.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlling-agent-behavior'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- human-in-the-loop means no action should ever require approval, under any circumstances$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Yes, but only for actions that involve calling get_capital_city or calculate_sum specifically$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$No -- requiring approval for every action would defeat the point of having an agent; only costly, irreversible, or hard-to-verify actions should be routed through approval$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Yes -- every single action an agent takes must always be approved by a human before it runs, without exception$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$'Human-in-the-Loop: Approval Before Risky Actions'a göre, bir agent'ın alabileceği her eylem insan onayından geçmesi gerekir mi?$$,
           NULL, NULL,
           $$Ders açıktır: bu, her eylemin onay gerektirdiği anlamına gelmez, bu bir agent'a sahip olmanın amacını tamamen ortadan kaldırırdı -- bu, yanlış bir kararın yeterince pahalı olduğu (maliyetli, geri döndürülemez ya da doğrulanması zor) alt kümeyi bilinçli olarak işaretlemek anlamına gelir, öyle ki kısa bir onay duraklaması kaybedilen hıza değer.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlling-agent-behavior'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayır -- her eylem için onay gerektirmek bir agent'a sahip olmanın amacını ortadan kaldırırdı; yalnızca maliyetli, geri döndürülemez ya da doğrulanması zor eylemler onaydan geçirilmelidir$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Evet -- bir agent'ın aldığı her tek eylem, istisnasız olarak her zaman bir insan tarafından çalışmadan önce onaylanmalıdır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Hayır -- human-in-the-loop, hiçbir koşulda hiçbir eylemin asla onay gerektirmemesi gerektiği anlamına gelir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Evet, ama yalnızca özellikle get_capital_city ya da calculate_sum'ı çağırmayı içeren eylemler için$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$An agent is given a tool that can delete any record, even though its actual job only ever requires reading records. According to "Scoping Tool Access: The Principle of Least Privilege," what risk does this create?$$,
           NULL, NULL,
           $$The lesson states this creates a risk that has nothing to do with how good the agent's decision-making is -- it exists purely because the capability was available to misuse; narrower tool access doesn't make the agent's reasoning any better, but it shrinks the space of damage a bad decision can cause.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlling-agent-behavior'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No real risk, since giving broader tool access always makes an agent's underlying reasoning more reliable$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$A risk that only ever materializes if the agent is also given human-in-the-loop approval for every action$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$A risk that is entirely eliminated as soon as observability/logging is added to the loop$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$A risk that has nothing to do with how good the agent's decision-making is -- it exists purely because the unnecessary delete capability was available to misuse$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir agent'a, gerçek görevi yalnızca kayıtları okumayı gerektirdiği halde, herhangi bir kaydı silebilen bir araç veriliyor. 'Scoping Tool Access: The Principle of Least Privilege'a göre, bu ne tür bir risk yaratır?$$,
           NULL, NULL,
           $$Ders, bunun agent'ın karar vermesinin ne kadar iyi olduğuyla hiçbir ilgisi olmayan bir risk yarattığını belirtir -- bu risk yalnızca kötüye kullanılabilecek bir yetenek mevcut olduğu için var olur; daha dar araç erişimi agent'ın akıl yürütmesini daha iyi yapmaz, ama kötü bir kararın yaratabileceği zararın alanını daraltır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlling-agent-behavior'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Loop'a observability/logging eklenir eklenmez tamamen ortadan kalkan bir risk$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Agent'ın karar vermesinin ne kadar iyi olduğuyla hiçbir ilgisi olmayan bir risk -- bu risk yalnızca gereksiz silme yeteneği kötüye kullanılabilir olduğu için var olur$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Gerçek bir risk yoktur, çünkü daha geniş araç erişimi vermek her zaman bir agent'ın altta yatan akıl yürütmesini daha güvenilir yapar$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca agent'a her eylem için human-in-the-loop onayı da verilirse ortaya çıkan bir risk$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$An agent produces a wrong final answer, and there is no record of what tools it called, with what arguments, or what results it got back. According to "Observability: Logging and Tracing an Agent's Decisions," what does this lesson say about diagnosing this situation?$$,
           NULL, NULL,
           $$The lesson states that without this logging, a wrong final answer is nearly impossible to debug -- there's no way to tell whether the model reasoned incorrectly, called the right tool with the wrong arguments, or got a correct result and misused it.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlling-agent-behavior'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It's nearly impossible to debug -- without a log of each step, there's no way to tell where the actual mistake happened$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It's trivial to debug, since a wrong final answer alone always makes the root cause obvious$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$This can only be diagnosed by re-running the exact same goal with a completely different set of tools$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$A step limit alone is always sufficient to explain why any wrong answer occurred$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir agent yanlış bir nihai cevap üretiyor, ve hangi araçları hangi argümanlarla çağırdığına ya da hangi sonuçları geri aldığına dair hiçbir kayıt yok. 'Observability: Logging and Tracing an Agent's Decisions'a göre, bu ders bu durumu teşhis etmek hakkında ne söylüyor?$$,
           NULL, NULL,
           $$Ders, bu loglama olmadan, yanlış bir nihai cevabın hata ayıklanmasının neredeyse imkansız olduğunu belirtir -- modelin yanlış akıl yürütüp yürütmediğini, doğru aracı yanlış argümanlarla çağırıp çağırmadığını, ya da doğru bir sonuç alıp onu yanlış kullanıp kullanmadığını söylemenin bir yolu yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlling-agent-behavior'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu yalnızca aynı hedefi tamamen farklı bir araç kümesiyle yeniden çalıştırarak teşhis edilebilir$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Herhangi bir yanlış cevabın neden oluştuğunu açıklamak için tek başına bir step limit her zaman yeterlidir$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Hata ayıklaması neredeyse imkansızdır -- her adımın bir kaydı olmadan, gerçek hatanın nerede olduğunu söylemenin bir yolu yoktur$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Hata ayıklaması önemsizdir, çünkü yanlış bir nihai cevap tek başına kök nedeni her zaman açık kılar$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$An agent is granted only read access to a customer database (least privilege), has a step limit of 10, and logs every decision -- but no action it takes ever requires human approval, including sending refund emails. According to this lesson, is this guardrail combination adequate for sending refund emails specifically?$$,
           NULL, NULL,
           $$The lesson treats these as distinct, complementary mechanisms addressing different risks -- least privilege, a step limit, and logging don't substitute for human-in-the-loop approval on a costly, hard-to-reverse action like sending a refund email; "Human-in-the-Loop" specifically calls out actions that are costly, irreversible, or hard to verify automatically as needing an approval step, regardless of the other guardrails already in place.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlling-agent-behavior'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- but only because read-only database access already makes sending an email impossible in the first place$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$No -- least privilege, a step limit, and logging address different risks; a costly, hard-to-reverse action like sending a refund email still needs its own human-in-the-loop approval step$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Yes -- a step limit alone is always sufficient to make any action, including sending refund emails, safe to run without approval$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Yes -- logging every decision automatically prevents any costly action from having a real-world side effect$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir agent'a bir müşteri veritabanına yalnızca okuma erişimi (least privilege) veriliyor, 10'luk bir step limit'i var, ve her kararını loglıyor -- ama iade e-postası göndermek dahil, aldığı hiçbir eylem hiçbir zaman insan onayı gerektirmiyor. Bu derse göre, bu guardrail kombinasyonu özellikle iade e-postası göndermek için yeterli midir?$$,
           NULL, NULL,
           $$Ders, bunları farklı riskleri ele alan, ayrı ve birbirini tamamlayan mekanizmalar olarak ele alır -- least privilege, bir step limit ve loglama, iade e-postası göndermek gibi maliyetli, geri döndürülmesi zor bir eylem için human-in-the-loop onayının yerini tutmaz; 'Human-in-the-Loop', diğer guardrail'ler zaten mevcut olsa bile, maliyetli, geri döndürülemez ya da otomatik doğrulanması zor eylemlerin özellikle bir onay adımına ihtiyaç duyduğunu belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlling-agent-behavior'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet -- tek başına bir step limit, iade e-postası göndermek dahil herhangi bir eylemi onaysız çalıştırmak için her zaman yeterlidir$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Evet -- her kararı loglamak, maliyetli herhangi bir eylemin gerçek dünyada bir yan etkiye sahip olmasını otomatik olarak engeller$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Hayır -- ama yalnızca salt-okunur veritabanı erişimi zaten bir e-posta göndermeyi baştan imkansız kıldığı için$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Hayır -- least privilege, step limit ve loglama farklı riskleri ele alır; iade e-postası göndermek gibi maliyetli, geri döndürülmesi zor bir eylem hâlâ kendi human-in-the-loop onay adımına ihtiyaç duyar$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about controlling agent behavior, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (a step limit is deliberately blunt -- it doesn't try to be clever about whether the agent is "almost done," it just stops the loop unconditionally once hit; and the principle of least privilege bounds tool access to what a task genuinely needs, not broader access "just in case"); relying only on the model's own judgment to stop the loop is explicitly called a common mistake (a hard step limit is needed as a backstop), and observability specifically means logging every step of the loop, not merely the final answer.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlling-agent-behavior'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Relying only on the model's own judgment to stop the loop, with no hard step limit, is recommended as sufficient in this lesson$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Observability, in this lesson, means recording only the agent's final answer, not the individual steps that led to it$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$A step limit is deliberately a blunt mechanism -- it doesn't try to judge whether the agent is "almost done," it just stops the loop unconditionally once the limit is hit$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$The principle of least privilege means granting an agent's tools exactly what its task needs, not broader access "just in case it's needed"$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, agent davranışını kontrol etmek hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (bir step limit bilinçli olarak kaba bir mekanizmadır -- agent'ın 'neredeyse bitmiş' olup olmadığı konusunda akıllı olmaya çalışmaz, sınıra ulaşıldığında loop'u koşulsuz olarak durdurur; ve least privilege ilkesi, bir agent'ın araçlarına, 'ne olur ne olmaz' diye daha geniş erişim değil, tam olarak görevinin ihtiyaç duyduğunu vermek anlamına gelir); loop'u durdurmak için yalnızca modelin kendi yargısına güvenmek, bu derste açıkça yaygın bir hata olarak adlandırılır (bir yedek olarak sert bir step limit gereklidir), ve observability özellikle loop'un yalnızca nihai cevabını değil, her adımını loglamak anlamına gelir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlling-agent-behavior'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir step limit bilinçli olarak kaba bir mekanizmadır -- agent'ın 'neredeyse bitmiş' olup olmadığını yargılamaya çalışmaz, sınıra ulaşıldığında loop'u koşulsuz olarak durdurur$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Least privilege ilkesi, bir agent'ın araçlarına 'ne olur ne olmaz diye' daha geniş erişim değil, tam olarak görevinin ihtiyaç duyduğunu vermek anlamına gelir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bu derste, loop'u durdurmak için sert bir step limit olmadan yalnızca modelin kendi yargısına güvenmek yeterli olarak önerilir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bu derste observability, yalnızca agent'ın nihai cevabını kaydetmek anlamına gelir, ona götüren bireysel adımları değil$$, FALSE, 3 FROM new_question_tr7;
