package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.config.AiTutorSettings;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.service.ai.TutorConversationStore.AppendResult;
import com.cdurgun.learning.service.ai.TutorConversationStore.ConversationView;
import com.cdurgun.learning.service.ai.TutorConversationStore.Status;
import com.cdurgun.learning.service.ai.TutorConversationStore.Turn;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.boot.test.system.CapturedOutput;
import org.springframework.boot.test.system.OutputCaptureExtension;
import org.springframework.mock.web.MockHttpSession;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * {@link TutorConversationStore}: sıra, sınırlar, eski turların atılması, session izolasyonu,
 * bozuk session verisi ve içeriğin dışarı/loga sızmaması. Yalnızca {@link MockHttpSession}; ne
 * veritabanı ne sağlayıcı.
 */
@ExtendWith(OutputCaptureExtension.class)
class TutorConversationStoreTest {

    /** Küçük sınırlar: soru 10, saklanan cevap 40, 3 tur, toplam 60 karakter, session başına 2 konuşma. */
    private static final String[] SMALL = {"ai.tutor.limits.max-message-chars=10",
            "ai.tutor.limits.max-answer-chars-stored=40", "ai.tutor.limits.history-turns=3",
            "ai.tutor.limits.max-history-chars=60", "ai.tutor.limits.max-conversations-per-session=2"};

    private final TutorConversationStore store = new TutorConversationStore(AiTutorTestSettings.load(SMALL));
    private final MockHttpSession session = new MockHttpSession();

    private static TutorCompletion answer(String content) {
        return new TutorCompletion(content, false, "deepseek-flash", new TutorUsage(0, 1, 1, null));
    }

    private ConversationView started() {
        return store.start(session, null, null).orElseThrow();
    }

    private AppendResult append(UUID id, String question, String answer) {
        return store.recordExchange(session, id, question, answer(answer));
    }

    // --- temel akış ---

    @Test
    void aNewConversationHasNoHistory() {
        ConversationView conversation = store.start(session, "enum", Language.TR).orElseThrow();

        assertThat(conversation.turns()).isEmpty();
        assertThat(conversation.messages()).isEmpty();
        assertThat(conversation.historyChars()).isZero();
        assertThat(conversation.topicSlug()).isEqualTo("enum");
        assertThat(conversation.language()).isEqualTo(Language.TR);
        assertThat(store.find(session, conversation.id())).contains(conversation);
    }

    @Test
    void unknownOrMissingConversationsAreNotFound() {
        assertThat(store.find(session, UUID.randomUUID())).isEmpty();
        assertThat(store.find(session, null)).isEmpty();
        assertThat(session.getAttribute(TutorConversationStore.SESSION_ATTRIBUTE)).isNull();
        assertThat(store.recordExchange(session, UUID.randomUUID(), "q", answer("a")).status())
                .isEqualTo(Status.CONVERSATION_NOT_FOUND);
        assertThat(store.recordExchange(session, null, "q", answer("a")).status())
                .isEqualTo(Status.CONVERSATION_NOT_FOUND);
    }

    @Test
    void turnsKeepQuestionAnswerOrder() {
        UUID id = started().id();
        append(id, "first?", "first answer");
        AppendResult result = append(id, "second?", "second answer");

        assertThat(result.status()).isEqualTo(Status.APPENDED);
        assertThat(result.turnsDropped()).isZero();
        assertThat(result.conversation().messages()).extracting(TutorPrompt.Message::role, TutorPrompt.Message::content)
                .containsExactly(
                        org.assertj.core.groups.Tuple.tuple(TutorPrompt.Role.USER, "first?"),
                        org.assertj.core.groups.Tuple.tuple(TutorPrompt.Role.ASSISTANT, "first answer"),
                        org.assertj.core.groups.Tuple.tuple(TutorPrompt.Role.USER, "second?"),
                        org.assertj.core.groups.Tuple.tuple(TutorPrompt.Role.ASSISTANT, "second answer"));
        assertThat(result.conversation().historyChars()).isEqualTo(6 + 12 + 7 + 13);
        assertThat(store.find(session, id)).contains(result.conversation());
    }

