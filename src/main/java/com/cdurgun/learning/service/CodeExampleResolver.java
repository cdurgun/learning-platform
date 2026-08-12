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
}
