-- `security` konusu, 5 örneğin tamamı -- Maven Central bu sandbox'tan engelli
-- olduğu için gerçek mvn/Spring Security ile derlenip çalıştırılamadı (bkz.
-- V312'deki not) -- kategorinin bilinen sandbox kısıtı, önceki topic'lerle
-- aynı. Kod yorumları ve açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'api-gateway''de JWT Doğrulaması', 'ApiGatewaySecurityConfig', 1
FROM topic WHERE slug = 'security';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'api-gateway''in JWT Issuer Yapılandırması', 'ApiGatewayJwtConfig', 2
FROM topic WHERE slug = 'security';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'order-service''te Bağımsız JWT Doğrulaması ve Role-Bazlı Yetkilendirme', 'OrderServiceSecurityConfig', 3
FROM topic WHERE slug = 'security';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'order-service''in JWT Issuer Yapılandırması', 'OrderServiceJwtConfig', 4
FROM topic WHERE slug = 'security';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Kimliği Giden Çağrılara Taşımak', 'RestClientBearerTokenInterceptor', 5
FROM topic WHERE slug = 'security';
