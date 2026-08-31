-- Promotion batch
-- Topic: file-writing (language: en x8, tr x4)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- UNLIKE every previous question-promotion migration in this project, these
-- 12 questions were NOT produced by the n8n generation pipeline, NOT judged
-- by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per an explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/file-writing.md and content/tr/file-writing.md. Each question
-- was checked against: factual accuracy, lesson support (no outside-lesson
-- knowledge), whether the marked-correct option directly answers the
-- question stem (not merely whether it is true), ambiguity, distractor
-- plausibility, code correctness (for CODE_OUTPUT), language quality, and
-- duplication against sibling questions in this same batch. Two questions
-- were revised/discarded during that review before being finalized here --
-- see the chat transcript for the full review log (a draft EN option
-- asserting an unconfirmed StandardOpenOption.CREATE-alone behavior not
-- stated in the lesson was rewritten to avoid outside-lesson knowledge; a
-- draft TR "common mistakes" MULTIPLE_CHOICE was discarded as fully
-- redundant with facts already individually tested elsewhere in this same
-- batch, and replaced with a BufferedWriter.newLine() platform-separator
-- question instead).
--
-- source = 'CLAUDE' (the QuestionSource enum value for content Claude
-- itself authored/ingested, as opposed to N8N/OPENAI pipeline runs or a
-- human's own MANUAL authoring) -- reviewed_by = 'claude-code@anthropic.com'
-- documents that the review was performed by Claude Code in this session,
-- not by the n8n AI Judge (would be 'n8n-ai-judge') or a human clicking
-- Publish in the real Admin UI (would be a real user email). status is set
-- directly to PUBLISHED, same as every other promotion migration in this
-- project -- there is no PENDING_REVIEW/ingest-API step for this batch, by
-- explicit user request (no n8n, no OpenAI, no AI Judge).
--
-- topic_id is resolved by Topic.slug (globally unique, stable across
-- environments) -- no development id is used as a foreign key value
-- anywhere below; question_option rows reference the newly generated id of
-- the INSERT immediately above them via a WITH ... RETURNING id CTE, so
-- this migration is correct regardless of what this environment's own
-- auto-generated ids turn out to be -- same pattern as question-promotion/
-- V431, V489, V520, V521, V525, V529, and V533.
--
-- Duplicate-promotion safety (bkz. docs/known-constraints.md "Faz D"): no
-- overlap with any prior promotion migration's ids -- N/A here since this
-- batch was never ingested into development in the first place (no dev ids
-- exist for these 12 questions at all).

-- Question EN-1 (en, SINGLE_CHOICE, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$By default, what happens if you call Files.writeString(path, content) on a file that already exists?$$, NULL, NULL,
           $$Files.writeString() creates the file if it doesn't exist and overwrites it entirely if it does -- calling it again simply replaces the previous content, it does not append to it.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'file-writing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The new content is appended to the end of the existing content.$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$The file's entire existing content is overwritten with the new content.$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$An exception is thrown because the file already exists.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$The call is ignored and the original content is preserved.$$, FALSE, 3 FROM new_question_en1;

-- Question EN-2 (en, SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens if you call Files.writeString(path, content, StandardOpenOption.APPEND) on a file that does not exist yet?$$, NULL, NULL,
           $$APPEND alone assumes the file already exists. Calling it on a missing file throws NoSuchFileException -- APPEND does not automatically include CREATE.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'file-writing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It throws NoSuchFileException.$$, TRUE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It creates the file and writes the content.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It throws FileAlreadyExistsException.$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It silently does nothing and no file is created.$$, FALSE, 3 FROM new_question_en2;

-- Question EN-3 (en, SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$You want to append content to a file, but you're not sure whether the file already exists. Which approach does the lesson recommend?$$, NULL, NULL,
           $$Passing StandardOpenOption.CREATE together with StandardOpenOption.APPEND works safely whether the file exists or not -- there is no need to check for existence first.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'file-writing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Use StandardOpenOption.APPEND by itself.$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Use StandardOpenOption.CREATE and StandardOpenOption.APPEND together.$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Rely on the default behavior of Files.writeString() with no extra options.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$First check with Files.exists(), and only then decide which option to pass.$$, FALSE, 3 FROM new_question_en3;

-- Question EN-4 (en, CODE_OUTPUT, BEGINNER)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$After this code runs, what will the file contain?$$,
           $$List<String> lines = List.of("Alpha", "Beta", "Gamma");
Files.write(path, lines);$$, $$java$$,
           $$Files.write(path, list) takes a List<String> and writes each element on its own line -- no need to manually add line separators.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'file-writing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Three lines: "Alpha", then "Beta", then "Gamma"$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$A single line: "AlphaBetaGamma"$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$A single line: "Alpha,Beta,Gamma"$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Only "Gamma" (the last element)$$, FALSE, 3 FROM new_question_en4;

-- Question EN-5 (en, CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What will the resulting file contain after this code runs?$$,
           $$try (BufferedWriter w = new BufferedWriter(new FileWriter(path.toFile()))) {
    w.write("Line1");
    w.write("Line2");
}$$, $$java$$,
           $$BufferedWriter.write() does not add a line separator by itself -- newLine() must be called explicitly for that. Without it, consecutive write() calls are simply concatenated.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'file-writing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Two separate lines: "Line1" and "Line2"$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$A single line: "Line1Line2"$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Only "Line2"$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$The code throws an exception because newLine() was never called.$$, FALSE, 3 FROM new_question_en5;

-- Question EN-6 (en, SINGLE_CHOICE, BEGINNER)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What happens when Files.copy(source, dest) is called and the destination file already exists?$$, NULL, NULL,
           $$By default, Files.copy() throws FileAlreadyExistsException if the destination already exists. StandardCopyOption.REPLACE_EXISTING makes it overwrite instead.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'file-writing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It throws FileAlreadyExistsException.$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It silently overwrites the destination.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It throws NoSuchFileException.$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It appends the source file's content to the destination.$$, FALSE, 3 FROM new_question_en6;

-- Question EN-7 (en, MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are best practices when writing files in Java, according to the lesson?$$, NULL, NULL,
           $$Using Files.writeString()/Files.write() for simple one-off writes, passing CREATE with APPEND when unsure if a file exists, and always adding REPLACE_EXISTING to Files.copy() when overwriting is intended are all lesson-stated best practices. Deleting a directory tree in natural (shallow-to-deep) order is the opposite of the recommended approach -- it fails on non-empty directories.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'file-writing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Use Files.writeString()/Files.write() for simple, one-off writes.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Pass StandardOpenOption.CREATE together with APPEND if you're unsure whether the file exists.$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Always add StandardCopyOption.REPLACE_EXISTING when calling Files.copy() if you want to overwrite the destination.$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Delete a directory tree by walking it in its natural, shallow-to-deep order.$$, FALSE, 3 FROM new_question_en7;

-- Question EN-8 (en, SINGLE_CHOICE, BEGINNER)
WITH new_question_en8 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What happens if you call Files.createDirectories() on a path where the directory already exists?$$, NULL, NULL,
           $$Files.createDirectories() creates a directory and any missing parent directories, like mkdir -p -- it does not fail if the directory already exists.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'file-writing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Nothing happens; no exception is thrown.$$, TRUE, 0 FROM new_question_en8
        UNION ALL SELECT id, $$It throws FileAlreadyExistsException.$$, FALSE, 1 FROM new_question_en8
        UNION ALL SELECT id, $$It deletes and recreates the directory.$$, FALSE, 2 FROM new_question_en8
        UNION ALL SELECT id, $$It throws an exception because the parent directories cannot be verified.$$, FALSE, 3 FROM new_question_en8;

-- Question TR-1 (tr, SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir dizin ağacını silerken Files.walk(dizin).sorted(Comparator.reverseOrder()) neden doğal sıralama yerine kullanılmalıdır?$$, NULL, NULL,
           $$Bir dizin, içindeki dosyalar/alt dizinler silinmeden silinemez. Bu yüzden Comparator.reverseOrder() ile en derindeki girişlerden başlanarak silme yapılmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'file-writing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir dizin, içindeki dosyalar/alt dizinler silinmeden silinemez; bu yüzden en derindeki girişler önce silinmelidir.$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Comparator.reverseOrder() silme işlemini doğal sıralamadan daha hızlı yapar.$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Files.walk() varsayılan olarak yalnızca ters sırada sonuç döner.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Doğal sıralama gizli dosyaları atlar.$$, FALSE, 3 FROM new_question_tr1;

-- Question TR-2 (tr, SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Derse göre, bir CSV dosyasının tüm satırlarını bir StringBuilder'da toplayıp TEK bir Files.writeString() çağrısıyla yazmak neden tercih edilir?$$, NULL, NULL,
           $$Tüm satırları bir StringBuilder'da toplayıp tek bir Files.writeString() çağrısıyla yazmak, her satır için ayrı bir yazma çağrısı yapmaktan daha verimlidir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'file-writing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her satır için ayrı bir yazma çağrısı yapmaktan daha verimlidir.$$, TRUE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Bu, doğru satır sonlarını garanti eden tek yöntemdir.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Files.writeString() bir dosya için birden fazla kez çağrılamaz.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Bu yöntem, dosyanın diskte daha az yer kaplamasını sağlar.$$, FALSE, 3 FROM new_question_tr2;

-- Question TR-3 (tr, CODE_OUTPUT, BEGINNER)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştırıldıktan sonra dosyanın içeriği ne olur?$$,
           $$Files.writeString(path, "First");
Files.writeString(path, "Second");$$, $$java$$,
           $$Files.writeString() aynı dosyaya art arda çağrıldığında, dosyada yalnızca son çağrının içeriği kalır -- üzerine yazma, biriktirme değildir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'file-writing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca "Second"$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$"First" ve ardından "Second" birleştirilmiş: "FirstSecond"$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca "First"$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$İki ayrı satır: "First" ve "Second"$$, FALSE, 3 FROM new_question_tr3;

-- Question TR-4 (tr, SINGLE_CHOICE, BEGINNER)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$BufferedWriter.newLine() metodu hakkında aşağıdakilerden hangisi doğrudur?$$, NULL, NULL,
           $$newLine() platforma uygun doğru satır sonunu kullanır: Linux/macOS'ta \n, Windows'ta \r\n.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'file-writing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her zaman "\n" karakterini ekler, platformdan bağımsızdır.$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Platforma uygun doğru satır sonu karakterini kullanır (Linux/macOS'ta \n, Windows'ta \r\n).$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca dosyanın son satırından sonra çağrılabilir.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$write() metodunu otomatik olarak çağırır.$$, FALSE, 3 FROM new_question_tr4;
