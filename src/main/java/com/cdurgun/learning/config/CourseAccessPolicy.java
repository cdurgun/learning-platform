package com.cdurgun.learning.config;

import com.cdurgun.learning.repository.QuizDefinitionRepository;
import com.cdurgun.learning.repository.TopicRepository;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authorization.AuthorizationDecision;
import org.springframework.security.authorization.AuthorizationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.access.intercept.RequestAuthorizationContext;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.Optional;

/**
 * Course seviyesinde erişim kuralının TEK doğruluk kaynağı. Ders içeriği (konu
 * sayfası, PDF) TÜM kurslarda herkese açıktır ve bu sınıfa hiç sorulmaz; kural
 * yalnızca etkileşimli özellikleri (sabit quiz, Quiz Area, Practice) kapsar: anonim
 * bir kullanıcı yalnızca {@link #PUBLIC_COURSE_SLUG} kursununkilere (Java) erişebilir,
 * girişli bir kullanıcı tüm kurslarınkilere. "java herkese açık" bilgisi YALNIZCA
 * burada yaşar -- SecurityConfig (URL kuralları), TopicController (konu sayfasındaki
 * quiz), PracticeService (havuz kapsamı + submit kontrolü) ve QuizNavigationService
 * (menüde kilitli/açık durumu) bu sınıfa sorar, kuralı kendileri tekrar etmez.
 *
 * <p>Course, veritabanı id'siyle değil slug'ıyla tanınır (V2'den beri sabit,
 * unique). Bilinmeyen bir topic/quiz slug'ı burada REDDEDİLMEZ -- controller'ın
 * kendi 404'ü devreye girsin diye izin verilir (var olmayan içerik korunacak
 * içerik değil).</p>
 */
@Component
public class CourseAccessPolicy {

    private static final String PUBLIC_COURSE_SLUG = "java";

    private final TopicRepository topicRepository;
    private final QuizDefinitionRepository quizDefinitionRepository;

    public CourseAccessPolicy(TopicRepository topicRepository, QuizDefinitionRepository quizDefinitionRepository) {
        this.topicRepository = topicRepository;
        this.quizDefinitionRepository = quizDefinitionRepository;
    }

    public String publicCourseSlug() {
        return PUBLIC_COURSE_SLUG;
    }

    private boolean isPublicCourse(String courseSlug) {
        return PUBLIC_COURSE_SLUG.equals(courseSlug);
    }

    public boolean canAccess(String courseSlug, Authentication authentication) {
        return isPublicCourse(courseSlug) || isAuthenticated(authentication);
    }

    public boolean currentUserCanAccess(String courseSlug) {
        return canAccess(courseSlug, currentAuthentication());
    }

    /** Girişli kullanıcı her kursa erişebildiği için "tüm havuz" kapsamı yalnızca ona açık. */
    public boolean currentUserCanAccessAllCourses() {
        return isAuthenticated(currentAuthentication());
    }

    /**
     * Servis katmanı kontrolü (course'un URL'den değil istek gövdesinden/havuzdan
     * belirlendiği yerler). Fırlatılan {@link AccessDeniedException}, projede hiçbir
     * {@code @ExceptionHandler} olmadığı için Spring Security'nin
     * {@code ExceptionTranslationFilter}'ına ulaşır -- anonim kullanıcıda
     * SecurityConfig'teki entry point'e (JSON uç noktaları için 401) düşer.
     */
    public void checkCurrentUserCanAccess(Collection<String> courseSlugs) {
        for (String courseSlug : courseSlugs) {
            if (!currentUserCanAccess(courseSlug)) {
                throw new AccessDeniedException("Login required for course: " + courseSlug);
            }
        }
    }

    /** {@code /{lang}/topics/{slug}/quiz/**} -- sabit quiz submit. */
    public AuthorizationManager<RequestAuthorizationContext> topicQuizAccess() {
        return (authentication, context) -> decide(
                topicRepository.findBySlugWithCategoryAndCourse(context.getVariables().get("slug"))
                        .map(topic -> topic.getCategory().getCourse().getSlug()),
                authentication.get());
    }

    /** {@code /{lang}/quiz/{definitionSlug}[/**]} -- Quiz Area oynatma ve submit. */
    public AuthorizationManager<RequestAuthorizationContext> quizDefinitionAccess() {
        return (authentication, context) -> decide(
                quizDefinitionRepository.findActiveCourseSlugByDefinitionSlug(context.getVariables().get("definitionSlug")),
                authentication.get());
    }

    private AuthorizationDecision decide(Optional<String> courseSlug, Authentication authentication) {
        return new AuthorizationDecision(courseSlug.map(slug -> canAccess(slug, authentication)).orElse(true));
    }

    private static Authentication currentAuthentication() {
        return SecurityContextHolder.getContext().getAuthentication();
    }

    /** {@code GlobalModelAttributes#currentUserDisplayName} ile AYNI "girişli mi" tanımı. */
    private static boolean isAuthenticated(Authentication authentication) {
        return authentication != null
                && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)
                && !"anonymousUser".equals(authentication.getPrincipal());
    }
}
