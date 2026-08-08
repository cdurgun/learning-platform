package com.cdurgun.learning.service;

import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.util.Optional;

/**
 * Gerçek, derlenebilir Java örnek dosyalarını, DB'de yol saklamadan, convention ile bulur:
 * {@code classpath:examples/{topicSlug}/{exampleName}.java}.
 */
@Service
public class CodeExampleResolver {

    private static final String PATH_TEMPLATE = "classpath:examples/%s/%s.java";

    private final ResourceLoader resourceLoader;

    public CodeExampleResolver(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }

    public Optional<String> resolve(String topicSlug, String exampleName) {
        String path = PATH_TEMPLATE.formatted(topicSlug, exampleName);
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
