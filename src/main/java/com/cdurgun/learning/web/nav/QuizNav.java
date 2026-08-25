package com.cdurgun.learning.web.nav;

import java.util.List;

/**
 * Quiz Area sidebar/nav ağacı -- {@link com.cdurgun.learning.web.nav.CourseNav} ile AYNI
 * stil: template'e önceden çözülmüş (message key değil, gerçek) görüntü metinleri verilir,
 * ham slug'ları çevirme işi template'e bırakılmaz. {@code groupLabel} bir kursu temsil eder
 * (örn. "Java Quiz"), {@code definitions} o kurs altındaki {@link
 * com.cdurgun.learning.domain.QuizDefinition} kapsamlarıdır (örn. "Basic Java").
 */
public record QuizNav(String groupLabel, String groupSlug, List<QuizDefinitionNavItem> definitions) {

    public record QuizDefinitionNavItem(String slug, String title) {
    }
}
