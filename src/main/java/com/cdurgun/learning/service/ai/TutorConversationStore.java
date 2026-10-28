package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.config.AiTutorProperties;
import com.cdurgun.learning.config.AiTutorSettings;
import com.cdurgun.learning.domain.Language;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.util.WebUtils;

import java.io.Serial;
import java.io.Serializable;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

/**
 * AI Tutor konuşmalarını HTTP session'da, sınırlı olarak tutar (bkz. plan §9). Veritabanına hiçbir
 * şey yazmaz; bu sınıfta paylaşılan (statik/singleton) konuşma durumu yoktur: her şey çağıranın
 * verdiği {@link HttpSession}'ın tek bir özniteliğindedir, böylece bir session başka birinin
 * geçmişini göremez. Yetkilendirme burada YAPILMAZ (SecurityConfig + {@link AiTutorGuard}).
 *
 * <p><b>Ne eklenebilir:</b> yalnızca tamamlanmış bir tur -- kullanıcının sorusu ile sağlayıcının
 * başarılı {@link TutorCompletion}'ı birlikte, tek adımda ({@link #recordExchange}). Hata alan ya da
 * henüz cevabı gelmemiş bir soru geçmişe hiç girmez; böylece sıra her zaman soru, cevap, soru,
 * cevap olarak kalır.</p>
 *
 * <p><b>Sınırlar</b> ({@code ai.tutor.limits.*}, hepsi karakter -- token DEĞİL):</p>
 * <ul>
 *   <li>soru: {@code max-message-chars}'tan uzunsa ya da boşsa REDDEDİLİR, asla kesilmez;</li>
 *   <li>cevap: {@code max-answer-chars-stored}'dan uzunsa yalnızca geçmişteki kopyası kısaltılır ve
 *       {@link #ANSWER_SHORTENED_MARKER} eklenir (kullanıcıya gösterilen cevap etkilenmez);</li>
 *   <li>konuşma başına en fazla {@code history-turns} tur ve toplam {@code max-history-chars}
 *       karakter: aşılırsa EN ESKİ turlar bütün olarak (soru + cevap) atılır, en yeni tur her zaman
 *       kalır (yapılandırma doğrulaması bir turun sığmasını garanti eder);</li>
 *   <li>session başına en fazla {@code max-conversations-per-session} konuşma: yenisi açılırken en
 *       uzun süredir kullanılmayan atılır.</li>
 * </ul>
 *
 * <p><b>Hata davranışı:</b> yapılandırma geçersizse sınırlar bilinmediği için hiçbir şey saklanmaz
 * ({@link Status#UNAVAILABLE}). Session'daki veri beklenmeyen türde ya da tutarsızsa atılır ve
 * boş geçmişle devam edilir; geçersiz kılınmış session {@link Status#SESSION_INVALID} döner. Log'a
 * yalnızca içeriksiz bir uyarı yazılır.</p>
 */
@Component
public class TutorConversationStore {

    private static final Logger log = LoggerFactory.getLogger(TutorConversationStore.class);

    static final String SESSION_ATTRIBUTE = TutorConversationStore.class.getName() + ".conversations";

    static final String ANSWER_SHORTENED_MARKER = "[answer shortened for history]";

    private final AiTutorProperties.Limits limits;

    public TutorConversationStore(AiTutorSettings settings) {
        this.limits = settings.properties().map(AiTutorProperties::limits).orElse(null);
    }

    public enum Status {
        APPENDED,
        /** Yapılandırma geçersiz: sınırlar bilinmediği için geçmiş tutulmaz. */
        UNAVAILABLE,
        /** Session geçersiz kılınmış (çıkış, zaman aşımı). */
        SESSION_INVALID,
        CONVERSATION_NOT_FOUND,
        MESSAGE_EMPTY,
        MESSAGE_TOO_LONG,
        /** Cevap yok ya da boş: başarılı bir tur sayılmaz, hiçbir şey eklenmez. */
        ANSWER_EMPTY
    }

