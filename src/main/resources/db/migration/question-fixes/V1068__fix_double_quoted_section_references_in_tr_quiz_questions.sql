-- content-check'in bulduğu 26 Türkçe quiz sorusu, çift tırnak içinde, dersin Türkçe sürümünde
-- var olmayan bir bölüm adına atıf yapıyordu (25'i İngilizce başlık, 1'i büyük/küçük harf
-- farkı). Yalnızca soru metnindeki tırnaklı bölüm adını, content/tr/{slug}.md'deki gerçek
-- H2 başlığıyla eşitler; şıklara, açıklamalara ve başka hiçbir soruya dokunmaz. Konu slug'ı +
-- dil + metinle eşleştiği için ortamdan bağımsızdır; tekrar çalıştırılması hiçbir şeyi
-- değiştirmez.
UPDATE question q
SET question = replace(q.question, v.old_ref, v.new_ref)
FROM (VALUES
    ('spring-batch', '"Spring Batch NE DEĞİLDİR"', '"Spring Batch Ne DEĞİLDİR"'),
    ('microservices-fundamentals', '"A Quick Look at the CAP Theorem"', '"CAP Teoremine Kısa Bir Bakış"'),
    ('inter-service-communication', '"Synchronous vs. Asynchronous: What Does This Lesson Cover?"', '"Senkron vs Asenkron: Bu Derste Neyi Kapsıyoruz?"'),
    ('service-discovery-eureka', '"Discovering Services with DiscoveryClient"', '"Servisleri Dinamik Olarak Keşfetmek: DiscoveryClient"'),
    ('service-discovery-eureka', '"Heartbeats, Eviction, and Self-Preservation Mode"', '"Heartbeat, Eviction ve Self-Preservation Modu"'),
    ('api-gateway', '"Writing a Custom Filter"', '"Özel Bir Filtre Yazmak"'),
    ('resilience4j', '"Circuit Breaker: States and Configuration"', '"Circuit Breaker: Durumlar ve Yapılandırma"'),
    ('resilience4j', '"Wrapping StockClient with a Circuit Breaker"', '"StockClient''ı Bir Circuit Breaker ile Sarmak"'),
    ('resilience4j', '"Retry: Trying Again Before Giving Up"', '"Retry: Vazgeçmeden Önce Tekrar Denemek"'),
    ('configuration-management', '"The Config Repository: Where Configuration Actually Lives"', '"Config Repository: Yapılandırma Aslında Nerede Yaşıyor?"'),
    ('configuration-management', '"Secrets: What Config Server Should NOT Store in Plain Text"', '"Sırlar (Secrets): Config Server''ın Düz Metin Olarak SAKLAMAMASI Gerekenler"'),
    ('event-driven-kafka', '"Setting Up Kafka (Broker) and Topics"', '"Kafka''yı (Broker) ve Topic''leri Kurmak"'),
    ('event-driven-kafka', '"Synchronous vs. Asynchronous: When to Use Which"', '"Senkron vs Asenkron: Hangisi Ne Zaman Kullanılır?"'),
    ('event-driven-kafka', '"Serialization: Why JSON Over the Wire"', '"Serialization: Neden Tel Üzerinde JSON"'),
    ('distributed-transactions', '"Two-Phase Commit: Why Microservices Usually Avoid It"', '"Two-Phase Commit: Mikroservisler Bunu Neden Genellikle Kaçınıyor"'),
    ('distributed-transactions', '"Compensating Actions: Undoing What Already Happened"', '"Kompansasyon Eylemleri: Zaten Olmuş Bir Şeyi Geri Almak"'),
    ('distributed-transactions', '"The Outbox Pattern: Not Losing an Event to a Crash"', '"Outbox Deseni: Bir Olayı Çökmeye Kaybetmemek"'),
    ('observability', '"The Three Pillars: Logs, Metrics, and Traces"', '"Üç Sütun: Log''lar, Metrikler ve Trace''ler"'),
    ('observability', '"Common Mistakes"', '"Yaygın Hatalar"'),
    ('observability', '"Exposing What Resilience4j Was Already Tracking"', '"Resilience4j''nin Zaten İzlediğini Ortaya Çıkarmak"'),
    ('security', '"Authentication vs. Authorization: Two Different Questions"', '"Authentication vs Authorization: İki Farklı Soru"'),
    ('security', '"JWT: A Self-Contained, Verifiable Identity"', '"JWT: Kendi Kendine Yeterli, Doğrulanabilir Bir Kimlik"'),
    ('security', '"Why the Gateway Alone Isn''t Enough: Zero Trust Between Services"', '"Gateway Tek Başına Neden Yetmiyor: Servisler Arasında Zero Trust"'),
    ('security', '"Propagating Identity: The Correlation Id''s Security Counterpart"', '"Kimliği Yaymak: Correlation Id''nin Security Karşılığı"'),
    ('deployment', '"A Multi-Stage Build: Keeping the Image Small"', '"Multi-Stage Bir Build: Image''ı Küçük Tutmak"'),
    ('deployment', '"Beyond Local: A Brief, Honest Look at Kubernetes"', '"Yerelin Ötesi: Kubernetes''e Kısa, Dürüst Bir Bakış"')
) AS v(slug, old_ref, new_ref)
JOIN topic t ON t.slug = v.slug
WHERE q.topic_id = t.id
  AND q.language = 'tr'
  AND position(v.old_ref in q.question) > 0;
