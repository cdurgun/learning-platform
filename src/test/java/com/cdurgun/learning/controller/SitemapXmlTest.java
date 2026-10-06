package com.cdurgun.learning.controller;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilderFactory;
import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;

/**
 * {@code /sitemap.xml}'in gerçekten geçerli bir XML sitemap olduğunu, metin araması yerine
 * yanıtı namespace-duyarlı bir XML ayrıştırıcıyla okuyarak doğrular. {@code app.base-url}
 * production değerine ayarlanır: adreslerin canlıdaki biçimi ({@code https://www...})
 * burada test edilir.
 *
 * <p>Not: sitemap, her adres için {@code xhtml:link} hreflang alternatifleri içerir. Bu
 * geçerlidir (Google'ın çok dilli sitemap biçimi), ama tarayıcılar XHTML namespace'i gören
 * bir XML'i sayfa gibi çizdiği için dosya tarayıcıda art arda yazılmış düz adresler gibi
 * GÖRÜNÜR. Bu bir görüntüleme etkisidir; yanıtın kendisi aşağıda doğrulanan XML'dir.</p>
 */
@SpringBootTest(properties = "app.base-url=https://www.learnforgex.com")
@AutoConfigureMockMvc
@ActiveProfiles("test")
class SitemapXmlTest {

    private static final String SITEMAP_NS = "http://www.sitemaps.org/schemas/sitemap/0.9";
    private static final String XHTML_NS = "http://www.w3.org/1999/xhtml";
    private static final String BASE = "https://www.learnforgex.com";

    @Autowired
    private MockMvc mockMvc;

    private MockHttpServletResponse fetch() throws Exception {
        return mockMvc.perform(get("/sitemap.xml")).andReturn().getResponse();
    }

    private Document parse(MockHttpServletResponse response) throws Exception {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        // Bozuk (well-formed olmayan) bir yanıt burada SAXException fırlatır ve testi düşürür.
        return factory.newDocumentBuilder()
                .parse(new ByteArrayInputStream(response.getContentAsByteArray()));
    }

    private List<Element> urlElements(Document document) {
        List<Element> urls = new ArrayList<>();
        NodeList children = document.getDocumentElement().getChildNodes();
        for (int i = 0; i < children.getLength(); i++) {
            if (children.item(i).getNodeType() == Node.ELEMENT_NODE) {
                urls.add((Element) children.item(i));
            }
        }
        return urls;
    }

    @Test
    void sitemapIsServedAsXml() throws Exception {
        MockHttpServletResponse response = fetch();

        assertThat(response.getStatus()).isEqualTo(200);
        assertThat(response.getContentType()).startsWith("application/xml");
        assertThat(new String(response.getContentAsByteArray(), StandardCharsets.UTF_8))
                .startsWith("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    }

    @Test
    void rootIsAUrlsetInTheSitemapNamespaceContainingOnlyUrlElements() throws Exception {
        Document document = parse(fetch());
        Element root = document.getDocumentElement();

        assertThat(root.getLocalName()).isEqualTo("urlset");
        assertThat(root.getNamespaceURI()).isEqualTo(SITEMAP_NS);

        List<Element> urls = urlElements(document);
        assertThat(urls).isNotEmpty();
        assertThat(urls).allSatisfy(url -> {
            assertThat(url.getLocalName()).isEqualTo("url");
            assertThat(url.getNamespaceURI()).isEqualTo(SITEMAP_NS);
        });
    }

    @Test
    void everyUrlHasExactlyOneAbsoluteHttpsLoc() throws Exception {
        List<String> locs = new ArrayList<>();
        for (Element url : urlElements(parse(fetch()))) {
            NodeList loc = url.getElementsByTagNameNS(SITEMAP_NS, "loc");
            assertThat(loc.getLength()).as("one <loc> per <url>").isEqualTo(1);
            locs.add(loc.item(0).getTextContent());
        }

        assertThat(locs).allSatisfy(loc -> {
            assertThat(loc).startsWith(BASE + "/");
            assertThat(loc).isEqualTo(loc.strip()).doesNotContain(" ");
        });
        assertThat(new HashSet<>(locs)).as("no duplicate URLs").hasSameSizeAs(locs);
        assertThat(locs).contains(BASE + "/en", BASE + "/tr",
                BASE + "/en/topics/enum", BASE + "/tr/topics/enum", BASE + "/en/courses/java");
    }

    @Test
    void hreflangAlternatesAreWellFormedAndPointToTheSameSite() throws Exception {
        for (Element url : urlElements(parse(fetch()))) {
            NodeList links = url.getElementsByTagNameNS(XHTML_NS, "link");
            assertThat(links.getLength()).as("alternates for " + url.getTextContent().strip()).isGreaterThan(0);
            for (int i = 0; i < links.getLength(); i++) {
                Element link = (Element) links.item(i);
                assertThat(link.getAttribute("rel")).isEqualTo("alternate");
                assertThat(link.getAttribute("hreflang")).isIn("en", "tr", "x-default");
                assertThat(link.getAttribute("href")).startsWith(BASE + "/");
            }
        }
    }
}
