package com.cdurgun.learning.web.nav;

import java.util.List;

/**
 * Sidebar/anasayfa için salt-okunur navigasyon ağacı. Entity'lerin doğrudan template'e
 * sızmasını önler ve yalnızca yayınlanmış (published) çevirileri içerir.
 *
 * <p>{@code accessible}: mevcut kullanıcı bu kursa erişebiliyor mu ({@link
 * com.cdurgun.learning.config.CourseAccessPolicy}) -- false ise template kursu görünür
 * ama devre dışı (link'siz) çizer.</p>
 */
public record CourseNav(String name, String slug, boolean accessible, List<CategoryNav> categories) {

    public record CategoryNav(String name, String slug, List<TopicNavItem> topics) {
    }

    public record TopicNavItem(String slug, String title, String summary, String difficulty, Integer estimatedMinutes) {
    }
}
