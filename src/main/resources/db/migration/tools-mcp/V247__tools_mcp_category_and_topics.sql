-- Faz 72, Wave 3: "ai" kursuna üçüncü kategori -- "Tools & MCP" (category.sort_order=3,
-- Large Language Models'tan sonra). Bu kategorinin var oluş nedeni önceki kategorinin
-- son topic'inde ("llm-capabilities-and-limitations") zaten açıkça kurulmuştu: bir LLM'in
-- dört temel sınırlaması (hallucination, knowledge cutoff, akıl yürütme garantisizliği,
-- bias) hepsi TEK bir köke bağlanıyordu -- yerleşik doğrulayıcısı olmadan makul metin
-- tahmini -- ve o dersin kapanışı bunun NEDEN "Tools & MCP" ve "AI Agents" kategorilerini
-- gerekli kıldığını söylüyordu: modeli "düzeltmeye" çalışmak yerine, etrafına güncel bilgi
-- sağlayan, çıktıyı doğrulayan ve modelin ne yapabileceğini kısıtlayan sistemler kurmak.
-- Bu kategori tam olarak bunu -- ve kullanıcının özellikle açıklanmasını istediği MCP
-- (Model Context Protocol) kavramını -- ele alıyor. Kullanıcı onayladığı Node/TypeScript
-- stack kararı BURADA ilk kez devreye giriyor: dördüncü ve son topic, gerçek npm install +
-- tsc + node ile bu sandbox'ta uçtan uca doğrulanmış, @modelcontextprotocol/sdk kullanan
-- çalıştırılabilir bir MCP server/client örneği içeriyor (bkz. V250 ve examples/
-- build-an-mcp-server/ altındaki dosyalar). İlk üç topic bilinçli olarak kod İÇERMİYOR --
-- tool use/function calling kavramını, MCP'nin çözdüğü N×M entegrasyon problemini, ve
-- protokolün mimarisini (host/client/server rolleri, primitives, transport, yaşam
-- döngüsü) kavramsal olarak kurup, dördüncü topic'te bunları gerçek koda bağlıyor.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Tools & MCP', 'tools-mcp', 3
FROM course
WHERE slug = 'ai';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'tools-and-function-calling', 'INTERMEDIATE', 18, 1
FROM category
WHERE slug = 'tools-mcp';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'introduction-to-mcp', 'INTERMEDIATE', 18, 2
FROM category
WHERE slug = 'tools-mcp';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'mcp-architecture', 'INTERMEDIATE', 20, 3
FROM category
WHERE slug = 'tools-mcp';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'building-an-mcp-server', 'INTERMEDIATE', 28, 4
FROM category
WHERE slug = 'tools-mcp';
