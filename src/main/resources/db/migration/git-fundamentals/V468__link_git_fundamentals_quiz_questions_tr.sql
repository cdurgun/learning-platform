-- Portable promotion-style migration linking the Turkish translations of the
-- Git Fundamentals quiz questions (same pattern as git-fundamentals/V467, which
-- did this for the English quiz -- see that file for the full rationale).
--
-- Development Question IDs: 105, 106, 107, 108, 109, 110, 111, 112, 113, 114
-- Topic: git-fundamentals (language: tr)
-- These are Turkish translations of the already-published English questions
-- 95-104 -- same meaning, same difficulty, same question type per question,
-- same correct-option positions, same 4-option structure. They were ingested
-- live via POST /api/internal/questions/ingest (source=CLAUDE), then
-- PUBLISHED through the normal human ADMIN review flow in development before
-- this migration was written -- exactly mirroring V467's own history for the
-- English questions. This migration only creates/links them on environments
-- that don't already have them (see duplicate-safety note below); it does
-- not itself perform any review step.
--
-- Each question is RE-INSERTED here with its full content via
-- WITH ... RETURNING id (question-promotion/V431's mechanism) -- portable to
-- any environment, no hardcoded foreign ids. topic_id is resolved by
-- Topic.slug, and the quiz is resolved by (topic slug, language='tr', quiz
-- slug='default') -- the EXISTING Turkish fixed quiz ("Bilgini Test Et"),
-- created back in core/V291 alongside the English one, not a new quiz.
--
-- Question 98's/108's Turkish translation intentionally keeps its
-- code_snippet byte-for-byte identical to the English version's real
-- `git status` terminal output -- git's own CLI output is not localized, so
-- translating it would misrepresent what a learner actually sees.
--
-- Duplicate-safety (same reasoning as V467): each block first checks whether
-- an equivalent question row (same topic_id + language='tr' + exact question
-- text) already exists, and only INSERTs when it doesn't -- portable to a
-- fresh database, and a safe no-op if re-run against this development
-- database (where the content already exists from live ingestion). The
-- quiz_question_link insert carries ON CONFLICT DO NOTHING as a second
-- safety net (UNIQUE(quiz_id, question_id), UNIQUE(quiz_id, position) from
-- V290).


-- Question 1/10 (dev id 105, Turkish translation of EN id 95, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'tr'
      AND question = $$Bir Git repository'si hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olanların hepsini seçin)$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir Git repository'si hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olanların hepsini seçin)$$, NULL, NULL,
           $$Bir repository, git init ile oluşturulan gizli .git klasörüyle tanımlanır -- bu klasörü silmek projenin Git geçmişini siler, ama gerçek dosyalar yerinde kalır. Bir klasörün zaten bir Git repository'si olması için ne GitHub'da barındırılması ne de var olan bir commit'e sahip olması gerekir.$$, 'temp-tr-publish-admin-1787924578@example.com', '2026-08-28 16:43:04.967036',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
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
    ($$Zaten en az bir commit içermesi gerekir.$$, FALSE, 0),
    ($$Git'in git init gibi bir komutla oluşturduğu gizli bir .git klasörü içerir.$$, TRUE, 1),
    ($$GitHub'da barındırılıyor olması gerekir.$$, FALSE, 2),
    ($$.git klasörünü silmek projenin Git geçmişini kaldırır, ama gerçek dosyaları silmez.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 2/10 (dev id 106, Turkish translation of EN id 96, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'tr'
      AND question = $$UserService.java dosyasını editöründe açıp yeni bir satır ekliyorsun, ama henüz herhangi bir git komutu çalıştırmadın. Bu değişiklik şu anda hangi alanda bulunuyor?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$UserService.java dosyasını editöründe açıp yeni bir satır ekliyorsun, ama henüz herhangi bir git komutu çalıştırmadın. Bu değişiklik şu anda hangi alanda bulunuyor?$$, NULL, NULL,
           $$Editöründe yaptığın değişiklikler, onları git add ile staging area'ya açıkça taşıyana kadar working tree'de -- diskteki gerçek dosyalarda -- yaşar. Henüz hiçbir git komutu çalıştırılmadığı için staging area ve repository etkilenmemiştir.$$, 'temp-tr-publish-admin-1787924578@example.com', '2026-08-28 16:43:05.031524',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
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
    ($$Yalnızca staging area'da.$$, FALSE, 0),
    ($$Hem staging area'da hem repository'de.$$, FALSE, 1),
    ($$Yalnızca working tree'de.$$, TRUE, 2),
    ($$Yalnızca repository'de.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 3/10 (dev id 107, Turkish translation of EN id 97, quiz position 3)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'tr'
      AND question = $$Git'in staging area'sı hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olanların hepsini seçin)$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Git'in staging area'sı hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olanların hepsini seçin)$$, NULL, NULL,
           $$Staging area, bir sonraki commit'e tam olarak hangi değişikliklerin gireceğini seçmene olanak tanır, ve onu git add kullanarak inşa edersin. Dosyalarını yedeklemez ya da herhangi bir şeyi sıkıştırmaz -- bunlar Git'in staging area'sının yaptığı şeyler değildir.$$, 'temp-tr-publish-admin-1787924578@example.com', '2026-08-28 16:43:05.085434',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
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
    ($$Commit etmeden önce dosyaları disk alanından tasarruf etmek için sıkıştırır.$$, FALSE, 0),
    ($$Bir sonraki commit'e tam olarak hangi değişikliklerin gireceğini seçmene olanak tanır.$$, TRUE, 1),
    ($$Dosyalarını kaybetme ihtimaline karşı otomatik olarak yedekler.$$, FALSE, 2),
    ($$git add kullanılarak inşa edilir.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 4/10 (dev id 108, Turkish translation of EN id 98, quiz position 4)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'tr'
      AND question = $$Yepyeni bir repository'de git status çalıştırıyorsun ve aşağıdaki çıktıyı görüyorsun. Bu çıktıya göre, UserService.java hakkında ne doğrudur?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Yepyeni bir repository'de git status çalıştırıyorsun ve aşağıdaki çıktıyı görüyorsun. Bu çıktıya göre, UserService.java hakkında ne doğrudur?$$, $$$ git status
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        UserService.java

nothing added to commit but untracked files present (use "git add" to track)$$, 'bash',
           $$"Untracked files" (izlenmeyen dosyalar), Git'in dosyayı working tree'de gördüğü ama onun hiç stage edilmediği ya da commit edilmediği anlamına gelir -- henüz Git'in geçmişinin bir parçası bile değildir.$$, 'temp-tr-publish-admin-1787924578@example.com', '2026-08-28 16:43:05.136612',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
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
    ($$Working tree'de var ama henüz stage edilmemiş ya da commit edilmemiş.$$, TRUE, 0),
    ($$Zaten repository'ye commit edilmiş.$$, FALSE, 1),
    ($$Working tree'de yok.$$, FALSE, 2),
    ($$Stage edilmiş ama henüz commit edilmemiş.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 5/10 (dev id 109, Turkish translation of EN id 99, quiz position 5)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'tr'
      AND question = $$git add çalıştırmakla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olanların hepsini seçin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$git add çalıştırmakla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olanların hepsini seçin)$$, NULL, NULL,
           $$git add, mevcut değişiklikleri staging area'ya taşır, bir sonraki commit için hazır hale getirir. Stage'lemek kaydetmekle aynı şey değildir -- dosya, git add'i hiç çalıştırmadan önce zaten diske kaydedilmiştir. Kalıcı olarak geçmiş kaydetmez (bu git commit'te olur) ya da herhangi bir yere bir şey yüklemez.$$, 'temp-tr-publish-admin-1787924578@example.com', '2026-08-28 16:43:05.184139',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
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
    ($$Dosyayı GitHub'a yükler.$$, FALSE, 0),
    ($$Dosyanın geçmişini repository'de kalıcı olarak kaydeder.$$, FALSE, 1),
    ($$Dosyanın mevcut değişikliklerini working tree'den staging area'ya taşır.$$, TRUE, 2),
    ($$Stage'lemek kaydetmekle aynı şey değildir -- dosya, sen onu çalıştırmadan önce zaten diske kaydedilmiştir.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 6/10 (dev id 110, Turkish translation of EN id 100, quiz position 6)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'tr'
      AND question = $$Üç dosya düzenledin ama yalnızca birinde git add çalıştırdın, sonra git commit -m "Fix login bug" çalıştırdın. Yeni commit'te ne kaydedilir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Üç dosya düzenledin ama yalnızca birinde git add çalıştırdın, sonra git commit -m "Fix login bug" çalıştırdın. Yeni commit'te ne kaydedilir?$$, NULL, NULL,
           $$Bir commit, o an staging area'da olan her şeyi alır ve kalıcı bir yeni anlık görüntü olarak kaydeder. Düzenlenen üç dosyadan yalnızca biri stage edildiği için, yalnızca o dosyanın değişiklikleri dahil edilir -- bu aynı zamanda commit etmeden önce bir dosyayı stage etmeyi unutmanın yaygın bir yeni başlayan hatası olmasının nedenidir.$$, 'temp-tr-publish-admin-1787924578@example.com', '2026-08-28 16:43:05.230537',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
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
    ($$Düzenlenen üç dosyanın tamamındaki değişiklikler.$$, FALSE, 0),
    ($$Yalnızca stage edilen tek dosyadaki değişiklikler.$$, TRUE, 1),
    ($$Hiçbir şey, çünkü git commit'in bir şey kaydetmesi için önce git status çalıştırılmalıdır.$$, FALSE, 2),
    ($$Değişip değişmediğine bakılmaksızın working tree'deki tüm dosyalar.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 7/10 (dev id 111, Turkish translation of EN id 101, quiz position 7)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'tr'
      AND question = $$Bir dosyayı düzenledin ama henüz git add çalıştırmadın. Hangi komut tam olarak neyin değiştiğini gösterir, ve neyi neyle karşılaştırır?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir dosyayı düzenledin ama henüz git add çalıştırmadın. Hangi komut tam olarak neyin değiştiğini gösterir, ve neyi neyle karşılaştırır?$$, NULL, NULL,
           $$Düz git diff (bayraksız), stage edilmemiş değişiklikleri gösterir: working tree'yi staging area ile karşılaştırır. git diff --staged farklı bir karşılaştırmadır (staging area vs. son commit), yalnızca stage'lemeden sonra kullanılır.$$, 'temp-tr-publish-admin-1787924578@example.com', '2026-08-28 16:43:05.274385',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
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
    ($$git diff -- working tree'yi staging area ile karşılaştırır.$$, TRUE, 0),
    ($$git status -- satır satır değişiklikleri gösterir.$$, FALSE, 1),
    ($$git log -- commit geçmişini gösterir.$$, FALSE, 2),
    ($$git diff --staged -- staging area'yı son commit ile karşılaştırır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 8/10 (dev id 112, Turkish translation of EN id 102, quiz position 8)
WITH existing_q8 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'tr'
      AND question = $$Az önce bir dosyada git add çalıştırdın ve git commit çalıştırmadan önce tam olarak neyin commit edileceğine dair son bir kontrol yapmak istiyorsun. Hangi komutu çalıştırmalısın, ve neden?$$
),
inserted_q8 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Az önce bir dosyada git add çalıştırdın ve git commit çalıştırmadan önce tam olarak neyin commit edileceğine dair son bir kontrol yapmak istiyorsun. Hangi komutu çalıştırmalısın, ve neden?$$, NULL, NULL,
           $$git diff --staged, staging area'yı son commit ile karşılaştırır -- şu anda commit etseydin geçmişe tam olarak ne ekleneceğini gösterir. Her commit'ten önce bunu gözden geçirmek bir en iyi pratik olarak belirtiliyor, çünkü unutulmuş bir debug satırı gibi bir şeyi yakalamak için son şansın.$$, 'temp-tr-publish-admin-1787924578@example.com', '2026-08-28 16:43:05.316460',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
      AND NOT EXISTS (SELECT 1 FROM existing_q8)
    RETURNING id
),
target_q8 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q8
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q8
),
option_ins_q8 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q8.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q8
             CROSS JOIN (VALUES
    ($$git log, çünkü bir sonraki commit'i yapılmadan önce önizler.$$, FALSE, 0),
    ($$git diff --staged, çünkü staging area'yı son commit ile karşılaştırır.$$, TRUE, 1),
    ($$git status, çünkü satır satır farkları gösterir.$$, FALSE, 2),
    ($$git diff, çünkü stage durumundan bağımsız olarak her zaman tüm değişiklikleri gösterir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q8.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q8.id, 8
FROM target_q8
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 9/10 (dev id 113, Turkish translation of EN id 103, quiz position 9)
WITH existing_q9 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'tr'
      AND question = $$git log öncelikle sana neyi gösterir?$$
),
inserted_q9 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$git log öncelikle sana neyi gösterir?$$, NULL, NULL,
           $$git log, commit geçmişini gösterir -- en yeniden en eskiye kaydedilmiş her anlık görüntü, her biri kendi commit hash'i, yazarı, tarihi ve mesajıyla birlikte.$$, 'temp-tr-publish-admin-1787924578@example.com', '2026-08-28 16:43:05.356959',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
      AND NOT EXISTS (SELECT 1 FROM existing_q9)
    RETURNING id
),
target_q9 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q9
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q9
),
option_ins_q9 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q9.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q9
             CROSS JOIN (VALUES
    ($$Working tree'de şu anda izlenen dosyaların listesini.$$, FALSE, 0),
    ($$Yalnızca şu anda stage edilmiş olan değişiklikleri.$$, FALSE, 1),
    ($$Commit geçmişini: kaydedilmiş her anlık görüntüyü, en yeniden en eskiye, yazar, tarih ve mesajla birlikte.$$, TRUE, 2),
    ($$Working tree ile son commit arasındaki farkları.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q9.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q9.id, 9
FROM target_q9
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


-- Question 10/10 (dev id 114, Turkish translation of EN id 104, quiz position 10)
WITH existing_q10 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'git-fundamentals')
      AND language = 'tr'
      AND question = $$git log tarafından gösterilen her commit, 4f2a1c9e8b3d5a6f7e8d9c0b1a2f3e4d5c6b7a8f gibi uzun bir onaltılık (hexadecimal) dizeyle başlar. Bu nedir, ve neden önemlidir?$$
),
inserted_q10 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$git log tarafından gösterilen her commit, 4f2a1c9e8b3d5a6f7e8d9c0b1a2f3e4d5c6b7a8f gibi uzun bir onaltılık (hexadecimal) dizeyle başlar. Bu nedir, ve neden önemlidir?$$, NULL, NULL,
           $$Bu, commit'in benzersiz hash'idir (SHA) -- Git'in o tam anlık görüntüye her yerde referans vermek için kullandığı tanımlayıcı, sonraki derslerde belirli commit'lere referans verirken de kullanılır (değişiklikleri geri almak, cherry-pick yapmak ve daha fazlası hash ile çalışır).$$, 'temp-tr-publish-admin-1787924578@example.com', '2026-08-28 16:43:05.397425',
           now(), now()
    FROM topic
    WHERE slug = 'git-fundamentals'
      AND NOT EXISTS (SELECT 1 FROM existing_q10)
    RETURNING id
),
target_q10 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q10
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q10
),
option_ins_q10 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q10.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q10
             CROSS JOIN (VALUES
    ($$Yazarın benzersiz geliştirici kimliği.$$, FALSE, 0),
    ($$Başka bir amacı olmayan rastgele üretilmiş bir görüntüleme kimliği.$$, FALSE, 1),
    ($$Commit'in benzersiz hash'i (SHA) -- Git'in o tam anlık görüntüye her yerde referans vermek için kullandığı tanımlayıcı.$$, TRUE, 2),
    ($$Commit'in onaltılık olarak kodlanmış zaman damgası.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q10.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q10.id, 10
FROM target_q10
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'git-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
