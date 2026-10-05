package com.cdurgun.learning.web;

import java.util.Arrays;
import java.util.Optional;

/**
 * Ders olmayan sabit bilgi sayfaları ({@code /{lang}/about} gibi). İçerikleri
 * {@code pages/{lang}/{slug}.md} dosyalarında, başlık/açıklamaları
 * {@code messages*.properties}'de ({@code page.{slug}.title} / {@code .description}).
 *
 * <p>{@code indexable=false}: sayfa yayında ama henüz gerçek içeriği yok -- arama
 * motorlarına {@code noindex} verilir ve sitemap'e eklenmez.</p>
 */
public enum StaticPage {

    ABOUT("about", false),
    CONTACT("contact", true),
    PRIVACY("privacy", true),
    TERMS("terms", true);

    private final String slug;
    private final boolean indexable;

    StaticPage(String slug, boolean indexable) {
        this.slug = slug;
        this.indexable = indexable;
    }

    public String getSlug() {
        return slug;
    }

    public boolean isIndexable() {
        return indexable;
    }

    public static Optional<StaticPage> fromSlug(String slug) {
        return Arrays.stream(values()).filter(page -> page.slug.equals(slug)).findFirst();
    }
}
