-- `control-flow` kategorisine dördüncü topic: `Enhanced for Loop` (slug:
-- enhanced-for-loop, sort_order=4). Kapsam: dizi/koleksiyon üzerinde temel for-each
-- sözdizimi, üç gerçek SINIRI (indekse erişilememesi; döngü değişkeninin bir kopya
-- olması ve yapısal değişikliğin genelde ConcurrentModificationException fırlatması;
-- birden fazla koleksiyonu paralel gezememe), ve klasik `for` ile seçim kriterleri.
-- "for Loop" (V274) dersine (Temel Sözdizimi/Dizi Gezinme/Birden Fazla Değişken
-- bölümlerine) ve "Lists" dersindeki "Iterator ve ListIterator" bölümüne çapraz
-- referans veriyor.
--
-- 6 örneğin tamamı bu sandbox'ta javac+java ile GERÇEKTEN derlenip çalıştırıldı --
-- bu sırada GERÇEK bir doğrulama bulgusu ortaya çıktı: ilk yazılan
-- ModifyingDuringIterationExample sürümü (listenin SONUNCU elemanına yakın bir
-- silme) ConcurrentModificationException'ı FIRLATMADI (ArrayList iterator'ının
-- hasNext()/modCount davranışının gerçek bir tuzağı -- silinen eleman listenin
-- sonuna yakınsa iç sayaçlar tesadüfen örtüşüp istisna fırlamayabiliyor); örnek,
-- istisnanın güvenilir şekilde fırladığı bir düzene (baştaki elemanı silme)
-- değiştirildi VE bu gerçek davranış bir Warning blockquote'una işlendi (kural
-- olarak "her zaman fırlar" DENMEDİ). Kod yorumları İNGİLİZCE (bkz. Faz 53).
--
-- BEGINNER zorlukta -- kategorinin diğer topic'leriyle aynı seviye.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'enhanced-for-loop', 'BEGINNER', 20, 4
FROM category
WHERE slug = 'control-flow';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Enhanced for Loop',
       'Control Flow kategorisinin dördüncü topic''i: dizi/koleksiyon üzerinde for-each sözdizimi, üç gerçek sınırı (indekse erişilememesi, döngü değişkeninin bir kopya olması ve yapısal değişikliğin ConcurrentModificationException fırlatması, birden fazla koleksiyonu paralel gezememe), ve klasik `for` ile ne zaman hangisinin kullanılacağı.',
       'Java Enhanced for (for-each) Nedir? Sınırları ve Örnekleri',
       'Java''nın enhanced for (for-each) döngüsü -- temel sözdizimi, üç gerçek sınırı, ve klasik `for` ile karşılaştırması -- gerçek Java örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'enhanced-for-loop';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Enhanced for Loop',
       'The fourth topic in the Control Flow category: the for-each syntax over arrays/collections, its three real limitations (no index access, the loop variable being a copy plus structural changes throwing ConcurrentModificationException, and no parallel iteration of multiple collections), and when to use it versus classic `for`.',
       'What Is Java Enhanced for (for-each)? Limitations and Examples',
       'Java''s enhanced for (for-each) loop -- basic syntax, its three real limitations, and how it compares to classic `for` -- explained with real Java examples.',
       false
FROM topic
WHERE slug = 'enhanced-for-loop';
