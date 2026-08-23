-- `wildcards` konusu, 6 örneğin tamamı. Kod yorumları ve açıklama metinleri
-- İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Wildcard Motivasyonu: Generics Değişmezliği', 'WildcardMotivationExample', 1
FROM topic WHERE slug = 'wildcards';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sınırsız Wildcard', 'UnboundedWildcardExample', 2
FROM topic WHERE slug = 'wildcards';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Üst Sınırlı Wildcard: Üretici', 'UpperBoundedWildcardProducerExample', 3
FROM topic WHERE slug = 'wildcards';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Alt Sınırlı Wildcard: Tüketici', 'LowerBoundedWildcardConsumerExample', 4
FROM topic WHERE slug = 'wildcards';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'get ve add Kısıtları: Üçünü Karşılaştırmak', 'WildcardGetPutRestrictionsExample', 5
FROM topic WHERE slug = 'wildcards';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'PECS Pratikte: copy Metodu', 'PecsCopyExample', 6
FROM topic WHERE slug = 'wildcards';
