-- State & Events kategorisinin dört topic'i, 18 örneğin tamamı. Dosyaların
-- kendisi examples/events/, examples/state/, examples/conditional-rendering/,
-- examples/lists-and-keys/ altında.

-- Events (5 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'onClick ile Tıklama Olaylarını Yakalamak', 'OnClickExample', 1
FROM topic WHERE slug = 'events';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Event Handler Fonksiyonu Tanımlamak', 'EventHandlerFunctionExample', 2
FROM topic WHERE slug = 'events';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'onChange ile Input Değişikliklerini Yakalamak', 'OnChangeExample', 3
FROM topic WHERE slug = 'events';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'onSubmit ile Form Gönderimini Yakalamak', 'OnSubmitExample', 4
FROM topic WHERE slug = 'events';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Event Object', 'EventObjectExample', 5
FROM topic WHERE slug = 'events';

-- State (5 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'useState ile Bir State Tanımlamak', 'UseStateBasicExample', 1
FROM topic WHERE slug = 'state';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'State Güncellemek', 'UpdatingStateExample', 2
FROM topic WHERE slug = 'state';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bir Önceki State''e Göre Güncelleme', 'PreviousStateExample', 3
FROM topic WHERE slug = 'state';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'State vs Normal Değişken', 'StateVsVariableExample', 4
FROM topic WHERE slug = 'state';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'State Immutability (Değişmezlik)', 'StateImmutabilityExample', 5
FROM topic WHERE slug = 'state';

-- Conditional Rendering (4 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'if ile Conditional Rendering', 'IfConditionalExample', 1
FROM topic WHERE slug = 'conditional-rendering';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Ternary (? :) ile Conditional Rendering', 'TernaryConditionalExample', 2
FROM topic WHERE slug = 'conditional-rendering';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '&& Operatörü ile Conditional Rendering', 'AndOperatorConditionalExample', 3
FROM topic WHERE slug = 'conditional-rendering';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Conditional Component''ler', 'ConditionalComponentExample', 4
FROM topic WHERE slug = 'conditional-rendering';

-- Lists & Keys (4 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'map() ile Liste Render Etmek', 'MapRenderListExample', 1
FROM topic WHERE slug = 'lists-and-keys';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'key Prop''u Nedir?', 'KeyPropExample', 2
FROM topic WHERE slug = 'lists-and-keys';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'key Neden Önemli?', 'WhyKeysMatterExample', 3
FROM topic WHERE slug = 'lists-and-keys';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Yaygın Hatalar', 'CommonKeyMistakeExample', 4
FROM topic WHERE slug = 'lists-and-keys';
