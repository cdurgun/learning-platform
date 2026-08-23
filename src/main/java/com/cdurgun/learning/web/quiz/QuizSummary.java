package com.cdurgun.learning.web.quiz;

/**
 * Bir topic sayfasında render edilecek, o topic+dilde bulunan (varsa) aktif sabit
 * quiz'in özeti — {@code slug}, generalize edilmiş submit URL'ini kurmak için gerekir.
 */
public record QuizSummary(Long id, String slug, String title) {
}
