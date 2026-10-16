package com.cdurgun.learning.service;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * {@link PdfExportService#absolutizeRootRelativeLinks}'in uç durumları. Gerçek PDF'teki bağlantı
 * hedefleri {@code TopicPdfLinkTest}'te; burada yalnızca dönüşüm kuralı sınanır.
 */
class PdfExportServiceLinkTest {

    private static final String LINKS = "<a href=\"/en/topics/string\">&quot;String&quot;</a>"
            + "<a href=\"//cdn.example.com/x.js\">p</a><a href=\"#section\">s</a>"
            + "<a href=\"https://vercel.com\">vercel.com</a>";

    private static Document absolutized(String baseUrl) {
        Document document = Jsoup.parse("<p>" + LINKS + "</p>", baseUrl);
        PdfExportService.absolutizeRootRelativeLinks(document);
        return document;
    }

    @Test
    void rootRelativeLinkBecomesAbsoluteWithoutADoubleSlash() {
        for (String baseUrl : new String[]{"https://www.learnforgex.com", "https://www.learnforgex.com/"}) {
            Document document = absolutized(baseUrl);

            assertThat(document.select("a").eachAttr("href")).as(baseUrl).containsExactly(
                    "https://www.learnforgex.com/en/topics/string", "//cdn.example.com/x.js", "#section",
                    "https://vercel.com");
            assertThat(document.selectFirst("a").text()).isEqualTo("\"String\"");
        }
    }

    @Test
    void unresolvableLinkKeepsItsOriginalHref() {
        // Geçersiz bir taban adreste jsoup adresi çözemez (absUrl boş döner); bağlantı boşalmamalı.
        for (String baseUrl : new String[]{"", "not a url"}) {
            assertThat(absolutized(baseUrl).select("a").eachAttr("href")).as("[" + baseUrl + "]").containsExactly(
                    "/en/topics/string", "//cdn.example.com/x.js", "#section", "https://vercel.com");
        }
    }
}
