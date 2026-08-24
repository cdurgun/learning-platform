-- `query-methods-and-jpql` konusu, 6 örneğin tamamı. Kod yorumları ve
-- açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Derived Query Temelleri', 'DerivedQueryBasicsExample', 1
FROM topic WHERE slug = 'query-methods-and-jpql';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Derived Query Anahtar Kelimeleri', 'DerivedQueryKeywordsExample', 2
FROM topic WHERE slug = 'query-methods-and-jpql';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Query ile JPQL ve İsimli Parametreler', 'JpqlQueryExample', 3
FROM topic WHERE slug = 'query-methods-and-jpql';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'join fetch ile İlişkileri Birleştirmek', 'JoinFetchExample', 4
FROM topic WHERE slug = 'query-methods-and-jpql';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Modifying ile Toplu Güncelleme', 'ModifyingQueryExample', 5
FROM topic WHERE slug = 'query-methods-and-jpql';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Native Query', 'NativeQueryExample', 6
FROM topic WHERE slug = 'query-methods-and-jpql';