    @Test
    void anEarlierViewIsASnapshotThatDoesNotChange() {
        UUID id = started().id();
        ConversationView before = append(id, "q1", "a1").conversation();

        append(id, "q2", "a2");

        assertThat(before.turns()).hasSize(1);
        assertThat(store.find(session, id).orElseThrow().turns()).hasSize(2);
    }

    // --- sınırlar ---

    @Test
    void theOldestTurnsGoWhenTheTurnLimitIsExceeded() {
        UUID id = started().id();
        append(id, "q1", "a1");
        append(id, "q2", "a2");
        append(id, "q3", "a3");

        AppendResult result = append(id, "q4", "a4");

        assertThat(result.turnsDropped()).isEqualTo(1);
        assertThat(result.conversation().turns()).extracting(Turn::userMessage).containsExactly("q2", "q3", "q4");
        assertThat(result.conversation().historyChars()).isEqualTo(12);
    }

    @Test
    void theOldestTurnsGoWhenTheCharacterLimitIsExceeded() {
        UUID id = started().id();
        append(id, "1234567890", "x".repeat(20)); // 30
        append(id, "abc", "y".repeat(20));        // 53

        AppendResult result = append(id, "def", "z".repeat(10)); // 66 > 60

        assertThat(result.turnsDropped()).isEqualTo(1);
        assertThat(result.conversation().turns()).extracting(Turn::userMessage).containsExactly("abc", "def");
        assertThat(result.conversation().historyChars()).isEqualTo(36).isLessThanOrEqualTo(60);
    }

    @Test
    void aFullSizeTurnPushesOutEverythingOlderButIsItselfKept() {
        UUID id = started().id();
        append(id, "q1", "a1");
        append(id, "q2", "a2");

        AppendResult result = append(id, "1234567890", "x".repeat(40)); // tek başına 50; toplam 58 <= 60

        assertThat(result.turnsDropped()).isZero();
        assertThat(result.conversation().turns()).extracting(Turn::userMessage).containsExactly("q1", "q2", "1234567890");

        AppendResult next = append(id, "0987654321", "y".repeat(40)); // 108: önceki üç tur da gider
        assertThat(next.turnsDropped()).isEqualTo(3);
        assertThat(next.conversation().turns()).extracting(Turn::userMessage).containsExactly("0987654321");
        assertThat(next.conversation().historyChars()).isEqualTo(50);
    }

    @Test
    void aTooLongQuestionIsRefusedNeverCut() {
        UUID id = started().id();
        append(id, "q1", "a1");

        assertThat(store.checkUserMessage("12345678901")).contains(Status.MESSAGE_TOO_LONG);
        assertThat(store.recordExchange(session, id, "12345678901", answer("a")).status())
                .isEqualTo(Status.MESSAGE_TOO_LONG);
        assertThat(store.find(session, id).orElseThrow().turns()).extracting(Turn::userMessage).containsExactly("q1");

        assertThat(store.checkUserMessage("1234567890")).isEmpty(); // tam sınır kabul
    }

    @Test
    void emptyQuestionsAreRefused() {
        UUID id = started().id();
        for (String blank : new String[]{null, "", "   ", "\n\t"}) {
            assertThat(store.checkUserMessage(blank)).contains(Status.MESSAGE_EMPTY);
            assertThat(store.recordExchange(session, id, blank, answer("a")).status()).isEqualTo(Status.MESSAGE_EMPTY);
        }
        assertThat(store.find(session, id).orElseThrow().turns()).isEmpty();
    }

    @Test
    void aMissingOrEmptyAnswerIsNotAFinishedTurn() {
        UUID id = started().id();

        assertThat(store.recordExchange(session, id, "q", null).status()).isEqualTo(Status.ANSWER_EMPTY);
        assertThat(store.recordExchange(session, id, "q", answer(null)).status()).isEqualTo(Status.ANSWER_EMPTY);
        assertThat(store.recordExchange(session, id, "q", answer("  \n")).status()).isEqualTo(Status.ANSWER_EMPTY);
        assertThat(store.find(session, id).orElseThrow().turns()).isEmpty();
    }

