package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.service.CodeExampleResolver;
import com.cdurgun.learning.service.MarkdownService;
import com.cdurgun.learning.service.ai.TutorAnswerRenderer.RenderedAnswer;
import com.cdurgun.learning.service.ai.TutorAnswerRenderer.Status;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Attribute;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.boot.test.system.CapturedOutput;
import org.springframework.boot.test.system.OutputCaptureExtension;
import org.springframework.core.io.DefaultResourceLoader;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * {@link TutorAnswerRenderer}: markdown korunur, model çıktısındaki HTML/JavaScript hiçbir yoldan
 * çalıştırılabilir hâle gelmez. Her çıktı {@link #safe} ile yapısal olarak denetlenir: jsoup'un
 * kendi Safelist doğrulaması, hiçbir {@code on*} özniteliği ve izin listesinin dışında hiçbir href.
 */
@ExtendWith(OutputCaptureExtension.class)
class TutorAnswerRendererTest {

    private final TutorAnswerRenderer renderer = new TutorAnswerRenderer();

    /** Render eder, sonucun RENDERED ve yapısal olarak güvenli olduğunu doğrular. */
    private Document rendered(String markdown) {
        RenderedAnswer answer = renderer.render(markdown);
        assertThat(answer.status()).isEqualTo(Status.RENDERED);
        return safe(answer.html());
    }

    private static Document safe(String html) {
        assertThat(Jsoup.isValid(html, TutorAnswerRenderer.SAFELIST)).as(html).isTrue();
        Document document = Jsoup.parseBodyFragment(html);
        for (Element element : document.body().getAllElements()) {
            for (Attribute attribute : element.attributes()) {
                assertThat(attribute.getKey().toLowerCase()).as(html).doesNotStartWith("on");
            }
        }
        for (Element link : document.select("a")) {
            assertThat(TutorAnswerRenderer.isAllowedHref(link.attr("href"))).as(html).isTrue();
            assertThat(link.attr("rel")).isEqualTo(TutorAnswerRenderer.LINK_REL);
        }
        assertThat(document.select("script, style, iframe, object, embed, img, svg, math, form, input, link, meta, base"))
                .as(html).isEmpty();
        return document;
    }

    // --- markdown korunur ---

    @Test
    void headingsParagraphsAndEmphasisAreKept() {
        String markdown = "# Title\n\n## Section\n\n###### Deep\n\nA **bold** and *italic* word.\n";
        rendered(markdown);

        assertThat(renderer.render(markdown).html()).isEqualTo(
                "<h3>Title</h3>\n<h4>Section</h4>\n<h6>Deep</h6>\n<p>A <strong>bold</strong> and <em>italic</em> word.</p>\n");
    }

    @Test
    void listsAndQuotesAreKept() {
        Document html = rendered("- one\n- two\n\n3. three\n4. four\n\n> quoted\n");

        assertThat(html.select("ul > li")).extracting(Element::text).containsExactly("one", "two");
        assertThat(html.select("ol").attr("start")).isEqualTo("3");
        assertThat(html.select("ol > li")).extracting(Element::text).containsExactly("three", "four");
        assertThat(html.select("blockquote p").text()).isEqualTo("quoted");
    }

    @Test
    void inlineCodeAndCodeBlocksStayText() {
        String code = "List<String> names = List.of(\"<b>x</b>\");\nif (a < b && c > d) { }";
        Document html = rendered("Use `Map<K, V>` here.\n\n```java\n" + code + "\n```\n");

        assertThat(html.select("p > code").text()).isEqualTo("Map<K, V>");
        Element block = html.selectFirst("pre > code");
        assertThat(block.className()).isEqualTo("language-java");
        assertThat(block.wholeText()).isEqualTo(code + "\n");
        assertThat(html.select("b")).isEmpty();
        assertThat(html.body().html()).contains("List&lt;String&gt;", "&lt;b&gt;x&lt;/b&gt;");
    }

    @Test
    void htmlExamplesInsideCodeBlocksAreShownNotRun() {
        String example = "<script>alert(1)</script>\n<img src=x onerror=alert(2)>\n<a href=\"javascript:x()\">x</a>";
        Document html = rendered("```html\n" + example + "\n```");

        assertThat(html.selectFirst("pre > code").wholeText()).isEqualTo(example + "\n");
        assertThat(html.select("a")).isEmpty();
    }

    @Test
    void anUnsafeCodeLanguageClassIsDropped() {
        Document html = rendered("```java\" onmouseover=\"alert(1)\nint x;\n```");

        Element code = html.selectFirst("pre > code");
        assertThat(code.hasAttr("class")).isFalse();
        assertThat(code.wholeText()).isEqualTo("int x;\n");
    }

    @Test
    void lessonPlaceholdersInModelOutputAreNotExpanded() {
        assertThat(rendered("See {{SecretExample.java}}.").text()).isEqualTo("See {{SecretExample.java}}.");
    }

    // --- tablolar (GFM) ---

    @Test
    void aMarkdownTableBecomesAnHtmlTable() {
        Document html = rendered("""
                Özet:

                | Karşılaştırma | Neyi karşılaştırır? | String'ler için güvenli mi? |
                |---|---|---|
                | `==` | Nesne kimliği (adres) | ❌ Hayır (pool tesadüfüne bağlı) |
                | `equals()` | İçerik | ✅ Evet |
                | `equalsIgnoreCase()` | İçerik (harf duyarsız) | ✅ Evet |
                """);

        assertThat(html.select("table")).hasSize(1);
        assertThat(html.select("table > thead > tr > th")).extracting(Element::text)
                .containsExactly("Karşılaştırma", "Neyi karşılaştırır?", "String'ler için güvenli mi?");
        assertThat(html.select("table > tbody > tr")).hasSize(3);
        assertThat(html.select("table > tbody > tr:eq(1) > td")).extracting(Element::text)
                .containsExactly("equals()", "İçerik", "✅ Evet");
        assertThat(html.text()).doesNotContain("|", "---");
    }

    @Test
    void inlineCodeInATableCellIsKept() {
        Document html = rendered("| Operator | Meaning |\n|---|---|\n| `==` | identity |\n| `a < b` | less |\n");

        assertThat(html.select("td > code")).extracting(Element::text).containsExactly("==", "a < b");
        assertThat(html.select("td > code")).allSatisfy(code -> assertThat(code.children()).isEmpty());
        assertThat(html.body().html()).contains("<td><code>==</code></td>", "<td><code>a &lt; b</code></td>");
    }

    @Test
    void htmlInTableCellsStaysText() {
        Document html = rendered("""
                | A | B | C |
                |---|---|---|
                | <script>alert(1)</script> | <img src=x onerror=alert(2)> | <a href="javascript:x()" onclick="y()">z</a> |
                """);

        assertThat(html.select("td")).hasSize(3);
        assertThat(html.select("td").get(0).text()).isEqualTo("<script>alert(1)</script>");
        assertThat(html.select("td").get(1).text()).isEqualTo("<img src=x onerror=alert(2)>");
        assertThat(html.select("a")).isEmpty();
    }

    @Test
    void tableAlignmentIsAcceptedButCarriesNoAttributes() {
        Document html = rendered("| Left | Center | Right |\n|:---|:---:|---:|\n| 1 | 2 | 3 |\n");

        assertThat(html.select("th")).hasSize(3);
        assertThat(html.select("td")).extracting(Element::text).containsExactly("1", "2", "3");
        assertThat(html.select("table, thead, tbody, tr, th, td"))
                .allSatisfy(element -> assertThat(element.attributes().size()).as(element.outerHtml()).isZero());
    }

    @Test
    void attributesOnAnUntrustedTableAreRemoved() {
        TutorAnswerRenderer leaky = new TutorAnswerRenderer(markdown ->
                "<table onclick=\"x()\" style=\"position:fixed\" class=\"table\"><thead><tr onmouseover=\"y()\">"
                        + "<th align=\"left\" style=\"color:red\">A</th></tr></thead><tbody><tr>"
                        + "<td class=\"z\" onclick=\"z()\" colspan=\"9\">B <img src=x onerror=w()></td></tr></tbody></table>");

        RenderedAnswer result = leaky.render("anything");

        assertThat(result.status()).isEqualTo(Status.RENDERED);
        safe(result.html());
        assertThat(result.html()).isEqualTo(
                "<table><thead><tr><th>A</th></tr></thead><tbody><tr><td>B </td></tr></tbody></table>");
    }

    @Test
    void tableLikeTextInACodeBlockStaysCode() {
        String code = "| a | b |\n|---|---|\n| 1 | 2 |\n";
        Document html = rendered("```text\n" + code + "```\n");

        assertThat(html.select("table")).isEmpty();
        assertThat(html.selectFirst("pre > code").wholeText()).isEqualTo(code);
    }

    @Test
    void pipesWithoutADelimiterRowAreNotATable() {
        Document html = rendered("| a | b |\n| 1 | 2 |\n\nx | y\n");

        assertThat(html.select("table")).isEmpty();
        assertThat(html.select("p").first().text()).isEqualTo("| a | b | | 1 | 2 |");
    }

    @Test
    void aTableInsideAListItemIsRendered() {
        Document html = rendered("- Compare:\n\n  | a | b |\n  |---|---|\n  | 1 | 2 |\n- next\n");

        assertThat(html.select("ul > li > table > tbody > tr > td")).extracting(Element::text).containsExactly("1", "2");
        assertThat(html.select("ul > li")).hasSize(2);
    }

    // --- sınırlar ---

    /**
     * Sunucunun {@link TutorAnswerRenderer#SAFELIST}'i ile {@code ai-tutor.js}'in {@code ALLOWED}'ı aynı
     * kalmalı: JS'de eksik bir etiket, sunucunun doğru ürettiği HTML'i tarayıcıda düz metne çevirir;
     * JS'de fazlası, sunucunun atacağı bir şeye istemcide izin verir. Safelist izinleri listelemediği
     * için iki yön de geniş bir aday kümesi üzerinden denetlenir.
     */
    @Test
    void theBrowserAllowlistMatchesTheServerSafelist() throws IOException {
        Map<String, Set<String>> js = browserAllowlist();
        assertThat(js).containsKeys("table", "thead", "tbody", "tr", "th", "td");

        Set<String> candidateTags = new TreeSet<>(js.keySet());
        candidateTags.addAll(List.of("h1", "h2", "div", "span", "img", "caption", "colgroup", "col", "tfoot",
                "b", "i", "u", "s", "del", "sup", "sub", "dl", "dt", "dd", "abbr", "cite", "q", "small",
                "script", "style", "iframe", "svg", "math", "form", "input", "button", "video", "audio", "source"));
        List<String> candidateAttributes = List.of("class", "id", "style", "title", "href", "rel", "start",
                "src", "align", "valign", "width", "colspan", "rowspan", "scope", "target", "onclick", "lang", "dir");

        for (String tag : candidateTags) {
            assertThat(TutorAnswerRenderer.SAFELIST.isSafeTag(tag)).as("tag <%s>", tag).isEqualTo(js.containsKey(tag));
            for (String attribute : candidateAttributes) {
                boolean server = js.containsKey(tag) && TutorAnswerRenderer.SAFELIST
                        .isSafeAttribute(tag, new Element(tag), new Attribute(attribute, "x"));
                boolean browser = js.containsKey(tag) && js.get(tag).contains(attribute);
                assertThat(server).as("<%s %s>", tag, attribute).isEqualTo(browser);
            }
        }
    }

    /** {@code var ALLOWED = { P: [], A: ['href', 'rel'], ... };} -> {@code {p=[], a=[href, rel], ...}}. */
    private static Map<String, Set<String>> browserAllowlist() throws IOException {
        String source;
        try (InputStream in = TutorAnswerRendererTest.class.getResourceAsStream("/static/js/ai-tutor.js")) {
            assertThat(in).as("static/js/ai-tutor.js on the classpath").isNotNull();
            source = new String(in.readAllBytes(), StandardCharsets.UTF_8);
        }
        Matcher block = Pattern.compile("var ALLOWED = \\{(.*?)\\};", Pattern.DOTALL).matcher(source);
        assertThat(block.find()).as("ALLOWED in ai-tutor.js").isTrue();

        Map<String, Set<String>> allowed = new TreeMap<>();
        Matcher entry = Pattern.compile("([A-Z0-9]+)\\s*:\\s*\\[([^\\]]*)\\]").matcher(block.group(1));
        while (entry.find()) {
            Set<String> attributes = new TreeSet<>();
            Matcher attribute = Pattern.compile("'([a-z]+)'").matcher(entry.group(2));
            while (attribute.find()) {
                attributes.add(attribute.group(1));
            }
            allowed.put(entry.group(1).toLowerCase(Locale.ROOT), attributes);
        }
        return allowed;
    }

    /** Tablo eklentisi yalnızca AI Tutor'a eklendi; ders sayfalarının markdown'ı tablo üretmez. */
    @Test
    void lessonMarkdownStillRendersNoTables() {
        MarkdownService lessons = new MarkdownService(new CodeExampleResolver(new DefaultResourceLoader()));

        String html = lessons.render("| a | b |\n|---|---|\n| 1 | 2 |\n", "no-such-topic").html();

        assertThat(html).doesNotContain("<table").contains("| a | b |");
    }

    // --- ham HTML çalışamaz ---

    @Test
    void scriptTagsBecomeVisibleText() {
        Document html = rendered("Hello <script>alert(document.cookie)</script> world\n\n<script>\nalert(1)\n</script>");

        assertThat(html.text()).contains("<script>alert(document.cookie)</script>", "alert(1)");
    }

    @ParameterizedTest
    @ValueSource(strings = {
            "<div onclick=\"steal()\">click</div>",
            "<p onmouseover=alert(1)>hover</p>",
            "<img src=x onerror=alert(1)>",
            "<svg onload=alert(1)>",
            "<a href=\"https://example.com\" onclick=\"x()\">link</a>",
            "<iframe src=\"https://evil.example\"></iframe>",
            "<style>body{display:none}</style>",
            "<form action=\"https://evil.example\"><input name=p></form>",
            "<meta http-equiv=\"refresh\" content=\"0;url=https://evil.example\">",
            "**bold <span style=\"color:red\" onclick=x()>span</span>**"})
    void rawHtmlAndEventHandlersAreEscaped(String markdown) {
        Document html = rendered(markdown);

        assertThat(html.select("div, span, iframe, form, input, meta, img, svg, style")).isEmpty();
        assertThat(html.text()).contains("<"); // görünür metin olarak kaldı
    }

    @Test
    void htmlLookingAndBrokenMarkupIsText() {
        Document html = rendered("a < b && c > d\n\n<b>unclosed\n\n</p></div><!-- comment -->\n\n&lt;already escaped&gt;");

        assertThat(html.text()).contains("a < b && c > d", "<b>unclosed", "</p></div><!-- comment -->",
                "<already escaped>");
        assertThat(html.select("b")).isEmpty();
    }

    // --- bağlantılar ---

    @Test
    void httpsAndHttpLinksAreKeptWithRel() {
        Document html = rendered("[docs](https://docs.oracle.com/javase/21/) and [old](http://example.com/a?b=1&c=2) "
                + "and <https://spring.io>");

        assertThat(html.select("a")).extracting(a -> a.attr("href")).containsExactly(
                "https://docs.oracle.com/javase/21/", "http://example.com/a?b=1&c=2", "https://spring.io");
    }

    @Test
    void sameSiteLinksAreKept() {
        Document html = rendered("[lesson](/en/topics/enum) and [here](#summary)");

        assertThat(html.select("a")).extracting(a -> a.attr("href")).containsExactly("/en/topics/enum", "#summary");
    }

    @ParameterizedTest
    @ValueSource(strings = {
            "[x](javascript:alert(1))",
            "[x](JaVaScRiPt:alert(1))",
            "[x](jav&#x61;script:alert(1))",
            "[x](&#106;avascript:alert(1))",
            "<javascript:alert(1)>",
            "[x](<java\tscript:alert(1)>)",
            "[x](java%09script:alert(1))",
            "[x](vbscript:msgbox(1))",
            "[x](data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg==)",
            "[x](DATA:image/png;base64,AAAA)",
            "[x](mailto:someone@example.com)",
            "[x](file:///etc/passwd)",
            "[x](//evil.example/path)",
            "[x](/\\evil.example)",
            "[x](https:///evil.example)",
            "[x](relative/path.html)",
            "[x](ftp://example.com/file)"})
    void unsafeOrUnexpectedLinksLoseTheirLinkButKeepTheText(String markdown) {
        Document html = rendered(markdown);

        // Görünür metin kalabilir (ör. "<javascript:alert(1)>" düz metin olur); bağlantı kalmaz.
        assertThat(html.select("a, [href], [src]")).isEmpty();
        assertThat(renderer.render(markdown).html().toLowerCase()).doesNotContain("href");
    }

    @Test
    void imagesBecomeLinksSoNothingLoadsByItself() {
        Document html = rendered("![diagram](https://example.com/d.png) ![bad](javascript:alert(1)) "
                + "![pixel](data:image/gif;base64,R0lGODlhAQABAAAAACw=)");

        assertThat(html.select("img")).isEmpty();
        assertThat(html.select("a")).extracting(Element::text, a -> a.attr("href"))
                .containsExactly(org.assertj.core.groups.Tuple.tuple("diagram", "https://example.com/d.png"));
        assertThat(html.text()).contains("diagram", "bad", "pixel");
    }

    @Test
    void hrefRules() {
        assertThat(TutorAnswerRenderer.isAllowedHref("https://a.example/x")).isTrue();
        assertThat(TutorAnswerRenderer.isAllowedHref("HTTPS://A.EXAMPLE")).isTrue();
        assertThat(TutorAnswerRenderer.isAllowedHref("/")).isTrue();
        assertThat(TutorAnswerRenderer.isAllowedHref("#x")).isTrue();
        for (String bad : new String[]{null, "", " https://a", "https://a b", "https://a​b", "https://a ",
                "java\nscript:x", "//a", "/\\a", "https:/a", "https:", "mailto:a@b", "x.html", "?q=1"}) {
            assertThat(TutorAnswerRenderer.isAllowedHref(bad)).as(String.valueOf(bad)).isFalse();
        }
    }

    // --- boş, uzun, hata ---

    @Test
    void nullOrBlankAnswersAreEmpty() {
        for (String blank : new String[]{null, "", "   ", "\n\t\n"}) {
            assertThat(renderer.render(blank)).isEqualTo(new RenderedAnswer(Status.EMPTY, ""));
        }
    }

    @Test
    void anAnswerAtTheLimitIsRendered() {
        String answer = "x".repeat(TutorAnswerRenderer.MAX_MARKDOWN_CHARS);
        assertThat(renderer.render(answer).status()).isEqualTo(Status.RENDERED);
    }

    @Test
    void anOverlongAnswerIsKeptWhollyAsEscapedText() {
        String answer = "<script>alert(1)</script>**" + "y".repeat(TutorAnswerRenderer.MAX_MARKDOWN_CHARS);

        RenderedAnswer result = renderer.render(answer);

        assertThat(result.status()).isEqualTo(Status.PLAIN_TEXT_TOO_LONG);
        Document html = safe(result.html());
        assertThat(html.selectFirst("pre").wholeText()).isEqualTo(answer); // hiçbir karakter kaybolmadı
        assertThat(html.select("strong")).isEmpty();
    }

    @Test
    void aRenderFailureNeverReturnsTheRawAnswerAsHtml(CapturedOutput output) {
        TutorAnswerRenderer failing = new TutorAnswerRenderer(markdown -> {
            throw new IllegalStateException("parser broke on " + markdown);
        });
        String answer = "SECRET-ANSWER <script>alert(1)</script> <b>x</b>";

        RenderedAnswer result = failing.render(answer);

        assertThat(result.status()).isEqualTo(Status.PLAIN_TEXT_AFTER_ERROR);
        Document html = safe(result.html());
        assertThat(html.selectFirst("pre").wholeText()).isEqualTo(answer);
        assertThat(html.select("b")).isEmpty();
        assertThat(output).contains("could not be rendered (IllegalStateException)")
                .doesNotContain("SECRET-ANSWER").doesNotContain("parser broke");
    }

    @Test
    void evenUnsafeOutputFromTheMarkdownStageIsCleaned() {
        // CommonMark'ta bir hata olsa bile jsoup katmanı yakalar.
        TutorAnswerRenderer leaky = new TutorAnswerRenderer(markdown ->
                "<h1 onclick=x()>T</h1><script>alert(1)</script><p style=\"x\">ok <a href=\"javascript:x()\">j</a> "
                        + "<a href=\"https://ok.example\" target=\"_top\">k</a><img src=x onerror=y()></p>"
                        + "<pre><code class=\"language-java x\">int a;</code></pre>");

        RenderedAnswer result = leaky.render("anything");

        assertThat(result.status()).isEqualTo(Status.RENDERED);
        safe(result.html());
        assertThat(result.html()).isEqualTo("<h3>T</h3><p>ok j <a href=\"https://ok.example\" rel=\""
                + TutorAnswerRenderer.LINK_REL + "\">k</a></p><pre><code>int a;</code></pre>");
    }

    @Test
    void toStringNeverPrintsTheAnswer() {
        RenderedAnswer result = renderer.render("PRIVATE-TEXT");

        assertThat(result.toString()).doesNotContain("PRIVATE-TEXT").contains("RENDERED");
    }
}
