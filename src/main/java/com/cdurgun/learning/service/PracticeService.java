package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Difficulty;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Question;
import com.cdurgun.learning.domain.QuestionOption;
import com.cdurgun.learning.domain.QuestionStatus;
import com.cdurgun.learning.domain.QuestionType;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.repository.QuestionOptionRepository;
import com.cdurgun.learning.repository.QuestionRepository;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.web.quiz.PracticeSubmitRequest;
import com.cdurgun.learning.web.quiz.PracticeSubmitResponse;
import com.cdurgun.learning.web.quiz.QuestionView;
import com.cdurgun.learning.web.quiz.QuizAnswer;
import com.cdurgun.learning.web.quiz.QuizOptionView;
import com.cdurgun.learning.web.quiz.QuizQuestionResult;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * FAZ C: Practice, herhangi bir {@code Quiz} satırına İHTİYAÇ DUYMADAN doğrudan
 * soru havuzunu (topic/language/difficulty/type filtreli, rastgele) sorgular --
 * bkz. plan bölüm 5. {@code status = 'PUBLISHED'} filtresi
 * {@link QuestionRepository#findRandomPublishedPool} sorgusuna sabit yazılmış,
 * burada AYRICA tekrarlanmıyor (tek doğruluk kaynağı orada).
 */
@Service
public class PracticeService {

    private static final int DEFAULT_COUNT = 10;
    private static final int MAX_COUNT = 50;

    private final QuestionRepository questionRepository;
    private final QuestionOptionRepository questionOptionRepository;
    private final TopicRepository topicRepository;

    public PracticeService(QuestionRepository questionRepository,
                            QuestionOptionRepository questionOptionRepository,
                            TopicRepository topicRepository) {
        this.questionRepository = questionRepository;
        this.questionOptionRepository = questionOptionRepository;
        this.topicRepository = topicRepository;
    }

    /**
     * Rastgele bir practice seti çeker. Tüm filtreler (topicSlug/difficulty/type)
     * OPSİYONELDİR -- yalnızca dolu olanlar uygulanır. {@code count} null/<=0 ise
     * {@link #DEFAULT_COUNT}'a düşer, {@link #MAX_COUNT}'u aşamaz (tek istekte aşırı
     * büyük bir çekimle DB'yi zorlamayı önlemek için).
     */
    public List<QuestionView> draw(Language language, String topicSlug, Difficulty difficulty,
                                    QuestionType type, Integer count) {
        Long topicId = null;
        if (topicSlug != null && !topicSlug.isBlank()) {
            Topic topic = topicRepository.findBySlug(topicSlug)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Konu bulunamadı: " + topicSlug));
            topicId = topic.getId();
        }

        int resolvedCount = (count == null || count <= 0) ? DEFAULT_COUNT : Math.min(count, MAX_COUNT);

        List<Question> questions = questionRepository.findRandomPublishedPool(
                topicId,
                language.getCode(),
                difficulty == null ? null : difficulty.name(),
                type == null ? null : type.name(),
                resolvedCount);

        if (questions.isEmpty()) {
            return List.of();
        }

        Map<Long, List<QuestionOption>> optionsByQuestionId = loadOptionsByQuestionId(questions);

        List<QuestionView> views = new ArrayList<>();
        for (Question question : questions) {
            List<QuizOptionView> optionViews = optionsByQuestionId
                    .getOrDefault(question.getId(), List.of()).stream()
                    .map(o -> new QuizOptionView(o.getId(), o.getOptionText()))
                    .toList();
            views.add(new QuestionView(question.getId(), question.getQuestion(), question.getType(),
                    question.getCodeSnippet(), question.getCodeLanguage(), optionViews));
        }
        return views;
    }

    /**
     * Submit edilen cevapları doğrular ve puanlar. Sabit quiz submit'inin aksine
     * (bkz. QuizService.submit) burada bir Quiz'in TÜM sorularının cevaplanmış
     * olması gerekmiyor -- her cevap kendi başına, bağımsız olarak doğrulanır: soru
     * var mı, HÂLÂ {@code PUBLISHED} mi (draw ile submit arasında review durumu
     * değişmiş olabilir), bu dile mi ait. Doğruluk kontrolü, sabit quiz'le AYNI
     * {@link QuestionScorer} ile, tam küme eşleşmesiyle yapılır (MULTIPLE_CHOICE
     * kısmi doğru cevabı KABUL ETMEZ).
     */
    public PracticeSubmitResponse submit(Language language, PracticeSubmitRequest request) {
        List<QuizAnswer> answers = request == null ? null : request.answers();
        if (answers == null || answers.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "answers is required");
        }

        Set<Long> answeredQuestionIds = new HashSet<>();
        for (QuizAnswer answer : answers) {
            if (answer.questionId() == null || answer.selectedOptionIds() == null || answer.selectedOptionIds().isEmpty()) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "each answer requires a questionId and at least one selectedOptionId");
            }
            if (!answeredQuestionIds.add(answer.questionId())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "duplicate questionId in answers");
            }
            if (new HashSet<>(answer.selectedOptionIds()).size() != answer.selectedOptionIds().size()) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "duplicate selectedOptionIds for questionId " + answer.questionId());
            }
        }

        List<Question> questions = questionRepository.findAllById(answeredQuestionIds);
        if (questions.size() != answeredQuestionIds.size()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "unknown question id(s)");
        }
        for (Question question : questions) {
            if (question.getStatus() != QuestionStatus.PUBLISHED) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "question " + question.getId() + " is not published");
            }
            if (question.getLanguage() != language) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "question " + question.getId() + " does not belong to this language");
            }
        }

        Map<Long, QuizAnswer> answerByQuestionId = answers.stream()
                .collect(Collectors.toMap(QuizAnswer::questionId, a -> a));
        Map<Long, List<QuestionOption>> allOptionsByQuestionId = loadOptionsByQuestionId(questions);

        Set<Long> allSubmittedOptionIds = answers.stream()
                .flatMap(a -> a.selectedOptionIds().stream())
                .collect(Collectors.toSet());
        List<QuestionOption> submittedOptions =
                questionOptionRepository.findByIdInWithQuestionAndTopic(new ArrayList<>(allSubmittedOptionIds));
        if (submittedOptions.size() != allSubmittedOptionIds.size()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "unknown option id(s)");
        }
        Map<Long, Long> questionIdByOptionId = submittedOptions.stream()
                .collect(Collectors.toMap(QuestionOption::getId, o -> o.getQuestion().getId()));
        for (QuizAnswer answer : answers) {
            for (Long optionId : answer.selectedOptionIds()) {
                if (!answer.questionId().equals(questionIdByOptionId.get(optionId))) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                            "option " + optionId + " does not belong to question " + answer.questionId());
                }
            }
        }

        List<QuizQuestionResult> results = new ArrayList<>();
        int score = 0;
        for (Question question : questions) {
            List<QuestionOption> options = allOptionsByQuestionId.getOrDefault(question.getId(), List.of());
            Set<Long> correctOptionIds = options.stream()
                    .filter(QuestionOption::isCorrect)
                    .map(QuestionOption::getId)
                    .collect(Collectors.toSet());
            if (correctOptionIds.isEmpty()) {
                throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
                        "question " + question.getId() + " has no correct option configured");
            }

            QuizAnswer answer = answerByQuestionId.get(question.getId());
            Set<Long> selectedOptionIds = new HashSet<>(answer.selectedOptionIds());
            boolean correct = QuestionScorer.isCorrect(correctOptionIds, selectedOptionIds);
            if (correct) {
                score++;
            }

            results.add(new QuizQuestionResult(question.getId(), answer.selectedOptionIds(), correct,
                    List.copyOf(correctOptionIds), question.getExplanation()));
        }

        return new PracticeSubmitResponse(score, questions.size(), results);
    }

    private Map<Long, List<QuestionOption>> loadOptionsByQuestionId(List<Question> questions) {
        List<Long> questionIds = questions.stream().map(Question::getId).toList();
        List<QuestionOption> options = questionOptionRepository.findByQuestionIdInOrderBySortOrderAsc(questionIds);
        Map<Long, List<QuestionOption>> byQuestionId = new HashMap<>();
        for (QuestionOption option : options) {
            byQuestionId.computeIfAbsent(option.getQuestion().getId(), id -> new ArrayList<>()).add(option);
        }
        return byQuestionId;
    }
}
