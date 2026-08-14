-- Routing kategorisinin iki topic'i, 10 örneğin tamamı. Dosyaların kendisi
-- examples/react-router-basics/, examples/route-parameters-navigation/ altında.

-- React Router Basics (5 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'BrowserRouter ve Routes ile Sayfa Tanımlamak', 'BasicRouterSetupExample', 1
FROM topic WHERE slug = 'react-router-basics';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Link ile Sayfalar Arası Geçiş', 'LinkNavigationExample', 2
FROM topic WHERE slug = 'react-router-basics';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'NavLink ile Aktif Sayfayı Vurgulamak', 'NavLinkActiveExample', 3
FROM topic WHERE slug = 'react-router-basics';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Birden Fazla Sayfayı Bir Arada Kullanmak', 'MultiPageNavExample', 4
FROM topic WHERE slug = 'react-router-basics';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Eşleşmeyen URL''ler: Not Found Sayfası', 'NotFoundRouteExample', 5
FROM topic WHERE slug = 'react-router-basics';

-- Route Parameters & Navigation (5 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Route Parametreleri: URL''den Veri Okumak', 'RouteParamExample', 1
FROM topic WHERE slug = 'route-parameters-navigation';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İç İçe (Nested) Route''lar ve Outlet', 'NestedRouteExample', 2
FROM topic WHERE slug = 'route-parameters-navigation';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'useNavigate ile Programatik Yönlendirme', 'UseNavigateExample', 3
FROM topic WHERE slug = 'route-parameters-navigation';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bir İşlemden Sonra Yönlendirmek', 'NavigateAfterActionExample', 4
FROM topic WHERE slug = 'route-parameters-navigation';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Geri Gitmek: navigate(-1)', 'GoBackNavigateExample', 5
FROM topic WHERE slug = 'route-parameters-navigation';
