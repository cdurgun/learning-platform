-- Promotion batch
-- Topic: introduction-to-generics (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V541 (records) through V569 (custom-exceptions),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/introduction-to-generics.md and content/tr/introduction-to-generics.md.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different code/variable names, different question
-- framing) rather than a translation. Every question whose answer depends on
-- shown code is typed CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a
-- code_snippet attached) -- fragments/quiz.html only renders code_snippet for
-- CODE_OUTPUT questions, per the bug found and fixed in try-catch-finally/V573.
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly -- same documentation convention as prior manual
-- batches. topic_id resolved by Topic.slug; question_option rows reference
-- the newly generated id via a WITH ... RETURNING id CTE.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these 14 questions at all.

-- Pair 1 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code runs?$$,
           $$List raw = new ArrayList();
raw.add("hello");
raw.add(42);

for (Object o : raw) {
    String s = (String) o;
    System.out.println(s);
}$$, $$java$$,
           $$A raw (non-generic) List accepts both a String and an Integer without complaint at insertion -- the failure only shows up later, at the cast, when the loop reaches the misplaced Integer element and throws ClassCastException.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-generics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It prints "hello", then throws ClassCastException on the second element.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It fails to compile because raw doesn't declare an element type.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It prints "hello" then "42" with no error.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It throws ClassCastException immediately on raw.add(42).$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$List veriler = new ArrayList();
veriler.add("elma");
veriler.add(7);

for (Object o : veriler) {
    String s = (String) o;
    System.out.println(s);
}$$, $$java$$,
           $$Raw (generic olmayan) bir List, ekleme sırasında hem bir String hem bir Integer'ı hiçbir itiraz etmeden kabul eder -- hata ancak daha sonra, döngü yanlış konumlandırılmış Integer elemanına ulaştığında cast noktasında ClassCastException olarak ortaya çıkar.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-generics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$"elma" yazdırır, sonra ikinci elemanda ClassCastException fırlatır.$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$veriler bir eleman türü bildirmediği için derlenmez.$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Hiçbir hata olmadan "elma" sonra "7" yazdırır.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$veriler.add(7) satırında hemen ClassCastException fırlatır.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$In `Box<String>`, which term correctly describes `String`?$$,
           NULL, NULL,
           $$String is the real, concrete type supplied when Box is used -- that is a type argument. T in the declaration class Box<T> is the type parameter, the placeholder name.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-generics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A type argument -- the real type supplied when Box is used.$$, TRUE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$A type parameter -- the placeholder declared on the class.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$A raw type.$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$A wildcard.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`Pair<String, Integer>` içindeki `String` ve `Integer` için ne söylenebilir?$$,
           NULL, NULL,
           $$String ve Integer, Pair<K, V> gerçekten kullanıldığında K ve V tür parametreleri için sağlanan gerçek, somut türlerdir -- bunlar tür argümanlarıdır. K ve V'nin kendisi ise tür parametreleridir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-generics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tür argümanlarıdır -- Pair kullanıldığında sağlanan gerçek türler.$$, TRUE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Tür parametreleridir -- sınıf üzerinde bildirilen yer tutucular.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Raw type'lardır.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Wildcard'lardır.$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$class Box<T> {
    private T content;
    void set(T content) { this.content = content; }
    T get() { return content; }
}

Box<String> stringBox = new Box<>();
stringBox.set("hello");
stringBox.set(42);$$, $$java$$,
           $$Box<String> fixes T as String for that instance -- set(T content) becomes set(String content), so calling set(42) with an int fails to compile; there's no cast to defer the error to runtime.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-generics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It fails to compile -- set(42) doesn't match set(String content).$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It compiles and silently overwrites the content with 42.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It compiles but throws ClassCastException at runtime.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It compiles because Box<T> accepts any type by default.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$class Kutu<T> {
    private T icerik;
    void koy(T icerik) { this.icerik = icerik; }
    T al() { return icerik; }
}

Kutu<Integer> sayiKutusu = new Kutu<>();
sayiKutusu.koy(10);
sayiKutusu.koy("on");$$, $$java$$,
           $$Kutu<Integer>, o instance için T'yi Integer olarak sabitler -- koy(T icerik), koy(Integer icerik) hâline gelir, bu yüzden koy("on") bir String ile çağırmak derlenmez; hata çalışma zamanına ertelenmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-generics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenmez -- koy("on"), koy(Integer icerik) ile eşleşmez.$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Derlenir ve icerik'i sessizce "on" ile değiştirir.$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Derlenir ama çalışma zamanında ClassCastException fırlatır.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Derlenir çünkü Kutu<T> varsayılan olarak her türü kabul eder.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$A class declares `class Pair<K, V> { ... }`. Which of the following is true?$$,
           NULL, NULL,
           $$A class isn't limited to a single type parameter -- as many as needed can be declared, comma-separated. Pair<String, Integer> and Pair<Integer, String> are both valid, unrelated uses of the exact same class, each independently type-checked.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-generics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Pair<String, Integer> and Pair<Integer, String> are both valid, independently type-checked uses of the same class.$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$A class can only ever declare a single type parameter, like Pair<K>.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$K and V must always be the same type when Pair is used.$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Pair<Integer, String> is a compile error because K must come before V alphabetically.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`class Sozluk<Anahtar, Deger> { ... }` şeklinde bir sınıf bildirildi. Aşağıdakilerden hangisi doğrudur?$$,
           NULL, NULL,
           $$Bir sınıf tek bir tür parametresiyle sınırlı değildir -- tasarımın ihtiyaç duyduğu kadarı virgülle ayrılarak bildirilebilir. Sozluk<String, Integer> ve Sozluk<Integer, String>, ikisi de aynı sınıfın geçerli, birbirinden bağımsız kullanımlarıdır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-generics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sozluk<String, Integer> ve Sozluk<Integer, String>, ikisi de aynı sınıfın geçerli, bağımsız olarak kontrol edilen kullanımlarıdır.$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Bir sınıf yalnızca Sozluk<Anahtar> gibi tek bir tür parametresi bildirebilir.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Sozluk kullanıldığında Anahtar ve Deger her zaman aynı tür olmak zorundadır.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Sozluk<Integer, String>, Anahtar alfabetik olarak önce gelmediği için derleme hatasıdır.$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$interface Repository<T> {
    void save(T item);
    T findLatest();
}

