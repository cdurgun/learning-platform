package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.repository.CourseRepository;
import jakarta.persistence.EntityManagerFactory;
import org.hibernate.SessionFactory;
import org.hibernate.stat.Statistics;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Menü ve önceki/sonraki sırasının, ders sayısından bağımsız olarak tek SQL sorgusuyla
 * kurulduğunu sabitler -- konu/çeviri başına sorgu atan eski N+1 yapısına geri dönülürse
 * bu test kırılır. Davranışın kendisi {@link NavigationServiceTest}'te.
 */
@SpringBootTest(properties = "spring.jpa.properties.hibernate.generate_statistics=true")
@ActiveProfiles("test")
class NavigationQueryCountTest {

    @Autowired
    private NavigationService navigationService;
    @Autowired
    private CourseRepository courseRepository;
    @Autowired
    private EntityManagerFactory entityManagerFactory;

    private Statistics statistics;

    @BeforeEach
    void resetStatistics() {
        statistics = entityManagerFactory.unwrap(SessionFactory.class).getStatistics();
        statistics.clear();
    }

    @Test
    void navigationIsBuiltWithASingleQueryPerLanguage() {
        for (Language language : Language.values()) {
            statistics.clear();

            assertThat(navigationService.buildNavigation(language)).isNotEmpty();

            assertThat(statistics.getPrepareStatementCount()).as(language.getCode()).isEqualTo(1);
            assertThat(statistics.getEntityLoadCount()).as(language.getCode()).isZero();
        }
    }

    @Test
    void courseSequenceIsBuiltWithASingleQuery() {
        Long javaId = courseRepository.findBySlug("java").orElseThrow().getId();
        statistics.clear();

        assertThat(navigationService.buildCourseSequence(javaId, Language.EN)).isNotEmpty();

        assertThat(statistics.getPrepareStatementCount()).isEqualTo(1);
        assertThat(statistics.getEntityLoadCount()).isZero();
    }
}
