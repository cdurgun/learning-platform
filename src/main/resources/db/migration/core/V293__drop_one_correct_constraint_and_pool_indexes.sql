-- Soru havuzu yeniden tasarımının 7. adımı. İki bağımsız değişikliği tek migration'da
-- topluyoruz çünkü ikisi de "havuz artık gerçekten kullanılabilir olsun" hedefine
-- hizmet ediyor ve aralarında bir sıralama bağımlılığı yok.
--
-- 1) uq_question_option_one_correct_per_question (eskiden uq_quiz_option_one_correct_
--    per_question, bkz. V259 + V288 rename), bir soru için EN FAZLA BİR doğru şık
--    olmasını GLOBAL olarak (tipten bağımsız) zorluyordu. Bu, MULTIPLE_CHOICE'ı DB
--    seviyesinde fiilen imkansız kılıyordu -- QuestionScorer/ingestion tip-farkındalı
--    doğrulamayı servis katmanında yapsa bile, DB birden fazla correct=true satırını
--    INSERT anında reddediyordu. Kısıtı kaldırıyoruz; tip-farkındalı kural (SINGLE_
--    CHOICE/CODE_OUTPUT ⇒ tam bir doğru, MULTIPLE_CHOICE ⇒ bir veya daha fazla) artık
--    yalnızca servis/ingestion katmanında uygulanacak (bkz. plan bölüm 5.1).
--    Mevcut enum quiz seçenekleri (hepsi SINGLE_CHOICE, zaten tam-bir-doğru) bu
--    kısıtı kaldırmaktan ETKİLENMEZ -- hiçbir satır değişmiyor, yalnızca gelecekteki
--    çok-doğru-şıklı INSERT'lerin artık REDDEDİLMEMESİ sağlanıyor.
--
--    NOT: question_option(question_id) üzerinde DÜZ bir index zaten mevcut --
--    idx_question_option_question (V259'da idx_quiz_option_question olarak
--    yaratıldı, V288'de bu isme yeniden adlandırıldı). O yüzden burada AYRICA bir
--    düz index YARATMIYORUZ -- aksi hâlde aynı sütun üzerinde gereksiz bir yinelenen
--    index eklenmiş olurdu.
-- Bu bir UNIQUE INDEX'ti (CREATE UNIQUE INDEX ... WHERE ...), adlandırılmış bir
-- table CONSTRAINT değil -- bu yüzden DROP INDEX ile kaldırılıyor, ALTER TABLE ...
-- DROP CONSTRAINT ile değil.
DROP INDEX IF EXISTS uq_question_option_one_correct_per_question;

-- 2) Practice havuzu sorgusu (topic+language+type+difficulty+status='PUBLISHED'
--    filtreli, rastgele seçim) için kompozit index. status en sona konuldu çünkü
--    her sorguda sabit ('PUBLISHED') olarak kullanılacak en seçici olmayan filtre.
CREATE INDEX idx_question_pool ON question (topic_id, language, type, difficulty, status);
