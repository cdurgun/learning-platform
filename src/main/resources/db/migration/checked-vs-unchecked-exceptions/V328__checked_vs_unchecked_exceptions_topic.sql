-- exceptions kategorisine, Exception Handling serisinin 4.'sü ekleniyor:
-- "checked-vs-unchecked-exceptions" -- exception-hierarchy'nin (sort_order=3)
-- hemen ardına, sort_order=4. Kategori şu an yalnızca üç topic içerdiği için
-- (bkz. V325) basit bir ekleme -- sort_order kaydırması gerekmiyor.
--
-- Kapsam (serinin 4.'sü, kullanıcının verdiği kesin sözdizimi listesi): checked
-- exception'ın derleyici tarafından zorlanan throws/catch sözleşmesi, unchecked
-- exception'ın (RuntimeException ailesi) bu zorunluluğu taşımaması, ikisi
-- arasında ne zaman hangisinin seçileceği, checked bir exception'ı unchecked'e
-- sarmalamak (wrapping, cause parametresiyle), ve override edilen bir metotta
-- throws bildirebileceği checked exception türlerinin yalnızca DARALTILABİLECEĞİ
-- kısıtı. "Exception Hierarchy" (serinin 3.'sü) konusunda hiyerarşideki yerine
-- yalnızca değinilen bu ayrım, burada TAM olarak işleniyor -- kavram tekrarı
-- yapılmaması talimatı gereği hiyerarşi anlatımı burada tekrarlanmadı, doğrudan
-- kullanıldı.
--
-- Format: serinin önceki üç topic'iyle (V318/V321/V325) AYNI güncel
-- java-basics/exceptions konvansiyonu -- "## Ek: Mini Proje" YOK,
-- estimated_minutes doğrudan son değerine yazıldı, BEGINNER zorluk
-- (komşularıyla aynı).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'checked-vs-unchecked-exceptions', 'BEGINNER', 20, 4
FROM category
WHERE slug = 'exceptions';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Checked ve Unchecked Exception''lar',
       'Checked exception''ın derleyici tarafından zorlanan throws/catch sözleşmesi ile unchecked exception''ın (RuntimeException ailesi) bu zorunluluğu hiç taşımaması arasındaki fark -- ikisi arasında ne zaman hangisinin seçileceği, checked bir exception''ı cause parametresiyle unchecked''e sarmalamak, ve override edilen bir metotta throws bildiriminin yalnızca DARALTILABİLECEĞİ kısıtı. Exception Handling serisinin 4.''sü.',
       'Java''da Checked ve Unchecked Exception Farkı',
       'Java''da checked ve unchecked exception arasındaki derleyici tarafından zorlanan fark, ne zaman hangisinin kullanılacağı, ve exception sarmalama (wrapping) gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'checked-vs-unchecked-exceptions';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Checked vs Unchecked Exceptions',
       'The difference between a checked exception''s compiler-enforced throws/catch contract and an unchecked exception''s (the RuntimeException family) complete lack of that requirement -- when to choose which, wrapping a checked exception as unchecked with the cause parameter, and the restriction that an overriding method''s throws declaration can only be NARROWED. The 4th lesson in the Exception Handling series.',
       'Checked vs Unchecked Exceptions in Java',
       'The compiler-enforced difference between checked and unchecked exceptions in Java, when to use which, and exception wrapping, explained with real examples.',
       false
FROM topic
WHERE slug = 'checked-vs-unchecked-exceptions';
