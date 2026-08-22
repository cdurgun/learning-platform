-- V260/V261'de her sorunun doğru şıkkı hep sort_order=1 (A) konumundaydı — öğrenci
-- okumadan hep ilk şıkkı seçerek 5/5 alabiliyordu. Bu migration YALNIZCA sort_order'ı
-- günceller; is_correct değerine ya da hangi metnin doğru olduğuna DOKUNMAZ.
-- Doğru şıkkın hedef konumu (soru bazında, TR ve EN'de aynı): Soru 1 -> C, Soru 2 -> A
-- (zaten A, değişiklik yok), Soru 3 -> D, Soru 4 -> B, Soru 5 -> C.
-- Uygulama: mevcut sort_order=1 (doğru şık) ile hedef konumdaki şıkkın sort_order'ı
-- tek bir UPDATE içinde takas edilir (CASE, satırın güncelleme öncesi değerini okur).

-- Soru 1 -> C (3)
UPDATE quiz_option
SET sort_order = CASE
                      WHEN sort_order = 1 THEN 3
                      WHEN sort_order = 3 THEN 1
                      ELSE sort_order
    END
WHERE question_id IN (
    SELECT q.id FROM quiz_question q JOIN topic t ON t.id = q.topic_id
    WHERE t.slug = 'enum' AND q.sort_order = 1
);

-- Soru 3 -> D (4)
UPDATE quiz_option
SET sort_order = CASE
                      WHEN sort_order = 1 THEN 4
                      WHEN sort_order = 4 THEN 1
                      ELSE sort_order
    END
WHERE question_id IN (
    SELECT q.id FROM quiz_question q JOIN topic t ON t.id = q.topic_id
    WHERE t.slug = 'enum' AND q.sort_order = 3
);

-- Soru 4 -> B (2)
UPDATE quiz_option
SET sort_order = CASE
                      WHEN sort_order = 1 THEN 2
                      WHEN sort_order = 2 THEN 1
                      ELSE sort_order
    END
WHERE question_id IN (
    SELECT q.id FROM quiz_question q JOIN topic t ON t.id = q.topic_id
    WHERE t.slug = 'enum' AND q.sort_order = 4
);

-- Soru 5 -> C (3)
UPDATE quiz_option
SET sort_order = CASE
                      WHEN sort_order = 1 THEN 3
                      WHEN sort_order = 3 THEN 1
                      ELSE sort_order
    END
WHERE question_id IN (
    SELECT q.id FROM quiz_question q JOIN topic t ON t.id = q.topic_id
    WHERE t.slug = 'enum' AND q.sort_order = 5
);

-- Soru 2 -> A (1): doğru şık zaten sort_order=1'de, değişiklik gerekmiyor.
