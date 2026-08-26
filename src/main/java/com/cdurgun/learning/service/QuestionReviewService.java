package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Question;
import com.cdurgun.learning.domain.QuestionOption;
import com.cdurgun.learning.domain.QuestionStatus;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.domain.TopicTranslation;
import com.cdurgun.learning.repository.QuestionOptionRepository;
import com.cdurgun.learning.repository.QuestionRepository;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import com.cdurgun.learning.web.review.QuestionReviewView;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Faz B (listeleme) + Faz C (Publish/Reject).
 *
 * <p>Var olan {@link QuestionOptionRepository#findByQuestionIdInOrderBySortOrderAsc}
 * AYNEN yeniden kullanılıyor (Practice/Quiz Area'nın da kullandığı metot) -- burada
 * seçeneklerin {@code correct} bilgisi GİZLENMİYOR (bkz. {@link QuestionReviewView}
 * javadoc'u), Practice'in {@code toQuestionViews}'inin AKSİNE.</p>
 *
 * <p>{@link #publish}/{@link #reject}, {@code Question.status}'u DEĞİŞTİREN TEK
 * yer -- ikisi de yalnızca {@code PENDING_REVIEW}'dan geçişe izin verir (zaten
 * PUBLISHED/REJECTED bir soru tekrar işlenemez, 409 döner) -- bu, iki reviewer'ın
 * aynı soruyu eşzamanlı işlemesi ya da bir formun yanlışlıkla iki kez submit
 * edilmesi durumunda sessizce YANLIŞ bir duruma geçmeyi önler. Public havuz
 * sorgularının ({@code QuestionRepository.findRandomPublishedPool}/
 * {@code findRandomPublishedPoolByCourseAndCategories}) {@code status='PUBLISHED'}
 * filtresi hâlâ SABİT YAZILI ve burada HİÇ dokunulmuyor -- {@code publish()}
 * çağrıldığı anda bu sorguların bir sonraki çalıştırmasında soru otomatik olarak
 * uygun hale gelir, ayrıca bir "public'e ekle" adımı GEREKMEZ.</p>
 */
@Service
public class QuestionReviewService {

    private final QuestionRepository questionRepository;
    private final QuestionOptionRepository questionOptionRepository;
    private final TopicTranslationRepository topicTranslationRepository;

    public QuestionReviewService(QuestionRepository questionRepository,
                                  QuestionOptionRepository questionOptionRepository,
                                  TopicTranslationRepository topicTranslationRepository) {
        this.questionRepository = questionRepository;
        this.questionOptionRepository = questionOptionRepository;
        this.topicTranslationRepository = topicTranslationRepository;
    }

    /**
     * {@code @Transactional(readOnly = true)} -- {@code question.getTopic()} LAZY,
     * oturum hâlâ açıkken (Open Session in View'a güvenmeden) çözülmesi için, {@link
     * QuizDefinitionService#draw}'daki AYNI disiplinle.
     */
    @Transactional(readOnly = true)
    public List<QuestionReviewView> listPending() {
        List<Question> pending = questionRepository.findByStatusOrderByCreatedAtAsc(QuestionStatus.PENDING_REVIEW);
        if (pending.isEmpty()) {
            return List.of();
        }

        List<Long> questionIds = pending.stream().map(Question::getId).toList();
        Map<Long, List<QuestionOption>> optionsByQuestionId = new HashMap<>();
        for (QuestionOption option : questionOptionRepository.findByQuestionIdInOrderBySortOrderAsc(questionIds)) {
            optionsByQuestionId.computeIfAbsent(option.getQuestion().getId(), id -> new ArrayList<>()).add(option);
        }

        List<QuestionReviewView> views = new ArrayList<>();
        for (Question question : pending) {
            Topic topic = question.getTopic();
            String topicTitle = topicTranslationRepository.findByTopicIdAndLanguage(topic.getId(), question.getLanguage())
                    .map(TopicTranslation::getTitle)
                    .orElse(topic.getSlug());

            List<QuestionReviewView.ReviewOptionView> optionViews = optionsByQuestionId
                    .getOrDefault(question.getId(), List.of()).stream()
                    .map(o -> new QuestionReviewView.ReviewOptionView(o.getId(), o.getOptionText(), o.isCorrect()))
                    .toList();

            views.add(new QuestionReviewView(
                    question.getId(),
                    question.getQuestion(),
                    question.getExplanation(),
                    question.getCodeSnippet(),
                    question.getCodeLanguage(),
                    question.getType(),
                    question.getDifficulty(),
                    question.getLanguage(),
                    question.getSource(),
                    question.getStatus(),
                    topic.getSlug(),
                    topicTitle,
                    question.getCreatedAt(),
                    optionViews));
        }
        return views;
    }

    @Transactional
    public void publish(Long questionId, String reviewerEmail) {
        transition(questionId, reviewerEmail, QuestionStatus.PUBLISHED);
    }

    @Transactional
    public void reject(Long questionId, String reviewerEmail) {
        transition(questionId, reviewerEmail, QuestionStatus.REJECTED);
    }

    private void transition(Long questionId, String reviewerEmail, QuestionStatus targetStatus) {
        Question question = questionRepository.findById(questionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Soru bulunamadı: " + questionId));

        if (question.getStatus() != QuestionStatus.PENDING_REVIEW) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "Soru " + questionId + " zaten " + question.getStatus() + " durumunda -- yalnızca PENDING_REVIEW "
                            + "sorular yayınlanabilir/reddedilebilir");
        }

        question.setStatus(targetStatus);
        question.setReviewedBy(reviewerEmail);
        question.setReviewedAt(LocalDateTime.now());
        questionRepository.save(question);
    }
}
