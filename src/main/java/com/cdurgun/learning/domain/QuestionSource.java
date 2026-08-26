package com.cdurgun.learning.domain;

/**
 * Bir {@link Question}'ın kökeni -- yalnızca denetim/filtreleme amaçlı, davranışı
 * değiştirmez (davranışı belirleyen {@link QuestionStatus}'tur). {@link
 * com.cdurgun.learning.service.QuestionReviewService}/public havuz sorguları
 * {@code source}'a HİÇ bakmaz -- {@code MANUAL}/{@code CLAUDE}/{@code N8N}/
 * {@code OPENAI} gözden geçirme akışında TAMAMEN aynı şekilde ele alınır.
 *
 * <p>Faz (Question Ingestion / Authoring API) itibarıyla eskiden var olan tek
 * genel {@code AI} değeri, ingestion çağıranının kendisini AÇIKÇA belirtebilmesi
 * için {@code CLAUDE} ve {@code N8N}'e ayrıldı (bkz. {@code
 * QuestionIngestService#parseSource}) -- hiçbir gerçek satır hiçbir zaman
 * {@code AI} değerini taşımadı (yalnızca 2 kod referansı vardı, ikisi de bu
 * Faz'da güncellendi), bu yüzden kaldırılması güvenliydi.</p>
 *
 * <p>{@code OPENAI} (büyük ölçekli soru üretim workflow'unun ilk gerçek uçtan
 * uca OpenAI testi, bkz. Faz 146) -- `n8n`'in `Generate Batch` düğümü Anthropic
 * yerine OpenAI Chat Completions API'sini (n8n'in kendi credential deposu
 * üzerinden, `{@code openAiApi}` tipi) kullanacak şekilde yapılandırıldığında
 * eklendi. {@code CLAUDE}/{@code N8N} deseninin AYNI mantığıyla -- her yeni LLM
 * sağlayıcısı kendi ayrı değerini alır, tek bir genel {@code AI} değerine geri
 * dönülmez.</p>
 */
public enum QuestionSource {
    MANUAL,
    CLAUDE,
    N8N,
    OPENAI
}
