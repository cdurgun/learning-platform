package com.cdurgun.learning.web;

import org.springframework.web.util.HtmlUtils;

import java.util.regex.Pattern;

/**
 * Konu özetini ({@code topic_translation.summary}) HTML'e çevirir. Özetler düz metindir,
 * yalnızca satır içi kod için ters tırnak ({@code `String`}) kullanır; tam bir Markdown
 * render'ı BİLİNÇLİ OLARAK kullanılmaz -- özetlerde {@code Predicate<T>}, {@code <<<<<<<},
 * {@code =======}, {@code *} gibi Markdown'ın biçim sanacağı metinler geçiyor.
 *
 * <p>Güvenlik sırası: önce TÜM metin HTML-escape edilir, sonra yalnızca eşleşen ters tırnak
 * çiftleri {@code <code>} etiketine çevrilir. Çıktıdaki tek HTML bu sınıfın kendi ürettiği
 * {@code <code>} etiketleridir; yakalanan grup zaten escape edilmiş olduğu için
 * {@code th:utext} ile basılması güvenlidir. Eşi olmayan bir ters tırnak olduğu gibi kalır.</p>
 */
public final class SummaryFormatter {

    private static final Pattern CODE_SPAN = Pattern.compile("`([^`\\n]+)`");

    private SummaryFormatter() {
    }

    public static String toHtml(String summary) {
        if (summary == null) {
            return "";
        }
        // UTF-8 varyantı yalnızca < > & " ' karakterlerini escape eder; tek argümanlı sürüm
        // "ü" gibi harfleri de &uuml;'ye çevirirdi.
        return CODE_SPAN.matcher(HtmlUtils.htmlEscape(summary, "UTF-8")).replaceAll("<code>$1</code>");
    }
}
