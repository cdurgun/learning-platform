-- Kategorinin yedinci ve SON topic'i: `primitive-parallel-streams` (sort_order=7,
-- optional'dan sonra). Kullanıcı onayıyla ("kalan 2 topiği bitirebilirsin") aynı fazda
-- TR+EN birlikte yazıldı -- bu, `functional-interfaces-streams` kategorisinin planlanan
-- 7 topic'inin TAMAMINI tamamlıyor (bkz. V179'daki orijinal plan).
--
-- Orijinal 7 topic'lik plandaki 10. ve 11. maddeler ("Primitive Streams": IntStream,
-- LongStream, DoubleStream, Boxing/unboxing; "Parallel Streams": parallelStream(), Ne
-- zaman kullanılmalı?, Neden her zaman daha hızlı değildir?) tek topic'te birleştirildi
-- -- ikisi de kısa, birbirinden bağımsız iki alt-konu olduğu için ayrı topic'e
-- bölünmedi (stream-fundamentals'daki Stream API + Intermediate Operations birleştirme
-- kararıyla aynı gerekçe).
--
-- Kapsam: IntStream/LongStream/DoubleStream'in var olma sebebi (autoboxing maliyeti),
-- range()/rangeClosed()/of() ile oluşturma, sum()/average()/max()/min(),
-- boxed()/mapToObj() ve mapToInt()/mapToLong()/mapToDouble() köprüleri,
-- parallelStream()/.parallel(), forEach() vs forEachOrdered() (sıralama garantisi),
-- thread-safe olmayan paylaşılan durumla ilgili gerçek bir tuzak, ne zaman
-- kullanılmalı, ve neden her zaman daha hızlı olmadığı (ısıtılmış/warmed-up bir
-- ölçümle gösterildi).
--
-- ÜÇ GERÇEK GÖZLEM (varsayımla değil, sandbox'ta gerçekten çalıştırılarak elde
-- edildi):
-- 1) ParallelOrderingExample.java: aynı 10 elemanlı listede parallelStream().forEach()
--    sırayı GERÇEKTEN bozdu (unordered.equals(numbers) == false),
--    forEachOrdered() ise korudu (true) -- dokümantasyondaki iddia burada gerçek
--    çalıştırmayla doğrulandı.
-- 2) ParallelPitfallExample.java: 100.000 elemanlı bir listede, thread-safe olmayan
--    bir ArrayList'e paralel forEach() ile yazmak, HİÇBİR İSTİSNA FIRLATMADAN, farklı
--    çalıştırmalarda 96.901 ile 100.000 arasında değişen boyutlar üretti (bazı
--    çalıştırmalarda şans eseri doğru çıktı) -- gerçek, sessiz bir veri yarışı.
-- 3) ParallelOverheadExample.java: İLK YAZIMDA ısıtmasız (no-warmup) tek seferlik bir
--    nanoTime() karşılaştırması YANLIŞ bir sonuç verdi -- sıralı yol, sırf İLK
--    çalışan yol olduğu için (JIT henüz devrede değilken), paralelden defalarca daha
--    yavaş çıktı; bu, beklenen "küçük veride sıralı kazanır" anlatısının TAM TERSİYDİ.
--    Örnek, her iki yolu da 10.000 kez ısıtıp SONRA ölçecek şekilde yeniden yazıldı;
--    ısıtılmış ölçümle sonuç beklenen yöne döndü (sıralı ~15ms, paralel ~41ms). Bu,
--    sandbox-compile sürecinin ("gerçekten çalıştır, gözlemle, varsayımla yazma")
--    tam olarak önlemeye çalıştığı türden bir hataydı -- gerçek çalıştırma olmasaydı
--    ders yanlış bir iddiayla yayınlanabilirdi.
--
-- `built-in-functional-interfaces`'e (autoboxing/Function<T,R>) ve `collectors`'a
-- (Collectors.toList() ile thread-safe toplama) çapraz referans veriyor.
--
-- Kullanıcı isteğiyle (Faz 42) ders metninde "derlenip doğrulandı" cümlesi yok --
-- ama bu topic'in ParallelOverheadExample.java keşfinde olduğu gibi, gerçek
-- çalıştırmadan elde edilen SPESİFİK gözlemler (ms değerleri, gözlemlenen boyut
-- aralığı) ders metninde doğrudan kullanıldı; bu, "derlenip doğrulandı" genellemesi
-- değil, somut bir veri noktası olduğu için kullanıcının itirazına takılmıyor.
--
-- Başlık: "Primitive & Parallel Streams" -- kısa, kısaltmaya gerek yok.
--
-- INTERMEDIATE zorlukta -- kategorideki diğer topic'lerle aynı seviye.
--
-- KATEGORİ TAMAMLANDI: bu, `functional-interfaces-streams` kategorisinin planlanan
-- 7. ve son topic'i. Kategori artık TR+EN tamamen tamamlanmış durumda.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'primitive-parallel-streams', 'INTERMEDIATE', 25, 7
FROM category
WHERE slug = 'functional-interfaces-streams';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Primitive & Parallel Streams',
       'IntStream/LongStream/DoubleStream ile autoboxing maliyetinden kaçınmak, boxed()/mapToInt() köprüleri. parallelStream() ile paralel çalışma, forEach() vs forEachOrdered() sıralama farkı, thread-safe olmayan paylaşılan durum tuzağı, ne zaman kullanılmalı ve neden her zaman daha hızlı olmadığı.',
       'Java IntStream ve Parallel Stream Nedir? Örneklerle Anlatım',
       'Java''nın primitive stream tipleri (IntStream, LongStream, DoubleStream) ile autoboxing maliyetinden kaçınmak, sum()/average()/max()/min(), boxed()/mapToObj() ve mapToInt()/mapToLong()/mapToDouble() köprüleri; parallelStream() ile bir pipeline''ı thread''lere dağıtmak, forEach() ile forEachOrdered() arasındaki sıralama farkı, thread-safe olmayan paylaşılan durumla ilgili gerçek bir veri yarışı tuzağı, ve ısıtılmış bir ölçümle paralel stream''in ne zaman gerçekten daha hızlı olduğu.',
       true
FROM topic
WHERE slug = 'primitive-parallel-streams';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Primitive & Parallel Streams',
       'Avoiding autoboxing cost with IntStream/LongStream/DoubleStream, the boxed()/mapToInt() bridges. Running in parallel with parallelStream(), the forEach() vs. forEachOrdered() ordering difference, a non-thread-safe shared state pitfall, when to use it, and why it is not always faster.',
       'What Are Java IntStream and Parallel Streams? Explained with Examples',
       'Java''s primitive stream types (IntStream, LongStream, DoubleStream) for avoiding autoboxing cost, sum()/average()/max()/min(), the boxed()/mapToObj() and mapToInt()/mapToLong()/mapToDouble() bridges; running a pipeline across threads with parallelStream(), the ordering difference between forEach() and forEachOrdered(), a real data-race pitfall with non-thread-safe shared state, and when a parallel stream is genuinely faster, shown via a warmed-up measurement.',
       false
FROM topic
WHERE slug = 'primitive-parallel-streams';
