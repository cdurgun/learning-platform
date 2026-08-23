-- exceptions kategorisine, Exception Handling serisinin 5.'si ekleniyor:
-- "throw-and-throws" -- checked-vs-unchecked-exceptions'ın (sort_order=4)
-- hemen ardına, sort_order=5. Kategori şu an dört topic içeriyor, sort_order
-- kaydırması gerekmiyor.
--
-- Kapsam (serinin 5.'si, kullanıcının verdiği kesin sözdizimi listesi): throw
-- ifadesinin çalışma zamanı davranışı (bir Throwable nesnesini JVM'e teslim
-- etmek, throw'dan sonraki kodun erişilemez olması), fail-fast doğrulama
-- deseni, yakalanan bir exception'ı farklı, daha anlamlı bir türle yeniden
-- fırlatmak (cause parametresiyle), throws bildiriminin derleme-zamanı
-- doğası ve checked exception'ın yakalanmadan çağrı zinciri boyunca
-- yayılması, ve throw/throws arasındaki temel ayrım (ifade vs bildirim).
-- Checked/unchecked ayrımının KENDİSİ ve override kısıtı (serinin 4.'sünde
-- işlendi) burada TEKRARLANMADI, yalnızca referans verildi. Özel exception
-- sınıfları tasarlamak bilinçli olarak burada YOK, serinin 6.'sına
-- (Custom Exceptions) bırakıldı.
--
-- Format: serinin önceki dört topic'iyle (V318/V321/V325/V328) AYNI güncel
-- java-basics/exceptions konvansiyonu -- "## Ek: Mini Proje" YOK,
-- estimated_minutes doğrudan son değerine yazıldı, BEGINNER zorluk
-- (komşularıyla aynı).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'throw-and-throws', 'BEGINNER', 20, 5
FROM category
WHERE slug = 'exceptions';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Throw ve Throws',
       'throw ifadesinin çalışma zamanında bir Throwable nesnesini JVM''e teslim etmesi ile throws bildiriminin yalnızca derleme-zamanı bir sözleşme olması arasındaki fark -- fail-fast doğrulama, yakalanan bir exception''ı cause parametresiyle farklı bir türle yeniden fırlatmak, ve checked exception''ın çağrı zinciri boyunca yakalanmadan yayılması. Exception Handling serisinin 5.''si.',
       'Java''da throw ve throws Kullanımı',
       'Java''da throw ifadesi ile throws bildirimi arasındaki fark, fail-fast doğrulama ve exception''ı yeniden fırlatma gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'throw-and-throws';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Throw and Throws',
       'The difference between the throw statement handing a Throwable instance to the JVM at runtime and the throws declaration being a purely compile-time contract -- fail-fast validation, rethrowing a caught exception as a different type with the cause parameter, and a checked exception propagating unhandled through a call chain. The 5th lesson in the Exception Handling series.',
       'Using throw and throws in Java',
       'The difference between the throw statement and the throws declaration in Java, fail-fast validation, and rethrowing exceptions, explained with real examples.',
       false
FROM topic
WHERE slug = 'throw-and-throws';
