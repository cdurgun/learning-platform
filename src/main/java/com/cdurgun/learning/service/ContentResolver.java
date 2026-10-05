package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Language;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.util.Optional;

/**
 * Bir konunun Markdown gövde içeriğini, DB'de hiçbir yol saklamadan, salt convention ile bulur:
 * {@code classpath:content/{language}/{topicSlug}.md}.
 *
 * <p>Yarın klasör yapısı değişirse (örn. {@code content/tr/oop/enum.md}) yalnızca bu sınıf
 * güncellenir — controller'lar bundan habersizdir.</p>
 */
@Service
public class ContentResolver {

    private static final String PATH_TEMPLATE = "classpath:content/%s/%s.md";
    private static final String PAGE_PATH_TEMPLATE = "classpath:pages/%s/%s.md";

    private final ResourceLoader resourceLoader;

    public ContentResolver(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }

    public Optional<String> resolve(String topicSlug, Language language) {
        return read(PATH_TEMPLATE.formatted(language.getCode(), topicSlug));
    }

    /** Sabit bilgi sayfaları (bkz. {@code StaticPage}): {@code classpath:pages/{language}/{pageSlug}.md}. */
    public Optional<String> resolvePage(String pageSlug, Language language) {
        return read(PAGE_PATH_TEMPLATE.formatted(language.getCode(), pageSlug));
    }

    private Optional<String> read(String path) {
        Resource resource = resourceLoader.getResource(path);
        if (!resource.exists()) {
            return Optional.empty();
        }
        try (var inputStream = resource.getInputStream()) {
            return Optional.of(new String(inputStream.readAllBytes(), StandardCharsets.UTF_8));
        } catch (IOException e) {
            throw new UncheckedIOException("İçerik dosyası okunamadı: " + path, e);
        }
    }
}
