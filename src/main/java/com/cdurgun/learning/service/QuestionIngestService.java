package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Difficulty;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Question;
import com.cdurgun.learning.domain.QuestionOption;
import com.cdurgun.learning.domain.QuestionSource;
import com.cdurgun.learning.domain.QuestionStatus;
import com.cdurgun.learning.domain.QuestionType;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.repository.QuestionOptionRepository;
import com.cdurgun.learning.repository.QuestionRepository;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.web.ingest.QuestionIngestOption;
import com.cdurgun.learning.web.ingest.QuestionIngestRequest;
import com.cdurgun.learning.web.ingest.QuestionIngestResponse;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * FAZ D: AI/n8n'in soru havuzuna yazdığı TEK giriş noktası. Buradan geçen HER
 * soru, client ne gönderirse göndersin, {@code status = PENDING_REVIEW} ve
 * {@code source = AI} ile kaydedilir -- bu iki alan {@link QuestionIngestRequest}'te
 * hiç YOK (bkz. o DTO'nun javadoc'u), yani "sunucu ezer" kuralı burada bir
 * if/override değil, DTO'nun kendisinden kaynaklanan bir imkansızlık. Kimlik
 * doğrulama (X-Api-Key) bu servisin SORUMLULUĞUNDA DEĞİL --
 * {@code config.QuizIngestApiKeyInterceptor} tarafından, bu servise hiç
 * ulaşılamadan önce yapılır.
 */
@Service
public class QuestionIngestService {

    private final TopicRepository topicRepository;
    private final QuestionRepository questionRepository;
    private final QuestionOptionRepository questionOptionRepository;

    public QuestionIngestService(TopicRepository topicRepository,
                                  QuestionRepository questionRepository,
                                  QuestionOptionRepository questionOptionRepository) {
        this.topicRepository = topicRepository;
        this.questionRepository = questionRepository;
        this.questionOptionRepository = questionOptionRepository;
    }

    @Transactional
    public QuestionIngestResponse ingest(QuestionIngestRequest request) {
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "request body is required");
        }

        Topic topic = topicRepository.findBySlug(requireNonBlank(request.topicSlug(), "topicSlug"))
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "unknown topicSlug: " + request.topicSlug()));

        Language language = parseLanguage(request.language());
        QuestionType type = parseEnum(QuestionType.class, request.type(), "type");
        Difficulty difficulty = parseEnum(Difficulty.class, request.difficulty(), "difficulty");

        String questionText = requireNonBlank(request.question(), "question");
        String explanation = requireNonBlank(request.explanation(), "explanation");

        List<QuestionIngestOption> options = request.options();
        if (options == null || options.size() < 2) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "at least two options are required");
        }
        for (QuestionIngestOption option : options) {
            requireNonBlank(option.optionText(), "options[].optionText");
        }
        validateCorrectOptionCount(type, options);

        String codeSnippet = validateCodeSnippet(type, request.codeSnippet());
        String codeLanguage = (type == QuestionType.CODE_OUTPUT) ? request.codeLanguage() : null;

        LocalDateTime now = LocalDateTime.now();
        Question question = questionRepository.save(Question.builder()
                .topic(topic)
                .language(language)
                .type(type)
                .difficulty(difficulty)
                .status(QuestionStatus.PENDING_REVIEW)
                .source(QuestionSource.AI)
                .question(questionText)
                .codeSnippet(codeSnippet)
                .codeLanguage(codeLanguage)
                .explanation(explanation)
                .createdAt(now)
                .updatedAt(now)
                .build());

        List<QuestionOption> optionEntities = new ArrayList<>();
        for (int i = 0; i < options.size(); i++) {
            QuestionIngestOption option = options.get(i);
            optionEntities.add(QuestionOption.builder()
                    .question(question)
                    .optionText(option.optionText().trim())
                    .correct(option.correct())
                    .sortOrder(i)
                    .build());
        }
        questionOptionRepository.saveAll(optionEntities);

        return new QuestionIngestResponse(question.getId(), question.getStatus().name(), question.getSource().name());
    }

    /**
     * SINGLE_CHOICE/CODE_OUTPUT tam olarak bir, MULTIPLE_CHOICE bir veya daha
     * fazla doğru şık gerektirir (bkz. plan bölüm 5.1, madde 4). Bu kontrol
     * yalnızca burada değil, sabit quiz/practice puanlamasının dayandığı AYNI
     * kuralın ingestion-zamanı karşılığıdır -- DB artık bunu zorlamıyor
     * (core/V293), bu yüzden burada zorlanması ZORUNLU.
     */
    private static void validateCorrectOptionCount(QuestionType type, List<QuestionIngestOption> options) {
        long correctCount = options.stream().filter(QuestionIngestOption::correct).count();
        switch (type) {
            case SINGLE_CHOICE, CODE_OUTPUT -> {
                if (correctCount != 1) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                            type + " requires exactly one correct option, got " + correctCount);
                }
            }
            case MULTIPLE_CHOICE -> {
                if (correctCount < 1) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                            "MULTIPLE_CHOICE requires at least one correct option");
                }
            }
        }
    }

    private static String validateCodeSnippet(QuestionType type, String codeSnippet) {
        boolean blank = codeSnippet == null || codeSnippet.isBlank();
        if (type == QuestionType.CODE_OUTPUT) {
            if (blank) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "codeSnippet is required for CODE_OUTPUT");
            }
            return codeSnippet;
        }
        if (!blank) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "codeSnippet is only allowed for CODE_OUTPUT");
        }
        return null;
    }

    private static Language parseLanguage(String rawValue) {
        String value = requireNonBlank(rawValue, "language");
        try {
            return Language.fromCode(value);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid language: " + rawValue);
        }
    }

    private static <E extends Enum<E>> E parseEnum(Class<E> enumType, String rawValue, String fieldName) {
        String value = requireNonBlank(rawValue, fieldName);
        try {
            return Enum.valueOf(enumType, value.trim().toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid " + fieldName + ": " + rawValue);
        }
    }

    private static String requireNonBlank(String value, String fieldName) {
        if (value == null || value.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, fieldName + " is required");
        }
        return value.trim();
    }
}
