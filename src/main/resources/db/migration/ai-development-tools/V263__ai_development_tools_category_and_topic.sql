-- Faz 81: "AI Development Tools" -- "ai" kursunun besinci kategorisi
-- (sort_order=5), "ai-fundamentals" (Faz 70), "large-language-models"
-- (Faz 71), "tools-mcp" (Faz 72-74) ve "ai-agents" (Faz 80) kategorilerinin
-- ardindan. Faz 80'in sonunda kullaniciya "ai" kursu tamamlandi mi yoksa ek
-- bir kategori/wave istiyor mu diye tek tarafli varsayilmadan soruldu; bu
-- Faz, kullanicinin secimi olan yeni kategoriye karsilik geliyor.
--
-- Onceki dort kategori AI'i disaridan (ne oldugunu, nasil calistigini)
-- ogretti; bu kategori AI'i bizzat bir gelistirme araci olarak, gercek bir
-- terminal oturumunda kullanmayi ogretiyor. Ilk (ve su an icin tek) topic'i
-- Claude Code -- kategori adi bilincli olarak "AI Development Tools" (ust
-- seviyede arac-tarafsiz) birakildi ki ileride "Cursor ile...", "GitHub
-- Copilot ile..." gibi kardes topic'ler ayni kategoriye eklenebilsin;
-- kullanicinin onayladigi karar buydu.
--
-- ONEMLI NUMARALANDIRMA NOTU: bu migration'in versiyon numarasi (V263),
-- bu sandbox kopyasindaki mevcut en yuksek numaradan (V258) degil,
-- kullanicinin KENDI yerel ortaminda ayni oturumda gerceklestirdigi Quiz
-- ozelligi calismasinin (enum konusuna V259-V262 araliginda eklenen dort
-- migration -- sema, sorular, secenekler, ve bir icerik-kalitesi
-- duzeltmesi) uzerine devam edecek sekilde secildi. Bu iki degisiklik
-- kumesi (Quiz ozelligi ve bu kategori) sonunda ayni gercek depoda
-- birlestirilecegi icin, V259'dan degil V263'ten baslamak, birlestirme
-- aninda bir versiyon numarasi cakismasini (iki farkli dosyanin ayni V259
-- olmasi) onceden onluyor.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'AI Development Tools', 'ai-development-tools', 5
FROM course
WHERE slug = 'ai';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'developing-with-claude-code', 'INTERMEDIATE', 35, 1
FROM category
WHERE slug = 'ai-development-tools';
