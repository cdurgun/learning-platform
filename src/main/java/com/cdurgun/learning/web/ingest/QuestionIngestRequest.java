package com.cdurgun.learning.web.ingest;

import java.util.List;

/**
 * POST /api/internal/questions/ingest istek gövdesi. DİKKAT: burada BİLİNÇLİ
 * OLARAK bir {@code status} alanı YOK -- bu, "sunucu her zaman PENDING_REVIEW ile
 * ezer" kuralının çalışma zamanı bir if/override'a değil, DTO seviyesinde bir
 * imkansızlığa dayanmasını sağlar: client bu alanı JSON'a eklese bile (n8n
 * workflow'u yanlış yapılandırılsa dahi), bu record'da karşılık gelen bir bileşen
 * olmadığı için Jackson bunu sessizce YOK SAYAR, hiçbir zaman bind edilmez (bkz.
 * QuestionIngestService.ingest — status SUNUCU tarafında sabit atanır).
 *
 * <p>{@code source} ise BİLİNÇLİ OLARAK burada VAR -- {@code status}'un aksine bu
 * alan güvenlik açısından hassas değil (hiçbir sorgu/yetkilendirme kararını
 * etkilemez, yalnızca denetim amaçlı, bkz. {@link
 * com.cdurgun.learning.domain.QuestionSource}), bu yüzden çağıranın kendini
 * {@code MANUAL}/{@code CLAUDE}/{@code N8N} olarak AÇIKÇA beyan etmesine izin
 * verilir -- yine de sunucu tarafında sıkı bir izin listesine karşı doğrulanır
 * (bkz. {@code QuestionIngestService#parseSource}), asla serbest metin olarak
 * güvenilmez.</p>
 */
public record QuestionIngestRequest(String topicSlug,
                                     String language,
                                     String type,
                                     String difficulty,
                                     String source,
                                     String question,
                                     String codeSnippet,
                                     String codeLanguage,
                                     String explanation,
                                     List<QuestionIngestOption> options) {
}
