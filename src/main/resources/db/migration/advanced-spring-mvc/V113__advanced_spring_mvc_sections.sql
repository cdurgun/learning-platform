-- Advanced Spring MVC konusu, 16 örneğin tamamı. Dosyaların kendisi
-- examples/advanced-spring-mvc/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Filter vs Interceptor: İkisi de "Araya Girer" ama Nerede?', 'FilterVsInterceptorExample', 1
FROM topic WHERE slug = 'advanced-spring-mvc';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'HandlerInterceptor Arayüzü: preHandle, postHandle, afterCompletion', 'HandlerInterceptorLifecycleExample', 2
FROM topic WHERE slug = 'advanced-spring-mvc';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bir İsteğin İzlediği Yol: Filter Chain + Interceptor Chain Birlikte', 'RequestPipelineSimulationExample', 3
FROM topic WHERE slug = 'advanced-spring-mvc';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'WebMvcConfigurer: Interceptor''ı Kaydetmek', 'InterceptorRegistrationExample', 4
FROM topic WHERE slug = 'advanced-spring-mvc';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'addPathPatterns ve excludePathPatterns: Interceptor''ı Sınırlamak', 'PathPatternScopingExample', 5
FROM topic WHERE slug = 'advanced-spring-mvc';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Çoklu Interceptor: Sıralama ve Zincirleme', 'MultipleInterceptorOrderExample', 6
FROM topic WHERE slug = 'advanced-spring-mvc';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'preHandle''da İsteği Durdurmak: Basit Bir Auth/Logging Örneği', 'AuthLoggingInterceptorExample', 7
FROM topic WHERE slug = 'advanced-spring-mvc';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'CORS Nedir? Same-Origin Policy ve Preflight Request', 'CorsPreflightExample', 8
FROM topic WHERE slug = 'advanced-spring-mvc';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@CrossOrigin: Controller/Metot Seviyesinde CORS', 'CrossOriginAnnotationExample', 9
FROM topic WHERE slug = 'advanced-spring-mvc';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'WebMvcConfigurer ile Global CORS Yapılandırması', 'GlobalCorsConfigExample', 10
FROM topic WHERE slug = 'advanced-spring-mvc';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Multipart File Upload: @RequestParam ile MultipartFile Almak', 'MultipartUploadControllerExample', 11
FROM topic WHERE slug = 'advanced-spring-mvc';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Multipart Yapılandırması ve Boyut Sınırları', 'MultipartSizeLimitExample', 12
FROM topic WHERE slug = 'advanced-spring-mvc';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: İstek Süresini Loglayan Bir Interceptor — Interceptor', 'RequestLoggingInterceptorExample', 13
FROM topic WHERE slug = 'advanced-spring-mvc';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: İstek Süresini Loglayan Bir Interceptor — Çalıştırma', 'RequestLoggingInterceptorDemo', 14
FROM topic WHERE slug = 'advanced-spring-mvc';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: CORS Destekli Dosya Yükleme — Controller', 'FileUploadCorsController', 15
FROM topic WHERE slug = 'advanced-spring-mvc';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: CORS Destekli Dosya Yükleme — Çalıştırma', 'FileUploadCorsDemo', 16
FROM topic WHERE slug = 'advanced-spring-mvc';
