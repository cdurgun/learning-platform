package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.config.AiTutorSettings;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.service.ai.AiTutorGuard.DenialReason;
import com.cdurgun.learning.service.ai.AiTutorService.Answered;
import com.cdurgun.learning.service.ai.AiTutorService.ErrorCode;
import com.cdurgun.learning.service.ai.AiTutorService.Question;
import com.cdurgun.learning.service.ai.AiTutorService.Refused;
import com.cdurgun.learning.service.ai.AiTutorService.Result;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.EnumSource;
import org.junit.jupiter.params.provider.MethodSource;
import org.mockito.ArgumentCaptor;
import org.mockito.InOrder;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.function.Supplier;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

/**
 * {@link AiTutorService}'in sırası ve hata eşlemesi. Guard ve ders oluşturucu sahte (bütçe/rezervasyon
 * kuralları {@code AiTutorGuardTest}/{@code AiBudgetEnforcementTest}'te); konuşma deposu ve render
 * gerçek. Sağlayıcı yalnızca bir stub: hiçbir test ağa çıkmaz.
 */
class AiTutorServiceTest {

    private static final Authentication ADMIN = new UsernamePasswordAuthenticationToken("admin@example.com", null, List.of());
    private static final String SLUG = "enum";

    private final AiTutorSettings settings = AiTutorTestSettings.usable();
    private AiTutorGuard guard;
    private LessonContextBuilder lessons;
    private TutorConversationStore store;
    private TutorModelClient client;
    private AiTutorService service;
    private MockHttpSession session;

    @BeforeEach
    void setUp() {
        guard = mock(AiTutorGuard.class);
        lessons = mock(LessonContextBuilder.class);
        store = spy(new TutorConversationStore(settings));
        client = mock(TutorModelClient.class);
        service = new AiTutorService(settings, guard, lessons, store, client, new TutorAnswerRenderer());
        session = new MockHttpSession();

        when(guard.checkAccess(any())).thenReturn(Optional.empty());
        // Gerçek guard gibi: sağlayıcıyı yalnızca burada, rezervasyondan sonra çağırır.
        when(guard.execute(any(), anyInt(), any(), any())).thenAnswer(invocation -> {
            Supplier<TutorCompletion> call = invocation.getArgument(3);
            try {
                return new AiTutorGuard.Completed(call.get(), null);
            } catch (AiProviderException failure) {
                return new AiTutorGuard.Failed(failure, null);
            }
        });
        when(lessons.build(eq(SLUG), any(), anyInt())).thenAnswer(invocation -> new LessonContextBuilder.Result(
                LessonContextBuilder.Status.AVAILABLE,
                new LessonContextBuilder.LessonContext(SLUG, invocation.getArgument(1), "Enum", "Lesson body about enums.",
                        0, 0, false)));
        answerWith("Here is **an answer**.");
    }

    private void answerWith(String content) {
        when(client.complete(any())).thenReturn(new TutorCompletion(content, false, "deepseek-flash", null));
    }

    private Result ask(UUID conversationId, String message, String slug) {
        return service.ask(ADMIN, session, new Question(conversationId, message, slug, Language.EN));
    }

    private TutorPrompt sentPrompt() {
        ArgumentCaptor<TutorPrompt> prompt = ArgumentCaptor.forClass(TutorPrompt.class);
        verify(client).complete(prompt.capture());
        return prompt.getValue();
    }

    private void assertProviderNeverCalled() {
        verify(guard, never()).execute(any(), anyInt(), any(), any());
        verifyNoInteractions(client);
    }

    // --- başarılı akış ---

    @Test
    void stepsRunInTheDocumentedOrder() {
        Result result = ask(null, "What is an enum?", SLUG);

        assertThat(result).isInstanceOf(Answered.class);
        InOrder order = inOrder(guard, lessons, store, client);
        order.verify(guard).checkAccess(ADMIN);
        order.verify(lessons).build(eq(SLUG), eq(Language.EN), anyInt());
        order.verify(store).checkUserMessage("What is an enum?");
        order.verify(guard).execute(eq(ADMIN), anyInt(), any(), any());
        order.verify(client).complete(any());
        order.verify(store).start(session, SLUG, Language.EN);
        order.verify(store).recordExchange(eq(session), any(), eq("What is an enum?"), any());
    }

