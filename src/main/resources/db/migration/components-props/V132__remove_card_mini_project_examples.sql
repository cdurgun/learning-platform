-- component-composition dersindeki gömülü "Ek: Mini Proje" bölümü kaldırıldı;
-- yerine react-course-projects reposundaki gerçek, çalıştırılabilir
-- "Components & Props Demo" projesine bir link kondu (bkz. content/tr ve
-- content/en altındaki component-composition.md, "Pratik Proje" bölümü).
-- Bu iki satır artık markdown'da embed edilmiyor, o yüzden temizleniyor.
DELETE FROM code_example
WHERE example_name IN ('CardBase', 'CardDemo')
  AND topic_id = (SELECT id FROM topic WHERE slug = 'component-composition');
