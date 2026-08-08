package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Category;
import com.cdurgun.learning.domain.Course;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.domain.TopicTranslation;
import com.cdurgun.learning.repository.CategoryRepository;
import com.cdurgun.learning.repository.CourseRepository;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import com.cdurgun.learning.web.nav.CourseNav;
import com.cdurgun.learning.web.nav.CourseNav.CategoryNav;
import com.cdurgun.learning.web.nav.CourseNav.TopicNavItem;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * Sidebar ve anasayfa için, seçilen dilde YALNIZCA yayınlanmış konuları içeren bir
 * kurs/kategori/konu ağacı üretir. Boş kalan kategori/kurslar ağaçtan elenir.
 *
 * <p><b>Not (ölçeklenme):</b> Bu implementasyon, her kategori/konu için ayrı sorgu
 * çalıştırır (N+1). İçerik onlarca/yüzlerce konuya çıktığında, tek bir fetch-join
 * sorgusu ya da projection ile optimize edilmesi gerekir — Faz 1/2 hacminde
 * (tek kurs, tek kategori, tek konu) bir sorun teşkil etmez.</p>
 */
@Service
public class NavigationService {

    private final CourseRepository courseRepository;
    private final CategoryRepository categoryRepository;
    private final TopicRepository topicRepository;
    private final TopicTranslationRepository topicTranslationRepository;

    public NavigationService(CourseRepository courseRepository,
                              CategoryRepository categoryRepository,
                              TopicRepository topicRepository,
                              TopicTranslationRepository topicTranslationRepository) {
        this.courseRepository = courseRepository;
        this.categoryRepository = categoryRepository;
        this.topicRepository = topicRepository;
        this.topicTranslationRepository = topicTranslationRepository;
    }

    public List<CourseNav> buildNavigation(Language language) {
        List<CourseNav> nav = new ArrayList<>();

        for (Course course : courseRepository.findAll()) {
            List<CategoryNav> categoryNavs = new ArrayList<>();

            for (Category category : categoryRepository.findByCourseIdOrderById(course.getId())) {
                List<TopicNavItem> topicItems = new ArrayList<>();

                for (Topic topic : topicRepository.findByCategoryIdOrderBySortOrderAsc(category.getId())) {
                    topicTranslationRepository.findByTopicIdAndLanguage(topic.getId(), language)
                            .filter(TopicTranslation::isPublished)
                            .ifPresent(translation ->
                                    topicItems.add(new TopicNavItem(
                                            topic.getSlug(), translation.getTitle(), translation.getSummary())));
                }

                if (!topicItems.isEmpty()) {
                    categoryNavs.add(new CategoryNav(category.getName(), category.getSlug(), topicItems));
                }
            }

            if (!categoryNavs.isEmpty()) {
                nav.add(new CourseNav(course.getName(), course.getSlug(), categoryNavs));
            }
        }

        return nav;
    }
}
