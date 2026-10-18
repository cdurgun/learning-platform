package com.cdurgun.learning.service;

import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.util.Optional;

/**
 * Gerçek, derlenebilir örnek dosyalarını, DB'de yol saklamadan, convention ile bulur:
 * {@code classpath:examples/{topicSlug}/{exampleName}.{extension}}.
 *
 * <p>Faz 27'ye kadar uzantı {@code .java} olarak hardcoded'dı; React kategorisi için
 * {@code .jsx} (ve gerekirse {@code .js}/{@code .tsx}) dosyalarını da aynı convention'la
 * bulabilmek üzere bir parametreye çevrildi. Mevcut tüm çağrılar (bkz. {@link MarkdownService})
 * zaten {@code {{Ad.java}}} yazdığı için davranış Java örnekleri için birebir aynı kalıyor.</p>
 */
@Service
public class CodeExampleResolver {

    private static final String PATH_TEMPLATE = "classpath:examples/%s/%s.%s";

    private final ResourceLoader resourceLoader;

    public CodeExampleResolver(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }

    public Optional<String> resolve(String topicSlug, String exampleName, String extension) {
        String path = PATH_TEMPLATE.formatted(topicSlug, exampleName, extension);
        Resource resource = resourceLoader.getResource(path);
        if (!resource.exists()) {
            return Optional.empty();
        }
        try (var inputStream = resource.getInputStream()) {
            return Optional.of(new String(inputStream.readAllBytes(), StandardCharsets.UTF_8).stripTrailing());
        } catch (IOException e) {
            throw new UncheckedIOException("Örnek dosyası okunamadı: " + path, e);
        }
    }

    /**
     * Bir örneğin "Beklenen Çıktı"sı: aynı klasörde, aynı taban adlı {@code {exampleName}.out}
     * dosyası. Dosya, programın gerçek stdout'unun bayt-bayt kopyasıdır.
     *
     * <p>{@link #resolve}'un aksine burada {@code stripTrailing()} YAPILMAZ: satır sonu
     * boşlukları ve sondaki boş satırlar çıktının parçası olabilir ({@code System.out.print(n + " ")},
     * en sonda bir {@code println()}). Yalnızca TEK bir son {@code \n} düşürülür -- o, son satırın
     * sonlandırıcısıdır, boş bir satır değildir. İçerik bundan sonra boş kalıyorsa (program hiçbir
     * şey basmadıysa) gösterilecek bir çıktı yoktur.</p>
     */
    public Optional<String> resolveOutput(String topicSlug, String exampleName) {
        String path = PATH_TEMPLATE.formatted(topicSlug, exampleName, "out");
        Resource resource = resourceLoader.getResource(path);
        if (!resource.exists()) {
            return Optional.empty();
        }
        try (var inputStream = resource.getInputStream()) {
            String output = new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
            if (output.endsWith("\n")) {
                output = output.substring(0, output.length() - 1);
            }
            return output.isEmpty() ? Optional.empty() : Optional.of(output);
        } catch (IOException e) {
            throw new UncheckedIOException("Çıktı dosyası okunamadı: " + path, e);
        }
    }
}
