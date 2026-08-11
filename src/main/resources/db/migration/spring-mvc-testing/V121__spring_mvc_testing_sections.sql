-- Spring MVC'de Test Yazmak konusu, 14 örneğin tamamı. Dosyaların kendisi
-- examples/spring-mvc-testing/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@WebMvcTest ve MockMvc: Yalnızca Web Katmanını Yüklemek', 'WebMvcTestSliceExample', 1
FROM topic WHERE slug = 'spring-mvc-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İlk MockMvc Testi: perform, andExpect, status()', 'FirstMockMvcTestExample', 2
FROM topic WHERE slug = 'spring-mvc-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@MockitoBean ile Bağımlılıkları Sahtelemek', 'MockitoBeanExample', 3
FROM topic WHERE slug = 'spring-mvc-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bu Projenin Kendi HomeController''ını Test Etmek', 'HomeControllerTest', 4
FROM topic WHERE slug = 'spring-mvc-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Model ve View Adını Doğrulamak: model(), view()', 'ModelAndViewAssertionExample', 5
FROM topic WHERE slug = 'spring-mvc-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@RestController Test Etmek: jsonPath ile Doğrulama', 'JsonPathAssertionExample', 6
FROM topic WHERE slug = 'spring-mvc-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Request Body Göndermek: content() ve contentType()', 'RequestBodyTestExample', 7
FROM topic WHERE slug = 'spring-mvc-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Path Variable ve Query Parametrelerini Test Etmek', 'PathVariableQueryParamTestExample', 8
FROM topic WHERE slug = 'spring-mvc-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Validation Hatalarını Test Etmek: 400 ve ProblemDetail', 'ValidationErrorTestExample', 9
FROM topic WHERE slug = 'spring-mvc-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Multipart Dosya Yüklemeyi Test Etmek: MockMultipartFile', 'MultipartUploadTestExample', 10
FROM topic WHERE slug = 'spring-mvc-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: TopicController Test Paketi — Fixture''lar', 'TopicTestFixtures', 11
FROM topic WHERE slug = 'spring-mvc-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: TopicController Test Paketi — @WebMvcTest', 'TopicControllerWebMvcTest', 12
FROM topic WHERE slug = 'spring-mvc-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Interceptor''ı MockMvc ile Test Etmek — Interceptor', 'TimingInterceptorForTest', 13
FROM topic WHERE slug = 'spring-mvc-testing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Interceptor''ı MockMvc ile Test Etmek — Test', 'TimingInterceptorMockMvcTest', 14
FROM topic WHERE slug = 'spring-mvc-testing';
