package com.cdurgun.learning.service;

import org.commonmark.Extension;
import org.commonmark.ext.heading.anchor.HeadingAnchorExtension;
import org.commonmark.node.Node;
import org.commonmark.parser.Parser;
import org.commonmark.renderer.html.HtmlRenderer;
import org.springframework.stereotype.Service;
import org.springframework.web.util.HtmlUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Markdown -> HTML dönüşüm hattı. Sırasıyla:
 *
 * <ol>
 *   <li><b>Preprocess:</b> {@code {{ExampleName.ext}}} yer tutucularını, ilgili konunun
 *       {@code examples/} klasöründeki gerçek dosyasının içeriğiyle, fenced code block
 *       olarak değiştirir -- uzantı (ör. {@code .java}, {@code .jsx}) serbesttir, hem
 *       dosya yolunu hem üretilen code block'un dil etiketini belirler.</li>
 *   <li><b>Parse + render:</b> CommonMark ile, {@code HeadingAnchorExtension} sayesinde her
 *       başlığa otomatik {@code id} vererek, standart HTML üretir.</li>
 *   <li><b>Beklenen Çıktı:</b> bir {@code .java} örneğinin yanında aynı adlı bir {@code .out}
 *       dosyası varsa (bkz. {@link CodeExampleResolver#resolveOutput}), kod bloğunun hemen
 *       ardına ikinci bir fenced block eklenir; render sonrası bu blok, kod bloğunun kardeşi
 *       olan bir {@code <figure class="code-output">} paneline çevrilir. Kod bloğunun kendi
 *       HTML'i değişmez; {@code .out} dosyası olmayan örnekler için çıktı birebir öncekiyle
 *       aynıdır.</li>
 *   <li><b>Callout post-process:</b> {@code > 💡 Tip ...} ve {@code > ⚠️ Warning ...}
 *       kalıbıyla yazılmış blockquote'ları Bootstrap alert kutularına çevirir.</li>
 *   <li><b>TOC çıkarımı:</b> Üretilen HTML'deki {@code <h2 id="...">} etiketlerini tarayıp
 *       sağdaki "Bu sayfada" navigasyonu için bir (id, başlık) listesi çıkarır — id'ler
 *       burada YENİDEN üretilmiyor, doğrudan render edilmiş HTML'den okunuyor; böylece
 *       TOC linkleri ile gerçek başlık id'leri hiçbir zaman birbirinden sapamaz.</li>
 * </ol>
 *
 * <p><b>Bilinen sınırlama:</b> callout dönüşümü tek paragraflık blockquote'ları destekler
 * (regex tabanlı, basit ve hızlı bir v1). Çok paragraflı / liste içeren callout'lar
 * gerekirse, CommonMark'ın {@code NodeRenderer} genişletme API'siyle daha sağlam bir
 * çözüme geçilebilir — bu, mevcut public API'yi (render metodu) etkilemez.</p>
 */
@Service
public class MarkdownService {

    // Faz 27'ye kadar yalnızca "\\{\\{(\\w+)\\.java}}" idi (uzantı hardcoded). React
    // kategorisi için .jsx (ve gerekirse .js/.tsx) dosyalarını da gömebilmek üzere
    // genelleştirildi: ikinci bir yakalama grubu artık uzantıyı taşıyor ve hem
    // CodeExampleResolver'a hem üretilen fenced code block'un dil etiketine besleniyor.
    // Geriye dönük uyumluluk otomatik: mevcut TÜM içerik zaten "{{Ad.java}}" yazıyor,
    // bu yüzden extension grubu onlar için her zaman "java" olarak çözülüyor ve üretilen
    // çıktı birebir öncekiyle aynı.
    private static final Pattern EXAMPLE_PLACEHOLDER = Pattern.compile("\\{\\{(\\w+)\\.(\\w+)}}");

    private static final Pattern TIP_BLOCKQUOTE = Pattern.compile(
            "<blockquote>\\s*<p>\\s*💡\\s*Tip\\s*(.*?)</p>\\s*</blockquote>",
            Pattern.DOTALL);

    private static final Pattern WARNING_BLOCKQUOTE = Pattern.compile(
            "<blockquote>\\s*<p>\\s*(?:⚠️|⚠)\\s*Warning\\s*(.*?)</p>\\s*</blockquote>",
            Pattern.DOTALL);

    private static final Pattern H2_HEADING = Pattern.compile(
            "<h2[^>]*\\bid=\"([^\"]+)\"[^>]*>(.*?)</h2>",
            Pattern.DOTALL);

    // Çıktı bloğunu markdown'da işaretleyen info string. CommonMark bunu
    // <code class="language-lfx-expected-output"> olarak render eder; aşağıdaki post-process
    // yalnızca bu sınıfı arar. İçerik CommonMark tarafından HTML-escape edilir (<, &, ").
    private static final String EXPECTED_OUTPUT_INFO = "lfx-expected-output";

    private static final Pattern EXPECTED_OUTPUT_BLOCK = Pattern.compile(
            "<pre><code class=\"language-" + EXPECTED_OUTPUT_INFO + "\">(.*?)</code></pre>",
            Pattern.DOTALL);

    private static final Pattern BACKTICK_RUN = Pattern.compile("`+");

    private static final Pattern STRIP_TAGS = Pattern.compile("<[^>]+>");

    private static final Pattern H1_HEADING = Pattern.compile("<h1(\\s[^>]*)?>(.*?)</h1>", Pattern.DOTALL);

    private final List<Extension> extensions = List.of(HeadingAnchorExtension.create());
    private final Parser parser = Parser.builder().extensions(extensions).build();
    private final HtmlRenderer renderer = HtmlRenderer.builder().extensions(extensions).build();
    private final CodeExampleResolver codeExampleResolver;

    public MarkdownService(CodeExampleResolver codeExampleResolver) {
        this.codeExampleResolver = codeExampleResolver;
    }

    /**
     * @param markdown  ham markdown metni (henüz işlenmemiş)
     * @param topicSlug {{...}} örneklerini bulmak için hangi konunun examples/ klasörüne
     *                  bakılacağını belirler
     */
    public MarkdownRenderResult render(String markdown, String topicSlug) {
        return render(markdown, topicSlug, null);
    }

    /**
     * @param expectedOutputLabel çıktı panelinin dile göre başlığı ("Beklenen Çıktı" /
     *                            "Expected Output"); {@code null} ise {@code .out} dosyalarına
     *                            hiç bakılmaz (ör. sabit sayfalar)
     */
    public MarkdownRenderResult render(String markdown, String topicSlug, String expectedOutputLabel) {
        boolean withOutputs = expectedOutputLabel != null;
        String withExamples = injectCodeExamples(markdown, topicSlug, withOutputs);
        Node document = parser.parse(withExamples);
        String html = applyCallouts(renderer.render(document));
        if (withOutputs) {
            html = applyExpectedOutputs(html, expectedOutputLabel);
        }
        return new MarkdownRenderResult(html, extractToc(html));
    }

    private String injectCodeExamples(String markdown, String topicSlug, boolean withOutputs) {
        Matcher matcher = EXAMPLE_PLACEHOLDER.matcher(markdown);
        StringBuilder result = new StringBuilder();
        while (matcher.find()) {
            String exampleName = matcher.group(1);
            String extension = matcher.group(2);
            Optional<String> resolved = codeExampleResolver.resolve(topicSlug, exampleName, extension);
            String code = resolved.orElse("// Örnek bulunamadı: " + exampleName + "." + extension);
            // Fenced code block'un dil etiketi, dosyanın gerçek uzantısından geliyor --
            // "java" için önceki davranışla birebir aynı, "jsx"/"js"/"tsx" için de
            // highlight.js'in ilgili grammar'ını (tam bundle CDN'den yükleniyor) tetikler.
            String replacement = "```" + extension + "\n" + code + "\n```";
            if (withOutputs && resolved.isPresent() && "java".equals(extension)) {
                Optional<String> output = codeExampleResolver.resolveOutput(topicSlug, exampleName);
                if (output.isPresent()) {
                    replacement += "\n" + expectedOutputFence(output.get());
                }
            }
            matcher.appendReplacement(result, Matcher.quoteReplacement(replacement));
        }
        matcher.appendTail(result);
        return result.toString();
    }

    // Çıktının içinde ``` geçse bile bloğu erken kapatmasın diye çit, içerikteki en uzun
    // backtick dizisinden bir uzun yazılır (CommonMark: kapanış çiti en az açılış kadar uzun
    // olmalı). Fenced block içeriği literal kalır: baştaki/sondaki boşluklar, boş satırlar ve
    // tab'lar korunur.
    private static String expectedOutputFence(String output) {
        int longestRun = 0;
        Matcher run = BACKTICK_RUN.matcher(output);
        while (run.find()) {
            longestRun = Math.max(longestRun, run.group().length());
        }
        String fence = "`".repeat(Math.max(3, longestRun + 1));
        return fence + EXPECTED_OUTPUT_INFO + "\n" + output + "\n" + fence;
    }

    // <samp>: program çıktısının anlamsal etiketi. <code> olmadığı için highlight.js
    // (hljs.highlightAll() yalnızca "pre code" seçer) bu bloğa hiç dokunmaz.
    private String applyExpectedOutputs(String html, String label) {
        Matcher matcher = EXPECTED_OUTPUT_BLOCK.matcher(html);
        StringBuilder result = new StringBuilder();
        while (matcher.find()) {
            String replacement = "<figure class=\"code-output\">"
                    + "<figcaption class=\"code-output-label\">" + HtmlUtils.htmlEscape(label, "UTF-8") + "</figcaption>"
                    + "<pre class=\"code-output-body\"><samp>" + matcher.group(1) + "</samp></pre>"
                    + "</figure>";
            matcher.appendReplacement(result, Matcher.quoteReplacement(replacement));
        }
        matcher.appendTail(result);
        return result.toString();
    }

    private String applyCallouts(String html) {
        String withTips = replaceCallouts(TIP_BLOCKQUOTE, html, "alert-info");
        return replaceCallouts(WARNING_BLOCKQUOTE, withTips, "alert-warning");
    }

    // Bilinçli olarak Matcher.replaceAll(Function<MatchResult, String>) KULLANILMIYOR:
    // o overload'un JDK implementasyonu, replacer'ın döndürdüğü metni appendReplacement'a
    // Matcher.quoteReplacement(...) ile SARMADAN geçiriyor. Callout gövdesi (m.group(1))
    // konu yazarının serbestçe yazdığı, kullanıcı içeriğinden gelen bir metin -- ve içinde
    // "${...}" gibi bir alt dize geçerse (ör. bir application.yml örneğinden bahseden
    // "`password: ${ORDERS_DB_PASSWORD}`" cümlesi), appendReplacement bunu regex named-group
    // referansı sanıp parse etmeye çalışıyor; alt tire içeren isimler Java'nın named-group
    // söz dizimine uymadığı için "named capturing group is missing trailing '}'" ile patlıyor
    // (spring-boot-microservice-basics/EN Warning callout'unda canlı olarak yaşandı).
    // injectCodeExamples yukarıda zaten doğru desende: manuel find()/appendReplacement(...,
    // Matcher.quoteReplacement(...))/appendTail() döngüsü. Aynı desen burada da kullanılıyor.
    private String replaceCallouts(Pattern pattern, String html, String alertClass) {
        Matcher matcher = pattern.matcher(html);
        StringBuilder result = new StringBuilder();
        while (matcher.find()) {
            String body = matcher.group(1).strip();
            String replacement = "<div class=\"alert " + alertClass + "\" role=\"alert\">"
                    + "<p class=\"mb-0\">" + body + "</p></div>";
            matcher.appendReplacement(result, Matcher.quoteReplacement(replacement));
        }
        matcher.appendTail(result);
        return result.toString();
    }

    private List<TocEntry> extractToc(String html) {
        List<TocEntry> toc = new ArrayList<>();
        Matcher matcher = H2_HEADING.matcher(html);
        while (matcher.find()) {
            String id = matcher.group(1);
            String text = STRIP_TAGS.matcher(matcher.group(2)).replaceAll("").strip();
            toc.add(new TocEntry(id, text));
        }
        return toc;
    }

    /** Sağdaki "Bu sayfada" navigasyonunda bir satır: çapa id'si ve görünen başlık. */
    /**
     * Web sayfasında başlığı zaten şablonun kendi {@code <h1>}'i veriyor; bazı markdown
     * dosyaları ayrıca kendi {@code # Başlık} satırıyla başladığı için sayfada iki
     * {@code <h1>} oluşuyordu. Markdown'dan geleni, görünümü değiştirmeden (Bootstrap
     * {@code .h1}) başlık olmayan bir öğeye çevirir; id'si (anchor) korunur.
     */
    public static String demoteH1(String html) {
        return H1_HEADING.matcher(html).replaceAll("<p class=\"h1\"$1>$2</p>");
    }

    public record TocEntry(String id, String text) {
    }

    /** Render edilmiş HTML ile ondan çıkarılan başlık listesi bir arada. */
    public record MarkdownRenderResult(String html, List<TocEntry> toc) {
    }
}
