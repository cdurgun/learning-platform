-- Promotion batch
-- Topic: microservices-fundamentals (language: en x7, tr x7)
-- Generated: 2026-09-07 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 14 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/microservices-fundamentals.md and content/tr/microservices-fundamentals.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (7 EN + 7 TR here), sized to
-- this lesson's actual concept density -- same convention established in the
-- Docker/PostgreSQL Foundations/git-github batches.
--
-- Strict 50/50 EN/TR split organized as 7 CONCEPT PAIRS -- each EN question
-- has a TR counterpart testing the exact same concept, but independently
-- authored (different framing/distractors), not a translation. Every
-- question whose answer depends on shown code/config output is typed
-- CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a code_snippet
-- attached).
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly. topic_id resolved by Topic.slug; question_option
-- rows reference the newly generated id via a WITH ... RETURNING id CTE.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these questions at all.

-- Pair 1 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is the core structural difference between a microservice and a module inside a monolith, per this lesson?$$,
           NULL, NULL,
           $$The lesson contrasts monolith characteristics (single codebase, single deployment unit, direct method calls, single shared database) with microservices' core characteristics (independent deployability and ownership of its own data).$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$microservices-fundamentals$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A microservice must be written in a different programming language$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A microservice is a separate, independently deployable process that owns its own data -- a monolith's modules share one process and one database$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A microservice always has more code than an equivalent monolith module$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A microservice cannot expose a REST API$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir mikroservis ile bir monolit içindeki bir modül arasındaki temel yapısal fark nedir?$$,
           NULL, NULL,
           $$Ders, monolitin özelliklerini (tek kod tabanı, tek deploy birimi, doğrudan metot çağrıları, paylaşılan veritabanı) mikroservisin temel özellikleriyle (bağımsız deploy edilebilirlik ve kendi veri sahipliği) karşılaştırır.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$microservices-fundamentals$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir mikroservis, sistemin geri kalanından farklı bir dilde yazılmak zorundadır$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir mikroservis eşdeğer bir monolit modülünden her zaman daha fazla kod içerir$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir mikroservis, kendi verisinin sahibi olan, ayrı ve bağımsız deploy edilebilen bir süreçtir; monolitin modülleri tek bir süreci ve veritabanını paylaşır$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir mikroservis asla REST API sunamaz$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Per "Why Do They Exist?", in which situation does the monolith's "rebuild the whole app for one small change" problem actually start to hurt?$$,
           NULL, NULL,
           $$The lesson explains the trouble shows up as the application and the team building it grows -- dozens of developers, merge conflicts, and uneven traffic across modules.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$microservices-fundamentals$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$From the very first day of any project, regardless of size$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Only once the application is deployed to a cloud provider$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$As the application and the team building it grow -- dozens of developers, frequent merge conflicts, uneven traffic across modules$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Only when the application stops using a relational database$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$"Neden Var? (Monolitin Sınırları)" bölümüne göre, monolitin "küçük bir değişiklik için tüm uygulamayı yeniden build etme" sorunu gerçekte ne zaman acıtmaya başlar?$$,
           NULL, NULL,
           $$Ders, sorunun uygulama ve onu geliştiren ekip büyüdükçe ortaya çıktığını açıklar -- onlarca geliştirici, sık merge çakışmaları, modüller arası dengesiz trafik.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$microservices-fundamentals$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Herhangi bir projenin, boyutundan bağımsız olarak, ilk gününden itibaren$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca uygulama bir bulut sağlayıcısına deploy edildiğinde$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Uygulama ve onu geliştiren ekip büyüdükçe -- onlarca geliştirici, sık merge çakışmaları, modüller arası dengesiz trafik$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca uygulama ilişkisel bir veritabanı kullanmayı bıraktığında$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A team splits an application into services but keeps them all reading and writing the same shared database schema. What does this lesson call this outcome?$$,
           NULL, NULL,
           $$The lesson defines this as a "distributed monolith" -- carrying all the operational cost of microservices without any of the monolith's simplicity advantage.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$microservices-fundamentals$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A modular monolith$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$A bounded context$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$A distributed monolith -- all the operational cost of microservices, none of the monolith's simplicity benefit$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$An orchestrated saga$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir ekip bir uygulamayı servislere böler ama hepsinin aynı paylaşılan veritabanı şemasını okuyup yazmasına izin verir. Bu ders bu sonucu ne olarak adlandırır?$$,
           NULL, NULL,
           $$Ders bunu bir "distributed monolith" (dağıtık monolit) olarak tanımlar -- mikroservislerin tüm operasyonel maliyetini taşır, monolitin basitlik avantajının hiçbirini taşımaz.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$microservices-fundamentals$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Modüler bir monolit$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir bounded context$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Dağıtık bir monolit (distributed monolith) -- mikroservislerin tüm operasyonel maliyetini taşır, monolitin basitlik avantajının hiçbirini taşımaz$$, TRUE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Orkestre edilmiş bir saga$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to "A Quick Look at the CAP Theorem," what choice does a distributed system actually face once a network partition happens?$$,
           NULL, NULL,
           $$The lesson explains that since Partition Tolerance can't realistically be given up, the practical choice during a partition is between Consistency and Availability.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$microservices-fundamentals$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Between Consistency and Partition Tolerance, since Availability is guaranteed by definition$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Between Consistency and Availability, since Partition Tolerance can't be given up in the real world$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Between all three properties simultaneously, with no trade-off required$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Between using REST and using message queues$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"A Quick Look at the CAP Theorem" bölümüne göre, bir ağ bölünmesi (network partition) yaşandığında dağıtık bir sistem gerçekte hangi seçimle karşı karşıya kalır?$$,
           NULL, NULL,
           $$Ders, Partition Tolerance gerçekçi olarak terk edilemeyeceği için, bir bölünme sırasındaki pratik seçimin Consistency ile Availability arasında olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$microservices-fundamentals$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Consistency ile Partition Tolerance arasında, çünkü Availability tanım gereği garantidir$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Consistency ile Availability arasında, çünkü Partition Tolerance gerçek dünyada terk edilemez$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Üç özelliğin tamamı arasında, hiçbir değiş tokuş gerekmeden$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$REST kullanmak ile mesaj kuyruğu kullanmak arasında$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Per "Conway's Law," what does the observation actually predict about a company with one large, tightly coordinated team?$$,
           NULL, NULL,
           $$The lesson states the reverse relationship also holds: a single, large, tightly coordinated team naturally tends to produce a single monolith, since they're already in constant synchronous communication.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$microservices-fundamentals$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$That team will always be forced to adopt microservices for compliance reasons$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$That team will naturally tend to produce a single monolith, since they're already in constant synchronous communication$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$That team's software will automatically split into services matching database tables$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Conway's Law only applies to organizations founded after 2011$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"Conway Yasası" bölümüne göre, gözlem, tek, büyük ve sıkı koordineli bir ekibe sahip bir şirket hakkında gerçekte neyi öngörür?$$,
           NULL, NULL,
           $$Ders, tersinin de doğru olduğunu belirtir: tek, büyük, sıkı koordineli bir ekip, zaten sürekli eşzamanlı iletişim içinde olduğu için doğal olarak tek bir monolit üretme eğiliminde olur.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$microservices-fundamentals$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$O ekip, uyumluluk nedenleriyle her zaman mikroservis benimsemek zorunda kalır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$O ekip, zaten sürekli eşzamanlı iletişim içinde olduğu için doğal olarak tek bir monolit üretme eğiliminde olur$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$O ekibin yazılımı otomatik olarak veritabanı tablolarıyla eşleşen servislere bölünür$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Conway Yasası yalnızca 2011'den sonra kurulan organizasyonlara uygulanır$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does the "modular monolith" approach described in this lesson actually keep, compared to full microservices?$$,
           NULL, NULL,
           $$The lesson explains a modular monolith keeps a single process and direct method calls between modules, so it never experiences network unreliability, partial failure, or eventual consistency problems.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$microservices-fundamentals$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Independent per-module databases, but a shared deployment process$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$A single process and direct method calls between modules -- so none of the network unreliability or eventual-consistency costs apply$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Independent scalability per module, but a single shared codebase$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$The exact same deployment pipeline as a distributed system$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılan "modüler monolit" yaklaşımı, tam mikroservislere kıyasla gerçekte neyi korur?$$,
           NULL, NULL,
           $$Ders, bir modüler monolitin modüller arasında tek bir süreç ve doğrudan metot çağrıları koruduğunu, bu yüzden ağ güvenilmezliği, kısmi hata veya eventual consistency problemlerini hiç yaşamadığını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$microservices-fundamentals$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Modül başına bağımsız veritabanları, ama paylaşılan bir deploy süreci$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Tek bir süreç ve modüller arası doğrudan metot çağrıları -- bu yüzden ağ güvenilmezliği veya eventual consistency maliyetlerinin hiçbiri geçerli olmaz$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Modül başına bağımsız ölçeklenebilirlik, ama tek bir paylaşılan kod tabanı$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Dağıtık bir sistemle birebir aynı deploy pipeline'ı$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are presented in this lesson as genuine signals that lean toward adopting microservices? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson lists differing scaling needs and teams wanting independent deploy cadence as signals toward microservices; a small team and an unsettled domain are explicitly listed as signals toward a monolith instead.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$microservices-fundamentals$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Different modules have clearly different traffic/scaling needs$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$The team is small (a handful of developers)$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Different teams want to deploy at their own pace without blocking each other$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$The domain/business rules aren't settled yet$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri bu derste mikroservis benimsemeye yönelen gerçek sinyaller olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Ders, farklı ölçeklenme ihtiyaçlarını ve ekiplerin bağımsız deploy hızı istemesini mikroservise yönelen sinyaller olarak listeler; küçük bir ekip ve oturmamış bir domain ise açıkça monolite yönelen sinyaller olarak listelenir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$microservices-fundamentals$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Farklı modüllerin belirgin şekilde farklı trafik/ölçeklenme ihtiyaçları vardır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Ekip küçüktür (bir avuç geliştirici)$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Farklı ekipler birbirini engellemeden kendi hızlarında deploy etmek ister$$, TRUE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Domain/iş kuralları henüz oturmamıştır$$, FALSE, 3 FROM new_question_tr7;
