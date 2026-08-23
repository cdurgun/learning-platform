-- java-basics kategorisine, kullanıcının verdiği 7 topic'lik Exception Handling
-- alt-müfredatının İLKİ ekleniyor: "introduction-to-exceptions" -- wrapper-classes
-- (sort_order=4) ile file-reading (sort_order=5) arasına, kullanıcının açıkça
-- istediği konumda. Bu proje, arka arkaya eklenen her java-basics topic'inde
-- olduğu gibi (bkz. V213/V216/V219/V222/V225 -- string/arrays/scanner/
-- wrapper-classes/file-reading), sort_order'ı bir GAP/fractional şema DEĞİL, GERÇEK
-- bir tamsayı kaydırmasıyla yönetiyor -- bu yüzden file-reading'den itibaren HER
-- şey +1 kaydırılıyor.
--
-- Kapsam (7 topic'lik serinin 1.'si -- yalnızca GİRİŞ, henüz try/catch/throw
-- MEKANİĞİ YOK, sonraki 6 derse kasıtlı olarak bırakıldı): exception nedir,
-- neden var (dönüş-değeri-tabanlı hata sinyallemesinin sorunları), kısa tarihçe
-- (Java'nın checked exception kararı, sonraki dillerin bundan neden vazgeçtiği),
-- bir exception nesnesinin taşıdıkları (mesaj/cause/stack trace, Throwable'a
-- kısa bir ileri referansla -- tam hiyerarşi kendi dersinde), yakalanmamış bir
-- exception'ın programı nasıl sonlandırdığı, stack trace okuma/propagation, ve
-- yaygın runtime exception tetikleyicileri (NPE, ArrayIndexOutOfBounds,
-- NumberFormat, Arithmetic, ClassCast). try/catch YOK (bir sonraki ders), throw/
-- throws yalnızca BİR örnekte (PropagationThroughCallChainExample) minimal ve
-- açıkça "bu, throw/throws'un kendi dersine kısa bir önizleme" diye
-- çerçevelenerek kullanıldı -- serinin geri kalanıyla kavram TEKRARI yok.
--
-- Format kararı: bu proje bölgesindeki (string/arrays/scanner/wrapper-classes/
-- file-reading/file-writing) EN GÜNCEL java-basics konvansiyonu izlendi -- "## Ek:
-- Mini Proje" YOK (yalnızca reflection/date-time gibi daha eski topic'lerde var,
-- evrensel bir kural değil), estimated_minutes doğrudan son değerine (20)
-- yazıldı (skeleton-first eski topic'lerdeki gibi ayrı bir update migration'ı
-- YOK). Zorluk BEGINNER -- komşuları (wrapper-classes, file-reading) ile aynı.

UPDATE topic
SET sort_order = sort_order + 1
WHERE category_id = (SELECT id FROM category WHERE slug = 'java-basics')
  AND sort_order >= 5;

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'introduction-to-exceptions', 'BEGINNER', 20, 5
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Exception''lara Giriş',
       'Bir exception''ın gerçekte ne olduğu -- neden var olduğu (dönüş-değeri-tabanlı hata sinyallemesinin sorunları), Java''nın checked exception tasarım kararının kısa tarihçesi, bir exception nesnesinin taşıdığı mesaj/cause/stack trace, yakalanmamış bir exception''ın programı nasıl sonlandırdığı, stack trace okumak ve propagation, ve yaygın runtime exception tetikleyicileri (NullPointerException, ArrayIndexOutOfBoundsException, NumberFormatException). Bu serinin 7 dersinin ilki, henüz try/catch mekaniği yok.',
       'Java''da Exception Nedir? Exception Handling''e Giriş',
       'Java''da exception''ların ne olduğu, neden var olduğu, ve yakalanmamış bir exception''ın programı nasıl sonlandırdığı -- stack trace okumak, propagation, ve yaygın runtime exception''lar gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'introduction-to-exceptions';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Introduction to Exceptions',
       'What an exception actually is -- why it exists (the problems with return-value-based error signaling), a short history of Java''s checked exception design decision, the message/cause/stack trace an exception object carries, what happens when an exception goes uncaught, reading a stack trace and propagation, and the common runtime exception triggers (NullPointerException, ArrayIndexOutOfBoundsException, NumberFormatException). The first of 7 lessons in this series -- try/catch mechanics come next.',
       'What Is an Exception in Java? An Introduction to Exception Handling',
       'What exceptions are in Java, why they exist, and what happens when one goes uncaught -- reading a stack trace, propagation, and the common runtime exceptions, explained with real examples.',
       false
FROM topic
WHERE slug = 'introduction-to-exceptions';
