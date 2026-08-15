-- Production kategorisinin iki topic'i, 5 örneğin tamamı. Dosyaların kendisi
-- examples/build-deployment/ ve examples/react-spring-boot-deployment/ altında
-- (ikinci klasörde biri .java, biri gerçek Advanced Spring MVC CORS deseninin
-- production'a uyarlanmış hali).

-- Build & Deployment (2 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Vite Ortam Değişkenlerini Okumak', 'ReadingEnvVarExample', 1
FROM topic WHERE slug = 'build-deployment';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Ortama Göre Davranmak: Feature Flag', 'ConditionalFeatureFlagExample', 2
FROM topic WHERE slug = 'build-deployment';

-- React + Spring Boot Deployment (3 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Backend Adresini Ortam Değişkeninden Okumak', 'ApiBaseUrlFromEnvExample', 1
FROM topic WHERE slug = 'react-spring-boot-deployment';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Deploy Edilmiş Backend''den Veri Çekmek', 'FetchFromDeployedBackendExample', 2
FROM topic WHERE slug = 'react-spring-boot-deployment';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Production CORS Yapılandırması', 'DeploymentCorsConfigExample', 3
FROM topic WHERE slug = 'react-spring-boot-deployment';
