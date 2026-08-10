package com.cdurgun.learning.config;

import com.cdurgun.learning.domain.Language;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.LocaleResolver;

import java.util.Locale;

/**
 * Locale'i, uygulamanın zaten sayfa sayfa taşıdığı {@code ?lang=tr|en} request
 * parametresinden çözer. Bilerek stateless: cookie/session'da hiçbir şey saklamıyoruz,
 * her istekte parametreden yeniden hesaplıyoruz — {@link Language#fromCode} ile aynı
 * kaynağı (tr/en) kullanarak iki farklı "dil kavramının" birbirinden sapmasını önlüyoruz.
 */
public class LangParamLocaleResolver implements LocaleResolver {

    private static final Locale DEFAULT_LOCALE = Locale.forLanguageTag("en");

    @Override
    public Locale resolveLocale(HttpServletRequest request) {
        try {
            return Locale.forLanguageTag(Language.fromCode(request.getParameter("lang")).getCode());
        } catch (IllegalArgumentException e) {
            return DEFAULT_LOCALE;
        }
    }

    @Override
    public void setLocale(HttpServletRequest request, HttpServletResponse response, Locale locale) {
        // Kasıtlı olarak no-op: locale her istekte `lang` parametresinden yeniden
        // hesaplanıyor, sunucu tarafında (cookie/session) hiçbir şey saklanmıyor.
    }
}
