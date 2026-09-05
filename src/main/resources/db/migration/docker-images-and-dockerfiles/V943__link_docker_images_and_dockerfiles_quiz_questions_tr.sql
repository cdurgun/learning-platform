-- Promotion-style migration linking TR docker-images-and-dockerfiles quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-images-and-dockerfiles')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir Dockerfile nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir Dockerfile nedir?$$,
           NULL, NULL,
           $$Ders, bir Dockerfile'ı, geleneksel olarak uzantısız tam olarak 'Dockerfile' adlandırılan, Docker'ın bir imaj üretmek için sırayla çalıştırdığı bir dizi talimat içeren düz metin dosyası olarak tanımlar -- her talimat, öncekinin üzerine yeni, önbelleğe alınmış bir katman ekler.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-images-and-dockerfiles'
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
    ($$Docker'ın bir imaj üretmek için sırayla çalıştırdığı, her biri yeni önbelleğe alınmış bir katman ekleyen bir dizi talimat içeren düz metin dosyası$$, TRUE, 0),
    ($$Docker'ın herhangi bir build adımı olmadan doğrudan bir container olarak çalıştırdığı derlenmiş bir ikili dosya$$, FALSE, 1),
    ($$Yalnızca bir container başladıktan sonra ağ ayarlarını belirlemek için kullanılan bir yapılandırma dosyası$$, FALSE, 2),
    ($$Bir Spring Boot uygulamasının ihtiyaç duyduğu Maven bağımlılıklarını listeleyen bir JSON dosyası$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-images-and-dockerfiles'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-images-and-dockerfiles')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu ders, minimal web server örneği için `FROM` temel imajı olarak neden `alpine:3.20`'yi seçiyor?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu ders, minimal web server örneği için `FROM` temel imajı olarak neden `alpine:3.20`'yi seçiyor?$$,
           NULL, NULL,
           $$Ders, Alpine Linux'un özellikle yaygın bir temel olmasının nedeninin, gerçek, minimal bir Linux dağıtımı olması (yalnızca birkaç megabayt), ve ihtiyaç duyulan başka her şey için bir paket yöneticisine (`apk`) sahip olması olduğunu belirtir -- kullanılmayan araçları olan genel amaçlı bir OS imajı yerine kasıtlı olarak küçük bir başlangıç noktası.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-images-and-dockerfiles'
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
    ($$Özellikle örnek sunucu Java ile yazıldığı için gereklidir$$, FALSE, 0),
    ($$Gerçek, minimal bir Linux dağıtımıdır (yalnızca birkaç megabayt), ihtiyaç duyulan başka her şey için bir paket yöneticisine sahiptir -- kasıtlı olarak küçük bir başlangıç noktası$$, TRUE, 1),
    ($$`FROM` talimatı için Docker'ın resmi olarak desteklediği tek temel imajdır$$, FALSE, 2),
    ($$Diğer hiçbir temel imajın aksine, zaten tam bir JDK ve Maven ile önceden kurulmuş gelir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-images-and-dockerfiles'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-images-and-dockerfiles')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`WORKDIR /app` ne yapar, ve hiç ayarlanmazsa `COPY` gibi sonraki talimatlara ne olur?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`WORKDIR /app` ne yapar, ve hiç ayarlanmazsa `COPY` gibi sonraki talimatlara ne olur?$$,
           NULL, NULL,
           $$Ders, WORKDIR'ın (gerekirse oluşturarak) sonraki her talimatın göreceli olarak çalışacağı dizini ayarladığını belirtir; bu olmadan, COPY ve RUN gibi sonraki talimatlar imajın dosya sistemi kökünde göreceli olarak çalışır -- teknik olarak geçerlidir, ama uygulamanın dosyalarını temel imajın kendi sistem dizinleriyle karıştırır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-images-and-dockerfiles'
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
    ($$Temel imaj içindeki verilen yolda zaten mevcut olan dosyaları kalıcı olarak siler$$, FALSE, 0),
    ($$Çalışan container'ın uygulama kodunun çalışma zamanında okuyabileceği bir ortam değişkeni ayarlar$$, FALSE, 1),
    ($$Sonraki talimatların göreceli olarak çalışacağı dizini ayarlar; bu olmadan, COPY/RUN dosya sistemi kökünde çalışır, uygulama dosyalarını sistem dizinleriyle karıştırır$$, TRUE, 2),
    ($$Hiçbir işlevsel etkisi yoktur -- yalnızca Dockerfile'ı okuyan insanlar için bir yorum olarak var olur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-images-and-dockerfiles'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-images-and-dockerfiles')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir Dockerfile'daki `COPY` talimatı dosyaları nereden okuyabilir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir Dockerfile'daki `COPY` talimatı dosyaları nereden okuyabilir?$$,
           NULL, NULL,
           $$Ders, COPY'nin build context'ten -- `docker build`'un çalıştırıldığı klasörden -- bir dosyayı ya da dizini imaja getirdiğini belirtir; yalnızca host makinedeki build context'ten okur ve onun dışına asla ulaşamaz, bu da tam olarak `docker build`'un imajın ihtiyaç duyduğu her şeyi içeren klasörden çalıştırılması gerekmesinin nedenidir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-images-and-dockerfiles'
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
    ($$`docker build`'un nereden çalıştırıldığından bağımsız olarak, host makinenin dosya sisteminde herhangi bir yerden$$, FALSE, 0),
    ($$Yalnızca `FROM` ile belirtilen temel imaj içinde zaten mevcut olan dosyalardan$$, FALSE, 1),
    ($$Herhangi bir yerel dosyaya ihtiyaç duymadan, doğrudan uzak bir Git repository URL'inden$$, FALSE, 2),
    ($$Yalnızca build context'ten -- `docker build`'un çalıştırıldığı klasörden -- ve onun dışına asla ulaşamaz$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-images-and-dockerfiles'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-images-and-dockerfiles')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Yalnızca `CMD ["echo", "Merhaba CMD'den"]` ayarlayan (ENTRYPOINT olmayan) bir Dockerfile göz önüne alındığında, `docker run benim-imajim echo "Gecersiz Kilindi"` çalıştırmak ne yazdırır?$$
      AND code_snippet = $$docker run benim-imajim
# Cikti: Merhaba CMD'den

docker run benim-imajim echo "Gecersiz Kilindi"
# Cikti: Gecersiz Kilindi$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Yalnızca `CMD ["echo", "Merhaba CMD'den"]` ayarlayan (ENTRYPOINT olmayan) bir Dockerfile göz önüne alındığında, `docker run benim-imajim echo "Gecersiz Kilindi"` çalıştırmak ne yazdırır?$$,
           $$docker run benim-imajim
# Cikti: Merhaba CMD'den

docker run benim-imajim echo "Gecersiz Kilindi"
# Cikti: Gecersiz Kilindi$$, $$bash$$,
           $$Ders, yalnızca CMD varken, docker run'a verilen herhangi bir komutun onu TAMAMEN DEĞİŞTİRDİĞİNİ belirtir -- bu yüzden ekstra argüman olarak `echo "Gecersiz Kilindi"` vermek tüm CMD'yi değiştirir, ve container tam olarak gösterildiği gibi "Gecersiz Kilindi" yazdırır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-images-and-dockerfiles'
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
    ($$Gecersiz Kilindi$$, TRUE, 0),
    ($$Merhaba CMD'den$$, FALSE, 1),
    ($$Merhaba CMD'den
Gecersiz Kilindi  (her iki satır da, biri diğerinden sonra yazdırılır)$$, FALSE, 2),
    ($$Bir hata, çünkü yalnızca CMD ayarlıyken `docker run` ekstra argüman kabul edemez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-images-and-dockerfiles'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-images-and-dockerfiles')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`ENTRYPOINT ["echo"]` ve `CMD ["Merhaba CMD'den"]` olan bir Dockerfile göz önüne alındığında, `docker run benim-imajim "Gecersiz Kilindi"` çalıştırmak ne yazdırır?$$
      AND code_snippet = $$docker run benim-imajim
# Cikti: Merhaba CMD'den

docker run benim-imajim "Gecersiz Kilindi"
# Cikti: Gecersiz Kilindi$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`ENTRYPOINT ["echo"]` ve `CMD ["Merhaba CMD'den"]` olan bir Dockerfile göz önüne alındığında, `docker run benim-imajim "Gecersiz Kilindi"` çalıştırmak ne yazdırır?$$,
           $$docker run benim-imajim
# Cikti: Merhaba CMD'den

docker run benim-imajim "Gecersiz Kilindi"
# Cikti: Gecersiz Kilindi$$, $$bash$$,
           $$Ders, ENTRYPOINT ayarlıyken her zaman çalıştığını açıklar -- CMD, docker run'ın entrypoint'in kendisine dokunmadan geçersiz kılabileceği varsayılan argümanlarını sağlar. Bu yüzden `"Gecersiz Kilindi"` yalnızca varsayılan CMD argümanını değiştirir, `echo "Gecersiz Kilindi"` üretir, bu da tamamen farklı bir komut değil, "Gecersiz Kilindi" yazdırır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-images-and-dockerfiles'
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
    ($$Gecersiz Kilindi iki kez yazdırılır, biri ENTRYPOINT için biri geçersiz kılan argüman için$$, FALSE, 0),
    ($$Gecersiz Kilindi -- entrypoint (`echo`) hâlâ her zaman çalışır, yalnızca varsayılan CMD argümanı değiştirilir$$, TRUE, 1),
    ($$Merhaba CMD'den -- ENTRYPOINT argümanları hiçbir koşulda docker run tarafından geçersiz kılınamaz$$, FALSE, 2),
    ($$Bir hata, çünkü ENTRYPOINT ve CMD aynı Dockerfile'da birlikte bulunamaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-images-and-dockerfiles'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-images-and-dockerfiles')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, Dockerfile talimatları ve `docker build` hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Dockerfile talimatları ve `docker build` hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (RUN'ın imaj inşa edilirken bir komut çalıştırması ve diskte değiştirdiği her şeyin ortaya çıkan imajın kalıcı bir parçası olması; EXPOSE'un yapılandırma değil dokümantasyon olması -- kendi başına bir portu yayınlamaması, bunu docker run üzerindeki `-p`'nin yapması); `docker build -t`'nin imajı bir repository adı ve tag ile etiketlemesi, arka planda çalışmak için `-d` bayrağına ihtiyaç duymaması (bu bir `docker run` kavramıdır, build değil), ve build context'in `docker build`'a geçirilen dizin olması, farklıysa Dockerfile'ın kendisinin bulunduğu dizin otomatik olarak değil.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-images-and-dockerfiles'
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
    ($$`docker build -t <ad>:<tag> .`, build sürecini arka planda çalıştırmak için her zaman bir `-d` bayrağıyla çalıştırılmalıdır$$, FALSE, 0),
    ($$`docker build`'un kullandığı build context, build komutunun argümanı olarak açıkça farklı bir dizin geçirilse bile otomatik olarak Dockerfile'ı içeren dizindir$$, FALSE, 1),
    ($$`RUN`, imaj inşa edilirken bir komut çalıştırır, ve diskte değiştirdiği her şey ortaya çıkan imajın kalıcı bir parçası olur$$, TRUE, 2),
    ($$`EXPOSE` yapılandırma değil dokümantasyondur -- kendi başına bir portu host makineye gerçekten yayınlamaz$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-images-and-dockerfiles'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
