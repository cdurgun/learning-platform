-- İngilizce çeviriler tamamlandı (content/en/what-is-react.md, creating-a-react-application.md,
-- jsx.md) -- TR ile birebir aynı başlık ve embed sayısı/sırası. Üçü birden yayına alınıyor.
--
-- Bu, "React" course'unun ilk kategorisi "React Fundamentals"ın tamamlanışı -- kurs
-- artık üç yayında topic'e sahip. Sıradaki kategori: "Components & Props".
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id IN (SELECT id FROM topic WHERE slug IN ('what-is-react', 'creating-a-react-application', 'jsx'));
