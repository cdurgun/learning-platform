-- Kategorinin dördüncü topic'i: `terminal-operations` (sort_order=4, stream-fundamentals'
-- tan sonra). Kullanıcı onayıyla ("sıradaki konuyu yapabilirsin") aynı fazda TR+EN
-- birlikte yazıldı.
--
-- Orijinal 7 topic'lik plandaki 7. madde ("Terminal Operations": collect(), toList(),
-- forEach(), reduce(), count(), min()/max(), findFirst()/findAny(), anyMatch()/
-- allMatch()/noneMatch()). `collect()`'in Collectors ile asıl gücü kasıtlı olarak bu
-- topic'e DAHIL EDİLMEDİ -- bir sonraki topic (`collectors`) için ayrıldı; burada yalnızca
-- `toList()`/`toArray()` (collect()'in basit, dolaylı kullanımı) var.
--
-- GERÇEK BİR KEŞİF (planı etkiledi): `count()` + `peek()` kombinasyonuyla yazılan
-- ShortCircuitExample.java ilk yazımda "count() kısa devre yapmaz, her elemanı işler"
-- varsayımıyla yazılmıştı. Sandbox'ta gerçekten çalıştırılınca bunun YANLIŞ olduğu
-- ortaya çıktı: `Stream.of(1,2,3).peek(...).count()` çalıştırıldığında peek()'in içindeki
-- yazdırma satırı HİÇ ÇALIŞMADI -- JDK, source'un boyutu bilindiğinde count()'u pipeline'ı
-- hiç çalıştırmadan doğrudan hesaplayabiliyor (Stream.count() javadoc'unda açıkça
-- belgelenen, kasıtlı bir optimizasyon). Örnek koddaki yorum ve derste ilgili bölüm
-- ("Kısa Devre ve count()'un Şaşırtıcı Davranışı") bu gerçek gözlemi yansıtacak şekilde
-- düzeltildi -- varsayımla değil, gerçek derleme+çalıştırma çıktısıyla yazıldı.
--
-- `stream-fundamentals`'daki "Stream Pipeline: Source, Intermediate, Terminal" bölümüne
-- ve `built-in-functional-interfaces`'teki Class::new (constructor reference) bölümüne
-- çapraz referans veriyor.
--
-- Kullanıcı isteğiyle (Faz 42) bu topic'in ders metninde "örnekler derlenip
-- doğrulandı" türü bir cümle YOK -- yalnızca bu migration yorumunda belgeleniyor.
--
-- Başlık: "Terminal Operations" -- kısa, kısaltmaya gerek yok (precedent: "Stream API
-- Temelleri" 21 karakter, bu da benzer uzunlukta).
--
-- INTERMEDIATE zorlukta -- kategorideki diğer topic'lerle aynı seviye.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'terminal-operations', 'INTERMEDIATE', 22, 4
FROM category
WHERE slug = 'functional-interfaces-streams';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Terminal Operations',
       'Stream pipeline''ını tetikleyip sonuç üreten terminal operation''lar: forEach(), reduce(), count(), min()/max(), findFirst()/findAny(), anyMatch()/allMatch()/noneMatch(), toList()/toArray(). Kısa devre (short-circuiting) davranışı ve count()''un source boyutundan doğrudan hesaplanabilme optimizasyonu.',
       'Java Stream Terminal Operations Nedir? reduce, count, findFirst Örnekleriyle',
       'Java Stream API''deki terminal operation''lar -- forEach() ile yan etki uygulamak, reduce() ile elemanları tek bir değere indirgemek, count() ile eleman sayısı, min()/max() ile Comparator''a göre uç değerler, findFirst()/findAny() ile Optional dönen eşleşmeler, anyMatch()/allMatch()/noneMatch() ile kısa devre yapan boolean kontroller, ve toList()/toArray() ile basit koleksiyona dönüştürme -- gerçek Java örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'terminal-operations';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Terminal Operations',
       'The terminal operations that trigger a stream pipeline and produce a result: forEach(), reduce(), count(), min()/max(), findFirst()/findAny(), anyMatch()/allMatch()/noneMatch(), toList()/toArray(). Short-circuiting behavior and count()''s source-size optimization.',
       'What Are Java Stream Terminal Operations? Explained with reduce, count, findFirst',
       'The terminal operations in the Java Stream API -- applying a side effect with forEach(), reducing elements to a single value with reduce(), the element count with count(), extremes via a Comparator with min()/max(), Optional-returning matches with findFirst()/findAny(), short-circuiting boolean checks with anyMatch()/allMatch()/noneMatch(), and converting to a simple collection with toList()/toArray() -- explained with real Java examples.',
       false
FROM topic
WHERE slug = 'terminal-operations';
