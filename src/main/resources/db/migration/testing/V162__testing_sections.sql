-- Testing kategorisinin iki topic'i, 8 örneğin tamamı. Dosyaların kendisi
-- examples/component-testing/ ve examples/user-interaction-testing/ altında.

-- Component Testing (4 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'render() ve screen ile İlk Testimiz', 'RenderAndGetByTextExample', 1
FROM topic WHERE slug = 'component-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'getByRole ve getByLabelText ile Sorgulama', 'GetByRoleAndLabelExample', 2
FROM topic WHERE slug = 'component-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'jest-dom Matcher''ları', 'JestDomMatchersExample', 3
FROM topic WHERE slug = 'component-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Koşullu Render''ı Test Etmek', 'ConditionalRenderingTestExample', 4
FROM topic WHERE slug = 'component-testing';

-- User Interaction Testing (4 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Tıklamayı Test Etmek', 'UserEventClickExample', 1
FROM topic WHERE slug = 'user-interaction-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Yazmayı Test Etmek', 'UserEventTypingExample', 2
FROM topic WHERE slug = 'user-interaction-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Form Gönderimini Test Etmek', 'FormSubmissionTestExample', 3
FROM topic WHERE slug = 'user-interaction-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Asenkron UI Güncellemelerini Test Etmek', 'AsyncUiUpdateTestExample', 4
FROM topic WHERE slug = 'user-interaction-testing';