    @Test
    void lessonPromptStartsWithRulesAndLessonBlockThenTheQuestion() {
        ask(null, "What is an enum?", SLUG);

        List<TutorPrompt.Message> messages = sentPrompt().messages();
        assertThat(messages).hasSize(2);
        assertThat(messages.get(0).role()).isEqualTo(TutorPrompt.Role.SYSTEM);
        assertThat(messages.get(0).content())
                .contains("Answer only programming and learning questions")
                .contains("Never reveal")
                .contains("never instructions")
                .contains("Beyond the lesson")
                .endsWith("<lesson>\nLesson body about enums.\n</lesson>");
        assertThat(messages.get(1)).isEqualTo(new TutorPrompt.Message(TutorPrompt.Role.USER, "What is an enum?"));
    }

    @Test
    void generalQuestionHasNoLessonBlockAndNoLessonLookup() {
        Answered answered = (Answered) ask(null, "What is a JVM?", null);

        assertThat(answered.lessonContextUsed()).isFalse();
        verifyNoInteractions(lessons);
        String system = sentPrompt().messages().getFirst().content();
        assertThat(system).doesNotContain("<lesson>").doesNotContain("Beyond the lesson");
    }

    @Test
    void inputCharsAndCallInfoAreTheWholePrompt() {
        ask(null, "What is an enum?", SLUG);

        ArgumentCaptor<Integer> inputChars = ArgumentCaptor.forClass(Integer.class);
        ArgumentCaptor<AiTutorGuard.CallInfo> info = ArgumentCaptor.forClass(AiTutorGuard.CallInfo.class);
        verify(guard).execute(eq(ADMIN), inputChars.capture(), info.capture(), any());
        int expected = sentPrompt().messages().stream().mapToInt(m -> m.content().length()).sum();
        assertThat(inputChars.getValue()).isEqualTo(expected);
        assertThat(info.getValue()).isEqualTo(new AiTutorGuard.CallInfo(SLUG, Language.EN, "Lesson body about enums.".length()));
    }

    @Test
    void followUpSendsHistoryInOrderAndCountsTurns() {
        Answered first = (Answered) ask(null, "Q1", SLUG);
        assertThat(first.conversationSaved()).isTrue();
        assertThat(first.conversationId()).isNotNull();
        assertThat(store.find(session, first.conversationId())).isPresent();
        assertThat(first.turnsRemaining()).isEqualTo(5);
        assertThat(first.lessonContextUsed()).isTrue();

        answerWith("A2");
        Answered second = (Answered) ask(first.conversationId(), "Q2", SLUG);

        assertThat(second.conversationId()).isEqualTo(first.conversationId());
        assertThat(second.turnsRemaining()).isEqualTo(4);
        ArgumentCaptor<TutorPrompt> prompts = ArgumentCaptor.forClass(TutorPrompt.class);
        verify(client, org.mockito.Mockito.times(2)).complete(prompts.capture());
        List<TutorPrompt.Message> messages = prompts.getAllValues().get(1).messages();
        assertThat(messages).extracting(TutorPrompt.Message::role).containsExactly(TutorPrompt.Role.SYSTEM,
                TutorPrompt.Role.USER, TutorPrompt.Role.ASSISTANT, TutorPrompt.Role.USER);
        assertThat(messages.get(1).content()).isEqualTo("Q1");
        assertThat(messages.get(2).content()).isEqualTo("Here is **an answer**.");
        assertThat(messages.get(3).content()).isEqualTo("Q2");
        // Önek (sistem mesajı) iki istekte aynı: sağlayıcı önbelleği için.
        assertThat(messages.getFirst()).isEqualTo(prompts.getAllValues().get(0).messages().getFirst());
    }

    @Test
    void answerIsRenderedSafelyAndTruncationIsReported() {
        when(client.complete(any())).thenReturn(new TutorCompletion(
                "**bold**\n\n<script>alert(1)</script>\n\n[x](javascript:alert(1))", true, "deepseek-flash", null));

        Answered answered = (Answered) ask(null, "Q", null);

        assertThat(answered.answerHtml()).contains("<strong>bold</strong>").doesNotContain("<script")
                .doesNotContain("javascript:").doesNotContain("href");
        assertThat(answered.truncated()).isTrue();
    }