    @Test
    void anAnswerCutOffByTheProviderIsKeptAndMarked() {
        UUID id = started().id();

        Turn turn = store.recordExchange(session, id, "q", new TutorCompletion("partial", true, "m", null))
                .conversation().turns().getFirst();

        assertThat(turn.assistantMessage()).isEqualTo("partial");
        assertThat(turn.cutOffByProvider()).isTrue();
        assertThat(turn.shortenedForHistory()).isFalse();
    }

    @Test
    void aLongAnswerIsShortenedOnlyInTheHistoryCopy() {
        UUID id = started().id();
        String full = "A".repeat(39) + "BCDEFG";

        Turn turn = append(id, "q", full).conversation().turns().getFirst();

        assertThat(turn.assistantMessage()).hasSize(40)
                .isEqualTo("A".repeat(8) + "\n\n" + TutorConversationStore.ANSWER_SHORTENED_MARKER);
        assertThat(turn.shortenedForHistory()).isTrue();
        assertThat(append(id, "q", "B".repeat(40)).conversation().turns().getLast().shortenedForHistory()).isFalse();
    }

    @Test
    void shorteningNeverSplitsASurrogatePair() {
        TutorConversationStore tiny = new TutorConversationStore(AiTutorTestSettings.load(
                "ai.tutor.limits.max-answer-chars-stored=5", "ai.tutor.limits.max-history-chars=4005"));
        UUID id = tiny.start(session, null, null).orElseThrow().id();

        Turn turn = tiny.recordExchange(session, id, "q", answer("abcd😀xyz")).conversation().turns().getFirst();

        assertThat(turn.assistantMessage()).isEqualTo("abcd"); // işaret sığmıyor, emoji yarım bırakılmıyor
        assertThat(turn.shortenedForHistory()).isTrue();
    }

    @Test
    void theLeastRecentlyUsedConversationIsDroppedWhenTheSessionIsFull() {
        UUID first = started().id();
        UUID second = started().id();
        store.find(session, first); // first artık en son kullanılan

        UUID third = started().id();

        assertThat(store.find(session, second)).isEmpty();
        assertThat(store.find(session, first)).isPresent();
        assertThat(store.find(session, third)).isPresent();
    }

    @Test
    void conversationsCanBeDeleted() {
        UUID id = started().id();

        assertThat(store.delete(session, id)).isTrue();
        assertThat(store.find(session, id)).isEmpty();
        assertThat(store.delete(session, id)).isFalse();
        assertThat(store.delete(session, null)).isFalse();
    }

    @Test
    void aLessonConversationNeedsALanguage() {
        assertThatThrownBy(() -> store.start(session, "enum", null)).isInstanceOf(IllegalArgumentException.class);
        assertThatThrownBy(() -> store.start(session, " ", Language.EN)).isInstanceOf(IllegalArgumentException.class);
    }

    // --- izolasyon ---

    @Test
    void sessionsNeverSeeEachOthersConversations() {
        MockHttpSession other = new MockHttpSession();
        UUID mine = started().id();
        append(mine, "secret q", "secret a");
        UUID theirs = store.start(other, null, null).orElseThrow().id();

        assertThat(store.find(other, mine)).isEmpty();
        assertThat(store.recordExchange(other, mine, "q", answer("a")).status()).isEqualTo(Status.CONVERSATION_NOT_FOUND);
        assertThat(store.delete(other, mine)).isFalse();
        assertThat(store.find(session, theirs)).isEmpty();
        assertThat(store.find(session, mine).orElseThrow().turns()).hasSize(1);
        assertThat(other.getAttribute(TutorConversationStore.SESSION_ATTRIBUTE))
                .isNotSameAs(session.getAttribute(TutorConversationStore.SESSION_ATTRIBUTE));
    }

