package com.cdurgun.learning.service;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.web.util.HtmlUtils;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Bir {@code .java} örneğinin yanındaki {@code .out} dosyasının "Beklenen Çıktı" paneline
 * dönüşmesi. Fixture'lar {@code src/test/resources/examples/expected-output-fixture/}
 * altında -- gerçek bir ders slug'ı değil, main'deki hiçbir içerikle çakışmaz.
 *
 * <p>Temel sözleşme: panelde gösterilen (ve kopyalanan) metin, {@code .out} dosyasının
 * içeriğiyle -- yani programın gerçek stdout'uyla -- birebir aynıdır; satır sonu boşlukları,
 * baştaki girintiler, tab'lar ve sondaki boş satırlar korunur. Tek istisna: son satır
 * sonlandırıcısı olmayan bir çıktıda, HTML'deki metin yine {@code \n} ile biter (CommonMark
 * kod bloğu içeriğini her zaman bir satır sonuyla kapatır; tarayıcıda görünür bir fark yok).</p>
 */
class MarkdownExpectedOutputRenderTest {

    private static final String SLUG = "expected-output-fixture";
    private static final String LABEL = "Expected Output";

    private static final Pattern SAMP = Pattern.compile("<samp>(.*?)</samp>", Pattern.DOTALL);
    private static final Pattern PANEL = Pattern.compile("\\n?<figure class=\"code-output\">.*?</figure>", Pattern.DOTALL);

    private final MarkdownService markdownService =
            new MarkdownService(new CodeExampleResolver(new DefaultResourceLoader()));

    private String render(String markdown) {
        return markdownService.render(markdown, SLUG, LABEL).html();
    }

    private static String fixture(String fileName) throws IOException {
        try (InputStream in = MarkdownExpectedOutputRenderTest.class
                .getResourceAsStream("/examples/" + SLUG + "/" + fileName)) {
            return new String(in.readAllBytes(), StandardCharsets.UTF_8);
        }
    }

    /** Panelde gösterilen metin, HTML escape'leri çözülmüş hâliyle. */
    private static String displayedOutput(String html) {
        Matcher matcher = SAMP.matcher(html);
        assertThat(matcher.find()).as("samp bloğu").isTrue();
        String text = HtmlUtils.htmlUnescape(matcher.group(1));
        assertThat(matcher.find()).as("tek bir samp bloğu").isFalse();
        return text;
    }

    @Test
    void outFileProducesAPanelRightAfterTheCodeBlock() {
        String html = render("Intro.\n\n{{MultiLine.java}}\n\nAfter.");

        assertThat(html).contains("</code></pre>\n<figure class=\"code-output\">"
                + "<figcaption class=\"code-output-label\">Expected Output</figcaption>"
                + "<pre class=\"code-output-body\"><samp>1 2 3 4 \n1 2 3 4 5 \n5050\n</samp></pre>"
                + "</figure>");
        assertThat(html.indexOf("<figure")).isGreaterThan(html.indexOf("<pre><code class=\"language-java\">"));
        assertThat(html.indexOf("<figure")).isLessThan(html.indexOf("<p>After.</p>"));
    }

    @Test
    void codeBlockHtmlIsUnchangedWhenAPanelIsAdded() {
        String markdown = "{{MultiLine.java}}\n\n{{Special.java}}\n\n{{NoOutputFile.java}}";

        String withoutOutputs = markdownService.render(markdown, SLUG).html();
        String withOutputs = render(markdown);

        assertThat(withOutputs).isNotEqualTo(withoutOutputs);
        assertThat(PANEL.matcher(withOutputs).replaceAll("")).isEqualTo(withoutOutputs);
    }

    @Test
    void withoutAnOutFileTheHtmlIsIdenticalToTheOldRendering() {
        String markdown = "## Section\n\n{{NoOutputFile.java}}\n\n> 💡 Tip Something.\n\n{{NoSuchExample.java}}";

        assertThat(render(markdown)).isEqualTo(markdownService.render(markdown, SLUG).html());
        assertThat(render(markdown)).doesNotContain("code-output");
    }

