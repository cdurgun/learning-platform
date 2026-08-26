package com.cdurgun.learning.web.internal;

/**
 * Question generation tooling (n8n) için salt-okunur topic metadata görünümü --
 * {@code GET /api/internal/topics/{slug}}. Path/dosya konumu hiç YOK (proje
 * konvansiyonu: DB path saklamaz), yalnızca içerik dosyasını convention'la
 * bulmak için gereken {@code slug} + zorluk/kategori/kurs bağlamı.
 */
public record TopicMetadataResponse(String slug,
                                     String difficulty,
                                     String categorySlug,
                                     String courseSlug,
                                     Integer estimatedMinutes) {
}