    /**
     * Tamamlanmış bir tur. Değiştirilemez; {@code toString} içerik değil yalnızca boyut yazar.
     *
     * @param shortenedForHistory cevabın geçmişteki kopyası {@code max-answer-chars-stored}'a kısaltıldı
     * @param cutOffByProvider    sağlayıcı cevabı {@code max_tokens}'ta kesti ({@code finish_reason = length})
     */
    public record Turn(String userMessage, String assistantMessage, boolean shortenedForHistory,
                       boolean cutOffByProvider) implements Serializable {

        @Serial
        private static final long serialVersionUID = 1L;

        public Turn {
            Objects.requireNonNull(userMessage, "userMessage");
            Objects.requireNonNull(assistantMessage, "assistantMessage");
        }

        public int chars() {
            return userMessage.length() + assistantMessage.length();
        }

        @Override
        public String toString() {
            return "Turn[userChars=" + userMessage.length() + ", assistantChars=" + assistantMessage.length()
                    + ", shortenedForHistory=" + shortenedForHistory + ", cutOffByProvider=" + cutOffByProvider + "]";
        }
    }

    /**
     * Bir konuşmanın o anki salt-okunur görüntüsü. {@code turns} değiştirilemez bir listedir;
     * session'daki asıl koleksiyon dışarı hiç verilmez. Ders bağlamı konuşmaya bağlıdır
     * ({@code topicSlug}/{@code language}) ama burada saklanmaz: sınıf yolundaki içerikten her
     * istekte aynı metinle yeniden kurulur ({@link LessonContextBuilder}).
     */
    public record ConversationView(UUID id, String topicSlug, Language language, List<Turn> turns, int historyChars) {

        public ConversationView {
            turns = List.copyOf(turns);
        }

        /** Modele gidecek sırayla: soru, cevap, soru, cevap... */
        public List<TutorPrompt.Message> messages() {
            List<TutorPrompt.Message> messages = new ArrayList<>(turns.size() * 2);
            for (Turn turn : turns) {
                messages.add(new TutorPrompt.Message(TutorPrompt.Role.USER, turn.userMessage()));
                messages.add(new TutorPrompt.Message(TutorPrompt.Role.ASSISTANT, turn.assistantMessage()));
            }
            return List.copyOf(messages);
        }

        @Override
        public String toString() {
            return "ConversationView[id=" + id + ", topicSlug=" + topicSlug + ", language=" + language
                    + ", turns=" + turns.size() + ", historyChars=" + historyChars + "]";
        }
    }

    /** {@code conversation} yalnızca {@link Status#APPENDED} iken dolu. */
    public record AppendResult(Status status, ConversationView conversation, int turnsDropped) {

        static AppendResult refused(Status status) {
            return new AppendResult(status, null, 0);
        }
    }

    // --- API ---

    /**
     * Sağlayıcıya gitmeden ÖNCE çağrılmalı: reddedilecek bir soru için para harcanmasın.
     * Boşsa soru kabul edilebilir; değilse ret nedeni. {@link #recordExchange} aynı kuralı
     * yeniden uygular.
     */
    public Optional<Status> checkUserMessage(String message) {
        if (limits == null) {
            return Optional.of(Status.UNAVAILABLE);
        }
        if (message == null || message.isBlank()) {
            return Optional.of(Status.MESSAGE_EMPTY);
        }
        if (message.length() > limits.maxMessageChars()) {
            return Optional.of(Status.MESSAGE_TOO_LONG);
        }
        return Optional.empty();
    }

    public Optional<ConversationView> find(HttpSession session, UUID conversationId) {
        Objects.requireNonNull(session, "session");
        if (limits == null || conversationId == null) {
            return Optional.empty();
        }
        try {
            synchronized (WebUtils.getSessionMutex(session)) {
                SessionConversations conversations = read(session, false);
                Conversation conversation = conversations == null ? null : conversations.byId.get(conversationId);
                return Optional.ofNullable(conversation).map(Conversation::view);
            }
        } catch (IllegalStateException invalidated) {
            return Optional.empty();
        }
    }

