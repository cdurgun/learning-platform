package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.service.ai.AiTutorService;
import com.cdurgun.learning.service.ai.AiTutorService.ErrorCode;
import com.cdurgun.learning.web.ai.TutorErrorResponse;
import com.cdurgun.learning.web.ai.TutorMessageRequest;
import com.cdurgun.learning.web.ai.TutorMessageResponse;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.core.Authentication;
import org.springframework.web.HttpMediaTypeNotSupportedException;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import java.util.Locale;
import java.util.UUID;

/**
 * AI Tutor JSON uç noktaları (plan §5, §6). Yalnızca HTTP: gövdeyi okur, servise verir, sonucu
 * durum koduna ve dile göre bir mesaja çevirir -- iş kuralı (erişim, ders, konuşma, bütçe) TAMAMEN
 * {@link AiTutorService}'te.
 *
 * <p>Yetki iki katmanlı: {@code /{lang}/admin/**} zaten SecurityConfig'te {@code hasRole("ADMIN")}
 * (anonim fetch 401 alır, USER 403); servis aynı kontrolü yeniden yapar. CSRF AÇIK: istek bir
 * oturum adına para harcadığı için {@code X-CSRF-TOKEN} başlığı zorunludur, muafiyet listesinde YOK.</p>
 */
@RestController
public class AiTutorController {

    private final AiTutorService service;
    private final MessageSource messageSource;

    public AiTutorController(AiTutorService service, MessageSource messageSource) {
        this.service = service;
        this.messageSource = messageSource;
    }

    // consumes BİLİNÇLİ OLARAK yok: JSON olmayan bir gövde eşleşmeyip genel bir 415 sayfasına düşmesin,
    // aşağıdaki işleyiciyle aynı invalid_request JSON'unu alsın (gövde yine yalnızca JSON olarak okunur).
    @PostMapping(path = "/{lang:en|tr}/admin/ai-tutor/messages", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> send(@PathVariable String lang,
                                  @RequestBody(required = false) TutorMessageRequest request,
                                  Authentication authentication,
                                  HttpServletRequest httpRequest) {
        Language language = Language.fromCode(lang);
        if (request == null) {
            return error(ErrorCode.INVALID_REQUEST, language);
        }
        AiTutorService.Result result = service.ask(authentication, httpRequest.getSession(),
                new AiTutorService.Question(request.conversationId(), request.message(), request.topicSlug(), language));
        return switch (result) {
            case AiTutorService.Answered answered -> ResponseEntity.ok(new TutorMessageResponse(
                    answered.conversationId(), answered.conversationSaved(), answered.answerHtml(), answered.truncated(),
                    answered.lessonContextUsed(), answered.turnsRemaining()));
            case AiTutorService.Refused refused -> error(refused.error(), language);
        };
    }

    @DeleteMapping(path = "/{lang:en|tr}/admin/ai-tutor/conversations/{id}",
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> delete(@PathVariable String lang, @PathVariable UUID id,
                                    Authentication authentication, HttpServletRequest httpRequest) {
        return service.deleteConversation(authentication, httpRequest.getSession(), id)
                .<ResponseEntity<?>>map(error -> error(error, Language.fromCode(lang)))
                .orElseGet(() -> ResponseEntity.noContent().build());
    }

    // Bozuk JSON, yanlış içerik türü ya da UUID olmayan bir id: ayrıntı (ayrıştırıcı mesajı) dönmez.
    @ExceptionHandler({HttpMessageNotReadableException.class, HttpMediaTypeNotSupportedException.class,
            MethodArgumentTypeMismatchException.class})
    public ResponseEntity<TutorErrorResponse> unreadable(HttpServletRequest httpRequest) {
        String path = httpRequest.getRequestURI();
        Language language = path.startsWith("/tr/") ? Language.TR : Language.EN;
        return error(ErrorCode.INVALID_REQUEST, language);
    }

    static HttpStatus statusFor(ErrorCode error) {
        return switch (error) {
            case INVALID_REQUEST -> HttpStatus.BAD_REQUEST;
            case NOT_AUTHENTICATED -> HttpStatus.UNAUTHORIZED;
            case FORBIDDEN -> HttpStatus.FORBIDDEN;
            case CONVERSATION_NOT_FOUND -> HttpStatus.NOT_FOUND;
            case CONTENT_FILTERED -> HttpStatus.UNPROCESSABLE_CONTENT;
            case RATE_LIMITED, BUDGET_EXHAUSTED -> HttpStatus.TOO_MANY_REQUESTS;
            case AI_UNAVAILABLE -> HttpStatus.BAD_GATEWAY;
            case AI_TIMEOUT -> HttpStatus.GATEWAY_TIMEOUT;
            case DISABLED, AI_BUSY, SERVICE_UNAVAILABLE -> HttpStatus.SERVICE_UNAVAILABLE;
        };
    }

    private ResponseEntity<TutorErrorResponse> error(ErrorCode error, Language language) {
        Locale locale = Locale.forLanguageTag(language.getCode());
        String message = messageSource.getMessage("aiTutor.error." + error.code(), null, locale);
        return ResponseEntity.status(statusFor(error))
                .contentType(MediaType.APPLICATION_JSON)
                .body(new TutorErrorResponse(error.code(), message));
    }
}
