-- enum quiz'i için şıklar — her soruya 4 şık (1 doğru, 3 yanlış).
-- quiz_question'a (topic slug, language, sort_order) üçlüsüyle bağlanır,
-- diğer tüm migration'larda kullanılan "hardcoded id yok, subquery ile bul" kuralıyla tutarlı.

-- Soru 1 (TR) — Enum vs String
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Derleme zamanında tip güvenliği sağlar — geçersiz bir değer çalışma zamanında değil derleyici tarafından yakalanır.', true, 1
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 1;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Enum''lar string''lerden daha az bellek kullanır.', false, 2
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 1;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Enum sabitleri çalışma zamanında değiştirilebilir, string''ler değiştirilemez.', false, 3
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 1;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Enum''lar birden fazla sınıftan kalıtım almayı destekler.', false, 4
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 1;

-- Soru 1 (EN) — Enum vs String
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'It provides compile-time type safety — an invalid value is caught by the compiler instead of at runtime.', true, 1
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 1;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Enums use less memory than strings.', false, 2
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 1;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Enum constants can be changed at runtime, unlike strings.', false, 3
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 1;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Enums support multiple inheritance from several classes.', false, 4
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 1;

-- Soru 2 (TR) — Constructor erişim belirleyicisi
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Yalnızca private ya da paket-private (varsayılan).', true, 1
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 2;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'public', false, 2
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 2;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'protected', false, 3
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 2;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Kullanım amacına göre public ya da protected.', false, 4
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 2;

-- Soru 2 (EN) — Constructor access modifier
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Only private or package-private (default).', true, 1
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 2;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'public', false, 2
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 2;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'protected', false, 3
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 2;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'public or protected, depending on the use case.', false, 4
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 2;

-- Soru 3 (TR) — ordinal() kalıcı veri olarak saklanmamalı
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Sabitlerin sırası değişirse ya da araya yeni bir sabit eklenirse, ordinal değerleri sessizce kayar ve önceden kaydedilmiş verinin anlamı bozulur.', true, 1
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 3;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Çünkü ordinal() kalıcı hale getirildiğinde exception fırlatır.', false, 2
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 3;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Çünkü ordinal() serileştirilemez (Serializable değildir).', false, 3
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 3;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Çünkü ordinal() yalnızca aynı JVM oturumunda geçerlidir.', false, 4
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 3;

-- Soru 3 (EN) — don't persist ordinal()
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'If the order of constants changes or a new constant is inserted, ordinal values silently shift, corrupting the meaning of previously stored data.', true, 1
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 3;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Because ordinal() throws an exception when persisted.', false, 2
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 3;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Because ordinal() is not Serializable.', false, 3
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 3;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Because ordinal() is only valid within the same JVM session.', false, 4
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 3;

-- Soru 4 (TR) — values() performansı
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Her çağrıldığında yeni bir dizi (array) kopyalar.', true, 1
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 4;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Her çağrıldığında bir veritabanı sorgusu tetikler.', false, 2
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 4;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Thread''leri senkronize eder ve diğer thread''leri bloklar.', false, 3
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 4;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Enum''ın static initializer''ını her seferinde yeniden çalıştırır.', false, 4
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 4;

-- Soru 4 (EN) — values() performance
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'It copies a new array every time it is called.', true, 1
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 4;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'It triggers a database query on every call.', false, 2
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 4;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'It synchronizes threads and blocks other threads.', false, 3
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 4;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'It re-runs the enum''s static initializer every time.', false, 4
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 4;

-- Soru 5 (TR) — enum'ın kalıtım/interface ilişkisi
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Bir enum örtük olarak java.lang.Enum''ı extend eder, bu yüzden başka bir sınıfı extend edemez — ama istediği kadar arayüz implement edebilir.', true, 1
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 5;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Bir enum, Enum''a ek olarak bir sınıfı daha extend edebilir.', false, 2
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 5;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Bir enum hiçbir arayüz implement edemez.', false, 3
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 5;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'Bir enum birden fazla sınıftan kalıtım alabilir.', false, 4
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'tr' AND q.sort_order = 5;

-- Soru 5 (EN) — enum's inheritance/interface relationship
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'An enum implicitly extends java.lang.Enum, so it cannot extend any other class — but it can implement as many interfaces as it wants.', true, 1
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 5;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'An enum can extend one additional class besides Enum.', false, 2
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 5;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'An enum cannot implement any interfaces.', false, 3
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 5;
INSERT INTO quiz_option (question_id, option_text, is_correct, sort_order)
SELECT q.id, 'An enum can inherit from multiple classes.', false, 4
FROM quiz_question q JOIN topic t ON t.id = q.topic_id WHERE t.slug = 'enum' AND q.language = 'en' AND q.sort_order = 5;
