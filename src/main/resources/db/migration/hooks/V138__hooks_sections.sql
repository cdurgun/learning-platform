-- Hooks kategorisinin beş topic'i, 18 örneğin tamamı. Dosyaların kendisi
-- examples/what-are-hooks/, examples/use-effect/, examples/use-ref/,
-- examples/use-memo-use-callback/, examples/custom-hooks/ altında.

-- What Are Hooks? (2 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Hook Nedir?', 'WhatIsAHookExample', 1
FROM topic WHERE slug = 'what-are-hooks';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Hooks Kuralları (Rules of Hooks)', 'RulesOfHooksExample', 2
FROM topic WHERE slug = 'what-are-hooks';

-- useEffect (5 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Temel useEffect Kullanımı', 'BasicUseEffectExample', 1
FROM topic WHERE slug = 'use-effect';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Dependency Array: Boş Dizi []', 'EmptyDependencyArrayExample', 2
FROM topic WHERE slug = 'use-effect';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Dependency Array: Belirli Değerler', 'DependencyArrayExample', 3
FROM topic WHERE slug = 'use-effect';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Cleanup Fonksiyonu', 'CleanupFunctionExample', 4
FROM topic WHERE slug = 'use-effect';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Yaygın Hata: Infinite Loop', 'InfiniteLoopMistakeExample', 5
FROM topic WHERE slug = 'use-effect';

-- useRef (4 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'DOM Referansları (DOM References)', 'DomReferenceExample', 1
FROM topic WHERE slug = 'use-ref';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Render''lar Arası Kalıcı Değerler', 'PersistentValueExample', 2
FROM topic WHERE slug = 'use-ref';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'useRef vs useState', 'UseRefVsUseStateExample', 3
FROM topic WHERE slug = 'use-ref';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'useRef ve useEffect''i Birlikte Kullanmak', 'PreviousValueWithRefExample', 4
FROM topic WHERE slug = 'use-ref';

-- useMemo & useCallback (4 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'useMemo ile Hesaplama Sonucunu Önbelleğe Almak', 'UseMemoBasicExample', 1
FROM topic WHERE slug = 'use-memo-use-callback';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'useMemo ile Nesne Referansını Sabit Tutmak', 'ObjectMemoizationExample', 2
FROM topic WHERE slug = 'use-memo-use-callback';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'useCallback ile Fonksiyon Referansını Sabit Tutmak', 'UseCallbackBasicExample', 3
FROM topic WHERE slug = 'use-memo-use-callback';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Ne Zaman KULLANILMAMALI?', 'WhenNotToUseMemoExample', 4
FROM topic WHERE slug = 'use-memo-use-callback';

-- Custom Hooks (3 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'use Öneki ve İsimlendirme Kuralı', 'CustomHookNamingExample', 1
FROM topic WHERE slug = 'custom-hooks';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Aynı Hook''u Birden Fazla Kez Kullanmak', 'ReusingCustomHookExample', 2
FROM topic WHERE slug = 'custom-hooks';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Örnek: useFetch ile Veri Çekme', 'UseFetchExample', 3
FROM topic WHERE slug = 'custom-hooks';
