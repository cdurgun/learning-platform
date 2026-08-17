-- Kategorinin beşinci topic'i: `collectors` (sort_order=5, terminal-operations'tan
-- sonra). Kullanıcı onayıyla ("olur devam edebilirsin") aynı fazda TR+EN birlikte
-- yazıldı.
--
-- Orijinal 7 topic'lik plandaki 8. madde ("Collectors": Collectors.toList(), toSet(),
-- joining(), groupingBy(), partitioningBy(), mapping(), counting()). Kapsam: bir
-- Collector'ın üç bileşeni (supplier/accumulator/combiner, kavramsal giriş),
-- Collectors.toList()/toSet(), joining() (3 overload), groupingBy() (+ downstream
-- collector olarak counting()/mapping()), partitioningBy(), toMap() (+ üç argümanlı
-- merge fonksiyonu hali). `terminal-operations`'taki "toList() ve toArray(): Basit
-- Koleksiyona Dönüştürme" bölümüne çapraz referans veriyor -- Stream.toList()
-- (immutable) ile collect(Collectors.toList()) (mutable) arasındaki fark, bu iki
-- dersi birbirine bağlayan ana nokta.
--
-- Örnekler, aynı sandbox-compile süreciyle (/tmp/work/scratch/collectors/ altında
-- javac+java) gerçekten derlenip çalıştırılarak doğrulandı; 6 dosya: ToListToSetExample,
-- JoiningExample, GroupingByExample, GroupingByDownstreamExample, PartitioningByExample,
-- ToMapExample (bu sonuncusu Collectors.toMap()'in çakışan anahtarlarda gerçek bir
-- IllegalStateException fırlattığını yakalayarak gösteriyor).
--
-- Kullanıcı isteğiyle (Faz 42) ders metninde "derlenip doğrulandı" cümlesi yok, bu
-- doğrulama yalnızca bu migration yorumunda belgeleniyor.
--
-- Başlık: "Collectors" -- kısa, kısaltmaya gerek yok.
--
-- INTERMEDIATE zorlukta -- kategorideki diğer topic'lerle aynı seviye.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'collectors', 'INTERMEDIATE', 22, 5
FROM category
WHERE slug = 'functional-interfaces-streams';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Collectors',
       'Collectors sınıfının sunduğu hazır collect() tarifleri: toList()/toSet(), joining(), groupingBy() (+ downstream collector olarak counting()/mapping()), partitioningBy(), toMap(). Bir Collector''ın üç bileşeni: supplier, accumulator, combiner.',
       'Java Stream Collectors Nedir? groupingBy, joining, toMap Örnekleriyle',
       'Java Stream API''deki Collectors sınıfı -- toList()/toSet() ile basit koleksiyonlara toplama, joining() ile string birleştirme, groupingBy() ile elemanları anahtara göre gruplama, counting()/mapping() ile downstream collector''lar, partitioningBy() ile ikiye ayırma, ve toMap() ile Map oluşturma (çakışan anahtarlar için merge fonksiyonu dahil) -- gerçek Java örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'collectors';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Collectors',
       'The ready-made collect() recipes the Collectors class offers: toList()/toSet(), joining(), groupingBy() (with counting()/mapping() as downstream collectors), partitioningBy(), toMap(). The three parts of a Collector: supplier, accumulator, combiner.',
       'What Are Java Stream Collectors? Explained with groupingBy, joining, toMap',
       'The Collectors class in the Java Stream API -- gathering into simple collections with toList()/toSet(), joining strings with joining(), grouping elements by a key with groupingBy(), downstream collectors like counting()/mapping(), splitting into two with partitioningBy(), and building a Map with toMap() (including a merge function for colliding keys) -- explained with real Java examples.',
       false
FROM topic
WHERE slug = 'collectors';
