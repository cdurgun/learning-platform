-- content-check'in bulduğu 6 Türkçe quiz sorusu, dersin Türkçe sürümünde var olmayan
-- (İngilizce ya da eksik noktalamalı) bir bölüm adına atıf yapıyordu. Yalnızca soru
-- metnindeki tırnaklı bölüm adını dersin gerçek Türkçe H2 başlığıyla eşitler; şıklara,
-- açıklamalara ve başka hiçbir soruya dokunmaz. Konu slug'ı + dil + metinle eşleştiği için
-- ortamdan bağımsızdır; tekrar çalıştırılması hiçbir şeyi değiştirmez.
UPDATE question q
SET question = replace(q.question, v.old_ref, v.new_ref)
FROM (VALUES
    ('generative-ai', '''Generative AI Ne Değildir'' bölümüne', '''Generative AI Ne Değildir?'' bölümüne'),
    ('postgresql-and-the-relational-model', '''ACID: A First Look''', '''ACID: İlk Bir Bakış'''),
    ('connecting-to-postgresql', '''Common Misconceptions''', '''Yaygın Yanlış Anlamalar'''),
    ('databases-schemas-tables-and-basic-sql', '''Common Misconceptions''', '''Yaygın Yanlış Anlamalar'''),
    ('joins', '''Common Mistakes''', '''Yaygın Hatalar'''),
    ('transactions-and-concurrency-in-postgresql', '''A Real FOR UPDATE Scenario''', '''Gerçek Bir FOR UPDATE Senaryosu''')
) AS v(slug, old_ref, new_ref)
JOIN topic t ON t.slug = v.slug
WHERE q.topic_id = t.id
  AND q.language = 'tr'
  AND position(v.old_ref in q.question) > 0;
