-- Faz 38: "react" course'unun onuncu kategorisi -- "Testing"
-- (category.sort_order=10, advanced-react'ten sonra). ChatGPT planındaki
-- bölüm 10'a karşılık geliyor: Topic 31 — React Testing (Vitest, React
-- Testing Library, Component testing, User interaction testing).
--
-- ÖNEMLİ yapılandırma kararı: plan bu içeriği TEK bir topic başlığı ("React
-- Testing") altında dört alt-kavram olarak listeliyordu, önceki
-- kategorilerdeki gibi ayrı "Topic N — ..." maddeleri hâlinde değil. Bu
-- dört alt-kavram, planın kendi metnindeki iki doğal grup ile birebir
-- örtüştüğü için (Vitest+RTL kurulumu/component testing vs. user
-- interaction testing), AskUserQuestion sorulmadan iki topic'e bölündü:
-- `component-testing` (Vitest kurulumu, render+screen, getByRole/
-- getByLabelText, jest-dom matcher'ları, koşullu render testi) ve
-- `user-interaction-testing` (user-event, tıklama/yazma/form gönderimi,
-- asenkron UI güncellemeleri). Bu, içeriği azaltan bir karar DEĞİL --
-- planın kendi alt-madde başlıklarını iki derse ayırmaktan ibaret; bu
-- yüzden önceki "sonraya bırakma" kararlarından (Forms/API & Data
-- Fetching/State Management) farklı bir karar türü.
--
-- DOĞRULAMA: /tmp/testingcheck adlı bir scratch projede gerçek npm install
-- ile `vitest`, `@testing-library/react`, `@testing-library/user-event`,
-- `@testing-library/jest-dom` kuruldu (sürümler: vitest 4.1.10,
-- @testing-library/react 16.3.2, @testing-library/user-event 14.6.4,
-- @testing-library/jest-dom 7.0.1). Gerçek bir vite.config.js (test.
-- environment='jsdom', setupFiles) ve gerçek component+test dosyaları
-- yazılıp `npx vitest run` ile ÇALIŞTIRILDI -- render/screen/getByText/
-- getByRole/getByLabelText/toBeInTheDocument/toBeDisabled/toBeEnabled/
-- userEvent.setup().click/type/vi.fn()/toHaveBeenCalledWith/findByText
-- kalıplarının HEPSİ gerçekten geçti (12/12 test).
--
-- ÖNEMLİ teknik keşif: MarkdownService'teki embed regex'i
-- (\{\{(\w+)\.(\w+)}}) exampleName grubunda nokta karakterine İZİN VERMİYOR
-- -- yani gerçek dünyada yaygın olan "Component.test.jsx" isimlendirmesi
-- {{Component.test.jsx}} olarak GÖMÜLEMEZ (regex eşleşmez, literal metin
-- olarak kalır). Python'da doğrudan test edilip doğrulandı. Bu yüzden
-- examples/ altındaki dosyalar, kursun geri kalanıyla aynı tek-nokta
-- convention'ını kullanıyor (ör. "UserEventClickExample.jsx") -- component
-- ve testi AYNI dosyada birleştirerek. react-course-projects'teki GERÇEK
-- pratik proje ise bu kısıtlamaya tabi değil (Java regex motorundan
-- geçmiyor), o yüzden orada idiomatik "Component.test.jsx" isimlendirmesi
-- kullanılabilir.
--
-- Zorluk seviyesi INTERMEDIATE (Advanced React'in ADVANCED'ından sonra,
-- ama test yazmanın kendisi hooks/forms kadar temel bir React becerisi
-- değil; kursun genel INTERMEDIATE akışına -- Hooks'tan itibaren -- geri
-- dönülüyor, çünkü bu kategori yeni bir React API'si değil, VAR OLAN
-- component'leri doğrulama tekniği öğretiyor).
--
-- TR+EN aynı fazda yazıldı; tarihsel tutarlılık için TR published=true,
-- EN published=false olarak ekleniyor.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Testing', 'testing', 10
FROM course
WHERE slug = 'react';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'component-testing', 'INTERMEDIATE', 5, 1
FROM category
WHERE slug = 'testing';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'user-interaction-testing', 'INTERMEDIATE', 5, 2
FROM category
WHERE slug = 'testing';

-- Topic 1: Component Testing

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Component Testing',
       'Vitest ve React Testing Library kurulumu, render+screen ile ilk test, getByRole/getByLabelText ile sorgulama, jest-dom matcher''ları, ve koşullu render''ı test etmek -- basit örneklerle.',
       'React''te Component Testing: Vitest, React Testing Library | Basit Örneklerle Anlatım',
       'Bir Vite projesine Vitest ve React Testing Library kurmak, render() ve screen ile ilk testi yazmak, getByRole ve getByLabelText ile erişilebilirliğe yakın sorgular yapmak, @testing-library/jest-dom''un ekledigi toBeInTheDocument gibi matcher''ları kullanmak, ve koşullu render''ı queryBy* ile test etmek -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'component-testing';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Component Testing',
       'Setting up Vitest and React Testing Library, your first test with render+screen, querying with getByRole/getByLabelText, jest-dom matchers, and testing conditional rendering -- with simple examples.',
       'Component Testing in React: Vitest, React Testing Library | Explained with Simple Examples',
       'Setting up Vitest and React Testing Library in a Vite project, writing your first test with render() and screen, querying closer to accessibility with getByRole and getByLabelText, using matchers like toBeInTheDocument added by @testing-library/jest-dom, and testing conditional rendering with queryBy* -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'component-testing';

-- Topic 2: User Interaction Testing

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'User Interaction Testing',
       'user-event ile gerçekçi etkileşim simülasyonu, tıklamayı ve yazmayı test etmek, form gönderimini vi.fn() ile doğrulamak, ve asenkron UI güncellemelerini findBy* ile test etmek -- basit örneklerle.',
       'React''te User Interaction Testing: user-event, vi.fn() | Basit Örneklerle Anlatım',
       '@testing-library/user-event ile fireEvent''ten daha gerçekçi bir etkileşim simülasyonu yapmak, userEvent.setup() ile tıklamayı ve yazmayı test etmek, vi.fn() ile oluşturulan sahte fonksiyonlarla form gönderimini doğrulamak, ve useEffect ile zamanla değişen UI''ları findByText/waitFor ile test etmek -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'user-interaction-testing';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'User Interaction Testing',
       'Realistic interaction simulation with user-event, testing clicks and typing, verifying form submission with vi.fn(), and testing asynchronous UI updates with findBy* -- with simple examples.',
       'User Interaction Testing in React: user-event, vi.fn() | Explained with Simple Examples',
       'Simulating interactions more realistically than fireEvent with @testing-library/user-event, testing clicks and typing with userEvent.setup(), verifying form submission with mock functions created via vi.fn(), and testing UI that changes over time (useEffect) with findByText/waitFor -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'user-interaction-testing';
