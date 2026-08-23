-- Kullanıcı, Exception Handling alt-müfredatının (bkz. Faz 97/98 -- introduction-
-- to-exceptions ve try-catch-finally, java-basics İÇİNDE yazıldı) `java-basics`
-- KATEGORİSİNİN İÇİNDE değil, kendi ayrı üst-seviye kategorisinde olmasını
-- istedi -- gerekçe: bu 7 topic'lik seri kendi başına tutarlı bir konu bütünü,
-- tıpkı Faz 51'de Interface/Abstract Class/Inheritance/Polymorphism'in "OOP"
-- kategorisine, Faz'ta (V268) Control Flow'un kendi kategorisine taşınması gibi
-- -- AYNI desen, birebir tekrarlanıyor.
--
-- Yeni kategori "java" kursuna, java-basics'in HEMEN ardına ekleniyor
-- (sort_order=2) -- kullanıcının "Exceptions, Java Basics'te zaten işlenen
-- temellerin üzerine inşa ediyor" gerekçesiyle. Diğer kategoriler V201/V268'deki
-- AYNI "sort_order kaydırma" deseniyle (her biri tek tek, blanket bir WHERE
-- DEĞİL) bir kaydırılıyor: control-flow(2->3), collections(3->4), oop(4->5),
-- concurrency(5->6), functional-interfaces-streams(6->7).
--
-- Şimdiye kadar yazılan İKİ topic (introduction-to-exceptions, try-catch-finally
-- -- bkz. V318/V321) java-basics'ten exceptions'a taşınıyor, kendi kategorisi
-- içinde 1'den başlayarak yeniden numaralandırılıyor (topic.sort_order
-- kategoriye özeldir, bkz. CLAUDE.md). java-basics'te GERİYE KALAN topic'lerin
-- sort_order'ı, iki topic'in bıraktığı boşluğu kapatmak için GERİ kaydırılıyor
-- -- file-reading 7->5, file-writing 8->6, enum 9->7, records 10->8,
-- reflection 11->9, date-time 12->10 (V318 ve V321'in yaptığı iki ayrı +1
-- kaydırmasının tam tersi, tek seferde) -- sonuç, java-basics'in exception
-- topic'leri hiç eklenmemiş gibi ORİJİNAL sıralamasına dönmesi.
--
-- İçerik/dosyalar HİÇ DEĞİŞMEDİ -- content/{lang}/{slug}.md ve examples/{slug}/*
-- yalnızca topic slug'ına göre bağlanıyor (bkz. CLAUDE.md "DB ↔ dosya
-- bağlantısı yalnızca slug convention ile kurulur"), kategori değişikliği bu
-- bağlantıyı hiç etkilemiyor -- topic.slug zaten kategoriden bağımsız olarak
-- GLOBAL olarak unique (bkz. V1 şema).

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Exceptions', 'exceptions', 2
FROM course
WHERE slug = 'java';

UPDATE category SET sort_order = 3 WHERE slug = 'control-flow';
UPDATE category SET sort_order = 4 WHERE slug = 'collections';
UPDATE category SET sort_order = 5 WHERE slug = 'oop';
UPDATE category SET sort_order = 6 WHERE slug = 'concurrency';
UPDATE category SET sort_order = 7 WHERE slug = 'functional-interfaces-streams';

UPDATE topic
SET category_id = (SELECT id FROM category WHERE slug = 'exceptions'),
    sort_order   = 1
WHERE slug = 'introduction-to-exceptions';

UPDATE topic
SET category_id = (SELECT id FROM category WHERE slug = 'exceptions'),
    sort_order   = 2
WHERE slug = 'try-catch-finally';

-- java-basics'te kalan topic'lerin sort_order'ını geri kaydır (boşluğu kapat).
UPDATE topic SET sort_order = 5 WHERE slug = 'file-reading';
UPDATE topic SET sort_order = 6 WHERE slug = 'file-writing';
UPDATE topic SET sort_order = 7 WHERE slug = 'enum';
UPDATE topic SET sort_order = 8 WHERE slug = 'records';
UPDATE topic SET sort_order = 9 WHERE slug = 'reflection';
UPDATE topic SET sort_order = 10 WHERE slug = 'date-time';
