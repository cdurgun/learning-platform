package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Question;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.repository.QuestionRepository;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.web.internal.ExistingQuestionView;
import com.cdurgun.learning.web.internal.TopicMetadataResponse;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

/**
 * Question generation tooling (n8n'in büyük ölçekli soru üretim workflow'u) için
 * salt-okunur destek -- topic metadata/gövde içeriği ve mevcut soru metinleri
 * (duplicate kontrolü için). n8n'in Postgres'e DOĞRUDAN bağlanmasının YASAK
 * olduğu mimari karara dayanır (bkz. Faz "Large-Scale Question Generation Workflow"
 * planı) -- n8n bunun yerine bu servisin arkasındaki `/api/internal/**` uç
 * noktalarını çağırır, AYNI `QuizIngestApiKeyInterceptor`/`X-Api-Key` koruması
 * altında (yeni bir güvenlik mekanizması KURULMADI, yalnızca var olan
 * `/api/internal/**` path pattern'ine iki yeni GET rotası eklendi).
 *
 * <p>BU SERVİS HİÇBİR {@code Question} SATIRINI YAZMAZ -- yalnızca okur. Soru
 * havuzuna yazmanın TEK yolu hâlâ {@link QuestionIngestService#ingest}.</p>
 */
@Service
public class GenerationToolingService {

    private final TopicRepository topicRepository;
    private final ContentResolver contentResolver;
    private final QuestionRepository questionRepository;

    public GenerationToolingService(TopicRepository topicRepository,
                                     ContentResolver contentResolver,
                                     QuestionRepository questionRepository) {
        this.topicRepository = topicRepository;
        this.contentResolver = contentResolver;
        this.questionRepository = questionRepository;
    }

    @Transactional(readOnly = true)
    public TopicMetadataResponse getMetadata(String slug) {
        Topic topic = findTopicOrThrow(slug);
        return new TopicMetadataResponse(
                topic.getSlug(),
                topic.getDifficulty().name(),
                topic.getCategory().getSlug(),
                topic.getCategory().getCourse().getSlug(),
                topic.getEstimatedMinutes());
    }

    public String getContent(String slug, String languageCode) {
        // Topic'in var olduğunu ayrıca doğruluyoruz -- "topic yok" ile "topic var
        // ama bu dilde içerik dosyası yok" arasındaki farkı net tutmak için (ikisi
        // de 404 ama farklı mesajlarla, n8n'in Load Topic Content aşamasında hangi
        // durumun oluştuğunu ayırt edebilmesi için).
        findTopicOrThrow(slug);
        Language language = parseLanguage(languageCode);
        return contentResolver.resolve(slug, language)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "no content file for topic '" + slug + "' in language '" + languageCode + "'"));
    }

    @Transactional(readOnly = true)
    public List<ExistingQuestionView> listExisting(String topicSlug, String languageCode) {
        Topic topic = findTopicOrThrow(topicSlug);
        Language language = parseLanguage(languageCode);
        List<Question> questions = questionRepository.findByTopicIdAndLanguage(topic.getId(), language);
        return questions.stream()
                .map(q -> new ExistingQuestionView(q.getId(), q.getQuestion()))
                .toList();
    }

    private Topic findTopicOrThrow(String slug) {
        return topicRepository.findBySlugWithCategoryAndCourse(slug)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "unknown topic slug: " + slug));
    }

    private static Language parseLanguage(String rawValue) {
        if (rawValue == null || rawValue.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "language is required");
        }
        try {
            return Language.fromCode(rawValue.trim());
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid language: " + rawValue);
        }
    }
}
