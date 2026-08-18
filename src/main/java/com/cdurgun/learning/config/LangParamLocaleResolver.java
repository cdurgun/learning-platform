package com.cdurgun.learning.config;

import com.cdurgun.learning.domain.Language;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.LocaleResolver;

import java.util.Locale;

/**
 * Locale'i öncelikle URL path'inin ilk segmentinden ({@code /en/...}, {@code /tr/...})
 * çözer -- Faz 64'te query parametresinden path-bazlı URL yapısına geçildi (bkz.
 * "Mimari" notu, SEO gerekçesiyle: her dilin kendi indexlenebilir URL'si olması ve
 * {@code hreflang} ile bağlanabilmesi için). Eski {@code ?lang=} parametresi hâlâ
 * ikinci bir kaynak olarak destekleniyor -- yalnızca path segmenti bir dil kodu
 * DEĞİLSE devreye girer (statik kaynaklar, kök `/` gibi dil öneki taşımayan yollar,
 * ve legacy redirect controller'larının kendi işleyişi için). Bilerek stateless:
 * cookie/session'da hiçbir şey saklamıyoruz, her istekte URI/parametreden yeniden
 * hesaplıyoruz.
 */
public class LangParamLocaleResolver implements LocaleResolver {

    private static final Locale DEFAULT_LOCALE = Locale.forLanguageTag("en");

    @Override
    public Locale resolveLocale(HttpServletRequest request) {
        Locale fromPath = tryResolve(firstPathSegment(request.getRequestURI()));
        if (fromPath != null) {
            return fromPath;
        }

        Locale fromParam = tryResolve(request.getParameter("lang"));
        if (fromParam != null) {
            return fromParam;
        }

        return DEFAULT_LOCALE;
    }

    @Override
    public void setLocale(HttpServletRequest request, HttpServletResponse response, Locale locale) {
        // Kasıtlı olarak no-op: locale her istekte URI/parametreden yeniden hesaplanıyor,
        // sunucu tarafında (cookie/session) hiçbir şey saklanmıyor.
    }

    private static String firstPathSegment(String uri) {
        String withoutLeadingSlash = uri.startsWith("/") ? uri.substring(1) : uri;
        int nextSlash = withoutLeadingSlash.indexOf('/');
        return nextSlash == -1 ? withoutLeadingSlash : withoutLeadingSlash.substring(0, nextSlash);
    }

    private static Locale tryResolve(String code) {
        try {
            return Locale.forLanguageTag(Language.fromCode(code).getCode());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