    @Test
    void answerIsReturnedEvenWhenUsageCouldNotBeRecorded() {
        // Guard sonucu yazamadıysa usageLog null döner; rezervasyon en kötü durumla sayılmaya devam eder.
        Result result = ask(null, "Q", null);

        assertThat(result).isInstanceOf(Answered.class);
    }

    @Test
    void answerIsReturnedWithoutConversationWhenSessionIsInvalidatedDuringTheCall() {
        when(client.complete(any())).thenAnswer(invocation -> {
            session.invalidate();
            return new TutorCompletion("A", false, "deepseek-flash", null);
        });

        Answered answered = (Answered) ask(null, "Q", null);

        assertThat(answered.conversationSaved()).isFalse();
        assertThat(answered.conversationId()).isNull();
        assertThat(answered.answerHtml()).isEqualToIgnoringWhitespace("<p>A</p>");
        assertThat(answered.turnsRemaining()).isZero();
        verify(client, times(1)).complete(any());
    }

    @Test
    void newConversationThatCouldNotBeWrittenIsNotLeftBehind() {
        doReturn(TutorConversationStore.AppendResult.refused(TutorConversationStore.Status.SESSION_INVALID))
                .when(store).recordExchange(any(), any(), any(), any());

        Answered answered = (Answered) ask(null, "Q", null);

        assertThat(answered.conversationSaved()).isFalse();
        assertThat(answered.conversationId()).isNull();
        ArgumentCaptor<UUID> started = ArgumentCaptor.forClass(UUID.class);
        verify(store).delete(eq(session), started.capture());
        assertThat(store.find(session, started.getValue())).isEmpty();
        verify(client, times(1)).complete(any());
    }

    @Test
    void followUpWhoseConversationDisappearedDuringTheCallIsUnsavedButKeepsNothingElse() {
        Answered first = (Answered) ask(null, "Q1", null);
        when(client.complete(any())).thenAnswer(invocation -> {
            store.delete(session, first.conversationId());
            return new TutorCompletion("A2", false, "deepseek-flash", null);
        });

        Answered second = (Answered) ask(first.conversationId(), "Q2", null);

        assertThat(second.conversationSaved()).isFalse();
        assertThat(second.conversationId()).isNull();
        assertThat(second.answerHtml()).contains("A2");
        // Var olan bir konuşma için yeni konuşma açılmaz; soru otomatik olarak yeniden gönderilmez.
        verify(store, times(1)).start(any(), any(), any());
        verify(client, times(2)).complete(any());
    }

    @Test
    void answeredStateIsConsistent() {
        UUID id = UUID.randomUUID();
        assertThatThrownBy(() -> new Answered(null, true, "<p>A</p>", false, false, 5))
                .isInstanceOf(IllegalArgumentException.class);
        assertThatThrownBy(() -> new Answered(id, false, "<p>A</p>", false, false, 0))
                .isInstanceOf(IllegalArgumentException.class);
        assertThatThrownBy(() -> new Answered(null, false, "<p>A</p>", false, false, 3))
                .isInstanceOf(IllegalArgumentException.class);
    }

    // --- sağlayıcıya gitmeden reddedilenler ---

    static Stream<Arguments> accessDenials() {
        return Stream.of(
                Arguments.of(DenialReason.NOT_AUTHENTICATED, ErrorCode.NOT_AUTHENTICATED),
                Arguments.of(DenialReason.FORBIDDEN, ErrorCode.FORBIDDEN),
                Arguments.of(DenialReason.INVALID_CONFIGURATION, ErrorCode.DISABLED),
                Arguments.of(DenialReason.DISABLED, ErrorCode.DISABLED),
                Arguments.of(DenialReason.MISSING_API_KEY, ErrorCode.DISABLED),
                Arguments.of(DenialReason.GUARD_UNAVAILABLE, ErrorCode.SERVICE_UNAVAILABLE));
    }

    @ParameterizedTest
    @MethodSource("accessDenials")
    void accessDenialStopsBeforeAnythingElse(DenialReason reason, ErrorCode expected) {
        when(guard.checkAccess(any())).thenReturn(Optional.of(reason));

        assertThat(ask(null, "Q", SLUG)).isEqualTo(new Refused(expected));
        verifyNoInteractions(lessons);
        verify(store, never()).checkUserMessage(any());
        assertProviderNeverCalled();
    }

