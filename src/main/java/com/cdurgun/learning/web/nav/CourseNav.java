package com.cdurgun.learning.web.nav;

import com.cdurgun.learning.web.SummaryFormatter;

import java.util.List;

/**
 * Sidebar/anasayfa için salt-okunur navigasyon ağacı. Entity'lerin doğrudan template'e
 * sızmasını önler ve yalnızca yayınlanmış (published) çevirileri içerir.
 */
public record CourseNav(String name, String slug, List<CategoryNav> categories) {

    /** Bu dilde yayında olan toplam ders sayısı (anasayfanın mobil kurs kartı için). */
    public int topicCount() {
        return categories.stream().mapToInt(category -> category.topics().size()).sum();
    }

    public record CategoryNav(String name, String slug, List<TopicNavItem> topics) {
    }

    public record TopicNavItem(String slug, String title, String summary, String difficulty, Integer estimatedMinutes) {

        /** Kart özetinin {@code th:utext} ile basılacak güvenli HTML'i -- bkz. {@link SummaryFormatter}. */
        public String summaryHtml() {
            return SummaryFormatter.toHtml(summary);
        }
    }
}
