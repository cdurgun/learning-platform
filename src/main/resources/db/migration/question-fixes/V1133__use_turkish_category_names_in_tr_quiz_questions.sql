-- Kurs ve kategori adları Türkçe sayfalarda artık Türkçe gösteriliyor (bkz. CatalogNames,
-- course.{slug}.name / category.{slug}.name mesajları). İki Türkçe quiz metni bir kategoriyi
-- hâlâ İngilizce adıyla anıyordu; bu migration yalnızca o iki ifadeyi eşitler. Konu slug'ı +
-- dil + metinle eşleştiği için ortamdan bağımsızdır; tekrar çalıştırılması hiçbir şeyi
-- değiştirmez.
--
-- `joins` dersinin bir sorusundaki `PostgreSQL Foundations` BİLİNÇLİ OLARAK değiştirilmedi:
-- o, bir sorgunun döndürdüğü gerçek veritabanı değeridir (category.name), bir kategori atfı
-- değil.

-- tools-and-function-calling: açıklamadaki kategori atfı
UPDATE question q
SET explanation = replace(q.explanation, '''AI Agents'' kategorisinde', '"AI Agent''lar" kategorisinde')
FROM topic t
WHERE q.topic_id = t.id
  AND t.slug = 'tools-and-function-calling'
  AND q.language = 'tr'
  AND position('''AI Agents'' kategorisinde' in q.explanation) > 0;

-- llm-capabilities-and-limitations: bir şıkkın metnindeki kategori atfı
UPDATE question_option o
SET option_text = replace(o.option_text,
                          'Tools & MCP ve AI Agents gibi sonraki kategorileri',
                          'Tool''lar ve MCP ile AI Agent''lar gibi sonraki kategorileri')
FROM question q
         JOIN topic t ON t.id = q.topic_id
WHERE o.question_id = q.id
  AND t.slug = 'llm-capabilities-and-limitations'
  AND q.language = 'tr'
  AND position('Tools & MCP ve AI Agents gibi sonraki kategorileri' in o.option_text) > 0;
