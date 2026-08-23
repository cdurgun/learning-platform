-- `deployment` konusu, 4 örneğin tamamı -- Maven Central bu sandbox'tan engelli
-- olduğu için gerçek Docker/Docker Compose ile derlenip çalıştırılamadı (bkz.
-- V315'teki not) -- kategorinin bilinen sandbox kısıtı, önceki topic'lerle
-- aynı. Kod yorumları ve açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'order-service''in Multi-Stage Dockerfile''ı', 'OrderServiceDockerfile', 1
FROM topic WHERE slug = 'deployment';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Tüm Sistemi Orkestre Eden docker-compose', 'DockerComposeConfig', 2
FROM topic WHERE slug = 'deployment';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Container İçin Ortam Değişkeni Yapılandırması', 'OrderServiceContainerConfig', 3
FROM topic WHERE slug = 'deployment';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Kubernetes''e Kısa Bir Önizleme', 'KubernetesDeploymentPreview', 4
FROM topic WHERE slug = 'deployment';