class InMemoryOrderRepository implements Repository<String> {
    private String latest;
    public void save(String item) { this.latest = item; }
    public String findLatest() { return latest; }
}

public class Demo {
    public static void main(String[] args) {
        Repository<String> repo = new InMemoryOrderRepository();
        repo.save("order-101");
        System.out.println(repo.findLatest().toUpperCase());
    }
}$$, $$java$$,
           $$InMemoryOrderRepository implements Repository<String>, supplying the real type argument -- findLatest() returns a String directly, no cast needed, so calling toUpperCase() on it compiles and runs normally.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-generics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ORDER-101$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$order-101$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Compile error -- findLatest() returns Object, not String.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$NullPointerException.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$interface Depo<T> {
    void kaydet(T eleman);
    T sonEklenen();
}

class BellekteUrunDeposu implements Depo<String> {
    private String son;
    public void kaydet(String eleman) { this.son = eleman; }
    public String sonEklenen() { return son; }
}

public class Ornek {
    public static void main(String[] args) {
        Depo<String> depo = new BellekteUrunDeposu();
        depo.kaydet("laptop");
        System.out.println(depo.sonEklenen().toUpperCase());
    }
}$$, $$java$$,
           $$BellekteUrunDeposu implements Depo<String> gerçek tür argümanını sağlar -- sonEklenen() doğrudan bir String döner, hiçbir cast gerekmez, bu yüzden üzerinde toUpperCase() çağırmak normal şekilde derlenir ve çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-generics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$LAPTOP$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$laptop$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Derleme hatası -- sonEklenen() String değil Object döner.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$NullPointerException.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about raw types (like plain `List` instead of `List<String>`) are true? (Select all that apply)$$,
           NULL, NULL,
           $$Using a raw type makes the compiler fall back to pre-generics behavior for that usage, silently losing all compile-time type-safety benefits -- exactly the class of mistake generics exist to catch.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-generics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The compiler falls back to pre-generics behavior for that specific usage.$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It silently loses the type-safety benefits generics normally provide.$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It is functionally identical to List<Object> in every respect.$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$The compiler still rejects adding a mismatched element type to a raw List.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Raw type'lar (örneğin `List<String>` yerine düz `List`) hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Bir raw type kullanmak, derleyicinin o kullanım için generics-öncesi davranışa geri düşmesine yol açar, tür-güvenliği faydalarının tamamını sessizce kaybettirir -- tam olarak generics'in önlemek için var olduğu hata sınıfı.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-generics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleyici, o belirli kullanım için generics-öncesi davranışa geri döner.$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Generics'in normalde sağladığı tür-güvenliği faydalarını sessizce kaybeder.$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Her açıdan List<Object> ile işlevsel olarak birebir aynıdır.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Derleyici, raw bir List'e uyuşmayan bir eleman türü eklemeyi yine de reddeder.$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, BEGINNER)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$A `List<String>` is declared, and code tries to call `.add(42)` on it. Which of the following are true? (Select all that apply)$$,
           NULL, NULL,
           $$Trying to add(42) to a List<String> simply does not compile -- there's no cast to forget, no ClassCastException waiting to happen later. This is the core promise generics make: the class of mistake pre-generics code suffered from becomes impossible to write in the first place.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-generics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The call fails to compile, since 42 doesn't match the element type String.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$This is exactly the kind of mistake generics are designed to catch at compile time.$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$The call compiles, and the mistake would only surface later as a ClassCastException.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$add() on any generic collection always accepts a plain Object regardless of the declared type argument.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, BEGINNER)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir `List<Integer>` bildiriliyor ve kod üzerinde `.add("seksen")` çağırmaya çalışıyor. Aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Bir List<Integer>'a add("seksen") yapmaya çalışmak basitçe derlenmiyor -- unutulacak bir cast, sonradan gerçekleşmeyi bekleyen bir ClassCastException yok. Bu, generics'in verdiği temel sözdür: pre-generics kodun çektiği hata sınıfı baştan yazılamaz hâle gelir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-generics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çağrı derlenmez, çünkü "seksen" eleman türü olan Integer ile eşleşmez.$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bu, tam olarak generics'in derleme zamanında yakalamak için tasarlandığı türden bir hatadır.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Çağrı derlenir, ve hata ancak daha sonra bir ClassCastException olarak ortaya çıkar.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Herhangi bir generic koleksiyonda add(), bildirilen tür argümanından bağımsız olarak her zaman düz bir Object kabul eder.$$, FALSE, 3 FROM new_question_tr7;
