-- State Management kategorisinin iki topic'i, 10 örneğin tamamı. Dosyaların
-- kendisi examples/sharing-state/, examples/context-api/ altında.

-- Sharing State (5 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İki Component, Aynı State''e İhtiyaç Duyduğunda', 'SeparateStateProblemExample', 1
FROM topic WHERE slug = 'sharing-state';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'State''i Yukarı Taşımak: Lifting State Up', 'LiftingStateUpExample', 2
FROM topic WHERE slug = 'sharing-state';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Aynı Deseni Farklı Bir Senaryoda Görmek', 'SyncedSiblingsExample', 3
FROM topic WHERE slug = 'sharing-state';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Props Drilling: Ara Katmanlardan Geçirmek', 'PropsDrillingExample', 4
FROM topic WHERE slug = 'sharing-state';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Props Drilling Neden Sorun Yaratır?', 'WhyPropsDrillingHurtsExample', 5
FROM topic WHERE slug = 'sharing-state';

-- Context API (5 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'createContext ile Bir Context Oluşturmak', 'CreateContextExample', 1
FROM topic WHERE slug = 'context-api';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Provider Yokken: Varsayılan Değer', 'DefaultValueExample', 2
FROM topic WHERE slug = 'context-api';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Props Drilling''i Context ile Çözmek', 'AvoidingPropsDrillingExample', 3
FROM topic WHERE slug = 'context-api';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Context İçinde State Taşımak', 'ContextWithStateExample', 4
FROM topic WHERE slug = 'context-api';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Context''i Bir Custom Hook''a Sarmalamak', 'CustomContextHookExample', 5
FROM topic WHERE slug = 'context-api';
