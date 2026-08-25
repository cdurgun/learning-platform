package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Category;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Question;
import com.cdurgun.learning.domain.QuizDefinition;
import com.cdurgun.learning.repository.QuestionRepository;
import com.cdurgun.learning.repository.QuizDefinitionRepository;
import com.cdurgun.learning.web.quiz.QuestionView;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

/**
 * Quiz Area: bir {@link QuizDefinition} slug'ını (course_id, opsiyonel category_id[])
 * kapsamına çözer ve rastgele bir soru seti çeker. Bilinçli olarak KÜÇÜK ve TEK amaçlı
 * -- yalnızca "hangi soruları çekeceğim" sorusunu cevaplar; puanlama/submit BURADA
 * DEĞİL, {@link PracticeService#submit} tarafından AYNEN (değiştirilmeden) yapılır,
 * çünkü submit zaten her cevabı bağımsız doğruluyor ve hangi kapsamdan çekildiğini
 * hiç bilmesi gerekmiyor (bkz. plan bölüm "Service layer").
 *
 * <p>{@code question_count}, bir ÜST SINIR olarak ele alınır, bir GARANTİ değil --
 * kapsamda o sayıdan az uygun ({@code PUBLISHED}) soru varsa, {@link
 * QuestionRepository#findRandomPublishedPoolByCourseAndCategories}'in native
 * {@code LIMIT} semantiği zaten mevcut olan kadarını hatasız döner; burada ayrı bir
 * "yetersiz soru" kontrolü/istisnası YOK, sıfır sonuç bile geçerli bir sonuçtur (boş
 * bir quiz sayfası olarak ele alınır, template katmanında).</p>
 */
@Service
public class QuizDefinitionService {

    private final QuizDefinitionRepository quizDefinitionRepository;
    private final QuestionRepository questionRepository;
    private final PracticeService practiceService;

    public QuizDefinitionService(QuizDefinitionRepository quizDefinitionRepository,
                                  QuestionRepository questionRepository,
                                  PracticeService practiceService) {
        this.quizDefinitionRepository = quizDefinitionRepository;
        this.questionRepository = questionRepository;
        this.practiceService = practiceService;
    }

    /**
     * {@code @Transactional(readOnly = true)} BİLİNÇLİ OLARAK burada -- {@code
     * def.getCourse()} ve {@code def.getCategories()} LAZY ilişkiler, Open Session in
     * View'a güvenmek yerine bu metot içinde, oturum hâlâ açıkken çözülmeleri
     * garantilenir (bkz. plan, "LAZY course/categories access").
     */
    @Transactional(readOnly = true)
    public List<QuestionView> draw(Language language, String definitionSlug) {
        QuizDefinition definition = quizDefinitionRepository.findBySlugAndActiveTrue(definitionSlug)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Quiz definition bulunamadı: " + definitionSlug));

        Long courseId = definition.getCourse().getId();
        Long[] categoryIds = definition.getCategories().isEmpty()
                ? null
                : definition.getCategories().stream().map(Category::getId).toArray(Long[]::new);

        List<Question> questions = questionRepository.findRandomPublishedPoolByCourseAndCategories(
                courseId, categoryIds, language.getCode(), null, null, definition.getQuestionCount());

        return practiceService.toQuestionViews(questions);
    }
}