    @ParameterizedTest
    @EnumSource(value = LessonContextBuilder.Status.class, names = {"TOPIC_NOT_FOUND", "NOT_PUBLISHED"})
    void unknownOrUnpublishedLessonIsAnInvalidRequest(LessonContextBuilder.Status status) {
        when(lessons.build(eq("draft-topic"), any(), anyInt())).thenReturn(new LessonContextBuilder.Result(status, null));

        assertThat(ask(null, "Q", "draft-topic")).isEqualTo(new Refused(ErrorCode.INVALID_REQUEST));
        assertProviderNeverCalled();
    }

    @ParameterizedTest
    @EnumSource(value = LessonContextBuilder.Status.class, names = {"CONTENT_MISSING", "CONTENT_UNREADABLE", "CONTENT_EMPTY"})
    void unreadableLessonIsOurProblem(LessonContextBuilder.Status status) {
        when(lessons.build(eq("broken"), any(), anyInt())).thenReturn(new LessonContextBuilder.Result(status, null));

        assertThat(ask(null, "Q", "broken")).isEqualTo(new Refused(ErrorCode.SERVICE_UNAVAILABLE));
        assertProviderNeverCalled();
    }

    @Test
    void unknownConversationIsNotFound() {
        assertThat(ask(UUID.randomUUID(), "Q", null)).isEqualTo(new Refused(ErrorCode.CONVERSATION_NOT_FOUND));
        assertProviderNeverCalled();
    }

    @Test
    void conversationOfAnotherSessionIsNotFound() {
        Answered first = (Answered) ask(null, "Q1", null);
        session = new MockHttpSession();

        assertThat(ask(first.conversationId(), "Q2", null)).isEqualTo(new Refused(ErrorCode.CONVERSATION_NOT_FOUND));
    }

    @Test
    void conversationCannotSwitchLessonOrLanguage() {
        Answered lesson = (Answered) ask(null, "Q1", SLUG);

        assertThat(ask(lesson.conversationId(), "Q2", null)).isEqualTo(new Refused(ErrorCode.INVALID_REQUEST));
        assertThat(service.ask(ADMIN, session, new Question(lesson.conversationId(), "Q2", SLUG, Language.TR)))
                .isEqualTo(new Refused(ErrorCode.INVALID_REQUEST));
        verify(client, org.mockito.Mockito.times(1)).complete(any());
    }

    @Test
    void emptyOrTooLongMessageIsRejectedBeforeReservation() {
        String tooLong = "x".repeat(settings.properties().orElseThrow().limits().maxMessageChars() + 1);

        assertThat(ask(null, null, null)).isEqualTo(new Refused(ErrorCode.INVALID_REQUEST));
        assertThat(ask(null, "   ", null)).isEqualTo(new Refused(ErrorCode.INVALID_REQUEST));
        assertThat(ask(null, tooLong, null)).isEqualTo(new Refused(ErrorCode.INVALID_REQUEST));
        assertProviderNeverCalled();
    }

    static Stream<Arguments> guardRejections() {
        return Stream.of(
                Arguments.of(DenialReason.REQUEST_IN_FLIGHT, ErrorCode.RATE_LIMITED),
                Arguments.of(DenialReason.HOURLY_LIMIT_REACHED, ErrorCode.RATE_LIMITED),
                Arguments.of(DenialReason.DAILY_BUDGET_EXHAUSTED, ErrorCode.BUDGET_EXHAUSTED),
                Arguments.of(DenialReason.MONTHLY_BUDGET_EXHAUSTED, ErrorCode.BUDGET_EXHAUSTED),
                Arguments.of(DenialReason.GUARD_UNAVAILABLE, ErrorCode.SERVICE_UNAVAILABLE),
                Arguments.of(DenialReason.DISABLED, ErrorCode.DISABLED));
    }

    @ParameterizedTest
    @MethodSource("guardRejections")
    void reservationRefusalNeverReachesTheProvider(DenialReason reason, ErrorCode expected) {
        doReturn(new AiTutorGuard.Rejected(reason)).when(guard).execute(any(), anyInt(), any(), any());

        assertThat(ask(null, "Q", null)).isEqualTo(new Refused(expected));
        verifyNoInteractions(client);
        assertThat(session.getAttribute(TutorConversationStore.SESSION_ATTRIBUTE)).isNull();
    }

    // --- sağlayıcı hataları ---

