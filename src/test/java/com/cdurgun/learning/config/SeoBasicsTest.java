package com.cdurgun.learning.config;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.not;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Arama motorlarını doğrudan etkileyen sayfa/başlık davranışları: statik dosyaların
 * hash'li adres + uzun önbellekle sunulması, konu sayfasında tek {@code <h1>}, ve
 * anasayfanın kendi meta description'ı.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class SeoBasicsTest {

    private static final Pattern HASHED_CSS = Pattern.compile("href=\"(/css/custom-[0-9a-f]{32}\\.css)\"");

    @Autowired
    private MockMvc mockMvc;

    @Test
    void pagesLinkContentHashedStaticFilesServedWithLongLivedCache() throws Exception {
        String html = mockMvc.perform(get("/en")).andReturn().getResponse().getContentAsString();
        Matcher hashedCss = HASHED_CSS.matcher(html);
        assertThat(hashedCss.find()).as("home page links a content-hashed custom.css").isTrue();

        mockMvc.perform(get(hashedCss.group(1)))
                .andExpect(status().isOk())
                .andExpect(header().string("Cache-Control", containsString("max-age=31536000")));
    }

    @Test
    void fixedAddressRootFilesAreNotLongCached() throws Exception {
        mockMvc.perform(get("/robots.txt"))
                .andExpect(status().isOk())
                .andExpect(header().string("Cache-Control", not(containsString("max-age=31536000"))));
    }

    @Test
    void topicPageHasExactlyOneH1() throws Exception {
        // enum.md kendi "# Enum" satırıyla başlar -- şablonun <h1>'iyle çakışmamalı.
        String html = mockMvc.perform(get("/en/topics/enum")).andReturn().getResponse().getContentAsString();
        assertThat(html.split("<h1[ >]", -1).length - 1).isEqualTo(1);
        assertThat(html).contains("<p class=\"h1\" id=\"enum\">");
    }

    @Test
    void staticPagesRenderInBothLanguagesAndAreLinkedFromFooter() throws Exception {
        for (String page : new String[]{"about", "contact", "privacy", "terms"}) {
            mockMvc.perform(get("/en/" + page)).andExpect(status().isOk());
            mockMvc.perform(get("/tr/" + page)).andExpect(status().isOk());
            mockMvc.perform(get("/en")).andExpect(content().string(containsString("href=\"/en/" + page + "\"")));
        }
        mockMvc.perform(get("/tr/privacy"))
                .andExpect(content().string(containsString("<title>Gizlilik Politikası | LearnForgeX</title>")))
                .andExpect(content().string(containsString("mailto:learnforgex@gmail.com")));
        mockMvc.perform(get("/en/imprint")).andExpect(status().isNotFound());
    }

    @Test
    void staticPagesAreIndexableAndListedInSitemap() throws Exception {
        mockMvc.perform(get("/en/about"))
                .andExpect(content().string(not(containsString("noindex"))))
                .andExpect(content().string(containsString("href=\"/en/courses/java\"")));
        mockMvc.perform(get("/tr/about"))
                .andExpect(content().string(not(containsString("noindex"))))
                .andExpect(content().string(containsString("href=\"/tr/contact\"")));
        mockMvc.perform(get("/en/privacy"))
                .andExpect(content().string(not(containsString("noindex"))));
        mockMvc.perform(get("/sitemap.xml"))
                .andExpect(content().string(containsString("/en/privacy</loc>")))
                .andExpect(content().string(containsString("/tr/terms</loc>")))
                .andExpect(content().string(containsString("/en/about</loc>")))
                .andExpect(content().string(containsString("/tr/about</loc>")));
    }

    @Test
    void topicPdfIsNotIndexable() throws Exception {
        mockMvc.perform(get("/en/topics/enum/pdf"))
                .andExpect(status().isOk())
                .andExpect(header().string("X-Robots-Tag", "noindex"));
    }

    @Test
    void homePageHasItsOwnMetaDescription() throws Exception {
        mockMvc.perform(get("/en"))
                .andExpect(content().string(containsString(
                        "<meta name=\"description\" content=\"Free, hands-on lessons in Java, Spring Boot")));
    }
}
