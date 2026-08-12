-- Faz 29: "react" course'unun ikinci kategorisi -- "Components & Props"
-- (category.sort_order=2, react-fundamentals'tan sonra). Üç topic: Components,
-- Props, Component Composition -- ChatGPT planındaki orijinal Topic 4-5-6'ya karşılık
-- geliyor.
--
-- Bu kategoriden itibaren gerçek mini projeler başlıyor (bkz. CLAUDE.md Faz 28 notu:
-- "gerçek mini projeler Components & Props kategorisinden itibaren gelecek") -- ama
-- kullanıcının "sade dil, kolay örnekler" kararı hâlâ geçerli, bu yüzden yalnızca
-- component-composition'da TEK bir "## Ek: Mini Proje" var (Java/Spring derslerindeki
-- zorunlu 2'li ek kuralı burada uygulanmıyor), components ve props hiç ek içermiyor.
--
-- Üç topic de BEGINNER işaretlendi -- henüz state/hooks yok, hâlâ React'in en temel
-- yapı taşları (component, props, composition) anlatılıyor. TR+EN aynı fazda yazıldı;
-- tarihsel tutarlılık için TR published=true, EN published=false olarak ekleniyor.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Components & Props', 'components-props', 2
FROM course
WHERE slug = 'react';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'components', 'BEGINNER', 5, 1
FROM category
WHERE slug = 'components-props';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'props', 'BEGINNER', 5, 2
FROM category
WHERE slug = 'components-props';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'component-composition', 'BEGINNER', 5, 3
FROM category
WHERE slug = 'components-props';

-- Topic 1: Components

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Components',
       'Component nedir, fonksiyon olarak nasıl yazılır, nasıl kullanılır (render edilir), isimlendirme kuralı ve yeniden kullanılabilirlik -- basit örneklerle.',
       'React Component Nedir? | Basit Örneklerle Anlatım',
       'React''te bir component nedir, fonksiyon olarak nasıl yazılır, JSX içinde nasıl kullanılır, neden büyük harfle başlamalı ve nasıl yeniden kullanılır -- yeni başlayanlar için sade bir dille anlatılıyor.',
       true
FROM topic
WHERE slug = 'components';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Components',
       'What a component is, how to write one as a function, how to use (render) it, the naming rule, and reusability -- with simple examples.',
       'What Is a React Component? | Explained with Simple Examples',
       'What a component is in React, how to write one as a function, how to use it inside JSX, why it must start with an uppercase letter, and how to reuse it -- explained in plain language for beginners.',
       false
FROM topic
WHERE slug = 'components';

-- Topic 2: Props

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Props',
       'Props nedir, parent''tan child''a veri gönderme, birden fazla prop, destructuring, varsayılan değerler ve props''un normal fonksiyon parametrelerinden farkı.',
       'React Props Nedir? | Basit Örneklerle Anlatım',
       'React''te props nedir, bir component''e dışarıdan veri nasıl gönderilir, birden fazla prop nasıl kullanılır, destructuring ile props nasıl okunur, varsayılan değerler nasıl tanımlanır -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'props';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Props',
       'What props are, sending data from parent to child, using multiple props, destructuring, default values, and how props differ from regular function parameters.',
       'What Are Props in React? | Explained with Simple Examples',
       'What props are in React, how to send data into a component from outside, how to use multiple props, how to read props with destructuring, and how to define default values -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'props';

-- Topic 3: Component Composition

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Component Composition',
       'children prop''u, iç içe component''ler ve composition ile inheritance arasındaki fark -- yeniden kullanılabilir bir Card component''i mini projesiyle.',
       'React''te Component Composition Nedir? | Mini Proje ile Anlatım',
       'React''te children prop''unun ne olduğu, component''lerin nasıl iç içe kullanıldığı, composition ile inheritance arasındaki fark, ve yeniden kullanılabilir bir Card component''i mini projesiyle composition''ın gerçek bir örneği.',
       true
FROM topic
WHERE slug = 'component-composition';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Component Composition',
       'The children prop, nesting components, and the difference between composition and inheritance -- with a reusable Card component mini project.',
       'What Is Component Composition in React? | With a Mini Project',
       'What the children prop is in React, how components are nested, the difference between composition and inheritance, and a real example of composition with a reusable Card component mini project.',
       false
FROM topic
WHERE slug = 'component-composition';