    static Stream<Arguments> providerFailures() {
        return Stream.of(
                Arguments.of(AiErrorCategory.DISABLED, ErrorCode.DISABLED),
                Arguments.of(AiErrorCategory.INVALID_REQUEST, ErrorCode.AI_UNAVAILABLE),
                Arguments.of(AiErrorCategory.AUTHENTICATION, ErrorCode.AI_UNAVAILABLE),
                // 402 sağlayıcı hesabının sorunu: uygulamanın bütçe reddinden (budget_exhausted) ayrı.
                Arguments.of(AiErrorCategory.INSUFFICIENT_BALANCE, ErrorCode.AI_UNAVAILABLE),
                Arguments.of(AiErrorCategory.RATE_LIMITED, ErrorCode.AI_BUSY),
                Arguments.of(AiErrorCategory.OVERLOADED, ErrorCode.AI_BUSY),
                Arguments.of(AiErrorCategory.PROVIDER_ERROR, ErrorCode.AI_UNAVAILABLE),
                Arguments.of(AiErrorCategory.TIMEOUT, ErrorCode.AI_TIMEOUT),
                Arguments.of(AiErrorCategory.NETWORK, ErrorCode.AI_UNAVAILABLE),
                Arguments.of(AiErrorCategory.INVALID_RESPONSE, ErrorCode.AI_UNAVAILABLE),
                Arguments.of(AiErrorCategory.CONTENT_FILTERED, ErrorCode.CONTENT_FILTERED));
    }

    @ParameterizedTest
    @MethodSource("providerFailures")
    void providerFailureIsMappedAndNeverEntersHistory(AiErrorCategory category, ErrorCode expected) {
        Answered first = (Answered) ask(null, "Q1", null);
        when(client.complete(any())).thenThrow(new AiProviderException(category, 500));

        assertThat(ask(first.conversationId(), "Q2", null)).isEqualTo(new Refused(expected));
        assertThat(store.find(session, first.conversationId()).orElseThrow().turns()).hasSize(1);
    }

    @Test
    void failedFirstQuestionLeavesNoConversationBehind() {
        when(client.complete(any())).thenThrow(new AiProviderException(AiErrorCategory.TIMEOUT, null));

        assertThat(ask(null, "Q", null)).isEqualTo(new Refused(ErrorCode.AI_TIMEOUT));
        verify(store, never()).start(any(), any(), any());
    }

    @Test
    void unexpectedExceptionFromTheCallIsAGenericError() {
        doThrow(new IllegalStateException("boom")).when(guard).execute(any(), anyInt(), any(), any());

        assertThat(ask(null, "Q", null)).isEqualTo(new Refused(ErrorCode.AI_UNAVAILABLE));
        verify(store, never()).start(any(), any(), any());
    }

    @Test
    void blankAnswerIsAnErrorAndNotStored() {
        answerWith("   ");

        assertThat(ask(null, "Q", null)).isEqualTo(new Refused(ErrorCode.AI_UNAVAILABLE));
        verify(store, never()).start(any(), any(), any());
    }

    // --- silme ---

    @Test
    void deleteRemovesTheConversationOnce() {
        Answered first = (Answered) ask(null, "Q", null);

        assertThat(service.deleteConversation(ADMIN, session, first.conversationId())).isEmpty();
        assertThat(service.deleteConversation(ADMIN, session, first.conversationId()))
                .contains(ErrorCode.CONVERSATION_NOT_FOUND);
    }

    @Test
    void deleteWorksWhileDisabledButNotForNonAdmins() {
        Answered first = (Answered) ask(null, "Q", null);

        when(guard.checkAccess(any())).thenReturn(Optional.of(DenialReason.FORBIDDEN));
        assertThat(service.deleteConversation(ADMIN, session, first.conversationId())).contains(ErrorCode.FORBIDDEN);

        when(guard.checkAccess(any())).thenReturn(Optional.of(DenialReason.DISABLED));
        assertThat(service.deleteConversation(ADMIN, session, first.conversationId())).isEmpty();
    }

    // --- loglar/toString içerik taşımaz ---

    @Test
    void toStringsCarryNoContent() {
        Question question = new Question(null, "secret question text", null, Language.EN);
        Answered answered = new Answered(UUID.randomUUID(), true, "<p>secret answer</p>", false, false, 5);

        assertThat(question.toString()).doesNotContain("secret");
        assertThat(answered.toString()).doesNotContain("secret");
    }
}
