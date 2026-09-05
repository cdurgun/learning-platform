-- Promotion-style migration linking TR production-docker-for-java-applications quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/6 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'production-docker-for-java-applications')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir Dockerfile `HEALTHCHECK`'i Docker'ın gerçekte ne yapmasını sağlar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir Dockerfile `HEALTHCHECK`'i Docker'ın gerçekte ne yapmasını sağlar?$$,
           NULL, NULL,
           $$Ders, HEALTHCHECK'in Docker'a çalışan bir container'a gerçekten 'çalışıyor musun?' diye sormanın yolunu söylediğini belirtir -- container içinde periyodik olarak bir komut çalıştırır ve başarılı olup olmadığını takip eder; `docker ps` daha sonra yalnızca sürecin çökmediğini değil, bir container'ın sağlık durumunu (healthy/unhealthy/starting) gösterir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'production-docker-for-java-applications'
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
    ($$Bellek kullanımı yapılandırılmış bir eşiği her aştığında container'ı otomatik olarak yeniden başlatır$$, FALSE, 0),
    ($$Container'ın başladıktan sonra bir daha asla durdurulamamasını kalıcı olarak sağlar$$, FALSE, 1),
    ($$Bir container'ın çalışan replika sayısını otomatik olarak yukarı ya da aşağı ölçeklendirir$$, FALSE, 2),
    ($$Container içinde periyodik olarak bir komut çalıştırarak gerçekten çalışıp çalışmadığını kontrol eder, `docker ps`'te bir sağlık durumu olarak görünür$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'production-docker-for-java-applications'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'production-docker-for-java-applications')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, (`groupadd`/`useradd` ve `COPY --chown`'dan sonra) bir `USER appuser` talimatı eklemek gerçekte neyi değiştirir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, (`groupadd`/`useradd` ve `COPY --chown`'dan sonra) bir `USER appuser` talimatı eklemek gerçekte neyi değiştirir?$$,
           NULL, NULL,
           $$Ders, `USER appuser`'ın kendisinden sonraki her talimatı -- nihai ENTRYPOINT'in java süreci dahil -- root yerine o ayrıcalıksız kullanıcı olarak çalışacak şekilde değiştirdiğini belirtir; bu derinlemesine savunmadır, çünkü çalışan Java sürecinin ele geçirilmesi artık container içinde otomatik olarak root vermez.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'production-docker-for-java-applications'
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
    ($$Kendisinden sonraki her talimatı, nihai çalışan Java süreci dahil, root yerine ayrıcalıksız bir kullanıcı olarak çalışacak şekilde değiştirir$$, TRUE, 0),
    ($$Çalışma zamanında hiçbir etkisi yoktur -- yalnızca `docker inspect` çıktısında görüneni değiştirir$$, FALSE, 1),
    ($$Root kullanıcısını imajdan tamamen siler, root'u `docker exec` yoluyla bile kalıcı olarak erişilemez hale getirir$$, FALSE, 2),
    ($$O andan itibaren container'ın diske yazdığı tüm dosyaları otomatik olarak şifreler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'production-docker-for-java-applications'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'production-docker-for-java-applications')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'Basic Image Security Considerations'a göre, bir Dockerfile'da `ENV` ile ayarlanan gerçek bir sır (bir şifre gibi), o değer daha sonra 'değiştirilse' bile, ona ne olur?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$'Basic Image Security Considerations'a göre, bir Dockerfile'da `ENV` ile ayarlanan gerçek bir sır (bir şifre gibi), o değer daha sonra 'değiştirilse' bile, ona ne olur?$$,
           NULL, NULL,
           $$Ders, ENV ile ayarlanan ya da bir Dockerfile'da sabit kodlanan gerçek bir sırın, imajı çekebilen ya da inceleyebilen herkes tarafından okunabilir şekilde imajın kendi katmanlarının KALICI bir parçası olduğunu açıkça belirtir -- 'daha sonra kaldırılamaz'; sırlar bunun yerine `docker run`/`docker compose up` zamanında sağlanan ortam değişkenlerine aittir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'production-docker-for-java-applications'
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
    ($$İmaj içinde, ayrı bir şifre çözme anahtarı olmadan okunamayacak şekilde güvenli bir şekilde şifrelenir$$, FALSE, 0),
    ($$İmajı çekebilen ya da inceleyebilen herkes tarafından okunabilir şekilde, imajın kendi katmanlarının kalıcı bir parçası olur -- daha sonra kaldırılamaz$$, TRUE, 1),
    ($$Bir sonraki `docker build` çalıştığında imajdan otomatik olarak çıkarılır$$, FALSE, 2),
    ($$Yalnızca imaj açıkça Docker Hub gibi herkese açık bir registry'ye push edilirse okunabilir hale gelir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'production-docker-for-java-applications'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'production-docker-for-java-applications')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu multi-stage Dockerfile'ın builder aşaması göz önüne alındığında, `src/` içinde yalnızca tek bir Java dosyası değişirse (pom.xml'de hiçbir şey değişmezse) ve imaj yeniden inşa edilirse, hangi katman(lar) gerçekten yeniden çalışır?$$
      AND code_snippet = $$COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B package -DskipTests$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu multi-stage Dockerfile'ın builder aşaması göz önüne alındığında, `src/` içinde yalnızca tek bir Java dosyası değişirse (pom.xml'de hiçbir şey değişmezse) ve imaj yeniden inşa edilirse, hangi katman(lar) gerçekten yeniden çalışır?$$,
           $$COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B package -DskipTests$$, $$dockerfile$$,
           $$Ders, Docker'ın her katmanı önbelleğe aldığını ve o katmanın bağlı olduğu hiçbir şey değişmediği sürece onu yeniden kullandığını açıklar -- yalnızca src/ içindeki bir dosya değişip pom.xml değişmediği için, `COPY pom.xml .` ve `RUN mvn dependency:go-offline` katmanları önbellekten yeniden kullanılır, ve yalnızca `COPY src ./src` ve ondan sonraki her şey yeniden çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'production-docker-for-java-applications'
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
    ($$Hiçbir şey yeniden çalışmaz -- Docker, ilk inşa edildiğinde tüm builder aşamasını kalıcı olarak önbelleğe alınmış sayar$$, FALSE, 0),
    ($$Yalnızca `RUN mvn -B dependency:go-offline` yeniden çalışır, çünkü Java kaynak dosyalarını derlemekten sorumlu katman odur$$, FALSE, 1),
    ($$Yalnızca `COPY src ./src` ve `RUN mvn -B package -DskipTests` yeniden çalışır -- pom.xml kopyalama ve bağımlılık indirme önbellekten yeniden kullanılır$$, TRUE, 2),
    ($$Dört talimatın hepsi sıfırdan yeniden çalışır, pom.xml'in bildirdiği her bağımlılığın yeniden indirilmesi dahil$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'production-docker-for-java-applications'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'production-docker-for-java-applications')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir Compose `db` servisine bir `healthcheck:` eklemek, Compose'un `app`'i başlatmadan önce onu otomatik olarak beklemesini sağlar mı?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir Compose `db` servisine bir `healthcheck:` eklemek, Compose'un `app`'i başlatmadan önce onu otomatik olarak beklemesini sağlar mı?$$,
           NULL, NULL,
           $$Ders, tek başına bir HEALTHCHECK/healthcheck'in yalnızca görünürlük (docker ps durumu) sağladığını belirtir -- Compose'un bağımlı servisi başlatmadan önce healthcheck'in başarılı olmasını gerçekten beklemesini sağlayan şey, uzun biçimli `depends_on: db: condition: service_healthy`'dir; bir healthcheck eklemek ama onu `condition: service_healthy` ile hiç referans vermemek açıkça yaygın bir hata olarak adlandırılır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'production-docker-for-java-applications'
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
    ($$Evet -- bir serviste tanımlanan herhangi bir `healthcheck:`, aynı dosyadaki her diğer servis tarafından otomatik olarak beklenir$$, FALSE, 0),
    ($$Evet, ama yalnızca servis özellikle `db` olarak adlandırılmışsa -- başka herhangi bir ad Compose tarafından tamamen yok sayılır$$, FALSE, 1),
    ($$Bu ders, `healthcheck:` ile `depends_on` arasında hiçbir ilişkiyi ele almaz$$, FALSE, 2),
    ($$Hayır -- tek başına bir healthcheck yalnızca görünürlük sağlar; `app`'in onu gerçekten beklemesini sağlayan `depends_on: db: condition: service_healthy`'dir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'production-docker-for-java-applications'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'production-docker-for-java-applications')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, Java uygulamaları için production Docker pratikleri hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Java uygulamaları için production Docker pratikleri hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir ('Basic Image Security Considerations'ın, 'Docker CLI Fundamentals'ta zaten ele alınan, `:latest` değil kesin tag'leri sabitlemenin production'da da aynı derecede geçerli olduğunu önermesi; aynı bölümün, temel imajı ve üzerine kurulanları minimal tutmayı, eklenen her paketi gerekçelendirmeyi önermesi); ders, `COPY src ./src`'i bağımlılık-indirme adımından önceye almanın Docker'ın layer-caching davranışını iyileştirdiğini iddia etmez (bunun aksine, layer-caching faydasını sessizce bozduğu açıkça adlandırılır), ve `pg_isready`'nin bu dersin yazarlarının PostgreSQL hazır olma durumunu kontrol etmek için sıfırdan yazdığı özel bir betik değil, resmi `postgres` imajı içinde zaten kurulu gerçek bir araç olduğu tanımlanır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'production-docker-for-java-applications'
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
    ($$'Docker CLI Fundamentals'ta zaten ele alınan, kesin imaj tag'lerini sabitlemek (asla `:latest` değil) pratiğinin production'da da aynı derecede geçerli olduğu belirtilir$$, TRUE, 0),
    ($$Temel imajı ve üzerine kurulanları minimal tutmak -- eklenen her paketi gerekçelendirmek -- bu dersin temel imaj güvenliği değerlendirmelerinden biridir$$, TRUE, 1),
    ($$Bir multi-stage Dockerfile'ı, `COPY src ./src` bağımlılık-indirme adımından önce gerçekleşecek şekilde yeniden sıralamak Docker'ın layer-caching davranışını iyileştirir$$, FALSE, 2),
    ($$Compose `healthcheck` örneğinde kullanılan `pg_isready`, bu dersin PostgreSQL'in hazır olma durumunu kontrol etmek için özellikle yazdığı özel bir betiktir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'production-docker-for-java-applications'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
