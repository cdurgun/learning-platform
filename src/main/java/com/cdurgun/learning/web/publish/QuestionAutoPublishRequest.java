package com.cdurgun.learning.web.publish;

/**
 * {@code POST /api/internal/questions/{id}/auto-publish} istek gövdesi. Tüm alanlar
 * OPSİYONEL ve yalnızca {@link com.cdurgun.learning.domain.QuestionPublishLog}'a
 * denetim amaçlı yazılır -- hiçbiri yayınlama KARARINI etkilemez (o karar zaten n8n'in
 * AI Judge aşamasında verilmiş olmalı, bu endpoint yalnızca o kararı UYGULAR). {@code
 * status} burada da (ingestion'daki gibi) BİLİNÇLİ OLARAK YOK -- bu endpoint çağrıldığı
 * an zaten "yayınla" komutu anlamına gelir, ayrı bir alan gerekmez.
 */
public record QuestionAutoPublishRequest(String runId, String modelName, String reason) {
}
