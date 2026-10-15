package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.repository.NavigationRow;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import com.cdurgun.learning.web.nav.CourseNav;
import com.cdurgun.learning.web.nav.CourseNav.CategoryNav;
import com.cdurgun.learning.web.nav.CourseNav.TopicNavItem;
import com.cdurgun.learning.web.nav.SequencedTopic;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Sidebar, anasayfa ve Prev/Next navigasyonu için, seçilen dilde YALNIZCA yayınlanmış
 * konuları içeren görünümler üretir. Boş kalan kategori/kurslar ağaçta hiç yer almaz.
 *
 * <p>Her görünüm tek bir projection sorgusuyla kurulur ({@link NavigationRow}): sorgu
 * yalnızca bu dilde yayında olan çevirileri, kurs + kategori + konu sırasında döner;
 * gruplama bellekte yapılır. Bu yüzden yayında konusu olmayan bir kategori ya da kurs
 * sonuca hiç girmez. (Eskiden kurs/kategori/konu/çeviri başına ayrı sorgu atılıyordu --
 * menü başına ~210 sorgu.)</p>
 */
@Service
public class NavigationService {

    private final TopicTranslationRepository topicTranslationRepository;
    private final CatalogNames catalogNames;

    public NavigationService(TopicTranslationRepository topicTranslationRepository, CatalogNames catalogNames) {
        this.topicTranslationRepository = topicTranslationRepository;
        this.catalogNames = catalogNames;
    }

    public List<CourseNav> buildNavigation(Language language) {
        Map<String, CourseGroup> courses = new LinkedHashMap<>();

        for (NavigationRow row : topicTranslationRepository.findPublishedNavigationRows(language)) {
            CourseGroup course = courses.computeIfAbsent(row.courseSlug(),
                    slug -> new CourseGroup(catalogNames.course(slug, row.courseName(), language)));
            List<TopicNavItem> topics = course.categories.computeIfAbsent(row.categorySlug(),
                    slug -> new CategoryGroup(catalogNames.category(slug, row.categoryName(), language))).topics;
            topics.add(new TopicNavItem(
                    row.topicSlug(),
                    row.title(),
                    row.summary(),
                    row.difficulty().name(),
                    row.estimatedMinutes()));
        }

        List<CourseNav> nav = new ArrayList<>();
        courses.forEach((courseSlug, course) -> {
            List<CategoryNav> categoryNavs = new ArrayList<>();
            course.categories.forEach((categorySlug, category) ->
                    categoryNavs.add(new CategoryNav(category.name, categorySlug, category.topics)));
            nav.add(new CourseNav(course.name, courseSlug, categoryNavs));
        });
        return nav;
    }

    /**
     * Bir kursun, verilen dilde yayınlanmış tüm konularını kategori sort_order + konu
     * sort_order sırasına göre TEK bir düz listede döner. Prev/Next navigasyonu, bu
     * listede konumu bulup bir öncekini/sonrakini almakla çalışır — bu sayede kategori
     * sınırını geçmek (bir kategorinin son konusundan diğerinin ilk konusuna) otomatik
     * olur, ekstra bir özel durum kodu gerekmez.
     */
    public List<SequencedTopic> buildCourseSequence(Long courseId, Language language) {
        return topicTranslationRepository.findPublishedNavigationRowsByCourse(courseId, language).stream()
                .map(row -> new SequencedTopic(row.topicSlug(), row.title()))
                .toList();
    }

    private static final class CourseGroup {
        private final String name;
        private final Map<String, CategoryGroup> categories = new LinkedHashMap<>();

        private CourseGroup(String name) {
            this.name = name;
        }
    }

    private static final class CategoryGroup {
        private final String name;
        private final List<TopicNavItem> topics = new ArrayList<>();

        private CategoryGroup(String name) {
            this.name = name;
        }
    }
}
