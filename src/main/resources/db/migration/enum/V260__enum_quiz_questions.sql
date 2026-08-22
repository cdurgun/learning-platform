-- enum konusu için 5 soruluk quiz — TR ve EN soru metinleri.
-- Sorular enum.md'nin "Enum vs String", "Constructor", "ordinal()", "values()" ve
-- "Arayüz (Interface) İmplementasyonu" bölümlerine dayanıyor.

-- 1. Enum vs String (tip güvenliği)
INSERT INTO quiz_question (topic_id, language, question, explanation, sort_order)
SELECT id, 'tr',
       'Sabit bir değer kümesini temsil ederken enum kullanmanın string sabitlere göre en temel avantajı nedir?',
       'Enum kullanıldığında geçersiz bir sabit (örn. yazım hatası içeren bir string) derleme anında hata verir; string sabitlerde ise aynı hata ancak çalışma zamanında fark edilir.',
       1
FROM topic WHERE slug = 'enum';

INSERT INTO quiz_question (topic_id, language, question, explanation, sort_order)
SELECT id, 'en',
       'What is the main advantage of using an enum over string constants to represent a fixed set of values?',
       'With an enum, an invalid constant (e.g. a typo in a string) is caught at compile time; with string constants, the same error is only noticed at runtime.',
       1
FROM topic WHERE slug = 'enum';

-- 2. Constructor erişim belirleyicisi
INSERT INTO quiz_question (topic_id, language, question, explanation, sort_order)
SELECT id, 'tr',
       'Bir enum constructor''ı hangi erişim belirleyicisine (access modifier) sahip olabilir?',
       'Java, enum sabitlerinin yalnızca enum''un kendisi tarafından tanım satırında oluşturulabilmesini garanti etmek için enum constructor''larının public/protected olmasına derleme zamanında izin vermez; yalnızca private ya da paket-private (varsayılan) geçerlidir.',
       2
FROM topic WHERE slug = 'enum';

INSERT INTO quiz_question (topic_id, language, question, explanation, sort_order)
SELECT id, 'en',
       'What access modifier can an enum constructor have?',
       'Java enforces at compile time that enum constants can only be created by the enum itself on the definition line, so enum constructors can never be public or protected — only private or package-private (default) is allowed.',
       2
FROM topic WHERE slug = 'enum';

-- 3. ordinal() kalıcı veri olarak saklanmamalı
INSERT INTO quiz_question (topic_id, language, question, explanation, sort_order)
SELECT id, 'tr',
       'ordinal() değerini veritabanında kalıcı veri olarak saklamaktan neden kaçınmalısın?',
       'Sabitlerin sırası değişirse ya da araya yeni bir sabit eklenirse, ordinal değerleri sessizce kayar ve önceden kaydedilmiş verinin anlamı bozulur.',
       3
FROM topic WHERE slug = 'enum';

INSERT INTO quiz_question (topic_id, language, question, explanation, sort_order)
SELECT id, 'en',
       'Why should you avoid persisting the ordinal() value as permanent data in a database?',
       'If the order of constants changes or a new constant is inserted, ordinal values silently shift, corrupting the meaning of previously stored data.',
       3
FROM topic WHERE slug = 'enum';

-- 4. values() performans uyarısı
INSERT INTO quiz_question (topic_id, language, question, explanation, sort_order)
SELECT id, 'tr',
       'values() metodunu bir döngü içinde her iterasyonda çağırmanın performans sorunu nedir?',
       'values() her çağrıldığında yeni bir dizi (array) kopyalar; bunu bir döngü içinde tekrar tekrar çağırmak yerine diziyi bir kere alıp bir değişkende tutmak daha doğrudur.',
       4
FROM topic WHERE slug = 'enum';

INSERT INTO quiz_question (topic_id, language, question, explanation, sort_order)
SELECT id, 'en',
       'What is the performance issue with calling values() repeatedly inside a loop?',
       'values() copies a new array every time it is called; it is better to get the array once and store it in a variable instead of calling values() on every iteration.',
       4
FROM topic WHERE slug = 'enum';

-- 5. Enum'ın kalıtım/interface ilişkisi
INSERT INTO quiz_question (topic_id, language, question, explanation, sort_order)
SELECT id, 'tr',
       'Bir enum''ın diğer tiplerle ilişkisi hakkında hangisi doğrudur?',
       'Bir enum örtük olarak java.lang.Enum''ı extend eder, bu yüzden başka bir sınıfı extend edemez — ama istediği kadar arayüz implement edebilir.',
       5
FROM topic WHERE slug = 'enum';

INSERT INTO quiz_question (topic_id, language, question, explanation, sort_order)
SELECT id, 'en',
       'Which of the following is true about an enum''s relationship with other types?',
       'An enum implicitly extends java.lang.Enum, so it cannot extend any other class — but it can implement as many interfaces as it wants.',
       5
FROM topic WHERE slug = 'enum';
