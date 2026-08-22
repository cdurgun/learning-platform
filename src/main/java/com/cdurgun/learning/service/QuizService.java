package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.QuizOption;
import com.cdurgun.learning.domain.QuizQuestion;
import com.cdurgun.learning.repository.QuizOptionRepository;
import com.cdurgun.learning.repository.QuizQuestionRepository;
import com.cdurgun.learning.web.quiz.QuizOptionView;
import com.cdurgun.learning.web.quiz.QuizQuestionResult;
import com.cdurgun.learning.web.quiz.QuizQuestionView;
import com.cdurgun.learning.web.quiz.QuizSubmitRequest;
import com.cdurgun.learning.web.quiz.QuizSubmitResponse;
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

@Service
public class QuizService {

    private final QuizQuestionRepository quizQuestionRepository;
    private final QuizOptionRepository quizOptionRepository;

    public QuizService(QuizQuestionRepository quizQuestionRepository,
                        QuizOptionRepository quizOptionRepository) {
        this.quizQuestionRepository = quizQuestionRepository;
        this.quizOptionRepository = quizOptionRepository;
    }

    /**
     * Konu sayfasında render edilecek quiz görünümü. Bu konu/dilde quiz yoksa
     * (bugün için enum dışındaki her konu) boş liste döner — bu normal bir durumdur,
     * hata değildir.
     */
    public List<QuizQuestionView> loadQuiz(Long topicId, Language language) {
        List<QuizQuestion> questions = quizQuestionRepository
                .findByTopicIdAndLanguageOrderBySortOrderAsc(topicId, language);
        if (questions.isEmpty()) {
            return List.of();
        }

        Map<Long, List<QuizOption>> optionsByQuestionId = loadOptionsByQuestionId(questions);

        List<QuizQuestionView> views = new ArrayList<>();
        for (QuizQuestion question : questions) {
            List<QuizOptionView> optionViews = optionsByQuestionId
                    .getOrDefault(question.getId(), List.of()).stream()
                    .map(o -> new QuizOptionView(o.getId(), o.getOptionText()))
                    .toList();
            views.add(new QuizQuestionView(question.getId(), question.getQuestion(), optionViews));
        }
        return views;
    }

    /**
     * Submit edilen cevapları doğrular ve puanlar. Her adımda uygun olmayan bir
     * durum 400 (Bad Request) ile sonuçlanır — client'a is_correct hiçbir zaman
     * submit öncesi gönderilmez, doğru şık yalnızca bu metodun döndürdüğü sonuçta yer alır.
     */
    public QuizSubmitResponse submit(Long topicId, Language language, QuizSubmitRequest request) {
        List<Long> selectedOptionIds = request == null ? null : request.selectedOptionIds();
        if (selectedOptionIds == null || selectedOptionIds.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "selectedOptionIds is required");
        }

        Set<Long> distinctSelectedIds = new HashSet<>(selectedOptionIds);
        if (distinctSelectedIds.size() != selectedOptionIds.size()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "duplicate selectedOptionIds");
        }

        List<QuizQuestion> questions = quizQuestionRepository
                .findByTopicIdAndLanguageOrderBySortOrderAsc(topicId, language);
        if (questions.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "no quiz available for this topic/language");
        }

        if (selectedOptionIds.size() != questions.size()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "expected " + questions.size() + " answers, got " + selectedOptionIds.size());
        }

        List<QuizOption> submittedOptions = quizOptionRepository.findByIdInWithQuestionAndTopic(selectedOptionIds);
        if (submittedOptions.size() != selectedOptionIds.size()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "unknown option id(s)");
        }

        for (QuizOption option : submittedOptions) {
            QuizQuestion owningQuestion = option.getQuestion();
            if (!owningQuestion.getTopic().getId().equals(topicId) || owningQuestion.getLanguage() != language) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "option " + option.getId() + " does not belong to this topic/language");
            }
        }

        Set<Long> canonicalQuestionIds = questions.stream().map(QuizQuestion::getId).collect(Collectors.toSet());
        Map<Long, QuizOption> submittedOptionByQuestionId = new HashMap<>();
        for (QuizOption option : submittedOptions) {
            submittedOptionByQuestionId.put(option.getQuestion().getId(), option);
        }
        if (!submittedOptionByQuestionId.keySet().equals(canonicalQuestionIds)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "answers must cover exactly the topic's questions, one each");
        }

        Map<Long, List<QuizOption>> allOptionsByQuestionId = loadOptionsByQuestionId(questions);

        List<QuizQuestionResult> results = new ArrayList<>();
        int score = 0;
        for (QuizQuestion question : questions) {
            QuizOption correctOption = allOptionsByQuestionId.getOrDefault(question.getId(), List.of()).stream()
                    .filter(QuizOption::isCorrect)
                    .findFirst()
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
                            "question " + question.getId() + " has no correct option configured"));

            QuizOption selectedOption = submittedOptionByQuestionId.get(question.getId());
            boolean correct = selectedOption.getId().equals(correctOption.getId());
            if (correct) {
                score++;
            }

            results.add(new QuizQuestionResult(question.getId(), selectedOption.getId(), correct,
                    correctOption.getId(), question.getExplanation()));
        }

        boolean passed = ((double) score / questions.size()) >= 0.80;
        return new QuizSubmitResponse(score, questions.size(), passed, results);
    }

    private Map<Long, List<QuizOption>> loadOptionsByQuestionId(List<QuizQuestion> questions) {
        List<Long> questionIds = questions.stream().map(QuizQuestion::getId).toList();
        List<QuizOption> options = quizOptionRepository.findByQuestionIdInOrderBySortOrderAsc(questionIds);
        Map<Long, List<QuizOption>> byQuestionId = new HashMap<>();
        for (QuizOption option : options) {
            byQuestionId.computeIfAbsent(option.getQuestion().getId(), id -> new ArrayList<>()).add(option);
        }
        return byQuestionId;
    }
}
