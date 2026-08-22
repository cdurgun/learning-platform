-- Faz 81 (devam): kullanici, "İzin Modeli/Ready to Code" gibi ekranlarin
-- "bu oturumda gozlemledigimiz davranis" olarak cercevelenmesi, CLAUDE.md
-- otomatik-okunur iddiasinin surum-dayanikli hale getirilmesi, kurulum
-- komutunun kisaltilip resmi belgelere yonlendirilmesi, "Plan Mode en
-- ayirt edici ozellik" -> "onemli ozelliklerinden biri", ve yeni "Etkili
-- Bir Gorev Nasil Verilir?"/"How to Give an Effective Task" bolumu (Kotu/
-- Daha iyi/En iyi ornek + bu dersin kendi planlama surecine geri referans)
-- gibi kucuk duzeltmeleri istedikten sonra TR+EN icerigi onayladi ("Hatalar
-- duzgun anlatilmis") ve EN cevirinin yayina alinmasini istedi.
--
-- V252/V258'deki ayni desen: TR yayinda kaldi, bu migration yalnizca EN
-- topic_translation kaydini published=true'ya ceviriyor.

UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id IN (
      SELECT id FROM topic WHERE slug = 'developing-with-claude-code'
  );
