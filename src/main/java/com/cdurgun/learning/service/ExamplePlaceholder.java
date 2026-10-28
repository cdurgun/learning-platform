package com.cdurgun.learning.service;

import java.util.regex.Pattern;

/**
 * Ders markdown'ındaki {@code {{Ad.uzanti}}} örnek yer tutucusunun TEK tanımı. Hem sayfa
 * render'ı ({@link MarkdownService}) hem AI Tutor'un ders bağlamı
 * ({@code service.ai.LessonContextBuilder}) bunu kullanır; böylece iki taraf hangi metnin bir
 * örnek gömmesi olduğu konusunda hiçbir zaman ayrışmaz.
 *
 * <p>Grup 1 dosyanın taban adı ({@code \w+}), grup 2 uzantısıdır; uzantı hem dosya yolunu
 * ({@link CodeExampleResolver}) hem fenced code block'un dil etiketini belirler. Desen,
 * {@link MarkdownService}'te Faz 27'den beri duran literal ile birebir aynıdır.</p>
 */
public final class ExamplePlaceholder {

    public static final Pattern PATTERN = Pattern.compile("\\{\\{(\\w+)\\.(\\w+)}}");

    public static final int NAME_GROUP = 1;

    public static final int EXTENSION_GROUP = 2;

    private ExamplePlaceholder() {
    }
}