    @Test
    void twoArgumentRenderNeverLooksForOutFiles() {
        assertThat(markdownService.render("{{MultiLine.java}}", SLUG).html()).doesNotContain("code-output");
    }

    @Test
    void displayedTextEqualsTheRawStdoutIncludingTrailingSpaces() throws IOException {
        assertThat(displayedOutput(render("{{MultiLine.java}}"))).isEqualTo(fixture("MultiLine.out"));
    }

    @Test
    void specialCharactersFencesTabsAndIndentationArePreserved() throws IOException {
        String html = render("{{Special.java}}\n\nAfter.");

        assertThat(displayedOutput(html)).isEqualTo(fixture("Special.out"));
        // HTML'de ham hâliyle değil, escape'lenmiş olarak durur.
        assertThat(html).contains("List&lt;String&gt; &amp; &quot;q&quot;");
        // Çıktıdaki ``` / ```` satırları bloğu erken kapatmadı: "After." panelin dışında, tek paragraf.
        assertThat(html).containsOnlyOnce("<p>After.</p>");
        assertThat(html.indexOf("<p>After.</p>")).isGreaterThan(html.indexOf("</figure>"));
    }

    @Test
    void aTrailingBlankLineInTheOutputIsKept() throws IOException {
        String stdout = fixture("TrailingBlankLine.out");
        assertThat(stdout).isEqualTo("a\n\n");

        assertThat(displayedOutput(render("{{TrailingBlankLine.java}}"))).isEqualTo(stdout);
    }

    @Test
    void outputWithoutAFinalNewlineIsShownWithTheSameLines() throws IOException {
        String stdout = fixture("NoFinalNewline.out");
        assertThat(stdout).isEqualTo("no final newline");

        assertThat(displayedOutput(render("{{NoFinalNewline.java}}"))).isEqualTo(stdout + "\n");
    }

    @Test
    void emptyOutFileProducesNoPanel() {
        assertThat(render("{{EmptyOutput.java}}")).doesNotContain("code-output");
    }

    @Test
    void onlyJavaExamplesGetAPanel() {
        assertThat(render("{{JsxOnly.jsx}}")).contains("language-jsx").doesNotContain("code-output");
    }

    @Test
    void anOutFileWithoutItsJavaSourceProducesNoPanel() {
        String html = render("{{Orphan.java}}");

        assertThat(html).contains("// Örnek bulunamadı: Orphan.java").doesNotContain("code-output");
    }

    @Test
    void placeholdersWithPathCharactersAreNotResolved() {
        String html = render("{{../expected-output-fixture/MultiLine.java}} {{MultiLine.out}}x");

        assertThat(html).doesNotContain("<samp>").doesNotContain("code-output");
    }

    @Test
    void eachExampleGetsItsOwnOutput() {
        String html = render("{{MultiLine.java}}\n\n{{NoOutputFile.java}}\n\n{{TrailingBlankLine.java}}");

        Matcher matcher = SAMP.matcher(html);
        assertThat(matcher.find()).isTrue();
        assertThat(matcher.group(1)).startsWith("1 2 3 4 ");
        assertThat(matcher.find()).isTrue();
        assertThat(matcher.group(1)).isEqualTo("a\n\n");
        assertThat(matcher.find()).isFalse();
    }

    @Test
    void turkishLabelIsWrittenAsIsNotAsEntities() {
        String html = markdownService.render("{{MultiLine.java}}", SLUG, "Beklenen Çıktı").html();

        assertThat(html).contains("<figcaption class=\"code-output-label\">Beklenen Çıktı</figcaption>");
    }

    @Test
    void outputPanelIsNotACodeElementSoHighlightJsSkipsIt() {
        String html = render("{{MultiLine.java}}");
        String panel = html.substring(html.indexOf("<figure"));

        assertThat(panel).doesNotContain("<code").doesNotContain("hljs");
    }

    @Test
    void tableOfContentsIsNotAffected() {
        String markdown = "## First\n\n{{MultiLine.java}}\n\n## Second";

        assertThat(markdownService.render(markdown, SLUG, LABEL).toc())
                .isEqualTo(markdownService.render(markdown, SLUG).toc());
    }
}
