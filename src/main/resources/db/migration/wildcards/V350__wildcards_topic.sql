-- `generics` kategorisine, serinin 4.'sü ekleniyor: "wildcards" --
-- bounded-type-parameters'ın (sort_order=3) hemen ardına, sort_order=4.
-- Kategori şu an üç topic içeriyor, sort_order kaydırması gerekmiyor.
--
-- Kullanıcının özellikle vurguladığı, "önemli ve yaygın yanlış anlaşılan"
-- topic. Kapsam (kullanıcının verdiği kesin alt başlıklar): sınırsız
-- wildcard (`<?>`), üst sınırlı wildcard (`<? extends T>`), alt sınırlı
-- wildcard (`<? super T>`), üçü arasındaki farklar, PECS (Producer Extends,
-- Consumer Super), pratik örnekler. Bu vurgu nedeniyle diğer topic'lerin
-- 4-5 örneğinden farklı olarak 6 örnek yazıldı. "Bounded Type
-- Parameters"taki (Faz 107) `<T extends ...>` mekaniği burada
-- TEKRARLANMADI, yalnızca topic başlığı üzerinden referans verildi --
-- wildcard'ların bir tür parametresini DEĞİL, generic bir türün bir
-- KULLANIMINI sınırladığı ayrımı net biçimde vurgulandı. Generics
-- değişmezliği (invariance) BURADA motivasyon olarak kısaca tanıtıldı, ama
-- tam derinlikte "List<Object> neden List<String> değildir" işlenmesi
-- BİLİNÇLİ OLARAK serinin 5. topic'i "Generics with Collections"a
-- bırakıldı (kullanıcının o topic için verdiği kesin alt başlık) -- ileri
-- referansla değinildi, o topic yazıldığında gerçek migration başlığıyla
-- doğrulanacak.
--
-- INTERMEDIATE zorlukta, serinin önceki topic'leriyle aynı seviye (ADVANCED
-- değil -- kullanıcının vurgusu içeriğin derinliğine yansıdı, zorluk
-- etiketine değil). Format: serinin önceki topic'leriyle AYNI konvansiyon --
-- "## Ek: Mini Proje" YOK, estimated_minutes 6 örnek nedeniyle biraz daha
-- yüksek tutuldu.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'wildcards', 'INTERMEDIATE', 30, 4
FROM category
WHERE slug = 'generics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Wildcard''lar',
       'Sınırsız wildcard (`<?>`), üst sınırlı wildcard (`<? extends T>`), alt sınırlı wildcard (`<? super T>`), üçü arasındaki fark, ve PECS (Producer Extends, Consumer Super) kuralı -- Java generics''in en yaygın yanlış anlaşılan bölümü, gerçek örneklerle adım adım. Generics serisinin 4.''sü.',
       'Java''da Wildcard''lar ve PECS Kuralı',
       'Java generics wildcard''ları -- sınırsız, üst sınırlı ve alt sınırlı wildcard''lar, ve PECS (Producer Extends, Consumer Super) kuralı gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'wildcards';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Wildcards',
       'The unbounded wildcard (`<?>`), the upper bounded wildcard (`<? extends T>`), the lower bounded wildcard (`<? super T>`), the difference between the three, and the PECS (Producer Extends, Consumer Super) rule -- the most commonly misunderstood part of Java generics, walked through step by step with real examples. The 4th lesson in the Generics series.',
       'Wildcards and the PECS Rule in Java',
       'Java generics wildcards -- unbounded, upper bounded, and lower bounded wildcards, and the PECS (Producer Extends, Consumer Super) rule, explained with real examples.',
       false
FROM topic
WHERE slug = 'wildcards';
