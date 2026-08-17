-- Kategorinin üçüncü topic'i: `stream-fundamentals` (sort_order=3, built-in-functional-
-- interfaces'ten sonra). Kullanıcı onayıyla ("evet yeni konuya geçebilirsin") aynı fazda
-- TR+EN birlikte yazıldı.
--
-- Orijinal 7 topic'lik plandaki 5. ve 6. maddeleri ("Stream API" ve "Intermediate
-- Operations") birleştirdi -- ChatGPT'nin planında bu ikisi zaten birbirine çok yakın
-- (Stream nedir/Collection->Stream/intermediate vs terminal operations kavramı VE
-- filter/map/flatMap/distinct/sorted/peek/limit/skip metotları), ayrı iki topic'e
-- bölünseydi ilki neredeyse tek başına kavramsal bir giriş olurdu.
--
-- Kapsam: Stream nedir (veri saklamayan, tek geçişlik pipeline), source (stream()/of()/
-- Arrays.stream()/iterate()), pipeline'ın üç aşaması (source/intermediate/terminal),
-- filter/map/flatMap, distinct/sorted/peek, limit/skip, lazy evaluation, stream'in tek
-- kullanımlık doğası (IllegalStateException). `interface`, `lambda-expressions`,
-- `built-in-functional-interfaces` derslerine çapraz referans veriyor -- kullanıcının
-- paylaştığı names.stream().filter(...).map(...).toList() örneği, "Neden Var?"
-- bölümünde bu üç dersin bir araya geldiği nokta olarak doğrudan kullanıldı.
--
-- Örnekler, aynı sandbox-compile süreciyle (/tmp/work/scratch/stream-fundamentals/
-- altında javac+java) gerçekten derlenip çalıştırılarak doğrulandı; 6 dosya:
-- StreamCreationExample, FilterMapExample, FlatMapExample, DistinctSortedPeekExample,
-- LimitSkipExample, LazyEvaluationExample (bu sonuncusu Stream'in tek kullanımlık
-- doğasını gerçek bir IllegalStateException yakalayarak gösteriyor).
--
-- Kullanıcının isteğiyle (Faz 41 devamı) bu ve sonraki topic'lerin summary/seo alanlarına
-- ve ders metnine "örnekler derlenip doğrulandı" türünden bir cümle KONULMUYOR -- bu not
-- yalnızca migration yorumlarında (iç süreç dokümantasyonu) kalıyor.
--
-- Başlık kısaltıldı (sidebar precedent'i, bkz. V182 notu): "Stream API Fundamentals &
-- Intermediate Operations" yerine "Stream API Temelleri" / "Stream API Fundamentals".
--
-- INTERMEDIATE zorlukta -- kategorideki diğer topic'lerle aynı seviye.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'stream-fundamentals', 'INTERMEDIATE', 25, 3
FROM category
WHERE slug = 'functional-interfaces-streams';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Stream API Temelleri',
       'Stream API''nin temelleri: Stream nedir, Collection''dan Stream''e geçiş, pipeline''ın üç aşaması (source/intermediate/terminal). Intermediate operation''lar: filter(), map(), flatMap(), distinct(), sorted(), peek(), limit(), skip(). Lazy evaluation ve stream''in tek kullanımlık doğası.',
       'Java Stream API Nedir? filter, map, flatMap Örnekleriyle Anlatım',
       'Java Stream API''nin temelleri -- bir Stream''in veri saklamayan, tek geçişlik bir pipeline olması, Collection''dan stream() ile Stream''e geçiş, filter() ile eleme, map() ve flatMap() ile dönüştürme/düzleştirme, distinct()/sorted()/peek(), limit()/skip() ile sayfalama, intermediate operation''ların lazy (tembel) çalışması, ve bir stream''in yalnızca bir kez tüketilebilmesi -- gerçek Java örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'stream-fundamentals';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Stream API Fundamentals',
       'The fundamentals of the Stream API: what a Stream is, moving from a Collection to a Stream, the three stages of a pipeline (source/intermediate/terminal). Intermediate operations: filter(), map(), flatMap(), distinct(), sorted(), peek(), limit(), skip(). Lazy evaluation and a stream''s single-use nature.',
       'What Is the Java Stream API? Explained with filter, map, flatMap Examples',
       'The fundamentals of the Java Stream API -- a Stream as a single-pass pipeline that doesn''t store data, moving from a Collection to a Stream with stream(), filtering with filter(), transforming and flattening with map() and flatMap(), distinct()/sorted()/peek(), pagination with limit()/skip(), the lazy evaluation of intermediate operations, and why a stream can only be consumed once -- explained with real Java examples.',
       false
FROM topic
WHERE slug = 'stream-fundamentals';
