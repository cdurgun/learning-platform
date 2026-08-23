-- `generics` kategorisine, serinin 2.'si ekleniyor: "generic-methods" --
-- introduction-to-generics'in (sort_order=1) hemen ardına, sort_order=2.
-- Kategori şu an tek topic içeriyor, sort_order kaydırması gerekmiyor.
--
-- Kapsam (kullanıcının verdiği kesin alt başlıklar): generic metotlar (bir
-- sınıfın generic olup olmamasından bağımsız, metodun kendi tür
-- parametresi), metot tür parametreleri, birden fazla tür parametresi, tür
-- çıkarımı (type inference, açık tür tanığıyla karşılaştırmalı), pratik
-- örnekler. "Introduction to Generics"te (Faz 105) işlenen generic
-- sınıflar/interface'ler burada TEKRARLANMADI, yalnızca topic başlığı
-- üzerinden referans verildi. Bounded type parameter'lar (`<T extends ...>`)
-- ve wildcard'lar BİLİNÇLİ OLARAK burada ÖĞRETİLMEDİ -- serinin 3. ve
-- 4. topic'lerine bırakıldı.
--
-- INTERMEDIATE zorlukta, introduction-to-generics ile aynı seviye. Format:
-- serinin 1. topic'iyle (V341) AYNI konvansiyon -- "## Ek: Mini Proje" YOK,
-- estimated_minutes doğrudan son değerine yazıldı.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'generic-methods', 'INTERMEDIATE', 20, 2
FROM category
WHERE slug = 'generics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Generic Metotlar',
       'Sınıfının generic olup olmamasından bağımsız olarak kendi tür parametresini bildiren generic metotlar -- metot tür parametreleri, birden fazla tür parametresi, tür çıkarımı (type inference) ve açık tür tanığı (type witness). Generics serisinin 2.''si.',
       'Java''da Generic Metotlar',
       'Java''da generic metotların nasıl tanımlanacağı -- metot tür parametreleri, çoklu tür parametreleri ve tür çıkarımı gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'generic-methods';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Generic Methods',
       'Generic methods that declare their own type parameter independent of whether their class is generic -- method type parameters, multiple type parameters, type inference, and explicit type witnesses. The 2nd lesson in the Generics series.',
       'Generic Methods in Java',
       'How to define generic methods in Java -- method type parameters, multiple type parameters, and type inference, explained with real examples.',
       false
FROM topic
WHERE slug = 'generic-methods';