    /**
     * Boş geçmişli yeni bir konuşma açar. Ders bağlamı varsa slug ve dil birlikte verilir;
     * slug'ın gerçek, yayında bir ders olduğu {@link LessonContextBuilder}'ın işidir.
     * Yapılandırma geçersizse ya da session geçersiz kılınmışsa boş.
     */
    public Optional<ConversationView> start(HttpSession session, String topicSlug, Language language) {
        Objects.requireNonNull(session, "session");
        if (topicSlug != null && (topicSlug.isBlank() || language == null)) {
            throw new IllegalArgumentException("a lesson conversation needs a slug and a language");
        }
        if (limits == null) {
            return Optional.empty();
        }
        try {
            synchronized (WebUtils.getSessionMutex(session)) {
                SessionConversations conversations = read(session, true);
                Iterator<UUID> leastRecentlyUsed = conversations.byId.keySet().iterator();
                while (conversations.byId.size() >= limits.maxConversationsPerSession() && leastRecentlyUsed.hasNext()) {
                    leastRecentlyUsed.next();
                    leastRecentlyUsed.remove();
                }
                Conversation conversation = new Conversation(UUID.randomUUID(), topicSlug, language);
                conversations.byId.put(conversation.id, conversation);
                session.setAttribute(SESSION_ATTRIBUTE, conversations);
                return Optional.of(conversation.view());
            }
        } catch (IllegalStateException invalidated) {
            return Optional.empty();
        }
    }

    /**
     * Bir turu (soru + başarılı cevap) sona ekler ve sınırları uygular. Reddedilirse geçmiş
     * değişmez. {@code turnsDropped}: sınır yüzünden atılan eski tur sayısı.
     */
    public AppendResult recordExchange(HttpSession session, UUID conversationId, String userMessage,
                                       TutorCompletion completion) {
        Objects.requireNonNull(session, "session");
        Optional<Status> rejected = checkUserMessage(userMessage);
        if (rejected.isPresent()) {
            return AppendResult.refused(rejected.get());
        }
        if (completion == null || completion.content() == null || completion.content().isBlank()) {
            return AppendResult.refused(Status.ANSWER_EMPTY);
        }
        if (conversationId == null) {
            return AppendResult.refused(Status.CONVERSATION_NOT_FOUND);
        }
        Turn turn = turn(userMessage, completion);
        try {
            synchronized (WebUtils.getSessionMutex(session)) {
                SessionConversations conversations = read(session, false);
                Conversation conversation = conversations == null ? null : conversations.byId.get(conversationId);
                if (conversation == null) {
                    return AppendResult.refused(Status.CONVERSATION_NOT_FOUND);
                }
                int dropped = conversation.append(turn, limits);
                session.setAttribute(SESSION_ATTRIBUTE, conversations);
                return new AppendResult(Status.APPENDED, conversation.view(), dropped);
            }
        } catch (IllegalStateException invalidated) {
            return AppendResult.refused(Status.SESSION_INVALID);
        }
    }

    public boolean delete(HttpSession session, UUID conversationId) {
        Objects.requireNonNull(session, "session");
        if (conversationId == null) {
            return false;
        }
        try {
            synchronized (WebUtils.getSessionMutex(session)) {
                SessionConversations conversations = read(session, false);
                if (conversations == null || conversations.byId.remove(conversationId) == null) {
                    return false;
                }
                session.setAttribute(SESSION_ATTRIBUTE, conversations);
                return true;
            }
        } catch (IllegalStateException invalidated) {
            return false;
        }
    }

    // --- iç yapı ---

