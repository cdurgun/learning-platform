-- Faz 70: Course tablosunda gerçek bir sort_order yoktu (bkz. CLAUDE.md "Bilinen
-- Kısıtlar" -- Faz 28'den beri işaretli bir risk), NavigationService kursları
-- courseRepository.findAll()'in döndüğü (pratikte id/insert) sıraya güveniyordu.
-- java=1/spring-boot=2/react=3 istenen sırayla örtüştüğü için şimdiye kadar
-- dokunulmamıştı; dördüncü bir kurs (ai) eklenirken kullanıcı onayıyla bu artık
-- gerçek bir kolonla çözülüyor -- Category/Topic'teki sort_order deseniyle birebir
-- aynı.
ALTER TABLE course
    ADD COLUMN sort_order INTEGER NOT NULL DEFAULT 0;

UPDATE course SET sort_order = 1 WHERE slug = 'java';
UPDATE course SET sort_order = 2 WHERE slug = 'spring-boot';
UPDATE course SET sort_order = 3 WHERE slug = 'react';
