package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Course;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.QuizDefinition;
import com.cdurgun.learning.repository.QuizDefinitionRepository;
import com.cdurgun.learning.web.nav.QuizNav;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.MessageSource;

import java.util.List;
import java.util.Locale;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.when;

/**
 * {@link QuizNavigationService#buildQuizNav}'ın grup-etiketi çözümlemesini test eder --
 * özellikle bu sınıfa Spring Quiz için eklenen {@code quiz.courseGroup.{course.slug}}
 * override mekanizmasını: (1) bir override anahtarı tanımlıysa doğrudan kullanılmalı,
 * course.name'i hiç formatlamadan; (2) tanımlı değilse (Java'nın durumu gibi), var olan
 * genel {@code quiz.courseGroup} şablonuna course.name ile DEĞİŞMEDEN düşülmeli.
 */
@ExtendWith(MockitoExtension.class)
class QuizNavigationServiceTest {

    @Mock
    private QuizDefinitionRepository quizDefinitionRepository;
    @Mock
    private MessageSource messageSource;

    private QuizNavigationService service() {
        return new QuizNavigationService(quizDefinitionRepository, messageSource);
    }

    @Test
    void buildQuizNavUsesCourseSlugOverrideWhenDefined() {
        Course springBoot = Course.builder().id(2L).name("Spring Boot").slug("spring-boot").sortOrder(2).build();
        QuizDefinition definition = definitionOf(springBoot, "spring-core", 1);
        when(quizDefinitionRepository.findAllActiveOrderByCourseAndSortOrder()).thenReturn(List.of(definition));
        when(messageSource.getMessage(eq("quiz.courseGroup.spring-boot"), isNull(), isNull(), any(Locale.class)))
                .thenReturn("Spring Sınavı");
        when(messageSource.getMessage(eq("quiz.def.spring-core.title"), isNull(), eq("spring-core"), any(Locale.class)))
                .thenReturn("Spring Core");

        List<QuizNav> nav = service().buildQuizNav(Language.TR);

        // Override mevcutken genel "{0} Sınavı" şablonu HİÇ ÇAĞRILMAMALI -- "Spring Boot
        // Sınavı" değil, tam olarak istenen "Spring Sınavı" üretilmeli.
        assertThat(nav).hasSize(1);
        assertThat(nav.get(0).groupLabel()).isEqualTo("Spring Sınavı");
    }

    @Test
    void buildQuizNavFallsBackToGenericTemplateWhenNoOverrideExists() {
        Course java = Course.builder().id(1L).name("Java").slug("java").sortOrder(1).build();
        QuizDefinition definition = definitionOf(java, "basic-java", 1);
        when(quizDefinitionRepository.findAllActiveOrderByCourseAndSortOrder()).thenReturn(List.of(definition));
        when(messageSource.getMessage(eq("quiz.courseGroup.java"), isNull(), isNull(), any(Locale.class)))
                .thenReturn(null);
        when(messageSource.getMessage(eq("quiz.courseGroup"), eq(new Object[]{"Java"}), any(Locale.class)))
                .thenReturn("Java Sınavı");
        when(messageSource.getMessage(eq("quiz.def.basic-java.title"), isNull(), eq("basic-java"), any(Locale.class)))
                .thenReturn("Temel Java");

        List<QuizNav> nav = service().buildQuizNav(Language.TR);

        // Java'nın hiçbir override anahtarı yok -- davranış Faz 139'daki ORİJİNAL
        // haliyle BİREBİR AYNI kalmalı.
        assertThat(nav).hasSize(1);
        assertThat(nav.get(0).groupLabel()).isEqualTo("Java Sınavı");
    }

    private static QuizDefinition definitionOf(Course course, String slug, int sortOrder) {
        return QuizDefinition.builder()
                .id(1L)
                .course(course)
                .slug(slug)
                .questionCount(10)
                .active(true)
                .sortOrder(sortOrder)
                .build();
    }
}
