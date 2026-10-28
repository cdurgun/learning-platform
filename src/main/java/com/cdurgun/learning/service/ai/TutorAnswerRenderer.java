package com.cdurgun.learning.service.ai;

import org.commonmark.node.AbstractVisitor;
import org.commonmark.node.Image;
import org.commonmark.node.Link;
import org.commonmark.node.Node;
import org.commonmark.parser.Parser;
import org.commonmark.renderer.html.HtmlRenderer;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.safety.Cleaner;
import org.jsoup.safety.Safelist;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.util.HtmlUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.function.UnaryOperator;
import java.util.regex.Pattern;

/**
 * AI Tutor cevabını (GÜVENİLMEYEN model çıktısı) güvenli HTML'e çevirir (bkz. plan §11).
 * Ders sayfalarının {@code MarkdownService}'i BİLİNÇLİ OLARAK kullanılmaz: o, repo'daki içeriğe
 * güvenir (ham HTML'i geçirir) ve {@code {{Ad.java}}} yer tutucularını dosya içeriğiyle genişletir;
 * model çıktısında ikisi de istenmez. İki yol hiçbir kodu paylaşmaz.
 *
 * <p><b>Katmanlar</b> (her biri tek başına da güvenli olmayı hedefler, regex ile temizlik YOK):</p>
 * <ol>
 *   <li><b>CommonMark</b> (yalnızca çekirdek, eklenti yok -- tablo yok): {@code escapeHtml(true)}
 *       ile modelin yazdığı her ham HTML metin olarak kaçışlanır; {@code sanitizeUrls(true)}.
 *       Görseller bağlantıya çevrilir: modelin seçtiği bir adresten tarayıcı kendiliğinden hiçbir
 *       şey yüklemez.</li>
 *   <li><b>jsoup {@link Safelist}</b>: yalnızca {@link #SAFELIST}'teki etiketler ve öznitelikler
 *       kalır, gerisi DOM seviyesinde atılır.</li>
 *   <li><b>Bağlantı izin listesi</b> (bizim kuralımız, CommonMark/jsoup'a bırakılmaz): yalnızca
 *       {@code https://}, {@code http://}, kök-göreli {@code /yol} ve {@code #parça}. Boşluk/kontrol
 *       karakteri içeren, {@code //} ile başlayan ya da başka bir şemaya sahip ({@code javascript:},
 *       {@code data:}, {@code vbscript:}, {@code mailto:}, ...) her adresin bağlantısı kaldırılır,
 *       metni kalır. Kalan bağlantılara {@code rel="nofollow noopener noreferrer"} eklenir.</li>
 *   <li><b>Son doğrulama</b>: çıktı yeniden {@link Cleaner#isValidBodyHtml} ile denetlenir; geçmezse
 *       render başarısız sayılır.</li>
 * </ol>
 *
 * <p>Başlıklar iki seviye aşağı kaydırılır ({@code #} -> {@code h3}, en fazla {@code h6}): cevap,
 * kendi {@code h1}'i olan bir sayfanın içinde gösterilir. Kod blokları metin olarak kalır; dil
 * sınıfı ({@code language-java}) yalnızca güvenli karakterlerden oluşuyorsa korunur.</p>
 *
 * <p><b>Gösterim:</b> yalnızca {@link RenderedAnswer#html()} değeri HTML olarak basılabilir
 * (Thymeleaf'te {@code th:utext}, JavaScript'te {@code innerHTML}); modelin ham metni HİÇBİR ZAMAN
 * {@code th:utext}/{@code innerHTML} ile basılmaz ({@code th:text}/{@code textContent} kullanılır).
 * Temizlik sunucuda yapıldığı için güvenlik tarayıcıya bırakılmaz.</p>
 *
 * <p>Hiçbir şey loglanmaz; yalnızca beklenmeyen bir hatada istisnanın sınıf adı.</p>
 */
@Component
public class TutorAnswerRenderer {

    private static final Logger log = LoggerFactory.getLogger(TutorAnswerRenderer.class);

    /**
     * Bundan uzun bir cevap markdown olarak ayrıştırılmaz, kaçışlanmış düz metin olarak döner.
     * {@code max-output-tokens} (en fazla 8192) ile böyle bir cevap gerçekte beklenmez; sınır,
     * ayrıştırıcıyı olağan dışı büyük girdiye karşı korur. Metin atılmaz.
     */
    static final int MAX_MARKDOWN_CHARS = 64_000;

    static final String LINK_REL = "nofollow noopener noreferrer";

    static final Safelist SAFELIST = new Safelist()
            .addTags("p", "br", "hr", "h3", "h4", "h5", "h6", "strong", "em", "code", "pre",
                    "blockquote", "ul", "ol", "li", "a")
            .addAttributes("a", "href", "rel")
            .addAttributes("code", "class")
            .addAttributes("ol", "start");

    private static final Pattern CODE_LANGUAGE_CLASS = Pattern.compile("language-[A-Za-z0-9_+#.-]{1,32}");
    private static final Pattern SAFE_ABSOLUTE = Pattern.compile("(?i)https?://[^/\\\\].*");
    private static final Pattern URL_SCHEME = Pattern.compile("^[A-Za-z][A-Za-z0-9+.-]*:");

    private final UnaryOperator<String> markdownToHtml;

