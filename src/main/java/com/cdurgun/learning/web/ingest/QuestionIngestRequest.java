package com.cdurgun.learning.web.ingest;

import java.util.List;

/**
 * POST /api/internal/questions/ingest istek gövdesi. DİKKAT: burada BİLİNÇLİ
 * OLARAK bir {@code status}/{@code source} alanı YOK -- bu, "sunucu her zaman
 * PENDING_REVIEW/AI ile ezer" kuralının çalışma zamanı bir if/override'a değil,
 * DTO seviyesinde bir imkansızlığa dayanmasını sağlar: client bu alanları JSON'a
 * eklese bile (n8n workflow'u yanlış yapılandırılsa dahi), bu record'da karşılık
 * gelen bir bileşen olmadığı için Jackson bunları sessizce YOK SAYAR, hiçbir
 * zaman bind edilmezler (bkz. QuestionIngestService.ingest — status/source
 * SUNUCU tarafında sabit atanır, bkz. plan bölüm 6).
 */
public record QuestionIngestRequest(String topicSlug,
                                     String language,
                                     String type,
                                     String difficulty,
                                     String question,
                                     String codeSnippet,
                                     String codeLanguage,
                                     String explanation,
                                     List<QuestionIngestOption> options) {
}
