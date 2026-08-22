-- Faz 82: "ai-development-tools" kategorisinin ikinci topic'i --
-- "claude-code-cli-commands" (sort_order=2, "developing-with-claude-code"in
-- ardindan).
--
-- Faz 81'deki topic tek bir gercek oturumun bastan sona anlatisiydi
-- (analiz -> plan -> implementasyon -> test -> review -> git). Bu topic
-- bilincli olarak farkli bir role sahip: ChatGPT ile yapilan bir tartismada
-- onerilen, ve kullanicinin onayladigi bir "hizli basvuru" dersi -- session
-- yonetimi (--continue/--resume//resume), context yonetimi (/compact
-- vs /clear), izin modlari/Plan Mode kontrolu, ve komut kesfetme
-- aliskanligi. Amac bir komut listesini ezberletmek degil, "ihtiyacim
-- oldugunda dogru komutu nasil bulurum" sorusuna cevap vermek.
--
-- Icerik iki kaynaktan doğrulandi: resmi Claude Code dokumantasyonu
-- (code.claude.com/docs) ve platformun gelistiricisinin GERCEK CLI
-- oturumunda (22 Agustos 2026, Claude Code v2.1.238, Claude Pro) canli
-- olarak calistirilan komutlar/ekran ciktilari -- versiyon-bagimli hicbir
-- CLI davranisi dogrulanmadan "kesin" olarak sunulmadi (bkz. icerik
-- dosyasindaki Warning bloklari).
--
-- estimated_minutes=22, kullanicinin onayladigi 20-25 dk hedefine gore.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'claude-code-cli-commands', 'INTERMEDIATE', 22, 2
FROM category
WHERE slug = 'ai-development-tools';
