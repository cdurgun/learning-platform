-- Kullanıcı, `java` kursuna yeni bir üst-seviye "Generics" kategorisi istedi --
-- `java-basics`'in İÇİNDE değil, `exceptions`'ın (Faz 99'da aynı gerekçeyle
-- kendi kategorisine ayrılmıştı) HEMEN ARDINA, kendi ayrı kategorisi olarak.
-- V201 (collections), V268 (control-flow) ve V324 (exceptions) ile AYNI,
-- artık üç kez kullanılmış "yeni kategori ekle + sonraki kategorileri tek
-- tek kaydır" deseni tekrarlanıyor.
--
-- Mevcut sıra (V324 sonrası, CLAUDE.md'de doğrulandı): java-basics(1),
-- exceptions(2), control-flow(3), collections(4), oop(5), concurrency(6),
-- functional-interfaces-streams(7). Yeni "generics" kategorisi sort_order=3'e
-- ekleniyor, diğer beşi TEK TEK bir kaydırılıyor: control-flow(3->4),
-- collections(4->5), oop(5->6), concurrency(6->7),
-- functional-interfaces-streams(7->8).
--
-- Bu migration yalnızca kategoriyi açıyor -- topic'ler ayrı migration'larda,
-- Exception Handling serisindeki gibi (Faz 97-104) TEK SEFERDE BİR TOPIC,
-- her topic'ten sonra kullanıcı onayı beklenerek eklenecek. Planlanan 6 topic
-- (sort_order): 1) introduction-to-generics, 2) generic-methods,
-- 3) bounded-type-parameters, 4) wildcards, 5) generics-with-collections,
-- 6) type-erasure-and-generic-limitations. Kullanıcının açık talimatı gereği
-- bu kategoriye şimdilik bir "Pratik Proje" eklenmeyecek.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Generics', 'generics', 3
FROM course
WHERE slug = 'java';

UPDATE category SET sort_order = 4 WHERE slug = 'control-flow';
UPDATE category SET sort_order = 5 WHERE slug = 'collections';
UPDATE category SET sort_order = 6 WHERE slug = 'oop';
UPDATE category SET sort_order = 7 WHERE slug = 'concurrency';
UPDATE category SET sort_order = 8 WHERE slug = 'functional-interfaces-streams';
