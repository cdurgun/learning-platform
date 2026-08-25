package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Course;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.QuizDefinition;
import com.cdurgun.learning.repository.QuizDefinitionRepository;
import com.cdurgun.learning.web.nav.QuizNav;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Quiz Area'nın sidebar nav ağacını ({@link QuizNav}) kurar -- {@link NavigationService}'in
 * Course→Category→Topic ağacından BİLİNÇLİ OLARAK AYRI, küçük ve tek amaçlı bir servis
 * (bkz. plan, "Web layer"): {@link QuizDefinition} tamamen farklı bir DB kaynağı ve
 * gruplama anahtarı kullanıyor, başlıklar DB kolonundan değil {@code MessageSource}'tan
 * geliyor -- bu iki farklı kaynağı tek bir NavigationService'e karıştırmak yerine ayrı
 * tutuluyor.
 *
 * <p>Başlıklar {@code messages_{lang}.properties}'ten slug konvansiyonuyla okunur
 * ({@code quiz.def.{slug}.title}) -- bkz. {@link QuizDefinition} javadoc'u. Eksik/typo'lu
 * bir key, {@code NoSuchMessageException} fırlatıp TÜM sayfayı kırmak yerine ham slug'a
 * düşer (4 parametreli {@code getMessage} overload'u ile) -- bu liste artık sitewide
 * olduğu için (bkz. {@code GlobalModelAttributes}) bu savunma önemli.</p>
 */
@Service
public class QuizNavigationService {

    private final QuizDefinitionRepository quizDefinitionRepository;
    private final MessageSource messageSource;

    public QuizNavigationService(QuizDefinitionRepository quizDefinitionRepository, MessageSource messageSource) {
        this.quizDefinitionRepository = quizDefinitionRepository;
        this.messageSource = messageSource;
    }

    @Transactional(readOnly = true)
    public List<QuizNav> buildQuizNav(Language language) {
        Locale locale = Locale.forLanguageTag(language.getCode());
        List<QuizDefinition> definitions = quizDefinitionRepository.findAllActiveOrderByCourseAndSortOrder();

        Map<Long, List<QuizDefinition>> byCourseId = definitions.stream()
                .collect(Collectors.groupingBy(d -> d.getCourse().getId(), LinkedHashMap::new, Collectors.toList()));

        List<QuizNav> nav = new ArrayList<>();
        for (List<QuizDefinition> group : byCourseId.values()) {
            Course course = group.get(0).getCourse();
            String groupLabel = messageSource.getMessage("quiz.courseGroup", new Object[]{course.getName()}, locale);
            List<QuizNav.QuizDefinitionNavItem> items = group.stream()
                    .map(d -> new QuizNav.QuizDefinitionNavItem(d.getSlug(),
                            messageSource.getMessage("quiz.def." + d.getSlug() + ".title", null, d.getSlug(), locale)))
                    .toList();
            nav.add(new QuizNav(groupLabel, course.getSlug(), items));
        }
        return nav;
    }
}
