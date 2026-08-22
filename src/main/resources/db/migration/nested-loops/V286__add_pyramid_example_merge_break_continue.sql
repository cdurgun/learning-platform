-- Kullanıcı, nested-loops konusuna ChatGPT ile birlikte tartıştığı bir örnek
-- (yıldızlardan piramit basma) eklenmesini istedi. Bu örnek gerçekten değerli
-- (döngü sınırlarının dış döngünün o anki değerine göre HESAPLANMASI, önceki
-- 6 örnekte hiç işlenmemiş bir kavram) ama lean şablonun "tam 6 örnek" kuralını
-- bozmamak için (kullanıcının kendisine de bu şekilde önerildi, kabul edildi)
-- YENİ bir 7. örnek eklemek yerine önceki `BreakInNestedLoopExample` +
-- `ContinueInNestedLoopExample` ikilisi TEK bir dosyada
-- (`BreakContinueInNestedLoopExample`) birleştirildi -- `while-do-while`
-- konusunda break/continue'nun zaten aynı şekilde tek dosyada birleştirilmiş
-- olması emsal alındı (bkz. Faz 84). Bu, V283-V285 ZATEN uygulanmış migration'ları
-- DEĞİŞTİRMİYOR -- yalnızca onların eklediği code_example satırlarını
-- güncelleyen YENİ bir migration.
--
-- Uygulanan değişiklik: eski `BreakInNestedLoopExample` satırı, yeni birleşik
-- `BreakContinueInNestedLoopExample` dosyasını gösterecek şekilde güncellendi;
-- eski `ContinueInNestedLoopExample` satırı artık ARTIK KULLANILMAYAN o dosya
-- yerine yeni `PyramidPrintingExample`'ı gösterecek ve sona (sort_order=6)
-- taşınacak şekilde güncellendi -- while-do-while'daki Number Guessing Game
-- gibi, piramit örneği de topic'in kapanış (en son) uygulamalı örneği oldu.
-- `LabeledBreakContinueExample` ve `NestedLoopPerformanceExample` satırları bir
-- pozisyon öne kaydırıldı. Toplamda hâlâ TAM 6 code_example -- lean şablon
-- korundu. Piramit örneği gerçekten bu sandbox'ta javac+java ile derlenip
-- çalıştırıldı -- rows=4 için "   *"/"  ***"/" *****"/"*******" çıktısı GERÇEKTEN
-- doğrulandı.

UPDATE code_example
SET title = 'İç İçe Döngülerde break ve continue',
    example_name = 'BreakContinueInNestedLoopExample'
WHERE example_name = 'BreakInNestedLoopExample'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'nested-loops');

UPDATE code_example
SET title = 'Uygulamalı Örnek: Yıldızlardan Piramit (Pyramid Printing)',
    example_name = 'PyramidPrintingExample',
    sort_order = 6
WHERE example_name = 'ContinueInNestedLoopExample'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'nested-loops');

UPDATE code_example
SET sort_order = 4
WHERE example_name = 'LabeledBreakContinueExample'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'nested-loops');

UPDATE code_example
SET sort_order = 5
WHERE example_name = 'NestedLoopPerformanceExample'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'nested-loops');

UPDATE topic
SET estimated_minutes = 22
WHERE slug = 'nested-loops';
