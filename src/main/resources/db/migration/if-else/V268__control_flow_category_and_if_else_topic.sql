-- Kullanıcı ChatGPT ile "java-basics"i genişletme fikrini görüştü, sonra ChatGPT'nin
-- planını sadeleştirdi (break/continue ayrı bir topic değil, ilgili loop topic'lerinin
-- içine dağıtılacak -- for Loop'ta break, while & do-while'da continue/break kısaca
-- tekrar gösterilecek). Sonuçta 6 topic'lik yeni bir kategori planlandı: if / else,
-- switch, for Loop, Enhanced for Loop, while & do-while Loops, Nested Loops.
--
-- Yeni kategori "java" kursuna ikinci sırada (sort_order=2) ekleniyor -- java-basics'in
-- hemen ardına, collections/oop/concurrency/functional-interfaces-streams'ten önce.
-- Gerekçe: (1) java-basics zaten 10 topic'e ulaşmış durumda (String, Arrays, Scanner,
-- Wrapper Classes, File Reading, File Writing, Enum, Record, Reflection, Date & Time
-- API) -- bu, projenin bugüne kadarki en kalabalık tek-kategori örneği olan Spring
-- MVC'nin (9 topic) bile üzerinde, Control Flow'un 8 topic'lik ilk hâli (şimdi 6)
-- doğrudan java-basics'e eklenseydi kategori aşırı şişerdi -- tıpkı Faz 51'de OOP'nin,
-- ve sonrasında Collections/Functional Interfaces & Streams'in aynı gerekçeyle ayrı
-- kategori olarak açılması gibi. (2) Arrays/Scanner kategorisindeki mevcut örnek
-- dosyalarının 12'sinden 7'si zaten for/while döngüsü kullanıyor -- yani öğrenciler
-- döngüyü hiç resmi olarak görmeden örneklerde karşılaşıyor, bu da Control Flow'un
-- aslında java-basics'in geri kalanından daha temel/erken bir konu olduğunu gösteriyor.
-- Bu iki gerekçeyle kategori java-basics(1)'in hemen ardına, sort_order=2'ye açılıyor.
--
-- Diğer kategoriler V201/V179'daki aynı "sort_order kaydırma" deseniyle bir kaydırılıyor:
-- collections(2->3), oop(3->4), concurrency(4->5), functional-interfaces-streams(5->6).
--
-- BOYUT KARARI: Control Flow'un topic'leri (if/else, switch, döngüler) kavramsal olarak
-- java-basics'in son eklenen topic'leriyle (String/Arrays/Scanner/Wrapper Classes/File
-- Reading/File Writing -- V213-V228) aynı "tekil sözdizimi kavramı" seviyesinde --
-- Reflection/Interface/Abstract Class gibi derin mimari konularla değil. O yüzden bu
-- topic'ler için de AYNI "yalın" şablon kullanılıyor: bu 6 java-basics topic'inin
-- hepsinde tutarlı olarak 12 H2 (giriş 3 + orta 6, her biri bir örnek gömer + kapanış 3)
-- ve 6 kod örneği var, `## Ek: Mini Proje` YOK -- Enum'dan başlayıp Date & Time API'ye
-- kadar giden "büyük" şablonun (15-23 H2 + 2 mini proje eki) aksine. Kategori kapanışında
-- kullanıcının önerdiği tek bir "Practical Example" (Number Guessing Game) -- hangi
-- topic'in içine gömüleceği (muhtemelen while & do-while, çünkü do-while klasik "en az
-- bir kez sor" deseni) kategori tamamlanmadan netleştirilecek.
--
-- Bu migration yalnızca kategoriyi ve İLK topic'i (if-else) açıyor -- kullanıcı bu ilk
-- topic'i onayladıktan sonra kalan 5 topic'e devam edilecek.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Control Flow', 'control-flow', 2
FROM course
WHERE slug = 'java';

UPDATE category SET sort_order = 3 WHERE slug = 'collections';
UPDATE category SET sort_order = 4 WHERE slug = 'oop';
UPDATE category SET sort_order = 5 WHERE slug = 'concurrency';
UPDATE category SET sort_order = 6 WHERE slug = 'functional-interfaces-streams';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'if-else', 'BEGINNER', 20, 1
FROM category
WHERE slug = 'control-flow';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'if / else',
       'Yeni Control Flow kategorisinin ilk topic''i: `if`/`else`''in temel kullanımı, `else if` zinciri, iç içe koşullar, altı karşılaştırma operatörü (`==`/`!=`/`<`/`>`/`<=`/`>=`) ve ondalıklı sayı/`String` karşılaştırma tuzakları, `&&`/`||`/`!` mantıksal operatörleri ve kısa devre değerlendirme, ve üçlü (ternary) operatör.',
       'Java if / else Nedir? Örneklerle Koşullu İfadeler',
       'Java''da `if`/`else`, `else if` zinciri, iç içe koşullar, karşılaştırma ve mantıksal operatörler (kısa devre değerlendirme dahil), ve üçlü operatör -- gerçek Java örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'if-else';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'if / else',
       'The first topic in the new Control Flow category: the basics of `if`/`else`, `else if` chains, nested conditions, the six comparison operators (`==`/`!=`/`<`/`>`/`<=`/`>=`) with decimal number and `String` comparison pitfalls, the `&&`/`||`/`!` logical operators and short-circuit evaluation, and the ternary operator.',
       'What Is Java if / else? Conditional Statements Explained',
       'Java''s `if`/`else`, `else if` chains, nested conditions, comparison and logical operators (including short-circuit evaluation), and the ternary operator -- explained with real Java examples.',
       false
FROM topic
WHERE slug = 'if-else';
