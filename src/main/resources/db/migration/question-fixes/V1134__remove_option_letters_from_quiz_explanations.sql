-- 76 çok seçimli sorunun açıklaması iki şık harfiyle başlıyordu ("A and B are directly stated
-- in the lesson (...)", "A ve B derste doğrudan belirtilir (...)"). Quiz arayüzünde şıkların
-- yanında harf yoktur ve şık sırası sonradan değiştiği için bu harflerin çoğu gerçek doğru
-- şıkların konumunu da göstermiyordu. Açılıştaki harfler nötr bir ifadeyle değiştirilir;
-- açıklamanın geri kalanı, soru metni, şıklar ve doğru cevaplar AYNEN kalır.
--
-- Kapsam bilinçli olarak dar: yalnızca açıklaması aşağıdaki altı kalıptan biriyle BAŞLAYAN,
-- o dildeki, tam iki doğru şıkkı olan MULTIPLE_CHOICE sorular. Yalnızca UPDATE içerir (satır
-- eklemez); kalıp bir kez değiştirildikten sonra artık eşleşmediği için tekrar çalıştırılması
-- hiçbir şeyi değiştirmez. Metinde soruya ait bir ad olarak geçen harflere ("Model A",
-- tip parametresi A, "A LEFT JOIN B") dokunulmaz, çünkü hiçbiri açıklamanın başında değildir.

UPDATE question q
SET explanation = regexp_replace(q.explanation, v.pattern, v.replacement)
FROM (VALUES
    ('en', '^[A-D] and [A-D] are directly stated in the lesson', 'The two correct options are directly stated in the lesson'),
    ('en', '^[A-D] and [A-D] are correct per the lesson',        'The two correct options are correct per the lesson'),
    ('en', '^[A-D] and [A-D] match the lesson',                  'The two correct options match the lesson'),
    ('tr', '^[A-D] ve [A-D] derste doğrudan belirtilir',         'İki doğru seçenek derste doğrudan belirtilir'),
    ('tr', '^[A-D] ve [A-D] derse göre doğrudur',                'İki doğru seçenek derse göre doğrudur'),
    ('tr', '^[A-D] ve [A-D] derse doğrudan',                     'İki doğru seçenek derse doğrudan')
) AS v(language, pattern, replacement)
WHERE q.language = v.language
  AND q.type = 'MULTIPLE_CHOICE'
  AND q.explanation ~ v.pattern
  AND (SELECT count(*) FROM question_option o WHERE o.question_id = q.id AND o.is_correct) = 2;
