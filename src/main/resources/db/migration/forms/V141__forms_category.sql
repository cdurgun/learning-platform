-- Faz 33: "react" course'unun beşinci kategorisi -- "Forms" (category.sort_order=5,
-- hooks'tan sonra). ChatGPT planındaki Topic 16-17'ye karşılık geliyor: Controlled
-- Components, Form Handling.
--
-- ChatGPT'nin planındaki üçüncü topic (Topic 18 — Form Libraries: React Hook
-- Form, Zod) BİLİNÇLİ OLARAK ATLANDI -- planın kendisinde bile "daha sonra
-- eklenebilir, ilk React öğreniminde şart değil" notuyla işaretliydi.
-- AskUserQuestion ile kullanıcıya soruldu, "Yalnızca 2 konu (Önerilen)" seçildi.
-- İleride ayrı bir konu olarak eklenmek istenirse bu kategoriye yeni bir topic
-- olarak eklenebilir.
--
-- Kavram sırası kasıtlı: controlled-components.md, önceki kategorilerde
-- (State & Events'teki state-events projesi, Hooks'taki hooks projesi)
-- BİLİNÇLİ OLARAK kaçınılan "value={state} ile input'u kontrol etmek" desenini
-- ilk kez burada, tam bir derste işliyor. form-handling.md, bunu gerçek bir
-- forma (gönderim, çoklu alan, validation, hata mesajları) genişletiyor.
--
-- Zorluk seviyesi Hooks'tan (Faz 32) devam ederek INTERMEDIATE. Sade dil
-- kararı hâlâ geçerli, hiçbir topic'te "## Ek: Mini Proje" yok -- kategori
-- sonunda (form-handling'e) react-course-projects'teki beşinci Pratik Proje
-- eklenecek.
--
-- TR+EN aynı fazda yazıldı; tarihsel tutarlılık için TR published=true,
-- EN published=false olarak ekleniyor.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Forms', 'forms', 5
FROM course
WHERE slug = 'react';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'controlled-components', 'INTERMEDIATE', 5, 1
FROM category
WHERE slug = 'forms';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'form-handling', 'INTERMEDIATE', 5, 2
FROM category
WHERE slug = 'forms';

-- Topic 1: Controlled Components

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Controlled Components',
       'Controlled component nedir, value ve onChange ile bir input''u state''e bağlamak, checkbox/select''lerde de aynı deseni kullanmak -- basit örneklerle.',
       'React''te Controlled Components Nedir? | Basit Örneklerle Anlatım',
       'React''te bir controlled component''in ne olduğu, value ile bir input''u state''e bağlamak, onChange ile state''i güncel tutmak, checkbox ve select''lerde aynı deseni kullanmak, ve controlled component''lerin neden tercih edildiği -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'controlled-components';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Controlled Components',
       'What a controlled component is, binding an input to state with value and onChange, using the same pattern for checkboxes/selects -- with simple examples.',
       'What Are Controlled Components in React? | Explained with Simple Examples',
       'What a controlled component is in React, binding an input to state with value, keeping state up to date with onChange, using the same pattern for checkboxes and selects, and why controlled components are preferred -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'controlled-components';

-- Topic 2: Form Handling

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Form Handling',
       'onSubmit ile formu göndermek, birden fazla alanı tek bir state nesnesiyle yönetmek, validation ve hata mesajları göstermek -- basit örneklerle.',
       'React''te Form Handling Nedir? | Basit Örneklerle Anlatım',
       'React''te onSubmit ile bir formu göndermek, birden fazla alanı tek bir state nesnesinde yönetmek, gönderim öncesi basit validation yapmak, hata mesajlarını && ile conditional rendering ile göstermek, ve tüm formu doğrulamak -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'form-handling';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Form Handling',
       'Submitting a form with onSubmit, managing multiple fields with a single state object, validation, and displaying error messages -- with simple examples.',
       'What Is Form Handling in React? | Explained with Simple Examples',
       'Submitting a form with onSubmit in React, managing multiple fields in a single state object, doing simple validation at submit time, displaying error messages with && for conditional rendering, and validating the whole form -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'form-handling';
