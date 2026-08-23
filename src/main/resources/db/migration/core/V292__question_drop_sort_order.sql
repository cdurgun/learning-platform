-- Soru havuzu yeniden tasarımının 6. adımı (Faz B). question.sort_order artık
-- gereksiz: sabit quiz sıralaması quiz_question_link.position'da, Practice modu
-- zaten rastgele seçim yapıyor (deterministik bir sıraya ihtiyacı yok).
-- DİKKAT: bu migration YALNIZCA V291 (sort_order -> position taşıması) çalıştıktan
-- SONRA güvenlidir -- V291'den önce çalıştırılırsa position değerleri kaybolur.
ALTER TABLE question DROP COLUMN sort_order;
