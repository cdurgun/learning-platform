-- Promotion-style migration linking TR autoconfiguration-properties quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'autoconfiguration-properties')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Component scanning tek başına neden `DataSource` ya da `EntityManagerFactory` gibi bir bean'i kaydedemez?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Component scanning tek başına neden `DataSource` ya da `EntityManagerFactory` gibi bir bean'i kaydedemez?$$,
           NULL, NULL,
           $$Bunlar, uygulamanın kaynak koduna sahip olmadığı üçüncü parti kütüphane sınıflarıdır, bu yüzden onlara @Component eklenemez -- auto-configuration tam olarak bu durumu ele almak için vardır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'autoconfiguration-properties'
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
    ($$Bu bean'ler taranabilmek için bir veritabanı bağlantısı gerektirir.$$, FALSE, 0),
    ($$Bunlar, uygulamanın kaynak koduna sahip olmadığı üçüncü parti kütüphane sınıflarıdır, bu yüzden onlara @Component eklenemez.$$, TRUE, 1),
    ($$DataSource ve EntityManagerFactory, hiçbir koşulda örneklenemeyen abstract sınıflardır.$$, FALSE, 2),
    ($$Component scanning yalnızca tam olarak bir constructor parametresi olan sınıflarla çalışır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'autoconfiguration-properties'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'autoconfiguration-properties')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`@SpringBootApplication`, aslında hangi üç annotation'ın birleşimidir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`@SpringBootApplication`, aslında hangi üç annotation'ın birleşimidir?$$,
           NULL, NULL,
           $$@SpringBootApplication, @SpringBootConfiguration, @EnableAutoConfiguration ve @ComponentScan'i birleştirir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'autoconfiguration-properties'
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
    ($$@Configuration, @Bean ve @Autowired.$$, FALSE, 0),
    ($$@Component, @Service ve @Repository.$$, FALSE, 1),
    ($$@Conditional, @ConditionalOnClass ve @ConditionalOnMissingBean.$$, FALSE, 2),
    ($$@SpringBootConfiguration, @EnableAutoConfiguration ve @ComponentScan.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'autoconfiguration-properties'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'autoconfiguration-properties')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu iki bean tanımında ne olur? (`ObjectMapper`'ın `spring-boot-starter-web` üzerinden gerçekten classpath'te olduğunu varsayın.)$$
      AND code_snippet = $$@Configuration
class BenimAutoConfigurationim {
    @Bean
    @ConditionalOnClass(name = "com.fasterxml.jackson.databind.ObjectMapper")
    JacksonYardimcisi jacksonYardimcisi() { return new JacksonYardimcisi(); }

    @Bean
    @ConditionalOnClass(name = "com.uydurma.OlmayanKutuphane")
    SahteYardimci sahteYardimci() { return new SahteYardimci(); }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu iki bean tanımında ne olur? (`ObjectMapper`'ın `spring-boot-starter-web` üzerinden gerçekten classpath'te olduğunu varsayın.)$$,
           $$@Configuration
class BenimAutoConfigurationim {
    @Bean
    @ConditionalOnClass(name = "com.fasterxml.jackson.databind.ObjectMapper")
    JacksonYardimcisi jacksonYardimcisi() { return new JacksonYardimcisi(); }

    @Bean
    @ConditionalOnClass(name = "com.uydurma.OlmayanKutuphane")
    SahteYardimci sahteYardimci() { return new SahteYardimci(); }
}$$, $$java$$,
           $$@ConditionalOnClass, yalnızca verilen sınıf classpath'teyse bir bean'i kaydeder. ObjectMapper gerçekten mevcuttur, bu yüzden jacksonYardimcisi kaydedilir; OlmayanKutuphane mevcut değildir, bu yüzden sahteYardimci hiçbir istisna fırlatılmadan sessizce atlanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'autoconfiguration-properties'
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
    ($$Hiçbir bean kaydedilmez, çünkü @ConditionalOnClass ayrıca @ConditionalOnMissingBean de gerektirir.$$, FALSE, 0),
    ($$jacksonYardimcisi bir bean olarak kaydedilir; sahteYardimci, hiçbir istisna fırlatılmadan sessizce atlanır.$$, TRUE, 1),
    ($$İki bean de normal şekilde kaydedilir.$$, FALSE, 2),
    ($$Uygulama, SahteYardimci için bir ClassNotFoundException ile başlayamaz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'autoconfiguration-properties'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'autoconfiguration-properties')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu iki config aynı anda mevcutken, container hangi `ObjectMapper` bean'ini kullanır?$$
      AND code_snippet = $$class ObjectMapperOtoYapilandirmasi {
    @Bean
    @ConditionalOnMissingBean
    ObjectMapper objectMapper() { return new ObjectMapper(); }
}

@Configuration
class BenimUygulamaConfigim {
    @Bean
    ObjectMapper objectMapper() { return new ObjectMapper().findAndRegisterModules(); }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu iki config aynı anda mevcutken, container hangi `ObjectMapper` bean'ini kullanır?$$,
           $$class ObjectMapperOtoYapilandirmasi {
    @Bean
    @ConditionalOnMissingBean
    ObjectMapper objectMapper() { return new ObjectMapper(); }
}

@Configuration
class BenimUygulamaConfigim {
    @Bean
    ObjectMapper objectMapper() { return new ObjectMapper().findAndRegisterModules(); }
}$$, $$java$$,
           $$Auto-configuration sınıfları her zaman uygulamanın kendi @Configuration sınıflarından SONRA işlenir, bu yüzden ObjectMapperOtoYapilandirmasi'nin @ConditionalOnMissingBean'i değerlendirildiğinde BenimUygulamaConfigim'in ObjectMapper bean'i zaten mevcuttur -- auto-configuration varsayılanı atlanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'autoconfiguration-properties'
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
    ($$Auto-configuration'ın varsayılan ObjectMapper'ı -- @ConditionalOnMissingBean her zaman kullanıcının kendi bean'ine karşı kazanır.$$, FALSE, 0),
    ($$Uygulama, iki ObjectMapper bean'i tanımlandığı için NoUniqueBeanDefinitionException ile başlayamaz.$$, FALSE, 1),
    ($$İki bean tek bir birleşik ObjectMapper'da birleştirilir.$$, FALSE, 2),
    ($$BenimUygulamaConfigim'in kendi ObjectMapper bean'i -- auto-configuration'ın varsayılanı atlanır, çünkü o türden bir bean zaten var.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'autoconfiguration-properties'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'autoconfiguration-properties')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`@Value` ve `@ConfigurationProperties` hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`@Value` ve `@ConfigurationProperties` hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$@Value, hiçbir gruplama olmadan tek bir property'yi enjekte eder; @ConfigurationProperties, aynı prefix'i paylaşan tüm bir property ailesini tek, tipli bir nesneye bağlar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'autoconfiguration-properties'
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
    ($$@ConfigurationProperties yalnızca sayısal property değerleri için kullanılabilir, string'ler için asla kullanılamaz.$$, FALSE, 0),
    ($$@Value, hiçbir gruplama olmadan tek bir property'yi enjekte eder.$$, TRUE, 1),
    ($$@ConfigurationProperties, aynı prefix'i paylaşan tüm bir property ailesini tek, tipli bir nesneye bağlar.$$, TRUE, 2),
    ($$@Value, tıpkı @ConfigurationProperties gibi, ilgili property'lerin tüm bir grubunu tek bir nesneye bağlayabilir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'autoconfiguration-properties'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'autoconfiguration-properties')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$En yüksekten en düşüğe, Spring Boot'un ana property kaynaklarının doğru öncelik sırası nedir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$En yüksekten en düşüğe, Spring Boot'un ana property kaynaklarının doğru öncelik sırası nedir?$$,
           NULL, NULL,
           $$En yüksekten en düşüğe: komut satırı argümanları, ortam değişkenleri, application-{profile}.yml, ve en altta temel application.yml.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'autoconfiguration-properties'
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
    ($$application.yml > application-{profile}.yml > ortam değişkenleri > komut satırı argümanları.$$, FALSE, 0),
    ($$Ortam değişkenleri > komut satırı argümanları > application.yml > application-{profile}.yml.$$, FALSE, 1),
    ($$Tüm property kaynaklarının önceliği tam olarak eşittir; en son yüklenen her zaman kazanır.$$, FALSE, 2),
    ($$Komut satırı argümanları > ortam değişkenleri > application-{profile}.yml > application.yml.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'autoconfiguration-properties'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'autoconfiguration-properties')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır? ("dev" profili, context refresh olmadan önce aktive edilir.)$$
      AND code_snippet = $$interface Selamlayici { String selamla(); }

@Component
@Profile("dev")
class GelistirmeSelamlayicisi implements Selamlayici {
    public String selamla() { return "gelistirme modu"; }
}

@Component
@Profile("prod")
class UretimSelamlayicisi implements Selamlayici {
    public String selamla() { return "uretim modu"; }
}

public class Ornek {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext();
        context.getEnvironment().setActiveProfiles("dev");
        context.register(AppConfig.class);
        context.refresh();
        System.out.println(context.getBean(Selamlayici.class).selamla());
    }
}$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır? ("dev" profili, context refresh olmadan önce aktive edilir.)$$,
           $$interface Selamlayici { String selamla(); }

@Component
@Profile("dev")
class GelistirmeSelamlayicisi implements Selamlayici {
    public String selamla() { return "gelistirme modu"; }
}

@Component
@Profile("prod")
class UretimSelamlayicisi implements Selamlayici {
    public String selamla() { return "uretim modu"; }
}

public class Ornek {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext();
        context.getEnvironment().setActiveProfiles("dev");
        context.register(AppConfig.class);
        context.refresh();
        System.out.println(context.getBean(Selamlayici.class).selamla());
    }
}$$, $$java$$,
           $$@Profile, iki farklı implementasyonun yan yana durmasına izin verir, yalnızca aktif profile uyan gerçekten kaydedilir. "dev" aktifken, UretimSelamlayicisi hiç kaydedilmez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'autoconfiguration-properties'
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
    ($$Derleme hatası -- @Profile, @Component ile birlikte kullanılamaz.$$, FALSE, 0),
    ($$gelistirme modu$$, TRUE, 1),
    ($$uretim modu$$, FALSE, 2),
    ($$Uygulama, her iki Selamlayici de var olduğu için NoUniqueBeanDefinitionException ile başlayamaz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'autoconfiguration-properties'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
