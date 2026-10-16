package com.cdurgun.learning.service;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.DefaultResourceLoader;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Ders içine yazılacak iç bağlantıların {@link MarkdownService} çıktısında nasıl göründüğü.
 * Kurallar:
 * <ul>
 *   <li>Paragraftaki bir ders bağlantısı tek bir {@code <a href="/{lang}/topics/{slug}">} olur;
 *       Türkçe ek (ör. {@code 'te}) bağlantının dışında kalır.</li>
 *   <li>Tip/Warning callout'u içindeki bağlantı uyarı kutusuna dönüştükten sonra da korunur.</li>
 *   <li>Satır içi kod ve kod bloğu içindeki bağlantı söz dizimi bağlantıya dönüşmez.</li>
 *   <li>Bir bağlantı başka bir bağlantının içine girmez (çift bağlantı yok).</li>
 * </ul>
 */
class MarkdownInternalLinkRenderTest {

    private static final Pattern ANCHOR_OPEN = Pattern.compile("<a\\s");

    private final MarkdownService markdownService =
            new MarkdownService(new CodeExampleResolver(new DefaultResourceLoader()));

    private String render(String markdown) {
        return markdownService.render(markdown, "no-such-topic").html();
    }

    @Test
    void lessonLinkInEnglishParagraphRendersAsOneAnchor() {
        String html = render("Arrays connect to streams (see the [\"Stream API Fundamentals\"](/en/topics/stream-fundamentals) lesson).");

        assertThat(html).contains("<a href=\"/en/topics/stream-fundamentals\">&quot;Stream API Fundamentals&quot;</a> lesson)");
        assertThat(anchorCount(html)).isEqualTo(1);
    }

    @Test
    void lessonLinkInTurkishParagraphKeepsTheSuffixOutsideTheLink() {
        String html = render("Bu işlemler O(n)'dir (bkz. [\"Lists\"](/tr/topics/lists)'te anlatılan yapı).");

        assertThat(html).contains("<a href=\"/tr/topics/lists\">&quot;Lists&quot;</a>'te anlatılan yapı");
        assertThat(anchorCount(html)).isEqualTo(1);
    }

    @Test
    void linkInsideTipCalloutSurvivesTheAlertConversion() {
        String html = render("> 💡 Tip See the [\"String\"](/en/topics/string) lesson for the same trap.");

        assertThat(html).contains("<div class=\"alert alert-info\" role=\"alert\"><p class=\"mb-0\">See the "
                + "<a href=\"/en/topics/string\">&quot;String&quot;</a> lesson for the same trap.</p></div>");
        assertThat(html).doesNotContain("<blockquote>");
    }

    @Test
    void linkInsideTurkishWarningCalloutSurvivesTheAlertConversion() {
        String html = render("> ⚠️ Warning Ayrıntısı [\"Checked ve Unchecked Exception'lar\"](/tr/topics/checked-vs-unchecked-exceptions) dersinde.");

        assertThat(html).contains("<div class=\"alert alert-warning\" role=\"alert\"><p class=\"mb-0\">Ayrıntısı "
                + "<a href=\"/tr/topics/checked-vs-unchecked-exceptions\">&quot;Checked ve Unchecked Exception'lar&quot;</a>"
                + " dersinde.</p></div>");
        assertThat(html).doesNotContain("<blockquote>");
    }

    @Test
    void linkSyntaxInsideInlineCodeAndCodeBlocksStaysLiteral() {
        String html = render("""
                Inline: `[String](/en/topics/string)`

                ```java
                // [Lists](/tr/topics/lists)
                ```
                """);

        assertThat(anchorCount(html)).isZero();
        assertThat(html).contains("<code>[String](/en/topics/string)</code>");
        assertThat(html).contains("// [Lists](/tr/topics/lists)");
    }

    @Test
    void anExistingLinkIsNotWrappedInASecondLink() {
        // CommonMark bir bağlantının metni içinde ikinci bir bağlantıya izin vermez;
        // iç içe yazılmış olsa bile çıktıda iç içe <a> oluşmamalı.
        String html = render("Read [\"String\"](/en/topics/string) and [[\"Lists\"](/en/topics/lists)](/en/topics/arrays).");

        assertThat(hasNestedAnchor(html)).isFalse();
        assertThat(html).contains("<a href=\"/en/topics/string\">&quot;String&quot;</a>");
    }

    private static int anchorCount(String html) {
        Matcher matcher = ANCHOR_OPEN.matcher(html);
        int count = 0;
        while (matcher.find()) {
            count++;
        }
        return count;
    }

    /** Bir {@code <a>} kapanmadan ikinci bir {@code <a} açılıyor mu. */
    static boolean hasNestedAnchor(String html) {
        int depth = 0;
        Matcher matcher = Pattern.compile("<a\\s|</a>").matcher(html);
        while (matcher.find()) {
            if (matcher.group().startsWith("</")) {
                depth = Math.max(0, depth - 1);
            } else if (++depth > 1) {
                return true;
            }
        }
        return false;
    }
}
