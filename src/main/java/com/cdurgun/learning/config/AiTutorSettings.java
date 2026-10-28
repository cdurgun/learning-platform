package com.cdurgun.learning.config;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.ValidatorFactory;
import org.hibernate.validator.HibernateValidator;
import org.springframework.boot.context.properties.bind.BindException;
import org.springframework.boot.context.properties.bind.BindResult;
import org.springframework.boot.context.properties.bind.Bindable;
import org.springframework.boot.context.properties.bind.Binder;
import org.springframework.core.env.Environment;

import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.Set;
import java.util.TreeSet;

/**
 * {@code ai.tutor.*} yapılandırmasının yüklenmiş hâli: ya geçerli bir {@link AiTutorProperties},
 * ya da hiç properties taşımayan, KALICI olarak kapalı bir durum ve neden geçersiz olduğu.
 *
 * <p>Yalnızca {@code ai.tutor} öneki bağlanır; yakalanan tek hata Spring Boot'un o öneke ait
 * {@link BindException}'ı (tür dönüşümü); kısıt ihlalleri ayrıca toplanır. Uygulamanın başka
 * hiçbir yapılandırması ve Spring Boot'un genel doğrulaması etkilenmez; beklenmeyen başka her
 * hata yukarı fırlar.</p>
 *
 * <p>{@link #problems()} hiçbir zaman reddedilen DEĞERİ içermez -- yalnızca özellik adı ve
 * kısıt mesajı. Böylece yanlış yere yazılmış bir anahtar ya da URL loglara sızmaz.</p>
 */
public final class AiTutorSettings {

    static final String PREFIX = "ai.tutor";

    private final AiTutorProperties properties;
    private final List<String> problems;

    private AiTutorSettings(AiTutorProperties properties, List<String> problems) {
        this.properties = properties;
        this.problems = List.copyOf(problems);
    }

    /**
     * İki adım: önce yalnızca bağlama (tür dönüşümü), sonra kaydın TAMAMI tek seferde doğrulanır.
     * Boot'un {@code ValidationBindHandler}'ı ilk hatalı iç nesnede durduğu için kullanılmıyor --
     * birden fazla yanlış ayar varsa hepsi birlikte raporlanmalı. Mesajlar, JVM dilinden bağımsız
     * olarak İngilizce üretilir.
     */
    public static AiTutorSettings load(Environment environment) {
        BindResult<AiTutorProperties> result;
        try {
            result = Binder.get(environment).bind(PREFIX, Bindable.of(AiTutorProperties.class));
        } catch (BindException e) {
            // Tür dönüşümü vb.: değer bilinçli olarak YAZILMAZ, yalnızca hangi özellik olduğu.
            String cause = e.getCause() == null ? "unknown" : e.getCause().getClass().getSimpleName();
            return invalid(List.of(e.getName() + ": invalid value (" + cause + ")"));
        }
        if (!result.isBound()) {
            return invalid(List.of(PREFIX + ": not configured"));
        }

        AiTutorProperties properties = result.get();
        Set<String> problems = new TreeSet<>();
        try (ValidatorFactory factory = Validation.byProvider(HibernateValidator.class)
                .configure()
                .defaultLocale(Locale.ENGLISH)
                .buildValidatorFactory()) {
            for (ConstraintViolation<AiTutorProperties> violation : factory.getValidator().validate(properties)) {
                problems.add(propertyName(violation) + ": " + violation.getMessage());
            }
        }
        return problems.isEmpty() ? new AiTutorSettings(properties, List.of()) : invalid(List.copyOf(problems));
    }

    /** {@code limits.maxOutputTokens} -> {@code ai.tutor.limits.max-output-tokens}. */
    private static String propertyName(ConstraintViolation<?> violation) {
        String path = violation.getPropertyPath().toString()
                .replaceAll("([a-z0-9])([A-Z])", "$1-$2")
                .toLowerCase(Locale.ROOT);
        return path.isEmpty() ? PREFIX : PREFIX + "." + path;
    }

    private static AiTutorSettings invalid(List<String> problems) {
        return new AiTutorSettings(null, problems);
    }

    /** Yalnızca yapılandırma geçerliyse dolu. */
    public Optional<AiTutorProperties> properties() {
        return Optional.ofNullable(properties);
    }

    public boolean isValid() {
        return properties != null;
    }

    /** Geçerli yapılandırma + bayrak açık + anahtar var. Geçersiz yapılandırma ASLA kullanılabilir değildir. */
    public boolean isUsable() {
        return properties != null && properties.isUsable();
    }

    public List<String> problems() {
        return problems;
    }
}
