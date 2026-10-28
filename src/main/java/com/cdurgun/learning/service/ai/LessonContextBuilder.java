package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.domain.TopicTranslation;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import com.cdurgun.learning.service.CodeExampleResolver;
import com.cdurgun.learning.service.ContentResolver;
import com.cdurgun.learning.service.ExamplePlaceholder;
import org.springframework.stereotype.Service;

import java.io.UncheckedIOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * AI Tutor'a verilecek ders bağlamını YALNIZCA sunucu tarafındaki kaynaklardan kurar (bkz.
 * {@code docs/deepseek-ai-tutor-plan.md} §7). İstemciden ders metni hiçbir zaman alınmaz: girdi
 * yalnızca bir konu slug'ı ve yoldan gelen dildir.
 *
 * <p>Akış: slug DB'de bir {@link Topic} olmalı, o dilde YAYINDA bir {@link TopicTranslation}'ı
 * olmalı; markdown {@link ContentResolver} ile okunur, her {@code {{Ad.uzanti}}}
 * ({@link ExamplePlaceholder}, sayfa render'ıyla aynı desen) o dosyanın kodunu taşıyan bir fenced
 * code block'a çevrilir. "Beklenen Çıktı" ({@code .out}) dosyalarına bakılmaz. Markdown render
 * EDİLMEZ: model ham markdown'ı okur.</p>
 *
 * <p>Sınır ({@code maxContextChars}, Java {@code String} uzunluğu) yalnızca ders gövdesine
 * uygulanır; {@link LessonContext#promptBlock()}'un {@code <lesson>} sınırlayıcıları bunun
 * dışındadır. Sığmazsa sırasıyla: (1) örnek kodları SONDAN başlayarak
 * {@code [example Ad.uzanti omitted]} ile değiştirilir -- baştaki örnekler korunur; (2) bu da
 * yetmezse metnin sonu bir blok sınırından (hiçbir zaman bir code fence'in içinden değil) kesilip
 * {@code [lesson truncated]} eklenir.</p>
 *
 * <p>Her çağrı bir DB sorgu çifti ve sınıf yolu okumaları yapar; aynı örnek dosyası bir derste
 * birden çok geçse de bir kez okunur. Bağlam konuşma başına bir kez kurulup konuşmayla saklanmak
 * içindir (§7.5); bu sınıf kendi önbelleğini tutmaz.</p>
 */
@Service
public class LessonContextBuilder {

    static final String TRUNCATED_MARKER = "[lesson truncated]";

    private static final String BLOCK_SEPARATOR = "\n\n";

    // Tüm gerçek slug'lar bu biçimde (168 slug, en uzunu 42 karakter); uymayan girdi DB'ye gitmez.
    private static final Pattern SLUG = Pattern.compile("[a-z0-9]+(?:-[a-z0-9]+)*");
    private static final int MAX_SLUG_LENGTH = 255;

    private static final Pattern BACKTICK_RUN = Pattern.compile("`+");
    private static final Pattern FENCE_OPEN = Pattern.compile("^[ \\t]*(`{3,}|~{3,})(.*)$");
    private static final Pattern FENCE_CLOSE = Pattern.compile("^[ \\t]*(`{3,}|~{3,})\\s*$");

    private final TopicRepository topicRepository;
    private final TopicTranslationRepository translationRepository;
    private final ContentResolver contentResolver;
    private final CodeExampleResolver codeExampleResolver;

    public LessonContextBuilder(TopicRepository topicRepository,
                                TopicTranslationRepository translationRepository,
                                ContentResolver contentResolver,
                                CodeExampleResolver codeExampleResolver) {
        this.topicRepository = topicRepository;
        this.translationRepository = translationRepository;
        this.contentResolver = contentResolver;
        this.codeExampleResolver = codeExampleResolver;
    }

    public enum Status {
        AVAILABLE,
        /** Slug geçersiz ya da böyle bir konu yok. */
        TOPIC_NOT_FOUND,
        /** Konu var ama bu dilde çevirisi yok ya da taslak. */
        NOT_PUBLISHED,
        /** Çeviri yayında ama {@code content/{lang}/{slug}.md} yok (veri tutarsızlığı). */
        CONTENT_MISSING,
        CONTENT_UNREADABLE,
        /** Dosya var ama boş ya da yalnızca boşluk. */
        CONTENT_EMPTY
    }

    /**
     * @param content           modele gidecek ders gövdesi, {@code maxContextChars}'ı asla aşmaz
     * @param examples          dersteki örnek yer tutucusu sayısı
     * @param examplesOmitted   sınır yüzünden kodu çıkarılan örnek sayısı
     * @param truncated         metnin sonu kesildi mi
     */
    public record LessonContext(String topicSlug,
                                Language language,
                                String title,
                                String content,
                                int examples,
                                int examplesOmitted,
                                boolean truncated) {

        public int contentChars() {
            return content.length();
        }

        /** Sistem isteminde kullanılacak, sınırlayıcılarla sarılmış blok. */
        public String promptBlock() {
            return "<lesson>\n" + content + "\n</lesson>";
        }
    }

    /** {@code status == AVAILABLE} ise ve yalnızca o zaman bir {@code context} vardır. */
    public record Result(Status status, LessonContext context) {

        public Result {
            Objects.requireNonNull(status, "status");
            if ((status == Status.AVAILABLE) != (context != null)) {
                throw new IllegalArgumentException("context must be present exactly when AVAILABLE");
            }
        }

        static Result unavailable(Status status) {
            return new Result(status, null);
        }

        public boolean available() {
            return status == Status.AVAILABLE;
        }
    }

    public Result build(String topicSlug, Language language, int maxContextChars) {
        Objects.requireNonNull(language, "language");
        if (maxContextChars < 0) {
            throw new IllegalArgumentException("maxContextChars must not be negative");
        }
        if (topicSlug == null || topicSlug.length() > MAX_SLUG_LENGTH || !SLUG.matcher(topicSlug).matches()) {
            return Result.unavailable(Status.TOPIC_NOT_FOUND);
        }

        Optional<Topic> topic = topicRepository.findBySlug(topicSlug);
        if (topic.isEmpty()) {
            return Result.unavailable(Status.TOPIC_NOT_FOUND);
        }
        Optional<TopicTranslation> translation = translationRepository
                .findByTopicIdAndLanguage(topic.get().getId(), language)
                .filter(TopicTranslation::isPublished);
        if (translation.isEmpty()) {
            return Result.unavailable(Status.NOT_PUBLISHED);
        }

        // Dosya yolları istemcinin yazdığından değil, DB'deki slug'dan kurulur.
        String slug = topic.get().getSlug();
        Optional<String> markdown;
        try {
            markdown = contentResolver.resolve(slug, language);
        } catch (UncheckedIOException e) {
            return Result.unavailable(Status.CONTENT_UNREADABLE);
        }
        if (markdown.isEmpty()) {
            return Result.unavailable(Status.CONTENT_MISSING);
        }
        if (markdown.get().isBlank()) {
            return Result.unavailable(Status.CONTENT_EMPTY);
        }

        List<Part> parts = parse(markdown.get(), slug);
        return new Result(Status.AVAILABLE, fit(parts, slug, language, translation.get().getTitle(), maxContextChars));
    }

    // --- parçalama ---

    private sealed interface Part permits Text, Example {
    }

    private record Text(String markdown) implements Part {
    }

    /** {@code code == null}: dosya bulunamadı ya da okunamadı. */
    private record Example(String fileName, String extension, String code) implements Part {

        boolean hasCode() {
            return code != null;
        }

        String full() {
            if (code == null) {
                return "[example " + fileName + " unavailable]";
            }
            return codeFence(code, extension);
        }

        String omitted() {
            return "[example " + fileName + " omitted]";
        }
    }

    private List<Part> parse(String markdown, String slug) {
        List<Part> parts = new ArrayList<>();
        Map<String, Optional<String>> resolved = new HashMap<>();
        Matcher matcher = ExamplePlaceholder.PATTERN.matcher(markdown);
        int last = 0;
        while (matcher.find()) {
            parts.add(new Text(markdown.substring(last, matcher.start())));
            String name = matcher.group(ExamplePlaceholder.NAME_GROUP);
            String extension = matcher.group(ExamplePlaceholder.EXTENSION_GROUP);
            Optional<String> code = resolved.computeIfAbsent(name + "." + extension,
                    key -> resolveExample(slug, name, extension));
            parts.add(new Example(name + "." + extension, extension, code.orElse(null)));
            last = matcher.end();
        }
        parts.add(new Text(markdown.substring(last)));
        return parts;
    }

    private Optional<String> resolveExample(String slug, String name, String extension) {
        try {
            return codeExampleResolver.resolve(slug, name, extension);
        } catch (UncheckedIOException e) {
            return Optional.empty();
        }
    }

    // Sayfa render'ı her zaman ``` kullanır; burada kodun içindeki en uzun backtick dizisinden bir
    // uzun çit yazılır ki kod ``` içerse bile blok erken kapanmasın (CommonMark kuralı).
    private static String codeFence(String code, String extension) {
        int longestRun = 0;
        Matcher run = BACKTICK_RUN.matcher(code);
        while (run.find()) {
            longestRun = Math.max(longestRun, run.group().length());
        }
        String fence = "`".repeat(Math.max(3, longestRun + 1));
        return fence + extension + "\n" + code + "\n" + fence;
    }

    // --- sınır ---

    private static LessonContext fit(List<Part> parts, String slug, Language language, String title, int max) {
        int examples = 0;
        long total = 0;
        for (Part part : parts) {
            if (part instanceof Example) {
                examples++;
            }
            total += length(part, false);
        }

        boolean[] omit = new boolean[parts.size()];
        int omitted = 0;
        for (int i = parts.size() - 1; i >= 0 && total > max; i--) {
            // İşaretten kısa bir örneği çıkarmak metni uzatırdı; o örnek yerinde kalır.
            if (parts.get(i) instanceof Example example && example.hasCode()
                    && length(example, true) < length(example, false)) {
                total -= length(example, false) - length(example, true);
                omit[i] = true;
                omitted++;
            }
        }

        StringBuilder content = new StringBuilder();
        for (int i = 0; i < parts.size(); i++) {
            content.append(render(parts.get(i), omit[i]));
        }
        String text = content.toString();
        boolean truncated = text.length() > max;
        if (truncated) {
            text = truncate(text, max);
        }
        return new LessonContext(slug, language, title, text, examples, omitted, truncated);
    }

    private static int length(Part part, boolean omitted) {
        return render(part, omitted).length();
    }

    private static String render(Part part, boolean omitted) {
        return switch (part) {
            case Text text -> text.markdown();
            case Example example -> omitted ? example.omitted() : example.full();
        };
    }

    /**
     * Metni, sonuna {@link #TRUNCATED_MARKER} eklenmiş hâliyle {@code max}'a sığacak şekilde keser.
     * Kesim yalnızca bir satır başında ve hiçbir code fence'in İÇİNDE olmayan bir noktada yapılır;
     * boş satırdan sonraki (paragraf/blok) sınırlar tercih edilir. Hiçbir nokta sığmıyorsa yalnızca
     * işaret kalır; işaret de sığmıyorsa ({@code max} çok küçük) gövde boştur.
     */
    static String truncate(String text, int max) {
        if (max < TRUNCATED_MARKER.length()) {
            return "";
        }
        int bestBlock = 0;
        int bestLine = 0;
        char fenceChar = 0;
        int fenceLength = 0;
        boolean blockBoundary = true;
        int lineStart = 0;
        while (lineStart < text.length()) {
            if (fenceChar == 0) {
                if (!fits(text, lineStart, max)) {
                    break;
                }
                bestLine = lineStart;
                if (blockBoundary) {
                    bestBlock = lineStart;
                }
            }
            int newline = text.indexOf('\n', lineStart);
            int lineEnd = newline < 0 ? text.length() : newline;
            String line = text.substring(lineStart, lineEnd);

            if (fenceChar == 0) {
                Matcher open = FENCE_OPEN.matcher(line);
                if (open.matches() && !(open.group(1).charAt(0) == '`' && open.group(2).indexOf('`') >= 0)) {
                    fenceChar = open.group(1).charAt(0);
                    fenceLength = open.group(1).length();
                    blockBoundary = false;
                } else {
                    blockBoundary = line.isBlank();
                }
            } else {
                Matcher close = FENCE_CLOSE.matcher(line);
                if (close.matches() && close.group(1).charAt(0) == fenceChar
                        && close.group(1).length() >= fenceLength) {
                    fenceChar = 0;
                    blockBoundary = true;
                }
            }
            lineStart = newline < 0 ? text.length() : newline + 1;
        }
        int cut = bestBlock > 0 ? bestBlock : bestLine;
        String kept = text.substring(0, trimmedEnd(text, cut));
        return kept.isEmpty() ? TRUNCATED_MARKER : kept + BLOCK_SEPARATOR + TRUNCATED_MARKER;
    }

    private static boolean fits(String text, int cut, int max) {
        int kept = trimmedEnd(text, cut);
        int length = kept == 0 ? TRUNCATED_MARKER.length()
                : kept + BLOCK_SEPARATOR.length() + TRUNCATED_MARKER.length();
        return length <= max;
    }

    private static int trimmedEnd(String text, int end) {
        while (end > 0 && Character.isWhitespace(text.charAt(end - 1))) {
            end--;
        }
        return end;
    }
}
