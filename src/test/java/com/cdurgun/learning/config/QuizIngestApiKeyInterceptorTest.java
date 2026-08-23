package com.cdurgun.learning.config;

import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import static org.assertj.core.api.Assertions.assertThat;

class QuizIngestApiKeyInterceptorTest {

    @Test
    void rejectsAllRequestsWhenApiKeyIsNotConfigured() throws Exception {
        QuizIngestApiKeyInterceptor interceptor = new QuizIngestApiKeyInterceptor("");
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("X-Api-Key", "anything");
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean allowed = interceptor.preHandle(request, response, new Object());

        assertThat(allowed).isFalse();
        assertThat(response.getStatus()).isEqualTo(503);
    }

    @Test
    void rejectsMissingApiKeyHeader() throws Exception {
        QuizIngestApiKeyInterceptor interceptor = new QuizIngestApiKeyInterceptor("secret-key");
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean allowed = interceptor.preHandle(request, response, new Object());

        assertThat(allowed).isFalse();
        assertThat(response.getStatus()).isEqualTo(401);
    }

    @Test
    void rejectsWrongApiKeyHeader() throws Exception {
        QuizIngestApiKeyInterceptor interceptor = new QuizIngestApiKeyInterceptor("secret-key");
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("X-Api-Key", "wrong-key");
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean allowed = interceptor.preHandle(request, response, new Object());

        assertThat(allowed).isFalse();
        assertThat(response.getStatus()).isEqualTo(401);
    }

    @Test
    void allowsMatchingApiKeyHeader() throws Exception {
        QuizIngestApiKeyInterceptor interceptor = new QuizIngestApiKeyInterceptor("secret-key");
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("X-Api-Key", "secret-key");
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean allowed = interceptor.preHandle(request, response, new Object());

        assertThat(allowed).isTrue();
    }
}
