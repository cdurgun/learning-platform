-- Promotion-style migration linking TR spring-ioc-container quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-ioc-container')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır? (AppConfig'in `new Bilesen()` döndüren bir @Bean metodu olduğunu varsayın.)$$
      AND code_snippet = $$class Bilesen {
    Bilesen() { System.out.println("Bilesen olusturuldu"); }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println("context oncesi");
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        System.out.println("context sonrasi");
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır? (AppConfig'in `new Bilesen()` döndüren bir @Bean metodu olduğunu varsayın.)$$,
           $$class Bilesen {
    Bilesen() { System.out.println("Bilesen olusturuldu"); }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println("context oncesi");
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        System.out.println("context sonrasi");
    }
}$$, $$java$$,
           $$ApplicationContext, singleton bean'leri lazy değil, context inşa edilir edilmez eager olarak oluşturur -- bu yüzden Bilesen'in constructor'ı, AnnotationConfigApplicationContext'in kendi inşası sırasında, "context sonrasi" yazdırılmadan önce çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-ioc-container'
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
    ($$context oncesi / context sonrasi (Bilesen hiç oluşturulmaz, çünkü getBean hiç çağrılmadı)$$, FALSE, 0),
    ($$context oncesi / Bilesen olusturuldu / context sonrasi$$, TRUE, 1),
    ($$context oncesi / context sonrasi / Bilesen olusturuldu$$, FALSE, 2),
    ($$Bilesen olusturuldu / context oncesi / context sonrasi$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-ioc-container'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-ioc-container')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`BeanFactory`'nin "lazy" olması ne anlama gelir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`BeanFactory`'nin "lazy" olması ne anlama gelir?$$,
           NULL, NULL,
           $$Bir bean tanımı kaydetmek nesneyi oluşturmaz -- nesne yalnızca getBean(...) ile gerçekten istendiğinde oluşturulur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-ioc-container'
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
    ($$BeanFactory, bean tanımlarını okumayı uygulama kapanana kadar erteler.$$, FALSE, 0),
    ($$BeanFactory her bean'i iki kez oluşturur, biri lazy biri eager.$$, FALSE, 1),
    ($$BeanFactory hiçbir zaman gerçekten hiçbir nesne oluşturmaz.$$, FALSE, 2),
    ($$Bir bean tanımı kaydetmek nesneyi oluşturmaz -- nesne yalnızca getBean(...) ile gerçekten istendiğinde oluşturulur.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-ioc-container'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-ioc-container')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir bean'in lifecycle adımlarının doğru sırası nedir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir bean'in lifecycle adımlarının doğru sırası nedir?$$,
           NULL, NULL,
           $$Sıra şöyledir: constructor çalışır, bağımlılıklar ayarlanır, BeanPostProcessor (before) çalışır, @PostConstruct çalışır, sonra BeanPostProcessor (after) çalışır ve bean hazır olur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-ioc-container'
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
    ($$BeanPostProcessor (after) -> Constructor çalışır -> bağımlılıklar ayarlanır -> @PostConstruct.$$, FALSE, 0),
    ($$Constructor çalışır -> bağımlılıklar ayarlanır -> BeanPostProcessor (before) -> @PostConstruct -> BeanPostProcessor (after) -> kullanıma hazır.$$, TRUE, 1),
    ($$@PostConstruct -> Constructor çalışır -> bağımlılıklar ayarlanır -> kullanıma hazır.$$, FALSE, 2),
    ($$Constructor çalışır -> @PostConstruct -> bağımlılıklar ayarlanır -> kullanıma hazır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-ioc-container'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-ioc-container')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu ders, `InitializingBean`/`DisposableBean` implement etmek yerine `@PostConstruct`/`@PreDestroy`'u neden önerir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu ders, `InitializingBean`/`DisposableBean` implement etmek yerine `@PostConstruct`/`@PreDestroy`'u neden önerir?$$,
           NULL, NULL,
           $$Annotation tabanlı yaklaşım, sınıfı Spring'e bağımlı hale getirmeden aynı garantiyi verir, çünkü bu annotation'lar Spring'in kendisinden değil jakarta.annotation'dan gelir -- InitializingBean/DisposableBean implement eden bir sınıf, container classpath'te olmadan derlenmez bile.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-ioc-container'
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
    ($$InitializingBean/DisposableBean deprecated'dır ve artık derlenmez.$$, FALSE, 0),
    ($$@PostConstruct/@PreDestroy, interface tabanlı yaklaşımdan lifecycle'da daha erken çalışır.$$, FALSE, 1),
    ($$InitializingBean/DisposableBean yalnızca prototype scope'lu bean'lerle çalışır.$$, FALSE, 2),
    ($$Annotation tabanlı yaklaşım, sınıfı Spring'e bağımlı hale getirmeden aynı garantiyi verir, çünkü bu annotation'lar Spring'in kendisinden değil jakarta.annotation'dan gelir.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-ioc-container'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-ioc-container')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır? (`Sayac`'ın hiç @Scope belirtilmeden düz bir @Bean olarak kaydedildiğini, yani varsayılan scope'ta olduğunu varsayın.)$$
      AND code_snippet = $$class Sayac {
    private int deger = 0;
    void artir() { deger++; }
    int getDeger() { return deger; }
}

public class Ornek {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        Sayac birinci = context.getBean(Sayac.class);
        Sayac ikinci = context.getBean(Sayac.class);
        birinci.artir();
        System.out.println(birinci.getDeger() == ikinci.getDeger());
    }
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır? (`Sayac`'ın hiç @Scope belirtilmeden düz bir @Bean olarak kaydedildiğini, yani varsayılan scope'ta olduğunu varsayın.)$$,
           $$class Sayac {
    private int deger = 0;
    void artir() { deger++; }
    int getDeger() { return deger; }
}

public class Ornek {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        Sayac birinci = context.getBean(Sayac.class);
        Sayac ikinci = context.getBean(Sayac.class);
        birinci.artir();
        System.out.println(birinci.getDeger() == ikinci.getDeger());
    }
}$$, $$java$$,
           $$Varsayılan scope (hiç @Scope belirtilmezse) singleton'dır -- container başına bir instance. birinci ve ikinci aynı nesneyi işaret eder, bu yüzden birinci'yi artırmak ikinci'nin gördüğü değeri de değiştirir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-ioc-container'
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
    ($$Sayac'ın açık bir constructor'ı olmadığı için istisna fırlatır.$$, FALSE, 0),
    ($$true$$, TRUE, 1),
    ($$false$$, FALSE, 2),
    ($$Derleme hatası.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-ioc-container'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-ioc-container')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir singleton bean tanımına `@Lazy` koymak neyi değiştirir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir singleton bean tanımına `@Lazy` koymak neyi değiştirir?$$,
           NULL, NULL,
           $$Bean, context refresh olduğunda değil, yalnızca getBean(...) ile gerçekten ilk istendiğinde oluşturulur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-ioc-container'
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
    ($$Bean, singleton yerine prototype scope'lu hale gelir.$$, FALSE, 0),
    ($$Bean'in @PreDestroy metodu başlangıçta hemen çağrılır.$$, FALSE, 1),
    ($$Bean iki kez oluşturulur -- biri lazy biri eager.$$, FALSE, 2),
    ($$Bean, context refresh olduğunda değil, yalnızca getBean(...) ile gerçekten ilk istendiğinde oluşturulur.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-ioc-container'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-ioc-container')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$İki constructor-injected bean arasındaki bir circular dependency, bir BeanCreationException içine sarılmış BeanCurrentlyInCreationException ile sonuçlanır. Aynı türden iki bean tanımlayıp getBean(Type.class) çağırmak, container hiçbir zaman tahmin etmediği için NoUniqueBeanDefinitionException fırlatır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-ioc-container'
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
    ($$NoUniqueBeanDefinitionException yalnızca prototype scope'lu bean'lerde oluşur.$$, FALSE, 0),
    ($$İki constructor-injected bean arasındaki bir circular dependency, bir BeanCreationException içine sarılmış bir BeanCurrentlyInCreationException ile sonuçlanır.$$, TRUE, 1),
    ($$Aynı interface türünden iki bean tanımlamak ve getBean(Type.class) çağırmak, container hiçbir zaman hangisini istediğini tahmin etmediği için NoUniqueBeanDefinitionException fırlatır.$$, TRUE, 2),
    ($$Container, bir circular dependency'yi hangi bean önce tanımlandıysa onu seçerek otomatik olarak çözer.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-ioc-container'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
