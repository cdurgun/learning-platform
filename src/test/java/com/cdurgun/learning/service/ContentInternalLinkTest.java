package com.cdurgun.learning.service;

import org.commonmark.node.AbstractVisitor;
import org.commonmark.node.Link;
import org.commonmark.node.Node;
import org.commonmark.node.Text;
import org.commonmark.parser.Parser;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Ders içeriğindeki ({@code content/{lang}/*.md}) site içi bağlantıların kuralları -- gerçek
 * yayın verisine karşı. Kurallar:
 * <ol>
 *   <li>Ders bağlantısı yalnızca {@code /{lang}/topics/{slug}} biçiminde, kök-göreli yazılır:
 *       mutlak domain (bkz. {@code app.base-url} kuralı), query parametresi ya da {@code #bölüm}
 *       çapası yok.</li>
 *   <li>Hedefin dili kaynak dosyanın diliyle aynı.</li>
 *   <li>Hedef ders o dilde yayında.</li>
 *   <li>Ders kendisine bağlantı vermez.</li>
 *   <li>Bağlantı metni başka bir bağlantı içermez (çift bağlantı yok) ve tırnaklı atıfta
 *       tırnaklar bağlantının içinde kalır ({@code ["X"](...)}, {@code "[X](...)"} değil) --
 *       {@code content-check}'in tırnaklı atıf kontrolü bu biçime göre çalışır.</li>
 * </ol>
 * Kod bloğu ve satır içi kod CommonMark ağacında bağlantı düğümü üretmez; bunun render
 * tarafı {@link MarkdownInternalLinkRenderTest}'te. Kural denetleyicisi önce örnek EN/TR
 * metinlerle sınanır, sonra tüm içerik üzerinde çalıştırılır.
 */
@SpringBootTest
@ActiveProfiles("test")
class ContentInternalLinkTest {

    private static final Pattern LESSON_LINK = Pattern.compile("^/(en|tr)/topics/([a-z0-9]+(?:-[a-z0-9]+)*)$");
    private static final Pattern LOOKS_LOCAL = Pattern.compile(
            "^(?:https?://(?:www\\.)?learnforgex\\.com)?/?(?:(?:en|tr)/)?topics/|learnforgex\\.com", Pattern.CASE_INSENSITIVE);
    private static final Pattern QUOTES_OUTSIDE_LINK = Pattern.compile("[\"“]\\[[^\\]]*]\\([^)]*\\)[\"”]");

    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private MarkdownService markdownService;

    private final Parser parser = Parser.builder().build();
    private Set<String> published;

    @BeforeEach
    void loadPublishedTranslations() {
        published = new HashSet<>(jdbcTemplate.queryForList("""
                select tt.language || '/' || t.slug
                from topic_translation tt join topic t on t.id = tt.topic_id
                where tt.published = true
                """, String.class));
    }

    // --- Denetleyicinin kendisi: örnek metinlerle -----------------------------------------

    @Test
    void validEnglishAndTurkishLessonLinksPass() {
        assertThat(violations("en", "arrays",
                "See the [\"Stream API Fundamentals\"](/en/topics/stream-fundamentals) lesson.")).isEmpty();
        assertThat(violations("tr", "queues-collections-utility",
                "Bu işlem O(n)'dir (bkz. [\"Lists\"](/tr/topics/lists) dersi).")).isEmpty();
    }

    @Test
    void linkToTheOtherLanguageIsRejected() {
        assertThat(violations("en", "arrays", "See [\"String\"](/tr/topics/string).")).singleElement()
                .asString().contains("dil");
        assertThat(violations("tr", "arrays", "Bkz. [\"String\"](/en/topics/string).")).singleElement()
                .asString().contains("dil");
    }

    @Test
    void linkToAnUnpublishedOrMissingLessonIsRejected() {
        // claude-code-cli-commands'in EN çevirisi taslak; TR'si yayında.
        assertThat(published).contains("tr/claude-code-cli-commands").doesNotContain("en/claude-code-cli-commands");
        assertThat(violations("en", "developing-with-claude-code",
                "See [\"Claude Code CLI Commands\"](/en/topics/claude-code-cli-commands).")).singleElement()
                .asString().contains("yayında değil");
        assertThat(violations("tr", "developing-with-claude-code",
                "Bkz. [\"Claude Code CLI Komutları\"](/tr/topics/claude-code-cli-commands).")).isEmpty();
        assertThat(violations("tr", "arrays", "Bkz. [\"Yok\"](/tr/topics/no-such-lesson).")).singleElement()
                .asString().contains("yayında değil");
    }

    @Test
    void selfLinkIsRejected() {
        assertThat(violations("en", "string", "Back to [\"String\"](/en/topics/string).")).singleElement()
                .asString().contains("kendisine");
    }

    @Test
    void absoluteQueryAndAnchorFormsAreRejected() {
        assertThat(violations("en", "arrays", "[a](https://www.learnforgex.com/en/topics/string)")).singleElement()
                .asString().contains("biçim");
        assertThat(violations("en", "arrays", "[a](/topics/string?lang=en)")).singleElement()
                .asString().contains("biçim");
        assertThat(violations("tr", "arrays", "[a](/tr/topics/string#karşılaştırma)")).singleElement()
                .asString().contains("biçim");
        assertThat(violations("en", "arrays", "[a](https://github.com/cdurgun/react-course-projects)")).isEmpty();
    }

    @Test
    void linkSyntaxInsideCodeIsNotTreatedAsALink() {
        assertThat(violations("en", "arrays", """
                Inline `[x](/tr/topics/string)` and:

                ```
                [y](/en/topics/arrays)
                ```
                """)).isEmpty();
    }

    @Test
    void nestedLinksAndQuotesOutsideTheLinkAreRejected() {
        assertThat(violations("en", "arrays", "[[\"Lists\"](/en/topics/lists)](/en/topics/string)"))
                .anySatisfy(v -> assertThat(v).contains("iç içe"));
        assertThat(violations("tr", "arrays", "Bkz. \"[Lists](/tr/topics/lists)\" dersi.")).singleElement()
                .asString().contains("tırnak");
    }

    // --- Gerçek içerik --------------------------------------------------------------------

    @Test
    void allLessonContentFollowsTheLinkRules() throws IOException {
        List<String> all = new ArrayList<>();
        int files = 0;
        for (String lang : List.of("en", "tr")) {
            for (Resource resource : lessonFiles(lang)) {
                files++;
                String slug = resource.getFilename().replaceFirst("\\.md$", "");
                for (String v : violations(lang, slug, resource.getContentAsString(StandardCharsets.UTF_8))) {
                    all.add(lang + "/" + slug + ": " + v);
                }
            }
        }
        assertThat(files).as("taranan içerik dosyası").isEqualTo(336);
        assertThat(all).isEmpty();
    }

    @Test
    void renderedLessonsContainNoNestedLinks() throws IOException {
        List<String> nested = new ArrayList<>();
        for (String lang : List.of("en", "tr")) {
            for (Resource resource : lessonFiles(lang)) {
                String slug = resource.getFilename().replaceFirst("\\.md$", "");
                String html = markdownService.render(resource.getContentAsString(StandardCharsets.UTF_8), slug).html();
                if (MarkdownInternalLinkRenderTest.hasNestedAnchor(html)) {
                    nested.add(lang + "/" + slug);
                }
            }
        }
        assertThat(nested).isEmpty();
    }

    // --- Denetleyici ----------------------------------------------------------------------

    private List<String> violations(String lang, String sourceSlug, String markdown) {
        List<String> found = new ArrayList<>();
        Matcher quotes = QUOTES_OUTSIDE_LINK.matcher(markdown);
        while (quotes.find()) {
            found.add("tırnaklar bağlantının dışında: " + quotes.group());
        }
        Node document = parser.parse(markdown);
        document.accept(new AbstractVisitor() {
            @Override
            public void visit(Link link) {
                String destination = link.getDestination();
                if (containsLink(link)) {
                    found.add("iç içe bağlantı: " + destination);
                }
                if (LOOKS_LOCAL.matcher(destination).find()) {
                    checkLessonLink(lang, sourceSlug, destination, found);
                }
                visitChildren(link);
            }

            // İç içe yazılmış bağlantıda CommonMark içtekini bağlantı yapar, dıştakinin
            // kalıntısını ("](/en/topics/x)") düz metin bırakır: sayfada bozuk söz dizimi.
            @Override
            public void visit(Text text) {
                if (text.getLiteral().contains("](/")) {
                    found.add("iç içe ya da bozuk bağlantı söz dizimi: " + text.getLiteral().strip());
                }
            }
        });
        return found;
    }

    private void checkLessonLink(String lang, String sourceSlug, String destination, List<String> found) {
        Matcher m = LESSON_LINK.matcher(destination);
        if (!m.matches()) {
            found.add("geçersiz biçim (yalnızca /{lang}/topics/{slug}): " + destination);
            return;
        }
        String targetLang = m.group(1);
        String targetSlug = m.group(2);
        if (!targetLang.equals(lang)) {
            found.add("hedef dil kaynak dilden farklı: " + destination);
        } else if (targetSlug.equals(sourceSlug)) {
            found.add("ders kendisine bağlantı veriyor: " + destination);
        } else if (!published.contains(targetLang + "/" + targetSlug)) {
            found.add("hedef bu dilde yayında değil: " + destination);
        }
    }

    private static boolean containsLink(Node parent) {
        for (Node child = parent.getFirstChild(); child != null; child = child.getNext()) {
            if (child instanceof Link || containsLink(child)) {
                return true;
            }
        }
        return false;
    }

    private static Resource[] lessonFiles(String lang) throws IOException {
        return new PathMatchingResourcePatternResolver().getResources("classpath:content/" + lang + "/*.md");
    }
}
