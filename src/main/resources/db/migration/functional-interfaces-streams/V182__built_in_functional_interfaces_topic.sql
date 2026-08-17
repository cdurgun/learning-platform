-- Kategorinin ikinci topic'i: `built-in-functional-interfaces` (sort_order=2,
-- lambda-expressions'tan sonra). Kullanıcı onayıyla ("olur devam edebilirsin") aynı
-- fazda TR+EN birlikte yazıldı, topic 1'deki "önce TR" ritmi burada tekrarlanmadı.
--
-- `java.util.function` paketindeki hazır interface'leri (Predicate, Function, Consumer,
-- Supplier, UnaryOperator, BinaryOperator) ve dört method reference biçimini
-- (Class::staticMethod, object::instanceMethod, Class::instanceMethod, Class::new)
-- kapsıyor. `interface` dersindeki "Functional Interface ve Lambda" bölümüne ve
-- `lambda-expressions` dersindeki "Lambda'nın Functional Interface ile Bağlantısı:
-- Target Typing" bölümüne çapraz referans veriyor, tekrarlamıyor.
--
-- Örnekler, topic 1'de kurulan sandbox-compile sürecinin aynısıyla doğrulandı:
-- /tmp/work/scratch/builtin-fi/ altında javac+java ile gerçekten derlenip çalıştırıldı,
-- çıktılar gözlemlenip içeriğe işlendi, sonra examples/built-in-functional-interfaces/
-- altına kopyalandı. 6 dosya: PredicateExample, FunctionExample,
-- ConsumerSupplierExample, UnaryBinaryOperatorExample, MethodReferenceExample,
-- ConstructorReferenceExample (bu sonuncusu bir `record Point` de içeriyor).
--
-- Başlık kısaltıldı: içerik "Built-in Functional Interfaces & Method References"
-- konusunu kapsıyor ama sidebar başlığı "Mikroservis Yapılandırma" (spring-boot-
-- microservice-basics) precedent'iyle tutarlı olarak kısa tutuldu.
--
-- INTERMEDIATE zorlukta -- lambda-expressions ile aynı seviye.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'built-in-functional-interfaces', 'INTERMEDIATE', 22, 2
FROM category
WHERE slug = 'functional-interfaces-streams';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Built-in Functional Interfaces',
       'java.util.function paketindeki hazır interface''ler: Predicate<T>, Function<T,R>, Consumer<T>, Supplier<T>, UnaryOperator<T>, BinaryOperator<T>. Dört method reference biçimi: Class::staticMethod, object::instanceMethod, Class::instanceMethod, Class::new. Örnekler gerçekten derlenip çalıştırılarak doğrulandı.',
       'Java Built-in Functional Interfaces ve Method Reference Nedir? Örneklerle Anlatım',
       'Java''nın java.util.function paketindeki hazır functional interface''leri -- Predicate<T> (koşul kontrolü), Function<T,R> (dönüşüm), Consumer<T> ve Supplier<T> (yan etki ve üretim), UnaryOperator<T> ve BinaryOperator<T> (Function/BiFunction''ın özel halleri) -- ve dört method reference biçimini (Class::staticMethod, object::instanceMethod, Class::instanceMethod, Class::new constructor reference) gerçek, derlenip çalıştırılmış Java örnekleriyle anlatıyor.',
       true
FROM topic
WHERE slug = 'built-in-functional-interfaces';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Built-in Functional Interfaces',
       'The ready-made interfaces in java.util.function: Predicate<T>, Function<T,R>, Consumer<T>, Supplier<T>, UnaryOperator<T>, BinaryOperator<T>. The four method reference forms: Class::staticMethod, object::instanceMethod, Class::instanceMethod, Class::new. Examples were actually compiled and run to verify them.',
       'What Are Java Built-in Functional Interfaces and Method References? Explained with Examples',
       'Java''s ready-made functional interfaces in java.util.function -- Predicate<T> (condition checking), Function<T,R> (transformation), Consumer<T> and Supplier<T> (side effects and production), UnaryOperator<T> and BinaryOperator<T> (specialized forms of Function/BiFunction) -- and the four method reference forms (Class::staticMethod, object::instanceMethod, Class::instanceMethod, Class::new constructor reference) -- explained with real, compiled-and-run Java examples.',
       false
FROM topic
WHERE slug = 'built-in-functional-interfaces';