    @Test
    void theStoreHoldsNoConversationStateOfItsOwn() {
        for (Field field : TutorConversationStore.class.getDeclaredFields()) {
            if (Modifier.isStatic(field.getModifiers())) {
                assertThat(Modifier.isFinal(field.getModifiers())).as(field.getName()).isTrue();
                assertThat(field.getType()).as(field.getName()).isIn(String.class, org.slf4j.Logger.class);
            } else {
                assertThat(field.getName()).isEqualTo("limits");
            }
        }
    }

    // --- dışarıdan değiştirme ---

    @Test
    void returnedHistoryCannotModifyTheSession() {
        UUID id = started().id();
        ConversationView view = append(id, "q1", "a1").conversation();

        assertThatThrownBy(() -> view.turns().clear()).isInstanceOf(UnsupportedOperationException.class);
        assertThatThrownBy(() -> view.turns().add(new Turn("x", "y", false, false)))
                .isInstanceOf(UnsupportedOperationException.class);
        assertThatThrownBy(() -> view.messages().clear()).isInstanceOf(UnsupportedOperationException.class);

        List<Turn> mutable = new ArrayList<>(view.turns());
        ConversationView copy = new ConversationView(id, null, null, mutable, 0);
        mutable.clear();
        assertThat(copy.turns()).hasSize(1);
        assertThat(store.find(session, id).orElseThrow().turns()).hasSize(1);
    }

    // --- bozuk ya da eksik session verisi ---

    @Test
    void unexpectedSessionDataIsDiscardedAndTheTutorKeepsWorking(CapturedOutput output) {
        session.setAttribute(TutorConversationStore.SESSION_ATTRIBUTE, "not a conversation map");

        assertThat(store.find(session, UUID.randomUUID())).isEmpty();
        assertThat(session.getAttribute(TutorConversationStore.SESSION_ATTRIBUTE)).isNull();
        UUID id = started().id();
        assertThat(append(id, "q", "a").status()).isEqualTo(Status.APPENDED);
        assertThat(output).contains("was unreadable (String)").doesNotContain("not a conversation map");
    }

    @Test
    void historyThatBreaksTheCurrentLimitsIsDiscarded() {
        // Daha geniş sınırlarla yazılmış bir session (ör. yapılandırma değişti): 4 tur.
        TutorConversationStore wide = new TutorConversationStore(AiTutorTestSettings.load());
        UUID id = wide.start(session, null, null).orElseThrow().id();
        for (int i = 0; i < 4; i++) {
            wide.recordExchange(session, id, "q" + i, answer("a" + i));
        }

        assertThat(store.find(session, id)).isEmpty();
        assertThat(session.getAttribute(TutorConversationStore.SESSION_ATTRIBUTE)).isNull();
    }

    @Test
    void anInvalidatedSessionIsReportedNotThrown() {
        UUID id = started().id();
        session.invalidate();

        assertThat(store.find(session, id)).isEmpty();
        assertThat(store.start(session, null, null)).isEmpty();
        assertThat(store.recordExchange(session, id, "q", answer("a")).status()).isEqualTo(Status.SESSION_INVALID);
        assertThat(store.delete(session, id)).isFalse();
    }

    @Test
    void sessionContentsSurviveSerialization() throws Exception {
        UUID id = started().id();
        append(id, "q1", "a1");

        ByteArrayOutputStream bytes = new ByteArrayOutputStream();
        try (ObjectOutputStream out = new ObjectOutputStream(bytes)) {
            out.writeObject(session.getAttribute(TutorConversationStore.SESSION_ATTRIBUTE));
        }
        MockHttpSession restored = new MockHttpSession();
        try (ObjectInputStream in = new ObjectInputStream(new ByteArrayInputStream(bytes.toByteArray()))) {
            restored.setAttribute(TutorConversationStore.SESSION_ATTRIBUTE, in.readObject());
        }

        assertThat(store.find(restored, id).orElseThrow().messages()).hasSize(2);
    }

    // --- yapılandırma ---

