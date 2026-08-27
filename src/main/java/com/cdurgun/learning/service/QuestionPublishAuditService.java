package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.QuestionPublishLog;
import com.cdurgun.learning.repository.QuestionPublishLogRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * {@link QuestionReviewService#autoPublish}'in denetim kaydı yazma sınırı -- ayrı bir
 * Spring bean olarak var, çünkü {@code Propagation.REQUIRES_NEW} yalnızca gerçek bir
 * proxy çağrısı üzerinden çalışır (aynı sınıf içinde {@code this.xxx()} self-invocation
 * ile ÇAĞRILSAYDI, Spring'in proxy-tabanlı AOP'si bunu ATLAR, anotasyon hiç devreye
 * girmezdi). Bu sınıfın TEK sorumluluğu: {@link #record} çağıran taraf hangi
 * transaction'da olursa olsun (autoPublish() BAŞARILI olsa da, dışarı bir istisna
 * fırlatsa da) KENDİ bağımsız transaction'ında commit olur -- bu, "başarısız/duplicate
 * bir deneme denetim kaydı, o denemenin kendi transaction'ının rollback'iyle birlikte
 * sessizce kaybolmasın" gereksiniminin (bkz. QuestionReviewService javadoc'u) TEK
 * doğru çözümü.
 */
@Service
public class QuestionPublishAuditService {

    private final QuestionPublishLogRepository questionPublishLogRepository;

    public QuestionPublishAuditService(QuestionPublishLogRepository questionPublishLogRepository) {
        this.questionPublishLogRepository = questionPublishLogRepository;
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void record(QuestionPublishLog log) {
        questionPublishLogRepository.save(log);
    }
}
