-- API & Data Fetching kategorisinin iki topic'i, 10 örneğin tamamı. Dosyaların
-- kendisi examples/fetching-data/, examples/react-rest-api/ altında.

-- Fetching Data (5 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'fetch ile Veri Çekmek: GET', 'BasicFetchGetExample', 1
FROM topic WHERE slug = 'fetching-data';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Loading Durumu Göstermek', 'LoadingStateExample', 2
FROM topic WHERE slug = 'fetching-data';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Hataları Yönetmek', 'ErrorHandlingExample', 3
FROM topic WHERE slug = 'fetching-data';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Veri Göndermek: POST', 'PostRequestExample', 4
FROM topic WHERE slug = 'fetching-data';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Güncellemek ve Silmek: PUT ve DELETE', 'PutAndDeleteExample', 5
FROM topic WHERE slug = 'fetching-data';

-- React + REST API (5 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'API Katmanını Ayırmak: Bir api.js Modülü', 'ApiModuleExample', 1
FROM topic WHERE slug = 'react-rest-api';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Backend''den Kurs Listesini Çekmek', 'FetchCoursesExample', 2
FROM topic WHERE slug = 'react-rest-api';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Yeni Bir Kurs Oluşturmak', 'CreateCourseFormExample', 3
FROM topic WHERE slug = 'react-rest-api';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bir Kursu Silmek', 'DeleteCourseExample', 4
FROM topic WHERE slug = 'react-rest-api';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Oluşturduktan Sonra Ekranı Güncellemek', 'RefreshAfterMutationExample', 5
FROM topic WHERE slug = 'react-rest-api';