    @Test
    void withoutValidLimitsNothingIsStored() {
        AiTutorSettings invalid = AiTutorTestSettings.load("ai.tutor.limits.history-turns=0");
        assertThat(invalid.isValid()).isFalse();
        TutorConversationStore unavailable = new TutorConversationStore(invalid);

        assertThat(unavailable.start(session, null, null)).isEmpty();
        assertThat(unavailable.find(session, UUID.randomUUID())).isEmpty();
        assertThat(unavailable.checkUserMessage("q")).contains(Status.UNAVAILABLE);
        assertThat(unavailable.recordExchange(session, UUID.randomUUID(), "q", answer("a")).status())
                .isEqualTo(Status.UNAVAILABLE);
        assertThat(session.getAttribute(TutorConversationStore.SESSION_ATTRIBUTE)).isNull();
    }

    @Test
    void theHistoryLimitMustHoldOneFullTurn() {
        AiTutorSettings tooSmall = AiTutorTestSettings.load("ai.tutor.limits.max-history-chars=11999");
        AiTutorSettings justEnough = AiTutorTestSettings.load("ai.tutor.limits.max-history-chars=12000");

        assertThat(tooSmall.isValid()).isFalse();
        assertThat(tooSmall.problems()).anyMatch(p -> p.contains("max-history-chars must hold at least one full turn"));
        assertThat(justEnough.isValid()).isTrue();
    }

    @Test
    void theDefaultsComeFromApplicationYml() {
        var limits = AiTutorTestSettings.load().properties().orElseThrow().limits();
        assertThat(limits.maxHistoryChars()).isEqualTo(24000);
        assertThat(limits.historyTurns()).isEqualTo(6);
        assertThat(limits.maxConversationsPerSession()).isEqualTo(5);
        assertThat(limits.maxAnswerCharsStored()).isEqualTo(8000);
        assertThat(limits.maxMessageChars()).isEqualTo(4000);
    }

    // --- içerik dışarı sızmaz ---

    @Test
    void contentNeverAppearsInLogsOrToString(CapturedOutput output) {
        UUID id = started().id();
        ConversationView view = append(id, "QSECRET", "ASECRET-ANSWER").conversation();
        store.recordExchange(session, id, "TOOLONGSECRET", answer("x"));
        session.setAttribute(TutorConversationStore.SESSION_ATTRIBUTE, List.of("LISTSECRET"));
        store.find(session, id);

        assertThat(view.toString()).doesNotContain("QSECRET", "ASECRET");
        assertThat(view.turns().getFirst().toString()).doesNotContain("QSECRET", "ASECRET")
                .contains("userChars=7", "assistantChars=14");
        assertThat(new AppendResult(Status.APPENDED, view, 0).toString()).doesNotContain("QSECRET", "ASECRET");
        assertThat(output).doesNotContain("QSECRET", "ASECRET", "TOOLONGSECRET", "LISTSECRET");
    }

    // --- aynı session'da eşzamanlı istekler ---

    @Test
    void concurrentAppendsInOneSessionKeepTheHistoryConsistent() throws Exception {
        TutorConversationStore wide = new TutorConversationStore(AiTutorTestSettings.load());
        UUID id = wide.start(session, null, null).orElseThrow().id();
        ExecutorService pool = Executors.newFixedThreadPool(8);
        CountDownLatch start = new CountDownLatch(1);
        try {
            List<Future<AppendResult>> futures = new ArrayList<>();
            for (int i = 0; i < 64; i++) {
                String n = String.valueOf(i);
                futures.add(pool.submit(() -> {
                    start.await();
                    return wide.recordExchange(session, id, "q" + n, answer("a" + n));
                }));
            }
            start.countDown();
            for (Future<AppendResult> future : futures) {
                assertThat(future.get(30, TimeUnit.SECONDS).status()).isEqualTo(Status.APPENDED);
            }
        } finally {
            pool.shutdownNow();
        }

        ConversationView view = wide.find(session, id).orElseThrow();
        assertThat(view.turns()).hasSize(6);
        assertThat(view.historyChars()).isEqualTo(view.turns().stream().mapToInt(Turn::chars).sum());
        assertThat(view.turns()).allSatisfy(turn ->
                assertThat(turn.assistantMessage()).isEqualTo("a" + turn.userMessage().substring(1)));
    }
}
