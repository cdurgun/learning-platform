-- `generics` kategorisine, serinin 3.'sü ekleniyor: "bounded-type-parameters"
-- -- generic-methods'ın (sort_order=2) hemen ardına, sort_order=3. Kategori
-- şu an iki topic içeriyor, sort_order kaydırması gerekmiyor.
--
-- Kapsam (kullanıcının verdiği kesin alt başlıklar): üst sınırlar
-- (`<T extends ...>`), birden fazla sınır (`&` ile birleştirme, sınıf varsa
-- ilk sırada), sınıflarla ve interface'lerle sınırlama, pratik örnekler.
-- "Introduction to Generics" ve "Generic Methods"te (Faz 105/106) işlenen
-- generic sınıf/metot mekaniği burada TEKRARLANMADI, yalnızca topic
-- başlıkları üzerinden referans verildi. Wildcard'lar (`<? extends T>`)
-- BİLİNÇLİ OLARAK burada ÖĞRETİLMEDİ -- serinin 4. topic'i "Wildcards"a
-- bırakıldı, yalnızca ileri bir referansla ("Wildcards" -- kesin başlık Faz
-- 97 desenindeki gibi şimdiden kararlaştırıldı, o topic yazıldığında gerçek
-- migration başlığıyla doğrulanacak) değinildi.
--
-- INTERMEDIATE zorlukta, serinin önceki iki topic'iyle aynı seviye. Format:
-- serinin önceki iki topic'iyle (V341/V344) AYNI konvansiyon -- "## Ek: Mini
-- Proje" YOK, estimated_minutes doğrudan son değerine yazıldı.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'bounded-type-parameters', 'INTERMEDIATE', 20, 3
FROM category
WHERE slug = 'generics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Sınırlı Tür Parametreleri',
       'Üst sınırlar (`<T extends ...>`), `&` ile birleştirilen birden fazla sınır, sınıflarla ve interface''lerle sınırlama, ve bir tür parametresini sınırlamanın tür parametresine hangi metotların çağrılabileceğini nasıl genişlettiği. Generics serisinin 3.''sü.',
       'Java''da Sınırlı (Bounded) Tür Parametreleri',
       'Java''da bounded type parameter''lar -- üst sınırlar, birden fazla sınır ve sınıf/interface ile sınırlama gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'bounded-type-parameters';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Bounded Type Parameters',
       'Upper bounds (`<T extends ...>`), multiple bounds joined with `&`, bounding with classes and with interfaces, and how bounding a type parameter expands which methods can be called on it. The 3rd lesson in the Generics series.',
       'Bounded Type Parameters in Java',
       'Bounded type parameters in Java -- upper bounds, multiple bounds, and bounding with classes and interfaces, explained with real examples.',
       false
FROM topic
WHERE slug = 'bounded-type-parameters';
