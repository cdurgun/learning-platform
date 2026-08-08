package com.cdurgun.learning.web.nav;

import java.util.List;

/**
 * Sidebar/anasayfa için salt-okunur navigasyon ağacı. Entity'lerin doğrudan template'e
 * sızmasını önler ve yalnızca yayınlanmış (published) çevirileri içerir.
 */
public record CourseNav(String name, String slug, List<CategoryNav> categories) {

    public record CategoryNav(String name, String slug, List<TopicNavItem> topics) {
    }

    public record TopicNavItem(String slug, String title, String summary) {
    }
}
