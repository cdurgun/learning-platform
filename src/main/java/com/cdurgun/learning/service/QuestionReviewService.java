package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.PublishLogStatus;
import com.cdurgun.learning.domain.Question;
import com.cdurgun.learning.domain.QuestionOption;
import com.cdurgun.learning.domain.QuestionPublishLog;
import com.cdurgun.learning.domain.QuestionStatus;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.domain.TopicTranslation;
import com.cdurgun.learning.repository.QuestionOptionRepository;
import com.cdurgun.learning.repository.QuestionRepository;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import com.cdurgun.learning.web.publish.QuestionAutoPublishRequest;
import com.cdurgun.learning.web.publish.QuestionAutoPublishResponse;
import com.cdurgun.learning.web.review.QuestionReviewView;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
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

    private static final Logger log = LoggerFactory.getLogger(QuestionReviewService.class);

    /**
     * {@link #autoPublish}'in yazdığı {@code reviewed_by} değeri -- gerçek bir ADMIN
     * e-postasından AÇIKÇA ayırt edilebilir olması için sabit, insan-olmayan bir işaret
     * (bkz. plan bölüm 7/10). Review ekranında/raporlamada auto-publish edilmiş
     * sorular bu değerle diğerlerinden ayırt edilebilir.
     */
    static final String AUTO_PUBLISH_REVIEWER = "n8n-ai-judge";

    private final QuestionRepository questionRepository;
    private final QuestionOptionRepository questionOptionRepository;
    private final TopicTranslationRepository topicTranslationRepository;
    private final QuestionPublishAuditService questionPublishAuditService;
    private final boolean autoPublishEnabled;

    public QuestionReviewService(QuestionRepository questionRepository,
                                  QuestionOptionRepository questionOptionRepository,
                                  TopicTranslationRepository topicTranslationRepository,
                                  QuestionPublishAuditService questionPublishAuditService,
                                  @Value("${quiz.auto-publish.enabled:false}") boolean autoPublishEnabled) {
        this.questionRepository = questionRepository;
        this.questionOptionRepository = questionOptionRepository;
        this.topicTranslationRepository = topicTranslationRepository;
        this.questionPublishAuditService = questionPublishAuditService;
        this.autoPublishEnabled = autoPublishEnabled;
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

    /**
     * n8n'in AI Judge aşaması bir soruyu APPROVE ettikten SONRA çağırdığı yol --
     * {@link #transition}'ı ({@link #publish}/{@link #reject}'in AYNI, tek doğruluk
     * kaynağı olan geçiş mantığı) {@code reviewerEmail} yerine {@link
     * #AUTO_PUBLISH_REVIEWER} ile yeniden kullanır, böylece PENDING_REVIEW-only kuralı
     * (409 Conflict) ve status/reviewedBy/reviewedAt ataması İNSAN publish'iyle BİREBİR
     * aynı kalır -- bir "auto-publish yolu" diye ayrı bir durum makinesi İCAT EDİLMEDİ.
     *
     * <p><b>Kill switch:</b> {@code quiz.auto-publish.enabled} (env: {@code
     * QUIZ_AUTO_PUBLISH_ENABLED}) {@code false}/tanımsızsa istek 503 ile reddedilir --
     * {@link com.cdurgun.learning.config.QuizIngestApiKeyInterceptor}'ın "anahtar
     * yapılandırılmamışsa reddet" fail-closed deseniyle AYNI mantık.</p>
     *
     * <p><b>Duplicate-publish koruması:</b> birincil katman {@link #transition}'ın
     * kendisi -- soru zaten {@code PUBLISHED} (ya da başka bir durumda) ise 409 atar,
     * hiçbir yeni durum değişikliği OLMAZ. Bu durumda soru zaten VAR OLDUĞU için
     * (404 değil) bir {@code FAILED} denetim satırı yazılır -- {@code question_id}
     * (metnin kendisi değil, sorunun gerçek PK'sı) üzerinden migration V465'teki kısmi
     * unique index'le İKİNCİ bir fiziksel güvenlik ağı da sağlanmış olur. 404
     * durumunda (soru hiç yok) hiçbir log satırı YAZILMAZ -- {@code question_id} FK'sı
     * var olmayan bir soruya işaret edemez.</p>
     *
     * <p><b>{@code @Transactional} (REQUIRED)</b> -- {@link #transition}'ın read-check-
     * write'ı {@link #publish}/{@link #reject} ile AYNI atomiklikte, TEK bir DB
     * transaction'ı olarak çalışır. Denetim kaydı yazma sorumluluğu BİLİNÇLİ OLARAK bu
     * transaction'ın DIŞINA taşındı -- {@link QuestionPublishAuditService#record}
     * {@code Propagation.REQUIRES_NEW} ile KENDİ bağımsız transaction'ında commit olur,
     * bu yüzden (a) başarılı bir geçişin ardından denetim satırı yazımı başarısız olsa
     * bile {@code Question.status} zaten kalıcı olarak değişmiştir ve (b) {@code catch}
     * bloğundaki {@code FAILED} satırı, dışarı fırlatılan {@link
     * ResponseStatusException} yüzünden bu metodun kendi transaction'ı rollback olsa
     * DAHİ KAYBOLMAZ (gerçek bir çalıştırmada ÖNCE gözlemlenip DÜZELTİLEN bir hata --
     * denetim kaydı tek bir sarmalayıcı transaction İÇİNDE yazılsaydı bu SESSİZCE
     * kaybolurdu). Her iki denetim yazımı da AYRICA try/catch ile sarılı: ikincil bir
     * denetim-yazma hatası (ör. geçici bir DB sorunu, ya da eşzamanlı iki başarılı
     * geçişin {@code uq_question_publish_log_success_question} kısmi unique index'inde
     * çarpışması) ASLA (a) gerçekten başarılı olmuş bir yayınlamayı 500'e çeviremez,
     * (b) gerçek 409/404 hatasını maskeleyip yerine 500 döndüremez -- ikisinde de
     * yalnızca uygulama logger'ına yazılır, orijinal sonuç/istisna DEĞİŞMEDEN kalır.</p>
     *
     * <p><b>KASITLI OLARAK ele alınmayan:</b> aynı soru için eşzamanlı iki
     * {@code autoPublish} çağrısının {@code transition()} seviyesinde birbirini
     * engellemesi -- {@code Question}'da optimistic lock (`@Version`) ya da koşullu
     * {@code UPDATE ... WHERE status = 'PENDING_REVIEW'} YOK, bu {@link #publish}/
     * {@link #reject}'te de zaten önceden var olan, bu Faz'ın kapsamı DIŞINDA bırakılan
     * ayrı bir konu.</p>
     */
    @Transactional
    public QuestionAutoPublishResponse autoPublish(Long questionId, QuestionAutoPublishRequest request) {
        if (!autoPublishEnabled) {
            throw new ResponseStatusException(HttpStatus.SERVICE_UNAVAILABLE, "auto-publish is disabled");
        }

        String runId = request == null ? null : request.runId();
        String modelName = request == null ? null : request.modelName();
        String reason = request == null ? null : request.reason();
        LocalDateTime now = LocalDateTime.now();

        try {
            transition(questionId, AUTO_PUBLISH_REVIEWER, QuestionStatus.PUBLISHED);
        } catch (ResponseStatusException e) {
            if (e.getStatusCode() == HttpStatus.CONFLICT) {
                recordAuditRowSafely(QuestionPublishLog.builder()
                        .questionId(questionId)
                        .runId(runId)
                        .modelName(modelName)
                        .reason(reason)
                        .status(PublishLogStatus.FAILED)
                        .errorMessage(e.getReason())
                        .createdAt(now)
                        .build());
            }
            // The original business error (409/404) is always what the caller sees,
            // regardless of whether the audit write above succeeded.
            throw e;
        }

        recordAuditRowSafely(QuestionPublishLog.builder()
                .questionId(questionId)
                .runId(runId)
                .modelName(modelName)
                .reason(reason)
                .status(PublishLogStatus.SUCCESS)
                .publishedAt(now)
                .createdAt(now)
                .build());

        // The transition above already committed (independently, via REQUIRES_NEW audit
        // writes never touching this transaction's outcome) -- the response always
        // reflects the real, successful publish, even if the audit row above failed.
        return new QuestionAutoPublishResponse(questionId, QuestionStatus.PUBLISHED.name(), "Question published automatically.");
    }

    /**
     * {@link QuestionPublishAuditService#record}'ı çağırır, ama onun bir hatasının
     * {@link #autoPublish}'in asıl sonucunu (başarılı yanıt ya da orijinal 409/404)
     * DEĞİŞTİRMESİNE asla izin vermez -- yalnızca logger'a yazılır. Denetim kaydı
     * ikincil bir kaygı, {@code Question.status}/orijinal hata birincil gerçek.
     */
    private void recordAuditRowSafely(QuestionPublishLog auditLog) {
        try {
            questionPublishAuditService.record(auditLog);
        } catch (RuntimeException e) {
            log.error("Failed to write question_publish_log audit row for question {} (status={}): {}",
                    auditLog.getQuestionId(), auditLog.getStatus(), e.getMessage(), e);
        }
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