    private Turn turn(String userMessage, TutorCompletion completion) {
        String answer = completion.content();
        int max = limits.maxAnswerCharsStored();
        if (answer.length() <= max) {
            return new Turn(userMessage, answer, false, completion.truncated());
        }
        String suffix = "\n\n" + ANSWER_SHORTENED_MARKER;
        int keep = max > suffix.length() ? max - suffix.length() : max;
        // Bir surrogate çiftinin ortasından bölme.
        if (keep > 0 && Character.isHighSurrogate(answer.charAt(keep - 1))) {
            keep--;
        }
        String shortened = max > suffix.length() ? answer.substring(0, keep) + suffix : answer.substring(0, keep);
        return new Turn(userMessage, shortened, true, completion.truncated());
    }

    /**
     * Session'daki kapsayıcı; beklenmeyen tür ya da tutarsız içerik atılır. {@code create} ise
     * yoksa yenisi konur.
     */
    private SessionConversations read(HttpSession session, boolean create) {
        Object value = session.getAttribute(SESSION_ATTRIBUTE);
        if (value instanceof SessionConversations conversations && conversations.isIntact(limits)) {
            return conversations;
        }
        if (value != null) {
            log.warn("AI Tutor conversation data in the session was unreadable ({}); it was discarded",
                    value.getClass().getSimpleName());
            session.removeAttribute(SESSION_ATTRIBUTE);
        }
        if (!create) {
            return null;
        }
        SessionConversations fresh = new SessionConversations();
        session.setAttribute(SESSION_ATTRIBUTE, fresh);
        return fresh;
    }

    /** Session'da duran tek nesne; erişim sırasına göre (en eski kullanılan ilk). */
    static final class SessionConversations implements Serializable {

        @Serial
        private static final long serialVersionUID = 1L;

        private final LinkedHashMap<UUID, Conversation> byId = new LinkedHashMap<>(8, 0.75f, true);

        boolean isIntact(AiTutorProperties.Limits limits) {
            if (byId == null || byId.size() > limits.maxConversationsPerSession()) {
                return false;
            }
            for (Map.Entry<UUID, Conversation> entry : byId.entrySet()) {
                if (entry.getKey() == null || entry.getValue() == null || !entry.getKey().equals(entry.getValue().id)
                        || !entry.getValue().isIntact(limits)) {
                    return false;
                }
            }
            return true;
        }
    }

    static final class Conversation implements Serializable {

        @Serial
        private static final long serialVersionUID = 1L;

        private final UUID id;
        private final String topicSlug;
        private final Language language;
        private final ArrayDeque<Turn> turns = new ArrayDeque<>();
        private int historyChars;

        Conversation(UUID id, String topicSlug, Language language) {
            this.id = id;
            this.topicSlug = topicSlug;
            this.language = language;
        }

        int append(Turn turn, AiTutorProperties.Limits limits) {
            turns.addLast(turn);
            historyChars += turn.chars();
            int dropped = 0;
            while (turns.size() > 1
                    && (turns.size() > limits.historyTurns() || historyChars > limits.maxHistoryChars())) {
                historyChars -= turns.removeFirst().chars();
                dropped++;
            }
            return dropped;
        }

        ConversationView view() {
            return new ConversationView(id, topicSlug, language, List.copyOf(turns), historyChars);
        }

        // Sınırlar yalnızca bu sınıftan geçerek uygulanır; uymayan bir durum dışarıdan gelmiştir.
        boolean isIntact(AiTutorProperties.Limits limits) {
            if (id == null || turns == null || turns.size() > limits.historyTurns()
                    || (topicSlug != null && language == null)) {
                return false;
            }
            long chars = 0;
            for (Turn turn : turns) {
                if (turn == null || turn.userMessage() == null || turn.assistantMessage() == null) {
                    return false;
                }
                chars += turn.chars();
            }
            return chars == historyChars && chars <= limits.maxHistoryChars();
        }
    }
}
