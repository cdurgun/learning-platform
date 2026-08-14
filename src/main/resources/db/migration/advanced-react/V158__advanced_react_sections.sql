-- Advanced React kategorisinin beş topic'i, 22 örneğin tamamı. Dosyaların
-- kendisi examples/react-performance/, examples/error-boundaries/,
-- examples/lazy-loading-code-splitting/, examples/suspense/,
-- examples/portals/ altında.

-- React Performance (5 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Gereksiz Yeniden Render''lar', 'UnnecessaryRerenderExample', 1
FROM topic WHERE slug = 'react-performance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'React.memo ile Gereksiz Render''ı Atlamak', 'ReactMemoExample', 2
FROM topic WHERE slug = 'react-performance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'memo + useCallback: Fonksiyon Prop''ları', 'ReactMemoWithCallbackExample', 3
FROM topic WHERE slug = 'react-performance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'useMemo ile Pahalı Hesaplamaları Önbelleklemek', 'UseMemoForExpensiveCalculationExample', 4
FROM topic WHERE slug = 'react-performance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'React DevTools Profiler ve <Profiler>', 'ProfilerComponentExample', 5
FROM topic WHERE slug = 'react-performance';

-- Error Boundaries (5 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Temel Bir Error Boundary Yazmak', 'BasicErrorBoundaryExample', 1
FROM topic WHERE slug = 'error-boundaries';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'componentDidCatch ile Hatayı Loglamak', 'ComponentDidCatchExample', 2
FROM topic WHERE slug = 'error-boundaries';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Error Boundary Kullanmak', 'UsingErrorBoundaryExample', 3
FROM topic WHERE slug = 'error-boundaries';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Error Boundary''lerin Kapsamı', 'ErrorBoundaryScopeExample', 4
FROM topic WHERE slug = 'error-boundaries';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Error Boundary''lerin Yakalamadığı Hatalar', 'WhatErrorBoundariesDontCatchExample', 5
FROM topic WHERE slug = 'error-boundaries';

-- Lazy Loading & Code Splitting (4 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'React.lazy ile Bir Component''i Sonradan Yüklemek', 'ReactLazyBasicExample', 1
FROM topic WHERE slug = 'lazy-loading-code-splitting';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Route Bazlı Code Splitting', 'RouteBasedCodeSplittingExample', 2
FROM topic WHERE slug = 'lazy-loading-code-splitting';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Named Export''larla lazy Kullanmak', 'NamedExportLazyExample', 3
FROM topic WHERE slug = 'lazy-loading-code-splitting';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Koşullu Lazy Loading', 'ConditionalLazyLoadExample', 4
FROM topic WHERE slug = 'lazy-loading-code-splitting';

-- Suspense (4 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'fallback Prop''u', 'SuspenseFallbackExample', 1
FROM topic WHERE slug = 'suspense';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İç İçe Suspense Sınırları', 'NestedSuspenseExample', 2
FROM topic WHERE slug = 'suspense';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'use() Hook''u ile Suspense', 'UsePromiseWithSuspenseExample', 3
FROM topic WHERE slug = 'suspense';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Suspense''in Otomatik Yapmadıkları', 'SuspenseLimitationsExample', 4
FROM topic WHERE slug = 'suspense';

-- Portals (4 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Portal Nedir? createPortal ile Başlangıç', 'BasicPortalExample', 1
FROM topic WHERE slug = 'portals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Modal''lar için Portal Kullanmak', 'ModalWithPortalExample', 2
FROM topic WHERE slug = 'portals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Event Bubbling: Portal''ların Şaşırtıcı Davranışı', 'EventBubblingThroughPortalExample', 3
FROM topic WHERE slug = 'portals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Portal Hedefini Ayarlamak', 'PortalTargetSetupExample', 4
FROM topic WHERE slug = 'portals';
