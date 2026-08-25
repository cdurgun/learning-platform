package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.service.PracticeService;
import com.cdurgun.learning.service.QuizDefinitionService;
import com.cdurgun.learning.web.quiz.PracticeSubmitRequest;
import com.cdurgun.learning.web.quiz.PracticeSubmitResponse;
import com.cdurgun.learning.web.quiz.QuestionView;
import com.cdurgun.learning.web.quiz.QuizAnswer;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.MessageSource;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.ExtendedModelMap;
import org.springframework.ui.Model;

import java.util.List;
import java.util.Locale;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

/**
 * Mimari kuralı doğrudan doğrular: bu controller'da değerlendirme/puanlama mantığı
 * OLMAMALI -- yalnızca {@link QuizDefinitionService#draw}/{@link PracticeService#submit}'e
 * delege eder. Gerçek çekme/puanlama davranışı zaten {@code QuizDefinitionServiceTest}/
 * {@code PracticeServiceTest}'te kapsamlıca test ediliyor, burada yalnızca controller'ın
 * doğru servis metodunu doğru parametrelerle çağırdığı ve sonucu OLDUĞU GİBİ döndürdüğü
 * doğrulanıyor -- MockMvc/Spring context GEREKMİYOR (constructor injection, business
 * logic yok).
 */
@ExtendWith(MockitoExtension.class)
class QuizAreaControllerTest {

    @Mock
    private QuizDefinitionService quizDefinitionService;
    @Mock
    private PracticeService practiceService;
    @Mock
    private MessageSource messageSource;

    private QuizAreaController controller() {
        return new QuizAreaController(quizDefinitionService, practiceService, messageSource);
    }

    @Test
    void indexReturnsIndexViewWithLanguageOnly() {
        Model model = new ExtendedModelMap();

        String view = controller().index("tr", model);

        assertThat(view).isEqualTo("quiz-index");
        assertThat(model.getAttribute("language")).isEqualTo(Language.TR);
        verifyNoInteractions(quizDefinitionService, practiceService);
    }

    @Test
    void playDelegatesDrawAndResolvesTitleViaSlugConvention() {
        List<QuestionView> questions = List.of();
        when(quizDefinitionService.draw(Language.EN, "basic-java")).thenReturn(questions);
        when(messageSource.getMessage(eq("quiz.def.basic-java.title"), isNull(), eq("basic-java"), any(Locale.class)))
                .thenReturn("Basic Java");
        Model model = new ExtendedModelMap();

        String view = controller().play("en", "basic-java", model);

        assertThat(view).isEqualTo("quiz-play");
        assertThat(model.getAttribute("language")).isEqualTo(Language.EN);
        assertThat(model.getAttribute("definitionSlug")).isEqualTo("basic-java");
        assertThat(model.getAttribute("quizTitle")).isEqualTo("Basic Java");
        assertThat(model.getAttribute("quizQuestions")).isSameAs(questions);
        verifyNoInteractions(practiceService);
    }

    @Test
    void submitDelegatesToPracticeServiceSubmitUnchangedRegardlessOfDefinitionSlug() {
        PracticeSubmitRequest request = new PracticeSubmitRequest(List.of(new QuizAnswer(1L, List.of(10L))));
        PracticeSubmitResponse response = new PracticeSubmitResponse(1, 1, List.of());
        when(practiceService.submit(Language.EN, request)).thenReturn(response);

        ResponseEntity<PracticeSubmitResponse> result = controller().submit("en", "basic-java", request);

        // definitionSlug submit'e HİÇ aktarılmıyor -- puanlama kapsamdan bağımsız.
        assertThat(result.getBody()).isSameAs(response);
        verify(practiceService).submit(Language.EN, request);
        verifyNoInteractions(quizDefinitionService);
    }
}
