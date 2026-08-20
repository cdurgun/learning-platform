-- Faz 70: java/spring-boot/react'ten sonra DÖRDÜNCÜ Course -- "Artificial Intelligence"
-- (course.slug = 'ai'). Kullanıcı, ChatGPT ile birlikte hazırladığı ~7 kategori/~30
-- topic'lik bir planı paylaşıp değerlendirme istedi; plan onaylandı (bkz. CLAUDE.md'ye
-- eklenecek Faz 70 notu) -- küçük dalgalar (wave) halinde, her dalgadan sonra kullanıcı
-- onayıyla ilerlenecek (Microservices kategorisindeki aynı model). Course tablosuna artık
-- gerçek bir sort_order var (bkz. V234) -- 'ai' sort_order=4 ile ekleniyor, insert sırasına
-- güvenmeye gerek yok.
--
-- Wave 1: "AI Fundamentals" (category.sort_order=1) -- hiçbir AI bilgisi olmayan biri için
-- temel kavramlar: What Is Artificial Intelligence?, Machine Learning, Deep Learning,
-- Generative AI. React Fundamentals/Microservices Fundamentals'taki aynı desenle
-- BİLİNÇLİ OLARAK kod YOK -- bu dört konu, alanın haritasını çıkarıyor, henüz teknik bir
-- mekanizma göstermiyor; kod (LLM API çağrıları, tool calling, MCP server, agent loop)
-- ilerleyen dalgalarda (Tools & MCP, AI Agents, AI Application Development) gelecek.
-- Kullanıcı onayıyla içerik ilkesi: matematiksel derinlikten kaçın, kavramsal ve
-- pratik netliği önceliklendir (bkz. Faz 70 notu, "Claude Code için içerik prensibi").
-- Dördü de BEGINNER -- react-fundamentals'taki "kursun hiç bilgi gerektirmeyen ilk
-- kategorisi" gerekçesiyle aynı, microservices-fundamentals'ın (yazılım geçmişi
-- varsayan) INTERMEDIATE'inden bilinçli olarak farklı.

INSERT INTO course (name, slug, sort_order)
VALUES ('Artificial Intelligence', 'ai', 4);

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'AI Fundamentals', 'ai-fundamentals', 1
FROM course
WHERE slug = 'ai';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'what-is-ai', 'BEGINNER', 15, 1
FROM category
WHERE slug = 'ai-fundamentals';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'machine-learning', 'BEGINNER', 18, 2
FROM category
WHERE slug = 'ai-fundamentals';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'deep-learning', 'BEGINNER', 18, 3
FROM category
WHERE slug = 'ai-fundamentals';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'generative-ai', 'BEGINNER', 15, 4
FROM category
WHERE slug = 'ai-fundamentals';
