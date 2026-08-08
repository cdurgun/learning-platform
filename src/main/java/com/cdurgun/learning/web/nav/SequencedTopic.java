package com.cdurgun.learning.web.nav;

/**
 * Bir kursun tek bir dilde yayınlanmış konularının, kategori + konu sort_order'ına göre
 * sıralanmış düz (flat) listesindeki bir öğe. Önceki/Sonraki konu navigasyonu için —
 * bkz. {@code NavigationService#buildCourseSequence}.
 */
public record SequencedTopic(String slug, String title) {
}
