-- Promotion-style migration linking TR dependency-injection quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dependency-injection')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Dependency Injection (DI) ile Inversion of Control (IoC) arasındaki ilişki için hangi ifade doğrudur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Dependency Injection (DI) ile Inversion of Control (IoC) arasındaki ilişki için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$IoC, kontrolü dışarıya devretme fikrinin daha genel hâlidir; DI ise IoC'yi uygulamanın en yaygın somut yoludur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dependency-injection'
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
    ($$DI daha genel fikirdir; IoC ise onu uygulamanın bir tekniğidir.$$, FALSE, 0),
    ($$IoC, kontrolü dışarıya devretme fikrinin daha genel hâlidir; DI ise IoC'yi uygulamanın en yaygın somut yoludur.$$, TRUE, 1),
    ($$DI ve IoC, yalnızca birlikte anılan, tamamen ilgisiz iki kavramdır.$$, FALSE, 2),
    ($$IoC Spring'e özgü bir mekanizmadır; DI ise genel tasarım ilkesidir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dependency-injection'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: MULTIPLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dependency-injection')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, sıkı bağlılığın (bir sınıfın bağımlılığını doğrudan `new` ile oluşturması) somut maliyetleri arasında aşağıdakilerden hangileri yer alır? (Uygun olan hepsini seçin)$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, sıkı bağlılığın (bir sınıfın bağımlılığını doğrudan `new` ile oluşturması) somut maliyetleri arasında aşağıdakilerden hangileri yer alır? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Sıkı bağlılık, test edilemezliğe (gerçek implementasyona karşı test etmeye zorlanırsın) ve değiştirme zorluğuna (farklı bir implementasyona geçmek kaynak kodu düzenlemeyi gerektirir) yol açar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dependency-injection'
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
    ($$Değiştirme zorluğu -- farklı bir implementasyona geçmek, sınıfın kaynak kodunu açıp düzenlemeyi gerektirir.$$, TRUE, 0),
    ($$Interface dolaylaması olmadığı için gelişmiş performans.$$, FALSE, 1),
    ($$Bağımlılık yalnızca bir kez oluşturulduğu için otomatik thread-safety.$$, FALSE, 2),
    ($$Test edilemezlik -- gerçek implementasyona karşı test etmeye zorlanırsın, bundan kaçınmanın bir yolu yoktur.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dependency-injection'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dependency-injection')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod çalıştığında ne olur?$$
      AND code_snippet = $$class SiparisServisi {
    private BildirimGonderici gonderici;
    void setGonderici(BildirimGonderici gonderici) { this.gonderici = gonderici; }
    void siparisVer(String urun) {
        gonderici.gonder("Siparis verildi: " + urun);
    }
}

public class Ornek {
    public static void main(String[] args) {
        SiparisServisi servis = new SiparisServisi();
        servis.siparisVer("Kitap");
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$class SiparisServisi {
    private BildirimGonderici gonderici;
    void setGonderici(BildirimGonderici gonderici) { this.gonderici = gonderici; }
    void siparisVer(String urun) {
        gonderici.gonder("Siparis verildi: " + urun);
    }
}

public class Ornek {
    public static void main(String[] args) {
        SiparisServisi servis = new SiparisServisi();
        servis.siparisVer("Kitap");
    }
}$$, $$java$$,
           $$Setter injection'da, eksik bir bağımlılık ancak çalışma zamanında, gerçekten kullanıldığı satırda ortaya çıkar. setGonderici(...) hiç çağrılmadığı için, siparisVer(...) onu kullanmaya çalıştığında gonderici null'dır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dependency-injection'
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
    ($$Sorunsuz çalışır ve null gonderici ile "Siparis verildi: Kitap" yazdırır.$$, FALSE, 0),
    ($$setGonderici(...) hiç çağrılmadığı için, çalışma zamanında siparisVer(...) çağrısında NullPointerException fırlatır.$$, TRUE, 1),
    ($$gonderici hiç başlatılmadığı için derlenmez.$$, FALSE, 2),
    ($$new SiparisServisi() çalıştığında hemen istisna fırlatır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dependency-injection'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dependency-injection')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, field injection kullanan bir sınıfı (elle simüle edilmiş bir `@Autowired` alanı gibi) bir framework olmadan test etmek neden zordur?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, field injection kullanan bir sınıfı (elle simüle edilmiş bir `@Autowired` alanı gibi) bir framework olmadan test etmek neden zordur?$$,
           NULL, NULL,
           $$Düz bir new OrderService(fakeSender) çağrısı bağımlılığı hiç ayarlayamaz, çünkü onu kabul eden bir constructor yoktur -- reflection gerekir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dependency-injection'
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
    ($$Field injection kullanan sınıflar container dışında hiçbir zaman örneklenemez.$$, FALSE, 0),
    ($$Field injection alanı final yapar, bu yüzden test için asla değiştirilemez.$$, FALSE, 1),
    ($$Field injection test etmek için gerçek bir veritabanı bağlantısı gerektirir.$$, FALSE, 2),
    ($$Düz bir new OrderService(fakeSender) çağrısı bağımlılığı hiç ayarlayamaz, çünkü onu kabul eden bir constructor yoktur -- reflection gerekir.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dependency-injection'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dependency-injection')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu ders, constructor injection'ın varsayılan olarak önerilmesi için hangi gerekçeleri verir? (Uygun olan hepsini seçin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu ders, constructor injection'ın varsayılan olarak önerilmesi için hangi gerekçeleri verir? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Eksik/null bir bağımlılık, Objects.requireNonNull(...) ile nesne inşa edilirken hemen yakalanabilir, ve büyüyen bir parametre listesi çok fazla sorumluluğun erken bir işaretidir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dependency-injection'
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
    ($$Birden fazla bağımlılığı olan sınıflar için Spring'in desteklediği tek injection tarzıdır.$$, FALSE, 0),
    ($$Eksik/null bir bağımlılık, nesne inşa edilirken, Objects.requireNonNull(...) gibi bir şeyle hemen yakalanabilir.$$, TRUE, 1),
    ($$Beş ya da altıya çıkan bir constructor parametre listesi, sınıfın çok fazla sorumluluk üstlendiğinin erken, görünür bir işaretidir.$$, TRUE, 2),
    ($$Hiç constructor ya da setter yazmaya gerek olmadığı için en az kod yazmayı gerektirir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dependency-injection'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dependency-injection')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin Yaygın Hatalar bölümüne göre, Dependency Injection hakkında yanlış bir varsayım nedir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin Yaygın Hatalar bölümüne göre, Dependency Injection hakkında yanlış bir varsayım nedir?$$,
           NULL, NULL,
           $$DI'nin Spring'e özgü bir kavram olduğunu varsaymak bir hatadır -- composition-root örneğinin gösterdiği gibi, DI hiçbir framework olmadan da çalışan bir tasarım fikridir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dependency-injection'
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
    ($$DI'nin yalnızca interface'lere uygulanabileceğini, somut sınıflara asla uygulanamayacağını varsaymak.$$, FALSE, 0),
    ($$DI'nin değmeye değer olması için en az üç bağımlılık gerektirdiğini varsaymak.$$, FALSE, 1),
    ($$DI'nin her türlü testi gereksiz kıldığını varsaymak.$$, FALSE, 2),
    ($$DI'nin Spring'e özgü bir kavram olduğunu varsaymak -- composition-root örneğinin gösterdiği gibi, DI hiçbir framework olmadan da çalışan bir tasarım fikridir.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dependency-injection'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dependency-injection')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class SahteBildirimGonderici implements BildirimGonderici {
    List<String> gonderilenMesajlar = new ArrayList<>();
    public void gonder(String mesaj) { gonderilenMesajlar.add(mesaj); }
}

public class Ornek {
    public static void main(String[] args) {
        SahteBildirimGonderici sahte = new SahteBildirimGonderici();
        SiparisServisi servis = new SiparisServisi(sahte, "MagazaAdi");
        servis.siparisVer("Kitap");
        System.out.println(sahte.gonderilenMesajlar.size());
    }
}$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class SahteBildirimGonderici implements BildirimGonderici {
    List<String> gonderilenMesajlar = new ArrayList<>();
    public void gonder(String mesaj) { gonderilenMesajlar.add(mesaj); }
}

public class Ornek {
    public static void main(String[] args) {
        SahteBildirimGonderici sahte = new SahteBildirimGonderici();
        SiparisServisi servis = new SiparisServisi(sahte, "MagazaAdi");
        servis.siparisVer("Kitap");
        System.out.println(sahte.gonderilenMesajlar.size());
    }
}$$, $$java$$,
           $$Yalnızca ne göndermesi istendiğini kaydeden sahte bir BildirimGonderici, testin gerçek bir ağ çağrısı olmadan SiparisServisi'nin davranışını doğrulamasını sağlar -- siparisVer(...), gonder(...)'i bir kez çağırır, bu yüzden gonderilenMesajlar'da bir kayıt olur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dependency-injection'
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
    ($$sahte gerçek bir gonderici olmadığı için NullPointerException fırlatır.$$, FALSE, 0),
    ($$1$$, TRUE, 1),
    ($$0$$, FALSE, 2),
    ($$Derleme hatası -- SahteBildirimGonderici, gerçek bir e-posta bağlantısı olmadan BildirimGonderici implement edemez.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dependency-injection'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
