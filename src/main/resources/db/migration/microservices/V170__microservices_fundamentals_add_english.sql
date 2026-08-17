-- content/en/microservices-fundamentals.md tamamlandı -- TR ile birebir aynı yapı
-- (17 başlık: 14 ana bölüm + Best Practices + Yaygın Hatalar/Common Mistakes +
-- Özet/Summary and Glossary), TR gibi sıfır embed. Kullanıcı onayı üzerine EN
-- çevirisine geçildi (Faz 40, önce TR'nin ayrıca onaylanması istenmişti). Henüz
-- yayına alınmıyor -- proje genelindeki "TR published=true, EN published=false,
-- ayrı bir publish migration'ıyla hemen ardından yayına al" düzenine uyuluyor
-- (bkz. react-fundamentals/V124 + V127 örneği).

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'What Are Microservices?',
       'The limits of monolithic architecture, the core characteristics of microservice architecture, defining service boundaries (bounded context), database per service, and a quick look at the CAP theorem and Conway''s Law -- a conceptual introduction with no code.',
       'What Are Microservices? Monolith vs. Microservices | A Conceptual Introduction',
       'What microservice architecture is, how it differs from a monolithic architecture, and at what point a monolith''s limits justify moving to microservices; how service boundaries (bounded context) are defined, the database-per-service principle, the new challenges distributed systems bring, the CAP theorem, and Conway''s Law -- explained conceptually, with no code.',
       false
FROM topic
WHERE slug = 'microservices-fundamentals';
