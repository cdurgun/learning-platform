package com.cdurgun.learning.service;

import org.commonmark.Extension;
import org.commonmark.ext.heading.anchor.HeadingAnchorExtension;
import org.commonmark.node.Node;
import org.commonmark.parser.Parser;
import org.commonmark.renderer.html.HtmlRenderer;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
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

    private static final Pattern STRIP_TAGS = Pattern.compile("<[^>]+>");

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
        String withExamples = injectCodeExamples(markdown, topicSlug);
        Node document = parser.parse(withExamples);
        String html = applyCallouts(renderer.render(document));
        return new MarkdownRenderResult(html, extractToc(html));
    }

    private String injectCodeExamples(String markdown, String topicSlug) {
        Matcher matcher = EXAMPLE_PLACEHOLDER.matcher(markdown);
        StringBuilder result = new StringBuilder();
        while (matcher.find()) {
            String exampleName = matcher.group(1);
            String extension = matcher.group(2);
            String code = codeExampleResolver.resolve(topicSlug, exampleName, extension)
                    .orElse("// Örnek bulunamadı: " + exampleName + "." + extension);
            // Fenced code block'un dil etiketi, dosyanın gerçek uzantısından geliyor --
            // "java" için önceki davranışla birebir aynı, "jsx"/"js"/"tsx" için de
            // highlight.js'in ilgili grammar'ını (tam bundle CDN'den yükleniyor) tetikler.
            String replacement = "```" + extension + "\n" + code + "\n```";
            matcher.appendReplacement(result, Matcher.quoteReplacement(replacement));
        }
        matcher.appendTail(result);
        return result.toString();
    }

    private String applyCallouts(String html) {
        String withTips = TIP_BLOCKQUOTE.matcher(html)
                .replaceAll(m -> "<div class=\"alert alert-info\" role=\"alert\">"
                        + "<p class=\"mb-0\">" + m.group(1).strip() + "</p></div>");
        return WARNING_BLOCKQUOTE.matcher(withTips)
                .replaceAll(m -> "<div class=\"alert alert-warning\" role=\"alert\">"
                        + "<p class=\"mb-0\">" + m.group(1).strip() + "</p></div>");
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
    public record TocEntry(String id, String text) {
    }

    /** Render edilmiş HTML ile ondan çıkarılan başlık listesi bir arada. */
    public record MarkdownRenderResult(String html, List<TocEntry> toc) {
    }
}
