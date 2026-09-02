-- Promotion-style migration linking TR component-scanning quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-scanning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır? (`AppConfig`, `@ComponentScan` taşır ve `SelamlamaSaglayicisi` ile aynı pakette yer alır.)$$
      AND code_snippet = $$@Service
class SelamlamaSaglayicisi {
    String selamla() { return "merhaba"; }
}

@Configuration
@ComponentScan
class AppConfig { }

public class Ornek {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        SelamlamaSaglayicisi saglayici = context.getBean(SelamlamaSaglayicisi.class);
        System.out.println(saglayici.selamla());
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır? (`AppConfig`, `@ComponentScan` taşır ve `SelamlamaSaglayicisi` ile aynı pakette yer alır.)$$,
           $$@Service
class SelamlamaSaglayicisi {
    String selamla() { return "merhaba"; }
}

@Configuration
@ComponentScan
class AppConfig { }

public class Ornek {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        SelamlamaSaglayicisi saglayici = context.getBean(SelamlamaSaglayicisi.class);
        System.out.println(saglayici.selamla());
    }
}$$, $$java$$,
           $$SelamlamaSaglayicisi'nin hiç @Bean metodu yoktur -- AppConfig üzerindeki @ComponentScan, AppConfig'in kendi paketini (SelamlamaSaglayicisi'nin de yaşadığı yeri) tarar ve bulduğu her @Component türevi sınıfı, @Service dahil, otomatik olarak kaydeder.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-scanning'
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
    ($$null$$, FALSE, 0),
    ($$merhaba$$, TRUE, 1),
    ($$Derleme hatası -- SelamlamaSaglayicisi'nin kaydedilmek için açık bir @Bean metoduna ihtiyacı var.$$, FALSE, 2),
    ($$NoSuchBeanDefinitionException fırlatır, çünkü @Service tek başına bir bean kaydetmez.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-scanning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-scanning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Container açısından, `@Service` ile düz `@Component` arasında tarama/kayıt bakımından ne fark vardır?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Container açısından, `@Service` ile düz `@Component` arasında tarama/kayıt bakımından ne fark vardır?$$,
           NULL, NULL,
           $$Hiçbir fark yoktur -- @Service, @Repository ve @Controller'ın hepsi altta @Component taşır ve birebir aynı şekilde taranıp kaydedilir; yalnızca okuyucu için anlam katarlar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-scanning'
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
    ($$@Service bean'leri eager oluşturulurken @Component bean'leri lazy oluşturulur.$$, FALSE, 0),
    ($$@Component yalnızca interface'lerde, @Service yalnızca sınıflarda kullanılabilir.$$, FALSE, 1),
    ($$@Service açık bir @ComponentScan gerektirirken @Component gerektirmez.$$, FALSE, 2),
    ($$Hiçbir fark yoktur -- @Service, @Repository ve @Controller'ın hepsi altta @Component taşır ve birebir aynı şekilde taranıp kaydedilir.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-scanning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-scanning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`@ComponentScan`'e hiç argüman verilmezse, hangi paketleri tarar?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`@ComponentScan`'e hiç argüman verilmezse, hangi paketleri tarar?$$,
           NULL, NULL,
           $$Hiç argüman verilmediğinde, @ComponentScan, @Configuration sınıfının kendi paketini ve alt paketlerini tarar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-scanning'
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
    ($$Hiçbir paketi -- argüman her zaman zorunludur.$$, FALSE, 0),
    ($$@Configuration sınıfının kendi paketini ve onun alt paketlerini.$$, TRUE, 1),
    ($$Tüm classpath'i, üçüncü parti kütüphaneler dahil.$$, FALSE, 2),
    ($$Yalnızca @ComponentScan annotation'ının bulunduğu sınıfın tam paketini, alt paketleri asla.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-scanning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-scanning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Context başladıktan sonra bu bean'e ne olur? (`SiparisServisi`'nin bunun dışında doğru şekilde tarandığını ve kaydedildiğini varsayın.)$$
      AND code_snippet = $$@Component
class SiparisServisi {
    private BildirimGonderici gonderici;

    void setGonderici(BildirimGonderici gonderici) {
        this.gonderici = gonderici;
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Context başladıktan sonra bu bean'e ne olur? (`SiparisServisi`'nin bunun dışında doğru şekilde tarandığını ve kaydedildiğini varsayın.)$$,
           $$@Component
class SiparisServisi {
    private BildirimGonderici gonderici;

    void setGonderici(BildirimGonderici gonderici) {
        this.gonderici = gonderici;
    }
}$$, $$java$$,
           $$Setter üzerinde @Autowired zorunludur -- Spring hangi setter'ın injection için olduğunu bilemez, bu yüzden işaretlenmemiş bir setter asla otomatik çağrılmaz. Context başladıktan sonra gonderici null kalır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-scanning'
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
    ($$Spring, tek bir setter olduğu için setGonderici(...)'yi yine de otomatik çağırır.$$, FALSE, 0),
    ($$Uygulama NoSuchBeanDefinitionException ile başlamayı başaramaz.$$, FALSE, 1),
    ($$Spring, setGonderici(...)'yi açıkça null argümanla çağırır.$$, FALSE, 2),
    ($$gonderici null kalır -- Spring işaretlenmemiş bir setter'ı asla otomatik çağırmaz.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-scanning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-scanning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$İki `BildirimGonderici` bean'i varken, bir constructor parametresi üzerindeki `@Qualifier("emailGonderici")` ne yapar?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$İki `BildirimGonderici` bean'i varken, bir constructor parametresi üzerindeki `@Qualifier("emailGonderici")` ne yapar?$$,
           NULL, NULL,
           $$Spring'e, BildirimGonderici tipindeki adaylar arasından bean adı tam olarak "emailGonderici" olanı seçmesini söyler.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-scanning'
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
    ($$İki BildirimGonderici bean'ini tek bir birleşik instance'a birleştirir.$$, FALSE, 0),
    ($$Spring'e, BildirimGonderici tipindeki adaylar arasından bean adı tam olarak "emailGonderici" olanı seçmesini söyler.$$, TRUE, 1),
    ($$Spring'e o anda "emailGonderici" adında yepyeni bir bean oluşturmasını söyler.$$, FALSE, 2),
    ($$O belirli parametre için dependency injection'ı devre dışı bırakır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-scanning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-scanning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$interface BildirimGonderici { }

@Component @Primary
class EmailBildirimGonderici implements BildirimGonderici { }

@Component
class SmsBildirimGonderici implements BildirimGonderici { }

@Component
class SadeceEmailServisi {
    SadeceEmailServisi(BildirimGonderici gonderici) {
        System.out.println(gonderici.getClass().getSimpleName());
    }
}

@Component
class SadeceSmsServisi {
    SadeceSmsServisi(@Qualifier("smsBildirimGonderici") BildirimGonderici gonderici) {
        System.out.println(gonderici.getClass().getSimpleName());
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$interface BildirimGonderici { }

@Component @Primary
class EmailBildirimGonderici implements BildirimGonderici { }

@Component
class SmsBildirimGonderici implements BildirimGonderici { }

@Component
class SadeceEmailServisi {
    SadeceEmailServisi(BildirimGonderici gonderici) {
        System.out.println(gonderici.getClass().getSimpleName());
    }
}

@Component
class SadeceSmsServisi {
    SadeceSmsServisi(@Qualifier("smsBildirimGonderici") BildirimGonderici gonderici) {
        System.out.println(gonderici.getClass().getSimpleName());
    }
}$$, $$java$$,
           $$SadeceEmailServisi'nin hiç @Qualifier'ı yok, bu yüzden @Primary bean'ini (EmailBildirimGonderici) alır. SadeceSmsServisi ise @Qualifier ile açıkça "smsBildirimGonderici"yi ister, bu yüzden orada @Primary'nin bir önemi yoktur -- açık bir @Qualifier her zaman kazanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-scanning'
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
    ($$İkisi de "EmailBildirimGonderici" yazdırır, çünkü @Primary her zaman @Qualifier'a karşı kazanır.$$, FALSE, 0),
    ($$Uygulama, her iki servis için de NoUniqueBeanDefinitionException ile başlayamaz.$$, FALSE, 1),
    ($$İkisi de "SmsBildirimGonderici" yazdırır.$$, FALSE, 2),
    ($$SadeceEmailServisi "EmailBildirimGonderici" yazdırır; SadeceSmsServisi "SmsBildirimGonderici" yazdırır.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-scanning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-scanning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, component scanning ile Java Config arasında seçim yapmakla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, component scanning ile Java Config arasında seçim yapmakla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Component scanning kendi sınıfların için idealdir; Java Config, üçüncü parti sınıflar ya da bir API anahtarı gibi bean olmayan constructor parametreleri alan sınıflar için gereklidir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-scanning'
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
    ($$Component scanning, üçüncü parti kütüphane sınıfları dahil, herhangi bir sınıfta kullanılabilir.$$, FALSE, 0),
    ($$Component scanning, kendi yazdığın sınıflar için idealdir, çünkü kaynak koduna erişimin vardır.$$, TRUE, 1),
    ($$Java Config, kaynak koduna erişimin olmadığı üçüncü parti sınıflar için ya da constructor'ı bir API anahtarı gibi bean olmayan parametreler alan sınıflar için gereklidir.$$, TRUE, 2),
    ($$Java Config, gerçek uygulamalarda component scanning'in yerini tamamen alır -- ikisi asla birlikte kullanılmaz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-scanning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