    public TutorAnswerRenderer() {
        Parser parser = Parser.builder().build();
        HtmlRenderer renderer = HtmlRenderer.builder().escapeHtml(true).sanitizeUrls(true).build();
        this.markdownToHtml = markdown -> {
            Node document = parser.parse(markdown);
            ImagesToLinks images = new ImagesToLinks();
            document.accept(images);
            images.replaceAll();
            return renderer.render(document);
        };
    }

    /** Testler için: markdown aşamasının hata verdiği durumu kurmak üzere. */
    TutorAnswerRenderer(UnaryOperator<String> markdownToHtml) {
        this.markdownToHtml = markdownToHtml;
    }

    public enum Status {
        RENDERED,
        /** Cevap yok ya da yalnızca boşluk: {@code html} boş. */
        EMPTY,
        /** {@link #MAX_MARKDOWN_CHARS}'tan uzun: markdown işlenmedi, tamamı kaçışlanmış düz metin. */
        PLAIN_TEXT_TOO_LONG,
        /** Render başarısız oldu: tamamı kaçışlanmış düz metin, asla ham HTML. */
        PLAIN_TEXT_AFTER_ERROR
    }

    /** {@code toString} yalnızca uzunluk yazar, içerik değil. */
    public record RenderedAnswer(Status status, String html) {

        @Override
        public String toString() {
            return "RenderedAnswer[status=" + status + ", htmlChars=" + html.length() + "]";
        }
    }

    public RenderedAnswer render(String answer) {
        if (answer == null || answer.isBlank()) {
            return new RenderedAnswer(Status.EMPTY, "");
        }
        if (answer.length() > MAX_MARKDOWN_CHARS) {
            return new RenderedAnswer(Status.PLAIN_TEXT_TOO_LONG, plainText(answer));
        }
        try {
            return new RenderedAnswer(Status.RENDERED, sanitize(markdownToHtml.apply(answer)));
        } catch (RuntimeException e) {
            log.warn("AI Tutor answer could not be rendered ({}); shown as escaped plain text",
                    e.getClass().getSimpleName());
            return new RenderedAnswer(Status.PLAIN_TEXT_AFTER_ERROR, plainText(answer));
        }
    }

    private static String sanitize(String unsafeHtml) {
        Document dirty = Jsoup.parseBodyFragment(unsafeHtml);
        demoteHeadings(dirty);
        Document clean = new Cleaner(SAFELIST).clean(dirty);
        clean.outputSettings().prettyPrint(false);

        for (Element link : clean.select("a")) {
            String href = link.attr("href");
            if (isAllowedHref(href)) {
                link.attr("rel", LINK_REL);
            } else {
                link.unwrap();
            }
        }
        for (Element code : clean.select("code[class]")) {
            if (!CODE_LANGUAGE_CLASS.matcher(code.attr("class")).matches()) {
                code.removeAttr("class");
            }
        }

        String html = clean.body().html();
        if (!new Cleaner(SAFELIST).isValidBodyHtml(html)) {
            throw new IllegalStateException("sanitized answer failed validation");
        }
        return html;
    }

    // jsoup Safelist yalnızca h3-h6'ya izin verir; temizlikten ÖNCE kaydırılır ki başlık atılmasın.
    private static void demoteHeadings(Document document) {
        for (Element heading : document.select("h1, h2, h3, h4, h5, h6")) {
            int level = heading.tagName().charAt(1) - '0';
            heading.tagName("h" + Math.min(6, level + 2));
        }
    }

    /**
     * Kendi izin listemiz. Boşluk ve kontrol karakterleri reddedilir: tarayıcılar onları adresten
     * silerek {@code java\tscript:} gibi bir değeri yeniden {@code javascript:} yapabilir.
     */
    static boolean isAllowedHref(String href) {
        if (href == null || href.isEmpty()) {
            return false;
        }
        for (int i = 0; i < href.length(); i++) {
            char c = href.charAt(i);
            if (c <= 0x20 || c == 0x7F || Character.isWhitespace(c) || Character.isSpaceChar(c)
                    || Character.isISOControl(c) || Character.getType(c) == Character.FORMAT) {
                return false;
            }
        }
        if (href.startsWith("#")) {
            return true;
        }
        if (href.startsWith("/")) {
            // "//host" ve "/\host" başka bir siteye götürür; kök-göreli sayılmaz.
            return href.length() == 1 || (href.charAt(1) != '/' && href.charAt(1) != '\\');
        }
        if (URL_SCHEME.matcher(href).find()) {
            String lower = href.toLowerCase(Locale.ROOT);
            return (lower.startsWith("https://") || lower.startsWith("http://")) && SAFE_ABSOLUTE.matcher(href).matches();
        }
        return false;
    }

    private static String plainText(String answer) {
        return "<pre>" + HtmlUtils.htmlEscape(answer, "UTF-8") + "</pre>";
    }

    /** {@code ![alt](url)} -> {@code [alt](url)}: model çıktısındaki bir adres kendiliğinden yüklenmez. */
    private static final class ImagesToLinks extends AbstractVisitor {

        private final List<Image> images = new ArrayList<>();

        @Override
        public void visit(Image image) {
            images.add(image);
            visitChildren(image);
        }

        /** Gezinme bittikten sonra çağrılır: gezinirken ağaç değiştirilmez. */
        void replaceAll() {
            for (Image image : images) {
                Link link = new Link(image.getDestination(), image.getTitle());
                Node child = image.getFirstChild();
                while (child != null) {
                    Node next = child.getNext();
                    link.appendChild(child);
                    child = next;
                }
                image.insertBefore(link);
                image.unlink();
            }
        }
    }
}
