-- Kategorinin altıncı topic'i: `optional` (sort_order=6, collectors'tan sonra).
-- Kullanıcı onayıyla ("kalan 2 topiği bitirebilirsin") aynı fazda TR+EN birlikte
-- yazıldı.
--
-- Orijinal 7 topic'lik plandaki 9. madde ("Optional": Optional<T>, map(), flatMap(),
-- orElse(), orElseGet(), orElseThrow()). Kapsam: Optional'ın var olma sebebi (null
-- güvenliğini tip sistemine taşımak), of()/ofNullable()/empty() ile oluşturma,
-- isPresent()/isEmpty()/get(), orElse() vs orElseGet() (eager vs lazy -- gerçekten
-- çalıştırılıp gözlemlendi), orElseThrow() (iki biçim), map()/flatMap() (Stream'deki
-- aynı iç içelik probleminin Optional karşılığı), ifPresent()/ifPresentOrElse(),
-- filter(). `terminal-operations`'taki Optional dönen beş metoda (reduce/min/max/
-- findFirst/findAny) ve `stream-fundamentals`'daki flatMap()'e çapraz referans veriyor.
--
-- GERÇEK GÖZLEM: OrElseExample.java, orElse()'in argümanının Optional DOLU olsa bile
-- her zaman hesaplandığını, orElseGet()'in Supplier'ının ise yalnızca Optional
-- BOŞSA çağrıldığını, gerçek çalıştırma çıktısıyla (her çağrıdan önce bir
-- System.out.println ile "computing default: ..." yazdırılarak) doğruluyor --
-- varsayımla değil, gözlemle.
--
-- Örnekler, aynı sandbox-compile süreciyle (/tmp/work/scratch/optional/ altında
-- javac+java) gerçekten derlenip çalıştırılarak doğrulandı; 6 dosya:
-- OptionalCreationExample, OrElseExample, OrElseThrowExample,
-- OptionalMapFlatMapExample, IfPresentExample, OptionalFilterExample.
--
-- Kullanıcı isteğiyle (Faz 42) ders metninde "derlenip doğrulandı" cümlesi yok, bu
-- doğrulama yalnızca bu migration yorumunda belgeleniyor.
--
-- Başlık: "Optional" -- kısa, kısaltmaya gerek yok.
--
-- INTERMEDIATE zorlukta -- kategorideki diğer topic'lerle aynı seviye.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'optional', 'INTERMEDIATE', 20, 6
FROM category
WHERE slug = 'functional-interfaces-streams';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Optional',
       'Optional<T>: bir değerin bulunmama ihtimalini tip sisteminde ifade etmek. of()/ofNullable()/empty() ile oluşturma, orElse() vs orElseGet() (eager vs lazy), orElseThrow(), map()/flatMap(), ifPresent()/ifPresentOrElse(), filter().',
       'Java Optional Nedir? orElse, orElseGet, map, flatMap Örnekleriyle Anlatım',
       'Java''nın Optional<T> sınıfı -- of()/ofNullable()/empty() ile Optional oluşturma, orElse() ile orElseGet() arasındaki eager/lazy değerlendirme farkı, orElseThrow() ile özel istisna fırlatma, map()/flatMap() ile içindeki değeri dönüştürme, ifPresent()/ifPresentOrElse() ile yan etki uygulama, ve filter() ile koşulla süzme -- gerçek Java örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'optional';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Optional',
       'Optional<T>: expressing the possibility of an absent value in the type system. Creating with of()/ofNullable()/empty(), orElse() vs. orElseGet() (eager vs. lazy), orElseThrow(), map()/flatMap(), ifPresent()/ifPresentOrElse(), filter().',
       'What Is Java Optional? Explained with orElse, orElseGet, map, flatMap Examples',
       'Java''s Optional<T> class -- creating an Optional with of()/ofNullable()/empty(), the eager-vs-lazy evaluation difference between orElse() and orElseGet(), throwing a custom exception with orElseThrow(), transforming the inner value with map()/flatMap(), applying a side effect with ifPresent()/ifPresentOrElse(), and filtering with a condition using filter() -- explained with real Java examples.',
       false
FROM topic
WHERE slug = 'optional';
