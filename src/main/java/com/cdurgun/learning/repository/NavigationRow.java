package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.Difficulty;

/**
 * Menü ve önceki/sonraki navigasyonu için tek satırlık projection: yayında olan bir ders
 * çevirisi, kendi kurs ve kategori bilgisiyle birlikte. Entity yüklemeden, tek sorguda
 * gelir -- bkz. {@link TopicTranslationRepository#findPublishedNavigationRows}.
 */
public record NavigationRow(String courseSlug, String courseName,
                            String categorySlug, String categoryName,
                            String topicSlug, String title, String summary,
                            Difficulty difficulty, Integer estimatedMinutes) {
}
