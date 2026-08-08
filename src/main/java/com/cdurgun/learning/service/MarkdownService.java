package com.cdurgun.learning.service;

import org.commonmark.node.Node;
import org.commonmark.parser.Parser;
import org.commonmark.renderer.html.HtmlRenderer;
import org.springframework.stereotype.Service;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Markdown -> HTML dönüşüm hattı. Sırasıyla:
 *
 * <ol>
 *   <li><b>Preprocess:</b> {@code {{ExampleName.java}}} yer tutucularını, ilgili konunun
 *       {@code examples/} klasöründeki gerçek dosyasının içeriğiyle, fenced code block
 *       olarak değiştirir.</li>
 *   <li><b>Parse + render:</b> CommonMark ile standart HTML üretir.</li>
 *   <li><b>Callout post-process:</b> {@code > 💡 Tip ...} ve {@code > ⚠️ Warning ...}
 *       kalıbıyla yazılmış blockquote'ları Bootstrap alert kutularına çevirir.</li>
 * </ol>
 *
 * <p><b>Bilinen sınırlama:</b> callout dönüşümü tek paragraflık blockquote'ları destekler
 * (regex tabanlı, basit ve hızlı bir v1). Çok paragraflı / liste içeren callout'lar
 * gerekirse, CommonMark'ın {@code NodeRenderer} genişletme API'siyle daha sağlam bir
 * çözüme geçilebilir — bu, mevcut public API'yi (render metodu) etkilemez.</p>
 */
@Service
public class MarkdownService {

    private static final Pattern EXAMPLE_PLACEHOLDER = Pattern.compile("\\{\\{(\\w+)\\.java}}");

    private static final Pattern TIP_BLOCKQUOTE = Pattern.compile(
            "<blockquote>\\s*<p>\\s*💡\\s*Tip\\s*(.*?)</p>\\s*</blockquote>",
            Pattern.DOTALL);

    private static final Pattern WARNING_BLOCKQUOTE = Pattern.compile(
            "<blockquote>\\s*<p>\\s*(?:⚠️|⚠)\\s*Warning\\s*(.*?)</p>\\s*</blockquote>",
            Pattern.DOTALL);

    private final Parser parser = Parser.builder().build();
    private final HtmlRenderer renderer = HtmlRenderer.builder().build();
    private final CodeExampleResolver codeExampleResolver;

    public MarkdownService(CodeExampleResolver codeExampleResolver) {
        this.codeExampleResolver = codeExampleResolver;
    }

    /**
     * @param markdown  ham markdown metni (henüz işlenmemiş)
     * @param topicSlug {{...}} örneklerini bulmak için hangi konunun examples/ klasörüne
     *                  bakılacağını belirler
     */
    public String render(String markdown, String topicSlug) {
        String withExamples = injectCodeExamples(markdown, topicSlug);
        Node document = parser.parse(withExamples);
        String html = renderer.render(document);
        return applyCallouts(html);
    }

    private String injectCodeExamples(String markdown, String topicSlug) {
        Matcher matcher = EXAMPLE_PLACEHOLDER.matcher(markdown);
        StringBuilder result = new StringBuilder();
        while (matcher.find()) {
            String exampleName = matcher.group(1);
            String code = codeExampleResolver.resolve(topicSlug, exampleName)
                    .orElse("// Örnek bulunamadı: " + exampleName + ".java");
            String replacement = "```java\n" + code + "\n```";
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
}
