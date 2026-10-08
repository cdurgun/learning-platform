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
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Çerez onayı özelliği AÇIKKEN: banner footer'ı kullanan sayfalarda render edilir, iki
 * dilde metni vardır ve {@code consent.js} hash'li adresle, {@code defer} ile yüklenir.
 * Özelliğin varsayılan (kapalı) hâli {@link SeoBasicsTest}'te doğrulanır.
 */
@SpringBootTest(properties = "app.analytics.consent-enabled=true")
@AutoConfigureMockMvc
@ActiveProfiles("test")
class CookieConsentTest {

    private static final Pattern CONSENT_SCRIPT =
            Pattern.compile("<script defer(?:=\"defer\")? src=\"(/js/consent-[0-9a-f]{32}\\.js)\"></script>");

    @Autowired
    private MockMvc mockMvc;

    @Test
    void bannerIsRenderedHiddenOnPagesThatUseTheFooter() throws Exception {
        for (String path : new String[]{"/en", "/en/topics/enum", "/en/courses/java", "/en/privacy", "/en/login"}) {
            String html = mockMvc.perform(get(path)).andReturn().getResponse().getContentAsString();
            assertThat(html).as(path).containsOnlyOnce("id=\"cookie-consent\"");
            assertThat(html).as(path).containsPattern("<div id=\"cookie-consent\"[^>]*data-nosnippet[^>]*hidden");
            assertThat(html).as(path).contains("data-consent-open");
            assertThat(CONSENT_SCRIPT.matcher(html).find()).as(path + " loads consent.js deferred").isTrue();
        }
    }

    @Test
    void bannerTextIsTranslated() throws Exception {
        String en = mockMvc.perform(get("/en")).andReturn().getResponse().getContentAsString();
        String tr = mockMvc.perform(get("/tr")).andReturn().getResponse().getContentAsString();

        assertThat(en).contains(">Accept<", ">Reject<", ">Settings<", ">Save preferences<", ">Cookie settings<",
                ">Required<", ">Analytics<");
        assertThat(tr).contains(">Kabul Et<", ">Reddet<", ">Ayarlar<", ">Tercihi kaydet<", ">Çerez ayarları<",
                ">Zorunlu<", ">Analitik<");
        assertThat(en).contains("href=\"/en/privacy\"").doesNotContain("??consent.");
        assertThat(tr).contains("href=\"/tr/privacy\"").doesNotContain("??consent.");
    }

    @Test
    void consentScriptIsServedAndLoadsNoAnalytics() throws Exception {
        String html = mockMvc.perform(get("/en")).andReturn().getResponse().getContentAsString();
        Matcher script = CONSENT_SCRIPT.matcher(html);
        assertThat(script.find()).isTrue();

        String js = mockMvc.perform(get(script.group(1)))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();
        assertThat(js).contains("localStorage");
        assertThat(js.toLowerCase()).doesNotContain("gtag", "googletagmanager", "google-analytics", "adsbygoogle");
        assertThat(html.toLowerCase()).doesNotContain("gtag", "googletagmanager", "google-analytics", "adsbygoogle");
    }
}
