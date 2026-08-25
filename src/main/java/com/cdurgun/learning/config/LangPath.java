package com.cdurgun.learning.config;

import com.cdurgun.learning.domain.Language;

/**
 * Bir istek URI'sinin ilk path segmentinden dil kodunu okur, geçersiz/eksikse
 * İngilizce'ye düşer. {@link LangParamLocaleResolver#resolveLocale} ile aynı
 * mantık, ama o class'ın {@code private} yardımcı metodu üzerinden paylaşılamadığı
 * için burada küçük, bağımsız bir yardımcı olarak tekrarlandı — auth handler'ları
 * (bkz. {@code SecurityConfig}) login/logout sonrası hangi dile yönlendireceğini
 * bulmak için bunu kullanır.
 */
final class LangPath {

    private LangPath() {
    }

    static String extractLangOrDefault(String requestUri) {
        String withoutLeadingSlash = requestUri.startsWith("/") ? requestUri.substring(1) : requestUri;
        int nextSlash = withoutLeadingSlash.indexOf('/');
        String firstSegment = nextSlash == -1 ? withoutLeadingSlash : withoutLeadingSlash.substring(0, nextSlash);

        try {
            return Language.fromCode(firstSegment).getCode();
        } catch (IllegalArgumentException e) {
            return Language.EN.getCode();
        }
    }
}
