package com.cdurgun.learning.web;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * {@link SummaryFormatter}: önce escape, sonra yalnızca ters tırnak çiftleri {@code <code>} olur.
 */
class SummaryFormatterTest {

    @Test
    void backtickPairsBecomeCodeElements() {
        assertThat(SummaryFormatter.toHtml("`String`'s IMMUTABLE design and the `==` vs `equals()` trap"))
                .isEqualTo("<code>String</code>&#39;s IMMUTABLE design and the <code>==</code> vs "
                        + "<code>equals()</code> trap");
    }

    @Test
    void scriptTagIsEscapedNotRendered() {
        assertThat(SummaryFormatter.toHtml("<script>alert(1)</script>"))
                .isEqualTo("&lt;script&gt;alert(1)&lt;/script&gt;");
    }

    @Test
    void htmlInsideACodeSpanIsEscapedToo() {
        assertThat(SummaryFormatter.toHtml("`<img src=x onerror=alert(1)>`"))
                .isEqualTo("<code>&lt;img src=x onerror=alert(1)&gt;</code>");
    }

    @Test
    void quotesCannotBreakOutOfAnAttribute() {
        assertThat(SummaryFormatter.toHtml("\" onmouseover=\"alert(1)"))
                .isEqualTo("&quot; onmouseover=&quot;alert(1)");
    }

    @Test
    void genericTypeParametersStayVisibleAsText() {
        assertThat(SummaryFormatter.toHtml("Predicate<T>, Function<T,R> and `Map<K,V>`"))
                .isEqualTo("Predicate&lt;T&gt;, Function&lt;T,R&gt; and <code>Map&lt;K,V&gt;</code>");
    }

    @Test
    void conflictMarkersAndAmpersandsAreNotTreatedAsMarkup() {
        assertThat(SummaryFormatter.toHtml("markers (<<<<<<<, =======, >>>>>>>) & bounds joined with `&`"))
                .isEqualTo("markers (&lt;&lt;&lt;&lt;&lt;&lt;&lt;, =======, &gt;&gt;&gt;&gt;&gt;&gt;&gt;) "
                        + "&amp; bounds joined with <code>&amp;</code>");
    }

    @Test
    void markdownEmphasisSyntaxIsLeftAlone() {
        assertThat(SummaryFormatter.toHtml("**bold** _x_ # heading"))
                .isEqualTo("**bold** _x_ # heading");
    }

    @Test
    void unmatchedBacktickStaysLiteral() {
        assertThat(SummaryFormatter.toHtml("a `b and `c` d `e"))
                .isEqualTo("a <code>b and </code>c<code> d </code>e");
        assertThat(SummaryFormatter.toHtml("only one ` here")).isEqualTo("only one ` here");
        assertThat(SummaryFormatter.toHtml("empty `` pair")).isEqualTo("empty `` pair");
    }

    @Test
    void turkishLettersAreNotTurnedIntoEntities() {
        assertThat(SummaryFormatter.toHtml("üst sınırlı wildcard, çoğu `Ş` ğ İ ö"))
                .isEqualTo("üst sınırlı wildcard, çoğu <code>Ş</code> ğ İ ö");
    }

    @Test
    void nullAndEmptyRenderAsEmpty() {
        assertThat(SummaryFormatter.toHtml(null)).isEmpty();
        assertThat(SummaryFormatter.toHtml("")).isEmpty();
    }
}
